<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật nhân viên - Skycomputer</title>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- FontAwesome Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #1a56db;
            --primary-light: #e6efff;
            --sidebar-active: #eef2ff;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --bg-body: #f8f9fa;
            --border-color: #e5e7eb;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            display: flex;
            height: 100vh;
            background-color: var(--bg-body);
            color: var(--text-main);
            overflow: hidden;
        }

                /* 🎨 --- SIDEBAR --- */
        .sidebar {
            width: 260px;
            background-color: #fff;
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            height: 100vh;
            padding-bottom: 16px;
            z-index: 10;
        }

        .brand {
            display: flex;
            align-items: center;
            padding: 20px 20px;
            gap: 12px;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 12px;
        }

        .brand-logo {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff;
        }

        .brand-logo img { width: 100%; height: 100%; object-fit: contain; }
        .brand-text h1 { font-size: 16px; font-weight: 700; color: #1e3a8a; margin-bottom: 0px;}
        .brand-text p { font-size: 11px; color: var(--text-muted); margin-bottom: 0; }

        .nav-menu { list-style: none; padding: 0 12px; flex: 1; overflow-y: auto; }
        .nav-item { margin-bottom: 4px; }

        .nav-link-custom {
            display: flex;
            align-items: center;
            padding: 11px 16px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            gap: 12px;
        }
        .nav-link-custom i { font-size: 16px; width: 20px; text-align: center; }
        .nav-link-custom:hover { background-color: #f3f4f6; color: var(--text-main); }
        .nav-link-custom.active { background-color: var(--sidebar-active); color: var(--primary); font-weight: 600; }

        .sub-menu {
            list-style: none;
            padding-left: 0;
            margin-top: 4px;
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .sub-menu .nav-link-custom {
            padding: 9px 16px 9px 44px !important;
            font-size: 13px;
        }
        .sub-menu .nav-link-custom.active-sub {
            background-color: var(--sidebar-active);
            color: var(--primary);
            font-weight: 600;
        }

        .logout-item { margin-top: auto; padding: 0 12px; }
        .nav-link-custom.logout-link { color: #dc2626; border-top: 1px solid var(--border-color); border-radius: 0; padding-top: 16px; }
        .nav-link-custom.logout-link:hover { background-color: var(--danger-bg); color: var(--danger-text); border-radius: 8px; }


        /* --- MAIN CONTENT LAYOUT --- */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .top-header {
            height: 70px;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }

        .header-actions { display: flex; align-items: center; gap: 24px; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 20px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0px; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }

        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 14px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }

        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        /* --- FORM CARD --- */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-title h2 { font-size: 20px; font-weight: 600; margin-bottom: 4px; }
        .page-title p { font-size: 13px; color: var(--text-muted); }

        .btn { padding: 10px 20px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 8px; border: none; transition: 0.2s; text-decoration: none;}
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }

        .form-card {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            margin-bottom: 32px;
        }

        .section-title {
            font-size: 14px;
            font-weight: 600;
            color: #1e3a8a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 20px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--primary-light);
        }

        /* --- FORM GRID SYSTEM --- */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 32px;
        }

        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group.span-3 { grid-column: span 3; }

        .form-group label { font-size: 13px; font-weight: 500; color: var(--text-main); }
        .form-group label span { color: #dc2626; margin-left: 2px; }

        .input-wrapper { position: relative; }
        .input-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px;}

        .form-control { width: 100%; padding: 11px 14px 11px 38px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 13.5px; color: var(--text-main); outline: none; transition: 0.2s; }
        .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(26,86,219,0.1); }

        select.form-control { padding-left: 14px; appearance: none; background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="%236b7280" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>') no-repeat right 14px center; }

        .radio-group { display: flex; gap: 24px; padding: 11px 0; }
        .radio-label { display: flex; align-items: center; gap: 8px; font-size: 13.5px; cursor: pointer; color: var(--text-main); }
        .radio-label input[type="radio"] { width: 16px; height: 16px; accent-color: var(--primary); cursor: pointer; }

        .form-actions { display: flex; justify-content: flex-end; gap: 12px; padding-top: 20px; border-top: 1px solid var(--border-color); }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="brand">
        <div class="brand-logo">
            <img src="/img/logo.jpg" alt="Skycomputer Logo">
        </div>
        <div class="brand-text">
            <h1>Skycomputer</h1>
            <p>Hệ thống quản lý</p>
        </div>
    </div>

    <ul class="nav-menu">
        <li class="nav-item">
            <a href="/tong_quan" class="nav-link-custom"><i class="fa-solid fa-border-all"></i> Trang tổng quan</a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/ban-hang" class="nav-link-custom"><i class="fa-solid fa-store"></i> Bán hàng tại quầy</a>
        </li>

        <!-- DROPDOWN QUẢN LÝ SẢN PHẨM -->
        <li class="nav-item">
            <a href="#sub-san-pham" class="nav-link-custom d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button" aria-expanded="false">
                <span><i class="fa-solid fa-box"></i> Quản lý sản phẩm</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 10px; transition: transform 0.2s;"></i>
            </a>
            <div class="collapse" id="sub-san-pham">
                <ul class="sub-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="nav-link-custom">
                            <i class="fa-solid fa-list me-1"></i> Danh sách sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" class="nav-link-custom">
                            <i class="fa-solid fa-circle-info me-1"></i> Sản phẩm chi tiết
                        </a>
                    </li>
                </ul>
            </div>
        </li>

        <!-- QUẢN LÝ HÓA ĐƠN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/hoa-don/hien-thi" class="nav-link-custom"><i class="fa-solid fa-file-invoice"></i> Quản lý hóa đơn</a>
        </li>

        <!-- QUẢN LÝ KHÁCH HÀNG -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/khach-hang/hien-thi" class="nav-link-custom"><i class="fa-solid fa-users"></i> Quản lý khách hàng</a>
        </li>

        <!-- QUẢN LÝ NHÂN VIÊN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="nav-link-custom active"><i class="fa-solid fa-id-badge"></i> Quản lý nhân viên</a>
        </li>

        <!-- DROPDOWN QUẢN LÝ THUỘC TÍNH -->
        <li class="nav-item">
            <a href="#sub-thuoc-tinh" class="nav-link-custom d-flex justify-content-between align-items-center" data-bs-toggle="collapse" role="button" aria-expanded="false">
                <span><i class="fa-solid fa-sliders"></i> Quản lý thuộc tính</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 10px; transition: transform 0.2s;"></i>
            </a>
            <div class="collapse" id="sub-thuoc-tinh">
                <ul class="sub-menu">
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/cpu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-microchip me-1"></i> Cấu hình CPU</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/ram/hien-thi" class="nav-link-custom"><i class="fa-solid fa-memory me-1"></i> Cấu hình RAM</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/o-cung/hien-thi" class="nav-link-custom"><i class="fa-solid fa-hard-drive me-1"></i> Ổ cứng</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/gpu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-clone me-1"></i> Card đồ họa (GPU)</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/man-hinh/hien-thi" class="nav-link-custom"><i class="fa-solid fa-display me-1"></i> Màn hình</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/hien-thi" class="nav-link-custom"><i class="fa-solid fa-palette me-1"></i> Màu sắc</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/pin/hien-thi" class="nav-link-custom"><i class="fa-solid fa-battery-three-quarters me-1"></i> Thông số Pin</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/danh-muc/hien-thi" class="nav-link-custom"><i class="fa-solid fa-layer-group me-1"></i> Danh mục sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/thuong-hieu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-copyright me-1"></i> Thương hiệu</a></li>
                </ul>
            </div>
        </li>
    </ul>

    <div class="logout-item">
        <a href="${pageContext.request.contextPath}/dang-xuat" class="nav-link-custom logout-link">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</aside>

<!-- MAIN WRAPPER -->
<main class="main-wrapper">
    <header class="top-header">
        <div class="header-actions">
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
            <div class="user-profile">
                <div class="user-info">
                    <div class="user-name">Admin User</div>
                    <div class="user-role">QUẢN TRỊ VIÊN</div>
                </div>
                <img src="https://i.pravatar.cc/150?img=11" alt="Avatar" class="avatar">
            </div>
        </div>
    </header>

    <!-- Content Area -->
    <div class="content-area">

        <div class="page-header">
            <div class="page-title">
                <h2>Cập nhật thông tin nhân viên</h2>
                <p>Chỉnh sửa hồ sơ nhân viên mã: <strong>${nv.maNhanVien}</strong></p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-outline">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/nhan-vien/update" method="POST"
                  onsubmit="return confirm('Bạn có chắc chắn muốn cập nhật thay đổi cho nhân viên ${nv.hoTen} không?');">

                <!-- Giữ lại ID ẩn để phục vụ câu lệnh UPDATE WHERE id = ? -->
                <input type="hidden" name="id" value="${nv.id}">

                <div class="section-title">Thông tin hồ sơ nhân sự</div>
                <div class="form-grid">

                    <div class="form-group">
                        <label>Họ và tên <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-user"></i>
                            <input type="text" name="hoTen" class="form-control" value="${nv.hoTen}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-phone"></i>
                            <input type="tel" name="sdt" class="form-control" value="${nv.sdt}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Giới tính <span>*</span></label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="gioiTinh" value="true" ${nv.gioiTinh ? 'checked' : ''}>
                                <i class="fa-solid fa-mars" style="color: #1d4ed8;"></i> Nam
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gioiTinh" value="false" ${!nv.gioiTinh ? 'checked' : ''}>
                                <i class="fa-solid fa-venus" style="color: #db2777;"></i> Nữ
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Ngày sinh <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-calendar"></i>
                            <input type="date" name="ngaySinh" class="form-control" value="${nv.ngaySinh}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Email <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-regular fa-envelope"></i>
                            <input type="email" name="email" class="form-control" value="${nv.email}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Chức vụ <span>*</span></label>
                        <select name="chucVu" class="form-control" required>
                            <option value="Quản trị viên" ${nv.chucVu == 'Quản trị viên' ? 'selected' : ''}>Quản trị viên</option>
                            <option value="Nhân viên bán hàng" ${nv.chucVu == 'Nhân viên bán hàng' ? 'selected' : ''}>Nhân viên bán hàng</option>
                            <option value="Nhân viên kỹ thuật" ${nv.chucVu == 'Nhân viên kỹ thuật' ? 'selected' : ''}>Nhân viên kỹ thuật</option>
                        </select>
                    </div>

                </div>

                <!-- ĐỊA CHỈ: ĐỒNG BỘ 3 DROPDOWN + TỰ ĐỘNG CHỌN GIÁ TRỊ CŨ -->
                <div class="section-title">Địa chỉ cư trú</div>
                <div class="form-grid">

                    <div class="form-group">
                        <label>Tỉnh / Thành phố <span>*</span></label>
                        <select id="provinceSelect" name="tinhThanh" class="form-control" required onchange="onProvinceChange(this)">
                            <option value="" disabled selected>Chọn Tỉnh/Thành phố...</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Quận / Huyện <span>*</span></label>
                        <select id="districtSelect" name="quanHuyen" class="form-control" required disabled onchange="onDistrictChange(this)">
                            <option value="" disabled selected>Chọn Quận/Huyện...</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Phường / Xã <span>*</span></label>
                        <select id="wardSelect" name="phuongXa" class="form-control" required disabled>
                            <option value="" disabled selected>Chọn Phường/Xã...</option>
                        </select>
                    </div>

                    <div class="form-group span-3">
                        <label>Số nhà, tên đường, ngõ hẻm <span>*</span></label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-location-dot"></i>
                            <input type="text" id="diaChiChiTietInput" name="diaChiChiTiet" class="form-control" placeholder="Ví dụ: Số 45 Nguyễn Văn Linh..." required>
                        </div>
                    </div>

                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-outline">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-pen-to-square"></i> Cập nhật nhân viên
                    </button>
                </div>

            </form>
        </div>

    </div>
</main>

<!-- JAVASCRIPT XỬ LÝ API VÀ AUTO SELECT ĐỊA CHỈ CŨ -->

<script>
    // Lấy chuỗi địa chỉ cũ từ DB
    const rawOldAddress = `<c:out value="${nv.diaChi}" escapeXml="true"/>`;

    document.addEventListener('DOMContentLoaded', function () {
        initAddressData();
    });

    // Hàm chuẩn hóa chuỗi để so sánh (Xóa bỏ tiền tố Tỉnh/Thành/Quận/Huyện/Phường/Xã)
    function cleanText(str) {
        if (!str) return '';
        return str.toLowerCase()
            .replace(/(thành phố|tỉnh|quận|huyện|thị xã|phường|xã|thị trấn)/g, '')
            .trim();
    }

    // Hàm kiểm tra 2 tên địa danh có khớp nhau không
    function isMatch(name1, name2) {
        if (!name1 || !name2) return false;
        const c1 = cleanText(name1);
        const c2 = cleanText(name2);
        return c1.includes(c2) || c2.includes(c1);
    }

    async function initAddressData() {
        let oldChiTiet = "", oldXa = "", oldHuyen = "", oldTinh = "";

        if (rawOldAddress && rawOldAddress.includes(',')) {
            const parts = rawOldAddress.split(',').map(s => s.trim());
            if (parts.length >= 4) {
                oldChiTiet = parts[0];
                oldXa = parts[1];
                oldHuyen = parts[2];
                oldTinh = parts[3];
            } else if (parts.length === 3) {
                oldXa = parts[0];
                oldHuyen = parts[1];
                oldTinh = parts[2];
            }
        } else {
            oldChiTiet = rawOldAddress;
        }

        // Đổ địa chỉ chi tiết vào ô input
        document.getElementById('diaChiChiTietInput').value = oldChiTiet;

        // Tải danh sách Tỉnh/Thành
        const pSelect = document.getElementById('provinceSelect');
        try {
            const res = await fetch('https://provinces.open-api.vn/api/p/');
            const provinces = await res.json();

            pSelect.innerHTML = '<option value="" disabled selected>Chọn Tỉnh/Thành phố...</option>';
            let targetPCode = null;

            provinces.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.name;
                opt.dataset.code = p.code;
                opt.textContent = p.name;

                if (oldTinh && isMatch(p.name, oldTinh)) {
                    opt.selected = true;
                    targetPCode = p.code;
                }
                pSelect.appendChild(opt);
            });

            if (targetPCode) {
                await loadDistrictsForUpdate(targetPCode, oldHuyen, oldXa);
            }

        } catch (err) {
            console.error('Lỗi tải danh sách Tỉnh:', err);
        }
    }

    async function loadDistrictsForUpdate(pCode, oldHuyen, oldXa) {
        const dSelect = document.getElementById('districtSelect');
        dSelect.innerHTML = '<option value="" disabled selected>Chọn Quận/Huyện...</option>';

        try {
            const res = await fetch('https://provinces.open-api.vn/api/p/' + pCode + '?depth=2');
            const pData = await res.json();
            let targetDCode = null;

            pData.districts.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.name;
                opt.dataset.code = d.code;
                opt.textContent = d.name;

                if (oldHuyen && isMatch(d.name, oldHuyen)) {
                    opt.selected = true;
                    targetDCode = d.code;
                }
                dSelect.appendChild(opt);
            });
            dSelect.disabled = false;

            if (targetDCode) {
                await loadWardsForUpdate(targetDCode, oldXa);
            }
        } catch (err) {
            console.error('Lỗi tải danh sách Huyện:', err);
        }
    }

    async function loadWardsForUpdate(dCode, oldXa) {
        const wSelect = document.getElementById('wardSelect');
        wSelect.innerHTML = '<option value="" disabled selected>Chọn Phường/Xã...</option>';

        try {
            const res = await fetch('https://provinces.open-api.vn/api/d/' + dCode + '?depth=2');
            const dData = await res.json();

            dData.wards.forEach(w => {
                const opt = document.createElement('option');
                opt.value = w.name;
                opt.textContent = w.name;

                if (oldXa && isMatch(w.name, oldXa)) {
                    opt.selected = true;
                }
                wSelect.appendChild(opt);
            });
            wSelect.disabled = false;
        } catch (err) {
            console.error('Lỗi tải danh sách Xã:', err);
        }
    }

    // Sự kiện thay đổi ô chọn
    async function onProvinceChange(select) {
        const selectedOpt = select.options[select.selectedIndex];
        const pCode = selectedOpt.dataset.code;

        const dSelect = document.getElementById('districtSelect');
        const wSelect = document.getElementById('wardSelect');

        dSelect.innerHTML = '<option value="" disabled selected>Chọn Quận/Huyện...</option>';
        wSelect.innerHTML = '<option value="" disabled selected>Chọn Phường/Xã...</option>';
        wSelect.disabled = true;

        if (!pCode) {
            dSelect.disabled = true;
            return;
        }

        try {
            const res = await fetch('https://provinces.open-api.vn/api/p/' + pCode + '?depth=2');
            const pData = await res.json();

            pData.districts.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.name;
                opt.dataset.code = d.code;
                opt.textContent = d.name;
                dSelect.appendChild(opt);
            });
            dSelect.disabled = false;
        } catch (err) {
            console.error('Lỗi khi tải Quận/Huyện:', err);
        }
    }

    async function onDistrictChange(select) {
        const selectedOpt = select.options[select.selectedIndex];
        const dCode = selectedOpt.dataset.code;

        const wSelect = document.getElementById('wardSelect');
        wSelect.innerHTML = '<option value="" disabled selected>Chọn Phường/Xã...</option>';

        if (!dCode) {
            wSelect.disabled = true;
            return;
        }

        try {
            const res = await fetch('https://provinces.open-api.vn/api/d/' + dCode + '?depth=2');
            const dData = await res.json();

            dData.wards.forEach(w => {
                const opt = document.createElement('option');
                opt.value = w.name;
                opt.textContent = w.name;
                wSelect.appendChild(opt);
            });
            wSelect.disabled = false;
        } catch (err) {
            console.error('Lỗi khi tải Phường/Xã:', err);
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>