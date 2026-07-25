package demo.repository.san_pham;


import demo.entity.san_pham.CauHinhSanPham;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class CauHinhSanPhamRepository {

    public CauHinhSanPhamRepository() {
    }

    public List<CauHinhSanPham> getAll(){
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM CauHinhSanPham ", CauHinhSanPham.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public CauHinhSanPham getOne(Integer id){
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(CauHinhSanPham.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public void add(CauHinhSanPham cauHinhSanPham) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(cauHinhSanPham);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}