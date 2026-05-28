<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Kategori Yönetimi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { height: 100vh; background-color: #212529; color: white; position: fixed; width: 240px; }
        .main-content { margin-left: 240px; padding: 30px; }
        .sidebar a { color: #adb5bd; text-decoration: none; display: block; padding: 15px 20px; }
        .sidebar a:hover, .sidebar a.active { background-color: #343a40; color: white; border-left: 4px solid #198754; }
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
    <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Panel Özet</a>
    <a href="${pageContext.request.contextPath}/admin/products">📦 Ürün Yönetimi</a>
    <a href="${pageContext.request.contextPath}/admin/categories" class="active">🗂️ Kategori Yönetimi</a>
    <a href="${pageContext.request.contextPath}/home">🌐 Mağazaya Git</a>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-dark">🗂️ Kategori Listesi ve Yönetimi</h2>
        <button class="btn btn-success fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">➕ Yeni Kategori Ekle</button>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success shadow-sm">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger shadow-sm">${errorMessage}</div>
    </c:if>

    <div class="card border-0 shadow-sm p-3">
        <table class="table table-hover align-middle m-0">
            <thead class="table-dark">
                <tr>
                    <th>Kategori ID</th>
                    <th>Kategori Adı</th>
                    <th>Açıklama</th>
                    <th>Durum</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="cat" items="${categoryList}">
                    <tr>
                        <td class="fw-bold text-secondary">#${cat[0]}</td>
                        <td class="fw-semibold text-dark">${cat[1]}</td>
                        <td class="text-muted">${cat[2]}</td>
                        <td>
                            <span class="badge bg-success p-2">Aktif</span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/admin/categories" method="post" class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold">➕ Yeni Kategori Ekle</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-close="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary">Kategori Adı *</label>
                    <input type="text" name="name" class="form-control" required placeholder="Örn: Temizlik Ürünleri">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary">Açıklama</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Kategori kapsamı hakkında kısa bilgi..."></textarea>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary" data-bs-close="modal">Kapat</button>
                <button type="submit" class="btn btn-success fw-bold">🗂️ Kategoriyi Ekle</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>