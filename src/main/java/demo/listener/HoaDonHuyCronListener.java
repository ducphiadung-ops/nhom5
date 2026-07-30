package demo.listener;

import demo.entity.hoa_don.ChiTietHoaDon;
import demo.entity.hoa_don.HoaDon;
import demo.entity.san_pham.MaSeri;
import demo.repository.hoadon.ChiTietHoaDonRepo;
import demo.repository.hoadon.HoaDonRepository;
import demo.repository.san_pham.ChiTietSanPhamRepository;
import demo.repository.san_pham.MaSeriRepository;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Listener chạy cron job mỗi ngày vào lúc 00:00:
 *   - Lấy tất cả hóa đơn chờ (trangThai=2) có ngayLap < hôm nay
 *   - Giải phóng seri đã bị giữ → trả về trangThai=1 (còn hàng)
 *   - Đồng bộ tồn kho cho từng cấu hình sản phẩm
 *   - Đổi trangThai hóa đơn → 3 (đã hủy)
 */
@WebListener
public class HoaDonHuyCronListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    private final HoaDonRepository       hoaDonRepository        = new HoaDonRepository();
    private final ChiTietHoaDonRepo       chiTietHoaDonRepo       = new ChiTietHoaDonRepo();
    private final MaSeriRepository        maSeriRepository        = new MaSeriRepository();
    private final ChiTietSanPhamRepository chiTietSanPhamRepository = new ChiTietSanPhamRepository();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "hoadon-huy-cron");
            t.setDaemon(true);
            return t;
        });

        // Tính delay đến midnight đêm nay (00:00:00 ngày hôm sau)
        LocalDateTime now       = LocalDateTime.now(ZoneId.systemDefault());
        LocalDateTime nextMidnight = LocalDateTime.of(
                LocalDate.now(ZoneId.systemDefault()).plusDays(1),
                LocalTime.MIDNIGHT
        );
        long initialDelay = java.time.Duration.between(now, nextMidnight).getSeconds();

        scheduler.scheduleAtFixedRate(
                this::huyDonChoQuaHan,
                initialDelay,
                TimeUnit.DAYS.toSeconds(1),
                TimeUnit.SECONDS
        );

        System.out.println("[HoaDonHuyCron] Scheduler khởi động. Job đầu tiên sau "
                + initialDelay + "s (lúc 00:00 ngày mai).");

        // Chạy ngay 1 lần khi khởi động để xử lý các đơn chờ còn sót từ hôm trước
        huyDonChoQuaHan();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            System.out.println("[HoaDonHuyCron] Scheduler đã dừng.");
        }
    }

    // =========================================================
    //  Job logic: giải phóng seri rồi hủy đơn chờ quá hạn
    // =========================================================
    private void huyDonChoQuaHan() {
        try {
            List<HoaDon> danhSachQuaHan = hoaDonRepository.getDonChoQuaHan();

            if (danhSachQuaHan.isEmpty()) {
                System.out.println("[HoaDonHuyCron] Không có đơn chờ quá hạn cần hủy.");
                return;
            }

            System.out.println("[HoaDonHuyCron] Đang hủy " + danhSachQuaHan.size() + " đơn chờ quá hạn...");

            Set<Integer> cauHinhDaCapNhat = new HashSet<>();

            for (HoaDon hd : danhSachQuaHan) {
                try {
                    // Giải phóng tất cả seri đang bị giữ trong đơn này
                    List<ChiTietHoaDon> dsCT = chiTietHoaDonRepo.getByHoaDonId(hd.getId());
                    for (ChiTietHoaDon ct : dsCT) {
                        MaSeri seri = ct.getIdSeri();
                        if (seri != null && seri.getTrangThai() != null && seri.getTrangThai() == 0) {
                            // trangThai seri: 0=đang giữ → hoàn lại 1=còn hàng
                            seri.setTrangThai(1);
                            maSeriRepository.update(seri);

                            // Đồng bộ tồn kho — chỉ gọi 1 lần mỗi cấu hình
                            if (seri.getCauHinhSanPham() != null) {
                                Integer idCH = seri.getCauHinhSanPham().getId();
                                if (cauHinhDaCapNhat.add(idCH)) {
                                    chiTietSanPhamRepository.capNhatTonKhoTheoImei(idCH);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("[HoaDonHuyCron] Lỗi khi giải phóng seri cho HĐ id="
                            + hd.getId() + ": " + e.getMessage());
                }
            }

            // Cập nhật hàng loạt trangThai → 3 bằng native query (1 câu duy nhất)
            int soLuongHuy = hoaDonRepository.huyDonChoQuaHan();
            System.out.println("[HoaDonHuyCron] Đã hủy " + soLuongHuy + " đơn chờ quá hạn thành công.");

        } catch (Exception e) {
            System.err.println("[HoaDonHuyCron] Lỗi khi chạy job hủy đơn chờ: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
