package demo.servlet;

import demo.Service.nhanvien.NhanVienService;
import demo.entity.nhan_vien.NhanVien;
import demo.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/view-add",
        "/nhan-vien/add",
        "/nhan-vien/view-update",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/doi-trang-thai"
})
public class NhanVienServlet extends HttpServlet {

    NhanVienService service = new NhanVienService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền: nhân viên không được truy cập quản lý nhân viên
        Object nvObjCheck = request.getSession(false) != null ? request.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nvSession = (nvObjCheck instanceof demo.entity.nhan_vien.NhanVien)
                ? (demo.entity.nhan_vien.NhanVien) nvObjCheck : null;
        if (nvSession != null && LoginServlet.isNhanVienRole(nvSession.getChucVu())) {
            response.sendRedirect(request.getContextPath() + "/san-pham/hien-thi");
            return;
        }

        String uri = request.getRequestURI();

        // Hiển thị danh sách nhân viên
        if (uri.contains("hien-thi")) {

            request.setAttribute("listNV", service.getAll());
            request.getRequestDispatcher("/demo/nhan_vien/nhan_vien.jsp")
                    .forward(request, response);

        }
        // Mở trang thêm nhân viên
        else if (uri.contains("view-add")) {

            request.getRequestDispatcher("/demo/nhan_vien/nhan_vien_add.jsp")
                    .forward(request, response);

        }
        // Mở trang sửa nhân viên
        else if (uri.contains("view-update")) {

            Integer id = Integer.parseInt(request.getParameter("id"));

            // Lấy nhân viên theo id
            request.setAttribute("nv", service.getOne(id));

            // Chuyển sang trang update
            request.getRequestDispatcher("/demo/nhan_vien/nhan_vien_update.jsp")
                    .forward(request, response);

        }
        // Xóa mềm nhân viên
        else if (uri.contains("delete")) {

            Integer id = Integer.parseInt(request.getParameter("id"));
            service.delete(id);

            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");

        }
        // Switch đổi trạng thái
        else if (uri.contains("doi-trang-thai")) {

            Integer id = Integer.parseInt(request.getParameter("id"));

            // JS gửi "true"/"false" từ checkbox, cần parse sang 1/0
            String trangThaiParam = request.getParameter("trangThai");
            Integer trangThai;
            if ("true".equalsIgnoreCase(trangThaiParam) || "1".equals(trangThaiParam)) {
                trangThai = 1;
            } else if ("false".equalsIgnoreCase(trangThaiParam) || "0".equals(trangThaiParam)) {
                trangThai = 0;
            } else {
                trangThai = 0;
            }

            service.doiTrangThai(id, trangThai);

            // Nếu là AJAX (fetch) thì trả về JSON, ngược lại redirect
            String xhrHeader = request.getHeader("X-Requested-With");
            String acceptHeader = request.getHeader("Accept");
            if ("XMLHttpRequest".equals(xhrHeader) || (acceptHeader != null && acceptHeader.contains("application/json"))) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true}");
            } else {
                response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        // 1. LẤY CÁC THÔNG TIN CƠ BẢN TỪ FORM
        String hoTen = request.getParameter("hoTen");
        Boolean gioiTinh = Boolean.parseBoolean(request.getParameter("gioiTinh"));
        Date ngaySinh = Date.valueOf(request.getParameter("ngaySinh"));
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String chucVu = request.getParameter("chucVu");

        // 2. XỬ LÝ GHÉP CHUỖI ĐỊA CHỈ (Từ các ô chọn Tỉnh/Huyện/Xã)
        String tinhThanh = request.getParameter("tinhThanh");
        String quanHuyen = request.getParameter("quanHuyen");
        String phuongXa = request.getParameter("phuongXa");
        String diaChiChiTiet = request.getParameter("diaChiChiTiet");

        String diaChiFull = "";
        if (diaChiChiTiet != null && !diaChiChiTiet.trim().isEmpty()) {
            diaChiFull = diaChiChiTiet;
            if (phuongXa != null && !phuongXa.trim().isEmpty()) diaChiFull += ", " + phuongXa;
            if (quanHuyen != null && !quanHuyen.trim().isEmpty()) diaChiFull += ", " + quanHuyen;
            if (tinhThanh != null && !tinhThanh.trim().isEmpty()) diaChiFull += ", " + tinhThanh;
        } else {
            // Trường hợp Form cũ truyền trực tiếp parameter 'diaChi'
            diaChiFull = request.getParameter("diaChi");
        }

        // 3. XỬ LÝ LƯU HOẶC CẬP NHẬT
        if (uri.contains("add")) {
            // Tạo đối tượng nhân viên mới
            NhanVien nv = new NhanVien();
            nv.setMaNhanVien(service.layMaNhanVienMoi());
            nv.setHoTen(hoTen);
            nv.setGioiTinh(gioiTinh);
            nv.setNgaySinh(ngaySinh);
            nv.setSdt(sdt);
            nv.setEmail(email);
            nv.setDiaChi(diaChiFull);
            nv.setChucVu(chucVu);
            nv.setTrangThai(1);

            // Tài khoản = email, mật khẩu tạm để tránh null, sẽ cập nhật sau khi có ID
            nv.setTaiKhoan(email != null ? email.trim() : "tmp");
            nv.setMatKhau("tmp");

            service.add(nv); // Sau persist, Hibernate đã điền nv.getId()

            // Tạo mật khẩu theo chức vụ và ID thực tế
            Integer newId = nv.getId();
            String matKhau;
            if ("Quản Lý".equalsIgnoreCase(chucVu != null ? chucVu.trim() : "")) {
                matKhau = String.format("admin_%03d", newId);
            } else {
                matKhau = String.format("nv_%03d", newId);
            }
            nv.setMatKhau(matKhau);

            service.update(nv);

            // Gửi mail thông báo tài khoản
            try {
                EmailUtil.sendMail(
                        nv.getEmail(),
                        nv.getTaiKhoan(),
                        nv.getMatKhau()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (uri.contains("update")) {
            // Lấy ID từ form
            Integer id = Integer.parseInt(request.getParameter("id"));

            // Lấy đối tượng hiện tại từ DB để tránh đè mất Tài khoản / Mật khẩu cũ
            NhanVien nv = service.getOne(id);
            if (nv != null) {
                nv.setHoTen(hoTen);
                nv.setGioiTinh(gioiTinh);
                nv.setNgaySinh(ngaySinh);
                nv.setSdt(sdt);
                nv.setEmail(email);
                nv.setDiaChi(diaChiFull);
                nv.setChucVu(chucVu);

                service.update(nv);
            }
        }

        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }

}