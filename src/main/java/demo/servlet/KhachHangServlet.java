package demo.servlet;
import demo.Service.khachhang.KhachHangService;
import demo.entity.khach_hang.DiaChiApiMapping;
import demo.entity.khach_hang.DiaChiKhachHang;
import demo.entity.khach_hang.KhachHang;
import demo.repository.khachhang.DiaChiApiMappingRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "KhachHangServlet", value = {
        "/khach-hang/hien-thi",
        "/khach-hang/doi-trang-thai",
        "/khach-hang/view-add",
        "/khach-hang/add",
        "/khach-hang/sua",
        "/khach-hang/cap-nhat",
        "/khach-hang/xoa"
})
public class KhachHangServlet extends HttpServlet {

    KhachHangService service = new KhachHangService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        // Hiển thị danh sách
        if (uri.contains("hien-thi")) {

            req.setAttribute("listKH", service.getAll());

            req.getRequestDispatcher("/demo/khach_hang/khach_hang.jsp")
                    .forward(req, resp);

        }

        // Mở trang thêm
        if (uri.contains("view-add")) {
            req.getRequestDispatcher("/demo/khach_hang/khach_hang_add.jsp").forward(req, resp);

        }
        //mo form sua
        if (uri.contains("/sua")) {

            Integer id = Integer.valueOf(req.getParameter("id"));

            KhachHang kh = service.timTheoId(id);

            req.setAttribute("kh", kh);

            req.getRequestDispatcher("/demo/khach_hang/khach_hang_update.jsp")
                    .forward(req, resp);
            return;
        }
        //xoa
        if (uri.contains("xoa")) {

            Integer id = Integer.valueOf(req.getParameter("id"));

            service.xoa(id);

            resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");

            return;
        }
        // doi trang thai
        else if (uri.contains("doi-trang-thai")) {

            Integer id = Integer.valueOf(req.getParameter("id"));

            Boolean trangThai = Boolean.valueOf(req.getParameter("trangThai"));

            service.doiTrangThai(id, trangThai);

            resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            return;
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DiaChiApiMappingRepository mappingRepo = new DiaChiApiMappingRepository();

        String uri = req.getRequestURI();

        if (uri.contains("add")) {
            // Tự sinh mã khách hàng
            String ma = service.layMaKhachHangMoi();

            // Lấy dữ liệu từ form
            String ten = req.getParameter("tenKhachHang");
            String sdt = req.getParameter("sdt");
            String email = req.getParameter("email");

            Boolean trangThai = Boolean.valueOf(req.getParameter("trangThai"));
            Boolean gioiTinh = Boolean.valueOf(req.getParameter("gioiTinh"));

            String[] tinhThanh = req.getParameterValues("tinhThanh");
            String[] quanHuyen = req.getParameterValues("quanHuyen");
            String[] phuongXa = req.getParameterValues("phuongXa");
            String[] diaChiCuThe = req.getParameterValues("diaChiCuThe");
            String[] loaiDiaChi = req.getParameterValues("loaiDiaChi");
            String[] provinceCode = req.getParameterValues("provinceCode");
            String[] districtCode = req.getParameterValues("districtCode");
            String[] wardCode = req.getParameterValues("wardCode");

            String ngaySinhStr = req.getParameter("ngaySinh");
            LocalDate ngaySinh = null;
            if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
                ngaySinh = LocalDate.parse(ngaySinhStr);
            }

            // Tạo đối tượng khách hàng
            KhachHang kh = new KhachHang();
            kh.setMaKhachHang(ma);
            kh.setTenKhachHang(ten);
            kh.setGioiTinh(gioiTinh);
            kh.setNgaySinh(ngaySinh);
            kh.setSdt(sdt);
            kh.setEmail(email);
            kh.setTrangThai(trangThai);

            // Tạo đối tượng địa chỉ
            List<DiaChiKhachHang> listDiaChi = new ArrayList<>();

            for (int i = 0; i < tinhThanh.length; i++) {

                DiaChiKhachHang dc = new DiaChiKhachHang();

                dc.setTinhThanh(tinhThanh[i]);
                dc.setQuanHuyen(quanHuyen[i]);
                dc.setPhuongXa(phuongXa[i]);
                dc.setDiaChiCuThe(diaChiCuThe[i]);

                if (loaiDiaChi[i] == null || loaiDiaChi[i].trim().isEmpty()) {
                    dc.setLoaiDiaChi("Nhà riêng");
                } else {
                    dc.setLoaiDiaChi(loaiDiaChi[i]);
                }

                // Địa chỉ đầu tiên là mặc định
                dc.setTrangThai(i == 0);

                dc.setKhachHang(kh);

                // Mapping API
                DiaChiApiMapping mapping = new DiaChiApiMapping();
                mapping.setProvinceCode(Integer.parseInt(provinceCode[i]));
                mapping.setDistrictCode(Integer.parseInt(districtCode[i]));
                mapping.setWardCode(Integer.parseInt(wardCode[i]));

                mapping.setDiaChiKhachHang(dc);
                dc.setDiaChiApiMapping(mapping);

                listDiaChi.add(dc);
            }

            kh.setDiaChiKhachHang(listDiaChi);

            // Lưu xuống DB thông qua Service
            service.add(kh);

            resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            return;
        }

        // ================= 2. XỬ LÝ CẬP NHẬT (UPDATE) =================
        if (uri.contains("cap-nhat")) {

            Integer id = Integer.valueOf(req.getParameter("id"));
            KhachHang kh = service.timTheoId(id);

            if (kh != null) {
                // 1. Cập nhật thông tin chung của Khách Hang
                kh.setMaKhachHang(req.getParameter("maKhachHang"));
                kh.setTenKhachHang(req.getParameter("tenKhachHang"));
                kh.setGioiTinh(Boolean.valueOf(req.getParameter("gioiTinh")));

                String ngaySinh = req.getParameter("ngaySinh");
                if (ngaySinh != null && !ngaySinh.trim().isEmpty()) {
                    kh.setNgaySinh(LocalDate.parse(ngaySinh));
                } else {
                    kh.setNgaySinh(null);
                }

                kh.setSdt(req.getParameter("sdt"));
                kh.setEmail(req.getParameter("email"));
                kh.setTrangThai(Boolean.valueOf(req.getParameter("trangThai")));

                // 2. Nhận mảng dữ liệu Địa Chỉ từ Form JSP gửi lên
                String[] dsTinhThanh = req.getParameterValues("tinhThanh");
                String[] dsQuanHuyen = req.getParameterValues("quanHuyen");
                String[] dsPhuongXa = req.getParameterValues("phuongXa");
                String[] dsDiaChiCuThe = req.getParameterValues("diaChiCuThe");
                String[] dsLoaiDiaChi = req.getParameterValues("loaiDiaChi");

                String[] provinceCode = req.getParameterValues("provinceCode");
                String[] districtCode = req.getParameterValues("districtCode");
                String[] wardCode = req.getParameterValues("wardCode");

                // Tạo danh sách địa chỉ mới để gán lại cho Khách hàng
                List<DiaChiKhachHang> danhSachDiaChiMoi = new ArrayList<>();

                if (dsDiaChiCuThe != null && dsDiaChiCuThe.length > 0) {
                    for (int i = 0; i < dsDiaChiCuThe.length; i++) {
                        // Bỏ qua các dòng địa chỉ trống
                        if (dsDiaChiCuThe[i] == null || dsDiaChiCuThe[i].trim().isEmpty()) {
                            continue;
                        }

                        DiaChiKhachHang dc = new DiaChiKhachHang();
                        dc.setTinhThanh(dsTinhThanh != null && i < dsTinhThanh.length ? dsTinhThanh[i] : "");
                        dc.setQuanHuyen(dsQuanHuyen != null && i < dsQuanHuyen.length ? dsQuanHuyen[i] : "");
                        dc.setPhuongXa(dsPhuongXa != null && i < dsPhuongXa.length ? dsPhuongXa[i] : "");
                        dc.setDiaChiCuThe(dsDiaChiCuThe[i]);
                        dc.setLoaiDiaChi(dsLoaiDiaChi != null && i < dsLoaiDiaChi.length ? dsLoaiDiaChi[i] : "Nhà riêng");


                        dc.setKhachHang(kh);
                        DiaChiApiMapping mapping = new DiaChiApiMapping();

                        mapping.setProvinceCode(Integer.parseInt(provinceCode[i]));
                        mapping.setDistrictCode(Integer.parseInt(districtCode[i]));
                        mapping.setWardCode(Integer.parseInt(wardCode[i]));

                        mapping.setDiaChiKhachHang(dc);
                        dc.setDiaChiApiMapping(mapping);
                        danhSachDiaChiMoi.add(dc);
                    }
                }

                // Cập nhật lại danh sách địa chỉ cho Entity Khách hàng
                // Lưu ý: Đảm bảo trong Entity KhachHang bạn đã cấu hình orphanRemoval = true hoặc xoá các địa chỉ cũ
                if (kh.getDiaChiKhachHangList() != null) {
                    kh.getDiaChiKhachHangList().clear();
                    kh.getDiaChiKhachHangList().addAll(danhSachDiaChiMoi);
                } else {
                    kh.setDiaChiKhachHang(danhSachDiaChiMoi);
                }

                // 3. Gọi Service lưu lại
                service.capNhat(kh);

                // 4. Chuyển hướng về trang danh sách
                resp.sendRedirect(req.getContextPath() + "/khach-hang/hien-thi");
            }
        }
    }
}