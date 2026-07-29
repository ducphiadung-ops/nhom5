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

    public List<ChiTietSanPham> findByCauHinhId(Integer idCauHinh) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT ct FROM ChiTietSanPham ct WHERE ct.cauHinhSanPham.id = :id",
                    ChiTietSanPham.class)
                    .setParameter("id", idCauHinh)
                    .getResultList();
        } catch (Exception e) {
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

    // 🟢 Đếm tất cả biến thể theo idSanPham rồi UPDATE thẳng vào san_pham.so_luong_ton
    public void capNhatSoLuongTonSanPhamCha(Integer idSanPham) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            Long soLuongBienThe = session.createQuery(
                            "SELECT COUNT(ct) FROM ChiTietSanPham ct WHERE ct.sanPham.id = :idSP",
                            Long.class)
                    .setParameter("idSP", idSanPham)
                    .uniqueResult();

            int soLuong = (soLuongBienThe != null) ? soLuongBienThe.intValue() : 0;

            session.createNativeQuery(
                            "UPDATE san_pham SET so_luong_ton = :soLuong WHERE id = :idSP")
                    .setParameter("soLuong", soLuong)
                    .setParameter("idSP", idSanPham)
                    .executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.out.println("❌ Lỗi capNhatSoLuongTonSanPhamCha: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 🟢 Đếm tổng số biến thể (kể cả trạng_thái 0 và 1) theo id sản phẩm cha
    public long countAllBySanPhamId(Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(ct) FROM ChiTietSanPham ct WHERE ct.sanPham.id = :idSP",
                            Long.class)
                    .setParameter("idSP", idSanPham)
                    .uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            System.out.println("❌ Lỗi countAllBySanPhamId: " + e.getMessage());
            return 0L;
        }
    }

    // 🟢 Đếm số biến thể CÒN HOẠT ĐỘNG (trạng_thái = 1) theo id sản phẩm cha
    public long countActiveBySanPhamId(Integer idSanPham) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                            "SELECT COUNT(ct) FROM ChiTietSanPham ct WHERE ct.sanPham.id = :idSP AND ct.trangThai = 1",
                            Long.class)
                    .setParameter("idSP", idSanPham)
                    .uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            System.out.println("❌ Lỗi countActiveBySanPhamId: " + e.getMessage());
            return 0L;
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
                                    "WHERE m.cauHinhSanPham.id = :idCH AND m.trangThai = 1",
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