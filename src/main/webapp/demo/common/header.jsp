<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="demo.entity.nhan_vien.NhanVien" %>
<%
    NhanVien nvHeader = (NhanVien) session.getAttribute("nhanVien");
    String tenNhanVien = (nvHeader != null) ? nvHeader.getHoTen() : "Quản trị viên";
    String chucVu = (nvHeader != null) ? nvHeader.getChucVu() : "Admin";
%>
<header class="app-header">
    <div class="header-left">
        <span class="text-secondary fw-semibold" style="font-size: 14px;">
            <i class="fa-solid fa-house-chimney me-2"></i>Hệ thống quản lý máy tính Skycomputer
        </span>
    </div>
    <div class="header-right">
        <div class="user-profile-badge">
            <div class="user-avatar">
                <i class="fa-solid fa-user-tie"></i>
            </div>
            <div class="user-info">
                <span class="user-name"><%= tenNhanVien %></span>
                <span class="user-role"><%= chucVu %></span>
            </div>
</header>

<style>
    .app-header {
        height: 64px;
        background-color: #ffffff;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        align-items: center;
        justify-content: space-between; /* 🟢 Đẩy 2 đầu sang trái và phải */
        padding: 0 32px;
        flex-shrink: 0;
    }
    .header-right {
        display: flex;
        align-items: center;
        gap: 16px;
    }
    .user-profile-badge {
        display: flex;
        align-items: center;
        gap: 10px;
        background: #f8fafc;
        padding: 6px 12px;
        border-radius: 8px;
        border: 1px solid var(--border-color);
    }
    .user-avatar {
        width: 32px;
        height: 32px;
        background-color: var(--primary-light);
        color: var(--primary);
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-size: 14px;
    }
    .user-info {
        display: flex;
        flex-direction: column;
        text-align: left;
    }
    .user-name {
        font-size: 13px;
        font-weight: 700;
        color: var(--text-main);
        line-height: 1.2;
    }
    .user-role {
        font-size: 11px;
        color: var(--text-muted);
    }
    .btn-logout-icon {
        width: 36px;
        height: 36px;
        background-color: #fef2f2;
        color: #dc2626;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 8px;
        text-decoration: none;
        transition: all 0.2s;
    }
    .btn-logout-icon:hover {
        background-color: #dc2626;
        color: #ffffff;
    }
</style>