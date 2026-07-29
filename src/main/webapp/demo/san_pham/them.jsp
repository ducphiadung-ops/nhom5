<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<c:if test="${isNhanVien}">
    <c:redirect url="${pageContext.request.contextPath}/san-pham/hien-thi"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm - Skycomputer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <style>
        :root {
            --primary: #1a56db;
            --primary-light: #e6efff;
            --sidebar-active: #eef2ff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --bg-body: #f8f9fa;
            --border-color: #e5e7eb;
            --success-text: #047857;
            --success-bg: #d1fae5;
            --danger-text: #be123c;
            --danger-bg: #ffe4e6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { display: flex; height: 100vh; background-color: var(--bg-body); color: var(--text-main); overflow: hidden; }

        .sidebar { width: 260px; background-color: #fff; border-right: 1px solid var(--border-color); display: flex; flex-direction: column; height: 100vh; padding-bottom: 16px; z-index: 10; }
        .brand { display: flex; align-items: center; padding: 20px 20px; gap: 12px; border-bottom: 1px solid var(--border-color); margin-bottom: 12px; }
        .brand-logo { width: 40px; height: 40px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.08); overflow: hidden; display: flex; align-items: center; justify-content: center; background: #fff; }
        .brand-logo img { width: 100%; height: 100%; object-fit: contain; }
        .brand-text h1 { font-size: 16px; font-weight: 700; color: #1e3a8a; margin-bottom: 0px;}
        .brand-text p { font-size: 11px; color: var(--text-muted); margin-bottom: 0; }

        .nav-menu { list-style: none; padding: 0 12px; flex: 1; overflow-y: auto; }
        .nav-item { margin-bottom: 4px; }
        .nav-link-custom { display: flex; align-items: center; padding: 11px 16px; color: var(--text-muted); text-decoration: none; border-radius: 8px; font-size: 14px; font-weight: 500; transition: all 0.2s; gap: 12px; }
        .nav-link-custom i { font-size: 16px; width: 20px; text-align: center; }
        .nav-link-custom:hover { background-color: #f3f4f6; color: var(--text-main); }
        .nav-link-custom.active { background-color: var(--sidebar-active); color: var(--primary); font-weight: 600; }

        .sub-menu { list-style: none; padding-left: 0; margin-top: 4px; display: flex; flex-direction: column; gap: 2px; }
        .sub-menu .nav-link-custom { padding: 9px 16px 9px 44px !important; font-size: 13px; }
        .sub-menu .nav-link-custom.active-sub { background-color: var(--sidebar-active); color: var(--primary); font-weight: 600; }

        .logout-item { margin-top: auto; padding: 0 12px; }
        .nav-link-custom.logout-link { color: #dc2626; border-top: 1px solid var(--border-color); border-radius: 0; padding-top: 16px; }
        .nav-link-custom.logout-link:hover { background-color: var(--danger-bg); color: var(--danger-text); border-radius: 8px; }

        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-body); }
        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        .form-card { background-color: #ffffff; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); margin-bottom: 24px; }
        .form-label { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 6px; letter-spacing: 0.5px; }
        .form-control, .form-select { border-color: var(--border-color); border-radius: 8px; font-size: 14px; height: 42px; color: var(--text-main); }
        .form-control:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-light); }

        .btn-dark-custom { background-color: var(--primary); color: white; border: none; font-weight: 600; border-radius: 8px; height: 44px; transition: all 0.2s; }
        .btn-dark-custom:hover { background-color: #154cbf; }

        .version-box { border: 1px solid var(--border-color); border-radius: 12px; margin-bottom: 24px; overflow: hidden; background: #ffffff; }
        .version-header { background-color: #f8fafc; padding: 14px 20px; border-bottom: 1px solid var(--border-color); font-weight: 700; color: var(--text-main); font-size: 13px; }

        .btn-nhap-imei-chuan { background-color: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; font-weight: 600; font-size: 13px; padding: 6px 14px; border-radius: 6px; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-nhap-imei-chuan:hover { background-color: #a7f3d0; }

        .btn-xoa-imei-chip { cursor: pointer; transition: transform 0.2s; }
        .btn-xoa-imei-chip:hover { transform: scale(1.3); }

        .toast-container-custom { position: fixed; top: 24px; right: 24px; z-index: 1090; }
        .custom-toast { min-width: 320px; background-color: #ffffff; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); padding: 14px 18px; display: flex; align-items: center; gap: 12px; animation: slideInRight 0.3s ease; }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>

<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="san-pham"/>
    <jsp:param name="activeSub"  value="hien-thi-sp"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">

        <div class="toast-container-custom" id="boxDynamicToast"></div>

        <div class="mb-4 d-flex justify-content-between align-items-center">
            <div>
                <h4 class="fw-bold mb-1" style="color: var(--text-main);">Thêm dòng máy & Biến thể</h4>
                <small class="text-muted">Thiết kế chuẩn hóa thuộc tính vật lý và cấu hình thương mại</small>
            </div>
            <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách</a>
        </div>

        <form id="formRealThemSanPham" action="${pageContext.request.contextPath}/san-pham/them" method="POST">
            <div class="form-card">
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <label class="form-label">Tên dòng máy sản phẩm *</label>
                        <input type="text" id="tenSanPhamInput" name="tenSanPham" class="form-control" placeholder="Ví dụ: Dell Vostro 5620..." required oninput="dongBoTenBienThe()">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Danh mục nhóm *</label>
                        <select name="idDanhMuc" class="form-select" required>
                            <c:forEach items="${listDanhMuc}" var="dm"><option value="${dm.id}">${dm.tenDanhMuc}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Thương hiệu sản xuất *</label>
                        <select name="idThuongHieu" class="form-select" required>
                            <c:forEach items="${listThuongHieu}" var="th"><option value="${th.id}">${th.tenThuongHieu}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Nhà cung cấp lô hàng *</label>
                        <select name="idNhaCungCapForm" class="form-select" required>
                            <c:forEach items="${listNhaCungCap}" var="ncc"><option value="${ncc.id}">${ncc.tenNhaCungCap}</option></c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Hệ điều hành tích hợp *</label>
                        <select name="heDieuHanh" class="form-select" required>
                            <option value="Windows 11 Home">Windows 11 Home</option>
                            <option value="Windows 11 Pro">Windows 11 Pro</option>
                            <option value="macOS">macOS</option>
                            <option value="FreeDOS">FreeDOS</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Kích thước màn hình *</label>
                        <select name="idManHinh" class="form-select" required>
                            <c:forEach items="${listManHinh}" var="mh"><option value="${mh.id}">${mh.tenManHinh} (${mh.kichThuoc})</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thông số Pin máy *</label>
                        <select name="idPin" class="form-select" required>
                            <c:forEach items="${listPin}" var="p"><option value="${p.id}">${p.tenPin}</option></c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Bộ vi xử lý (CPU) *</label>
                        <select name="idCpu" class="form-select" required>
                            <c:forEach items="${listCpu}" var="cpu"><option value="${cpu.id}">${cpu.tenCpu}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Card đồ họa (GPU) *</label>
                        <select name="idGpu" class="form-select" required>
                            <c:forEach items="${listGpu}" var="gpu"><option value="${gpu.id}">${gpu.tenGpu}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thời gian bảo hành (Tháng)</label>
                        <input type="number" name="hanBaoHanh" class="form-control" value="12" min="1" required>
                    </div>
                </div>
            </div>

            <div class="form-card">
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Chọn các Màu sắc *</label>
                        <select id="selectMàu" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                            <c:forEach items="${listMauSac}" var="ms"><option value="${ms.id}">${ms.tenMauSac}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Chọn dung lượng RAM *</label>
                        <select id="selectRam" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                            <c:forEach items="${listRam}" var="ram"><option value="${ram.id}">${ram.dungLuongRam}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Chọn dung lượng Ổ cứng SSD *</label>
                        <select id="selectOCung" class="form-select select2-tag-build" multiple="multiple" style="width: 100%">
                            <c:forEach items="${listOCung}" var="oc"><option value="${oc.id}">${oc.dungLuongOCung}</option></c:forEach>
                        </select>
                    </div>
                </div>
                <button type="button" class="btn btn-dark-custom w-100" onclick="generateTổHợpBiếnThể()">
                    <i class="fa-solid fa-bolt me-2"></i> Ren Mã Biến Thể
                </button>
            </div>

            <div class="d-none" id="khungChứaBiếnThể">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-dark mb-0"><i class="fa-solid fa-layer-group me-1"></i> Danh sách biến thể thương mại cấu hình độc lập</h6>
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearBảng()"><i class="fa-solid fa-trash-can me-1"></i> Xóa bảng</button>
                </div>

                <div id="vùngChứaBảngĐộng"></div>

                <div class="d-flex justify-content-end gap-3 mt-4">
                    <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="btn btn-light border px-4">HỦY BỎ</a>
                    <button type="button" class="btn btn-dark-custom px-5" onclick="xuLySubmitKiemTra()">HOÀN TẤT LƯU TOÀN BỘ SẢN PHẨM</button>
                </div>
            </div>

            <!-- MODAL NHẬP NHANH IMEI CHO NHIỀU BIẾN THỂ -->
            <div class="modal fade" id="imeiModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content border-0 shadow-lg" style="border-radius: 12px;">
                        <div class="modal-header border-0 pt-4 px-4 pb-2">
                            <div>
                                <h5 class="modal-title fw-bold text-dark" style="font-size: 16px;">
                                    <i class="fa-solid fa-barcode text-primary me-2"></i>Nhập nhanh danh sách IMEI cho Biến thể
                                </h5>
                                <small class="text-muted">Mỗi dòng là 1 IMEI tự động phân bổ xuống lần lượt từng Biến thể (1 Biến thể = 1 IMEI)</small>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body px-4">
                            <input type="hidden" id="currentInputIndexTarget">

                            <div class="alert alert-info py-2 px-3 mb-2 small d-flex align-items-center gap-2" style="font-size:12px;">
                                <i class="fa-solid fa-circle-info fs-6"></i>
                                <span>Trên bảng có tổng cộng <b id="lblTongSoBienTheModal" class="text-danger">0</b> biến thể. Bạn chỉ được gõ tối đa <b id="lblMaxEnterModal" class="text-danger">0</b> dòng.</span>
                            </div>

                            <label class="form-label text-secondary mb-1">Bắn hoặc gõ mã IMEI (Bấm Enter để xuống dòng):</label>

                            <!-- Khung nhập dữ liệu -->
                            <textarea id="txtAreaImeiTemp" class="form-control font-monospace mb-3" rows="5" placeholder="Ví dụ:&#10;IMEI-DELL-001&#10;IMEI-DELL-002" style="text-transform: uppercase; font-size: 13px;"></textarea>

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="small text-muted fw-semibold">Kết quả phân bổ Real-time:</span>
                                <span id="lblCountImeiModal" class="badge bg-success font-monospace" style="font-size:12px;">0 / 0 Máy hợp lệ</span>
                            </div>

                            <!-- BẢNG PREVIEW CHỨA NÚT XÓA [X] VÀ BÁO XANH/ĐỎ -->
                            <div class="p-2 bg-light border rounded font-monospace" id="boxImeiListPreview" style="max-height:220px; overflow-y:auto; font-size:12px;">
                                Chưa có mã nào được nhập...
                            </div>
                        </div>
                        <div class="modal-footer border-0 p-4 pt-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearModalTextArea()">XÓA TRỐNG</button>
                            <button type="button" class="btn btn-sm btn-dark-custom px-4" onclick="xacNhanPhanBoImei()">XÁC NHẬN PHÂN BỔ IMEI</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let globalIndex = 0;
    const REGEX_IMEI = /^[A-Z0-9\-_]{5,30}$/;

    $(document).ready(function() {
        $('.select2-tag-build').select2({ placeholder: "Bấm chọn thuộc tính...", allowClear: true });

        // 🟢 1. CHẶN KHÔNG CHO ENTER NẾU DÒNG VƯỢT QUÁ SỐ LƯỢNG BIẾN THỂ
        $('#txtAreaImeiTemp').on('keydown', function(e) {
            if (e.key === 'Enter') {
                const rows = document.querySelectorAll("#vùngChứaBảngĐộng table tbody tr");
                let maxBienThe = rows.length || 1;

                let txt = $(this).val();
                let lines = txt.split(/\r?\n/);

                // Nếu số dòng hiện tại đã đạt bằng số biến thể -> CHẶN ENTER
                if (lines.length >= maxBienThe) {
                    e.preventDefault();
                    hienThongBaoToast("Số dòng IMEI đã đạt tối đa bằng số Biến thể hiện có (" + maxBienThe + " biến thể)! Không thể xuống dòng nữa.", "warning");
                }
            }
        });

        // 🟢 2. XỬ LÝ CHECK REAL-TIME XANH / ĐỎ
        $('#txtAreaImeiTemp').on('input', function() {
            let txt = $(this).val().toUpperCase();
            txt = txt.replace(/[^A-Z0-9,\n\r\-_]/g, '');
            $(this).val(txt);

            const rows = document.querySelectorAll("#vùngChứaBảngĐộng table tbody tr");
            let lines = txt.split(/\r?\n/).map(s => s.trim()).filter(s => s.length > 0);

            let htmlPreview = '';
            let countHopLe = 0;
            let setCheckUnique = new Set();

            lines.forEach((imei, idx) => {
                let isFormatOk = REGEX_IMEI.test(imei);
                let isDuplicate = setCheckUnique.has(imei);
                setCheckUnique.add(imei);

                // Lấy tên cấu hình biến thể tương ứng
                let targetRow = rows[idx];
                let tenBienTheLabel = "Biến thể #" + (idx + 1);
                if (targetRow) {
                    let mau = targetRow.querySelector("td:nth-child(3)").innerText.trim();
                    tenBienTheLabel = "Gán cho [" + mau + "]";
                }

                if (isFormatOk && !isDuplicate) {
                    countHopLe++;
                    // 🟢 BÁO XANH + BỔ SUNG DẤU [X] ĐỂ XÓA
                    htmlPreview += `
                        <div class="d-flex align-items-center justify-content-between p-2 mb-2 rounded font-monospace" style="background-color: #d1fae5; border: 1px solid #059669;">
                            <span class="fw-bold text-success"><i class="fa-solid fa-check-circle me-2"></i>` + (idx + 1) + `. ` + imei + `</span>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-success">` + tenBienTheLabel + `</span>
                                <i class="fa-solid fa-xmark text-danger fs-6 btn-xoa-imei-chip ms-2" title="Xóa dòng này" onclick="xoaDongImeiKhoiTextarea(` + idx + `)"></i>
                            </div>
                        </div>`;
                } else {
                    // 🔴 BÁO ĐỎ + DẤU [X] ĐỂ XÓA
                    let lyDo = isDuplicate ? "Trùng mã" : "Sai độ dài (5-30 ký tự)";
                    htmlPreview += `
                        <div class="d-flex align-items-center justify-content-between p-2 mb-2 rounded font-monospace" style="background-color: #ffe4e6; border: 1px solid #dc2626;">
                            <span class="fw-bold text-danger"><i class="fa-solid fa-circle-xmark me-2"></i>` + (idx + 1) + `. ` + imei + `</span>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-danger">` + lyDo + `</span>
                                <i class="fa-solid fa-xmark text-danger fs-6 btn-xoa-imei-chip ms-2" title="Xóa dòng này" onclick="xoaDongImeiKhoiTextarea(` + idx + `)"></i>
                            </div>
                        </div>`;
                }
            });

            $('#lblCountImeiModal').text(countHopLe + " / " + lines.length + " Máy hợp lệ");
            $('#boxImeiListPreview').html(htmlPreview || '<div class="text-muted small p-2">Chưa có mã nào được nhập...</div>');
        });
    });

    // 🟢 HÀM XÓA BẰNG DẤU [X] NGAY BÊN CẠNH IMEI
    function xoaDongImeiKhoiTextarea(indexXoa) {
        let txt = $('#txtAreaImeiTemp').val();
        let lines = txt.split(/\r?\n/).map(s => s.trim()).filter(s => s.length > 0);

        if (indexXoa >= 0 && indexXoa < lines.length) {
            lines.splice(indexXoa, 1);
        }

        $('#txtAreaImeiTemp').val(lines.join('\n'));
        $('#txtAreaImeiTemp').trigger('input');
    }

    function dongBoTenBienThe() {
        const textName = document.getElementById("tenSanPhamInput").value || "Sản phẩm mới";
        document.querySelectorAll(".sync-name-label").forEach(el => el.innerText = textName);
    }

    // 🟢 MỞ MODAL NHẬP IMEI VÀ CẬP NHẬT TỔNG SỐ BIẾN THỂ
    function moModalImei(index) {
        const rows = document.querySelectorAll("#vùngChứaBảngĐộng table tbody tr");
        if (rows.length === 0) {
            hienThongBaoToast("Vui lòng bấm 'Ren Mã Biến Thể' trước!", "error");
            return;
        }

        document.getElementById("lblTongSoBienTheModal").innerText = rows.length;
        document.getElementById("lblMaxEnterModal").innerText = rows.length;

        // Gom toàn bộ IMEI hiện tại của tất cả các dòng biến thể gom lên Textarea
        let listImeiCurrent = [];
        rows.forEach(r => {
            let val = r.querySelector("textarea[name='soSeriDong']").value.trim();
            if (val) listImeiCurrent.push(val);
        });

        document.getElementById("txtAreaImeiTemp").value = listImeiCurrent.join('\n');
        $('#txtAreaImeiTemp').trigger('input');
        $('#imeiModal').modal('show');
    }

    // 🟢 XÁC NHẬN PHÂN BỔ: DÒNG 1 -> BIẾN THỂ 1, DÒNG 2 -> BIẾN THỂ 2...
    function xacNhanPhanBoImei() {
        const rows = document.querySelectorAll("#vùngChứaBảngĐộng table tbody tr");
        let txt = $('#txtAreaImeiTemp').val();
        let lines = txt.split(/\r?\n/).map(s => s.trim().toUpperCase()).filter(s => s.length > 0);

        // Kiểm tra xem có mã lỗi không
        for (let i = 0; i < lines.length; i++) {
            if (!REGEX_IMEI.test(lines[i])) {
                hienThongBaoToast("Có mã IMEI chưa đúng định dạng: [" + lines[i] + "]. Vui lòng sửa lại trước khi lưu!", "error");
                return;
            }
        }

        // GÁN CHÍNH XÁC: 1 BIẾN THỂ = 1 IMEI
        rows.forEach((row, idx) => {
            let hiddenInput = row.querySelector("textarea[name='soSeriDong']");
            let badgeBtn = row.querySelector(".btn-nhap-imei-chuan");

            if (idx < lines.length) {
                hiddenInput.value = lines[idx]; // Gán 1 IMEI cho biến thể này
                badgeBtn.querySelector(".txt-count-imei-label").innerText = "1 Máy (" + lines[idx] + ")";
                badgeBtn.style.backgroundColor = "#d1fae5";
                badgeBtn.style.borderColor = "#059669";
                badgeBtn.style.color = "#047857";
            } else {
                hiddenInput.value = "";
                badgeBtn.querySelector(".txt-count-imei-label").innerText = "0 Máy";
                badgeBtn.style.backgroundColor = "#ecfdf5";
                badgeBtn.style.borderColor = "#a7f3d0";
                badgeBtn.style.color = "#059669";
            }
        });

        hienThongBaoToast("Đã phân bổ thành công " + Math.min(lines.length, rows.length) + " mã IMEI vào từng Biến thể!", "success");
        $('#imeiModal').modal('hide');
    }

    function formatInputTienTe(inputEl, hiddenId) {
        let rawValue = inputEl.value.replace(/[^0-9]/g, '');
        const hiddenEl = document.getElementById(hiddenId);
        if (hiddenEl) hiddenEl.value = rawValue ? rawValue : "0";
        inputEl.value = rawValue ? Number(rawValue).toLocaleString('vi-VN').replace(/,/g, '.') : '';
    }

    function generateTổHợpBiếnThể() {
        const mauSel = $('#selectMàu').select2('data');
        const ramSel = $('#selectRam').select2('data');
        const ocSel = $('#selectOCung').select2('data');
        const vungChua = document.getElementById("vùngChứaBảngĐộng");
        const tenSp = document.getElementById("tenSanPhamInput").value || "Sản phẩm mới";

        if (mauSel.length === 0 || ramSel.length === 0 || ocSel.length === 0) {
            hienThongBaoToast("Vui lòng chọn đầy đủ Màu sắc, RAM và Ổ cứng!", "error");
            return;
        }

        let biTrungCount = 0;
        let demBienTheMoiCreated = 0;

        ramSel.forEach(r => {
            ocSel.forEach(oc => {
                let idBox = "box-" + r.id + "-" + oc.id;
                let boxElement = document.getElementById(idBox);

                if (!boxElement) {
                    let htmlHeader = `
                        <div class="version-box" id="`+idBox+`">
                           <div class="version-header"><i class="fa-solid fa-gear me-1 text-secondary"></i> CẤU HÌNH MÁY: RAM `+r.text+` | SSD `+oc.text+`</div>
                           <table class="table align-middle text-center mb-0 table-hover" style="font-size:13px;">
                               <thead class="table-light text-secondary" style="font-size:11px; font-weight:600; text-transform:uppercase;">
                                   <tr>
                                       <th style="width:60px;">STT</th>
                                       <th>TÊN BIẾN THỂ SẢN PHẨM</th>
                                       <th>MÀU SẮC</th>
                                       <th style="width:220px;">MÃ IMEI / SERI (1 MÁY)</th>
                                       <th style="width:180px;">ĐƠN GIÁ BÁN (VND)</th>
                                       <th style="width:180px;">GIÁ NHẬP KHO (VND)</th>
                                       <th style="width:80px;">HÀNH ĐỘNG</th>
                                   </tr>
                               </thead>
                               <tbody></tbody>
                           </table>
                        </div>`;
                    vungChua.insertAdjacentHTML('beforeend', htmlHeader);
                    boxElement = document.getElementById(idBox);
                }

                const tbody = boxElement.querySelector("tbody");

                mauSel.forEach(function(m) {
                    let rowExist = tbody.querySelector(`tr[data-ram="`+r.id+`"][data-ocung="`+oc.id+`"][data-mau="`+m.id+`"]`);

                    if (rowExist) {
                        biTrungCount++;
                    } else {
                        globalIndex++;
                        demBienTheMoiCreated++;
                        let currentStt = tbody.querySelectorAll("tr").length + 1;

                        let htmlRow = `
                            <tr id="tr-row-`+globalIndex+`" data-ram="`+r.id+`" data-ocung="`+oc.id+`" data-mau="`+m.id+`">
                               <td class="fw-semibold text-secondary text-center stt-index-cell">`+currentStt+`</td>
                               <td class="sync-name-label fw-bold text-dark text-center">`+tenSp+`</td>
                               <td class="fw-medium text-dark text-center"><i class="fa-solid fa-palette me-1 text-muted"></i> `+m.text+`</td>
                               <td class="text-center">
                                   <button type="button" class="btn-nhap-imei-chuan" id="badge-count-`+globalIndex+`" data-config="RAM `+r.text+` - SSD `+oc.text+`" data-color="`+m.text+`" onclick="moModalImei(`+globalIndex+`)">
                                       <i class="fa-solid fa-barcode"></i> <span class="txt-count-imei-label">0 Máy</span>
                                   </button>
                                   <input type="hidden" name="idRamDong" value="`+r.id+`">
                                   <input type="hidden" name="idOCungDong" value="`+oc.id+`">
                                   <input type="hidden" name="idMauSacDong" value="`+m.id+`">
                                   <textarea name="soSeriDong" id="imei-hidden-`+globalIndex+`" class="d-none"></textarea>
                               </td>
                               <td>
                                   <input type="text" class="form-control form-control-sm text-center font-monospace mx-auto" value="0" style="width:90%; height:36px; background-color:#ffffff;" required oninput="formatInputTienTe(this, 'giaBanHidden_`+globalIndex+`')">
                                   <input type="hidden" name="giaBanDong" id="giaBanHidden_`+globalIndex+`" value="0">
                               </td>
                               <td>
                                   <input type="text" class="form-control form-control-sm text-center font-monospace mx-auto" value="0" style="width:90%; height:36px; background-color:#ffffff;" required oninput="formatInputTienTe(this, 'giaNhapHidden_`+globalIndex+`')">
                                   <input type="hidden" name="giaNhapDong" id="giaNhapHidden_`+globalIndex+`" value="0">
                               </td>
                               <td class="text-center">
                                   <button type="button" class="btn btn-sm btn-link text-danger p-0" onclick="gỡDòngDữLiệu(`+globalIndex+`, '`+idBox+`')">
                                       <i class="fa-regular fa-trash-can" style="font-size:15px;"></i>
                                   </button>
                               </td>
                            </tr>`;
                        tbody.insertAdjacentHTML('beforeend', htmlRow);
                    }
                });
            });
        });

        document.getElementById("khungChứaBiếnThể").classList.remove("d-none");
        dongBoTenBienThe();

        if(demBienTheMoiCreated > 0) {
            hienThongBaoToast("Đã sinh thành công " + demBienTheMoiCreated + " biến thể!", "success");
        }
    }

    function gỡDòngDữLiệu(idx, idBox) {
        const rowTarget = document.getElementById("tr-row-" + idx);
        if (rowTarget) {
            const box = document.getElementById(idBox);
            rowTarget.remove();
            if (box && box.querySelectorAll("tbody tr").length === 0) box.remove();
        }
        if (document.querySelectorAll("#vùngChứaBảngĐộng .version-box").length === 0) clearBảng();
    }

    function clearModalTextArea() {
        document.getElementById("txtAreaImeiTemp").value = "";
        $('#txtAreaImeiTemp').trigger('input');
    }

    function clearBảng() {
        document.getElementById("vùngChứaBảngĐộng").innerHTML = "";
        document.getElementById("khungChứaBiếnThể").classList.add("d-none");
    }

    function hienThongBaoToast(message, type) {
        const colorBorder = (type === 'success') ? '#16a34a' : (type === 'warning' ? '#d97706' : '#dc2626');
        const iconClass = (type === 'success') ? 'fa-circle-check text-success' : (type === 'warning' ? 'fa-triangle-exclamation text-warning' : 'fa-circle-exclamation text-danger');

        const toastHtml = `
            <div class="custom-toast" style="border-left: 4px solid `+colorBorder+`;">
                <i class="fa-solid `+iconClass+` fs-4"></i>
                <div>
                    <h6 class="mb-0 fw-bold text-dark" style="font-size: 14px;">Thông báo</h6>
                    <small class="text-muted" style="font-size: 13px;">`+message+`</small>
                </div>
            </div>`;

        const box = document.getElementById("boxDynamicToast");
        box.innerHTML = toastHtml;
        setTimeout(() => box.innerHTML = "", 3500);
    }

    function xuLySubmitKiemTra() {
        const tenInput = document.getElementById("tenSanPhamInput");
        if (!tenInput.value.trim()) {
            hienThongBaoToast("Tên sản phẩm không được để trống!", "error");
            tenInput.focus();
            return;
        }

        const rows = document.querySelectorAll("#vùngChứaBảngĐộng table tbody tr");
        if (rows.length === 0) {
            hienThongBaoToast("Bạn chưa sinh ma trận cấu hình biến thể!", "error");
            return;
        }

        document.getElementById("formRealThemSanPham").submit();
    }
</script>
</body>
</html>