# 404error

서버 내부에서 생긴 문제가 아니라 시작부터 잘못된 URL을 호출하게 되면 404 (Not Found) 예외가 발생하면서 톰캣이 보내는 메시지를 보게 된다.

![404](https://github.com/whochucompany/ByteClone-BE/assets/96435200/13d3b13e-03d3-4fcc-974e-6e4d467722a7)

# @ResponseStatus

@ControllerAdvice에 작성하는 메소드에 @ResponseStatus를 이용하면 404 상태에 맞는
화면을 별도로 작성할 수 있다.

<img width="394" alt="customErrorPage" src="https://github.com/whochucompany/ByteClone-BE/assets/96435200/4a882223-39a2-4e60-b2a2-a46481bf6ad9">

그리고 WEB-INF/views/todo 폴더에 custom404.jsp 파일을 만든다

<img width="524" alt="Custom404ErrorPage" src="https://github.com/whochucompany/ByteClone-BE/assets/96435200/ffa37970-7af9-4530-8a04-2211b6edd725">

이후 web.xml에서는 DispatcherServlet의 설정을 조정해야 한다.
< servlet 태그 내에 < init-param 을 추가하고 throwExceptionIfNoHandlerFound라는
파라미터 설정을 추가한다.

<img width="679" alt="throwExceptionIfNoHandlerFound" src="https://github.com/whochucompany/ByteClone-BE/assets/96435200/014fc0b2-fafd-4c79-b075-5de4004d8e7d">

![404CustomPage](https://github.com/whochucompany/ByteClone-BE/assets/96435200/9706a067-40e6-4bac-b0ca-b373d26ac72b)

