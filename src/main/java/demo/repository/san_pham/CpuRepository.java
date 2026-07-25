package demo.repository.san_pham;


import demo.entity.san_pham.Cpu;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class CpuRepository {
    public CpuRepository() {
    }
    public List<Cpu> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM Cpu WHERE trangThai = true", Cpu.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public Cpu getOne(Integer id){
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            return session.find(Cpu.class, id);
        }
    }

    public void add(Cpu cpu) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(cpu);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
    public void update (Cpu cpu){
        Transaction tx = null;
        try(Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(cpu);
            tx.commit();
        }catch (Exception e){
            if(tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
    public void delete (Integer id){
        Transaction tx = null;
        try(Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.delete(this.getOne(id));
            tx.commit();
        }catch (Exception e){
            if(tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}