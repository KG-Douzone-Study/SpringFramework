# ControllerAdvice

스프링 MVC의 컨트롤러에서 발생하는 예외를 처리하는 가장 일반적인 방식은 @ControllerAdvice를 이용하는 것이다.

@ControllerAdvice는 컨트롤러에서 발생하는 예외에 맞게 처리할 수 있는 기능을 제공하는데
@ControllerAdvice가 선언된 클래스 역시 스프링의 빈(bean)으로 처리된다.

<img width="303" alt="controllerAdvice" src="https://github.com/whochucompany/ByteClone-BE/assets/96435200/5562c26f-98c2-4da1-ba87-0768f17c7171">


---

# ExceptionHandler

@ControllerAdvice의 메소드들에는 특별하게 @ExceptionHandler라는 어노테이션을 사용할 수 있다.
이를 통해서 전달되는 Exception 객체들을 지정하고 메소드의 파라미터에서는 이를 이용할 수 있다.

<img width="770" alt="ExceptionHandler" src="https://github.com/whochucompany/ByteClone-BE/assets/96435200/c981b03b-6fe2-4dfe-91ba-74956e842bb7">

추가된 exceptNumber() 메서드에는 @ExceptionHandler가 지정되어 있고,
NumberFormatException.class 로 타입을 지정해주고 있다.

때문에 @ExceptionHandler를 가진 모든 메소드는 해당 타입의 예외를 파라미터로 전달 받을 수 있다.

지금의 exceptNumber()는 @ResponseBody를 이용해서 만들어진 "NUMBER FORMAT EXCEPTION"을
그대로 브라우저에 전송하는 방식이다.

- @ResponseBody는 REST 방식에서 문자열이나 JSON 데이터를 그대로 전송할 때 사용되는 어노테이션이다.

![NumberForamtError](https://github.com/whochucompany/ByteClone-BE/assets/96435200/a22f2538-38fe-4653-aa71-d2f186dbd9f2)
---

# 범용적인 예외처리

개발을 하다보면 어디선가 문제가 발생하고 이를 자세한 메시지로 확인하고 싶은 경우가 많다.
이를 위해서 예외 처리의 상위 타입인 Exception 타입을 처리하도록 구성하면 다음과 같이 작성할 수 있다.

<img width="638" alt="AllException" src="https://github.com/whochucompany/ByteClone-BE/assets/96435200/cc2c282d-bc30-4049-84f0-c46f396f74c8">

exceptCommon()은 Exception.class 타입을 처리하기 때문에 사실상 거의 모든 예외를 처리하는 용도로
사용할 수 있다.

개발시에는 에러 메시지가 많이 나오는 것이 좋기에 디버깅용으로 만들어두고
실제로 배포시에는 별도의 에러페이지를 만들어 배포해야 한다.

---

