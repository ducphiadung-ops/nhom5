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
        :root{--primary:#1a56db;--primary-light:#e6efff;--sidebar-active:#eef2ff;--text-main:#1f2937;--text-muted:#6b7280;--bg-body:#f3f4f6;--border-color:#e5e7eb;--success-text:#047857;--success-bg:#d1fae5;--warning-text:#b45309;--warning-bg:#fef3c7;--danger-text:#be123c;--danger-bg:#ffe4e6;}
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Inter',sans-serif;}
        body{display:flex;height:100vh;background:var(--bg-body);color:var(--text-main);overflow:hidden;}
        /* SIDEBAR */
        .sidebar{width:260px;background:#fff;border-right:1px solid var(--border-color);display:flex;flex-direction:column;height:100vh;padding-bottom:16px;z-index:10;}
        .brand{display:flex;align-items:center;padding:20px;gap:12px;border-bottom:1px solid var(--border-color);margin-bottom:12px;}
        .brand-logo{width:40px;height:40px;border-radius:8px;overflow:hidden;display:flex;align-items:center;justify-content:center;background:#fff;}
        .brand-logo img{width:100%;height:100%;object-fit:contain;}
        .brand-text h1{font-size:16px;font-weight:700;color:#1e3a8a;margin-bottom:0;}
        .brand-text p{font-size:11px;color:var(--text-muted);margin-bottom:0;}
        .nav-menu{list-style:none;padding:0 12px;flex:1;overflow-y:auto;}
        .nav-item{margin-bottom:4px;}
        .nav-link-custom{display:flex;align-items:center;padding:11px 16px;color:var(--text-muted);text-decoration:none;border-radius:8px;font-size:14px;font-weight:500;transition:all 0.2s;gap:12px;}
        .nav-link-custom i{font-size:16px;width:20px;text-align:center;}
        .nav-link-custom:hover{background:#f3f4f6;color:var(--text-main);}
        .nav-link-custom.active{background:var(--sidebar-active);color:var(--primary);font-weight:600;}
        .sub-menu{list-style:none;padding-left:0;margin-top:4px;display:flex;flex-direction:column;gap:2px;}
        .sub-menu .nav-link-custom{padding:9px 16px 9px 44px !important;font-size:13px;}
        .sub-menu .nav-link-custom.active-sub{background:var(--sidebar-active);color:var(--primary);font-weight:600;}
        .logout-item{margin-top:auto;padding:0 12px;}
        .nav-link-custom.logout-link{color:#dc2626;border-top:1px solid var(--border-color);border-radius:0;padding-top:16px;}
        .nav-link-custom.logout-link:hover{background:var(--danger-bg);color:var(--danger-text);border-radius:8px;}
        /* LAYOUT */
        .main-wrapper{flex:1;display:flex;flex-direction:column;overflow:hidden;}
        .top-header{height:70px;background:#fff;display:flex;align-items:center;padding:0 32px;border-bottom:1px solid var(--border-color);}
        .header-actions{display:flex;align-items:center;gap:24px;margin-left:auto;}
        .notification{position:relative;color:var(--text-muted);cursor:pointer;font-size:20px;}
        .notification::after{content:'';position:absolute;top:-2px;right:0;width:8px;height:8px;background:#ef4444;border-radius:50%;border:2px solid #fff;}
        .user-profile{display:flex;align-items:center;gap:12px;}
        .user-info{text-align:right;}
        .user-name{font-size:14px;font-weight:600;color:var(--text-main);}
        .user-role{font-size:11px;color:var(--text-muted);text-transform:uppercase;}
        .avatar{width:36px;height:36px;border-radius:50%;object-fit:cover;}
        .content-area{flex:1;padding:20px 28px;overflow-y:auto;}
        /* CARDS */
        .pos-card{background:#fff;border:1px solid var(--border-color);border-radius:12px;padding:18px 20px;margin-bottom:16px;box-shadow:0 1px 3px rgba(0,0,0,0.04);}
        .pos-card-header{display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border-color);padding-bottom:14px;margin-bottom:14px;}
        .pos-card-title{font-size:14px;font-weight:600;display:flex;align-items:center;gap:8px;color:var(--text-main);}
        /* GRID */
        .pos-container{display:grid;grid-template-columns:1fr 320px;gap:20px;align-items:start;}
        /* BUTTONS */
        .btn{padding:9px 16px;border-radius:6px;font-size:13px;font-weight:500;cursor:pointer;display:inline-flex;align-items:center;gap:7px;border:none;transition:0.2s;text-decoration:none;}
        .btn-primary{background:var(--primary);color:#fff;}
        .btn-primary:hover{background:#154cbf;color:#fff;}
        .btn-outline{background:#fff;border:1px solid var(--border-color);color:var(--text-main);}
        .btn-outline:hover{background:#f9fafb;}
        .btn-primary-light{background:var(--primary-light);color:var(--primary);font-weight:600;border:1px solid #bfdbfe;}
        .btn-primary-light:hover{background:#dbeafe;}
        .btn-danger-light{background:var(--danger-bg);color:var(--danger-text);border:1px solid #fca5a5;}
        .btn-danger-light:hover{background:#fecaca;}
        .btn-block{width:100%;justify-content:center;padding:12px;font-size:14px;font-weight:600;border-radius:8px;}
        .btn-delete{color:var(--text-muted);background:transparent;border:none;cursor:pointer;font-size:14px;transition:0.2s;padding:5px 8px;border-radius:4px;}
        .btn-delete:hover{color:var(--danger-text);background:var(--danger-bg);}
        /* FORM */
        .form-group{display:flex;flex-direction:column;gap:5px;margin-bottom:14px;}
        .form-group label{font-size:12px;font-weight:600;color:var(--text-main);}
        .form-control{width:100%;padding:9px 12px;border:1px solid var(--border-color);border-radius:6px;font-size:13px;color:var(--text-main);outline:none;background:#fff;}
        .form-control:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(26,86,219,.1);}
        /* TABLE */
        .table-cart{width:100%;border-collapse:collapse;}
        .table-cart th{font-size:11px;color:var(--text-muted);font-weight:600;text-align:left;padding:10px 12px;border-bottom:1px solid var(--border-color);background:#f8fafc;text-transform:uppercase;}
        .table-cart td{padding:13px 12px;border-bottom:1px dashed var(--border-color);font-size:13px;vertical-align:middle;}
        .spec-container{display:flex;flex-wrap:wrap;gap:3px;}
        .spec-badge{padding:3px 7px;font-size:11px;font-weight:500;border-radius:4px;}
        .spec-cpu{background:#e0e7ff;color:#4338ca;}.spec-ram{background:#ffedd5;color:#c2410c;}
        .spec-gpu{background:#d1fae5;color:#047857;}.spec-storage{background:#ede9fe;color:#6d28d9;}
        .spec-os{background:#f3f4f6;color:#374151;}
        /* SUMMARY */
        .summary-row{display:flex;justify-content:space-between;margin-bottom:10px;font-size:13px;color:var(--text-muted);}
        .summary-row.total{font-size:17px;font-weight:700;color:var(--danger-text);border-top:2px dashed var(--border-color);padding-top:14px;margin-top:6px;}
        /* EMPTY */
        .empty-msg{text-align:center;padding:32px 16px;color:var(--text-muted);}
        .empty-msg i{font-size:36px;color:#d1d5db;display:block;margin-bottom:10px;}
        /* INFO GRID */
        .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
        .info-item{display:flex;align-items:center;gap:10px;}
        .info-icon{width:32px;height:32px;border-radius:50%;background:var(--primary-light);color:var(--primary);display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0;}
        .info-label{font-size:11px;color:var(--text-muted);margin-bottom:1px;}
        .info-value{font-size:13px;font-weight:500;color:var(--text-main);line-height:1.4;}
        /* MODAL */
        .modal-overlay{position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.5);display:none;justify-content:center;align-items:center;z-index:9999;backdrop-filter:blur(2px);}
        .modal-overlay.active{display:flex !important;}
        .modal-container{background:#fff;width:90%;max-width:1100px;max-height:88vh;border-radius:12px;display:flex;flex-direction:column;box-shadow:0 10px 30px rgba(0,0,0,.2);animation:mfadeIn .25s ease;}
        .modal-header{padding:16px 24px;border-bottom:1px solid var(--border-color);display:flex;justify-content:space-between;align-items:center;flex-shrink:0;}
        .modal-header h3{font-size:17px;display:flex;align-items:center;gap:8px;margin:0;}
        .btn-close-modal{background:transparent;border:none;font-size:20px;color:var(--text-muted);cursor:pointer;padding:4px 8px;border-radius:4px;}
        .btn-close-modal:hover{color:var(--danger-text);background:var(--danger-bg);}
        .modal-body{padding:20px 24px;overflow-y:auto;flex:1;}
        @keyframes mfadeIn{from{opacity:0;transform:translateY(-16px)}to{opacity:1;transform:translateY(0)}}
        /* HOÁ ĐƠN CHỜ TABS */
        .don-cho-section{background:#fff;border:1px solid var(--border-color);border-radius:12px;padding:16px 20px;margin-bottom:16px;}
        .don-cho-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;}
        .don-cho-title{font-size:14px;font-weight:600;color:var(--text-main);display:flex;align-items:center;gap:8px;}
        .don-cho-list{display:flex;flex-wrap:wrap;gap:8px;align-items:center;}
        .don-tab{position:relative;display:flex;align-items:center;gap:6px;padding:8px 14px;border-radius:8px;border:1.5px solid var(--border-color);background:#f9fafb;cursor:pointer;font-size:13px;font-weight:500;color:var(--text-muted);transition:all .18s;min-width:130px;}
        .don-tab:hover{border-color:var(--primary);color:var(--primary);background:var(--primary-light);}
        .don-tab.active{border-color:var(--primary);background:var(--primary);color:#fff;}
        .don-tab .tab-ma{font-weight:700;font-size:12px;}
        .don-tab .tab-status{font-size:10px;opacity:.8;}
        .don-tab .btn-xoa-tab{position:absolute;top:-6px;right:-6px;width:18px;height:18px;border-radius:50%;background:#ef4444;color:#fff;border:none;cursor:pointer;font-size:10px;display:flex;align-items:center;justify-content:center;line-height:1;padding:0;}
        .don-tab .btn-xoa-tab:hover{background:#dc2626;}
        .don-cho-empty{color:var(--text-muted);font-size:13px;font-style:italic;}
        /* CONFIRM MODAL */
        .confirm-modal-container{max-width:440px;padding:0;}
        .confirm-body{padding:28px 28px 20px;text-align:center;}
        .confirm-icon{width:60px;height:60px;border-radius:50%;background:var(--warning-bg);display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:26px;color:var(--warning-text);}
        .confirm-footer{padding:16px 24px;border-top:1px solid var(--border-color);display:flex;gap:10px;justify-content:flex-end;}
        /* VALIDATION */
        .input-error{border-color:#ef4444 !important;box-shadow:0 0 0 3px rgba(239,68,68,.15) !important;}
        .error-msg{font-size:12px;color:#dc2626;margin-top:4px;display:none;}
        .error-msg.show{display:block;}
        /* TOAST */
        #posToast{position:fixed;bottom:24px;right:24px;z-index:99999;background:#1f2937;color:#fff;padding:13px 18px;border-radius:10px;font-size:13px;font-weight:500;box-shadow:0 4px 16px rgba(0,0,0,.25);display:none;align-items:center;gap:10px;max-width:400px;transition:opacity .3s;}
    </style>
</head>
<body>

<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="ban-hang"/>
</jsp:include>

<main class="main-wrapper">
<jsp:include page="/demo/common/header.jsp"/>
<div class="content-area">

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
        <div>
            <h2 style="font-size:19px;font-weight:700;margin-bottom:3px;">Bán hàng tại quầy</h2>
            <p style="font-size:13px;color:var(--text-muted);">Tạo hoá đơn, chọn sản phẩm và xác nhận thanh toán trực tiếp.</p>
        </div>
    </div>

    <%-- ===== SECTION 1: HOÁ ĐƠN CHỜ ===== --%>
    <div class="don-cho-section">
        <div class="don-cho-header">
            <div class="don-cho-title"><i class="fa-solid fa-layer-group" style="color:var(--primary);"></i> Hoá đơn chờ <span id="tabCountBadge" style="background:var(--primary);color:#fff;border-radius:20px;padding:1px 8px;font-size:11px;font-weight:600;margin-left:4px;">0</span></div>
            <button id="btnTaoDon" class="btn btn-primary" style="font-size:12px;padding:7px 14px;">
                <i class="fa-solid fa-plus"></i> Tạo hoá đơn
            </button>
        </div>
        <div class="don-cho-list" id="donChoList">
            <span class="don-cho-empty" id="donChoEmptyMsg">Chưa có hoá đơn nào. Bấm "Tạo hoá đơn" để bắt đầu.</span>
        </div>
    </div>

    <%-- ===== SECTION 2+3: POS GRID ===== --%>
    <div class="pos-container">
        <%-- === CỘT TRÁI === --%>
        <div>
            <%-- Chọn sản phẩm --%>
            <div class="pos-card">
                <div class="pos-card-header">
                    <div class="pos-card-title"><i class="fa-solid fa-list-check"></i> Giỏ hàng
                        <span id="cartDonLabel" style="font-size:11px;font-weight:500;color:var(--text-muted);margin-left:6px;">— chưa chọn hoá đơn —</span>
                    </div>
                    <button type="button" class="btn btn-primary" id="btnOpenProductModal" disabled style="font-size:12px;padding:7px 14px;opacity:.5;">
                        <i class="fa-solid fa-laptop-medical"></i> Chọn sản phẩm
                    </button>
                </div>
                <table class="table-cart">
                    <thead><tr>
                        <th style="width:14%">Mã Seri</th>
                        <th style="width:26%">Tên sản phẩm</th>
                        <th style="width:38%">Cấu hình</th>
                        <th style="width:14%">Đơn giá</th>
                        <th style="width:8%;text-align:center;">Xoá</th>
                    </tr></thead>
                    <tbody id="cartTableBody">
                        <tr id="emptyCartRow">
                            <td colspan="5" class="empty-msg">
                                <i class="fa-solid fa-cart-shopping"></i>
                                Chưa có sản phẩm. Hãy tạo hoá đơn rồi chọn sản phẩm.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <%-- Khách hàng --%>
            <div class="pos-card">
                <div class="pos-card-header" style="border-bottom:none;padding-bottom:0;margin-bottom:8px;">
                    <div class="pos-card-title"><i class="fa-regular fa-id-badge"></i> Thông tin khách hàng</div>
                    <button type="button" class="btn btn-primary-light" id="btnOpenCustomerModal" disabled style="font-size:12px;padding:7px 14px;opacity:.5;">
                        <i class="fa-solid fa-user-plus"></i> Chọn khách hàng
                    </button>
                </div>
                <div id="customerInfoContent" style="padding-top:8px;">
                    <div class="empty-msg" style="padding:20px 0;">
                        <i class="fa-regular fa-address-card" style="font-size:28px;"></i>
                        Chưa chọn khách hàng.
                    </div>
                </div>
            </div>
        </div>

        <%-- === CỘT PHẢI: THANH TOÁN === --%>
        <div>
            <div class="pos-card">
                <div class="pos-card-header" style="margin-bottom:16px;padding-bottom:12px;">
                    <div class="pos-card-title"><i class="fa-solid fa-receipt"></i> Thông tin hoá đơn</div>
                </div>

                <div class="summary-row total" style="border-top:none;padding-top:0;margin-top:0;margin-bottom:18px;">
                    <span style="font-size:14px;">Tổng tiền:</span>
                    <span id="displayTotalFinal" style="font-size:20px;">0 đ</span>
                </div>

                <div class="form-group">
                    <label>Phương thức thanh toán</label>
                    <select id="hinhThucId" class="form-control">
                        <c:forEach items="${listHinhThucThanhToan}" var="ht">
                            <option value="${ht.id}">${ht.tenHinhThuc}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label>Tiền khách đưa (đ)</label>
                    <input type="text" id="tienKhachTra" class="form-control"
                           placeholder="Nhập số tiền..." autocomplete="off"
                           inputmode="numeric">
                    <input type="hidden" id="tienKhachTraRaw" value="0">
                    <span class="error-msg" id="errTienKhach">Tiền nhập không đủ</span>
                </div>

                <div class="form-group">
                    <label>Tiền thừa</label>
                    <div id="tienThuaDisplay" style="padding:9px 12px;border:1px solid var(--border-color);border-radius:6px;font-size:14px;font-weight:700;color:var(--success-text);background:#f0fdf4;">0 đ</div>
                </div>

                <button type="button" id="btnThanhToan" class="btn btn-primary btn-block" disabled style="opacity:.5;margin-top:6px;">
                    <i class="fa-solid fa-circle-check"></i> Xác nhận thanh toán
                </button>
            </div>
        </div>
    </div>
</div><%-- end content-area --%>
</main>

<%-- ===== MODAL CHỌN SẢN PHẨM ===== --%>
<div class="modal-overlay" id="productModal">
    <div class="modal-container">
        <div class="modal-header">
            <h3 style="color:var(--primary);"><i class="fa-solid fa-laptop"></i> Chọn sản phẩm</h3>
            <button class="btn-close-modal" id="btnCloseProductModal"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body">
            <div style="margin-bottom:16px;display:flex;gap:10px;flex-wrap:wrap;">
                <input type="text" id="productSearchInput" class="form-control" placeholder="Tìm theo tên sản phẩm..." style="max-width:320px;">
                <select id="filterMauSac" class="form-control" style="width:130px;"><option value="">Màu sắc</option></select>
                <select id="filterCpu" class="form-control" style="width:130px;"><option value="">CPU</option></select>
                <select id="filterRam" class="form-control" style="width:130px;"><option value="">RAM</option></select>
                <button id="btnResetFilter" class="btn btn-outline" style="font-size:12px;"><i class="fa-solid fa-rotate-right"></i> Đặt lại</button>
            </div>
            <table class="table-cart" style="border:1px solid var(--border-color);">
                <thead><tr>
                    <th style="width:5%;text-align:center;">STT</th>
                    <th style="width:12%">Mã SP</th>
                    <th style="width:27%">Tên sản phẩm</th>
                    <th style="width:12%">Màu sắc</th>
                    <th style="width:13%">Đơn giá</th>
                    <th style="width:8%;text-align:center;">Tồn</th>
                    <th style="width:13%;text-align:center;">Chọn seri</th>
                </tr></thead>
                <tbody id="dbProductList">
                    <c:forEach items="${listSanPham}" var="sp" varStatus="loop">
                    <tr data-name="${sp.sanPham.tenSanPham}"
                        data-mausac="${sp.cauHinhSanPham.mauSac.tenMauSac}"
                        data-cpu="${sp.cauHinhSanPham.cpu.tenCpu}"
                        data-ram="${sp.cauHinhSanPham.ram.dungLuongRam}">
                        <td style="text-align:center;">${loop.index+1}</td>
                        <td style="color:var(--primary);font-weight:600;font-size:12px;">${sp.sanPham.maSanPham}</td>
                        <td style="font-weight:500;font-size:13px;">${sp.sanPham.tenSanPham}</td>
                        <td>
                            <c:if test="${not empty sp.cauHinhSanPham.mauSac.tenMauSac}">
                                <span style="background:#f3f4f6;border-radius:4px;padding:3px 8px;font-size:12px;font-weight:500;">
                                    <i class="fa-solid fa-circle" style="font-size:7px;color:#9ca3af;"></i> ${sp.cauHinhSanPham.mauSac.tenMauSac}
                                </span>
                            </c:if>
                        </td>
                        <td style="color:var(--danger-text);font-weight:700;font-size:13px;white-space:nowrap;">
                            <c:out value="${sp.donGia}"/> đ
                        </td>
                        <td style="text-align:center;">
                            <span style="background:var(--primary-light);padding:3px 8px;border:1px solid #bfdbfe;border-radius:4px;color:var(--primary);font-weight:600;font-size:12px;">${sp.tonKho}</span>
                        </td>
                        <td style="text-align:center;">
                            <button type="button" class="btn btn-primary-light btn-open-seri"
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
                                style="padding:5px 11px;font-size:12px;">
                                <i class="fa-solid fa-barcode"></i> Chọn seri
                            </button>
                        </td>
                    </tr>
                    </c:forEach>
                    <c:if test="${empty listSanPham}">
                    <tr><td colspan="7" class="empty-msg"><i class="fa-regular fa-folder-open"></i> Không có sản phẩm.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- ===== MODAL CHỌN SERI ===== --%>
<div class="modal-overlay" id="seriModal">
    <div class="modal-container" style="max-width:820px;">
        <div class="modal-header">
            <div style="flex:1;">
                <div style="display:flex;align-items:center;gap:12px;">
                    <button id="btnBackToProduct" style="background:var(--primary-light);border:1px solid #bfdbfe;color:var(--primary);border-radius:6px;padding:5px 12px;font-size:12px;font-weight:600;cursor:pointer;display:flex;align-items:center;gap:5px;">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </button>
                    <div>
                        <h3 style="color:var(--primary);margin:0;"><i class="fa-solid fa-barcode"></i> Chọn mã seri</h3>
                        <p id="seriModalSubtitle" style="font-size:12px;color:var(--text-muted);margin:3px 0 0;"></p>
                    </div>
                </div>
            </div>
            <button class="btn-close-modal" id="btnCloseSeriModal"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body" style="padding-bottom:0;">
            <div style="display:flex;align-items:center;gap:12px;margin-bottom:14px;flex-wrap:wrap;">
                <input type="text" id="seriSearchInput" class="form-control" placeholder="Tìm mã seri..." style="flex:1;min-width:180px;max-width:300px;">
                <label style="display:flex;align-items:center;gap:6px;font-size:13px;font-weight:500;cursor:pointer;padding:8px 12px;border:1px solid var(--border-color);border-radius:6px;background:#f9fafb;user-select:none;">
                    <input type="checkbox" id="chkSelectAllSeri" style="width:15px;height:15px;cursor:pointer;accent-color:var(--primary);"> Chọn tất cả
                </label>
                <span id="seriSelectedCount" style="font-size:12px;font-weight:600;color:var(--primary);background:var(--primary-light);padding:5px 12px;border-radius:20px;border:1px solid #bfdbfe;">Đã chọn: 0</span>
            </div>
            <table class="table-cart" style="border:1px solid var(--border-color);">
                <thead><tr>
                    <th style="width:5%;text-align:center;"><i class="fa-solid fa-check-square" style="font-size:12px;"></i></th>
                    <th style="width:6%;text-align:center;">STT</th>
                    <th style="width:32%">Mã seri</th>
                    <th style="width:28%">Mã sản phẩm</th>
                    <th style="width:22%;text-align:center;">Trạng thái</th>
                </tr></thead>
                <tbody id="seriTableBody"></tbody>
            </table>
        </div>
        <div style="padding:14px 24px;border-top:1px solid var(--border-color);display:flex;align-items:center;justify-content:space-between;flex-shrink:0;">
            <span id="seriConfirmInfo" style="font-size:13px;font-weight:500;color:var(--text-main);"></span>
            <button id="btnConfirmAddSeri" class="btn btn-primary" style="min-width:180px;justify-content:center;" disabled>
                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
            </button>
        </div>
    </div>
</div>

<%-- ===== MODAL CHỌN KHÁCH HÀNG ===== --%>
<div class="modal-overlay" id="customerModal">
    <div class="modal-container" style="max-width:900px;">
        <div class="modal-header">
            <h3><i class="fa-solid fa-users" style="color:var(--primary);"></i> Chọn khách hàng</h3>
            <button class="btn-close-modal" id="btnCloseCustomerModal"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body">
            <div style="display:flex;gap:10px;margin-bottom:16px;">
                <input type="text" id="customerSearchInput" class="form-control" placeholder="Tìm tên, số điện thoại..." style="flex:1;">
            </div>
            <table class="table-cart" style="border:1px solid var(--border-color);">
                <thead><tr>
                    <th style="width:5%;text-align:center;">STT</th>
                    <th style="width:22%">Tên khách hàng</th>
                    <th style="width:15%">Số điện thoại</th>
                    <th style="width:22%">Email</th>
                    <th style="width:26%">Địa chỉ</th>
                    <th style="width:10%;text-align:center;">Chọn</th>
                </tr></thead>
                <tbody id="dbCustomerListFull">
                    <c:forEach items="${listKhachHang}" var="kh" varStatus="loopKh">
                        <c:set var="dc" value="${not empty kh.diaChiKhachHang ? kh.diaChiKhachHang[0] : null}"/>
                        <tr data-search="${kh.tenKhachHang} ${kh.sdt}">
                            <td style="text-align:center;">${loopKh.index+1}</td>
                            <td style="font-weight:500;">${kh.tenKhachHang}</td>
                            <td>${kh.sdt}</td>
                            <td>${kh.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty dc}">${dc.diaChiCuThe}, ${dc.phuongXa}, ${dc.quanHuyen}, ${dc.tinhThanh}</c:when>
                                    <c:otherwise>Chưa có địa chỉ</c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <button type="button" class="btn btn-primary-light btn-select-customer"
                                    data-id="${kh.id}"
                                    data-name="${kh.tenKhachHang}"
                                    data-phone="${kh.sdt}"
                                    data-email="${kh.email}"
                                    data-address="${not empty dc ? dc.diaChiCuThe.concat(', ').concat(dc.phuongXa).concat(', ').concat(dc.quanHuyen).concat(', ').concat(dc.tinhThanh) : 'Chưa có địa chỉ'}"
                                    style="padding:5px 11px;font-size:12px;">
                                    <i class="fa-solid fa-check"></i> Chọn
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listKhachHang}">
                        <tr><td colspan="6" class="empty-msg"><i class="fa-regular fa-folder-open"></i> Không có khách hàng.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- ===== MODAL XÁC NHẬN THANH TOÁN ===== --%>
<div class="modal-overlay" id="confirmModal">
    <div class="modal-container confirm-modal-container">
        <div class="confirm-body">
            <div class="confirm-icon"><i class="fa-solid fa-circle-question"></i></div>
            <h5 style="font-size:16px;font-weight:700;margin-bottom:8px;">Xác nhận thanh toán?</h5>
            <p style="font-size:13px;color:var(--text-muted);line-height:1.6;" id="confirmModalText">Bạn có chắc muốn xác nhận thanh toán hoá đơn này không?</p>
        </div>
        <div class="confirm-footer">
            <button id="btnCancelConfirm" class="btn btn-outline">Huỷ</button>
            <button id="btnOkConfirm" class="btn btn-primary"><i class="fa-solid fa-check"></i> Xác nhận</button>
        </div>
    </div>
</div>

<%-- JSON dữ liệu seri nhúng vào trang --%>
<script id="seriDataScript" type="application/json">
[<c:forEach items="${listMaSeri}" var="ms" varStatus="sl">
{"id":${ms.id},"soSeri":"${ms.soSeri}","cauhinhId":${ms.cauHinhSanPham.id},"masp":"${ms.cauHinhSanPham.sanPham.maSanPham}","trangThai":${ms.trangThai != null ? ms.trangThai : 0}}${!sl.last ? ',' : ''}
</c:forEach>]
</script>

<%-- JSON hoá đơn chờ ban đầu từ server --%>
<script id="initDonChoScript" type="application/json">
[<c:forEach items="${listHoaDonCho}" var="hd" varStatus="sl">
{"id":${hd.id},"maHoaDon":"${hd.maHoaDon}","trangThai":${hd.trangThai}}${!sl.last ? ',' : ''}
</c:forEach>]
</script>

<%-- Toast --%>
<div id="posToast"><i id="posToastIcon" class="fa-solid fa-circle-check" style="font-size:15px;flex-shrink:0;"></i><span id="posToastMsg"></span></div>

<%-- Khai báo context path ra biến JS để tránh JSP parser nhầm ${ trong script --%>
<script>var CTX = '${pageContext.request.contextPath}';</script>

<script>
// ============================================================
//  KHỞI TẠO DỮ LIỆU TỪ SERVER
// ============================================================
let allSeriData = [];
try { allSeriData = JSON.parse(document.getElementById('seriDataScript').textContent); } catch(e) {}

// Danh sách hoá đơn chờ: { id, maHoaDon, trangThai }
let donChoList = [];
try { donChoList = JSON.parse(document.getElementById('initDonChoScript').textContent); } catch(e) {}

// ID hoá đơn đang được chọn
let currentDonId = null;
// Giỏ hàng theo từng hoá đơn: { [donId]: [{chiTietId, soSeri, tenSanPham, donGia}] }
let cartByDon = {};
// Khách hàng theo từng hoá đơn: { [donId]: {id, name, phone, email, address} | null }
let khachByDon = {};
// currentProduct cho modal seri
let currentProduct = {};
let currentCauhinhId = 0;
let selectedSeriIds = new Set();

// ============================================================
//  TOAST
// ============================================================
function showToast(msg, type) {
    const t = document.getElementById('posToast');
    const icon = document.getElementById('posToastIcon');
    document.getElementById('posToastMsg').textContent = msg;
    if (type === 'success') { t.style.background = '#065f46'; icon.className = 'fa-solid fa-circle-check'; }
    else if (type === 'error') { t.style.background = '#9f1239'; icon.className = 'fa-solid fa-circle-xmark'; }
    else { t.style.background = '#92400e'; icon.className = 'fa-solid fa-triangle-exclamation'; }
    t.style.display = 'flex'; t.style.opacity = '1';
    clearTimeout(window._tt);
    window._tt = setTimeout(function() { t.style.opacity = '0'; setTimeout(function(){ t.style.display='none'; }, 300); }, 3200);
}

// ============================================================
//  RENDER TABS HOÁ ĐƠN CHỜ
// ============================================================
function renderDonChoTabs() {
    const list = document.getElementById('donChoList');
    const emptyMsg = document.getElementById('donChoEmptyMsg');
    const badge = document.getElementById('tabCountBadge');
    badge.textContent = donChoList.length;

    // Xoá tabs cũ (giữ lại emptyMsg)
    Array.from(list.children).forEach(function(c) {
        if (c.id !== 'donChoEmptyMsg') list.removeChild(c);
    });

    if (donChoList.length === 0) {
        emptyMsg.style.display = '';
        return;
    }
    emptyMsg.style.display = 'none';

    donChoList.forEach(function(don) {
        const tab = document.createElement('div');
        tab.className = 'don-tab' + (don.id === currentDonId ? ' active' : '');
        tab.setAttribute('data-don-id', don.id);
        tab.innerHTML =
            '<i class="fa-solid fa-file-invoice" style="font-size:13px;"></i>' +
            '<div><div class="tab-ma">' + don.maHoaDon + '</div>' +
            '<div class="tab-status">Chờ xử lý</div></div>' +
            '<button class="btn-xoa-tab" data-don-id="' + don.id + '" title="Xoá hoá đơn này">' +
            '<i class="fa-solid fa-xmark" style="pointer-events:none;"></i></button>';
        list.appendChild(tab);
    });
}

// ============================================================
//  CHỌN HOÁ ĐƠN → load giỏ hàng + khách hàng
// ============================================================
function selectDon(donId) {
    currentDonId = donId;
    renderDonChoTabs();
    loadCartFromServer(donId);

    // Bật các nút
    const btnProd = document.getElementById('btnOpenProductModal');
    const btnKhach = document.getElementById('btnOpenCustomerModal');
    btnProd.disabled = false; btnProd.style.opacity = '1';
    btnKhach.disabled = false; btnKhach.style.opacity = '1';

    const don = donChoList.find(function(d){ return d.id === donId; });
    document.getElementById('cartDonLabel').textContent = don ? '— ' + don.maHoaDon + ' —' : '';

    // Khách hàng
    renderKhachHangInfo(khachByDon[donId] || null);

    // Bật nút thanh toán
    document.getElementById('btnThanhToan').disabled = false;
    document.getElementById('btnThanhToan').style.opacity = '1';
    document.getElementById('tienKhachTra').value = '';
    document.getElementById('tienKhachTraRaw').value = '0';
    document.getElementById('tienThuaDisplay').textContent = '0 đ';
    document.getElementById('errTienKhach').classList.remove('show');
}

// ============================================================
//  LOAD GIỎ HÀNG TỪ SERVER
// ============================================================
function loadCartFromServer(donId) {
    fetch(CTX + '/hoa-don/api/chi-tiet?id=' + donId)
        .then(function(r){ return r.json(); })
        .then(function(data) {
            cartByDon[donId] = data.items || [];
            if (data.idKhachHang && data.idKhachHang !== 'null') {
                // Khách hàng đã có trong server
                if (!khachByDon[donId]) {
                    khachByDon[donId] = {
                        id: data.idKhachHang,
                        name: data.tenKhachHang,
                        phone: data.sdtKhachHang,
                        email: '', address: ''
                    };
                }
            }
            renderCart(donId);
            updateTongTien(data.tongTien || 0);
            if (currentDonId === donId) renderKhachHangInfo(khachByDon[donId] || null);
        })
        .catch(function(e){ console.error(e); });
}

// ============================================================
//  RENDER GIỎ HÀNG
// ============================================================
function renderCart(donId) {
    const tbody = document.getElementById('cartTableBody');
    const items = cartByDon[donId] || [];
    tbody.innerHTML = '';

    if (items.length === 0) {
        tbody.innerHTML = '<tr id="emptyCartRow"><td colspan="5" class="empty-msg">' +
            '<i class="fa-solid fa-cart-shopping"></i> Giỏ hàng trống.</td></tr>';
        return;
    }

    items.forEach(function(item) {
        const tr = document.createElement('tr');
        tr.setAttribute('data-ct-id', item.id);
        const price = Number(item.donGia) || 0;

        // Tạo spec badges
        function badge(cls, icon, val) {
            if (!val) return '';
            return '<span class="spec-badge ' + cls + '"><i class="' + icon + '" style="margin-right:3px;font-size:10px;"></i>' + val + '</span>';
        }
        const specHtml =
            badge('spec-cpu',     'fa-solid fa-microchip',   item.cpu)     +
            badge('spec-ram',     'fa-solid fa-memory',      item.ram)     +
            badge('spec-gpu',     'fa-solid fa-display',     item.gpu)     +
            badge('spec-storage', 'fa-solid fa-hard-drive',  item.storage) +
            (item.mauSac ? '<span class="spec-badge spec-os"><i class="fa-solid fa-palette" style="margin-right:3px;font-size:10px;"></i>' + item.mauSac + '</span>' : '');

        const nameHtml = item.tenSanPham +
            (item.thuongHieu ? '<div style="font-size:11px;color:var(--text-muted);margin-top:2px;">' + item.thuongHieu + '</div>' : '');

        tr.innerHTML =
            '<td><span style="color:var(--primary);font-weight:700;font-size:12px;">' + item.soSeri + '</span></td>' +
            '<td style="font-weight:500;font-size:13px;">' + nameHtml + '</td>' +
            '<td><div class="spec-container">' + (specHtml || '<span style="color:var(--text-muted);font-size:12px;">—</span>') + '</div></td>' +
            '<td><span style="color:var(--danger-text);font-weight:700;white-space:nowrap;">' + price.toLocaleString('vi-VN') + ' đ</span></td>' +
            '<td style="text-align:center;"><button type="button" class="btn-delete btn-remove-item" data-ct-id="' + item.id + '" title="Xoá"><i class="fa-solid fa-trash-can"></i></button></td>';
        tbody.appendChild(tr);
    });
}

function updateTongTien(amount) {
    const num = Number(amount) || 0;
    document.getElementById('displayTotalFinal').textContent = num.toLocaleString('vi-VN') + ' đ';
    calculateChange();
}

// ============================================================
//  TÍNH TIỀN THỪA
// ============================================================
function calculateChange() {
    const totalText = document.getElementById('displayTotalFinal').textContent.replace(/[^0-9]/g, '');
    const total = parseInt(totalText) || 0;
    const given = parseInt(document.getElementById('tienKhachTraRaw').value) || 0;
    const change = given - total;
    const display = document.getElementById('tienThuaDisplay');
    if (change >= 0) {
        display.textContent = change.toLocaleString('vi-VN') + ' đ';
        display.style.color = 'var(--success-text)';
        display.style.background = '#f0fdf4';
        display.style.border = '1px solid #bbf7d0';
    } else {
        display.textContent = '0 đ';
        display.style.color = 'var(--text-muted)';
        display.style.background = '#f9fafb';
        display.style.border = '1px solid var(--border-color)';
    }
}

// ============================================================
//  RENDER KHÁCH HÀNG
// ============================================================
function renderKhachHangInfo(kh) {
    const box = document.getElementById('customerInfoContent');
    if (!kh) {
        box.innerHTML = '<div class="empty-msg" style="padding:18px 0;"><i class="fa-regular fa-address-card" style="font-size:26px;"></i> Chưa chọn khách hàng.</div>';
        return;
    }
    box.innerHTML = '<div class="info-grid">' +
        '<div class="info-item"><div class="info-icon"><i class="fa-solid fa-user"></i></div><div><div class="info-label">Tên khách hàng</div><div class="info-value">' + (kh.name || '—') + '</div></div></div>' +
        '<div class="info-item"><div class="info-icon"><i class="fa-solid fa-phone"></i></div><div><div class="info-label">Số điện thoại</div><div class="info-value">' + (kh.phone || '—') + '</div></div></div>' +
        '<div class="info-item"><div class="info-icon"><i class="fa-solid fa-envelope"></i></div><div><div class="info-label">Email</div><div class="info-value">' + (kh.email || '—') + '</div></div></div>' +
        '<div class="info-item"><div class="info-icon"><i class="fa-solid fa-location-dot"></i></div><div><div class="info-label">Địa chỉ</div><div class="info-value">' + (kh.address || '—') + '</div></div></div>' +
        '</div>' +
        '<div style="margin-top:12px;text-align:right;"><button type="button" id="btnRemoveCustomer" class="btn btn-outline" style="font-size:12px;padding:5px 11px;"><i class="fa-solid fa-user-slash"></i> Bỏ chọn</button></div>';
}

// ============================================================
//  DOM READY
// ============================================================
document.addEventListener('DOMContentLoaded', function() {

    // Render tabs ban đầu từ dữ liệu server
    renderDonChoTabs();
    // Nếu có 1 đơn thì tự chọn
    if (donChoList.length > 0) selectDon(donChoList[0].id);

    // --- TẠO HOÁ ĐƠN ---
    document.getElementById('btnTaoDon').addEventListener('click', function() {
        if (donChoList.length >= 10) {
            showToast('Tối đa 10 hoá đơn chờ!', 'warning');
            return;
        }
        const btn = this;
        btn.disabled = true;
        const params = new URLSearchParams();
        fetch(CTX + '/hoa-don/api/tao-don', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
            .then(function(r){ return r.json(); })
            .then(function(data) {
                if (data.error) { showToast(data.error, 'error'); return; }
                donChoList.push({ id: data.id, maHoaDon: data.maHoaDon, trangThai: 2 });
                cartByDon[data.id] = [];
                khachByDon[data.id] = null;
                renderDonChoTabs();
                selectDon(data.id);
                showToast('Tạo hoá đơn ' + data.maHoaDon + ' thành công!', 'success');
            })
            .catch(function(e){ showToast('Lỗi kết nối!', 'error'); })
            .finally(function(){ btn.disabled = false; });
    });

    // --- CLICK VÀO TAB ---
    document.getElementById('donChoList').addEventListener('click', function(e) {
        const xBtn = e.target.closest('.btn-xoa-tab');
        if (xBtn) {
            const donId = parseInt(xBtn.getAttribute('data-don-id'));
            xoaDonCho(donId);
            return;
        }
        const tab = e.target.closest('.don-tab');
        if (tab) {
            const donId = parseInt(tab.getAttribute('data-don-id'));
            selectDon(donId);
        }
    });

    // --- XOÁ HOÁ ĐƠN CHỜ ---
    function xoaDonCho(donId) {
        if (!confirm('Xoá hoá đơn này? Tất cả sản phẩm trong đơn sẽ được giải phóng.')) return;
        fetch(CTX + '/hoa-don/api/xoa-don', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'idHoaDon=' + donId
        })
            .then(function(r){
                if (r.status === 403) { showToast('Bạn không có quyền xoá hoá đơn này!', 'error'); throw new Error('403'); }
                return r.json();
            })
            .then(function(data) {
                if (data.error) { showToast(data.error, 'error'); return; }
                donChoList = donChoList.filter(function(d){ return d.id !== donId; });
                delete cartByDon[donId];
                delete khachByDon[donId];
                if (currentDonId === donId) {
                    currentDonId = donChoList.length > 0 ? donChoList[0].id : null;
                }
                renderDonChoTabs();
                if (currentDonId) {
                    selectDon(currentDonId);
                } else {
                    // Reset UI
                    document.getElementById('cartTableBody').innerHTML =
                        '<tr><td colspan="5" class="empty-msg"><i class="fa-solid fa-cart-shopping"></i> Chưa có sản phẩm.</td></tr>';
                    document.getElementById('customerInfoContent').innerHTML =
                        '<div class="empty-msg" style="padding:18px 0;"><i class="fa-regular fa-address-card" style="font-size:26px;"></i> Chưa chọn khách hàng.</div>';
                    document.getElementById('displayTotalFinal').textContent = '0 đ';
                    document.getElementById('cartDonLabel').textContent = '— chưa chọn hoá đơn —';
                    const btnProd = document.getElementById('btnOpenProductModal');
                    const btnKhach = document.getElementById('btnOpenCustomerModal');
                    btnProd.disabled = true; btnProd.style.opacity = '.5';
                    btnKhach.disabled = true; btnKhach.style.opacity = '.5';
                    document.getElementById('btnThanhToan').disabled = true;
                    document.getElementById('btnThanhToan').style.opacity = '.5';
                }
                showToast('Đã xoá hoá đơn.', 'success');
            })
            .catch(function(e){ if (e.message !== '403') showToast('Lỗi kết nối!', 'error'); });
    }

    // --- XOÁ SẢN PHẨM KHỎI GIỎ ---
    document.getElementById('cartTableBody').addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-remove-item');
        if (!btn) return;
        const ctId = parseInt(btn.getAttribute('data-ct-id'));
        fetch(CTX + '/hoa-don/api/xoa-seri', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'idChiTiet=' + ctId
        })
            .then(function(r){
                if (r.status === 403) { showToast('Bạn không có quyền thao tác hoá đơn này!', 'error'); throw new Error('403'); }
                return r.json();
            })
            .then(function(data) {
                if (data.error) { showToast(data.error, 'error'); return; }
                if (data.success && currentDonId) {
                    loadCartFromServer(currentDonId);
                }
            })
            .catch(function(e){ if (e.message !== '403') showToast('Lỗi xoá sản phẩm!', 'error'); });
    });

    // --- BỎ CHỌN KHÁCH ---
    document.getElementById('customerInfoContent').addEventListener('click', function(e) {
        if (!e.target.closest('#btnRemoveCustomer')) return;
        if (!currentDonId) return;
        fetch(CTX + '/hoa-don/api/cap-nhat-khach', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'idHoaDon=' + currentDonId + '&idKhachHang='
        })
            .then(function(r){
                if (r.status === 403) { showToast('Bạn không có quyền thao tác hoá đơn này!', 'error'); throw new Error('403'); }
                return r.json();
            })
            .then(function(data) {
                if (data.error) { showToast(data.error, 'error'); return; }
                khachByDon[currentDonId] = null;
                renderKhachHangInfo(null);
            })
            .catch(function(e){ if (e.message !== '403') showToast('Lỗi kết nối!', 'error'); });
    });

    // --- TIỀN KHÁCH TRẢ (auto format) ---
    document.getElementById('tienKhachTra').addEventListener('input', function() {
        // Lấy chỉ số từ input
        const raw = this.value.replace(/[^0-9]/g, '');
        document.getElementById('tienKhachTraRaw').value = raw || '0';
        // Format hiển thị
        this.value = raw ? parseInt(raw).toLocaleString('vi-VN') : '';
        calculateChange();
        document.getElementById('errTienKhach').classList.remove('show');
        document.getElementById('tienKhachTra').classList.remove('input-error');
    });

    // --- MODAL SẢN PHẨM ---
    const productModal  = document.getElementById('productModal');
    const seriModal     = document.getElementById('seriModal');
    const customerModal = document.getElementById('customerModal');
    const confirmModal  = document.getElementById('confirmModal');

    document.getElementById('btnOpenProductModal').addEventListener('click', function() {
        if (!currentDonId) return;
        productModal.classList.add('active');
    });
    document.getElementById('btnCloseProductModal').addEventListener('click', function() { productModal.classList.remove('active'); });

    // Filter sản phẩm
    function filterProducts() {
        const kw = document.getElementById('productSearchInput').value.toLowerCase();
        const ms = document.getElementById('filterMauSac').value.toLowerCase();
        const cpu = document.getElementById('filterCpu').value.toLowerCase();
        const ram = document.getElementById('filterRam').value.toLowerCase();
        document.querySelectorAll('#dbProductList tr[data-name]').forEach(function(row) {
            const n  = (row.dataset.name  || '').toLowerCase();
            const mc = (row.dataset.mausac|| '').toLowerCase();
            const cp = (row.dataset.cpu   || '').toLowerCase();
            const rm = (row.dataset.ram   || '').toLowerCase();
            const ok = (!kw || n.includes(kw)) && (!ms || mc.includes(ms)) && (!cpu || cp.includes(cpu)) && (!ram || rm.includes(ram));
            row.style.display = ok ? '' : 'none';
        });
    }
    document.getElementById('productSearchInput').addEventListener('input', filterProducts);
    document.getElementById('filterMauSac').addEventListener('change', filterProducts);
    document.getElementById('filterCpu').addEventListener('change', filterProducts);
    document.getElementById('filterRam').addEventListener('change', filterProducts);
    document.getElementById('btnResetFilter').addEventListener('click', function() {
        document.getElementById('productSearchInput').value = '';
        document.getElementById('filterMauSac').value = '';
        document.getElementById('filterCpu').value = '';
        document.getElementById('filterRam').value = '';
        filterProducts();
    });

    // Đóng modal khi click nền
    window.addEventListener('click', function(e) {
        if (e.target === productModal)  productModal.classList.remove('active');
        if (e.target === customerModal) customerModal.classList.remove('active');
        if (e.target === seriModal)   { seriModal.classList.remove('active'); selectedSeriIds.clear(); }
        if (e.target === confirmModal)  confirmModal.classList.remove('active');
    });

    // ============================================================
    //  MODAL SERI — MULTI SELECT
    // ============================================================
    const chkSelectAll  = document.getElementById('chkSelectAllSeri');
    const btnConfirmAdd = document.getElementById('btnConfirmAddSeri');
    const seriSearchInput = document.getElementById('seriSearchInput');

    function updateSeriUI() {
        const cnt = selectedSeriIds.size;
        document.getElementById('seriSelectedCount').textContent = 'Đã chọn: ' + cnt;
        btnConfirmAdd.disabled = cnt === 0;
        if (cnt > 0) {
            const total = cnt * (currentProduct.price || 0);
            document.getElementById('seriConfirmInfo').textContent =
                cnt + ' seri × ' + (currentProduct.price||0).toLocaleString('vi-VN') + ' đ = ' + total.toLocaleString('vi-VN') + ' đ';
        } else {
            document.getElementById('seriConfirmInfo').textContent = '';
        }
        const cbs = document.querySelectorAll('#seriTableBody input.seri-cb:not([disabled])');
        const allCk = cbs.length > 0 && [...cbs].every(function(c){ return c.checked; });
        chkSelectAll.checked = allCk;
        chkSelectAll.indeterminate = !allCk && cnt > 0;
    }

    function renderSeriTable(rows) {
        const tbody = document.getElementById('seriTableBody');
        tbody.innerHTML = '';
        if (!rows || rows.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="empty-msg"><i class="fa-regular fa-folder-open"></i> Không có seri khả dụng!</td></tr>';
            return;
        }
        const inCartSerials = new Set();
        if (currentDonId && cartByDon[currentDonId]) {
            cartByDon[currentDonId].forEach(function(item){ inCartSerials.add(item.soSeri); });
        }
        rows.forEach(function(s, idx) {
            const inCart  = inCartSerials.has(s.soSeri);
            const checked = selectedSeriIds.has(s.id);
            const tr = document.createElement('tr');
            tr.setAttribute('data-seri-id', s.id);
            if (inCart)  tr.style.opacity = '0.5';
            if (checked) tr.style.background = 'var(--primary-light)';
            const statusHtml = inCart
                ? '<span style="background:#f3f4f6;color:var(--text-muted);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;">Đã trong giỏ</span>'
                : '<span style="background:var(--success-bg);color:var(--success-text);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;"><i class="fa-solid fa-circle" style="font-size:7px;margin-right:3px;"></i>Còn hàng</span>';
            tr.innerHTML =
                '<td style="text-align:center;"><input type="checkbox" class="seri-cb" data-seri-id="' + s.id + '" data-so-seri="' + s.soSeri + '"' +
                (inCart ? ' disabled title="Đã trong giỏ"' : '') + (checked ? ' checked' : '') +
                ' style="width:15px;height:15px;cursor:' + (inCart?'not-allowed':'pointer') + ';accent-color:var(--primary);"></td>' +
                '<td style="text-align:center;">' + (idx+1) + '</td>' +
                '<td><span style="color:var(--primary);font-weight:700;font-size:13px;">' + s.soSeri + '</span></td>' +
                '<td style="font-size:12px;font-weight:600;">' + s.masp + '</td>' +
                '<td style="text-align:center;">' + statusHtml + '</td>';
            tbody.appendChild(tr);
        });

        tbody.querySelectorAll('.seri-cb').forEach(function(cb) {
            cb.addEventListener('change', function() {
                const id  = parseInt(this.getAttribute('data-seri-id'));
                if (isNaN(id)) return;
                const row = this.closest('tr');
                if (this.checked) { selectedSeriIds.add(id); row.style.background = 'var(--primary-light)'; }
                else              { selectedSeriIds.delete(id); row.style.background = ''; }
                updateSeriUI();
            });
        });
    }

    // Mở modal seri
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-open-seri');
        if (!btn) return;
        currentCauhinhId = parseInt(btn.dataset.cauhinhId);
        currentProduct = {
            masp: btn.dataset.masp || '', name: btn.dataset.name || '—',
            color: btn.dataset.color || '', price: parseFloat(btn.dataset.price) || 0,
            cpu: btn.dataset.cpu || '', ram: btn.dataset.ram || '',
            gpu: btn.dataset.gpu || '', storage: btn.dataset.storage || '', os: btn.dataset.os || ''
        };
        selectedSeriIds.clear();
        chkSelectAll.checked = false; chkSelectAll.indeterminate = false;
        document.getElementById('seriModalSubtitle').textContent =
            currentProduct.name + (currentProduct.color ? ' — ' + currentProduct.color : '') +
            ' | ' + currentProduct.price.toLocaleString('vi-VN') + ' đ / cái';

        const filtered = allSeriData.filter(function(s) {
            return s.cauhinhId === currentCauhinhId && s.trangThai === 0;
        });
        seriSearchInput.value = '';
        renderSeriTable(filtered);
        updateSeriUI();
        document.getElementById('productModal').classList.remove('active');
        document.getElementById('seriModal').classList.add('active');
    });

    document.getElementById('btnCloseSeriModal').addEventListener('click', function() {
        document.getElementById('seriModal').classList.remove('active');
        selectedSeriIds.clear();
    });
    document.getElementById('btnBackToProduct').addEventListener('click', function() {
        document.getElementById('seriModal').classList.remove('active');
        selectedSeriIds.clear();
        document.getElementById('productModal').classList.add('active');
    });

    chkSelectAll.addEventListener('change', function() {
        document.querySelectorAll('#seriTableBody .seri-cb:not([disabled])').forEach(function(cb) {
            const id = parseInt(cb.getAttribute('data-seri-id'));
            if (isNaN(id)) return;
            const row = cb.closest('tr');
            cb.checked = chkSelectAll.checked;
            if (chkSelectAll.checked) { selectedSeriIds.add(id); row.style.background = 'var(--primary-light)'; }
            else { selectedSeriIds.delete(id); row.style.background = ''; }
        });
        updateSeriUI();
    });

    seriSearchInput.addEventListener('input', function() {
        const kw = this.value.trim().toLowerCase();
        document.querySelectorAll('#seriTableBody tr[data-seri-id]').forEach(function(row) {
            row.style.display = (!kw || row.textContent.toLowerCase().includes(kw)) ? '' : 'none';
        });
    });

    // Xác nhận thêm seri vào giỏ
    btnConfirmAdd.addEventListener('click', function() {
        if (selectedSeriIds.size === 0 || !currentDonId) return;
        const ids = [...selectedSeriIds].filter(function(id){ return !isNaN(id) && id > 0; });
        if (ids.length === 0) { showToast('Không có seri hợp lệ để thêm!', 'warning'); return; }
        btnConfirmAdd.disabled = true;
        btnConfirmAdd.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang thêm...';

        // Thêm từng seri tuần tự
        const promises = ids.map(function(seriId) {
            const params = new URLSearchParams();
            params.append('idHoaDon', String(currentDonId));
            params.append('idSeri', String(seriId));
            return fetch(CTX + '/hoa-don/api/them-seri', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
                .then(function(r){
                    if (r.status === 403) { const err = new Error('403'); err.is403 = true; throw err; }
                    return r.json();
                })
                .then(function(data) {
                    data._seriId = seriId;
                    return data;
                });
        });

        Promise.all(promises).then(function(results) {
            const failures = results.filter(function(r){ return !r.success; });
            const ok = results.length - failures.length;

            if (failures.length > 0) {
                console.error('Lỗi thêm seri:', failures);
                const firstErr = failures[0].error || 'Lỗi không xác định';
                showToast('Lỗi: ' + firstErr, 'error');
            }

            selectedSeriIds.clear();
            results.forEach(function(r) {
                if (r.success) {
                    const s = allSeriData.find(function(x){ return x.id === r._seriId; });
                    if (s) s.trangThai = 1;
                }
            });
            loadCartFromServer(currentDonId);
            document.getElementById('seriModal').classList.remove('active');
            if (ok > 0) {
                document.getElementById('productModal').classList.add('active');
                showToast('Đã thêm ' + ok + ' sản phẩm vào giỏ!', 'success');
            }
        }).catch(function(err) {
            console.error('Promise.all lỗi:', err);
            if (err.message === '403') {
                showToast('Bạn không có quyền thao tác hoá đơn này!', 'error');
            } else {
                showToast('Có lỗi khi thêm sản phẩm!', 'error');
            }
        }).finally(function() {
            btnConfirmAdd.disabled = false;
            btnConfirmAdd.innerHTML = '<i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng';
        });
    });

    // ============================================================
    //  MODAL KHÁCH HÀNG
    // ============================================================
    document.getElementById('btnOpenCustomerModal').addEventListener('click', function() {
        if (!currentDonId) return;
        document.getElementById('customerModal').classList.add('active');
    });
    document.getElementById('btnCloseCustomerModal').addEventListener('click', function() {
        document.getElementById('customerModal').classList.remove('active');
    });

    document.getElementById('customerSearchInput').addEventListener('input', function() {
        const kw = this.value.toLowerCase();
        document.querySelectorAll('#dbCustomerListFull tr[data-search]').forEach(function(row) {
            row.style.display = (!kw || row.dataset.search.toLowerCase().includes(kw)) ? '' : 'none';
        });
    });

    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-select-customer');
        if (!btn || !currentDonId) return;
        const kh = { id: btn.dataset.id, name: btn.dataset.name, phone: btn.dataset.phone, email: btn.dataset.email, address: btn.dataset.address };
        fetch(CTX + '/hoa-don/api/cap-nhat-khach', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'idHoaDon=' + currentDonId + '&idKhachHang=' + kh.id
        })
            .then(function(r){
                if (r.status === 403) { showToast('Bạn không có quyền thao tác hoá đơn này!', 'error'); throw new Error('403'); }
                return r.json();
            })
            .then(function(data) {
                if (data.error) { showToast(data.error, 'error'); return; }
                khachByDon[currentDonId] = kh;
                renderKhachHangInfo(kh);
                document.getElementById('customerModal').classList.remove('active');
                showToast('Đã chọn khách hàng: ' + kh.name, 'success');
            })
            .catch(function(e){ if (e.message !== '403') showToast('Lỗi kết nối!', 'error'); });
    });

    // ============================================================
    //  THANH TOÁN
    // ============================================================
    document.getElementById('btnThanhToan').addEventListener('click', function() {
        if (!currentDonId) { showToast('Vui lòng chọn hoá đơn trước!', 'warning'); return; }
        const items = cartByDon[currentDonId] || [];
        if (items.length === 0) { showToast('Giỏ hàng trống!', 'warning'); return; }

        const totalText = document.getElementById('displayTotalFinal').textContent.replace(/[^0-9]/g, '');
        const total = parseInt(totalText) || 0;
        const tienKhach = parseInt(document.getElementById('tienKhachTraRaw').value) || 0;

        if (!tienKhach) {
            document.getElementById('tienKhachTra').classList.add('input-error');
            document.getElementById('errTienKhach').textContent = 'Vui lòng nhập tiền khách đưa';
            document.getElementById('errTienKhach').classList.add('show');
            document.getElementById('tienKhachTra').focus();
            return;
        }
        if (tienKhach < total) {
            document.getElementById('tienKhachTra').classList.add('input-error');
            document.getElementById('errTienKhach').textContent = 'Tiền nhập không đủ';
            document.getElementById('errTienKhach').classList.add('show');
            document.getElementById('tienKhachTra').focus();
            return;
        }

        const don = donChoList.find(function(d){ return d.id === currentDonId; });
        const tienThua = tienKhach - total;
        document.getElementById('confirmModalText').innerHTML =
            'Hoá đơn: <strong>' + (don ? don.maHoaDon : '') + '</strong><br>' +
            'Tổng tiền: <strong style="color:var(--danger-text);">' + total.toLocaleString('vi-VN') + ' đ</strong><br>' +
            'Tiền khách đưa: <strong>' + tienKhach.toLocaleString('vi-VN') + ' đ</strong><br>' +
            'Tiền thừa: <strong style="color:var(--success-text);">' + tienThua.toLocaleString('vi-VN') + ' đ</strong>';
        document.getElementById('confirmModal').classList.add('active');
    });

    document.getElementById('btnCancelConfirm').addEventListener('click', function() {
        document.getElementById('confirmModal').classList.remove('active');
    });

    document.getElementById('btnOkConfirm').addEventListener('click', function() {
        document.getElementById('confirmModal').classList.remove('active');
        const totalText = document.getElementById('displayTotalFinal').textContent.replace(/[^0-9]/g, '');
        const tienKhach = parseInt(document.getElementById('tienKhachTraRaw').value) || 0;
        const idHinhThuc = document.getElementById('hinhThucId').value;
        const btn = document.getElementById('btnThanhToan');
        btn.disabled = true; btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';

        const bodyStr = 'idHoaDon=' + currentDonId + '&idHinhThuc=' + idHinhThuc + '&tienKhachTra=' + tienKhach;
        fetch(CTX + '/hoa-don/api/thanh-toan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: bodyStr
        })
            .then(function(r){
                if (r.status === 403) { showToast('Bạn không có quyền thao tác hoá đơn này!', 'error'); throw new Error('403'); }
                return r.json();
            })
            .then(function(data) {
                if (data.error) { showToast(data.error, 'error'); return; }
                const doneId = currentDonId;
                const donData = donChoList.find(function(d){ return d.id === doneId; });
                const ma = donData ? donData.maHoaDon : '';
                // Xoá đơn khỏi danh sách
                donChoList = donChoList.filter(function(d){ return d.id !== doneId; });
                delete cartByDon[doneId]; delete khachByDon[doneId];
                currentDonId = donChoList.length > 0 ? donChoList[0].id : null;
                renderDonChoTabs();
                if (currentDonId) {
                    selectDon(currentDonId);
                } else {
                    document.getElementById('cartTableBody').innerHTML =
                        '<tr><td colspan="5" class="empty-msg"><i class="fa-solid fa-cart-shopping"></i> Chưa có sản phẩm.</td></tr>';
                    renderKhachHangInfo(null);
                    document.getElementById('displayTotalFinal').textContent = '0 đ';
                    document.getElementById('cartDonLabel').textContent = '— chưa chọn hoá đơn —';
                    document.getElementById('tienKhachTra').value = '';
                    document.getElementById('tienKhachTraRaw').value = '0';
                    document.getElementById('tienThuaDisplay').textContent = '0 đ';
                    const btnProd = document.getElementById('btnOpenProductModal');
                    const btnKhach = document.getElementById('btnOpenCustomerModal');
                    btnProd.disabled = true; btnProd.style.opacity = '.5';
                    btnKhach.disabled = true; btnKhach.style.opacity = '.5';
                    btn.disabled = true; btn.style.opacity = '.5';
                }
                showToast('✅ Thanh toán thành công! ' + ma + ' — Tiền thừa: ' + Number(data.tienThua||0).toLocaleString('vi-VN') + ' đ', 'success');
            })
            .catch(function(e) {
                if (e.message !== '403') showToast('Lỗi kết nối!', 'error');
            })
            .finally(function() {
                if (document.getElementById('btnThanhToan').disabled && currentDonId) {
                    document.getElementById('btnThanhToan').disabled = false;
                    document.getElementById('btnThanhToan').style.opacity = '1';
                }
                document.getElementById('btnThanhToan').innerHTML = '<i class="fa-solid fa-circle-check"></i> Xác nhận thanh toán';
            });
    });

}); // end DOMContentLoaded
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
