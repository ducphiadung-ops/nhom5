package demo.Service.khachhang;

import demo.entity.khach_hang.KhachHang;
import demo.repository.khachhang.KhachHangRepository;

import java.util.List;

public class KhachHangService {
    private KhachHangRepository repository = new KhachHangRepository();

    // Hiển thị danh sách
    public List<KhachHang> getAll() {
        return repository.getAll();
    }

    // Thêm khách hàng
    public void add(KhachHang kh) {
        repository.add(kh);
    }

    // lấy mã kh mới
    public String layMaKhachHangMoi() {
        return repository.layMaKhachHangMoi();
    }

    // tìm id khách hàng
    public KhachHang timTheoId(Integer id){

        return repository.timTheoId(id);

    }
    //xoa khách hàng
    public void xoa(Integer id){

        repository.xoa(id);

    }
    // cập nhật khách hàng
    public void capNhat(KhachHang kh){

        repository.capNhat(kh);

    }
    // doi trang thai
    public void doiTrangThai(Integer id, Boolean trangThai) {
        repository.doiTrangThai(id, trangThai);
    }
}
