package org.zerock.w1.calc;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "inputController", urlPatterns = "/calc/input")
public class InputController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        System.out.println("InputController...doGet...");

        RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/calc/input.jsp");

        dispatcher.forward(req, resp);

        /*
        InputController 의 경우 가장 핵심적인 코드는 RequestDispatcher 라는 존재를 이용해서 forward() 를 실행하는 부분이다.
        RequestDispatcher 라는 존재는 말 그대로 서블릿에 전달된 요청을 다른 쪽으로 전달 혹은 배포하는 역할을 하는 객체이다.

        /WEB-INF 밑에 존재하는 jsp 파일을 둔다는 의미는 브라우저에서 jsp 로 직접 호출이 불가능하다는 것을 의미한다.
         */
    }
}
