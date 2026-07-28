package demo.servlet;

import demo.entity.hoa_don.*;
import demo.entity.khach_hang.DiaChiKhachHang;
import demo.entity.khach_hang.KhachHang;
import demo.entity.nhan_vien.NhanVien;
import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.ChiTietSanPham;
import demo.entity.san_pham.MaSeri;
import demo.repository.hoadon.*;
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

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "HoaDonServlet", value = {
        "/hoa-don/hien-thi",
        "/hoa-don/add",
        "/hoa-don/xoa-cho",
        "/hoa-don/detail",
        "/hoa-don/delete",
        "/hoa-don/update",
        "/hoa-don/view-update",
        "/hoa-don/ban-hang",
        "/hoa-don/export",
        "/hoa-don/print-view",
        "/hoa-don/api/tao-don",
        "/hoa-don/api/xoa-don",
        "/hoa-don/api/them-seri",
        "/hoa-don/api/xoa-seri",
        "/hoa-don/api/cap-nhat-khach",
        "/hoa-don/api/thanh-toan",
        "/hoa-don/api/chi-tiet",
        "/hoa-don/khoi-phuc"
})
public class HoaDonServlet extends HttpServlet {

    private final HoaDonRepository hoaDonRepository         = new HoaDonRepository();
    private final HinhThucThanhToanRepo hinhThucThanhToanRepo = new HinhThucThanhToanRepo();
    private final KhachHangRepo khachHangRepo               = new KhachHangRepo();
    private final ChiTietSanPhamRepository chiTietSanPhamRepository = new ChiTietSanPhamRepository();
    private final MaSeriRepository maSeriRepository         = new MaSeriRepository();
    private final ChiTietHoaDonRepo chiTietHoaDonRepo       = new ChiTietHoaDonRepo();
    private final LichSuHoaDonRepo lichSuHoaDonRepo         = new LichSuHoaDonRepo();
    private final LichSuThanhToanRepo lichSuThanhToanRepo   = new LichSuThanhToanRepo();

    // =====================================================================
    //  ROUTING
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("hien-thi"))        { hienthi(req, resp); }
        else if (uri.contains("detail"))     { detail(req, resp); }
        else if (uri.contains("view-update")){ viewUpdate(req, resp); }
        else if (uri.contains("ban-hang"))   { banhang(req, resp); }
        else if (uri.contains("export"))     { export(req, resp); }
        else if (uri.contains("print-view")) { printview(req, resp); }
        else if (uri.contains("/api/chi-tiet")) { apiChiTiet(req, resp); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if      (uri.contains("/api/tao-don"))       { apiTaoDon(req, resp); }
        else if (uri.contains("/api/xoa-don"))       { apiXoaDon(req, resp); }
        else if (uri.contains("/api/them-seri"))     { apiThemSeri(req, resp); }
        else if (uri.contains("/api/xoa-seri"))      { apiXoaSeri(req, resp); }
        else if (uri.contains("/api/cap-nhat-khach")){ apiCapNhatKhach(req, resp); }
        else if (uri.contains("/api/thanh-toan"))    { apiThanhToan(req, resp); }
        else if (uri.contains("add"))                { add(req, resp); }
        else if (uri.contains("update"))             { update(req, resp); }
        else if (uri.contains("khoi-phuc"))          { khoiPhucHoaDon(req, resp); }
    }

    // =====================================================================
    //  POST /hoa-don/khoi-phuc — Đổi trangThai=3 → 2 (khôi phục hoá đơn đã huỷ)
    // =====================================================================
    private void khoiPhucHoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            HoaDon hd = hoaDonRepository.getOne(id);
            if (hd == null || hd.getTrangThai() != 3) {
                resp.sendRedirect(req.getContextPath() + "/hoa-don/hien-thi?filtered=true");
                return;
            }
            hd.setTrangThai(2);
            hoaDonRepository.update(hd);
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Redirect về trang danh sách với filter hiện tại
        String ref = req.getHeader("Referer");
        resp.sendRedirect(ref != null ? ref : req.getContextPath() + "/hoa-don/hien-thi?filtered=true");
    }

    // =====================================================================
    //  HELPER: gửi JSON response
    // =====================================================================
    private void jsonOk(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(200);
        try (PrintWriter pw = resp.getWriter()) { pw.print(json); }
    }

    private void jsonErr(HttpServletResponse resp, int code, String msg) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(code);
        try (PrintWriter pw = resp.getWriter()) {
            pw.print("{\"error\":\"" + msg.replace("\"", "'") + "\"}");
        }
    }

    // =====================================================================
    //  API: POST /hoa-don/api/tao-don
    //  Tạo một hoá đơn chờ mới (trangThai=2), trả về JSON hoá đơn vừa tạo
    // =====================================================================
    private void apiTaoDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");

            // Dự đoán ID tiếp theo để sinh mã trước (cột ma_hoa_don NOT NULL)
            int nextId = hoaDonRepository.getNextId();
            int nam = java.time.LocalDate.now().getYear();
            String ma = String.format("HD%d_%03d", nam, nextId);

            HoaDon hd = new HoaDon();
            hd.setMaHoaDon(ma);
            hd.setTrangThai(2);           // Chờ xử lý
            hd.setNgayLap(Date.valueOf(LocalDate.now()));
            hd.setTongTien(BigDecimal.ZERO);
            hd.setIsDeleted(0);
            if (nv != null) hd.setNhanVien(nv);

            Integer newId = hoaDonRepository.add(hd);
            if (newId == null) {
                jsonErr(resp, 500, "Không thể lưu hoá đơn vào database");
                return;
            }

            // Nếu ID thực khác dự đoán (race condition), cập nhật lại mã
            if (!newId.equals(nextId)) {
                ma = String.format("HD%d_%03d", nam, newId);
                hd.setId(newId);
                hd.setMaHoaDon(ma);
                hoaDonRepository.update(hd);
            }

            // Ghi lịch sử tạo đơn
            LichSuHoaDon ls = new LichSuHoaDon();
            ls.setHoaDon(hd);
            ls.setNgayTao(new java.util.Date());
            ls.setGhiChu("Tạo hoá đơn chờ tại quầy");
            ls.setTrangThai(2);
            lichSuHoaDonRepo.add(ls);

            jsonOk(resp, "{\"id\":" + newId + ",\"maHoaDon\":\"" + ma + "\",\"trangThai\":2}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Không thể tạo hoá đơn: " + e.getMessage());
        }
    }

    // =====================================================================
    //  API: POST /hoa-don/api/xoa-don
    //  Xoá hoá đơn chờ: chuyển trangThai = 3 (đã huỷ), giải phóng seri
    // =====================================================================
    private void apiXoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon = Integer.parseInt(req.getParameter("idHoaDon"));
            // Hoàn trạng thái tất cả seri về 0 (còn hàng)
            List<ChiTietHoaDon> danhSachCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            for (ChiTietHoaDon ct : danhSachCT) {
                MaSeri seri = ct.getIdSeri();
                if (seri != null) {
                    seri.setTrangThai(0);
                    maSeriRepository.update(seri);
                }
            }
            // Chuyển trạng thái hoá đơn về 3 (đã huỷ) thay vì xoá cứng
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd != null) {
                hd.setTrangThai(3);
                hoaDonRepository.update(hd);
            }
            jsonOk(resp, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Không thể xoá hoá đơn: " + e.getMessage());
        }
    }

    // =====================================================================
    //  API: POST /hoa-don/api/them-seri
    //  Thêm một mã seri vào chi tiết hoá đơn
    //  params: idHoaDon, idSeri
    // =====================================================================
    private void apiThemSeri(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idHoaDonStr = req.getParameter("idHoaDon");
            String idSeriStr   = req.getParameter("idSeri");

            System.out.println("[DEBUG] them-seri: idHoaDon=" + idHoaDonStr + " idSeri=" + idSeriStr);

            if (idHoaDonStr == null || idHoaDonStr.trim().isEmpty()) {
                jsonErr(resp, 400, "Thiếu tham số idHoaDon"); return;
            }
            if (idSeriStr == null || idSeriStr.trim().isEmpty()) {
                jsonErr(resp, 400, "Thiếu tham số idSeri"); return;
            }

            int idHoaDon = Integer.parseInt(idHoaDonStr.trim());
            int idSeri   = Integer.parseInt(idSeriStr.trim());

            HoaDon hd     = hoaDonRepository.getOne(idHoaDon);
            MaSeri seri   = maSeriRepository.getOne(idSeri);

            if (hd == null)   { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }
            if (seri == null) { jsonErr(resp, 404, "Không tìm thấy mã seri");  return; }
            if (seri.getTrangThai() != 0) {
                jsonErr(resp, 400, "Seri này không còn khả dụng");
                return;
            }

            // Lấy giá từ ChiTietSanPham theo cauHinhId
            CauHinhSanPham cauHinh = seri.getCauHinhSanPham();
            BigDecimal donGia = BigDecimal.ZERO;
            if (cauHinh != null) {
                List<ChiTietSanPham> dsCT = chiTietSanPhamRepository.findByCauHinhId(cauHinh.getId());
                if (!dsCT.isEmpty() && dsCT.get(0).getDonGia() != null) {
                    donGia = dsCT.get(0).getDonGia();
                }
            }

            // Tạo chi tiết hoá đơn
            ChiTietHoaDon ct = new ChiTietHoaDon();
            ct.setHoaDon(hd);
            ct.setIdSeri(seri);
            ct.setCauHinhSanPham(cauHinh);
            ct.setDonGia(donGia);
            ct.setThanhTien(donGia);
            ct.setTrangThai(1);
            Integer ctId = chiTietHoaDonRepo.add(ct);

            // Đánh dấu seri đã được giữ (trangThai = 1)
            seri.setTrangThai(1);
            maSeriRepository.update(seri);

            // Cập nhật tổng tiền hoá đơn
            capNhatTongTien(idHoaDon);

            jsonOk(resp, "{\"success\":true,\"chiTietId\":" + ctId + ",\"donGia\":" + donGia + "}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi thêm seri: " + e.getMessage());
        }
    }

    // =====================================================================
    //  API: POST /hoa-don/api/xoa-seri
    //  Xoá một chi tiết hoá đơn (theo idChiTiet)
    // =====================================================================
    private void apiXoaSeri(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idChiTiet = Integer.parseInt(req.getParameter("idChiTiet"));
            ChiTietHoaDon ct = chiTietHoaDonRepo.getOne(idChiTiet);
            if (ct == null) { jsonErr(resp, 404, "Không tìm thấy chi tiết"); return; }

            int idHoaDon = ct.getHoaDon().getId();

            // Hoàn trạng thái seri về 0
            MaSeri seri = ct.getIdSeri();
            if (seri != null) {
                seri.setTrangThai(0);
                maSeriRepository.update(seri);
            }
            chiTietHoaDonRepo.delete(idChiTiet);
            capNhatTongTien(idHoaDon);

            jsonOk(resp, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi xoá seri: " + e.getMessage());
        }
    }

    // =====================================================================
    //  API: POST /hoa-don/api/cap-nhat-khach
    //  Gán / bỏ khách hàng khỏi hoá đơn
    // =====================================================================
    private void apiCapNhatKhach(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon = Integer.parseInt(req.getParameter("idHoaDon"));
            String idKhParam = req.getParameter("idKhachHang");

            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }

            if (idKhParam == null || idKhParam.trim().isEmpty()) {
                hd.setKhachHang(null);
                hd.setTenKhachHang(null);
                hd.setSdtKhachHang(null);
            } else {
                KhachHang kh = khachHangRepo.getOne(Integer.parseInt(idKhParam));
                if (kh == null) { jsonErr(resp, 404, "Không tìm thấy khách hàng"); return; }
                hd.setKhachHang(kh);
                hd.setTenKhachHang(kh.getTenKhachHang());
                hd.setSdtKhachHang(kh.getSdt());
            }
            hoaDonRepository.update(hd);
            jsonOk(resp, "{\"success\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi cập nhật khách hàng: " + e.getMessage());
        }
    }

    // =====================================================================
    //  API: GET /hoa-don/api/chi-tiet?id=X
    //  Trả về JSON danh sách chi tiết hoá đơn + tổng tiền
    // =====================================================================
    private void apiChiTiet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon = Integer.parseInt(req.getParameter("id"));
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }

            List<ChiTietHoaDon> list = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            StringBuilder sb = new StringBuilder();
            sb.append("{\"idHoaDon\":").append(idHoaDon)
              .append(",\"maHoaDon\":\"").append(hd.getMaHoaDon()).append("\"")
              .append(",\"tongTien\":").append(hd.getTongTien() != null ? hd.getTongTien() : 0)
              .append(",\"idKhachHang\":").append(hd.getKhachHang() != null ? hd.getKhachHang().getId() : "null")
              .append(",\"tenKhachHang\":\"").append(hd.getKhachHang() != null ? hd.getKhachHang().getTenKhachHang() : "").append("\"")
              .append(",\"sdtKhachHang\":\"").append(hd.getSdtKhachHang() != null ? hd.getSdtKhachHang() : "").append("\"")
              .append(",\"items\":[");

            for (int i = 0; i < list.size(); i++) {
                ChiTietHoaDon ct = list.get(i);
                MaSeri seri = ct.getIdSeri();
                CauHinhSanPham ch = ct.getCauHinhSanPham();

                String soSeri  = seri != null ? seri.getSoSeri() : "";
                String tenSP   = "";
                String cpu     = "";
                String ram     = "";
                String gpu     = "";
                String storage = "";
                String mauSac  = "";
                String thuongHieu = "";

                if (ch != null) {
                    try { if (ch.getSanPham()  != null) { tenSP = ch.getSanPham().getTenSanPham(); } } catch(Exception e2) {}
                    try { if (ch.getCpu()      != null) { cpu = ch.getCpu().getTenCpu(); } } catch(Exception e2) {}
                    try { if (ch.getRam()      != null) { ram = ch.getRam().getDungLuongRam(); } } catch(Exception e2) {}
                    try { if (ch.getGpu()      != null) { gpu = ch.getGpu().getTenGpu(); } } catch(Exception e2) {}
                    try { if (ch.getOCung()    != null) { storage = ch.getOCung().getDungLuongOCung(); } } catch(Exception e2) {}
                    try { if (ch.getMauSac()   != null) { mauSac = ch.getMauSac().getTenMauSac(); } } catch(Exception e2) {}
                    try { if (ch.getSanPham()  != null && ch.getSanPham().getThuongHieu() != null) {
                            thuongHieu = ch.getSanPham().getThuongHieu().getTenThuongHieu();
                        } } catch(Exception e2) {}
                }

                sb.append("{\"id\":").append(ct.getId())
                  .append(",\"soSeri\":\"").append(soSeri.replace("\"","'")).append("\"")
                  .append(",\"tenSanPham\":\"").append(tenSP.replace("\"","'")).append("\"")
                  .append(",\"donGia\":").append(ct.getDonGia() != null ? ct.getDonGia() : 0)
                  .append(",\"cpu\":\"").append(cpu.replace("\"","'")).append("\"")
                  .append(",\"ram\":\"").append(ram.replace("\"","'")).append("\"")
                  .append(",\"gpu\":\"").append(gpu.replace("\"","'")).append("\"")
                  .append(",\"storage\":\"").append(storage.replace("\"","'")).append("\"")
                  .append(",\"mauSac\":\"").append(mauSac.replace("\"","'")).append("\"")
                  .append(",\"thuongHieu\":\"").append(thuongHieu.replace("\"","'")).append("\"")
                  .append("}");
                if (i < list.size() - 1) sb.append(",");
            }
            sb.append("]}");
            jsonOk(resp, sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi lấy chi tiết: " + e.getMessage());
        }
    }

    // =====================================================================
    //  API: POST /hoa-don/api/thanh-toan
    //  Xác nhận thanh toán, cập nhật đầy đủ hoá đơn → trangThai=1
    // =====================================================================
    private void apiThanhToan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int idHoaDon         = Integer.parseInt(req.getParameter("idHoaDon"));
            int idHinhThuc       = Integer.parseInt(req.getParameter("idHinhThuc"));
            BigDecimal tienKhachTra = new BigDecimal(req.getParameter("tienKhachTra"));

            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd == null) { jsonErr(resp, 404, "Không tìm thấy hoá đơn"); return; }

            // Tính lại tổng tiền từ chi tiết để đảm bảo chính xác
            capNhatTongTien(idHoaDon);
            hd = hoaDonRepository.getOne(idHoaDon); // reload sau khi cập nhật

            BigDecimal tongTien = hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO;

            if (tienKhachTra.compareTo(tongTien) < 0) {
                jsonErr(resp, 400, "Tiền khách đưa không đủ");
                return;
            }

            BigDecimal tienThua = tienKhachTra.subtract(tongTien);
            HinhThucThanhToan hinhThuc = hinhThucThanhToanRepo.getOne(idHinhThuc);
            NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVien");

            hd.setHinhThucThanhToan(hinhThuc);
            hd.setTienKhachTra(tienKhachTra);
            hd.setTienThua(tienThua);
            hd.setNgayLap(Date.valueOf(LocalDate.now()));
            hd.setTrangThai(1);  // Đã thanh toán
            if (nv != null) hd.setNhanVien(nv);
            hoaDonRepository.update(hd);

            // Đánh dấu tất cả seri trong đơn là đã bán (trangThai=1)
            List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            for (ChiTietHoaDon ct : dsCT) {
                if (ct.getIdSeri() != null) {
                    MaSeri seri = ct.getIdSeri();
                    seri.setTrangThai(1);
                    maSeriRepository.update(seri);
                }
            }

            // Ghi lịch sử thanh toán
            LichSuThanhToan lstt = new LichSuThanhToan();
            lstt.setHoaDon(hd);
            lstt.setPhuongThucThanhToan(hinhThuc != null ? hinhThuc.getTenHinhThuc() : "");
            lstt.setSoTien(tienKhachTra);
            lstt.setNgayThanhToan(new java.util.Date());
            lstt.setTrangThaiThanhToan(1);
            lstt.setTrangThai(1);
            lichSuThanhToanRepo.add(lstt);

            // Ghi lịch sử hoá đơn
            LichSuHoaDon lshd = new LichSuHoaDon();
            lshd.setHoaDon(hd);
            lshd.setNgayTao(new java.util.Date());
            lshd.setGhiChu("Xác nhận thanh toán tại quầy");
            lshd.setTrangThai(1);
            lichSuHoaDonRepo.add(lshd);

            jsonOk(resp, "{\"success\":true,\"maHoaDon\":\"" + hd.getMaHoaDon() + "\""
                    + ",\"tienThua\":" + tienThua + "}");
        } catch (Exception e) {
            e.printStackTrace();
            jsonErr(resp, 500, "Lỗi thanh toán: " + e.getMessage());
        }
    }

    // =====================================================================
    //  HELPER: cập nhật lại tổng tiền của một hoá đơn
    // =====================================================================
    private void capNhatTongTien(int idHoaDon) {
        try {
            List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(idHoaDon);
            BigDecimal tong = BigDecimal.ZERO;
            for (ChiTietHoaDon ct : dsCT) {
                if (ct.getDonGia() != null) tong = tong.add(ct.getDonGia());
            }
            HoaDon hd = hoaDonRepository.getOne(idHoaDon);
            if (hd != null) {
                hd.setTongTien(tong);
                hoaDonRepository.update(hd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================================================================
    //  Trang bán hàng - load dữ liệu cho JSP
    // =====================================================================
    private void banhang(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ChiTietSanPham> listSanPham      = chiTietSanPhamRepository.getAll();
        List<KhachHang> listKhachHang          = khachHangRepo.getAll();
        List<MaSeri> listMaSeri                = maSeriRepository.getAll();
        List<HinhThucThanhToan> listHinhThuc   = hinhThucThanhToanRepo.getAll();
        List<HoaDon> listHoaDonCho             = hoaDonRepository.getHoaDonCho();

        req.setAttribute("listSanPham",          listSanPham);
        req.setAttribute("listKhachHang",         listKhachHang);
        req.setAttribute("listMaSeri",            listMaSeri);
        req.setAttribute("listHinhThucThanhToan", listHinhThuc);
        req.setAttribute("listHoaDonCho",         listHoaDonCho);
        req.getRequestDispatcher("/demo/hoa_don/ban_hang.jsp").forward(req, resp);
    }

    private void printview(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            Integer id = Integer.valueOf(idParam);
            HoaDon hoaDon = hoaDonRepository.getOneWithDetails(id);
            if (hoaDon == null) { resp.sendError(404); return; }
            KhachHang khachHang = hoaDon.getKhachHang();
            DiaChiKhachHang diaChiHienThi = null;
            if (khachHang != null && khachHang.getDiaChiKhachHang() != null
                    && !khachHang.getDiaChiKhachHang().isEmpty()) {
                diaChiHienThi = khachHang.getDiaChiKhachHang().get(0);
            }
            req.setAttribute("diaChi",    diaChiHienThi);
            req.setAttribute("hoaDon",    hoaDon);
            req.setAttribute("khachHang", khachHang);
            req.getRequestDispatcher("/demo/hoa_don/in_hoa_don.jsp").forward(req, resp);
        }
    }

    private void detail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer id = Integer.valueOf(req.getParameter("id"));
        HoaDon hoaDon = hoaDonRepository.getOneWithDetails(id);
        if (hoaDon == null) {
            resp.sendError(404, "Không tìm thấy hoá đơn");
            return;
        }
        KhachHang khachHang = hoaDon.getKhachHang();
        DiaChiKhachHang diaChiHienThi = null;
        if (khachHang != null && khachHang.getDiaChiKhachHang() != null
                && !khachHang.getDiaChiKhachHang().isEmpty()) {
            diaChiHienThi = khachHang.getDiaChiKhachHang().get(0);
        }
        req.setAttribute("diaChi",    diaChiHienThi);
        req.setAttribute("hoaDon",    hoaDon);
        req.setAttribute("khachHang", khachHang);
        req.getRequestDispatcher("/demo/hoa_don/chi_tiet_hoa_don.jsp").forward(req, resp);
    }

    private void viewUpdate(HttpServletRequest req, HttpServletResponse resp) {}
    private void update(HttpServletRequest req, HttpServletResponse resp) {}
    private void add(HttpServletRequest req, HttpServletResponse resp) {}
    private void hienthi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword   = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        String ngayTao   = req.getParameter("ngayTao");
        boolean isFiltered = "true".equals(req.getParameter("filtered"));
        if (!isFiltered) ngayTao = java.time.LocalDate.now().toString();

        List<HoaDon> ListHoaDon = hoaDonRepository.timKiemVaLoc(keyword, trangThai, ngayTao);
        req.setAttribute("oldNgayTao",   ngayTao);
        req.setAttribute("oldKeyword",   keyword   != null ? keyword   : "");
        req.setAttribute("oldTrangThai", trangThai != null ? trangThai : "");
        req.setAttribute("isFiltered",   isFiltered);
        req.setAttribute("ListHoaDon",   ListHoaDon);
        req.getRequestDispatcher("/demo/hoa_don/hoa_don.jsp").forward(req, resp);
    }

    private void export(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword   = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        String ngayTao   = req.getParameter("ngayTao");
        boolean isFiltering = (keyword != null && !keyword.trim().isEmpty()) ||
                (trangThai != null && !trangThai.trim().isEmpty()) ||
                (ngayTao != null && !ngayTao.trim().isEmpty());
        List<HoaDon> listHoaDon = isFiltering
                ? hoaDonRepository.timKiemVaLoc(keyword, trangThai, ngayTao)
                : hoaDonRepository.getAllHoaDon();

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Danh_Sach_Hoa_Don");
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("STT");
        headerRow.createCell(1).setCellValue("Mã Hóa Đơn");
        headerRow.createCell(2).setCellValue("Khách Hàng");
        headerRow.createCell(3).setCellValue("Số Điện Thoại");
        headerRow.createCell(4).setCellValue("Ngày Tạo");
        headerRow.createCell(5).setCellValue("Tổng Tiền");
        headerRow.createCell(6).setCellValue("Trạng Thái");
        int rowNum = 1;
        for (HoaDon hd : listHoaDon) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rowNum - 1);
            row.createCell(1).setCellValue(hd.getMaHoaDon() != null ? hd.getMaHoaDon() : "");
            row.createCell(2).setCellValue(hd.getKhachHang() != null ? hd.getKhachHang().getTenKhachHang() : "");
            row.createCell(3).setCellValue(hd.getKhachHang() != null ? hd.getKhachHang().getSdt() : "");
            row.createCell(4).setCellValue(hd.getNgayLap() != null ? hd.getNgayLap().toString() : "");
            row.createCell(5).setCellValue(hd.getTongTien() != null ? hd.getTongTien().doubleValue() : 0);
            String trangThaiStr = (hd.getTrangThai() != null && hd.getTrangThai() == 1) ? "Đã thanh toán" : "Chưa thanh toán";
            row.createCell(6).setCellValue(trangThaiStr);
        }
        for (int i = 0; i < 7; i++) sheet.autoSizeColumn(i);
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"DanhSachHoaDon.xlsx\"");
        workbook.write(resp.getOutputStream());
        workbook.close();
    }
}
