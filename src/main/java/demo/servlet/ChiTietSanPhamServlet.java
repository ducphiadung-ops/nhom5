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
            Integer hanBaoHanh = Integer.parseInt(req.getParameter("hanBaoHanh"));

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
                    ctsp.setHanBaoHanh(hanBaoHanh);
                    ctsp.setTrangThai(true);
                    ctspRepo.add(ctsp);

                    for (String cleanImei : validImeisList) {
                        MaSeri maSeriObj = new MaSeri();
                        maSeriObj.setCauHinhSanPham(ch);
                        maSeriObj.setChiTietPhieuNhap(ctpn);
                        maSeriObj.setSoSeri(cleanImei);
                        maSeriObj.setNgayNhap(LocalDate.now());
                        maSeriObj.setTrangThai(true);
                        maSeriRepo.add(maSeriObj);
                    }

                    tsTontonSanPhamCha += soLuongImeiHopLe;
                }

                if (sp != null) {
                    sp.setSoLuongTon(sp.getSoLuongTon() + tsTontonSanPhamCha);
                    sanPhamRepo.update(sp);
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
            String idDongMayStr = req.getParameter("idDongMay");
            List<ChiTietSanPham> listResult;

            if (idDongMayStr != null && !idDongMayStr.trim().isEmpty()) {
                Integer idDongMay = Integer.parseInt(idDongMayStr);
                listResult = ctspRepo.findBySanPhamId(idDongMay);
                if (!listResult.isEmpty()) {
                    req.setAttribute("tenDongMayHienTai", listResult.get(0).getSanPham().getTenSanPham());
                } else {
                    SanPham spCha = sanPhamRepo.getOne(idDongMay);
                    if (spCha != null) req.setAttribute("tenDongMayHienTai", spCha.getTenSanPham());
                }
            } else {
                listResult = ctspRepo.getAll();
            }
            req.setAttribute("listChiTiet", listResult);
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
            Integer hanBaoHanh = Integer.parseInt(req.getParameter("hanBaoHanh"));
            Boolean trangThai = "true".equalsIgnoreCase(req.getParameter("trangThai"));

            chiTiet.setDonGia(donGia);
            chiTiet.setGiaNhap(giaNhap);
            chiTiet.setHanBaoHanh(hanBaoHanh);
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