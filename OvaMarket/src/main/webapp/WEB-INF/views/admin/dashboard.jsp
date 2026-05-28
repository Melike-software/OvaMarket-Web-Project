<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Yönetici Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { height: 100vh; background-color: #212529; color: white; position: fixed; width: 240px; }
        .main-content { margin-left: 240px; padding: 30px; }
        .sidebar a { color: #adb5bd; text-decoration: none; display: block; padding: 15px 20px; }
        .sidebar a:hover, .sidebar a.active { background-color: #343a40; color: white; border-left: 4px solid #198754; }
        .stat-card { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="p-3 text-center bg-success">
        <h4 class="fw-bold m-0 text-white">🌿 Ova Yönetim</h4>
    </div>
    <div class="p-3 border-bottom border-secondary text-center">
        <small class="text-muted">Yönetici:</small>
        <div class="fw-bold text-white">${sessionScope.user.fullName}</div>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">📊 Panel Özet</a>
    <a href="${pageContext.request.contextPath}/admin/products">📦 Ürün Yönetimi</a>
    <a href="${pageContext.request.contextPath}/home">🌐 Mağazaya Git</a>
    <a href="${pageContext.request.contextPath}/admin/categories">🗂️ Kategori Yönetimi</a>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-dark">📊 Yönetim Paneli Özeti</h2>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-danger btn-smfw-bold">Mağazaya Dön</a>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card stat-card bg-white p-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-muted text-uppercase fw-semibold">Toplam Ürün</h6>
                        <h2 class="fw-bold text-success m-0">${totalProducts} adet</h2>
                    </div>
                    <span class="fs-1">📦</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-white p-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-muted text-uppercase fw-semibold">Gelen Sipariş</h6>
                        <h2 class="fw-bold text-primary m-0">${totalOrders} adet</h2>
                    </div>
                    <span class="fs-1">📜</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card bg-white p-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <h6 class="text-muted text-uppercase fw-semibold">Toplam Ciro</h6>
                        <h2 class="fw-bold text-warning m-0"><fmt:formatNumber value="${totalEarnings}" type="currency" currencySymbol="TL"/></h2>
                    </div>
                    <span class="fs-1">💰</span>
                </div>
            </div>
        </div>
    </div>

    <div class="card stat-card mt-5 p-4 bg-white">
        <h4 class="fw-bold text-success mb-3">🌿 Sistem Durumu Raporu</h4>
        <p class="text-secondary m-0">Ova Market e-ticaret altyapısı Java MVC ve JSTL standartlarına tam uyumlu olarak çalışmaktadır. Kullanıcıların sepete eklediği ve satın aldığı tüm siparişler, stok düşüm mantığıyla birlikte veritabanı üzerinden anlık olarak bu panele yansımaktadır.</p>
    </div>
</div>

</body>
</html>