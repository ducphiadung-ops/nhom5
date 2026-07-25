<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Màu sắc - Skycomputer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; }
        /* 🎨 --- SIDEBAR --- */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #fff;
            border-right: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
            padding-bottom: 16px;
            z-index: 1000;
        }

        .brand {
            display: flex;
            align-items: center;
            padding: 20px 20px;
            gap: 12px;
            border-bottom: 1px solid #e5e7eb;
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
        .brand-text p { font-size: 11px; color: #6b7280; margin-bottom: 0; }

        .nav-menu { list-style: none; padding: 0 12px; flex: 1; overflow-y: auto; }
        .nav-item { margin-bottom: 4px; }

        .nav-link-custom {
            display: flex;
            align-items: center;
            padding: 11px 16px;
            color: #6b7280;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            gap: 12px;
        }
        .nav-link-custom i { font-size: 16px; width: 20px; text-align: center; }
        .nav-link-custom:hover { background-color: #f3f4f6; color: #1f2937; }
        .nav-link-custom.active { background-color: #eef2ff; color: #1a56db; font-weight: 600; }

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
            background-color: #eef2ff;
            color: #1a56db;
            font-weight: 600;
        }

        .logout-item { margin-top: auto; padding: 0 12px; }
        .nav-link-custom.logout-link { color: #dc2626; border-top: 1px solid #e5e7eb; border-radius: 0; padding-top: 16px; }
        .nav-link-custom.logout-link:hover { background-color: #ffe4e6; color: #be123c; border-radius: 8px; }


        .main-content { margin-left: 260px; padding: 40px; }
        .btn-dark-custom { background-color: #0f172a; color: #ffffff; border: none; }
        .card-custom { background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; }
        .table-custom th { background-color: #f8fafc; color: #64748b; font-weight: 600; font-size: 12px; text-transform: uppercase; padding: 14px 16px; }
        .table-custom td { padding: 16px; vertical-align: middle; font-size: 14px; border-bottom: 1px solid #f1f5f9; }
        .badge-active { background-color: #dcfce7; color: #16a34a; padding: 6px 12px; border-radius: 6px; font-weight: 500; }
        .form-label { font-size: 12px; font-weight: 600; color: #475569; text-transform: uppercase; }
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
            <a href="${pageContext.request.contextPath}/khach-hang/hien-thi" class="nav-link-custom"><i class="fa-solid fa-users"></i> Quản lý khách hàng</a>
        </li>

        <!-- QUẢN LÝ NHÂN VIÊN -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="nav-link-custom"><i class="fa-solid fa-id-badge"></i> Quản lý nhân viên</a>
        </li>


        <!-- DROPDOWN QUẢN LÝ THUỘC TÍNH -->
        <li class="nav-item">
            <a href="#sub-thuoc-tinh" class="nav-link-custom d-flex justify-content-between align-items-center active" data-bs-toggle="collapse" role="button" aria-expanded="true">
                <span><i class="fa-solid fa-sliders"></i> Quản lý thuộc tính</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 10px; transition: transform 0.2s;"></i>
            </a>
            <div class="collapse show" id="sub-thuoc-tinh">
                <ul class="sub-menu">
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/cpu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-microchip me-1"></i> Cấu hình CPU</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/ram/hien-thi" class="nav-link-custom"><i class="fa-solid fa-memory me-1"></i> Cấu hình RAM</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/o-cung/hien-thi" class="nav-link-custom"><i class="fa-solid fa-hard-drive me-1"></i> Ổ cứng</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/gpu/hien-thi" class="nav-link-custom"><i class="fa-solid fa-clone me-1"></i> Card đồ họa (GPU)</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/man-hinh/hien-thi" class="nav-link-custom"><i class="fa-solid fa-display me-1"></i> Màn hình</a></li>
                    <li><a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/hien-thi" class="nav-link-custom active-sub"><i class="fa-solid fa-palette me-1"></i> Màu sắc</a></li>
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

<div class="main-content">
    <div class="mb-4">
        <h4 class="fw-bold mb-1">Quản lý thuộc tính Màu sắc</h4>
        <p class="text-muted mb-0">Cấu hình danh mục màu sơn vỏ máy ngoại hình laptop.</p>
    </div>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card card-custom p-4">
                <h6 class="fw-bold mb-3 text-uppercase" style="font-size: 13px; color: #475569;"><i class="fa-solid fa-plus me-2"></i>Thêm Màu sắc mới</h6>
                <form action="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/them" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Tên màu sắc <span class="text-danger">*</span></label>
                        <input type="text" name="tenMauSac" class="form-control py-2" placeholder="Ví dụ: Bạc (Silver), Đen" required>
                    </div>
                    <button type="submit" class="btn btn-dark-custom w-100 py-2 fw-medium"><i class="fa-solid fa-save me-2"></i>Lưu thuộc tính</button>
                </form>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card card-custom p-4">
                <h6 class="fw-bold text-uppercase mb-3" style="font-size: 13px; color: #475569;"><i class="fa-solid fa-list me-2"></i>Danh sách phiên bản màu</h6>
                <div class="table-responsive">
                    <table class="table table-custom table-hover align-middle text-center mb-0">
                        <thead>
                        <tr>
                            <th style="width: 60px;">STT</th>
                            <th class="text-start">Tên Màu sắc</th>
                            <th>Trạng thái</th>
                            <th style="width: 100px;">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tbody>
                        <c:forEach items="${listMauSac}" var="ms" varStatus="status">
                            <tr>
                                <td class="text-secondary fw-medium">${status.index + 1}</td>
                                <td class="text-start fw-semibold text-dark">${ms.tenMauSac}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${ms.trangThai}">
                                            <span class="badge-active"><i class="fa-solid fa-circle-check me-1"></i> Sử dụng</span>
                                        </c:when>
                                        <c:otherwise>

                                            <span style="background-color: #fee2e2; color: #dc2626; padding: 6px 12px; border-radius: 6px; font-weight: 500; font-size: 12px;">
                                                <i class="fa-solid fa-circle-xmark me-1"></i> Ngừng dùng
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- 2. Khu vực nút Thao tác -->
                                <td>
                                    <div class="d-flex justify-content-center gap-2">
                                        <!-- Nút Sửa -->
                                        <a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/sua?id=${ms.id}" class="btn btn-sm btn-outline-secondary px-2.5" style="border-radius: 6px;">
                                            <i class="fa-regular fa-pen-to-square"></i>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/xoa?id=${ms.id}"
                                           class="btn btn-sm btn-outline-danger px-2.5 ${!ms.trangThai ? 'disabled pointer-events-none opacity-50' : ''}"
                                           style="border-radius: 6px;"
                                           onclick="return confirm('Bạn chắc chắn muốn ngừng kích hoạt Màu sắc này?');">
                                            <i class="fa-regular fa-trash-can"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listMauSac}">
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">
                                    <i class="fa-regular fa-folder-open d-block fs-3 mb-2 opacity-50"></i>
                                    Chưa có dữ liệu Màu sắc nào được khởi tạo!
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>