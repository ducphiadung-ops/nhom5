<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khách hàng - Skycomputer</title>

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
            justify-content: space-between;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }

        .search-global { position: relative; width: 400px; }
        .search-global i { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
        .search-global input { width: 100%; padding: 10px 16px 10px 40px; background-color: #f1f5f9; border: none; border-radius: 20px; font-size: 14px; outline: none; }

        .header-actions { display: flex; align-items: center; gap: 24px; }
        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 14px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }

        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        /* --- PAGE HEADER WITH BACK ARROW --- */
        .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 24px; }
        .btn-back { display: flex; align-items: center; justify-content: center; width: 36px; height: 36px; border-radius: 50%; background: #fff; border: 1px solid var(--border-color); color: var(--text-main); text-decoration: none; transition: 0.2s; }
        .btn-back:hover { background: #f3f4f6; }

        .page-title { display: flex; align-items: center; gap: 10px; }
        .page-title i { font-size: 20px; color: #10b981; }
        .page-title h2 { font-size: 20px; font-weight: 600; }

        /* --- FORM STYLES --- */
        .form-card {
            background: #fff;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
        }

        .form-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .form-card-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-main);
        }

        .info-layout { display: flex; gap: 48px; }

        .avatar-upload-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 160px;
            flex-shrink: 0;
        }
        .avatar-preview-box {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            border: 1px solid var(--border-color);
            overflow: hidden;
        }
        .avatar-preview-box i { font-size: 48px; color: #9ca3af; }
        .btn-upload-mock { padding: 6px 12px; background: #f3f4f6; border: 1px solid var(--border-color); border-radius: 6px; font-size: 12px; font-weight: 500; color: var(--text-main); cursor: pointer; margin-bottom: 6px; }
        .avatar-upload-section span { font-size: 11px; color: var(--text-muted); }

        .form-grid-fields { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 24px; flex: 1; }

        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group label { font-size: 13px; font-weight: 500; color: var(--text-main); }
        .form-group label span { color: #ef4444; margin-left: 2px; }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 13px;
            color: var(--text-main);
            outline: none;
            transition: border-color 0.2s;
        }
        .form-control:focus { border-color: var(--primary); }
        .form-control::placeholder { color: #9ca3af; }

        select.form-control {
            appearance: none;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="%236b7280" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>') no-repeat right 14px center;
            background-color: #fff;
        }

        .radio-group { display: flex; gap: 24px; margin-top: 6px; }
        .radio-label { display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 500; color: var(--text-main); cursor: pointer; }
        .radio-label input[type="radio"] {
            appearance: none;
            width: 18px;
            height: 18px;
            border: 2px solid var(--border-color);
            border-radius: 50%;
            outline: none;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .radio-label input[type="radio"]:checked { border-color: #10b981; }
        .radio-label input[type="radio"]:checked::before { content: ""; width: 10px; height: 10px; background-color: #10b981; border-radius: 50%; display: block; }

        /* ADDRESS CARD STYLES */
        .address-card {
            border: 1px solid #10b981;
            box-shadow: 0 0 0 1px #10b981;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            background: #fff;
            position: relative;
        }

        .address-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .address-card-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-main);
        }

        .address-card-title i { color: #10b981; }

        .address-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .address-detail-grid {
            display: grid;
            grid-template-columns: 3fr 1fr;
            gap: 20px;
        }

        .btn-add-address {
            background: #e6efff;
            color: var(--primary);
            border: 1px dashed var(--primary);
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: 0.2s;
        }
        .btn-add-address:hover { background: #dbe7ff; }

        .btn-delete-address {
            background: none;
            border: none;
            color: #ef4444;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-delete-address:hover { text-decoration: underline; }

        .form-actions-footer { display: flex; justify-content: flex-end; gap: 12px; margin-top: 12px; margin-bottom: 40px; }
        .btn { padding: 10px 20px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; transition: 0.2s; }
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }
    </style>
</head>
<body>

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
            <a href="${pageContext.request.contextPath}/khach-hang/hien-thi" class="nav-link-custom active"><i class="fa-solid fa-users"></i> Quản lý khách hàng</a>
        </li>

        <!-- QUẢN LÝ NHÂN VIÊN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="nav-link-custom"><i class="fa-solid fa-id-badge"></i> Quản lý nhân viên</a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/phieu-giam-gia/hien-thi" class="nav-link-custom"><i class="fa-solid fa-ticket"></i> Quản lý phiếu giảm giá</a>
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

<main class="main-wrapper">
    <header class="top-header">
        <div class="search-global">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" placeholder="Tìm kiếm tên, SĐT, mã khách hàng...">
        </div>

        <div class="header-actions">
            <div class="user-profile">
                <div class="user-info">
                    <div class="user-name">Admin User</div>
                    <div class="user-role">QUẢN TRỊ VIÊN</div>
                </div>
                <img src="https://i.pravatar.cc/150?img=11" alt="Avatar" class="avatar">
            </div>
        </div>
    </header>

    <div class="content-area">

        <div class="page-header">
            <a href="javascript:history.back()" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i>
            </a>
            <div class="page-title">
                <i class="fa-regular fa-address-book"></i>
                <h2>Thêm khách hàng</h2>
            </div>
        </div>

        <!-- FORM CHÍNH -->
        <form action="${pageContext.request.contextPath}/khach-hang/add" method="post">

            <!-- THÔNG TIN CHUNG -->
            <div class="form-card">
                <div class="form-card-header">
                    <div class="form-card-title">Thông tin chung</div>
                </div>

                <div class="info-layout">
                    <div class="avatar-upload-section">
                        <div class="avatar-preview-box">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <div class="btn-upload-mock">Chọn ảnh</div>
                        <span>Max 5MB</span>
                    </div>

                    <div class="form-grid-fields">
                        <div class="form-group">
                            <label>Họ và tên<span>*</span></label>
                            <input type="text" name="tenKhachHang" class="form-control" placeholder="Nhập họ và tên" required>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại<span>*</span></label>
                            <input type="text" name="sdt" class="form-control" placeholder="Nhập số điện thoại" required>
                        </div>

                        <div class="form-group">
                            <label>Email<span>*</span></label>
                            <input type="email" name="email" class="form-control" placeholder="example@email.com">
                        </div>

                        <div class="form-group">
                            <label>Ngày sinh<span>*</span></label>
                            <input type="date" name="ngaySinh" class="form-control">
                        </div>

                        <div class="form-group">
                            <label>Trạng thái</label>
                            <select name="trangThai" class="form-control">
                                <option value="true">Hoạt động</option>
                                <option value="false">Ngừng hoạt động</option>
                            </select>
                        </div>

                        <div class="form-group" style="grid-column: span 2;">
                            <label>Giới tính<span>*</span></label>
                            <div class="radio-group">
                                <label class="radio-label">
                                    <input type="radio" name="gioiTinh" value="true" checked> Nam
                                </label>
                                <label class="radio-label">
                                    <input type="radio" name="gioiTinh" value="false"> Nữ
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- DANH SÁCH ĐỊA CHỈ -->
            <div class="form-card">
                <div class="form-card-header">
                    <div class="form-card-title">Danh sách địa chỉ</div>
                    <button type="button" class="btn-add-address" id="btnAddAddress">
                        <i class="fa-solid fa-plus"></i> Thêm địa chỉ
                    </button>
                </div>

                <!-- KHU VỰC CHỨA CÁC THẺ ĐỊA CHỈ -->
                <div id="addressContainer">
                    <!-- Dynamic Address Cards will be rendered here -->
                </div>
            </div>

            <div class="form-actions-footer">
                <button type="button" class="btn btn-outline" onclick="javascript:history.back()">Hủy bỏ</button>
                <button type="submit" class="btn btn-primary">Thêm khách hàng</button>
            </div>
        </form>

    </div>
</main>

<script>
    let addressIndex = 0;

    // Khởi tạo 1 địa chỉ mặc định ngay khi tải trang
    document.addEventListener('DOMContentLoaded', function () {
        addAddressCard(true); // Thẻ địa chỉ mặc định đầu tiên

        document.getElementById('btnAddAddress').addEventListener('click', function () {
            addAddressCard(false); // Các thẻ thêm phụ
        });
    });

    // Hàm thêm thẻ địa chỉ
    function addAddressCard(isFirst = false) {
        const container = document.getElementById('addressContainer');
        const currentIndex = addressIndex++;

        const cardDiv = document.createElement('div');
        cardDiv.className = 'address-card';
        cardDiv.setAttribute('data-index', currentIndex);

        // Đánh dấu thẻ đầu tiên bằng class hoặc attribute để nhận biết
        if (isFirst) {
            cardDiv.classList.add('default-address');
        }

        cardDiv.innerHTML = `
        <div class="address-card-header">
            <div class="address-card-title">
                <i class="fa-solid fa-location-dot"></i>
                <span class="card-title-text">\${isFirst ? 'Địa chỉ mặc định' : 'Địa chỉ ' + container.children.length}</span>
            </div>
            \${!isFirst ? `
            <button type="button" class="btn-delete-address" onclick="removeAddressCard(this)">
            <i class="fa-solid fa-trash"></i> Xóa
    </button>
        ` : '<span style="font-size: 12px; color: #10b981; font-weight: 600;"><i class="fa-solid fa-check-circle"></i> Mặc định</span>'}
        </div>

        <div class="address-grid">
            <div class="form-group">
                <label>Tỉnh/Thành phố <span>*</span></label>
                <select class="form-control province-select" required onchange="onProvinceChange(this)">
                    <option value="">-- Chọn Tỉnh/Thành --</option>
                </select>
                <input type="hidden" name="tinhThanh" class="province-name">
                <input type="hidden" name="provinceCode" class="province-code">
            </div>

            <div class="form-group">
                <label>Quận/Huyện <span>*</span></label>
                <select class="form-control district-select" required disabled onchange="onDistrictChange(this)">
                    <option value="">-- Chọn Quận/Huyện --</option>
                </select>
                <input type="hidden" name="quanHuyen" class="district-name">
                <input type="hidden" name="districtCode" class="district-code">
            </div>

            <div class="form-group">
                <label>Phường/Xã <span>*</span></label>
                <select class="form-control ward-select" required disabled onchange="onWardChange(this)">
                    <option value="">-- Chọn Phường/Xã --</option>
                </select>
                <input type="hidden" name="phuongXa" class="ward-name">
                <input type="hidden" name="wardCode" class="ward-code">
            </div>
        </div>

        <div class="address-detail-grid">
            <div class="form-group">
                <label>Địa chỉ cụ thể <span>*</span></label>
                <input type="text" name="diaChiCuThe" class="form-control" placeholder="Số nhà, tên đường..." required>
            </div>
            <div class="form-group">
                <label>Loại địa chỉ</label>
                <select name="loaiDiaChi" class="form-control">
                    <option value="Nhà riêng">Nhà riêng</option>
                    <option value="Văn phòng">Văn phòng</option>
                </select>
            </div>
        </div>
    `;

        container.appendChild(cardDiv);
        loadProvinces(cardDiv.querySelector('.province-select'));
    }

    // Xóa thẻ địa chỉ & đánh số lại tiêu đề
    function removeAddressCard(btn) {
        const container = document.getElementById('addressContainer');
        const card = btn.closest('.address-card');

        // Không cho phép xóa địa chỉ mặc định
        if (card.classList.contains('default-address')) {
            alert('Bạn không thể xóa địa chỉ mặc định!');
            return;
        }

        card.remove();

        // Cập nhật lại số thứ tự tiêu đề các địa chỉ phụ
        const cards = container.getElementsByClassName('address-card');
        for (let i = 1; i < cards.length; i++) {
            const titleSpan = cards[i].querySelector('.card-title-text');
            if (titleSpan) {
                titleSpan.textContent = 'Địa chỉ ' + i;
            }
        }
    }

    // API Tỉnh/Thành
    function loadProvinces(selectElement) {
        fetch('https://provinces.open-api.vn/api/p/')
            .then(res => res.json())
            .then(data => {
                data.forEach(p => {
                    const opt = document.createElement('option');
                    opt.value = p.code;
                    opt.textContent = p.name;
                    selectElement.appendChild(opt);
                });
            })
            .catch(err => console.error("Lỗi tải Tỉnh/Thành:", err));
    }

    function onProvinceChange(select) {
        const card = select.closest('.address-card');
        const pCode = select.value;
        const pText = select.options[select.selectedIndex]?.text || '';

        const dSelect = card.querySelector('.district-select');
        const wSelect = card.querySelector('.ward-select');

        card.querySelector('.province-name').value = pCode ? pText : '';
        card.querySelector('.province-code').value = pCode || '0';

        dSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        wSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wSelect.disabled = true;

        card.querySelector('.district-name').value = '';
        card.querySelector('.district-code').value = '0';
        card.querySelector('.ward-name').value = '';
        card.querySelector('.ward-code').value = '0';

        if (!pCode) {
            dSelect.disabled = true;
            return;
        }

        fetch(`https://provinces.open-api.vn/api/p/\${pCode}?depth=2`)
            .then(res => res.json())
            .then(data => {
                data.districts.forEach(d => {
                    const opt = document.createElement('option');
                    opt.value = d.code;
                    opt.textContent = d.name;
                    dSelect.appendChild(opt);
                });
                dSelect.disabled = false;
            })
            .catch(err => console.error("Lỗi tải Quận/Huyện:", err));
    }

    function onDistrictChange(select) {
        const card = select.closest('.address-card');
        const dCode = select.value;
        const dText = select.options[select.selectedIndex]?.text || '';

        const wSelect = card.querySelector('.ward-select');

        card.querySelector('.district-name').value = dCode ? dText : '';
        card.querySelector('.district-code').value = dCode || '0';

        wSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        card.querySelector('.ward-name').value = '';
        card.querySelector('.ward-code').value = '0';

        if (!dCode) {
            wSelect.disabled = true;
            return;
        }

        fetch(`https://provinces.open-api.vn/api/d/\${dCode}?depth=2`)
            .then(res => res.json())
            .then(data => {
                data.wards.forEach(w => {
                    const opt = document.createElement('option');
                    opt.value = w.code;
                    opt.textContent = w.name;
                    wSelect.appendChild(opt);
                });
                wSelect.disabled = false;
            })
            .catch(err => console.error("Lỗi tải Phường/Xã:", err));
    }

    function onWardChange(select) {
        const card = select.closest('.address-card');
        const wCode = select.value;
        const wText = select.options[select.selectedIndex]?.text || '';

        card.querySelector('.ward-name').value = wCode ? wText : '';
        card.querySelector('.ward-code').value = wCode || '0';
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>