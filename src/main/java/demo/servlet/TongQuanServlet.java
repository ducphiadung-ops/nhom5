package demo.servlet;

import demo.entity.hoa_don.HoaDon;
import demo.entity.san_pham.SanPham;
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
        this.tongquan(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.tongquan(req, resp);
    }

    private void tongquan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            // 1. TỔNG DOANH THU (Dùng BigDecimal vì SQL trả về kiểu tiền tệ/decimal)
            BigDecimal tongDoanhThu = session.createQuery(
                            "SELECT SUM(h.tongTien) FROM HoaDon h WHERE h.trangThai = 1", BigDecimal.class)
                    .uniqueResult();

            // Xử lý null và định dạng: nếu null thì về 0
            double doanhThuValue = (tongDoanhThu != null) ? tongDoanhThu.doubleValue() : 0.0;

            // 2. TỔNG HÓA ĐƠN
            Long tongHoaDon = session.createQuery(
                            "SELECT COUNT(h) FROM HoaDon h", Long.class)
                    .uniqueResult();
            if (tongHoaDon == null) tongHoaDon = 0L;

            // 3. TỔNG SẢN PHẨM ĐÃ BÁN
            Long tongSanPhamDaBan = session.createQuery(
                            "SELECT COUNT(cthd) FROM ChiTietHoaDon cthd JOIN cthd.hoaDon h WHERE h.trangThai = 1", Long.class)
                    .uniqueResult();
            if (tongSanPhamDaBan == null) tongSanPhamDaBan = 0L;

            // 4. TỔNG KHÁCH HÀNG
            Long tongKhachHang = session.createQuery(
                            "SELECT COUNT(k) FROM KhachHang k", Long.class)
                    .uniqueResult();
            if (tongKhachHang == null) tongKhachHang = 0L;

            // 5 & 6. LẤY DỮ LIỆU TỪ REPOSITORY
            List<HoaDon> listDonHangGanDay = hoaDonRepo.getTop5();
            List<SanPham> listSanPhamBanChay = sanPhamRepo.getTop5();

            // Đẩy dữ liệu lên JSP
            // Định dạng chuỗi: %,.0f sẽ có dấu phẩy ngăn cách hàng nghìn
            req.setAttribute("tongDoanhThu", String.format("%,.0f", doanhThuValue));
            req.setAttribute("tongHoaDon", tongHoaDon);
            req.setAttribute("tongSanPham", tongSanPhamDaBan);
            req.setAttribute("tongKhachHang", tongKhachHang);
            req.setAttribute("ListDonHangGanDay", listDonHangGanDay);
            req.setAttribute("ListSanPhamBanChay", listSanPhamBanChay);

        } catch (Exception e) {
            e.printStackTrace();
            // Đẩy dữ liệu mặc định nếu lỗi
            req.setAttribute("tongDoanhThu", "0");
            req.setAttribute("tongHoaDon", 0L);
            req.setAttribute("tongSanPham", 0L);
            req.setAttribute("tongKhachHang", 0L);
        }

        req.getRequestDispatcher("/demo/tong_quan.jsp").forward(req, resp);
    }
}