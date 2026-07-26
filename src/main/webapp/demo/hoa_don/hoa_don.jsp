<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hóa đơn - Skycomputer</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{--primary:#1a56db;--primary-light:#e6efff;--sidebar-active:#eef2ff;--text-main:#1f2937;--text-muted:#6b7280;--bg-body:#f8f9fa;--border-color:#e5e7eb;--success-text:#047857;--success-bg:#d1fae5;--warning-text:#b45309;--warning-bg:#fef3c7;--danger-text:#be123c;--danger-bg:#ffe4e6;}
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Inter',sans-serif;}
        body{display:flex;height:100vh;background-color:var(--bg-body);color:var(--text-main);overflow:hidden;}
        /* SIDEBAR */
        .sidebar{width:260px;background-color:#fff;border-right:1px solid var(--border-color);display:flex;flex-direction:column;height:100vh;padding-bottom:16px;z-index:10;}
        .brand{display:flex;align-items:center;padding:20px;gap:12px;border-bottom:1px solid var(--border-color);margin-bottom:12px;}
        .brand-logo{width:40px;height:40px;border-radius:8px;overflow:hidden;display:flex;align-items:center;justify-content:center;background:#fff;}
        .brand-logo img{width:100%;height:100%;object-fit:contain;}
        .brand-text h1{font-size:16px;font-weight:700;color:#1e3a8a;margin-bottom:0;}
        .brand-text p{font-size:11px;color:var(--text-muted);margin-bottom:0;}
        .nav-menu{list-style:none;padding:0 12px;flex:1;overflow-y:auto;}
        .nav-item{margin-bottom:4px;}
        .nav-link-custom{display:flex;align-items:center;padding:11px 16px;color:var(--text-muted);text-decoration:none;border-radius:8px;font-size:14px;font-weight:500;transition:all 0.2s;gap:12px;}
        .nav-link-custom i{font-size:16px;width:20px;text-align:center;}
        .nav-link-custom:hover{background-color:#f3f4f6;color:var(--text-main);}
        .nav-link-custom.active{background-color:var(--sidebar-active);color:var(--primary);font-weight:600;}
        .sub-menu{list-style:none;padding-left:0;margin-top:4px;display:flex;flex-direction:column;gap:2px;}
        .sub-menu .nav-link-custom{padding:9px 16px 9px 44px !important;font-size:13px;}
        .sub-menu .nav-link-custom.active-sub{background-color:var(--sidebar-active);color:var(--primary);font-weight:600;}
        .logout-item{margin-top:auto;padding:0 12px;}
        .nav-link-custom.logout-link{color:#dc2626;border-top:1px solid var(--border-color);border-radius:0;padding-top:16px;}
        .nav-link-custom.logout-link:hover{background-color:var(--danger-bg);color:var(--danger-text);border-radius:8px;}
        /* MAIN */
        .main-wrapper{flex:1;display:flex;flex-direction:column;overflow:hidden;}
        .top-header{height:70px;background-color:#fff;display:flex;align-items:center;padding:0 32px;border-bottom:1px solid var(--border-color);}
        .header-actions{display:flex;align-items:center;gap:20px;margin-left:auto;}
        .notification{position:relative;color:var(--text-muted);cursor:pointer;font-size:18px;}
        .notification::after{content:'';position:absolute;top:-2px;right:0;width:6px;height:6px;background:#ef4444;border-radius:50%;border:2px solid #fff;}
        .user-profile{display:flex;align-items:center;gap:10px;}
        .user-info{text-align:right;}
        .user-name{font-size:13px;font-weight:600;color:var(--text-main);}
        .user-role{font-size:10px;color:var(--text-muted);text-transform:uppercase;}
        .avatar{width:32px;height:32px;border-radius:50%;object-fit:cover;}
        .content-area{flex:1;padding:20px 24px;overflow-y:auto;}
        .page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;}
        .page-title h2{font-size:18px;font-weight:600;margin-bottom:2px;}
        .page-title p{font-size:12px;color:var(--text-muted);}
        .btn{padding:8px 14px;border-radius:6px;font-size:12px;font-weight:500;cursor:pointer;display:flex;align-items:center;gap:6px;border:none;transition:0.2s;text-decoration:none;}
        .btn-outline{background:#fff;border:1px solid var(--border-color);color:var(--text-main);}
        .btn-outline:hover{background:#f9fafb;}
        .btn-primary{background:var(--primary);color:#fff;}
        .btn-primary:hover{background:#154cbf;}
        .btn-icon{padding:8px 10px;font-size:15px;}
        .btn-icon svg{width:16px;height:16px;display:block;}
        .table-toolbar{display:flex;justify-content:flex-end;align-items:center;gap:10px;margin-bottom:12px;}
        .filter-card{background:#fff;border-radius:10px;padding:16px;box-shadow:0 1px 2px rgba(0,0,0,.05);margin-bottom:12px;border:1px solid var(--border-color);}
        .filter-grid{display:grid;grid-template-columns:1fr 1fr 1fr auto auto;gap:12px;align-items:end;}
        .form-group{display:flex;flex-direction:column;gap:6px;}
        .form-group label{font-size:12px;font-weight:500;color:var(--text-main);}
        .form-control{width:100%;padding:8px 12px;border:1px solid var(--border-color);border-radius:6px;font-size:12px;color:var(--text-main);outline:none;}
        .btn-filter{background:var(--primary-light);color:var(--primary);border:none;padding:8px 16px;border-radius:6px;font-size:12px;font-weight:500;cursor:pointer;white-space:nowrap;}
        .table-container{background:#fff;border:1px solid var(--border-color);border-radius:10px;overflow:hidden;}
        table{width:100%;border-collapse:collapse;table-layout:fixed;}
        th{background:#f8fafc;padding:12px 8px;text-align:left;font-size:11px;font-weight:600;color:var(--text-main);border-bottom:1px solid var(--border-color);}
        td{padding:10px 8px;border-bottom:1px solid var(--border-color);font-size:12.5px;vertical-align:middle;}
        .col-stt{width:40px;text-align:center !important;}
        .col-ma{width:95px;}
        .col-nv{width:110px;}
        .col-khach{width:120px;}
        .col-sdt{width:85px;text-align:center !important;}
        .col-date{width:120px;text-align:center !important;white-space:nowrap;}
        .col-payment{width:100px;text-align:center !important;}
        .col-amount{width:110px;text-align:right !important;}
        .col-status{width:115px;text-align:center !important;}
        .col-action{width:55px;text-align:center !important;}
        .invoice-id{color:var(--primary);font-weight:600;text-decoration:none;}
        .employee-name,.customer-info p{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
        .employee-name{max-width:100px;font-weight:500;}
        .customer-info p{max-width:85px;font-weight:600;}
        .customer-info{display:flex;align-items:center;gap:6px;}
        .avatar-initial{width:26px;height:26px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:10px;font-weight:600;flex-shrink:0;}
        .bg-orange-light{background:#ffedd5;color:#c2410c;}
        .total-amount{font-weight:700;}
        .badge{padding:4px 10px;border-radius:20px;font-size:10.5px;font-weight:500;display:inline-block;white-space:nowrap;}
        .badge-success{background:var(--success-bg);color:var(--success-text);}
        .badge-warning{background:var(--warning-bg);color:var(--warning-text);}
        .badge-danger{background:var(--danger-bg);color:var(--danger-text);}
        .action-icons{display:flex;gap:10px;justify-content:center;}
        .action-icons a{color:var(--text-muted);}
        .action-icons a:hover{color:var(--primary);}
        /* Empty state */
        .empty-state{padding:48px 0;text-align:center;color:var(--text-muted);}
        .empty-state i{font-size:40px;margin-bottom:12px;opacity:0.4;display:block;}
        .empty-state p{font-size:14px;font-weight:500;}
        .empty-state span{font-size:12px;}
    </style>
</head>
<body>

<%-- SIDEBAR --%>
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="hoa-don"/>
</jsp:include>

<main class="main-wrapper">
    <%-- HEADER --%>
    <jsp:include page="/demo/common/header.jsp"/>

    <div class="content-area">
        <div class="page-header">
            <div class="page-title">
                <h2>Quản lý hóa đơn</h2>
                <p>Xem, tra cứu và xử lý danh sách hóa đơn bán hàng.</p>
            </div>
        </div>

        <%-- BỘ LỌC --%>
        <div class="filter-card">
            <form action="${pageContext.request.contextPath}/hoa-don/hien-thi" method="GET">
                <div class="filter-grid">
                    <div class="form-group">
                        <label>Tìm kiếm</label>
                        <input type="text" name="keyword" class="form-control"
                               placeholder="Mã hóa đơn, Tên KH, SĐT..." value="${oldKeyword}">
                    </div>
                    <div class="form-group">
                        <label>Trạng thái</label>
                        <select name="trangThai" class="form-control">
                            <option value="">Tất cả trạng thái</option>
                            <option value="1" ${oldTrangThai == '1' ? 'selected' : ''}>Đã thanh toán</option>
                            <option value="0" ${oldTrangThai == '0' ? 'selected' : ''}>Chưa thanh toán</option>
                            <option value="2" ${oldTrangThai == '2' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="3" ${oldTrangThai == '3' ? 'selected' : ''}>Đã huỷ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Ngày tạo</label>
                        <input type="date" name="ngayTao" class="form-control" value="${oldNgayTao}">
                    </div>
                    <input type="hidden" name="filtered" value="true">
                    <button type="submit" class="btn-filter"><i class="fa-solid fa-filter"></i> Lọc</button>
                    <a href="${pageContext.request.contextPath}/hoa-don/hien-thi?filtered=true"
                       class="btn btn-outline" style="white-space:nowrap;">
                        <i class="fa-solid fa-xmark"></i> Xóa lọc
                    </a>
                </div>
            </form>
        </div>

        <%-- TOOLBAR: admin thấy đủ nút, nhân viên chỉ thấy Xuất file --%>
        <div class="table-toolbar">
            <button type="button" class="btn btn-outline" onclick="xuatFileExcel()">
                <i class="fa-solid fa-download"></i> Xuất file
            </button>
            <c:if test="${not isNhanVien}">
                <button class="btn btn-outline btn-icon" title="Xuất mã QR">
                    <svg viewBox="0 0 29 29" xmlns="http://www.w3.org/2000/svg" fill="currentColor">
                        <path d="M1 1h9v9h-9z" fill="none" stroke="currentColor" stroke-width="1.6"/>
                        <rect x="3.4" y="3.4" width="4.2" height="4.2"/>
                        <path d="M19 1h9v9h-9z" fill="none" stroke="currentColor" stroke-width="1.6"/>
                        <rect x="21.4" y="3.4" width="4.2" height="4.2"/>
                        <path d="M1 19h9v9h-9z" fill="none" stroke="currentColor" stroke-width="1.6"/>
                        <rect x="3.4" y="21.4" width="4.2" height="4.2"/>
                        <rect x="13" y="1" width="2.2" height="2.2"/>
                        <rect x="13" y="13" width="2.2" height="2.2"/>
                        <rect x="19" y="19" width="2.2" height="2.2"/>
                    </svg>
                </button>
                <a href="${pageContext.request.contextPath}/hoa-don/ban-hang" class="btn btn-primary">
                    <i class="fa-solid fa-plus"></i> Tạo hóa đơn
                </a>
            </c:if>
        </div>

        <%-- BẢNG DỮ LIỆU --%>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th class="col-stt">STT</th>
                    <th class="col-ma">MÃ HÓA ĐƠN</th>
                    <th class="col-nv">NHÂN VIÊN</th>
                    <th class="col-khach">KHÁCH HÀNG</th>
                    <th class="col-sdt">SĐT</th>
                    <th class="col-payment">THANH TOÁN</th>
                    <th class="col-amount">TỔNG TIỀN</th>
                    <th class="col-date">NGÀY TẠO</th>
                    <th class="col-status">TRẠNG THÁI</th>
                    <th class="col-action">THAO TÁC</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty ListHoaDon}">
                        <tr>
                            <td colspan="10">
                                <div class="empty-state">
                                    <i class="fa-regular fa-folder-open"></i>
                                    <p>Không có hóa đơn cần tìm</p>
                                    <span>Thử thay đổi bộ lọc hoặc xóa lọc để xem tất cả hóa đơn</span>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${ListHoaDon}" var="hd" varStatus="stt">
                            <tr>
                                <td class="col-stt">${stt.index + 1}</td>
                                <td class="col-ma">
                                    <a href="${pageContext.request.contextPath}/hoa-don/detail?id=${hd.id}" class="invoice-id">${hd.maHoaDon}</a>
                                </td>
                                <td class="col-nv">
                                    <div class="employee-name">${hd.nhanVien != null ? hd.nhanVien.hoTen : '—'}</div>
                                </td>
                                <td class="col-khach">
                                    <div class="customer-info">
                                        <div class="avatar-initial bg-orange-light">KH</div>
                                        <div><p>${hd.khachHang != null ? hd.khachHang.tenKhachHang : '—'}</p></div>
                                    </div>
                                </td>
                                <td class="col-sdt">${hd.khachHang != null ? hd.khachHang.sdt : '—'}</td>
                                <td class="col-payment" style="font-weight:500;">
                                    ${hd.hinhThucThanhToan != null ? hd.hinhThucThanhToan.tenHinhThuc : '—'}
                                </td>
                                <td class="total-amount col-amount">
                                    <fmt:formatNumber value="${hd.tongTien}" type="number" maxFractionDigits="0"/> đ
                                </td>
                                <td class="col-date" style="color:var(--text-muted);font-size:12px;">${hd.ngayLap}</td>
                                <td class="col-status">
                                            <c:choose>
                                                <c:when test="${hd.trangThai == 1}">
                                                    <span class="badge badge-success">Đã thanh toán</span>
                                                </c:when>
                                                <c:when test="${hd.trangThai == 0}">
                                                    <span class="badge badge-danger">Chưa thanh toán</span>
                                                </c:when>
                                                <c:when test="${hd.trangThai == 2}">
                                                    <span class="badge badge-warning">Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${hd.trangThai == 3}">
                                                    <span class="badge badge-danger">Đã huỷ</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge">${hd.trangThai}</span>
                                                </c:otherwise>
                                            </c:choose>
                                </td>
                                <td class="col-action">
                                    <div class="action-icons">
                                        <a href="${pageContext.request.contextPath}/hoa-don/detail?id=${hd.id}" title="Xem chi tiết">
                                            <i class="fa-regular fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
    function xuatFileExcel() {
        let keyword   = document.querySelector('input[name="keyword"]').value   || "";
        let trangThai = document.querySelector('select[name="trangThai"]').value || "";
        let ngayTao   = document.querySelector('input[name="ngayTao"]').value   || "";
        window.location.href = '${pageContext.request.contextPath}/hoa-don/export'
            + '?keyword='   + encodeURIComponent(keyword)
            + '&trangThai=' + encodeURIComponent(trangThai)
            + '&ngayTao='   + encodeURIComponent(ngayTao);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
