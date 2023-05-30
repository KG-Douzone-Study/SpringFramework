
```txt
스프링 MVC가 기존 구조에 약간의 변화를 주는 부분은 다음과 같다.

- Front-Controller 패턴을 이용해서 모든 흐름의 사전/사후 처리를 가능하도록 설계된 점
- 어노테이션을 적극적으로 활용해서 최소한의 코드로 많은 처리가 가능하도록 설계된 점
- HttpServletRequest / HttpServletResponse 를 이용하지 않아도 될 만큼 추상화된 방식으로 개발
```

![springMVC](https://github.com/whochucompany/ByteClone-BE/assets/96435200/699b480f-90f3-4bbc-ba94-daf22b2876d8)

```txt
스프링 MVC에서 가장 중요한 사실은 모든 요청(Request)이 반드시 DispatcherServlet 이라는 존재를
통해서 실행된다는 점이다.

DispathcerServlet == Front-Controller

Front-Controller 패턴을 이용하면 모든 요청이 반드시 하나의 객체 (Front-Controller)를 지나서
처리되기 때문에 모든 공통적인 처리를 프론트 컨트롤러에서 처리할 수 있게 된다.
```

```txt
Front-Controller 가 사전/사후 처리를 하게 되면 중간에 매번 다른 처리를 하는 부분만 별도로 처리하는
구조를 만들게 된다.

스프링 MVC에서는 이를 컨트롤러라고 하는데 어노테이션 @Controller 를 이용해서 처리하게 된다.
```

---

**Spring MVC가 내부적으로 어떻게 요청을 처리하는지 글로 설명하기**

1. 클라이언트가 요청을 서버에 전송하면, DispatcherServlet이라는 클래스에게 요청이 전달된다.
   ( DispatcherServlet 은 기본적으로 생성되는 Class이다. 나중에 공부해서 더 깊게 파보자.)
   
2. DispatcherServlet은 클라이언트 요청을 처리할 Controller에 대한 검색을 HandlerMapping
   인터페이스에게 요청한다.
   
3. HandlerMapping은 요청에 해당하는 컨트롤러를 찾고 해당 컨트롤러 정보를 다시 DispatcherServlet
   에게 응답한다.

4. 요청을 처리할 Controller를 찾았으면 DispatcherServlet이 HandlerAdapter를 가지고 온다.
   
5. 그리고 HandlerAdapter 객체의 메소드를 실행한다.

6. HandlerAdapter 객체의 메소드로 실행된 Controller 객체는 비지니스 로직을 처리하고,
   결과(데이터, view name)를 ModelAndView 객체에 저장하여 전달한다.

7. DispatcherServlet은 view name을 View Resolver에게 전달하여 View 객체를 얻는다.
   
8. DispatcherServlet은 View 객체에 화면 표시를 요청한다.

9. View 객체는 해당하는 뷰를 호출하며, 뷰는 Model 객체에서 화면 표시에 필요한 객체를 가져와
   화면 표시를 처리한다.
   
---

## 스프링 MVC 컨트롤러

```txt
스프링 MVC 컨트롤러는 전통적인 자바의 클래스 구현 방식과 여러모로 상당히 다르다.
과거의 많은 프레임워크들은 상속이나 인터페이스를 기반으로 구현되는 방식을 선호했다면
스프링 MVC의 컨트롤러들은 다음과 같은 점들이 다르다.

1. 상속이나 인터페이스를 구현하는 방식을 사용하지 않고 어노테이션만으로 처리가 가능
2. 오버라이드 없이 필요한 메소드들을 정의
3. 메소드의 파라미터를 기본 자료형이나 객체 자료형을 마음대로 지정
4. 메소드의 리턴타입도 void, String, 객체 등 다양한 타입을 사용할 수 있음.
```

### servlet-context.xml 의 component-scan

```txt
Controller 클래스들을 스프링으로 인식하기 위해서는 해당 Controller 클래스가 들어있는 패키지를
스캔해서 @Controller 어노테이션 정확히는 @Component 어노테이션이 추가된 클래스들의 객체들을
스프링의 빈으로 설정되게 만들어야 한다.
```

```xml
<!-- servlet-context.xml -->

<context:component-scan base-package="org.zerock.springex.controller"/>
```

### @RequestMapping 와 파생 어노테이션들

```txt
스프링 컨트롤러에서 가장 많이 사용하는 어노테이션은 @RequestMapping 이다.
@RequestMapping은 말 그대로 '특정한 경로의 요청(Request)'을 지정하기 위해서 사용한다.

@RequestMapping은 컨트롤러 클래스의 선언부에도 사용할 수 있고, 컨트롤러의 메소드에서도 사용할 수 있다
```

### 스프링 MVC에서 주로 사용하는 어노테이션들

```txt
- 컨트롤러 선언부에 사용하는 어노테이션
	- @Controller : 스프링 빈의 처리됨을 명시
	- @RestController : REST 방식의 처리를 위한 컨트롤러임을 명시 (문자열, JSON 반환)
	- @RequestMapping : 특정한 URL 패턴에 맞는 컨트롤러인지를 명시

- 메소드 선언부에 사용하는 어노테이션
	- @GetMapping
	- @PostMapping
	- @DeleteMapping
	- @PutMapping
		- > HTTP 전송 방식에 따라 해당 메소드를 지정하는 경우에 사용.

	- @RequestMapping : GET / POST 방식 모두를 지원하는 경우에 사용
	- @ResponeBody : REST 방식에서 사용

- 메소드의 파라미터에 사용하는 어노테이션
	- @RequestParam : Request에 있는 특정한 이름의 데이터를 파라미터로 받아서 처리하는 경우
	- @PathVariable : URL 경로의 일부를 변수로 삼아서 처리하기 위해서 사용
	- @ModelAttribute : 해당 파라미터는 반드시 Model에 포함되어서 다시 뷰로 전달됨을 명시
	- @SessionAttribute, @Valid, @RequestBody
```

### Formatter를 이용한 파라미터의 커스텀 처리

```txt
기본적으로 HTTP는 문자열로 데이터를 전달하기 때문에 컨트롤러는 문자열을 기준으로 특정한 클래스의 객체로
처리하는 작업이 진행된다.

이때 개발에서 가장 문제가 되는 타입이 바로 날짜 관련 타입이다.

이런 경우 특정한 날짜를 처리하는 Formatter라는 것을 이용할 수 있다.
Formatter는 말 그대로 문자열을 포맷을 이용해서 특정한 개체로 변환하는 경우에 사용한다.

예를 들어 코드를 작성해보자.
```

```java
package org.zerock.springex.controller.formatter;  
  
import org.springframework.format.Formatter;  
  
import java.text.ParseException;  
import java.time.LocalDate;  
import java.time.format.DateTimeFormatter;  
import java.util.Locale;  
  
public class LocalDateFormatter implements Formatter<LocalDate> {  
  
@Override  
public LocalDate parse(String text, Locale locale) throws ParseException {  
	return LocalDate.parse(text, DateTimeFormatter.ofPattern("yyyy-MM-dd"));  
	}  
  
@Override  
public String print(LocalDate object, Locale locale) {  
	return DateTimeFormatter.ofPattern("yyyy-MM-dd").format(object);  
	}  
}
```

```txt
만들어진 Formatter를 servlet-context.xml에 적용하기 위해서는 조금 복잡한 과정이 필요하다.
```

```xml
<!-- servlet-context.xml -->

<mvc:annotation-driven conversion-service="conversionService" />

<bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">  
<property name="formatters">  
<set>  
<bean class="org.zerock.springex.controller.formatter.LocalDateFormatter"/>  
</set>  
</property>  
</bean>
```

