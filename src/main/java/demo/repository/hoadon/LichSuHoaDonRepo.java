package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.LichSuHoaDon;
import org.hibernate.Session;

import java.util.List;

public class LichSuHoaDonRepo {
    Session session;
    public  LichSuHoaDonRepo(){session = HibernateConfig.getFACTORY().openSession();
    }
    public List<LichSuHoaDon> getAll() { return session.createQuery("from LichSuHoaDon").list(); }
}
