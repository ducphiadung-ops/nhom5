<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    demo.entity.nhan_vien.NhanVien _nv = (demo.entity.nhan_vien.NhanVien) session.getAttribute("nhanVien");
    boolean _isNhanVien = demo.servlet.LoginServlet.isNhanVienRole(_nv != null ? _nv.getChucVu() : null);
    request.setAttribute("isNhanVien", _isNhanVien);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Sản phẩm chi tiết - Skycomputer</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            --success-text: #047857;
            --success-bg: #d1fae5;
            --danger-text: #be123c;
            --danger-bg: #ffe4e6;
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

        /* 🎨 SIDEBAR MÀU TRẮNG SÁNG */
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

        /* --- MAIN WRAPPER KHU VỰC BÊN PHẢI --- */
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-body); }

        .top-header {
            height: 65px;
            background-color: #fff;
            display: flex;
            align-items: center;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-color);
        }
        .header-actions { display: flex; align-items: center; gap: 24px; margin-left: auto; }
        .notification { position: relative; color: var(--text-muted); cursor: pointer; font-size: 18px; }
        .notification::after { content: ''; position: absolute; top: -2px; right: 0px; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; border: 2px solid #fff; }

        .user-profile { display: flex; align-items: center; gap: 12px; }
        .user-info { text-align: right; }
        .user-name { font-size: 13px; font-weight: 600; color: var(--text-main); }
        .user-role { font-size: 10px; color: var(--text-muted); text-transform: uppercase; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; }

        .content-area { flex: 1; padding: 24px 32px; overflow-y: auto; }

        .content-card { background-color: #ffffff; border-radius: 12px; padding: 24px; border: 1px solid var(--border-color); box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .table-custom th { font-size: 12px; text-transform: uppercase; color: var(--text-muted); background-color: #f8fafc; padding: 14px; border-bottom: 1px solid var(--border-color); }
        .table-custom td { padding: 16px 14px; vertical-align: middle; font-size: 14px; border-bottom: 1px solid var(--border-color); }

        .toast-notification {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 1050;
            min-width: 320px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            border: none;
        }

        .action-icon-btn {
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            text-decoration: none;
            display: inline-block;
        }
        .action-icon-btn:hover {
            color: var(--primary);
            transform: scale(1.2);
        }
        .action-icon-btn.text-danger:hover {
            color: #dc2626 !important;
        }

        /* BỘ LỌC BIẾN THỂ */
        .filter-card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid var(--border-color); }
        .search-input-wrapper { position: relative; }
        .search-input-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 14px; }
        .search-input-wrapper input { padding-left: 36px; }

        /* PRICE RANGE SLIDER */
        .price-range-wrapper { padding: 4px 2px 0; }
        .price-range-label { display: flex; justify-content: space-between; font-size: 12px; color: var(--text-muted); margin-bottom: 6px; }
        .price-range-label span { font-weight: 600; color: var(--primary); }
        .range-slider-container { position: relative; height: 6px; background: #e2e8f0; border-radius: 4px; margin: 0 2px; }
        .range-slider-fill { position: absolute; height: 100%; background: var(--primary); border-radius: 4px; pointer-events: none; }
        input[type="range"].price-slider {
            -webkit-appearance: none; appearance: none;
            position: absolute; width: 100%; height: 6px;
            background: transparent; pointer-events: none; margin: 0;
        }
        input[type="range"].price-slider::-webkit-slider-thumb {
            -webkit-appearance: none; appearance: none;
            width: 18px; height: 18px; border-radius: 50%;
            background: var(--primary); border: 2px solid #fff;
            box-shadow: 0 1px 4px rgba(26,86,219,.4);
            cursor: pointer; pointer-events: all;
        }
        input[type="range"].price-slider::-moz-range-thumb {
            width: 18px; height: 18px; border-radius: 50%;
            background: var(--primary); border: 2px solid #fff;
            box-shadow: 0 1px 4px rgba(26,86,219,.4);
            cursor: pointer; pointer-events: all;
        }
    </style>
</head>
<body>

<!-- SIDEBAR & HEADER (dùng chung) -->
<jsp:include page="/demo/common/sidebar.jsp">
    <jsp:param name="activeMenu" value="san-pham"/>
    <jsp:param name="activeSub"  value="chi-tiet-sp"/>
</jsp:include>

<main class="main-wrapper">
    <jsp:include page="/demo/common/header.jsp"/>
    <div class="content-area">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show toast-notification" role="alert">
                    ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show toast-notification" role="alert">
                    ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <%-- Khi lọc theo sản phẩm: hiển thị breadcrumb + tiêu đề riêng --%>
        <c:choose>
            <c:when test="${not empty idSanPhamFilter}">
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/san-pham/hien-thi"
                       class="text-decoration-none text-muted" style="font-size: 13px;">
                        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách sản phẩm
                    </a>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="badge bg-light text-dark border px-2 py-1 fw-medium" style="font-size: 12px;">
                                #${maSanPhamHienTai}
                            </span>
                            <h4 class="fw-bold mb-0" style="color: var(--text-main);">${tenDongMayHienTai}</h4>
                        </div>
                        <small class="text-muted">Danh sách biến thể (${fn:length(listChiTiet)} biến thể)</small>
                    </div>
                    <c:if test="${not isNhanVien}">
                    <a href="${pageContext.request.contextPath}/san-pham/giao-dien-them" class="btn btn-primary px-4 py-2" style="border-radius: 8px; font-weight: 500; font-size: 14px;">
                        <i class="fa-solid fa-plus me-2"></i>Thêm biến thể mới
                    </a>
                    </c:if>
                </div>

                <%-- BỘ LỌC cho chế độ xem biến thể của 1 sản phẩm --%>
                <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" method="GET"
                      class="filter-card" id="formLocBienTheSP">
                    <%-- Giữ lại idSanPham để server biết đang xem SP nào --%>
                    <input type="hidden" name="idSanPham" value="${idSanPhamFilter}">
                    <div class="row g-3">

                        <!-- Màu sắc -->
                        <div class="col-md-3">
                            <label class="form-label small fw-medium text-muted mb-1">Màu sắc</label>
                            <select name="idMauSac" class="form-select form-select-sm py-2">
                                <option value="">Tất cả màu</option>
                                <c:forEach items="${listMauSacFilter}" var="ms">
                                    <option value="${ms.id}" ${oldIdMauSac == ms.id ? 'selected' : ''}>${ms.tenMauSac}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- RAM -->
                        <div class="col-md-3">
                            <label class="form-label small fw-medium text-muted mb-1">RAM</label>
                            <select name="idRam" class="form-select form-select-sm py-2">
                                <option value="">Tất cả RAM</option>
                                <c:forEach items="${listRamFilter}" var="ram">
                                    <option value="${ram.id}" ${oldIdRam == ram.id ? 'selected' : ''}>${ram.dungLuongRam}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Ổ cứng -->
                        <div class="col-md-3">
                            <label class="form-label small fw-medium text-muted mb-1">Ổ cứng</label>
                            <select name="idOCung" class="form-select form-select-sm py-2">
                                <option value="">Tất cả ổ cứng</option>
                                <c:forEach items="${listOCungFilter}" var="oc">
                                    <option value="${oc.id}" ${oldIdOCung == oc.id ? 'selected' : ''}>${oc.dungLuongOCung}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Trạng thái -->
                        <div class="col-md-2">
                            <label class="form-label small fw-medium text-muted mb-1">Trạng thái</label>
                            <select name="trangThai" class="form-select form-select-sm py-2">
                                <option value="">Tất cả</option>
                                <option value="1" ${oldTrangThai == '1' ? 'selected' : ''}>Hoạt động</option>
                                <option value="0" ${oldTrangThai == '0' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>

                        <!-- Nút lọc / reset -->
                        <div class="col-md-1 d-flex align-items-end gap-2">
                            <button type="submit" class="btn btn-primary btn-sm py-2 px-3">
                                <i class="fa-solid fa-filter me-1"></i>Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi?idSanPham=${idSanPhamFilter}"
                               class="btn btn-outline-secondary btn-sm py-2" title="Xoá bộ lọc">
                                <i class="fa-solid fa-rotate-left"></i>
                            </a>
                        </div>

                        <!-- Thanh kéo khoảng giá — full width, đáy form -->
                        <div class="col-12">
                            <label class="form-label small fw-medium text-muted mb-1">
                                Khoảng giá bán &nbsp;(từ <strong>0 đ</strong> đến <span id="lblGiaMaxSPFilter" class="text-primary fw-bold"></span>)
                            </label>
                            <div class="price-range-wrapper">
                                <div class="range-slider-container">
                                    <div class="range-slider-fill" id="sliderFillSPFilter"></div>
                                    <input type="range" class="price-slider" id="sliderMaxSPFilter" name="giaMax"
                                           min="${priceAbsMin}" max="${priceAbsMax}"
                                           value="${oldGiaMax}" step="100000">
                                </div>
                                <div class="price-range-label mt-2">
                                    <span>0 ₫</span>
                                    <span id="lblRightSPFilter"></span>
                                </div>
                            </div>
                            <input type="hidden" name="giaMin" value="0">
                        </div>

                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold mb-1" style="color: var(--text-main);">Quản lý Biến thể Sản phẩm</h4>
                        <small class="text-muted">Danh sách các phiên bản cấu hình thương mại trong kho</small>
                    </div>
                    <c:if test="${not isNhanVien}">
                    <a href="${pageContext.request.contextPath}/san-pham/giao-dien-them" class="btn btn-primary px-4 py-2" style="border-radius: 8px; font-weight: 500; font-size: 14px;">
                        <i class="fa-solid fa-plus me-2"></i>Thêm biến thể mới
                    </a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- Bộ lọc biến thể (chỉ hiện khi đang ở danh sách tất cả, không phải lọc theo SP cha) --%>
        <c:if test="${empty idSanPhamFilter}">
        <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi" method="GET"
              class="filter-card" id="formLocBienThe">
            <div class="row g-3">

                <!-- Tên sản phẩm cha -->
                <div class="col-md-3">
                    <label class="form-label small fw-medium text-muted mb-1">Tên sản phẩm</label>
                    <div class="search-input-wrapper">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="tenSanPham" class="form-control form-control-sm py-2"
                               placeholder="Tìm theo tên SP..." value="${oldTenSanPham}">
                    </div>
                </div>

                <!-- CPU -->
                <div class="col-md-3">
                    <label class="form-label small fw-medium text-muted mb-1">CPU</label>
                    <select name="idCpu" class="form-select form-select-sm py-2">
                        <option value="">Tất cả CPU</option>
                        <c:forEach items="${listCpuFilter}" var="cpu">
                            <option value="${cpu.id}" ${oldIdCpu == cpu.id ? 'selected' : ''}>${cpu.tenCpu}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- GPU -->
                <div class="col-md-3">
                    <label class="form-label small fw-medium text-muted mb-1">GPU</label>
                    <select name="idGpu" class="form-select form-select-sm py-2">
                        <option value="">Tất cả GPU</option>
                        <c:forEach items="${listGpuFilter}" var="gpu">
                            <option value="${gpu.id}" ${oldIdGpu == gpu.id ? 'selected' : ''}>${gpu.tenGpu}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Màu sắc -->
                <div class="col-md-3">
                    <label class="form-label small fw-medium text-muted mb-1">Màu sắc</label>
                    <select name="idMauSac" class="form-select form-select-sm py-2">
                        <option value="">Tất cả màu</option>
                        <c:forEach items="${listMauSacFilter}" var="ms">
                            <option value="${ms.id}" ${oldIdMauSac == ms.id ? 'selected' : ''}>${ms.tenMauSac}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- RAM -->
                <div class="col-md-2">
                    <label class="form-label small fw-medium text-muted mb-1">RAM</label>
                    <select name="idRam" class="form-select form-select-sm py-2">
                        <option value="">Tất cả RAM</option>
                        <c:forEach items="${listRamFilter}" var="ram">
                            <option value="${ram.id}" ${oldIdRam == ram.id ? 'selected' : ''}>${ram.dungLuongRam}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Ổ cứng -->
                <div class="col-md-2">
                    <label class="form-label small fw-medium text-muted mb-1">Ổ cứng</label>
                    <select name="idOCung" class="form-select form-select-sm py-2">
                        <option value="">Tất cả ổ cứng</option>
                        <c:forEach items="${listOCungFilter}" var="oc">
                            <option value="${oc.id}" ${oldIdOCung == oc.id ? 'selected' : ''}>${oc.dungLuongOCung}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Trạng thái -->
                <div class="col-md-2">
                    <label class="form-label small fw-medium text-muted mb-1">Trạng thái</label>
                    <select name="trangThai" class="form-select form-select-sm py-2">
                        <option value="">Tất cả</option>
                        <option value="1" ${oldTrangThai == '1' ? 'selected' : ''}>Hoạt động</option>
                        <option value="0" ${oldTrangThai == '0' ? 'selected' : ''}>Không hoạt động</option>
                    </select>
                </div>

                <!-- Nút -->
                <div class="col-md-4 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary btn-sm px-4 py-2">
                        <i class="fa-solid fa-filter me-1"></i>Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/hien-thi"
                       class="btn btn-outline-secondary btn-sm py-2" title="Xoá bộ lọc">
                        <i class="fa-solid fa-rotate-left"></i>
                    </a>
                </div>

                <!-- Thanh kéo khoảng giá — full width, đáy bộ lọc -->
                <div class="col-12">
                    <label class="form-label small fw-medium text-muted mb-1">
                        Khoảng giá bán &nbsp;(từ <strong>0 đ</strong> đến <span id="lblGiaMaxCT" class="text-primary fw-bold"></span>)
                    </label>
                    <div class="price-range-wrapper">
                        <div class="range-slider-container">
                            <div class="range-slider-fill" id="sliderFillCT"></div>
                            <input type="range" class="price-slider" id="sliderMaxCT" name="giaMax"
                                   min="${priceAbsMin}" max="${priceAbsMax}"
                                   value="${oldGiaMax}" step="100000">
                        </div>
                        <div class="price-range-label mt-2">
                            <span>0 ₫</span>
                            <span id="lblRightCT"></span>
                        </div>
                    </div>
                    <input type="hidden" name="giaMin" value="0">
                </div>

            </div>
        </form>
        </c:if>

        <div class="content-card">
            <table class="table table-custom align-middle">
                <thead>
                <tr>
                    <th style="width: 50px;">STT</th>
                    <%-- Ẩn cột "Tên SP Cha" khi đang lọc theo sản phẩm (đã hiển thị ở tiêu đề) --%>
                    <c:if test="${empty idSanPhamFilter}">
                    <th>Tên SP Cha</th>
                    </c:if>
                    <th>Màu Sắc</th>
                    <th>RAM</th>
                    <th>Ổ Cứng</th>
                    <th>Giá Bán</th>
                    <th>Tồn Kho</th>
                    <th class="text-center" style="width: 120px;">Thao Tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listChiTiet}" var="ct" varStatus="stt">
                    <tr>
                        <td class="text-muted fw-semibold">${stt.index + 1}</td>
                        <c:if test="${empty idSanPhamFilter}">
                        <td class="fw-bold text-dark">${ct.sanPham.tenSanPham}</td>
                        </c:if>
                        <td><span class="badge border text-dark bg-light px-2 py-1"><i class="fa-solid fa-circle me-1 text-secondary" style="font-size:8px;"></i>${ct.cauHinhSanPham.mauSac.tenMauSac}</span></td>
                        <td class="fw-medium">${ct.cauHinhSanPham.ram.dungLuongRam}</td>
                        <td class="fw-medium">${ct.cauHinhSanPham.OCung.dungLuongOCung}</td>
                        <td class="text-success fw-bold"><fmt:formatNumber value="${ct.donGia}" type="currency" currencySymbol="₫"/></td>
                        <td><span class="badge bg-success px-2 py-1">${ct.tonKho}</span></td>

                        <!-- Thao tác -->
                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-3 align-items-center">
                                <a href="${pageContext.request.contextPath}/san-pham-chi-tiet/detail?id=${ct.id}" title="Xem chi tiết biến thể & IMEI" class="action-icon-btn">
                                    <i class="fa-regular fa-eye fs-5"></i>
                                </a>
                                <c:if test="${not isNhanVien}">
                                <form action="${pageContext.request.contextPath}/san-pham-chi-tiet/xoa" method="POST" id="formDelete-${ct.id}" style="margin:0;">
                                    <input type="hidden" name="id" value="${ct.id}">
                                    <i class="fa-regular fa-trash-can fs-5 action-icon-btn text-danger" title="Xóa bản ghi này"
                                       onclick="if(confirm('Bạn có chắc chắn muốn xóa bản ghi này không?')) document.getElementById('formDelete-${ct.id}').submit();">
                                    </i>
                                </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listChiTiet}">
                    <tr><td colspan="${not empty idSanPhamFilter ? '7' : '8'}" class="text-center py-5 text-muted">Kho hàng biến thể trống!</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- POPUP MODAL XEM CHI TIẾT (AJAX) -->
<div class="modal fade" id="detailSkuyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 12px;">
            <div class="modal-header border-0 pt-4 px-4 pb-2">
                <h5 class="modal-title fw-bold text-dark" style="font-size: 16px;">
                    <i class="fa-solid fa-circle-info text-dark me-2"></i>Chi tiết cấu hình biến thể
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 pb-4">
                <div class="row g-4">
                    <div class="col-md-7">
                        <div class="p-3 bg-light rounded-3 h-100 border">
                            <h6 class="fw-bold text-dark mb-3 small"><i class="fa-solid fa-microchip me-2 text-primary"></i>THÔNG SỐ KỸ THUẬT</h6>
                            <table class="table table-sm table-borderless mb-0" style="font-size: 13px;">
                                <tr><td class="text-muted py-1.5" style="width: 130px;">Tên sản phẩm:</td><td class="fw-semibold text-dark py-1.5" id="lblDetTen">...</td></tr>
                                <tr><td class="text-muted py-1.5">Mã SKU:</td><td class="fw-bold text-danger py-1.5" id="lblDetSku">...</td></tr>
                                <tr><td class="text-muted py-1.5">Bộ vi xử lý (CPU):</td><td class="text-dark py-1.5" id="lblDetCpu">...</td></tr>
                                <tr><td class="text-muted py-1.5">Bộ nhớ RAM:</td><td class="text-dark py-1.5" id="lblDetRam">...</td></tr>
                                <tr><td class="text-muted py-1.5">Ổ cứng SSD:</td><td class="text-dark py-1.5" id="lblDetOcung">...</td></tr>
                                <tr><td class="text-muted py-1.5">Card đồ họa (GPU):</td><td class="text-dark py-1.5" id="lblDetGpu">...</td></tr>
                                <tr><td class="text-muted py-1.5">Màn hình:</td><td class="text-dark py-1.5" id="lblDetManHinh">...</td></tr>
                                <tr><td class="text-muted py-1.5">Màu sắc:</td><td class="text-dark py-1.5" id="lblDetMau">...</td></tr>
                                <tr><td class="text-muted py-1.5">Giá bán niêm yết:</td><td class="fw-bold text-success py-1.5" id="lblDetGia">...</td></tr>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="p-3 bg-light rounded-3 h-100 border d-flex flex-column">
                            <h6 class="fw-bold text-dark mb-2 small"><i class="fa-solid fa-barcode me-2 text-success"></i>DANH SÁCH IMEI TỒN KHO</h6>
                            <small class="text-muted mb-2 d-block">Tổng số máy trong kho: <span class="fw-bold text-dark" id="lblDetTotalImei">0</span></small>
                            <div class="flex-grow-1 overflow-y-auto pe-1" id="boxDetImeiList" style="max-height: 240px;"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 px-4 pb-4 pt-0">
                <button type="button" class="btn btn-secondary px-4 btn-sm py-2" data-bs-dismiss="modal" style="border-radius:6px;">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        setTimeout(function() {
            let alertNode = document.querySelector('.toast-notification');
            if (alertNode) {
                let bsAlert = new bootstrap.Alert(alertNode);
                bsAlert.close();
            }
        }, 3000);
    });

    function moPopupXemChiTiet(idChiTiet) {
        $.ajax({
            url: "${pageContext.request.contextPath}/san-pham-chi-tiet/detail-json",
            type: "GET",
            data: { id: idChiTiet },
            success: function(res) {
                if (res.status === "success") {
                    $("#lblDetTen").text(res.tenSanPham || "N/A");
                    $("#lblDetSku").text("#" + (res.maSku || "N/A"));
                    $("#lblDetCpu").text(res.tenCpu || "N/A");
                    $("#lblDetRam").text(res.dungLuongRam || "N/A");
                    $("#lblDetOcung").text(res.dungLuongOCung || "N/A");
                    $("#lblDetGpu").text(res.tenGpu || "N/A");
                    $("#lblDetManHinh").text(res.tenManHinh || "N/A");
                    $("#lblDetMau").text(res.tenMauSac || "N/A");

                    if (res.giaBan) {
                        $("#lblDetGia").text(res.giaBan.toLocaleString('vi-VN') + " ₫");
                    } else {
                        $("#lblDetGia").text("0 ₫");
                    }

                    let countImei = res.listImei ? res.listImei.length : 0;
                    $("#lblDetTotalImei").text(countImei);

                    let htmlImei = "";
                    if (res.listImei && countImei > 0) {
                        res.listImei.forEach(function(item) {
                            htmlImei += '<div class="p-2 bg-white border rounded mb-1 font-monospace small d-flex justify-content-between align-items-center" style="border-radius: 6px;">' +
                                '<span><i class="fa-solid fa-laptop text-muted me-2"></i>' + item.soSeri + '</span>' +
                                '<span class="badge bg-success-subtle text-success border border-success-subtle px-1.5 py-0.5" style="font-size:10px;">Trong kho</span>' +
                                '</div>';
                        });
                    } else {
                        htmlImei = '<div class="text-center text-muted small py-4">Biến thể cấu hình này hiện tại đã hết hàng!</div>';
                    }
                    $("#boxDetImeiList").html(htmlImei);

                    const modalEl = document.getElementById('detailSkuyModal');
                    bootstrap.Modal.getOrCreateInstance(modalEl).show();
                } else {
                    alert("Lỗi từ hệ thống: " + res.message);
                }
            },
            error: function(xhr) {
                alert("Không thể tải dữ liệu chi tiết, vui lòng kiểm tra lại đường dẫn API mapping ở Servlet!");
            }
        });
    }

    /* ======= PRICE RANGE SLIDER – BIẾN THỂ ======= */
    (function () {
        var absMin = ${priceAbsMin != null ? priceAbsMin : 0};
        var absMax = ${priceAbsMax != null ? priceAbsMax : 0};
        var curMax = ${oldGiaMax  != null ? oldGiaMax  : (priceAbsMax != null ? priceAbsMax : 0)};

        function fmt(v) { return Number(v).toLocaleString('vi-VN') + ' ₫'; }

        function initSlider(sliderId, fillId, lblMaxId, lblRightId) {
            var sliderMax = document.getElementById(sliderId);
            var fill      = document.getElementById(fillId);
            var lblMax    = document.getElementById(lblMaxId);
            var lblRight  = document.getElementById(lblRightId);
            if (!sliderMax) return;
            sliderMax.min   = absMin;
            sliderMax.max   = absMax;
            sliderMax.value = curMax;
            function update() {
                var val = parseInt(sliderMax.value);
                var pct = absMax > absMin ? ((val - absMin) / (absMax - absMin)) * 100 : 100;
                fill.style.left  = '0%';
                fill.style.width = pct + '%';
                if (lblMax)   lblMax.textContent   = fmt(val);
                if (lblRight) lblRight.textContent = fmt(absMax);
            }
            sliderMax.addEventListener('input', update);
            update();
        }

        // Trang danh sách tất cả biến thể
        initSlider('sliderMaxCT',       'sliderFillCT',       'lblGiaMaxCT',       'lblRightCT');
        // Trang biến thể của 1 SP cụ thể
        initSlider('sliderMaxSPFilter', 'sliderFillSPFilter', 'lblGiaMaxSPFilter', 'lblRightSPFilter');
    })();
</script>
</body>
</html>