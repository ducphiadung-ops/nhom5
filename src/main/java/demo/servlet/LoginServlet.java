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
import java.text.Normalizer;

@WebServlet(name = "LoginServlet", value = {
        "/login/dang_nhap",
        "/login/dang_ky"
})
public class LoginServlet extends HttpServlet {

    private final NhanVienService nhanVienService = new NhanVienService();

    // 🟢 SỬA ĐƯỜNG DẪN JSP CHO ĐÚNG VỚI VỊ TRÍ FILE THỰC TẾ TRONG WEBAPP
    private static final String JSP_DANG_NHAP = "/demo/login/dang_nhap.jsp";
    private static final String JSP_DANG_KY   = "/demo/login/dang_ky.jsp";

    public static String removeDiacritics(String str) {
        if (str == null) return "";
        String normalized = Normalizer.normalize(str, Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
                .replace("đ", "d").replace("Đ", "d")
                .toLowerCase().trim();
    }

    public static boolean isNhanVienRole(String chucVu) {
        if (chucVu == null || chucVu.trim().isEmpty()) return false;
        String normalized = removeDiacritics(chucVu);
        return normalized.contains("nhan vien")
                || normalized.contains("nhanvien")
                || normalized.contains("ban hang")
                || normalized.contains("banhang")
                || normalized.contains("thu ngan")
                || normalized.contains("thu kho")
                || normalized.contains("ky thuat");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath(); // Dùng getServletPath() chính xác hơn getRequestURI()

        if ("/login/dang_nhap".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("nhanVien") != null) {
                NhanVien nv = (NhanVien) session.getAttribute("nhanVien");
                if (isNhanVienRole(nv.getChucVu())) {
                    resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/tong_quan");
                }
                return;
            }
            req.getRequestDispatcher(JSP_DANG_NHAP).forward(req, resp);
        } else if ("/login/dang_ky".equals(path)) {
            req.getRequestDispatcher(JSP_DANG_KY).forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/login/dang_nhap".equals(path)) {
            String taiKhoan = req.getParameter("username");
            String matKhau  = req.getParameter("password");

            if (taiKhoan == null || taiKhoan.trim().isEmpty()
                    || matKhau == null || matKhau.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
                req.getRequestDispatcher(JSP_DANG_NHAP).forward(req, resp);
                return;
            }

            NhanVien nv = nhanVienService.findByTaiKhoanAndMatKhau(taiKhoan.trim(), matKhau.trim());

            if (nv == null) {
                // Khi nhập sai: Set attribute báo lỗi và forward về lại JSP login
                req.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.");
                req.setAttribute("oldUsername", taiKhoan);
                req.getRequestDispatcher(JSP_DANG_NHAP).forward(req, resp);
                return;
            }

            // Đăng nhập thành công
            HttpSession session = req.getSession(true);
            session.setAttribute("nhanVien", nv);

            if (isNhanVienRole(nv.getChucVu())) {
                resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            } else {
                resp.sendRedirect(req.getContextPath() + "/tong_quan");
            }

        } else if ("/login/dang_ky".equals(path)) {
            req.getRequestDispatcher(JSP_DANG_KY).forward(req, resp);
        }
    }
}