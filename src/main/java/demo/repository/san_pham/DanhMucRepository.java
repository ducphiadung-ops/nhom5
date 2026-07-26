package demo.repository.san_pham;


import demo.entity.san_pham.DanhMuc;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class DanhMucRepository {

    public DanhMucRepository() {
    }

    public List<DanhMuc> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM DanhMuc where trangThai = 1", DanhMuc.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public DanhMuc getOne(Integer id){
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(DanhMuc.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add (DanhMuc danhMuc){
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(danhMuc);
            tx.commit();
        } catch (Exception e){
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<DanhMuc> getDangHoatDong(){
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM DanhMuc where trangThai = 1", DanhMuc.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public void update (DanhMuc danhMuc){
        Transaction tx = null;
        try(Session session = HibernateConfig.getFACTORY().openSession()){
            tx = session.beginTransaction();
            session.merge(danhMuc);
            tx.commit();
        }catch (Exception e){
            if(tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}