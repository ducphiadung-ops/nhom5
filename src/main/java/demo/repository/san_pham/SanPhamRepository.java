package demo.repository.san_pham;

import demo.entity.san_pham.SanPham;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class  SanPhamRepository {

    public SanPhamRepository() {
    }

    public SanPham getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(SanPham.class, id);
        }
    }

    public List<SanPham> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // 🟢 Đã thêm SanPham.class
            return session.createQuery("FROM SanPham WHERE trangThai = 1", SanPham.class).getResultList();
        }
    }

    public void add(SanPham sp) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            session.save(sp);
            session.flush();

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void delete(Integer idSanPhamCha) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            session.createNativeQuery("UPDATE san_pham SET trang_thai = 0 WHERE id = :id")
                    .setParameter("id", idSanPhamCha)
                    .executeUpdate();

            session.createNativeQuery("UPDATE chi_tiet_san_pham SET trang_thai = 0 WHERE id_san_pham = :id")
                    .setParameter("id", idSanPhamCha)
                    .executeUpdate();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.out.println("❌ Lỗi khi xóa mềm sản phẩm cha: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public void update(SanPham sanPham) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            session.merge(sanPham);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<SanPham> timTheoTen(String tenCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE LOWER(tenSanPham) LIKE LOWER(:ten)", SanPham.class)
                    .setParameter("ten", "%" + tenCT + "%")
                    .getResultList();
        }
    }

    public List<SanPham> timTheoMa(String maCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE LOWER(maSanPham) LIKE LOWER(:ma)", SanPham.class)
                    .setParameter("ma", "%" + maCT + "%")
                    .getResultList();
        }
    }

    public List<SanPham> timTheoTH(String tenHangCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE LOWER(thuongHieu.tenThuongHieu) LIKE LOWER(:tenHang)", SanPham.class)
                    .setParameter("tenHang", "%" + tenHangCT + "%")
                    .getResultList();
        }
    }

    public List<SanPham> timTheoTrangThai(Integer trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE trangThai = :tt", SanPham.class)
                    .setParameter("tt", trangThai)
                    .getResultList();
        }
    }

    public List<SanPham> timTheoNgay(LocalDate ngay) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE ngayTao = :ngay", SanPham.class)
                    .setParameter("ngay", ngay)
                    .getResultList();
        }
    }

    public List<SanPham> timTheoKhoang(LocalDate ngay1, LocalDate ngay2) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham WHERE ngayTao BETWEEN :ngay1 AND :ngay2", SanPham.class)
                    .setParameter("ngay1", ngay1)
                    .setParameter("ngay2", ngay2)
                    .getResultList();
        }
    }

    public List<SanPham> getAllWithPagination(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM SanPham", SanPham.class)
                    .setFirstResult(offset)
                    .setMaxResults(pageSize)
                    .getResultList();
        }
    }

    public Long countAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("SELECT COUNT(s) FROM SanPham s", Long.class)
                    .getSingleResult();
        }
    }

    // 1. Check trùng tên khi thêm
    public boolean checkTrungTen(String tenSanPham) {
        if (tenSanPham == null || tenSanPham.trim().isEmpty()) {
            return false;
        }
        String hql = "FROM SanPham sp WHERE LOWER(TRIM(sp.tenSanPham)) = :ten";
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Query<SanPham> query = session.createQuery(hql, SanPham.class);
            query.setParameter("ten", tenSanPham.trim().toLowerCase());
            return query.uniqueResult() != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Check trùng tên khi sửa
    public boolean checkTrungTenKhiSua(String tenSanPham, Integer idCurrent) {
        if (tenSanPham == null || tenSanPham.trim().isEmpty()) {
            return false;
        }
        String hql = "FROM SanPham sp WHERE LOWER(TRIM(sp.tenSanPham)) = :ten AND sp.id != :id";
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Query<SanPham> query = session.createQuery(hql, SanPham.class);
            query.setParameter("ten", tenSanPham.trim().toLowerCase());
            query.setParameter("id", idCurrent);
            return query.uniqueResult() != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<SanPham> getTop5() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Chỉ lấy 5 sản phẩm đầu tiên (sắp xếp theo id mới nhất)
            return session.createQuery("FROM SanPham s ORDER BY s.id DESC", SanPham.class)
                    .setMaxResults(5)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}