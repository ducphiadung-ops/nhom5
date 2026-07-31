package demo.servlet;

import demo.entity.san_pham.*;
import demo.repository.san_pham.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "ChiTietSanPhamServlet", value = {
        "/san-pham-chi-tiet/hien-thi",
        "/san-pham-chi-tiet/detail",
        "/san-pham-chi-tiet/them",
        "/san-pham-chi-tiet/xoa",
        "/san-pham-chi-tiet/sua",
        "/san-pham-chi-tiet/imei-sua",
        "/san-pham-chi-tiet/imei-xoa"
})
@MultipartConfig
public class ChiTietSanPhamServlet extends HttpServlet {
    private final ChiTietSanPhamRepository ctspRepo = new ChiTietSanPhamRepository();
    private final MaSeriRepository maSeriRepo = new MaSeriRepository();
    private final SanPhamRepository sanPhamRepo = new SanPhamRepository();
    private final CauHinhSanPhamRepository cauHinhRepo = new CauHinhSanPhamRepository();
    private final CpuRepository cpuRepo = new CpuRepository();
    private final GpuRepository gpuRepo = new GpuRepository();
    private final ManHinhRepository manHinhRepo = new ManHinhRepository();
    private final PinRepository pinRepo = new PinRepository();
    private final MauSacRepository mauSacRepo = new MauSacRepository();
    private final RamRepository ramRepo = new RamRepository();
    private final OCungRepository oCungRepo = new OCungRepository();

    private final PhieuNhapRepository phieuNhapRepo = new PhieuNhapRepository();
    private final ChiTietPhieuNhapRepository chiTietPhieuNhapRepo = new ChiTietPhieuNhapRepository();
    private final NhaCungCapRepository nhaCungCapRepo = new NhaCungCapRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Nhân viên không được vào trang sửa biến thể
        if (path.equals("/san-pham-chi-tiet/sua")) {
            Object nvObj = req.getSession(false) != null ? req.getSession().getAttribute("nhanVien") : null;
            demo.entity.nhan_vien.NhanVien nv = (nvObj instanceof demo.entity.nhan_vien.NhanVien)
                    ? (demo.entity.nhan_vien.NhanVien) nvObj : null;
            if (LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null)) {
                resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
                return;
            }
        }

        if (path.equals("/san-pham-chi-tiet/detail")) {
            xuLyHienThiDetail(req, resp);
        } else if (path.equals("/san-pham-chi-tiet/sua")) {
            xuLyHienThiFormSua(req, resp);
        } else {
            hienThiDanhSachGiaoDien(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Nhân viên không được thêm/sửa/xóa biến thể hoặc IMEI
        Object nvObjPost = req.getSession(false) != null ? req.getSession().getAttribute("nhanVien") : null;
        demo.entity.nhan_vien.NhanVien nv = (nvObjPost instanceof demo.entity.nhan_vien.NhanVien)
                ? (demo.entity.nhan_vien.NhanVien) nvObjPost : null;
        boolean isNhanVien = LoginServlet.isNhanVienRole(nv != null ? nv.getChucVu() : null);
        if (isNhanVien) {
            req.getSession().setAttribute("errorMessage", "Bạn không có quyền thực hiện thao tác này.");
            resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
            return;
        }

        if (path.equals("/san-pham-chi-tiet/them")) {
            xuLyThemMoiBienThe(req, resp);
        } else if (path.equals("/san-pham-chi-tiet/xoa")) {
            xuLyXoaBienThe(req, resp);
        } else if (path.equals("/san-pham-chi-tiet/sua")) {
            xuLyCapNhatBienThe(req, resp);
        } else if (path.equals("/san-pham-chi-tiet/imei-sua")) {
            xuLySuaImei(req, resp);
        } else if (path.equals("/san-pham-chi-tiet/imei-xoa")) {
            xuLyXoaImei(req, resp);
        }
    }

    private void xuLyXoaBienThe(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            ctspRepo.delete(id);
            session.setAttribute("successMessage", "Đã xóa biến thể thành công!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Xóa thất bại! Dữ liệu đang được sử dụng.");
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
    }

    private void xuLyThemMoiBienThe(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        List<String> imeiBiTrungBoQua = new ArrayList<>();
        try {
            Integer idSanPham = Integer.parseInt(req.getParameter("idSanPham"));
            SanPham sp = sanPhamRepo.getOne(idSanPham);

            Integer idCpu = Integer.parseInt(req.getParameter("idCpu"));
            Integer idGpu = Integer.parseInt(req.getParameter("idGpu"));
            Integer idManHinh = Integer.parseInt(req.getParameter("idManHinh"));
            Integer idPin = Integer.parseInt(req.getParameter("idPin"));
            String heDieuHanh = req.getParameter("heDieuHanh");

            String[] arrMauSac = req.getParameterValues("idMauSacDong");
            String[] arrRam = req.getParameterValues("idRamDong");
            String[] arrOCung = req.getParameterValues("idOCungDong");
            String[] arrGiaBan = req.getParameterValues("giaBanDong");
            String[] arrGiaNhap = req.getParameterValues("giaNhapDong");
            String[] arrSoSeri = req.getParameterValues("soSeriDong");

            if (arrMauSac != null && arrMauSac.length > 0) {

                Integer idNhaCungCapDuocChon = Integer.parseInt(req.getParameter("idNhaCungCapForm"));

                PhieuNhap phieuNhapAo = new PhieuNhap();
                phieuNhapAo.setIdNhaCungCap(idNhaCungCapDuocChon);
                phieuNhapAo.setNgayNhap(LocalDateTime.now());
                phieuNhapAo.setTongTien(BigDecimal.ZERO);
                phieuNhapRepo.add(phieuNhapAo);

                int tsTontonSanPhamCha = 0;

                for (int i = 0; i < arrMauSac.length; i++) {
                    Integer idMau = Integer.parseInt(arrMauSac[i]);
                    Integer idRam = Integer.parseInt(arrRam[i]);
                    Integer idOCung = Integer.parseInt(arrOCung[i]);

                    BigDecimal giaBan = (arrGiaBan != null && arrGiaBan.length > i && !arrGiaBan[i].trim().isEmpty())
                            ? new BigDecimal(arrGiaBan[i].trim()) : BigDecimal.ZERO;
                    BigDecimal giaNhap = (arrGiaNhap != null && arrGiaNhap.length > i && !arrGiaNhap[i].trim().isEmpty())
                            ? new BigDecimal(arrGiaNhap[i].trim()) : BigDecimal.ZERO;
                    String chuoiImei = (arrSoSeri != null && arrSoSeri.length > i) ? arrSoSeri[i] : "";

                    CauHinhSanPham ch = new CauHinhSanPham();
                    ch.setSanPham(sp);
                    ch.setCpu(cpuRepo.getOne(idCpu));
                    ch.setGpu(gpuRepo.getOne(idGpu));
                    ch.setManHinh(manHinhRepo.getOne(idManHinh));
                    ch.setPin(pinRepo.getOne(idPin));
                    ch.setHeDieuHanh(heDieuHanh);
                    ch.setMauSac(mauSacRepo.getOne(idMau));
                    ch.setRam(ramRepo.getOne(idRam));
                    ch.setOCung(oCungRepo.getOne(idOCung));
                    cauHinhRepo.add(ch);

                    String[] mangImei = new String[0];
                    if (chuoiImei != null && !chuoiImei.trim().isEmpty()) {
                        String cleanChuoi = chuoiImei.replaceAll("\\r\\n", "\n").replaceAll("\\r", "\n");
                        mangImei = cleanChuoi.split("[,\n]+");
                    }

                    Set<String> sessionUniqueCheck = new HashSet<>();
                    List<String> validImeisList = new ArrayList<>();

                    for (String imei : mangImei) {
                        String cleanImei = imei.trim();
                        if (cleanImei.isEmpty()) continue;

                        if (!sessionUniqueCheck.add(cleanImei) || maSeriRepo.checkTrungImei(cleanImei)) {
                            imeiBiTrungBoQua.add(cleanImei);
                            continue;
                        }
                        validImeisList.add(cleanImei);
                    }

                    int soLuongImeiHopLe = validImeisList.size();

                    ChiTietPhieuNhap ctpn = new ChiTietPhieuNhap();
                    ctpn.setPhieuNhap(phieuNhapAo);
                    ctpn.setCauHinhSanPham(ch);
                    ctpn.setSoLuong(soLuongImeiHopLe);
                    ctpn.setGiaNhap(giaNhap);
                    chiTietPhieuNhapRepo.add(ctpn);

                    ChiTietSanPham ctsp = new ChiTietSanPham();
                    ctsp.setSanPham(sp);
                    ctsp.setCauHinhSanPham(ch);
                    ctsp.setDonGia(giaBan);
                    ctsp.setGiaNhap(giaNhap);
                    ctsp.setTonKho(soLuongImeiHopLe);
                    ctsp.setTrangThai(1);
                    ctspRepo.add(ctsp);

                    for (String cleanImei : validImeisList) {
                        MaSeri maSeriObj = new MaSeri();
                        maSeriObj.setCauHinhSanPham(ch);
                        maSeriObj.setChiTietPhieuNhap(ctpn);
                        maSeriObj.setSoSeri(cleanImei);
                        maSeriObj.setNgayNhap(LocalDate.now());
                        maSeriObj.setTrangThai(1);
                        maSeriRepo.add(maSeriObj);
                    }

                    tsTontonSanPhamCha += soLuongImeiHopLe;
                }

                if (sp != null) {
                    // Đếm lại toàn bộ biến thể từ DB và ghi vào san_pham.so_luong_ton
                    ctspRepo.capNhatSoLuongTonSanPhamCha(sp.getId());
                }
            }

            if (!imeiBiTrungBoQua.isEmpty()) {
                session.setAttribute("errorMessage", "Đã lưu thành công các biến thể, tuy nhiên hệ thống bỏ qua " + imeiBiTrungBoQua.size() + " mã IMEI trùng lặp!");
            } else {
                session.setAttribute("successMessage", "Thêm mới biến thể SKU thành công!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi nghiêm trọng hệ thống khi thêm biến thể!");
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
    }

    private void xuLyHienThiDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                req.getSession().setAttribute("errorMessage", "Không nhận được tham số ID!");
                resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
                return;
            }

            Integer idChiTiet = Integer.parseInt(idStr);
            ChiTietSanPham chiTietObj = ctspRepo.getOne(idChiTiet);

            if (chiTietObj != null) {

                if (chiTietObj.getSanPham() != null) {
                    chiTietObj.getSanPham().getTenSanPham();
                }
                if (chiTietObj.getCauHinhSanPham() != null) {
                    CauHinhSanPham ch = chiTietObj.getCauHinhSanPham();
                    if (ch.getCpu() != null) ch.getCpu().getTenCpu();
                    if (ch.getRam() != null) ch.getRam().getDungLuongRam();
                    if (ch.getOCung() != null) ch.getOCung().getDungLuongOCung();
                    if (ch.getGpu() != null) ch.getGpu().getTenGpu();
                    if (ch.getManHinh() != null) ch.getManHinh().getTenManHinh();
                    if (ch.getMauSac() != null) ch.getMauSac().getTenMauSac();
                    if (ch.getPin() != null) ch.getPin().getTenPin();
                }

                req.setAttribute("chiTiet", chiTietObj);

                List<MaSeri> listImei = new ArrayList<>();
                if (chiTietObj.getCauHinhSanPham() != null) {
                    Integer idCauHinh = chiTietObj.getCauHinhSanPham().getId();
                    List<MaSeri> dbList = maSeriRepo.getByIdCauHinh(idCauHinh);
                    if (dbList != null) {
                        listImei = dbList;
                    }
                }
                req.setAttribute("listImei", listImei);
                req.getRequestDispatcher("/demo/san_pham/chi_tiet_bien_the.jsp").forward(req, resp);

            } else {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy dữ liệu biến thể trong Database!");
                resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
            }
        } catch (Exception e) {
            System.out.println("🚨 LỖI CRASH CHI TIẾT:");
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi crash hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
        }
    }

    private void hienThiDanhSachGiaoDien(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // --- lọc theo sản phẩm cha (đường dẫn từ trang danh sách SP) ---
            String idSanPhamStr = req.getParameter("idSanPham");
            if (idSanPhamStr == null || idSanPhamStr.trim().isEmpty()) {
                idSanPhamStr = req.getParameter("idDongMay");
            }

            // --- đọc tham số bộ lọc ---
            String tenSanPham  = req.getParameter("tenSanPham");
            String idCpuStr    = req.getParameter("idCpu");
            String idGpuStr    = req.getParameter("idGpu");
            String idMauSacStr = req.getParameter("idMauSac");
            String idRamStr    = req.getParameter("idRam");
            String idOCungStr  = req.getParameter("idOCung");
            String trangThaiStr = req.getParameter("trangThai");
            String giaMinStr   = req.getParameter("giaMin");
            String giaMaxStr   = req.getParameter("giaMax");

            Integer idCpu    = null; Integer idGpu    = null;
            Integer idMauSac = null; Integer idRam    = null;
            Integer idOCung  = null; Integer trangThai = null;
            java.math.BigDecimal giaMin = null, giaMax = null;

            try { if (idCpuStr    != null && !idCpuStr.isEmpty())    idCpu    = Integer.parseInt(idCpuStr);    } catch (Exception ignored) {}
            try { if (idGpuStr    != null && !idGpuStr.isEmpty())    idGpu    = Integer.parseInt(idGpuStr);    } catch (Exception ignored) {}
            try { if (idMauSacStr != null && !idMauSacStr.isEmpty()) idMauSac = Integer.parseInt(idMauSacStr); } catch (Exception ignored) {}
            try { if (idRamStr    != null && !idRamStr.isEmpty())    idRam    = Integer.parseInt(idRamStr);    } catch (Exception ignored) {}
            try { if (idOCungStr  != null && !idOCungStr.isEmpty())  idOCung  = Integer.parseInt(idOCungStr);  } catch (Exception ignored) {}
            try { if (trangThaiStr != null && !trangThaiStr.isEmpty()) trangThai = Integer.parseInt(trangThaiStr); } catch (Exception ignored) {}
            try { if (giaMinStr   != null && !giaMinStr.isEmpty())   giaMin   = new java.math.BigDecimal(giaMinStr); } catch (Exception ignored) {}
            try { if (giaMaxStr   != null && !giaMaxStr.isEmpty())   giaMax   = new java.math.BigDecimal(giaMaxStr); } catch (Exception ignored) {}

            List<ChiTietSanPham> listResult;

            if (idSanPhamStr != null && !idSanPhamStr.trim().isEmpty()) {
                // --- xem biến thể của 1 sản phẩm cụ thể ---
                Integer idSanPham = Integer.parseInt(idSanPhamStr);
                listResult = ctspRepo.findBySanPhamId(idSanPham);

                SanPham spCha = (!listResult.isEmpty()) ? listResult.get(0).getSanPham() : sanPhamRepo.getOne(idSanPham);
                if (spCha != null) {
                    req.setAttribute("tenDongMayHienTai", spCha.getTenSanPham());
                    req.setAttribute("maSanPhamHienTai",  spCha.getMaSanPham());
                    req.setAttribute("idSanPhamFilter",   idSanPham);
                }
            } else {
                // --- danh sách tất cả biến thể với bộ lọc ---
                boolean coLoc = (tenSanPham != null && !tenSanPham.isEmpty())
                        || idCpu != null || idGpu != null || idMauSac != null
                        || idRam != null || idOCung != null || trangThai != null
                        || giaMin != null || giaMax != null;

                if (coLoc) {
                    listResult = ctspRepo.locDaKieu(tenSanPham, idCpu, idGpu, idMauSac, idRam, idOCung, trangThai, giaMin, giaMax);
                } else {
                    listResult = ctspRepo.getAll();
                }
            }

            req.setAttribute("listChiTiet", listResult);

            // --- min/max giá để render thanh kéo ---
            java.math.BigDecimal[] minMax = ctspRepo.getMinMaxDonGia();
            req.setAttribute("priceAbsMin",     minMax[0].longValue());
            req.setAttribute("priceAbsMax",     minMax[1].longValue());
            req.setAttribute("priceCurrentMax", giaMax != null ? giaMax.longValue() : minMax[1].longValue());

            // --- giữ lại giá trị form cũ ---
            req.setAttribute("oldTenSanPham",  tenSanPham  != null ? tenSanPham  : "");
            req.setAttribute("oldIdCpu",       idCpu);
            req.setAttribute("oldIdGpu",       idGpu);
            req.setAttribute("oldIdMauSac",    idMauSac);
            req.setAttribute("oldIdRam",       idRam);
            req.setAttribute("oldIdOCung",     idOCung);
            req.setAttribute("oldTrangThai",   trangThaiStr != null ? trangThaiStr : "");
            req.setAttribute("oldGiaMin",      giaMin  != null ? giaMin.longValue()  : minMax[0].longValue());
            req.setAttribute("oldGiaMax",      giaMax  != null ? giaMax.longValue()  : minMax[1].longValue());

            // --- danh sách thuộc tính cho select box (chỉ lấy đang hoạt động trangThai=1) ---
            try { req.setAttribute("listCpuFilter",    cpuRepo.getAll());    } catch (Exception e) { req.setAttribute("listCpuFilter",    new ArrayList<>()); }
            try { req.setAttribute("listGpuFilter",    gpuRepo.getAll());    } catch (Exception e) { req.setAttribute("listGpuFilter",    new ArrayList<>()); }
            try { req.setAttribute("listMauSacFilter", mauSacRepo.getAll()); } catch (Exception e) { req.setAttribute("listMauSacFilter", new ArrayList<>()); }
            try { req.setAttribute("listRamFilter",    ramRepo.getAllDistinctByDungLuong());  } catch (Exception e) { req.setAttribute("listRamFilter",    new ArrayList<>()); }
            try { req.setAttribute("listOCungFilter",  oCungRepo.getAllDistinctByDungLuong()); } catch (Exception e) { req.setAttribute("listOCungFilter",  new ArrayList<>()); }

        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/demo/san_pham/san_pham_chi_tiet.jsp").forward(req, resp);
    }

    private void xuLyHienThiFormSua(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            ChiTietSanPham chiTiet = ctspRepo.getOne(id);
            if (chiTiet == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy biến thể cần sửa!");
                resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
                return;
            }
            req.setAttribute("chiTiet", chiTiet);
            req.getRequestDispatcher("/demo/san-pham/sua-bien-the.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
        }
    }

    private void xuLyCapNhatBienThe(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            ChiTietSanPham chiTiet = ctspRepo.getOne(id);

            if (chiTiet == null) {
                session.setAttribute("errorMessage", "Không tìm thấy biến thể!");
                resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
                return;
            }

            BigDecimal donGia = new BigDecimal(req.getParameter("donGia"));
            BigDecimal giaNhap = new BigDecimal(req.getParameter("giaNhap"));
            Integer trangThai = "true".equalsIgnoreCase(req.getParameter("trangThai")) ? 1 : 0;

            chiTiet.setDonGia(donGia);
            chiTiet.setGiaNhap(giaNhap);
            chiTiet.setTrangThai(trangThai);

            ctspRepo.update(chiTiet);
            session.setAttribute("successMessage", "Cập nhật biến thể thành công!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi cập nhật biến thể!");
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/hien-thi");
    }

    private void xuLySuaImei(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer idChiTiet = null;
        try {
            Integer idImei = Integer.parseInt(req.getParameter("idImei"));
            String soSeriMoi = req.getParameter("soSeriMoi");
            idChiTiet = Integer.parseInt(req.getParameter("idChiTiet"));

            if (soSeriMoi == null || soSeriMoi.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Số IMEI không được để trống!");
            } else {
                String cleanSoSeri = soSeriMoi.trim();
                MaSeri maSeriHienTai = maSeriRepo.getOne(idImei);

                boolean coThayDoi = maSeriHienTai != null && !cleanSoSeri.equalsIgnoreCase(maSeriHienTai.getSoSeri());
                if (coThayDoi && maSeriRepo.checkTrungImei(cleanSoSeri)) {
                    session.setAttribute("errorMessage", "Số IMEI '" + cleanSoSeri + "' đã tồn tại!");
                } else {
                    maSeriRepo.updateSoSeri(idImei, cleanSoSeri);
                    session.setAttribute("successMessage", "Cập nhật mã IMEI thành công!");
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi sửa mã IMEI!");
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/detail?id=" + idChiTiet);
    }

    private void xuLyXoaImei(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer idChiTiet = null;
        try {
            Integer idImei = Integer.parseInt(req.getParameter("idImei"));
            idChiTiet = Integer.parseInt(req.getParameter("idChiTiet"));

            MaSeri maSeri = maSeriRepo.getOne(idImei);
            if (maSeri != null) {
                Integer idCauHinh = maSeri.getCauHinhSanPham().getId();
                maSeriRepo.huyKichHoat(idImei);
                ctspRepo.capNhatTonKhoTheoImei(idCauHinh);
                session.setAttribute("successMessage", "Đã loại bỏ mã IMEI khỏi kho!");
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy mã IMEI!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi xóa mã IMEI!");
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/san-pham-chi-tiet/detail?id=" + idChiTiet);
    }
}