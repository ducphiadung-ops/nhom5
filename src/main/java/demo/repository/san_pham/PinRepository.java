package demo.repository.san_pham;


import demo.entity.san_pham.Pin;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PinRepository {
    public PinRepository() {
    }
    public List<Pin> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Pin WHERE trangThai = true", Pin.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public Pin getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(Pin.class, id);
        }
    }
    public void add(Pin pin) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(pin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(Pin pin) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(pin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}
