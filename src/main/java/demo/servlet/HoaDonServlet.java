package demo.servlet;


import demo.entity.hoa_don.ChiTietHoaDon;
import demo.entity.hoa_don.HinhThucThanhToan;
import demo.entity.hoa_don.HoaDon;
import demo.entity.khach_hang.DiaChiKhachHang;
import demo.entity.khach_hang.KhachHang;
import demo.entity.san_pham.ChiTietSanPham;
import demo.entity.san_pham.MaSeri;
import demo.repository.hoadon.HinhThucThanhToanRepo;
import demo.repository.hoadon.HoaDonRepository;
import demo.repository.khachhang.KhachHangRepo;
import demo.repository.san_pham.ChiTietSanPhamRepository;
import demo.repository.san_pham.MaSeriRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.util.HashMap;
import java.util.List;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "HoaDonServlet", value = {
        "/hoa-don/hien-thi",
        "/hoa-don/add",
        "/hoa-don/detail",
        "/hoa-don/delete",
        "/hoa-don/update",
        "/hoa-don/view-update",
        "/hoa-don/ban-hang",
        "/hoa-don/export",
        "/hoa-don/print-view"
})
public class HoaDonServlet extends HttpServlet {

    HoaDonRepository hoaDonRepository = new HoaDonRepository();
    HinhThucThanhToanRepo hinhThucThanhToanRepo = new HinhThucThanhToanRepo();
    KhachHangRepo khachHangRepo = new KhachHangRepo();
    ChiTietSanPhamRepository chiTietSanPhamRepository = new ChiTietSanPhamRepository();
    MaSeriRepository maSeriRepository = new MaSeriRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("hien-thi")) {
            this.hienthi(req, resp);
        }else if (uri.contains("detail")) {
            this.detail(req, resp);
        } else if (uri.contains("view-update")) {
            this.viewUpdate(req, resp);
        } else if (uri.contains("ban-hang")) {
            this.banhang(req,resp);
        } else if (uri.contains("export")) {
            this.export(req,resp);
        } else if (uri.contains("print-view")) {
            this.printview(req, resp);
        }
    }

    private void printview(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            Integer id = Integer.valueOf(idParam);
            HoaDon hoaDon = hoaDonRepository.getOne(id);
            KhachHang khachHang = hoaDon.getKhachHang();

            // --- Lấy Địa chỉ ---
            DiaChiKhachHang diaChiHienThi = null;
            if (khachHang != null && khachHang.getDiaChiKhachHang() != null
                    && !khachHang.getDiaChiKhachHang().isEmpty()) {
                diaChiHienThi = khachHang.getDiaChiKhachHang().get(0);
            }

            // --- Lazy load (Tránh lỗi Hibernate khi in list) ---
            if (hoaDon.getLichSuThanhToan() != null) {
                org.hibernate.Hibernate.initialize(hoaDon.getLichSuThanhToan());
            }
            if (hoaDon.getListChiTiet() != null) {
                org.hibernate.Hibernate.initialize(hoaDon.getListChiTiet());
                for (ChiTietHoaDon ct : hoaDon.getListChiTiet()) {
                    if (ct.getCauHinhSanPham() != null) {
                        org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham());
                    }
                }
            }

            // --- Truyền dữ liệu sang JSP ---
            req.setAttribute("diaChi", diaChiHienThi);
            req.setAttribute("hoaDon", hoaDon);
            req.setAttribute("khachHang", khachHang);

            // Đảm bảo đường dẫn này đúng với thư mục chứa file jsp của bạn
            req.getRequestDispatcher("/demo/hoa_don/in_hoa_don.jsp").forward(req, resp);
        }
    }

    private void export(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        String ngayTao = req.getParameter("ngayTao");

        List<HoaDon> listHoaDon;
        boolean isFiltering = (keyword != null && !keyword.trim().isEmpty()) ||
                (trangThai != null && !trangThai.trim().isEmpty()) ||
                (ngayTao != null && !ngayTao.trim().isEmpty());

        if (isFiltering) {
            listHoaDon = hoaDonRepository.timKiemVaLoc(keyword, trangThai, ngayTao);
        } else {
            listHoaDon = hoaDonRepository.getAllHoaDon();
        }

        // 2. Khởi tạo file Excel
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Danh_Sach_Hoa_Don");

        // 3. Tạo dòng tiêu đề (Header)
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("STT");
        headerRow.createCell(1).setCellValue("Mã Hóa Đơn");
        headerRow.createCell(2).setCellValue("Khách Hàng");
        headerRow.createCell(3).setCellValue("Số Điện Thoại");
        headerRow.createCell(4).setCellValue("Ngày Tạo");
        headerRow.createCell(5).setCellValue("Tổng Tiền");
        headerRow.createCell(6).setCellValue("Trạng Thái");

        // 4. Đổ dữ liệu vào các dòng tiếp theo
        int rowNum = 1;
        for (HoaDon hd : listHoaDon) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rowNum - 1); // STT
            row.createCell(1).setCellValue(hd.getMaHoaDon() != null ? hd.getMaHoaDon() : "");
            row.createCell(2).setCellValue(hd.getKhachHang() != null ? hd.getKhachHang().getTenKhachHang() : "");
            row.createCell(3).setCellValue(hd.getKhachHang() != null ? hd.getKhachHang().getSdt() : "");
            row.createCell(4).setCellValue(hd.getNgayLap() != null ? hd.getNgayLap().toString() : "");

            // Định dạng tiền tệ đơn giản
            double tongTien = hd.getTongTien() != null ? hd.getTongTien().doubleValue() : 0;
            row.createCell(5).setCellValue(tongTien);

            String trangThaiStr = (hd.getTrangThai() != null && hd.getTrangThai() == 1) ? "Đã thanh toán" : "Chưa thanh toán";
            row.createCell(6).setCellValue(trangThaiStr);
        }

        // Tự động căn chỉnh độ rộng cột
        for (int i = 0; i < 7; i++) {
            sheet.autoSizeColumn(i);
        }

        // 5. Cấu hình Response để trình duyệt tải file về
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"DanhSachHoaDon.xlsx\"");

        // 6. Ghi dữ liệu và đóng kết nối
        workbook.write(resp.getOutputStream());
        workbook.close();
    }

    private void banhang(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ChiTietSanPham> listSanPham = chiTietSanPhamRepository.getAll();
        List<KhachHang> listKhachHang = khachHangRepo.getAll();
        List<MaSeri> listMaSeri = maSeriRepository.getAll();

        req.setAttribute("listSanPham",  listSanPham);
        req.setAttribute("listKhachHang", listKhachHang);
        req.setAttribute("listMaSeri", listMaSeri);

        req.getRequestDispatcher("/demo/hoa_don/ban_hang.jsp")
                .forward(req, resp);

    }

    private void viewUpdate(HttpServletRequest req, HttpServletResponse resp) {
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) {
    }
    private void detail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer id = Integer.valueOf(req.getParameter("id"));

        HoaDon hoaDon = hoaDonRepository.getOne(id);
        KhachHang khachHang = hoaDon.getKhachHang();

        // --- Địa chỉ ---
        DiaChiKhachHang diaChiHienThi = null;
        if (khachHang != null && khachHang.getDiaChiKhachHang() != null
                && !khachHang.getDiaChiKhachHang().isEmpty()) {
            diaChiHienThi = khachHang.getDiaChiKhachHang().get(0);
        }

        // --- Lazy load ---
        if (hoaDon.getLichSuThanhToan() != null) {
            org.hibernate.Hibernate.initialize(hoaDon.getLichSuThanhToan());
        }
        if (hoaDon.getListChiTiet() != null) {
            org.hibernate.Hibernate.initialize(hoaDon.getListChiTiet());
            for (ChiTietHoaDon ct : hoaDon.getListChiTiet()) {
                if (ct.getCauHinhSanPham() != null) {
                    org.hibernate.Hibernate.initialize(ct.getCauHinhSanPham());
                }
            }
        }


        req.setAttribute("diaChi",    diaChiHienThi);
        req.setAttribute("hoaDon",    hoaDon);
        req.setAttribute("khachHang", khachHang);
        req.getRequestDispatcher("/demo/hoa_don/chi_tiet_hoa_don.jsp").forward(req, resp);
    }

    private void add(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

    private void hienthi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<HinhThucThanhToan> listHTTT = hinhThucThanhToanRepo.getAll();
        Map<Integer, String> mapThanhToan = new HashMap<>();

        String keyword = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        String ngayTao = req.getParameter("ngayTao");

        // 2. Gọi hàm lọc linh động từ Repository thay vì lấy tất cả
        // Nếu mới vào trang (chưa bấm lọc), các biến này sẽ là null -> Repo tự hiểu là select all
        List<HoaDon> ListHoaDon = hoaDonRepository.timKiemVaLoc(keyword, trangThai, ngayTao);

        for (HinhThucThanhToan httt : listHTTT) {
            if (httt.getHoaDon() != null) {
                mapThanhToan.put(httt.getHoaDon().getId(), httt.getTenHinhThuc());
            }
        }

        req.setAttribute("ListHoaDon", ListHoaDon);
        req.setAttribute("mapThanhToan", mapThanhToan);
        req.getRequestDispatcher("/demo/hoa_don/hoa_don.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("add")) {
            add(req, resp);
        } else if (uri.contains("update")) {
            update(req, resp);
        }
    }
}
