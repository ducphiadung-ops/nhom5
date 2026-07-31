package demo.repository.san_pham;


import demo.entity.san_pham.Ram;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class RamRepository {
    public RamRepository() {
    }
    public List<Ram> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Ram WHERE trangThai = 1", Ram.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Ram> getAllDistinctByDungLuong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // Lấy id nhỏ nhất đại diện cho mỗi giá trị dung lượng, tránh hiển thị trùng
            List<Integer> ids = session.createQuery(
                    "SELECT MIN(r.id) FROM Ram r WHERE r.trangThai = 1 GROUP BY r.dungLuongRam",
                    Integer.class).list();
            if (ids == null || ids.isEmpty()) return new java.util.ArrayList<>();
            return session.createQuery(
                    "FROM Ram WHERE id IN :ids ORDER BY id", Ram.class)
                    .setParameter("ids", ids)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
    public Ram getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(Ram.class, id);
        }
    }
    public void add(Ram ram) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(ram);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(Ram ram) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(ram);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
