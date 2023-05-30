
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

수정 중



