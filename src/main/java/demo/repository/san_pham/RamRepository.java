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
            return session.createQuery("FROM Ram WHERE trangThai = true", Ram.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
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
