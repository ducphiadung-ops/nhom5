package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.ChiTietHoaDon;
import org.hibernate.Session;

import java.util.List;

public class ChiTietHoaDonRepo {
    Session session;
    public ChiTietHoaDonRepo() {session = HibernateConfig.getFACTORY().openSession();}
    public List<ChiTietHoaDon> getAll() { return session.createQuery("from ChiTietHoaDon").list(); }
    // Trong ChiTietHoaDonRepository
    public ChiTietHoaDon getOne(Integer id){
        return session.find(ChiTietHoaDon.class,id);
    }
}
