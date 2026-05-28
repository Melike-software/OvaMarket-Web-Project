<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Hoş Geldiniz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-card { transition: transform 0.2s; }
        .product-card:hover { transform: scale(1.03); }
        .navbar-custom { background-color: #198754 !important; }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">🌿 OVA MARKET</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    
                    <%-- JSTL Kullanıcı Giriş Kontrolü --%>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <span class="text-white me-3">👋 Hoş geldin, <b class="text-warning">${sessionScope.user.fullName}</b></span>
                            </li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li class="nav-item me-2">
                                    <a class="btn btn-light btn-sm fw-bold text-success shadow-sm" href="${pageContext.request.contextPath}/admin/dashboard">Yönetim Paneli</a>
                                </li>
                            </c:if>
                            <li class="nav-item">
                                <a class="nav-link text-danger fw-bold bg-white rounded px-2 btn-sm shadow-sm" href="${pageContext.request.contextPath}/logout">Çıkış Yap</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link text-white fw-semibold" href="${pageContext.request.contextPath}/login">Giriş Yap / Kayıt Ol</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    
                    <%-- Dinamik Sepetim Butonu --%>
                    <li class="nav-item ms-3">
                        <a class="btn btn-warning fw-bold text-dark shadow-sm" href="${pageContext.request.contextPath}/cart">
                            🛒 Sepetim 
                            <span class="badge bg-danger">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.cartQuantity}">
                                        ${sessionScope.cartQuantity}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </span>
                        </a>
                    </li>
                    
                </ul>
            </div>
        </div>
    </nav>

    <%-- Sipariş başarıyla tamamlandıysa menünün hemen altında görünecek dinamik yeşil uyarı kutusu --%>
    <c:if test="${param.success eq 'true'}">
        <div class="container mb-3">
            <div class="alert alert-success alert-dismissible fade show text-center shadow-sm" role="alert">
                <strong>🌿 Siparişiniz Başarıyla Alınmıştır!</strong> Ova Market'i tercih ettiğiniz için teşekkür ederiz. En kısa sürede kapınızda!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>

    <div class="container">
        <div class="row">
            
            <div class="col-md-3 mb-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-dark text-white fw-bold">Kategoriler</div>
                    <ul class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/home" class="list-group-item list-group-item-action ${empty selectedCategory ? 'active bg-success border-success' : ''}">
                            🌱 Tüm Ürünler
                        </a>
                        <c:forEach var="cat" items="${categoryList}">
                            <a href="${pageContext.request.contextPath}/home?category=${cat.id}" 
                               class="list-group-item list-group-item-action ${selectedCategory == cat.id ? 'active bg-success border-success' : ''}">
                                 ${cat.name}
                            </a>
                        </c:forEach>
                    </ul>
                </div>
            </div>

            <div class="col-md-9">
                
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <h3 class="text-secondary fw-bold m-0">Taze ve Doğal Ürünlerimiz</h3>
                    
                    <div style="max-width: 350px; width: 100%;">
                        <div class="input-group shadow-sm border rounded">
                            <span class="input-group-text bg-white border-0 text-muted">🔍</span>
                            <input type="text" id="userProductSearch" class="form-control border-0 bg-white" onkeyup="filterUserProducts()" placeholder="Marketten ürün arayın...">
                        </div>
                    </div>
                </div>

                <div class="row" id="productsGridRow">
                    <c:choose>
                        <c:when test="${empty productList}">
                            <div class="col-12" id="noProductAlert">
                                <div class="alert alert-warning text-center shadow-sm">Bu kategoride henüz ürün bulunmamaktadır.</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="prod" items="${productList}">
                                <div class="col-md-4 mb-4 product-wrapper">
                                    <div class="card h-100 shadow-sm product-card border-0">
                                        <img src="${prod.imageUrl}" class="card-img-top rounded-top" alt="${prod.name}" style="height: 180px; object-fit: cover;">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title fw-bold text-dark">${prod.name}</h5>
                                            <p class="card-text text-muted small">${prod.description}</p>
                                            
                                            <div class="mt-auto">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <span class="fs-4 fw-bold text-success">${prod.price} TL</span>
                                                    <c:choose>
                                                        <c:when test="${prod.stock > 0}">
                                                            <span class="badge bg-info text-dark">Stok: ${prod.stock}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Tükendi</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <c:choose>
                                                    <c:when test="${prod.stock == 0}">
                                                        <button class="btn btn-outline-danger w-100 fw-bold" disabled>Stokta Yok</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/addToCart?productId=${prod.id}" class="btn btn-success w-100 fw-bold shadow-sm">Sepete Ekle</a>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="alert alert-danger text-center shadow-sm d-none" id="searchNotFoundAlert">
                    Aradığınız isimde bir ürün Ova Market envanterinde bulunamadı kanka! 🌾
                </div>

            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    function filterUserProducts() {
        var input = document.getElementById("userProductSearch");
        var filter = input.value.toUpperCase().trim();
        var wrappers = document.querySelectorAll(".product-wrapper");
        var visibleCount = 0;

        for (var i = 0; i < wrappers.length; i++) {
            var titleElement = wrappers[i].querySelector(".card-title");
            if (titleElement) {
                var txtValue = titleElement.textContent || titleElement.innerText;
                
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    wrappers[i].style.setProperty('display', '', 'important');
                    visibleCount++;
                } else {
                    wrappers[i].style.setProperty('display', 'none', 'important');
                }
            }
        }

        var notFoundAlert = document.getElementById("searchNotFoundAlert");
        if (notFoundAlert) {
            if (visibleCount === 0 && filter !== "") {
                notFoundAlert.classList.remove("d-none");
            } else {
                notFoundAlert.classList.add("d-none");
            }
        }
    }
    </script>
</body>
</html>