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
        try (Session session =HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM HoaDon ORDER BY ngayLap DESC", HoaDon.class)
                    .setMaxResults(5) // Lấy đúng 5 hóa đơn đầu tiên
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    public List<HoaDon> timKiemVaLoc(String keyword, String trangThai, String ngayTao) {
        List<HoaDon> list = new ArrayList<>();

        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Mệnh đề WHERE 1=1 để dễ dàng nối các điều kiện AND ở sau mà không bị lỗi cú pháp
            StringBuilder hql = new StringBuilder("SELECT h FROM HoaDon h WHERE 1=1 ");

            // 1. Kiểm tra và nối điều kiện keyword (Mã HĐ, Tên KH, SĐT)
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (h.maHoaDon LIKE :keyword " +
                        "OR h.khachHang.tenKhachHang LIKE :keyword " +
                        "OR h.khachHang.sdt LIKE :keyword) ");
            }

            // 2. Kiểm tra và nối điều kiện trạng thái
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                hql.append("AND h.trangThai = :trangThai ");
            }

            // 3. Kiểm tra và nối điều kiện ngày tạo
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                // Ép h.ngayLap về dạng date (bỏ qua giờ phút giây nếu có) để so sánh chính xác với input
                hql.append("AND CAST(h.ngayLap as date) = :ngayTao ");
            }

            // Tạo Query với chuỗi HQL đã nối hoàn chỉnh
            Query<HoaDon> query = session.createQuery(hql.toString(), HoaDon.class);

            // Truyền giá trị (Set Parameter) vào các biến trong HQL
            if (keyword != null && !keyword.trim().isEmpty()) {
                // Thêm % ở 2 đầu để tìm kiếm chứa (LIKE)
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", Integer.parseInt(trangThai));
            }
            if (ngayTao != null && !ngayTao.trim().isEmpty()) {
                // Thẻ <input type="date"> gửi lên chuỗi "yyyy-MM-dd"
                // Ta chuyển đổi chuỗi này sang java.sql.Date để Hibernate hiểu
                query.setParameter("ngayTao", java.sql.Date.valueOf(ngayTao));
            }

            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

