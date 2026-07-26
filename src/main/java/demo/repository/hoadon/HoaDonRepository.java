package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.*;
import org.hibernate.Session;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.query.Query;

public class HoaDonRepository {
    public List<HoaDon> getAllHoaDon() {
        Session session  = HibernateConfig.getFACTORY().openSession();
        return session.createQuery("from HoaDon").list(); }

    public HoaDon getOne(Integer id) {
        Session session  = HibernateConfig.getFACTORY().openSession();
        return session.find(HoaDon.class, id);}

    public void add(HoaDon hoaDon) {
        Session session  = HibernateConfig.getFACTORY().openSession();
        try {
            session.getTransaction().begin();
            session.save(hoaDon);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            session.getTransaction().rollback();
        }
    }


    public List<HoaDon> getTop5() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT h FROM HoaDon h LEFT JOIN h.khachHang ORDER BY h.ngayLap DESC",
                    HoaDon.class)
                    .setMaxResults(5)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    public List<HoaDon> timKiemVaLoc(String keyword, String trangThai, String ngayTao) {
        List<HoaDon> list = new ArrayList<>();

        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // LEFT JOIN để giữ lại hóa đơn không có khách hàng (hóa đơn chờ)
            StringBuilder hql = new StringBuilder(
                "SELECT h FROM HoaDon h " +
                "LEFT JOIN h.khachHang kh " +
                "LEFT JOIN h.nhanVien nv " +
                "WHERE 1=1 "
            );

            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (h.maHoaDon LIKE :keyword " +
                        "OR kh.tenKhachHang LIKE :keyword " +
                        "OR kh.sdt LIKE :keyword) ");
            }

            if (trangThai != null && !trangThai.trim().isEmpty()) {
                hql.append("AND h.trangThai = :trangThai ");
            }

            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                hql.append("AND CAST(h.ngayLap as date) = :ngayTao ");
            }

            hql.append("ORDER BY h.ngayLap DESC ");

            Query<HoaDon> query = session.createQuery(hql.toString(), HoaDon.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", Integer.parseInt(trangThai));
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                query.setParameter("ngayTao", java.sql.Date.valueOf(ngayTao));
            }

            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách hóa đơn chờ (trangThai = 2 = Chờ xử lý)
    public List<HoaDon> getHoaDonCho() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT h FROM HoaDon h LEFT JOIN h.khachHang " +
                    "WHERE h.trangThai = 2 ORDER BY h.ngayLap DESC",
                    HoaDon.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Tự động sinh mã hóa đơn: HD001, HD002, ...
    public String taoMaHoaDon() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long count = session.createQuery(
                    "SELECT COUNT(h) FROM HoaDon h", Long.class).uniqueResult();
            if (count == null) count = 0L;
            return String.format("HD%03d", count + 1);
        } catch (Exception e) {
            e.printStackTrace();
            return "HD" + System.currentTimeMillis();
        }
    }

    // Xóa hóa đơn chờ (soft delete — chỉ dùng cho hóa đơn chờ trangThai=2)
    public void deleteHoaDonCho(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            org.hibernate.Transaction tx = session.beginTransaction();
            session.createNativeQuery(
                    "UPDATE hoa_don SET is_deleted = 1 WHERE id = :id AND trang_thai = 2"
            ).setParameter("id", id).executeUpdate();
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

