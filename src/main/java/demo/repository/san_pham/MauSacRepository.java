package demo.repository.san_pham;

import demo.entity.san_pham.MauSac;
import demo.util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class MauSacRepository {
    public MauSacRepository() {
    }

    public List<MauSac> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM MauSac WHERE trangThai = true", MauSac.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<MauSac> getDangHoatDong() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            // ĐÃ SỬA: Đổi Cpu thành MauSac
            return session.createQuery("FROM MauSac WHERE trangThai = true", MauSac.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public MauSac getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(MauSac.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void add(MauSac mauSac) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.save(mauSac);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public void update(MauSac mauSac) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(mauSac);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}