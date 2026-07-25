package demo.repository.san_pham;


import demo.entity.san_pham.ThuongHieu;
import demo.util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class ThuongHieuRepository {
    private Session session;

    public ThuongHieuRepository() {
        session = HibernateConfig.getFACTORY().openSession();
    }
    public List<ThuongHieu> getAll(){
        return session.createQuery("FROM ThuongHieu ", ThuongHieu.class).list();
    }
    public ThuongHieu getOne(Integer id){
        return session.find(ThuongHieu.class, id);
    }
    public void add (ThuongHieu thuongHieu){
        try {
            session.getTransaction().begin();
            session.save(thuongHieu);
            session.getTransaction().commit();
        }catch (Exception e){
            session.getTransaction().rollback();
            e.printStackTrace();
        }
    }
    public void update (ThuongHieu thuongHieu){
        try {
            session.getTransaction().begin();
            session.merge(thuongHieu);
            session.getTransaction().commit();
        }catch (Exception e){
            session.getTransaction().rollback();
            e.printStackTrace();
        }
    }
    public void delete (Integer id){
        try {
            session.getTransaction().begin();
            session.delete(this.getOne(id));
            session.getTransaction().commit();
        }catch (Exception e){
            session.getTransaction().rollback();
            e.printStackTrace();
        }
    }
    public List<ThuongHieu> getDangHoatDong(){
        return session.createQuery("FROM ThuongHieu where trangThai = true", ThuongHieu.class).getResultList();
    }
}
