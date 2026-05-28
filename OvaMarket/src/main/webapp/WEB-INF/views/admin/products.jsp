<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Ürün Yönetimi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; }
        .sidebar { height: 100vh; background-color: #212529; color: white; position: fixed; width: 240px; }
        .main-content { margin-left: 240px; padding: 30px; }
        .sidebar a { color: #adb5bd; text-decoration: none; display: block; padding: 15px 20px; }
        .sidebar a:hover, .sidebar a.active { background-color: #343a40; color: white; border-left: 4px solid #198754; }
        .product-img-preview { width: 50px; height: 50px; object-fit: cover; border-radius: 5px; }
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
    <a href="${pageContext.request.contextPath}/admin/products" class="active">📦 Ürün Yönetimi</a>
    <a href="${pageContext.request.contextPath}/admin/categories">🗂️ Kategori Yönetimi</a>
    <a href="${pageContext.request.contextPath}/home">🌐 Mağazaya Git</a>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-dark">📦 Ürün Listesi ve Yönetimi</h2>
        <button class="btn btn-success fw-bold shadow-sm" onclick="openAddModal()">➕ Yeni Ürün Ekle</button>
    </div>

    <div class="card border-0 shadow-sm p-3 mb-3 bg-white">
        <div class="input-group">
            <span class="input-group-text bg-success text-white fw-bold">🔍 Ürün Ara</span>
            <input type="text" id="productSearchInput" class="form-control" onkeyup="searchProducts()" placeholder="Aradığınız ürünün adını yazın (Örn: Salatalık, Gofret)...">
        </div>
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
                    <th>Görsel</th>
                    <th>Ürün Adı</th>
                    <th>Fiyat</th>
                    <th>Stok Miktarı</th>
                    <th>İşlem</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="prod" items="${productList}">
                    <tr>
                        <td>
                            <img src="${prod.imageUrl}" class="product-img-preview" onerror="this.src='https://placehold.co/100x100?text=Resim+Yok'">
                        </td>
                        <td class="fw-semibold text-secondary">${prod.name}</td>
                        <td class="fw-bold text-success">
                            <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="TL"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${prod.stock <= 5}">
                                    <span class="badge bg-danger p-2">Kritik Stok: ${prod.stock}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-primary p-2">Stok: ${prod.stock}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-warning fw-bold shadow-sm" 
                                    onclick="openEditModal('${prod.id}', '${prod.name}', '${prod.price}', '${prod.stock}', '${prod.imageUrl}')">
                                ⚙️ Düzenle
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty productList}">
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">Sistemde kayıtlı ürün bulunmuyor.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="productModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form id="productForm" action="${pageContext.request.contextPath}/admin/products" method="post" class="modal-content border-0 shadow-lg">
            
            <input type="hidden" name="action" id="formAction" value="insert">
            <input type="hidden" name="productId" id="formProductId" value="">

            <div class="modal-header bg-success text-white" id="modalHeader">
                <h5 class="modal-title fw-bold" id="modalTitle">➕ Yeni Ürün Ekle</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-close="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary">Ürün Adı *</label>
                    <input type="text" name="name" id="pName" class="form-control" required placeholder="Örn: Taze Amasya Elması">
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label fw-bold text-secondary">Fiyat (TL) *</label>
                        <input type="number" step="0.01" name="price" id="pPrice" class="form-control" required placeholder="45.00">
                    </div>
                    <div class="col">
                        <label class="form-label fw-bold text-secondary">Stok Adedi *</label>
                        <input type="number" name="stock" id="pStock" class="form-control" required placeholder="50">
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary">Kategori Seçimi *</label>
                    <select name="categoryId" id="pCategory" class="form-select" required>
                        <option value="1">Manav</option>
                        <option value="2">Süt Ürünleri</option>
                        <option value="3">Atıştırmalık</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary">Görsel URL Linki</label>
                    <input type="text" name="imageUrl" id="pImageUrl" class="form-control" placeholder="https://images.unsplash.com/...">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary">Açıklama</label>
                    <textarea name="description" id="pDescription" class="form-control" rows="3" placeholder="Ürün tazelik bilgisi..."></textarea>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary" data-bs-close="modal">Vazgeç</button>
                <button type="submit" class="btn btn-success fw-bold" id="submitBtn">📦 Ürünü Sisteme Ekle</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Ekleme butonuna basınca formu sıfırlayıp temiz açar
function openAddModal() {
    document.getElementById("formAction").value = "insert";
    document.getElementById("formProductId").value = "";
    document.getElementById("modalTitle").innerText = "➕ Yeni Ürün Ekle";
    document.getElementById("submitBtn").innerText = "📦 Ürünü Sisteme Ekle";
    document.getElementById("productForm").reset();
    
    var myModal = new bootstrap.Modal(document.getElementById('productModal'));
    myModal.show();
}

// ⚙️ Düzenle butonu
function openEditModal(id, name, price, stock, imageUrl) {
    document.getElementById("formAction").value = "update";
    document.getElementById("formProductId").value = id;
    document.getElementById("modalTitle").innerText = "⚙️ Ürünü Düzenle";
    document.getElementById("submitBtn").innerText = "💾 Değişiklikleri Kaydet";
    
    document.getElementById("pName").value = name;
    document.getElementById("pPrice").value = price;
    document.getElementById("pStock").value = stock;
    document.getElementById("pImageUrl").value = imageUrl;
    
    var myModal = new bootstrap.Modal(document.getElementById('productModal'));
    myModal.show();
}

// Tabloda Canlı Arama Yapan Fonksiyon
function searchProducts() {
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("productSearchInput");
    filter = input.value.toUpperCase();
    table = document.querySelector(".table");
    tr = table.getElementsByTagName("tr");

    for (i = 1; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td")[1]; 
        if (td) {
            txtValue = td.textContent || td.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }       
    }
}
</script>
</body>
</html>