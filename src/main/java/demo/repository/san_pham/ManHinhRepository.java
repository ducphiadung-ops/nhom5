package demo.repository.san_pham;


import demo.entity.san_pham.ManHinh;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class ManHinhRepository {
    public ManHinhRepository() {
    }

    public List<ManHinh> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM ManHinh WHERE trangThai = 1", ManHinh.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<ManHinh> getDangHoatDong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM ManHinh WHERE trangThai = 1", ManHinh.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ManHinh getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(ManHinh.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add(ManHinh mh) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(mh);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(ManHinh mh) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(mh);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}