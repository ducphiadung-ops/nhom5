package demo.repository.khachhang;

import demo.util.HibernateConfig;
import demo.entity.khach_hang.KhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class KhachHangRepository {

    // Hiển thị tất cả khách hàng
    public List<KhachHang> getAll() {
        Session session = HibernateConfig.getFACTORY().openSession();

        List<KhachHang> list = session.createQuery("FROM KhachHang WHERE trangThai = true", KhachHang.class).getResultList();

        session.close();

        return list;
    }
    //


    // Thêm khách hàng
    public void add(KhachHang kh) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = null;

        try {

            transaction = session.beginTransaction();

            session.persist(kh);

            transaction.commit();

        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();

        } finally {
            session.close();
        }
    }
    // lấy mã khách hàng lớn nhất
    public String layMaKhachHangMoi() {

        Session session = HibernateConfig.getFACTORY().openSession();

        String hql = "SELECT MAX(maKhachHang) FROM KhachHang";

        String maCuoi = session.createQuery(hql, String.class).uniqueResult();

        session.close();

        if (maCuoi == null) {
            return "KH001";
        }

        int so = Integer.parseInt(maCuoi.substring(2));

        so++;

        return String.format("KH%03d", so);
    }
//xoa
    public void xoa(Integer id){
        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = null;

        try{

            transaction = session.beginTransaction();

            KhachHang kh = session.find(KhachHang.class,id);

            if(kh != null){

                kh.setTrangThai(false);

                session.merge(kh);

            }

            transaction.commit();
        }catch (Exception e){

            if(transaction != null)
            {
                transaction.rollback();
            }

            e.printStackTrace();

        }finally {
            session.close();
        }
    }
    //tim theo id
    public KhachHang timTheoId(Integer id){

        Session session = HibernateConfig.getFACTORY().openSession();

        KhachHang kh = session.find(KhachHang.class,id);

        session.close();

        return kh;
    }
    //cap nhat khách hàng
    public void capNhat(KhachHang kh){

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = null;

        try{
            transaction = session.beginTransaction();
            session.merge(kh);
            transaction.commit();

        }catch (Exception e){
            if(transaction != null){
                transaction.rollback();
            }
            e.printStackTrace();

        }finally {
            session.close();
        }
    }
    // doi trang thai
    public void doiTrangThai(Integer id, Boolean trangThai) {

        Session session = HibernateConfig.getFACTORY().openSession();

        Transaction transaction = session.beginTransaction();

        KhachHang kh = session.find(KhachHang.class, id);

        kh.setTrangThai(trangThai);

        session.merge(kh);

        transaction.commit();

        session.close();
    }
}