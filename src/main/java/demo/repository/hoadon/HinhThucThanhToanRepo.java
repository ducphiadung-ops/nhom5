package demo.repository.hoadon;

import demo.util.HibernateConfig;
import demo.entity.hoa_don.HinhThucThanhToan;
import org.hibernate.Session;

import java.util.List;

public class HinhThucThanhToanRepo {

    public List<HinhThucThanhToan> getAll() {
        Session session = HibernateConfig.getFACTORY().openSession();
        List<HinhThucThanhToan> list = null;
        try {
            // Thay vì dùng "FROM HinhThucThanhToan"
            // Dùng JOIN để chỉ lấy các Hình thức thanh toán mà Hóa đơn của nó TỒN TẠI (chưa bị xóa)
            String hql = "SELECT httt FROM HinhThucThanhToan httt JOIN httt.hoaDon";
            list = session.createQuery(hql, HinhThucThanhToan.class).list();
        } finally {
            session.close(); // Nhớ đóng session
        }
        return list;
    }
}

