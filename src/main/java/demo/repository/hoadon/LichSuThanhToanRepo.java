package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.LichSuThanhToan;
import org.hibernate.Session;

import java.util.List;

public class LichSuThanhToanRepo {
    Session session;
    public LichSuThanhToanRepo() {session = HibernateConfig.getFACTORY().openSession();
    }
    public List<LichSuThanhToan> getAll() { return session.createQuery("from LichSuThanhToan").list(); }
}
