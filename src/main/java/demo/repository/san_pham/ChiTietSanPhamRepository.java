package demo.repository.san_pham;


import demo.entity.san_pham.CauHinhSanPham;
import demo.entity.san_pham.ChiTietSanPham;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class ChiTietSanPhamRepository {

    public ChiTietSanPhamRepository() {
    }

    public ChiTietSanPham getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Step 1: Dùng HQL đơn giản nhất, chỉ FETCH sang Sản phẩm và Cấu hình
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE ct.id = :id";

            ChiTietSanPham ct = session.createQuery(hql, ChiTietSanPham.class)
                    .setParameter("id", id)
                    .uniqueResult();

            // Step 2: Nếu tìm thấy, chủ động kích hoạt (Lazy Load) an toàn các thuộc tính con
            if (ct != null && ct.getCauHinhSanPham() != null) {
                CauHinhSanPham ch = ct.getCauHinhSanPham();

                // Dùng các khối try-catch bọc từng linh kiện, lỗi linh kiện nào cũng không sợ sập dây chuyền
                try { if (ch.getCpu() != null) ch.getCpu().getTenCpu(); } catch (Exception e) {}
                try { if (ch.getRam() != null) ch.getRam().getDungLuongRam(); } catch (Exception e) {}
                try { if (ch.getOCung() != null) ch.getOCung().getDungLuongOCung(); } catch (Exception e) {}
                try { if (ch.getGpu() != null) ch.getGpu().getTenGpu(); } catch (Exception e) {}
                try { if (ch.getManHinh() != null) ch.getManHinh().getTenManHinh(); } catch (Exception e) {}
                try { if (ch.getMauSac() != null) ch.getMauSac().getTenMauSac(); } catch (Exception e) {}
                try { if (ch.getPin() != null) ch.getPin().getTenPin(); } catch (Exception e) {}
            }

            return ct;
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi lấy chi tiết biến thể getOne: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    public List<ChiTietSanPham> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch";

            List<ChiTietSanPham> list = session.createQuery(hql, ChiTietSanPham.class).getResultList();
            for (ChiTietSanPham ct : list) {
                if (ct.getCauHinhSanPham() != null) {
                    if (ct.getCauHinhSanPham().getCpu() != null) {
                        ct.getCauHinhSanPham().getCpu().getTenCpu(); // Kích hoạt Lazy load CPU
                    }
                    if (ct.getCauHinhSanPham().getRam() != null) {
                        ct.getCauHinhSanPham().getRam().getTenRam(); // Kích hoạt Lazy load RAM
                    }
                    if (ct.getCauHinhSanPham().getOCung() != null) {
                        ct.getCauHinhSanPham().getOCung().getTenOCung(); // Kích hoạt Lazy load Ổ cứng
                    }
                    if (ct.getCauHinhSanPham().getMauSac() != null) {
                        ct.getCauHinhSanPham().getMauSac().getTenMauSac(); // Kích hoạt Lazy load Màu sắc
                    }
                }
            }

            return list;
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi lấy danh sách sản phẩm chi tiết: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<ChiTietSanPham> findBySanPhamId(Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "SELECT ct FROM ChiTietSanPham ct " +
                    "LEFT JOIN FETCH ct.sanPham sp " +
                    "LEFT JOIN FETCH ct.cauHinhSanPham ch " +
                    "WHERE ct.sanPham.id = :id";
            return session.createQuery(hql, ChiTietSanPham.class)
                    .setParameter("id", idSanPham)
                    .getResultList();
        }
    }

    public void add(ChiTietSanPham ctsp) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.save(ctsp);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Integer id) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            ChiTietSanPham ctsp = session.find(ChiTietSanPham.class, id);
            if (ctsp != null) {
                session.delete(ctsp);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void update(ChiTietSanPham ctsp) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.merge(ctsp);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    // 🟢 TÁC VỤ 2: Tự động đồng bộ số lượng tồn kho (ton_kho) dựa theo số IMEI còn trong kho (trang_thai = 1)
    // Đếm tổng số mã seri (bảng ma_seri) có trang_thai = true thuộc cấu hình idCauHinh,
    // rồi UPDATE kết quả đếm được vào cột ton_kho của bảng chi_tiet_san_pham tương ứng.
    public void capNhatTonKhoTheoImei(Integer idCauHinh) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            Long soLuongConLai = session.createQuery(
                            "SELECT COUNT(m) FROM MaSeri m " +
                                    "WHERE m.cauHinhSanPham.id = :idCH AND m.trangThai = true",
                            Long.class)
                    .setParameter("idCH", idCauHinh)
                    .uniqueResult();

            int tonKhoMoi = (soLuongConLai != null) ? soLuongConLai.intValue() : 0;

            session.createQuery(
                            "UPDATE ChiTietSanPham ct SET ct.tonKho = :tonKho " +
                                    "WHERE ct.cauHinhSanPham.id = :idCH")
                    .setParameter("tonKho", tonKhoMoi)
                    .setParameter("idCH", idCauHinh)
                    .executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.out.println("❌ Lỗi khi đồng bộ tồn kho theo IMEI: " + e.getMessage());
            e.printStackTrace();
        }
    }
}