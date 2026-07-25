package demo.servlet;

import demo.entity.san_pham.*;
import demo.repository.san_pham.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ThuocTinhSanPhamServlet", value = {
        // Hiển thị danh sách
        "/thuoc-tinh/cpu/hien-thi",
        "/thuoc-tinh/ram/hien-thi",
        "/thuoc-tinh/o-cung/hien-thi",
        "/thuoc-tinh/gpu/hien-thi",
        "/thuoc-tinh/man-hinh/hien-thi",
        "/thuoc-tinh/mau-sac/hien-thi",
        "/thuoc-tinh/pin/hien-thi",
        "/thuoc-tinh/danh-muc/hien-thi",
        "/thuoc-tinh/thuong-hieu/hien-thi",

        // Chức năng Xóa
        "/thuoc-tinh/cpu/xoa",
        "/thuoc-tinh/ram/xoa",
        "/thuoc-tinh/o-cung/xoa",
        "/thuoc-tinh/gpu/xoa",
        "/thuoc-tinh/man-hinh/xoa",
        "/thuoc-tinh/mau-sac/xoa",
        "/thuoc-tinh/pin/xoa",
        "/thuoc-tinh/danh-muc/xoa",
        "/thuoc-tinh/thuong-hieu/xoa",

        // Chức năng Thêm mới
        "/thuoc-tinh/cpu/them",
        "/thuoc-tinh/ram/them",
        "/thuoc-tinh/o-cung/them",
        "/thuoc-tinh/gpu/them",
        "/thuoc-tinh/man-hinh/them",
        "/thuoc-tinh/mau-sac/them",
        "/thuoc-tinh/pin/them",
        "/thuoc-tinh/danh-muc/them",
        "/thuoc-tinh/thuong-hieu/them"
})
public class ThuocTinhSanPhamServlet extends HttpServlet {
    private final CpuRepository cpuRepo = new CpuRepository();
    private final RamRepository ramRepo = new RamRepository();
    private final OCungRepository oCungRepo = new OCungRepository();
    private final GpuRepository gpuRepo = new GpuRepository();
    private final ManHinhRepository manHinhRepo = new ManHinhRepository();
    private final MauSacRepository mauSacRepo = new MauSacRepository();
    private final PinRepository pinRepo = new PinRepository();
    private final ThuongHieuRepository thuongHieuRepo = new ThuongHieuRepository();
    private final DanhMucRepository danhMucRepo = new DanhMucRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("/thuoc-tinh/cpu/hien-thi")) this.cpuHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/ram/hien-thi")) this.ramHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/o-cung/hien-thi")) this.oCungHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/gpu/hien-thi")) this.gpuHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/man-hinh/hien-thi")) this.manHinhHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/mau-sac/hien-thi")) this.mauSacHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/pin/hien-thi")) this.pinHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/thuong-hieu/hien-thi")) this.thuongHieuHienThi(req, resp);
        else if (uri.contains("/thuoc-tinh/danh-muc/hien-thi")) this.danhMucHienThi(req, resp);

        else if (uri.contains("/thuoc-tinh/cpu/xoa")) this.cpuXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/ram/xoa")) this.ramXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/o-cung/xoa")) this.oCungXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/gpu/xoa")) this.gpuXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/man-hinh/xoa")) this.manHinhXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/mau-sac/xoa")) this.mauSacXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/pin/xoa")) this.pinXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/danh-muc/xoa")) this.danhMucXoa(req, resp);
        else if (uri.contains("/thuoc-tinh/thuong-hieu/xoa")) this.thuongHieuXoa(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        HttpSession session = req.getSession();

        try {
            if (uri.contains("/thuoc-tinh/cpu/them")) {
                Cpu obj = new Cpu();
                obj.setTenCpu(req.getParameter("tenCpu"));
                obj.setTheHeCpu(req.getParameter("theHeCpu"));
                obj.setTrangThai(true);
                cpuRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới cấu hình CPU thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/cpu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/ram/them")) {
                Ram obj = new Ram();
                obj.setTenRam(req.getParameter("tenRam"));
                obj.setDungLuongRam(req.getParameter("dungLuongRam"));
                obj.setTrangThai(true);
                ramRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới cấu hình RAM thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/ram/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/o-cung/them")) {
                OCung obj = new OCung();
                obj.setTenOCung(req.getParameter("tenOCung"));
                obj.setDungLuongOCung(req.getParameter("dungLuongOCung"));
                obj.setTrangThai(true);
                oCungRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Ổ cứng thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/o-cung/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/gpu/them")) {
                Gpu obj = new Gpu();
                obj.setTenGpu(req.getParameter("tenGPU"));
                obj.setDungLuongGpu(req.getParameter("dungLuongGPU"));
                obj.setTrangThai(true);
                gpuRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Card đồ họa (GPU) thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/gpu/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/man-hinh/them")) {
                ManHinh obj = new ManHinh();
                obj.setTenManHinh(req.getParameter("tenManHinh"));
                obj.setKichThuoc(req.getParameter("kichThuoc"));
                obj.setDoPhanGiai(req.getParameter("doPhanGiai"));
                obj.setTanSoQuet(req.getParameter("tanSoQuet"));
                obj.setTrangThai(true);
                manHinhRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Màn hình thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/man-hinh/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/mau-sac/them")) {
                MauSac obj = new MauSac();
                obj.setTenMauSac(req.getParameter("tenMauSac"));
                obj.setTrangThai(true);
                mauSacRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Màu sắc thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/mau-sac/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/pin/them")) {
                Pin obj = new Pin();
                obj.setTenPin(req.getParameter("tenPin"));
                obj.setDungLuongPin(req.getParameter("dungLuongPin"));
                obj.setTrangThai(true);
                pinRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Pin thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/pin/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/danh-muc/them")) {
                DanhMuc obj = new DanhMuc();
                obj.setTenDanhMuc(req.getParameter("tenDanhMuc"));
                obj.setTrangThai(true);
                danhMucRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Danh mục sản phẩm thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/danh-muc/hien-thi");
            }
            else if (uri.contains("/thuoc-tinh/thuong-hieu/them")) {
                ThuongHieu obj = new ThuongHieu();
                obj.setTenThuongHieu(req.getParameter("tenThuongHieu"));
                obj.setTrangThai(true);
                thuongHieuRepo.add(obj);
                session.setAttribute("successMessage", "Thêm mới Thương hiệu/Hãng thành công!");
                resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/thuong-hieu/hien-thi");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi nghiêm trọng khi thêm mới dữ liệu thuộc tính!");
            resp.sendRedirect(req.getContextPath() + "/san-pham/hien-thi");
        }
    }


    public void cpuHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listCpu", cpuRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/cpu/cpu-index.jsp").forward(req, resp);
    }

    public void ramHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listRam", ramRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/ram/ram-index.jsp").forward(req, resp);
    }

    public void oCungHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listOCung", oCungRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/o-cung/o-cung-index.jsp").forward(req, resp);
    }

    public void gpuHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listGpu", gpuRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/gpu/gpu-index.jsp").forward(req, resp);
    }

    public void manHinhHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listManHinh", manHinhRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/man-hinh/man-hinh-index.jsp").forward(req, resp);
    }

    public void mauSacHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listMauSac", mauSacRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/mau-sac/mau-sac-index.jsp").forward(req, resp);
    }

    public void pinHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listPin", pinRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/pin/pin-index.jsp").forward(req, resp);
    }

    public void thuongHieuHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listThuongHieu", thuongHieuRepo.getAll());
        req.getRequestDispatcher("demo/san_pham/thuoc-tinh/thuong-hieu/thuong-hieu-index.jsp").forward(req, resp);
    }

    public void danhMucHienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listDanhMuc", danhMucRepo.getAll());
        req.getRequestDispatcher("/demo/san_pham/thuoc-tinh/danh-muc/danh-muc-index.jsp").forward(req, resp);
    }

    public void cpuXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Cpu obj = cpuRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); cpuRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/cpu/hien-thi");
    }

    public void ramXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Ram obj = ramRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); ramRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/ram/hien-thi");
    }

    public void oCungXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            OCung obj = oCungRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); oCungRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/o-cung/hien-thi");
    }

    public void gpuXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Gpu obj = gpuRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); gpuRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/gpu/hien-thi");
    }

    public void manHinhXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            ManHinh obj = manHinhRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); manHinhRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/man-hinh/hien-thi");
    }

    public void mauSacXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            MauSac obj = mauSacRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); mauSacRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/mau-sac/hien-thi");
    }

    public void pinXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Pin obj = pinRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); pinRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/pin/hien-thi");
    }

    public void danhMucXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            DanhMuc obj = danhMucRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); danhMucRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/danh-muc/hien-thi");
    }

    public void thuongHieuXoa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            ThuongHieu obj = thuongHieuRepo.getOne(Integer.valueOf(req.getParameter("id")));
            if (obj != null) { obj.setTrangThai(false); thuongHieuRepo.update(obj); }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/thuoc-tinh/thuong-hieu/hien-thi");
    }
}