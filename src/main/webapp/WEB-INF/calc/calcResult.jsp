<%--
  Created by IntelliJ IDEA.
  User: rio
  Date: 2023/05/17
  Time: 11:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
  <!--
  '\${}' 로 처리된 부분이 존재하는데 이 부분은 JSP 에서 사용하는 EL 이라는 기술로,
  간단히 말해 서버에서 데이터를 출력하는 용도로 웹에서 System.out.println() 과 유사한 역할을 한다고 생각하면 된다.

  EL 을 이용할 때는 param 이라는 이름의 지정된 객체를 이용해서 현재 요청에 전달된 파라미터를 쉽게 추출할 수 있다.
  <form> 태그에서 num1 이라는 이름의 전송된 데이터는 \${param.num1}} 과 같은 형태로 간편하게 사용할 수 있다.
  -->

  <h1>Param ${param}</h1>
  <h1>NUM1 ${param.num1}</h1> <!-- 다만 이렇게 전달되는 데이터는 모두 문자열로 처리되기 때문에 정수형을 원하면 Integer.ParseInt()를 적용-->
  <h1>NUM2 ${param.num2}</h1>

  <h1>NUM3 ${Integer.parseInt(param.num3)}</h1> <!-- 다만 Integer.parseInt()에서 오류 발생 -->

  <!--
    따라서 JSP 는
    1. JSP 에서 쿼리스트링이나 파라미터를 처리하지 않는다. - JSP 대신에 서블릿을 통해서 처리
    2. JSP 는 입력 화면을 구성하거나 처리 결과를 보여주는 용도로만 사용한다.
    3. 브라우저는 직접 JSP 경로를 호출하지 않고 서블릿 경로를 통해서 JSP 를 보는 방식으로 사용
  -->
</body>
</html>
