package demo.servlet;

import demo.Service.nhanvien.NhanVienService;
import demo.entity.nhan_vien.NhanVien;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = {
        "/login/dang_nhap",
        "/login/dang_ky"
})
public class LoginServlet extends HttpServlet {

    private final NhanVienService nhanVienService = new NhanVienService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/login/dang_nhap")) {
            // Nếu đã đăng nhập thì chuyển về trang chính
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("nhanVien") != null) {
                resp.sendRedirect(req.getContextPath() + "/tong_quan");
                return;
            }
            req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req, resp);
        } else if (uri.contains("/login/dang_ky")) {
            req.getRequestDispatcher("/demo/login/dang_ky.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/login/dang_nhap")) {
            String taiKhoan = req.getParameter("username");
            String matKhau  = req.getParameter("password");

            if (taiKhoan == null || taiKhoan.trim().isEmpty()
                    || matKhau == null || matKhau.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
                req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req, resp);
                return;
            }

            NhanVien nv = nhanVienService.findByTaiKhoanAndMatKhau(taiKhoan.trim(), matKhau.trim());

            if (nv == null) {
                req.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.");
                req.setAttribute("oldUsername", taiKhoan);
                req.getRequestDispatcher("/demo/login/dang_nhap.jsp").forward(req, resp);
                return;
            }

            // Lưu thông tin vào session
            HttpSession session = req.getSession(true);
            session.setAttribute("nhanVien", nv);

            // Xác định vai trò để chuyển hướng phù hợp
            boolean isNhanVien = nv.getChucVu() != null
                    && nv.getChucVu().toLowerCase().contains("nhân viên");

            if (isNhanVien) {
                // Nhân viên → vào thẳng quản lý sản phẩm
                resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            } else {
                // Admin → vào trang tổng quan
                resp.sendRedirect(req.getContextPath() + "/tong_quan");
            }

        } else if (uri.contains("/login/dang_ky")) {
            req.getRequestDispatcher("/demo/login/dang_ky.jsp").forward(req, resp);
        }
    }
}
