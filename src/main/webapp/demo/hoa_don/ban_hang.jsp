<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bán hàng tại quầy - Skycomputer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* --- KHAI BÁO BIẾN MÀU SẮC GIAO DIỆN CHUẨN --- */
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
            --warning-text: #b45309;
            --warning-bg: #fef3c7;
            --danger-text: #be123c;
            --danger-bg: #ffe4e6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { display: flex; height: 100vh; background-color: var(--bg-body); color: var(--text-main); overflow: hidden; }

        /* --- SIDEBAR QUẢN TRỊ --- */
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


        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .top-header { height: 70px; background-color: #fff; display: flex; align-items: center; padding: 0 32px; border-bottom: 1px solid var(--border-color); }
        .header-actions { display: flex; align-items: center; gap: 24px; margin-left: auto; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 20px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0px; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }
        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 14px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 11px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }
        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; position: relative; }

        /* --- THÀNH PHẦN UI CƠ BẢN --- */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-title h2 { font-size: 20px; font-weight: 600; margin-bottom: 4px; }
        .page-title p { font-size: 13px; color: var(--text-muted); }
        .btn { padding: 10px 16px; border-radius: 6px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 8px; border: none; transition: 0.2s; }
        .btn-outline { background: #fff; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-outline:hover { background: #f9fafb; }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: #154cbf; }
        .btn-success-light { background: #ecfdf5; color: #059669; font-weight: 600; border: 1px solid #a7f3d0; }
        .btn-success-light:hover { background: #d1fae5; }

        /* Class CSS mới cho nút xanh dương */
        .btn-primary-light { background: var(--primary-light); color: var(--primary); font-weight: 600; border: 1px solid #bfdbfe; }
        .btn-primary-light:hover { background: #dbeafe; }

        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-size: 12px; font-weight: 600; color: var(--text-main); }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 13px; color: var(--text-main); outline: none; }
        .form-control:focus { border-color: var(--primary); }

        /* --- ZONING BÁN HÀNG --- */
        .pos-container { display: grid; grid-template-columns: 6.8fr 3.2fr; gap: 24px; align-items: start; }
        .pos-card { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; margin-bottom: 24px; box-shadow: 0 1px 2px rgba(0,0,0,0.02); }
        .pos-card-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 16px; margin-bottom: 16px; }
        .pos-card-title { font-size: 15px; font-weight: 600; display: flex; align-items: center; gap: 8px; color: var(--text-main); }

        .table-cart { width: 100%; border-collapse: collapse; }
        .table-cart th { font-size: 11px; color: var(--text-muted); font-weight: 600; text-align: left; padding: 12px; border-bottom: 1px solid var(--border-color); background: #f8fafc; text-transform: uppercase; }
        .table-cart td { padding: 16px 12px; border-bottom: 1px dashed var(--border-color); font-size: 13px; vertical-align: middle; }
        .product-img { width: 64px; height: 64px; object-fit: contain; border-radius: 6px; border: 1px solid var(--border-color); background: #fff; }
        .product-name { font-weight: 600; color: var(--text-main); margin-bottom: 4px; font-size: 14px; }
        .product-code { font-size: 11px; color: var(--text-muted); }

        .spec-container { display: flex; flex-wrap: wrap; gap: 4px; max-width: 240px; }
        .spec-badge { padding: 4px 8px; font-size: 11px; font-weight: 500; border-radius: 4px; }
        .spec-cpu { background: #e0e7ff; color: #4338ca; }
        .spec-gpu { background: #d1fae5; color: #047857; }
        .spec-ram { background: #ffedd5; color: #c2410c; }
        .spec-os { background: #f3f4f6; color: #374151; }
        .spec-storage { background: #ede9fe; color: #6d28d9; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item { display: flex; align-items: center; gap: 12px; }
        .info-icon { width: 36px; height: 36px; border-radius: 50%; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 14px; }
        .info-label { font-size: 11px; color: var(--text-muted); margin-bottom: 2px; }
        .info-value { font-size: 13px; font-weight: 500; color: var(--text-main); line-height: 1.4; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 14px; font-size: 13px; color: var(--text-muted); }
        .summary-row strong { color: var(--text-main); }
        .summary-row.total { font-size: 18px; font-weight: 700; color: var(--danger-text); border-top: 1px dashed var(--border-color); padding-top: 16px; margin-top: 4px; }
        .btn-block { width: 100%; padding: 12px; font-size: 14px; font-weight: 600; border-radius: 8px; display: flex; justify-content: center; }
        .btn-delete { color: var(--text-muted); background: transparent; border: none; cursor: pointer; font-size: 15px; transition: 0.2s; padding: 6px; }
        .btn-delete:hover { color: var(--danger-text); }

        /* --- MODAL CHUNG --- */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); display: none; justify-content: center; align-items: center; z-index: 9999; backdrop-filter: blur(2px); }
        .modal-overlay.active { display: flex !important; }
        .modal-container { background: #fff; width: 90%; max-width: 1100px; max-height: 85vh; border-radius: 12px; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.2); animation: modalFadeIn 0.3s ease; }
        .modal-header { padding: 16px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .modal-header h3 { font-size: 18px; display: flex; align-items: center; gap: 8px; }
        .btn-close-modal { background: transparent; border: none; font-size: 20px; color: var(--text-muted); cursor: pointer; }
        .btn-close-modal:hover { color: var(--danger-text); }
        .modal-body { padding: 24px; overflow-y: auto; flex: 1; }
        @keyframes modalFadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

        .empty-cart-msg { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .empty-cart-msg i { font-size: 48px; color: #e5e7eb; margin-bottom: 16px; }
    </style>
</head>
<body>

<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="ban-hang"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <div class="page-header">
            <div class="page-title">
                <h2>Bán hàng tại quầy</h2>
                <p>Khởi tạo giỏ hàng, cập nhật thông tin khách hàng và lên đơn trực tiếp.</p>
            </div>
        </div>

        <div class="pos-container">
            <div class="pos-left">
                <div class="pos-card">
                    <div class="pos-card-header">
                        <div class="pos-card-title"><i class="fa-solid fa-list-check"></i> Giỏ hàng hiện tại</div>
                        <button type="button" class="btn btn-primary" id="btnOpenProductModal" style="background-color: #1a56db;">
                            <i class="fa-solid fa-laptop-medical"></i> Chọn sản phẩm
                        </button>
                    </div>

                    <table class="table-cart">
                        <thead>
                        <tr>
                            <th style="width: 15%">Mã Serial</th>
                            <th style="width: 27%">Tên máy / Màu sắc</th>
                            <th style="width: 38%">Thông số chi tiết</th>
                            <th style="width: 15%">Đơn giá</th>
                            <th style="width: 5%; text-align: center;">Xóa</th>
                        </tr>
                        </thead>
                        <tbody id="cartTableBody">
                        <tr id="emptyCartRow">
                            <td colspan="5" class="empty-cart-msg" style="padding: 40px 20px;">
                                <i class="fa-solid fa-cart-shopping" style="font-size: 40px; color: #e5e7eb; display: block; margin-bottom: 12px;"></i>
                                Chưa có sản phẩm nào trong giỏ hàng.<br>
                                <span style="font-size: 12px; color: #9ca3af;">Bấm <strong>"Chọn sản phẩm"</strong> để thêm.</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="pos-card">
                    <div class="pos-card-header" style="border-bottom: none; padding-bottom: 0; margin-bottom: 8px;">
                        <div class="pos-card-title" style="font-size: 15px;"><i class="fa-regular fa-id-badge"></i> Thông tin khách hàng:</div>
                    </div>
                    <div id="customerInfoContent" style="padding-top: 8px;">
                        <div class="empty-cart-msg" style="padding: 24px 0;" id="emptyCustomerMsg">
                            <i class="fa-regular fa-address-card" style="font-size: 32px; color: #e5e7eb; display: block; margin-bottom: 8px;"></i>
                            Chưa chọn khách hàng.
                        </div>
                    </div>
                </div>
            </div>

            <div class="pos-right">
                <form action="#" method="POST">

                    <input type="hidden" name="idKhachHang" id="selectedCustomerId" value="">

                    <div class="pos-card">
                        <div class="pos-card-header" style="margin-bottom: 16px; padding-bottom: 12px;">
                            <div class="pos-card-title" style="font-size: 14px;"><i class="fa-solid fa-user-pen"></i> Chức năng khách hàng</div>
                        </div>

                        <div style="display: flex; gap: 12px;">
                            <button type="button" class="btn btn-primary" id="btnOpenCustomerModal" style="flex: 1; justify-content: center; background-color: #1a56db;">Chọn khách hàng</button>
                            <a href="/khach-hang/add" class="btn btn-primary" style="flex: 1; justify-content: center; background-color: #1a56db; text-decoration: none;">Thêm khách hàng</a>
                        </div>
                    </div>

                    <div class="pos-card">
                        <div class="pos-card-header" style="margin-bottom: 16px; padding-bottom: 12px;">
                            <div class="pos-card-title" style="font-size: 14px;"><i class="fa-solid fa-receipt"></i> Thông tin hóa đơn</div>
                        </div>

                        <div class="summary-row total" style="border-top: none; padding-top: 0; margin-top: 0;">
                            <span>Tổng tiền thanh toán:</span>
                            <span id="displayTotalFinal">0 đ</span>
                        </div>

                        <div class="form-group" style="margin-top: 20px; margin-bottom: 24px;">
                            <label>Phương thức thanh toán</label>
                            <select name="hinhThucId" id="hinhThucId" class="form-control" style="font-weight: 500;">
                                <c:forEach items="${listHinhThucThanhToan}" var="ht">
                                    <option value="${ht.id}">${ht.tenHinhThuc}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block" style="background-color: #1a56db;"><i class="fa-solid fa-check"></i> Xác nhận thanh toán</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<div class="modal-overlay" id="productModal">
    <div class="modal-container">
        <div class="modal-header">
            <h3 style="color: var(--primary);"><i class="fa-solid fa-circle-info"></i> Chọn sản phẩm</h3>
            <button class="btn-close-modal" id="btnCloseProductModal"><i class="fa-solid fa-xmark"></i></button>
        </div>

        <div class="modal-body">
            <div style="margin-bottom: 20px;">
                <input type="text" class="form-control" placeholder="Tìm kiếm tên sản phẩm..." style="width: 100%; max-width: 400px; margin-bottom: 12px;">

                <div style="display: flex; gap: 10px;">
                    <select class="form-control" style="width: 150px;"><option>Màu sắc</option></select>
                    <select class="form-control" style="width: 150px;"><option>CPU</option></select>
                    <select class="form-control" style="width: 150px;"><option>GPU</option></select>
                    <select class="form-control" style="width: 150px;"><option>RAM</option></select>
                    <button class="btn btn-outline" style="margin-left: auto;"><i class="fa-solid fa-rotate-right"></i> Đặt lại bộ lọc</button>
                </div>
            </div>

            <table class="table-cart" style="width: 100%; border: 1px solid var(--border-color);">
                <thead>
                <tr>
                    <th style="width: 5%; text-align: center;">STT</th>
                    <th style="width: 13%">Mã SP</th>
                    <th style="width: 28%">Tên sản phẩm</th>
                    <th style="width: 12%">Màu sắc</th>
                    <th style="width: 13%">Đơn giá</th>
                    <th style="width: 9%; text-align: center;">Tồn kho</th>
                    <th style="width: 12%; text-align: center;">Thao tác</th>
                </tr>
                </thead>
                <tbody id="dbProductList">
                <c:forEach items="${listSanPham}" var="sp" varStatus="loop">
                    <tr>
                        <td style="text-align: center;">${loop.index + 1}</td>
                        <td style="color: var(--primary); font-weight: 600; font-size: 12px;">
                                ${sp.sanPham.maSanPham}
                        </td>
                        <td>
                            <div style="font-weight: 500; font-size: 13px;">${sp.sanPham.tenSanPham}</div>
                        </td>
                        <td>
                            <c:if test="${not empty sp.cauHinhSanPham.mauSac.tenMauSac}">
                                <span style="display:inline-flex; align-items:center; gap:5px;
                                             background:#f3f4f6; border-radius:4px;
                                             padding:3px 8px; font-size:12px; font-weight:500;">
                                    <i class="fa-solid fa-circle" style="font-size:8px; color:#6b7280;"></i>
                                    ${sp.cauHinhSanPham.mauSac.tenMauSac}
                                </span>
                            </c:if>
                        </td>
                        <td style="color: var(--danger-text); font-weight: 700; font-size: 13px;">
                                ${sp.donGia} đ
                        </td>
                        <td style="text-align: center;">
                            <span style="background: var(--primary-light); padding: 4px 8px;
                                         border: 1px solid #bfdbfe; border-radius: 4px;
                                         color: var(--primary); font-weight: 600;">
                                    ${sp.tonKho}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <button type="button"
                                    class="btn btn-primary-light btn-open-seri"
                                    data-cauhinh-id="${sp.cauHinhSanPham.id}"
                                    data-masp="${sp.sanPham.maSanPham}"
                                    data-name="${sp.sanPham.tenSanPham}"
                                    data-color="${sp.cauHinhSanPham.mauSac.tenMauSac}"
                                    data-price="${sp.donGia}"
                                    data-cpu="${sp.cauHinhSanPham.cpu.tenCpu}"
                                    data-ram="${sp.cauHinhSanPham.ram.dungLuongRam}"
                                    data-gpu="${sp.cauHinhSanPham.gpu.tenGpu}"
                                    data-storage="${sp.cauHinhSanPham.OCung.dungLuongOCung}"
                                    data-os="${sp.cauHinhSanPham.heDieuHanh}"
                                    style="padding: 6px 12px; font-size: 12px; margin: 0 auto;">
                                <i class="fa-solid fa-barcode" style="margin-right: 4px;"></i> Chọn seri
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listSanPham}">
                    <tr>
                        <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                            <i class="fa-regular fa-folder-open" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                            Không tìm thấy sản phẩm nào trong hệ thống!
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal-overlay" id="seriModal">
    <div class="modal-container" style="max-width: 820px;">
        <div class="modal-header">
            <div style="flex:1;">
                <div style="display:flex; align-items:center; gap:12px;">
                    <button type="button" id="btnBackToProduct"
                            style="background:var(--primary-light);border:1px solid #bfdbfe;color:var(--primary);
                                   border-radius:6px;padding:5px 12px;font-size:12px;font-weight:600;cursor:pointer;
                                   display:flex;align-items:center;gap:6px;">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </button>
                    <div>
                        <h3 style="color: var(--primary); margin:0;"><i class="fa-solid fa-barcode"></i> Chọn mã seri</h3>
                        <p id="seriModalSubtitle" style="font-size: 12px; color: var(--text-muted); margin: 3px 0 0;"></p>
                    </div>
                </div>
            </div>
            <button class="btn-close-modal" id="btnCloseSeriModal"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body" style="padding-bottom:0;">
            <div style="display:flex; align-items:center; gap:12px; margin-bottom:14px; flex-wrap:wrap;">
                <input type="text" id="seriSearchInput" class="form-control"
                       placeholder="Tìm kiếm mã seri..."
                       style="flex:1; min-width:200px; max-width:340px;">
                <label style="display:flex;align-items:center;gap:6px;font-size:13px;font-weight:500;
                               cursor:pointer;padding:8px 12px;border:1px solid var(--border-color);
                               border-radius:6px;background:#f9fafb;user-select:none;">
                    <input type="checkbox" id="chkSelectAllSeri" style="width:15px;height:15px;cursor:pointer;">
                    Chọn tất cả
                </label>
                <span id="seriSelectedCount"
                      style="font-size:12px;font-weight:600;color:var(--primary);
                             background:var(--primary-light);padding:5px 12px;
                             border-radius:20px;border:1px solid #bfdbfe;white-space:nowrap;">
                    Đã chọn: 0
                </span>
            </div>
            <table class="table-cart" style="width: 100%; border: 1px solid var(--border-color);">
                <thead>
                <tr>
                    <th style="width: 5%; text-align: center;"><i class="fa-solid fa-check-square" style="font-size:13px;color:var(--text-muted);"></i></th>
                    <th style="width: 6%; text-align: center;">STT</th>
                    <th style="width: 30%">Mã seri</th>
                    <th style="width: 28%">Mã sản phẩm</th>
                    <th style="width: 22%; text-align: center;">Trạng thái</th>
                </tr>
                </thead>
                <tbody id="seriTableBody">
                </tbody>
            </table>
        </div>
        <%-- Footer xác nhận --%>
        <div style="padding:16px 24px; border-top:1px solid var(--border-color);
                    display:flex; align-items:center; justify-content:space-between; flex-shrink:0;">
            <div style="font-size:13px; color:var(--text-muted);">
                <span id="seriConfirmInfo" style="color:var(--text-main); font-weight:500;"></span>
            </div>
            <button type="button" id="btnConfirmAddSeri"
                    class="btn btn-primary"
                    style="background:var(--primary); min-width:180px; justify-content:center;"
                    disabled>
                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
            </button>
        </div>
    </div>
</div>

<%-- Nhúng toàn bộ danh sách mã seri vào trang dưới dạng JSON để JS lọc phía client --%>
<script id="seriDataScript" type="application/json">
[
<c:forEach items="${listMaSeri}" var="ms" varStatus="sLoop">
    {
        "id": ${ms.id},
        "soSeri": "${ms.soSeri}",
        "cauhinhId": ${ms.cauHinhSanPham.id},
        "masp": "${ms.cauHinhSanPham.sanPham.maSanPham}",
        "trangThai": ${ms.trangThai != null ? ms.trangThai : 0}
    }${!sLoop.last ? ',' : ''}
</c:forEach>
]
</script>

<div class="modal-overlay" id="customerModal">
    <div class="modal-container" style="max-width: 900px;">
        <div class="modal-header">
            <h3><i class="fa-solid fa-users" style="color: var(--primary);"></i> Chọn khách hàng có sẵn</h3>
            <button class="btn-close-modal" id="btnCloseCustomerModal"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body">
            <div style="display: flex; gap: 12px; margin-bottom: 20px;">
                <input type="text" class="form-control" placeholder="Tìm kiếm tên khách hàng, số điện thoại..." style="flex: 1;">
                <button class="btn btn-outline"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
            </div>

            <table class="table-cart" style="border: 1px solid var(--border-color);">
                <thead>
                <tr>
                    <th style="width: 5%; text-align: center;">STT</th>
                    <th style="width: 20%">Tên khách hàng</th>
                    <th style="width: 15%">Số điện thoại</th>
                    <th style="width: 20%">Email</th>
                    <th style="width: 30%">Địa chỉ đầy đủ</th>
                    <th style="width: 10%; text-align: center;">Thao tác</th>
                </tr>
                </thead>
                <tbody id="dbCustomerList">
                <c:forEach items="${listKhachHang}" var="kh" varStatus="loopKh">
                    <!-- Tạo một biến tạm 'dc' để lấy ra phần tử địa chỉ đầu tiên (index 0) -->
                    <c:set var="dc" value="${not empty kh.diaChiKhachHang ? kh.diaChiKhachHang[0] : null}" />

                    <tr>
                        <td style="text-align: center;">${loopKh.index + 1}</td>
                        <td style="font-weight: 500; font-size: 13px;">${kh.tenKhachHang}</td>
                        <td>${kh.sdt}</td>
                        <td>${kh.email}</td>

                        <!-- Hiển thị địa chỉ ngoài màn hình -->
                        <td>
                            <c:choose>
                                <c:when test="${not empty dc}">
                                    ${dc.diaChiCuThe}, ${dc.phuongXa}, ${dc.quanHuyen}, ${dc.tinhThanh}
                                </c:when>
                                <c:otherwise>Chưa có địa chỉ</c:otherwise>
                            </c:choose>
                        </td>

                        <td style="text-align: center;">
                            <button type="button"
                                    class="btn btn-primary-light btn-select-customer"
                                    data-id="${kh.id}"
                                    data-name="${kh.tenKhachHang}"
                                    data-phone="${kh.sdt}"
                                    data-email="${kh.email}"
                                    data-address="${not empty dc ? ''.concat(dc.diaChiCuThe).concat(', ').concat(dc.phuongXa).concat(', ').concat(dc.quanHuyen).concat(', ').concat(dc.tinhThanh) : 'Chưa có địa chỉ'}"
                                    style="padding: 6px 12px; font-size: 12px; margin: 0 auto;">
                                <i class="fa-solid fa-check" style="margin-right: 4px;"></i> Chọn
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listKhachHang}">
                    <tr>
                        <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                            <i class="fa-regular fa-folder-open" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                            Không tìm thấy khách hàng nào trong hệ thống!
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {

        // ================================================================
        // --- XỬ LÝ MODAL CHỌN SẢN PHẨM ---
        // ================================================================
        const btnOpenProduct = document.getElementById('btnOpenProductModal');
        const productModal   = document.getElementById('productModal');
        const btnCloseProduct = document.getElementById('btnCloseProductModal');
        const seriModal      = document.getElementById('seriModal');

        if (btnOpenProduct && productModal) {
            btnOpenProduct.addEventListener('click', function(e) {
                e.preventDefault();
                productModal.classList.add('active');
            });
        }
        if (btnCloseProduct && productModal) {
            btnCloseProduct.addEventListener('click', function(e) {
                e.preventDefault();
                productModal.classList.remove('active');
            });
        }

        // ================================================================
        // --- XỬ LÝ MODAL CHỌN KHÁCH HÀNG ---
        // ================================================================
        const btnOpenCustomer  = document.getElementById('btnOpenCustomerModal');
        const customerModal    = document.getElementById('customerModal');
        const btnCloseCustomer = document.getElementById('btnCloseCustomerModal');

        if (btnOpenCustomer && customerModal) {
            btnOpenCustomer.addEventListener('click', function(e) {
                e.preventDefault();
                customerModal.classList.add('active');
            });
        }
        if (btnCloseCustomer && customerModal) {
            btnCloseCustomer.addEventListener('click', function(e) {
                e.preventDefault();
                customerModal.classList.remove('active');
            });
        }

        // ================================================================
        // --- ĐÓNG MODAL KHI CLICK RA NGOÀI VÙNG ĐEN ---
        // ================================================================
        window.addEventListener('click', function(event) {
            if (event.target === productModal)  productModal.classList.remove('active');
            if (event.target === customerModal) customerModal.classList.remove('active');
            if (event.target === seriModal)     seriModal.classList.remove('active');
        });

        // ================================================================
        // --- XỬ LÝ MODAL CHỌN SERI (multi-select) ---
        // ================================================================
        const btnCloseSeri    = document.getElementById('btnCloseSeriModal');
        const btnBackToProduct = document.getElementById('btnBackToProduct');
        const seriSearchInput = document.getElementById('seriSearchInput');
        const chkSelectAll    = document.getElementById('chkSelectAllSeri');
        const btnConfirmAdd   = document.getElementById('btnConfirmAddSeri');

        // Parse dữ liệu seri từ JSON nhúng trong trang
        let allSeriData = [];
        try {
            allSeriData = JSON.parse(document.getElementById('seriDataScript').textContent);
        } catch(err) { allSeriData = []; }

        // Biến lưu thông tin sản phẩm đang chọn seri + seri đã tick
        let currentProduct  = {};
        let currentCauhinhId = 0;
        // Set các seriId đã được tick trong phiên mở modal này
        let selectedSeriIds = new Set();

        if (btnCloseSeri && seriModal) {
            btnCloseSeri.addEventListener('click', function(e) {
                e.preventDefault();
                seriModal.classList.remove('active');
                selectedSeriIds.clear();
            });
        }

        // Quay lại modal sản phẩm
        if (btnBackToProduct) {
            btnBackToProduct.addEventListener('click', function() {
                seriModal.classList.remove('active');
                selectedSeriIds.clear();
                productModal.classList.add('active');
            });
        }

        // Cập nhật UI counter + nút xác nhận
        function updateSeriSelectionUI() {
            const count = selectedSeriIds.size;
            document.getElementById('seriSelectedCount').textContent = 'Đã chọn: ' + count;
            btnConfirmAdd.disabled = (count === 0);
            if (count > 0) {
                const totalPrice = count * currentProduct.price;
                document.getElementById('seriConfirmInfo').textContent =
                    count + ' seri × ' + currentProduct.price.toLocaleString('vi-VN') + ' đ = ' +
                    totalPrice.toLocaleString('vi-VN') + ' đ';
            } else {
                document.getElementById('seriConfirmInfo').textContent = '';
            }
            // Cập nhật trạng thái checkbox "chọn tất cả"
            const visibleCheckboxes = document.querySelectorAll('#seriTableBody input[type="checkbox"]:not([disabled])');
            const allChecked = visibleCheckboxes.length > 0 &&
                [...visibleCheckboxes].every(cb => cb.checked);
            chkSelectAll.checked = allChecked;
            chkSelectAll.indeterminate = !allChecked && count > 0;
        }

        // Hàm render danh sách seri vào bảng
        function renderSeriTable(rows) {
            const tbody = document.getElementById('seriTableBody');
            tbody.innerHTML = '';
            if (rows.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; color:var(--text-muted); padding:24px;">' +
                    '<i class="fa-regular fa-folder-open" style="font-size:22px; display:block; margin-bottom:8px;"></i>' +
                    'Không có mã seri nào khả dụng cho sản phẩm này!</td></tr>';
                return;
            }
            // Tập hợp seri đã có trong giỏ hàng để disable
            const inCartSerials = new Set();
            document.querySelectorAll('#cartTableBody tr[data-serial]').forEach(function(tr) {
                inCartSerials.add(tr.getAttribute('data-serial'));
            });

            rows.forEach(function(s, idx) {
                const inCart = inCartSerials.has(s.soSeri);
                const checked = selectedSeriIds.has(s.id);
                const tr = document.createElement('tr');
                tr.setAttribute('data-seri-id', s.id);
                if (inCart) tr.style.opacity = '0.5';
                if (checked) tr.style.backgroundColor = 'var(--primary-light)';

                const statusHtml = inCart
                    ? '<span style="background:#f3f4f6;color:var(--text-muted);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;">Đã trong giỏ</span>'
                    : '<span style="background:var(--success-bg);color:var(--success-text);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;"><i class="fa-solid fa-circle" style="font-size:7px;margin-right:4px;"></i>Còn hàng</span>';

                tr.innerHTML =
                    '<td style="text-align:center;">' +
                        '<input type="checkbox" class="seri-checkbox" ' +
                        'data-seri-id="' + s.id + '" data-so-seri="' + s.soSeri + '" ' +
                        (inCart ? 'disabled title="Đã có trong giỏ hàng"' : '') +
                        (checked ? 'checked' : '') +
                        ' style="width:15px;height:15px;cursor:' + (inCart ? 'not-allowed' : 'pointer') + ';accent-color:var(--primary);">' +
                    '</td>' +
                    '<td style="text-align:center;">' + (idx + 1) + '</td>' +
                    '<td><span style="color:var(--primary);font-weight:700;font-size:13px;">' + s.soSeri + '</span></td>' +
                    '<td><span style="font-size:12px;font-weight:600;">' + s.masp + '</span></td>' +
                    '<td style="text-align:center;">' + statusHtml + '</td>';
                tbody.appendChild(tr);
            });

            // Gắn sự kiện checkbox
            tbody.querySelectorAll('.seri-checkbox').forEach(function(cb) {
                cb.addEventListener('change', function() {
                    const id = parseInt(this.dataset.seriId);
                    const row = this.closest('tr');
                    if (this.checked) {
                        selectedSeriIds.add(id);
                        row.style.backgroundColor = 'var(--primary-light)';
                    } else {
                        selectedSeriIds.delete(id);
                        row.style.backgroundColor = '';
                    }
                    updateSeriSelectionUI();
                });
            });
        }

        // Mở modal seri khi bấm "Chọn seri" ở danh sách sản phẩm
        document.addEventListener('click', function(e) {
            const btn = e.target.closest('.btn-open-seri');
            if (!btn) return;

            currentCauhinhId = parseInt(btn.dataset.cauhinhId);
            currentProduct = {
                masp:    btn.dataset.masp    || '',
                name:    btn.dataset.name    || '—',
                color:   btn.dataset.color   || '',
                price:   parseFloat(btn.dataset.price) || 0,
                cpu:     btn.dataset.cpu     || '',
                ram:     btn.dataset.ram     || '',
                gpu:     btn.dataset.gpu     || '',
                storage: btn.dataset.storage || '',
                os:      btn.dataset.os      || ''
            };

            // Reset selection khi mở modal mới cho sản phẩm khác
            selectedSeriIds.clear();
            if (chkSelectAll) { chkSelectAll.checked = false; chkSelectAll.indeterminate = false; }

            // Cập nhật tiêu đề modal
            document.getElementById('seriModalSubtitle').textContent =
                currentProduct.name +
                (currentProduct.color ? ' — ' + currentProduct.color : '') +
                ' | ' + currentProduct.price.toLocaleString('vi-VN') + ' đ / sản phẩm';

            // Lọc seri theo cấu hình, chỉ lấy trangThai === 0 (còn hàng)
            const filtered = allSeriData.filter(function(s) {
                return s.cauhinhId === currentCauhinhId && s.trangThai === 0;
            });

            seriSearchInput.value = '';
            renderSeriTable(filtered);
            updateSeriSelectionUI();
            productModal.classList.remove('active');
            seriModal.classList.add('active');
        });

        // Checkbox "Chọn tất cả"
        if (chkSelectAll) {
            chkSelectAll.addEventListener('change', function() {
                const checkboxes = document.querySelectorAll('#seriTableBody input.seri-checkbox:not([disabled])');
                checkboxes.forEach(function(cb) {
                    const id = parseInt(cb.dataset.seriId);
                    const row = cb.closest('tr');
                    if (chkSelectAll.checked) {
                        cb.checked = true;
                        selectedSeriIds.add(id);
                        row.style.backgroundColor = 'var(--primary-light)';
                    } else {
                        cb.checked = false;
                        selectedSeriIds.delete(id);
                        row.style.backgroundColor = '';
                    }
                });
                updateSeriSelectionUI();
            });
        }

        // Tìm kiếm trong modal seri
        if (seriSearchInput) {
            seriSearchInput.addEventListener('input', function() {
                const keyword = this.value.trim().toLowerCase();
                document.querySelectorAll('#seriTableBody tr[data-seri-id]').forEach(function(row) {
                    const text = row.textContent.toLowerCase();
                    row.style.display = (!keyword || text.includes(keyword)) ? '' : 'none';
                });
            });
        }

        // ================================================================
        // --- XÁC NHẬN THÊM NHIỀU SERI VÀO GIỎ HÀNG ---
        // ================================================================
        btnConfirmAdd.addEventListener('click', function() {
            if (selectedSeriIds.size === 0) return;

            const cartBody = document.getElementById('cartTableBody');
            const emptyRow = document.getElementById('emptyCartRow');

            // Lấy thông tin từng seri được chọn và thêm vào giỏ
            let addedCount = 0;
            let skippedCount = 0;

            selectedSeriIds.forEach(function(seriId) {
                const seriData = allSeriData.find(s => s.id === seriId);
                if (!seriData) return;

                const soSeri = seriData.soSeri;
                // Kiểm tra đã có trong giỏ chưa
                if (cartBody.querySelector('tr[data-serial="' + soSeri + '"]')) {
                    skippedCount++;
                    return;
                }

                if (emptyRow) emptyRow.style.display = 'none';

                const { name, color, price, cpu, ram, gpu, storage, os } = currentProduct;
                const priceFormatted = price.toLocaleString('vi-VN') + ' đ';

                const colorHtml = color
                    ? '<div class="product-code" style="margin-top:4px;"><i class="fa-solid fa-palette" style="margin-right:3px;"></i>' + color + '</div>'
                    : '';

                function badge(cls, icon, val) {
                    if (!val) return '';
                    return '<span class="spec-badge ' + cls + '"><i class="' + icon + '" style="margin-right:3px;font-size:10px;"></i>' + val + '</span>';
                }
                const specHtml =
                    badge('spec-cpu',     'fa-solid fa-microchip', cpu)     +
                    badge('spec-ram',     'fa-solid fa-memory',     ram)     +
                    badge('spec-gpu',     'fa-solid fa-display',    gpu)     +
                    badge('spec-storage', 'fa-solid fa-hard-drive', storage) +
                    badge('spec-os',      'fa-brands fa-windows',   os);

                const row = document.createElement('tr');
                row.setAttribute('data-serial', soSeri);
                row.setAttribute('data-price',  price);
                row.innerHTML =
                    '<td><span style="color:var(--primary);font-weight:700;font-size:13px;">' + soSeri + '</span></td>' +
                    '<td><div class="product-name" style="font-size:13px;">' + name + '</div>' + colorHtml + '</td>' +
                    '<td><div class="spec-container">' +
                        (specHtml || '<span style="color:var(--text-muted);font-size:12px;">Không có thông số</span>') +
                    '</div></td>' +
                    '<td><span style="color:var(--danger-text);font-weight:700;font-size:14px;white-space:nowrap;">' + priceFormatted + '</span></td>' +
                    '<td style="text-align:center;">' +
                        '<button type="button" class="btn-delete btn-remove-cart" title="Xóa sản phẩm khỏi giỏ">' +
                        '<i class="fa-solid fa-trash-can"></i></button></td>';
                cartBody.appendChild(row);
                addedCount++;
            });

            updateCartTotals();
            selectedSeriIds.clear();

            // Thông báo kết quả
            let msg = '✅ Đã thêm ' + addedCount + ' sản phẩm vào giỏ hàng.';
            if (skippedCount > 0) msg += '\n⚠️ ' + skippedCount + ' seri đã có trong giỏ, bỏ qua.';

            // Đóng modal seri, quay lại modal sản phẩm để tiếp tục chọn
            seriModal.classList.remove('active');
            productModal.classList.add('active');

            // Hiện toast nhẹ thay vì alert
            showToast(msg.replace('\n', ' '), addedCount > 0 ? 'success' : 'warning');
        });

        // ================================================================
        // --- XÓA SẢN PHẨM KHỎI GIỎ HÀNG ---
        // ================================================================
        document.addEventListener('click', function(e) {
            const btn = e.target.closest('.btn-remove-cart');
            if (!btn) return;

            const row = btn.closest('tr');
            if (row) {
                row.remove();
                updateCartTotals();

                const cartBody = document.getElementById('cartTableBody');
                const dataRows = cartBody.querySelectorAll('tr[data-serial]');
                if (dataRows.length === 0) {
                    const emptyRow = document.getElementById('emptyCartRow');
                    if (emptyRow) emptyRow.style.display = '';
                }
            }
        });

        // ================================================================
        // --- CẬP NHẬT TỔNG TIỀN ---
        // ================================================================
        function updateCartTotals() {
            const cartBody = document.getElementById('cartTableBody');
            let total = 0;
            cartBody.querySelectorAll('tr[data-serial]').forEach(function(row) {
                total += parseFloat(row.getAttribute('data-price')) || 0;
            });

            const totalFormatted = total.toLocaleString('vi-VN') + ' đ';

            const elOrigin   = document.getElementById('displayTotalOrigin');
            const elDiscount = document.getElementById('displayDiscount');
            const elFinal    = document.getElementById('displayTotalFinal');

            if (elOrigin)   elOrigin.textContent   = totalFormatted;
            if (elDiscount) elDiscount.textContent  = '- 0 đ';
            if (elFinal)    elFinal.textContent     = totalFormatted;
        }

        // ================================================================
        // --- CHỌN KHÁCH HÀNG TỪ MODAL & HIỂN THỊ XUỐNG DƯỚI ---
        // ================================================================
        document.addEventListener('click', function(e) {
            const btn = e.target.closest('.btn-select-customer');
            if (!btn) return;

            const id      = btn.dataset.id      || '';
            const name    = btn.dataset.name    || '—';
            const phone   = btn.dataset.phone   || '';
            const email   = btn.dataset.email   || '';
            const address = btn.dataset.address || '';

            const hiddenId = document.getElementById('selectedCustomerId');
            if (hiddenId) hiddenId.value = id;

            const infoBox = document.getElementById('customerInfoContent');
            infoBox.innerHTML = `
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-user"></i></div>
                        <div>
                            <div class="info-label">Tên khách hàng</div>
                            <div class="info-value">\${name}</div>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-phone"></i></div>
                        <div>
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value">\${phone || '—'}</div>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-envelope"></i></div>
                        <div>
                            <div class="info-label">Email</div>
                            <div class="info-value">\${email || '—'}</div>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-location-dot"></i></div>
                        <div>
                            <div class="info-label">Địa chỉ</div>
                            <div class="info-value">\${address || '—'}</div>
                        </div>
                    </div>
                </div>
                <div style="margin-top: 16px; text-align: right;">
                    <button type="button" class="btn btn-outline" id="btnRemoveCustomer" style="font-size: 12px; padding: 6px 12px;">
                        <i class="fa-solid fa-user-slash"></i> Bỏ chọn khách hàng
                    </button>
                </div>
            `;

            customerModal.classList.remove('active');
        });

        // ================================================================
        // --- BỎ CHỌN KHÁCH HÀNG ---
        // ================================================================
        document.addEventListener('click', function(e) {
            const btn = e.target.closest('#btnRemoveCustomer');
            if (!btn) return;

            const hiddenId = document.getElementById('selectedCustomerId');
            if (hiddenId) hiddenId.value = '';

            const infoBox = document.getElementById('customerInfoContent');
            infoBox.innerHTML = `
                <div class="empty-cart-msg" style="padding: 24px 0;" id="emptyCustomerMsg">
                    <i class="fa-regular fa-address-card" style="font-size: 32px; color: #e5e7eb; display: block; margin-bottom: 8px;"></i>
                    Chưa chọn khách hàng.
                </div>
            `;
        });

    });
</script>

<%-- Toast notification --%>
<div id="posToast" style="
    position:fixed; bottom:28px; right:28px; z-index:99999;
    background:#1f2937; color:#fff; padding:14px 20px;
    border-radius:10px; font-size:13px; font-weight:500;
    box-shadow:0 4px 16px rgba(0,0,0,0.25);
    display:none; align-items:center; gap:10px;
    max-width:420px; line-height:1.5;
    transition: opacity 0.3s ease;">
    <i id="posToastIcon" class="fa-solid fa-circle-check" style="font-size:16px;flex-shrink:0;"></i>
    <span id="posToastMsg"></span>
</div>

<script>
    function showToast(message, type) {
        const toast = document.getElementById('posToast');
        const icon  = document.getElementById('posToastIcon');
        const msg   = document.getElementById('posToastMsg');
        msg.textContent = message;
        if (type === 'success') {
            toast.style.background = '#065f46';
            icon.className = 'fa-solid fa-circle-check';
        } else if (type === 'warning') {
            toast.style.background = '#92400e';
            icon.className = 'fa-solid fa-triangle-exclamation';
        } else {
            toast.style.background = '#1f2937';
            icon.className = 'fa-solid fa-circle-info';
        }
        toast.style.display = 'flex';
        toast.style.opacity = '1';
        clearTimeout(window._toastTimer);
        window._toastTimer = setTimeout(function() {
            toast.style.opacity = '0';
            setTimeout(function() { toast.style.display = 'none'; }, 300);
        }, 3000);
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
