package demo.util;

import jakarta.persistence.Entity;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;
import org.reflections.Reflections;

import java.util.Properties;
import java.util.Set;

public class HibernateConfig {
    private static final SessionFactory FACTORY;

    static {
        Configuration conf = new Configuration();

        Properties properties = new Properties();

        // 🟢 1. Cấu hình Dialect & Driver cho SQL Server
        // LƯU Ý: Với Hibernate 6.x+, dùng "SQLServerDialect" chung thay vì gán cứng phiên bản cũ
        properties.put(Environment.DIALECT, "org.hibernate.dialect.SQLServerDialect");
        properties.put(Environment.DRIVER, "com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // 🟢 2. Chuỗi Kết Nối Database & Đăng nhập (sa / 123)
        properties.put(Environment.URL, "jdbc:sqlserver://localhost:1433;databaseName=DB_Quan_ly_may_tinh;encrypt=true;trustServerCertificate=true;");
        properties.put(Environment.USER, "sa");
        properties.put(Environment.PASS, "123");

        // 🟢 3. Log SQL để dễ Debug khi lập trình
        properties.put(Environment.SHOW_SQL, "true");
        properties.put(Environment.FORMAT_SQL, "true");

        // Cấu hình chế độ Hibernate (validate = kiểm tra match entity với DB hay chưa)
        // properties.put(Environment.HBM2DDL_AUTO, "update");

        conf.setProperties(properties);

        // 🟢 4. TỰ ĐỘNG QUÉT TOÀN BỘ ENTITY TRONG PACKAGE demo.entity
        try {
            Reflections reflections = new Reflections("demo.entity");
            Set<Class<?>> entityClasses = reflections.getTypesAnnotatedWith(Entity.class);

            for (Class<?> clazz : entityClasses) {
                conf.addAnnotatedClass(clazz);
                System.out.println("-> Đã ánh xạ Entity: " + clazz.getName());
            }
        } catch (Exception e) {
            System.err.println("Lỗi tự động quét Entity: " + e.getMessage());
            e.printStackTrace();
        }

        // 🟢 5. Tạo ServiceRegistry & SessionFactory
        ServiceRegistry registry = new StandardServiceRegistryBuilder()
                .applySettings(conf.getProperties())
                .build();

        FACTORY = conf.buildSessionFactory(registry);
    }

    public static SessionFactory getFACTORY() {
        return FACTORY;
    }

    // Hàm test chạy trực tiếp xem đã kết nối được CSDL chưa
    public static void main(String[] args) {
        try {
            SessionFactory sessionFactory = getFACTORY();
            if (sessionFactory != null) {
                System.out.println("\n✅ KẾT NỐI DATABASE VÀ ÁNH XẠ MAPPING FULL ENTITY THÀNH CÔNG!");
            }
        } catch (Exception e) {
            System.err.println("\n❌ KẾT NỐI THẤT BẠI:");
            e.printStackTrace();
        }
    }
}