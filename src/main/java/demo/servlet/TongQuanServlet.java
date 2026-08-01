package demo.servlet;

import demo.entity.hoa_don.HoaDon;
import demo.repository.hoadon.HoaDonRepository;
import demo.repository.san_pham.SanPhamRepository;
import demo.util.HibernateConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "TongQuanServlet", value = {"/tong_quan"})
public class TongQuanServlet extends HttpServlet {

    private final HoaDonRepository hoaDonRepo = new HoaDonRepository();
    private final SanPhamRepository sanPhamRepo = new SanPhamRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nhân viên không được truy cập trang tổng quan
        Object nvObj = req.getSession(false) != null ? req.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nv = (nvObj instanceof demo.entity.nhan_vien.NhanVien)
                ? (demo.entity.nhan_vien.NhanVien) nvObj : null;
        if (nv != null && LoginServlet.isNhanVienRole(nv.getChucVu())) {
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
            return;
        }
        this.tongquan(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.tongquan(req, resp);
    }

    private void tongquan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String todayStr = java.time.LocalDate.now().toString(); // yyyy-MM-dd

        // Xác định chế độ lọc:
        //   - ngayLoc = "all"        → toàn bộ thời gian
        //   - ngayLoc = "yyyy-MM-dd" → lọc theo ngày cụ thể
        //   - ngayLoc = null/empty   → mặc định ngày hôm nay
        String ngayLocParam = req.getParameter("ngayLoc");
        boolean isAll = "all".equals(ngayLocParam);

        java.time.LocalDate ngayLoc = null;
        java.sql.Date ngayLocSql = null;
        String ngayLocHienThi;
        String ngayLocValue;

        if (isAll) {
            ngayLocHienThi = "Toàn bộ";
            ngayLocValue   = "";          // input date để trống khi chế độ "all"
        } else {
            if (ngayLocParam != null && !ngayLocParam.trim().isEmpty()) {
                try {
                    ngayLoc = java.time.LocalDate.parse(ngayLocParam.trim());
                } catch (Exception e) {
                    ngayLoc = java.time.LocalDate.now();
                }
            } else {
                ngayLoc = java.time.LocalDate.now();
            }
            ngayLocSql      = java.sql.Date.valueOf(ngayLoc);
            ngayLocHienThi  = ngayLoc.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            ngayLocValue    = ngayLoc.toString();
        }

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            BigDecimal tongDoanhThu;
            Long tongHoaDon;
            Long tongSanPhamDaBan;

            if (isAll) {
                // --- TOÀN BỘ THỜI GIAN ---
                tongDoanhThu = session.createQuery(
                        "SELECT SUM(h.tongTien) FROM HoaDon h WHERE h.trangThai = 1",
                        BigDecimal.class).uniqueResult();

                tongHoaDon = session.createQuery(
                        "SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai = 1",
                        Long.class).uniqueResult();

                tongSanPhamDaBan = session.createQuery(
                        "SELECT COUNT(cthd) FROM ChiTietHoaDon cthd JOIN cthd.hoaDon h WHERE h.trangThai = 1",
                        Long.class).uniqueResult();
            } else {
                // --- LỌC THEO NGÀY CỤ THỂ ---
                tongDoanhThu = session.createQuery(
                        "SELECT SUM(h.tongTien) FROM HoaDon h " +
                        "WHERE h.trangThai = 1 AND CAST(h.ngayLap AS date) = :ngayLoc",
                        BigDecimal.class)
                        .setParameter("ngayLoc", ngayLocSql)
                        .uniqueResult();

                tongHoaDon = session.createQuery(
                        "SELECT COUNT(h) FROM HoaDon h " +
                        "WHERE h.trangThai = 1 AND CAST(h.ngayLap AS date) = :ngayLoc",
                        Long.class)
                        .setParameter("ngayLoc", ngayLocSql)
                        .uniqueResult();

                tongSanPhamDaBan = session.createQuery(
                        "SELECT COUNT(cthd) FROM ChiTietHoaDon cthd JOIN cthd.hoaDon h " +
                        "WHERE h.trangThai = 1 AND CAST(h.ngayLap AS date) = :ngayLoc",
                        Long.class)
                        .setParameter("ngayLoc", ngayLocSql)
                        .uniqueResult();
            }

            double doanhThuValue = (tongDoanhThu != null) ? tongDoanhThu.doubleValue() : 0.0;
            if (tongHoaDon == null)      tongHoaDon = 0L;
            if (tongSanPhamDaBan == null) tongSanPhamDaBan = 0L;

            // 4. KHÁCH HÀNG MUA TRONG KỲ (distinct, chỉ tính KH có tài khoản — không tính khách lẻ)
            Long khachHangMua;
            if (isAll) {
                khachHangMua = session.createQuery(
                        "SELECT COUNT(DISTINCT h.khachHang.id) FROM HoaDon h " +
                        "WHERE h.trangThai = 1 AND h.khachHang IS NOT NULL",
                        Long.class).uniqueResult();
            } else {
                khachHangMua = session.createQuery(
                        "SELECT COUNT(DISTINCT h.khachHang.id) FROM HoaDon h " +
                        "WHERE h.trangThai = 1 AND h.khachHang IS NOT NULL " +
                        "AND CAST(h.ngayLap AS date) = :ngayLoc",
                        Long.class)
                        .setParameter("ngayLoc", ngayLocSql)
                        .uniqueResult();
            }
            if (khachHangMua == null) khachHangMua = 0L;

            // 5. TỔNG KHÁCH HÀNG trong hệ thống (luôn tổng tất cả, không lọc ngày)
            Long tongKhachHang = session.createQuery(
                    "SELECT COUNT(k) FROM KhachHang k", Long.class).uniqueResult();
            if (tongKhachHang == null) tongKhachHang = 0L;

            // 5 & 6. LẤY DỮ LIỆU TỪ REPOSITORY
            List<HoaDon> listDonHangGanDay = hoaDonRepo.getTop5();
            List<Object[]> listSanPhamBanChay = sanPhamRepo.getTop5BanChay();

            // 7. BIỂU ĐỒ DOANH THU THEO TUẦN HIỆN TẠI
            // Tính ngày đầu tuần (Thứ 2) và cuối tuần (Chủ nhật) của tuần chứa ngày hôm nay
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate dauTuan = today.with(java.time.DayOfWeek.MONDAY);
            java.time.LocalDate cuoiTuan = today.with(java.time.DayOfWeek.SUNDAY);

            // Label trục X: "T2 28/7", "T3 29/7", ...
            String[] tenNgay = {"T2", "T3", "T4", "T5", "T6", "T7", "CN"};
            java.time.format.DateTimeFormatter fmtLabel =
                    java.time.format.DateTimeFormatter.ofPattern("dd/MM");

            StringBuilder jsonLabels = new StringBuilder("[");
            StringBuilder jsonData   = new StringBuilder("[");

            for (int i = 0; i < 7; i++) {
                java.time.LocalDate ngay = dauTuan.plusDays(i);
                String label = tenNgay[i] + " " + ngay.format(fmtLabel);

                // Append label
                if (i > 0) { jsonLabels.append(","); jsonData.append(","); }
                jsonLabels.append("\"").append(label).append("\"");

                // Ngày trong tương lai → null (ngắt đoạn đường)
                if (ngay.isAfter(today)) {
                    jsonData.append("null");
                } else {
                    java.sql.Date ngaySql = java.sql.Date.valueOf(ngay);
                    BigDecimal dt = session.createQuery(
                            "SELECT SUM(h.tongTien) FROM HoaDon h " +
                            "WHERE h.trangThai = 1 AND CAST(h.ngayLap AS date) = :d",
                            BigDecimal.class)
                            .setParameter("d", ngaySql)
                            .uniqueResult();
                    // Dùng đơn vị triệu đồng để trục Y gọn hơn
                    double val = (dt != null) ? dt.doubleValue() / 1_000_000.0 : 0.0;
                    jsonData.append(String.format("%.3f", val).replace(",", "."));
                }
            }
            jsonLabels.append("]");
            jsonData.append("]");

            req.setAttribute("chartLabels", jsonLabels.toString());
            req.setAttribute("chartData",   jsonData.toString());
            // Truyền ngày đầu/cuối tuần để hiển thị tiêu đề biểu đồ
            req.setAttribute("dauTuan",  dauTuan.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            req.setAttribute("cuoiTuan", cuoiTuan.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")));

            // Định dạng tiền tệ chuẩn VN
            String doanhThuFormatted = String.format("%,.0f", doanhThuValue).replace(",", ".");

            req.setAttribute("tongDoanhThu", doanhThuFormatted);
            req.setAttribute("tongHoaDon", tongHoaDon);
            req.setAttribute("tongSanPham", tongSanPhamDaBan);
            req.setAttribute("khachHangMua", khachHangMua);
            req.setAttribute("tongKhachHang", tongKhachHang);
            req.setAttribute("ListDonHangGanDay", listDonHangGanDay);
            req.setAttribute("ListSanPhamBanChay", listSanPhamBanChay);
            req.setAttribute("ngayLocHienThi", ngayLocHienThi);
            req.setAttribute("ngayLocValue", ngayLocValue);
            req.setAttribute("ngayTodayValue", todayStr);
            req.setAttribute("isAll", isAll);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("tongDoanhThu", "0");
            req.setAttribute("tongHoaDon", 0L);
            req.setAttribute("tongSanPham", 0L);
            req.setAttribute("khachHangMua", 0L);
            req.setAttribute("tongKhachHang", 0L);
            req.setAttribute("ngayLocHienThi", "Toàn bộ");
            req.setAttribute("ngayLocValue", "");
            req.setAttribute("ngayTodayValue", todayStr);
            req.setAttribute("isAll", false);
            req.setAttribute("chartLabels", "[\"T2\",\"T3\",\"T4\",\"T5\",\"T6\",\"T7\",\"CN\"]");
            req.setAttribute("chartData",   "[null,null,null,null,null,null,null]");
            req.setAttribute("dauTuan", "");
            req.setAttribute("cuoiTuan", "");
        }

        req.getRequestDispatcher("/demo/tong_quan.jsp").forward(req, resp);
    }
}