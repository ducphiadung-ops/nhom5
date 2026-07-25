<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="isNhanVien" value="${sessionScope.nhanVien != null and fn:contains(fn:toLowerCase(sessionScope.nhanVien.chucVu), 'nhân viên')}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Cấu hình CPU - Skycomputer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #1a56db; --primary-light: #e6efff; --sidebar-active: #eef2ff; --text-main: #1f2937; --text-muted: #6b7280; --bg-body: #f8f9fa; --border-color: #e5e7eb; --success-text: #047857; --success-bg: #d1fae5; --danger-text: #be123c; --danger-bg: #ffe4e6; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        /* Đồng bộ thẻ Body sang hiển thị Flexbox */
        body { display: flex; height: 100vh; background-color: var(--bg-body); color: var(--text-main); overflow: hidden; }

        /* Chèn CSS Sidebar Chuẩn ở Bước 1 vào đây */
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

        /* Khung nội dung */
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .top-header { height: 65px; background-color: #fff; display: flex; align-items: center; padding: 0 32px; border-bottom: 1px solid var(--border-color); }
        .header-actions { display: flex; align-items: center; gap: 24px; margin-left: auto; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 18px; }
        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 13px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 10px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; }
        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        .card-custom { background-color: #ffffff; border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .table-custom th { background-color: #f8fafc; color: var(--text-muted); font-weight: 600; font-size: 12px; text-transform: uppercase; padding: 14px 16px; }
        .table-custom td { padding: 16px; vertical-align: middle; font-size: 13px; border-bottom: 1px solid var(--border-color); }
        .badge-active { background-color: var(--success-bg); color: var(--success-text); padding: 5px 12px; border-radius: 6px; font-weight: 500; }
        .badge-inactive { background-color: var(--danger-bg); color: var(--danger-text); padding: 5px 12px; border-radius: 6px; font-weight: 500; }
    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="thuoc-tinh"/>
    <jsp:param name="activeSub"  value="cpu"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <div class="mb-4">
            <h4 class="fw-bold mb-1" style="color: var(--text-main);">Quản lý thuộc tính CPU</h4>
            <p class="text-muted mb-0" style="font-size: 13px;">Cấu hình danh mục các loại vi xử lý (CPU) cho sản phẩm laptop.</p>
        </div>
        <div class="row g-4">
            <c:if test="${not isNhanVien}">
            <div class="col-md-4">
                <div class="card card-custom p-4">
                    <h6 class="fw-bold mb-3 text-uppercase text-muted" style="font-size: 13px;"><i class="fa-solid fa-plus me-2"></i>Thêm CPU mới</h6>
                    <form action="${pageContext.request.contextPath}/thuoc-tinh/cpu/them" method="POST">
                        <div class="mb-3">
                            <label class="form-label small fw-medium text-muted">Tên CPU <span class="text-danger">*</span></label>
                            <input type="text" name="tenCpu" class="form-control py-2" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-medium text-muted">Thế hệ CPU</label>
                            <input type="text" name="theHeCpu" class="form-control py-2">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-medium" style="border-radius: 8px;">Lưu thuộc tính</button>
                    </form>
                </div>
            </div>
            </c:if>
            <div class="${isNhanVien ? 'col-md-12' : 'col-md-8'}">
                <div class="card card-custom p-4">
                    <h6 class="fw-bold text-uppercase mb-3 text-muted" style="font-size: 13px;"><i class="fa-solid fa-list me-2"></i>Danh sách bộ vi xử lý</h6>
                    <div class="table-responsive">
                        <table class="table table-custom table-hover align-middle text-center mb-0">
                            <thead>
                            <tr>
                                <th style="width: 60px;">STT</th>
                                <th class="text-start">Tên cấu hình CPU</th>
                                <th>Thế hệ</th>
                                <th>Trạng thái</th>
                                <c:if test="${not isNhanVien}"><th style="width: 150px;">Thao tác</th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${listCpu}" var="cpu" varStatus="status">
                                <tr>
                                    <td class="text-muted fw-medium">${status.index + 1}</td>
                                    <td class="text-start fw-semibold text-dark">${cpu.tenCpu}</td>
                                    <td class="text-muted">${empty cpu.theHeCpu ? '—' : cpu.theHeCpu}</td>
                                    <td><c:choose><c:when test="${cpu.trangThai}"><span class="badge-active">Sử dụng</span></c:when><c:otherwise><span class="badge-inactive">Ngừng dùng</span></c:otherwise></c:choose></td>
                                    <c:if test="${not isNhanVien}">
                                    <td>
                                        <div class="d-flex justify-content-center gap-3">
                                            <a href="${pageContext.request.contextPath}/thuoc-tinh/cpu/sua?id=${cpu.id}" class="text-muted"><i class="fa-regular fa-pen-to-square"></i></a>
                                            <a href="${pageContext.request.contextPath}/thuoc-tinh/cpu/xoa?id=${cpu.id}" class="text-danger" onclick="return confirm('Ngừng sử dụng CPU này?');"><i class="fa-regular fa-trash-can"></i></a>
                                        </div>
                                    </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
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