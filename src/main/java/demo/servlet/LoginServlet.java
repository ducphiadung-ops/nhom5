package demo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = {
        "/login/dang_nhap",
        "/login/dang_ky"
})

public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if(uri.contains("/login/dang_nhap")){
            this.dang_nhap(req,resp);
        }
        if(uri.contains("/login/dang_ky")){
            this.dang_ky(req,resp);
        }
    }

    private void dang_ky(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/demo/login/dang_ky.jsp").forward(req,resp);

    }

    private void dang_nhap(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if(uri.contains("/login/dang_nhap")){
            this.dang_nhap(req,resp);
        }
        if(uri.contains("/login/dang_ky")){
            this.dang_ky(req,resp);
        }
    }
}
