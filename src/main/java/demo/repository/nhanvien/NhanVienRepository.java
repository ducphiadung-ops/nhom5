    package demo.repository.nhanvien;

    import demo.entity.nhan_vien.NhanVien;
    import demo.util.HibernateConfig;
    import org.hibernate.Session;
    import org.hibernate.Transaction;

    import java.util.List;

    public class NhanVienRepository {

        // Hiển thị
        public List<NhanVien> getAll() {

            Session session = HibernateConfig.getFACTORY().openSession();

            List<NhanVien> list =
                    session.createQuery("FROM NhanVien WHERE trangThai = true", NhanVien.class)
                            .getResultList();

            session.close();

            return list;
        }

        // Thêm
        public void add(NhanVien nv) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            session.persist(nv);

            transaction.commit();

            session.close();

        }

        // Lấy theo id
        public NhanVien getOne(Integer id) {

            Session session = HibernateConfig.getFACTORY().openSession();

            NhanVien nv = session.find(NhanVien.class, id);

            session.close();

            return nv;

        }

        // Lấy mã nhân viên mới
        public String layMaNhanVienMoi() {

            Session session = HibernateConfig.getFACTORY().openSession();

            String hql = "SELECT MAX(maNhanVien) FROM NhanVien";

            String maCuoi = session.createQuery(hql, String.class).uniqueResult();

            session.close();

            if (maCuoi == null) {
                return "NV001";
            }

            int so = Integer.parseInt(maCuoi.substring(2));

            so++;

            return String.format("NV%03d", so);
        }

        // Sửa
        public void update(NhanVien nv) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            session.merge(nv);

            transaction.commit();

            session.close();

        }

        // Xóa mềm
        public void delete(Integer id) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            NhanVien nv = session.find(NhanVien.class, id);

            nv.setTrangThai(false);

            session.merge(nv);

            transaction.commit();

            session.close();

        }

        // switch doi trang thai
        public void doiTrangThai(Integer id, Boolean trangThai) {

            Session session = HibernateConfig.getFACTORY().openSession();

            Transaction transaction = session.beginTransaction();

            NhanVien nv = session.find(NhanVien.class, id);

            nv.setTrangThai(trangThai);

            session.merge(nv);

            transaction.commit();

            session.close();
        }

    }
