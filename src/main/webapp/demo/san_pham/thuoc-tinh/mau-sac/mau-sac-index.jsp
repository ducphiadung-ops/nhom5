<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    pageContext.setAttribute("isNhanVien", _isNhanVien);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Màu sắc - Skycomputer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root{--primary:#1a56db;--sidebar-active:#eef2ff;--text-main:#1f2937;--text-muted:#6b7280;--bg-body:#f8f9fa;--border-color:#e5e7eb;--success-text:#047857;--success-bg:#d1fae5;--danger-text:#be123c;--danger-bg:#ffe4e6;}
        *{margin:0;padding:0;box-sizing:border-box;font-family:'Inter',sans-serif;}
        body{display:flex;height:100vh;background-color:var(--bg-body);color:var(--text-main);overflow:hidden;}
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
        .main-wrapper{flex:1;display:flex;flex-direction:column;overflow:hidden;}
        .top-header{height:65px;background-color:#fff;display:flex;align-items:center;padding:0 32px;border-bottom:1px solid var(--border-color);}
        .header-actions{display:flex;align-items:center;gap:24px;margin-left:auto;}
        .user-profile{display:flex;align-items:center;gap:12px;}
        .user-info{text-align:right;}
        .user-name{font-size:13px;font-weight:600;color:var(--text-main);}
        .user-role{font-size:10px;color:var(--text-muted);text-transform:uppercase;}
        .avatar{width:34px;height:34px;border-radius:50%;object-fit:cover;}
        .content-area{flex:1;padding:24px 32px;overflow-y:auto;}
        .card-custom{background-color:#fff;border:1px solid var(--border-color);border-radius:12px;box-shadow:0 1px 3px rgba(0,0,0,.02);}
        .table-custom th{background-color:#f8fafc;color:var(--text-muted);font-weight:600;font-size:12px;text-transform:uppercase;padding:14px 16px;}
        .table-custom td{padding:16px;vertical-align:middle;font-size:13px;border-bottom:1px solid var(--border-color);}
        .badge-active{background-color:var(--success-bg);color:var(--success-text);padding:5px 12px;border-radius:6px;font-weight:500;}
        .badge-inactive{background-color:var(--danger-bg);color:var(--danger-text);padding:5px 12px;border-radius:6px;font-weight:500;}
        .form-label{font-size:12px;font-weight:600;color:#475569;text-transform:uppercase;}
    </style>
</head>
<body>

<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="thuoc-tinh"/>
    <jsp:param name="activeSub"  value="mau-sac"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <div class="mb-4">
            <h4 class="fw-bold mb-1">Quản lý thuộc tính Màu sắc</h4>
            <p class="text-muted mb-0">Cấu hình danh mục màu sơn vỏ máy ngoại hình laptop.</p>
        </div>
        <div class="row g-4">
            <c:if test="${not isNhanVien}">
            <div class="col-md-4">
                <div class="card card-custom p-4">
                    <h6 class="fw-bold mb-3 text-uppercase" style="font-size:13px;color:#475569;"><i class="fa-solid fa-plus me-2"></i>Thêm Màu sắc mới</h6>
                    <form action="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/them" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Tên màu sắc <span class="text-danger">*</span></label>
                            <input type="text" name="tenMauSac" class="form-control py-2" placeholder="Ví dụ: Bạc (Silver), Đen" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-medium" style="border-radius:8px;"><i class="fa-solid fa-save me-2"></i>Lưu thuộc tính</button>
                    </form>
                </div>
            </div>
            </c:if>
            <div class="${isNhanVien ? 'col-md-12' : 'col-md-8'}">
                <div class="card card-custom p-4">
                    <h6 class="fw-bold text-uppercase mb-3" style="font-size:13px;color:#475569;"><i class="fa-solid fa-list me-2"></i>Danh sách phiên bản màu</h6>
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle text-center mb-0">
                            <thead><tr>
                                <th style="width:60px;">STT</th>
                                <th class="text-start">Tên Màu sắc</th>
                                <th>Trạng thái</th>
                                <c:if test="${not isNhanVien}"><th style="width:120px;">Thao tác</th></c:if>
                            </tr></thead>
                            <tbody>
                            <c:forEach items="${listMauSac}" var="ms" varStatus="status">
                                <tr>
                                    <td class="text-secondary fw-medium">${status.index + 1}</td>
                                    <td class="text-start fw-semibold text-dark">${ms.tenMauSac}</td>
                                    <td><c:choose><c:when test="${ms.trangThai}"><span class="badge-active">Sử dụng</span></c:when><c:otherwise><span class="badge-inactive">Ngừng dùng</span></c:otherwise></c:choose></td>
                                    <c:if test="${not isNhanVien}">
                                    <td>
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/sua?id=${ms.id}" class="btn btn-sm btn-outline-secondary" style="border-radius:6px;"><i class="fa-regular fa-pen-to-square"></i></a>
                                            <a href="${pageContext.request.contextPath}/thuoc-tinh/mau-sac/xoa?id=${ms.id}" class="btn btn-sm btn-outline-danger" style="border-radius:6px;" onclick="return confirm('Ngừng kích hoạt Màu sắc này?');"><i class="fa-regular fa-trash-can"></i></a>
                                        </div>
                                    </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listMauSac}"><tr><td colspan="4" class="text-center py-5 text-muted">Chưa có dữ liệu Màu sắc nào!</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
