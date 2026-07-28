package demo.repository.san_pham;

import demo.entity.san_pham.MaSeri;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class MaSeriRepository {
    public MaSeriRepository() {
    }

    public List<MaSeri> getAll(){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.createQuery("FROM MaSeri ", MaSeri.class).list();
        }
    }

    public MaSeri getOne(Integer id){
        try(Session session= HibernateConfig.getFACTORY().openSession()){
            MaSeri ms = session.find(MaSeri.class, id);
            // Kích hoạt lazy load cauHinhSanPham trước khi đóng session
            if (ms != null && ms.getCauHinhSanPham() != null) {
                org.hibernate.Hibernate.initialize(ms.getCauHinhSanPham());
                if (ms.getCauHinhSanPham().getSanPham() != null) {
                    org.hibernate.Hibernate.initialize(ms.getCauHinhSanPham().getSanPham());
                }
            }
            return ms;
        }
    }

    // 🟢 HÀM FIX LỖI BÁO ĐỎ TRÊN SERVLET
    // Tìm kiếm danh sách mã IMEI/Seri thuộc về một Cấu hình cụ thể
    public List<MaSeri> getByIdCauHinh(Integer idCauHinh) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "FROM MaSeri m WHERE m.cauHinhSanPham.id = :idCH";
            return session.createQuery(hql, MaSeri.class)
                    .setParameter("idCH", idCauHinh)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public void add(MaSeri maSeri) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            session.save(maSeri);
            session.flush(); // Đồng bộ ID tự tăng sang đối tượng

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(MaSeri maSeri) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(maSeri);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // 🟢 TÁC VỤ 1: Kiểm tra trùng lặp IMEI dưới Database
    // Trả về true nếu số seri đã tồn tại (bất kể trạng thái còn/đã bán) để tránh trùng lặp mã định danh
    public boolean checkTrungImei(String soSeri) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Long soLuong = session.createQuery(
                    "SELECT COUNT(m) FROM MaSeri m WHERE m.soSeri = :soSeri", Long.class)
                    .setParameter("soSeri", soSeri)
                    .uniqueResult();
            return soLuong != null && soLuong > 0;
        } catch (Exception e) {
            e.printStackTrace();
            // An toàn: nếu lỗi truy vấn thì coi như trùng để không lưu nhầm dữ liệu bẩn
            return true;
        }
    }

    // 🟢 TÁC VỤ 4: Cập nhật (Sửa) chuỗi số seri cho 1 mã IMEI đơn lẻ
    public void updateSoSeri(Integer id, String soSeriMoi) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            MaSeri m = session.find(MaSeri.class, id);
            if (m != null) {
                m.setSoSeri(soSeriMoi);
                session.merge(m);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // 🟢 TÁC VỤ 4: Hủy kích hoạt (xóa mềm) 1 mã IMEI ra khỏi kho -> trang_thai = false
    public void huyKichHoat(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            MaSeri m = session.find(MaSeri.class, id);
            if (m != null) {
                m.setTrangThai(0);
                session.merge(m);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}