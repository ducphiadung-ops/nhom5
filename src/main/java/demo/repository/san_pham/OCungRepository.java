package demo.repository.san_pham;


import demo.entity.san_pham.OCung;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class OCungRepository {
    public OCungRepository() {
    }
    public List<OCung> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM OCung WHERE trangThai = 1", OCung.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<OCung> getAllDistinctByDungLuong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Lấy id nhỏ nhất đại diện cho mỗi giá trị dung lượng, tránh hiển thị trùng
            List<Integer> ids = session.createQuery(
                    "SELECT MIN(o.id) FROM OCung o WHERE o.trangThai = 1 GROUP BY o.dungLuongOCung",
                    Integer.class).list();
            if (ids == null || ids.isEmpty()) return new java.util.ArrayList<>();
            return session.createQuery(
                    "FROM OCung WHERE id IN :ids ORDER BY id", OCung.class)
                    .setParameter("ids", ids)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
    public OCung getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(OCung.class, id);
        }
    }
    public void add(OCung oCung) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(oCung);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(OCung oCung) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(oCung);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
