
# Spring Custom Exception

보통 Spring 5버전 이상에서 전역으로 공통 Exception 처리는
ResponseStatusException을 일반적으로 사용해서 처리했었는데

ResponseStatusException은 생성자로 HTTP Status 와 String 만을 받게 된다.
따라서 범용적인 Exception 처리가 어렵기 때문에 중복된 응답을 줄 수 없고,
오타로 인해 실수할 가능성도 생기게 된다.

![스크린샷 2023-06-08 오후 1 34 23](https://github.com/ParkRio/ParkRio/assets/96435200/794d3093-9f52-4d39-a2be-166cd9ddd82b)

---

위와 같은 이유로 Spring Exception 처리를 조금 다른 방법으로 처리해보자.

```txt
앞으로 사용할 클래스

- ErrorCode : 핵심클래스 -> 모든 예외 케이스를 이곳에서 관리한다.
- CustomException : 기본적으로 제공되는 Exception 외에 사용
- ErrorResponse : 사용자에게 JSON 형식으로 보여주기 위해 에러 응답 형식을 지정
- GlobalExceptionHandler : Custom Exception Handler
	- @Controller 
```

## ErrorCode (enum class)

```java
@Getter
@AllArgsConstructor
public enum ErrorCode {

	/* 404 NOT_FOUND */
	PAGE_NOT_FOUND(HttpStatus.NOT_FOUND, "페이지를 찾을 수 없습니다.");

	private final HttpStatus httpStatus;
	private final String detail;
	
}
```

- 에러 형식을 Enum 클래스로 정의한다.
- 응답으로 내보낼 HttpStatus 와 에러 메시지로 사용할 String 을 가지고 있다.
- ResponseStatusException 과 비슷해 보인다. 하지만 큰 차이점은 개발자가 정의한 새로운 Exception 을 모두 한 곳에서 관리하고 재사용 할 수 있다는 점이다.


## CustomException

```java
/**
* 일반 예외로 선언할 경우 Exception을 상속받아 구현하면 되고
* 실행 예외로 선언할 경우에는 RuntimeException을 상속받아 구현하면 된다.
*/
@Getter
@AllArgsConstructor
public class CustomException extends RuntimeException {

	private final ErrorCode errorCode;
}
```

- 전역으로 사용할 CustomException 이다.
- RuntimeException 을 상속받아서 Unchecked Exception 으로 활용한다.
- 생성자로 ErrorCode 를 받는다.


## ErrorResponse

```java
@Getter
@Builder

public class ErrorResponse {

private final LocalDateTime timestmap = LocalDateTime._now_();
private final int status;
private final String error;
private final String code;
private final String message;

public static ResponseEntity<ErrorResponse> toResponseEntity(ErrorCode errorCode){

return ResponseEntity
		.status(errorCode.getHttpStatus())
			.body(ErrorResponse.builder()
			.status(errorCode.getHttpStatus().value())
			.error(errorCode.getHttpStatus().name())
			.code(errorCode.name())
			.message(errorCode.getDetail())
			.build()
		);

	}
}
```

- 실제로 유저에게 보낼 응답 Format 이다.
- 일부러 에러 났을 때와 형식을 맞췄다. status, code 값은 사실 없어도 된다.
- ErrorCode 를 받아서 ResponseEntity< ErrorResponse > 로 변환해준다.

---

## @ControllerAdvice and @ExceptionHandler

- @ControllerAdvice 는 프로젝트 전역에서 발생하는 모든 예외를 잡아준다.
- @ExceptionHandler 는 발생한 특정 예외를 잡아서 하나의 메소드에서 공통 처리해줄 수 있게 해준다.
- 따라서 둘을 같이 사용하면 모든 예외를 잡은 후에 Exception 종류별로 메소드를 공통 처리할 수 있다.

- ResponseEntityExceptionHandler 란?
  Spring MVC에서 발생할 수 있는 예외들에 대해 미리 Handling을 해놓은 클래스이다.
  예를 들어, NoHandlerFoundException이 발생하면 ResponseEntityExceptionHandler의
  handleNoHandlerFoundException 메서드가 exception을 처리하게 된다.

```java
@Log4j2
//@RestControllerAdvice
@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

  @ExceptionHandler(value = {CustomException.class})

public ResponseEntity<ErrorResponse> handleCustomException(CustomException e) {
log.error("handleCustomException throw CustomException : {}", e.getErrorCode());
return ErrorResponse._toResponseEntity_(e.getErrorCode());
		}

}
```


## Test

```java
//@ResponseBody
@GetMapping("/custom")
public void testCustomException2() {

log.error("custom exception check");
throw new CustomException(ErrorCode.PAGE_NOT_FOUND);

/**
* 혹시 json type으로 변환하지 못한다는 Error가 온다면 maven repository에서 jackson-Databind 를 pom.xml에 넣어주자.
* 또 LocalDateTime을 변환하지 못한다는 error가 나온다면 error 내용에 따라 jackson-datatype-jsr310 같은 것도 pom.xml에 넣어주자.
*/

}
```

<img width="288" alt="스크린샷 2023-06-08 오후 3 37 51" src="https://github.com/ParkRio/ParkRio/assets/96435200/cdfcc5b5-767c-4134-bb01-ceb588f12625">
