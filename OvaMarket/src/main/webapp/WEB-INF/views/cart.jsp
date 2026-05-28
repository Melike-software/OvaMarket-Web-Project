<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Sepetim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .cart-card { border: none; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">🌿 OVA MARKET</a>
        <div class="ms-auto">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm fw-bold">🛒 Alışverişe Devam Et</a>
        </div>
    </div>
</nav>

<div class="container my-5">
    <h2 class="fw-bold text-success mb-4">🛒 Alışveriş Sepetiniz</h2>

    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty cart}">
                <div class="col-lg-8">
                    <div class="card cart-card p-3">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Ürün</th>
                                        <th>Adet</th>
                                        <th>Fiyat</th>
                                        <th>Toplam</th>
                                        <th>Aksiyon</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cart}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${item.imageUrl}" class="product-img" onerror="this.src='${pageContext.request.contextPath}/images/gofret.png'">
                                                    <span class="fw-semibold">${item.name}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <a href="${pageContext.request.contextPath}/cart?action=decrease&productId=${item.productId}" class="btn btn-sm btn-outline-secondary py-0 px-2 fw-bold">-</a>
                                                    <span class="fw-bold px-1">${item.quantity}</span>
                                                    <a href="${pageContext.request.contextPath}/cart?action=increase&productId=${item.productId}" class="btn btn-sm btn-outline-secondary py-0 px-2 fw-bold">+</a>
                                                </div>
                                            </td>
                                            <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="TL"/></td>
                                            <td class="fw-bold text-success"><fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="TL"/></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/cart?action=remove&productId=${item.productId}" class="btn btn-sm btn-outline-danger">🗑️ Sil</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card cart-card p-4 bg-white">
                        <h4 class="fw-bold text-dark mb-3">Sipariş Özeti</h4>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="fs-5 text-muted">Genel Toplam:</span>
                            <span class="fs-4 fw-bold text-success"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="TL"/></span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/checkout" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-muted">Teslimat Adresi:</label>
                                <textarea name="address" class="form-control" rows="3" required>${sessionScope.user.address}</textarea>
                            </div>
                            <button type="submit" class="btn btn-success w-100 fw-bold py-3 shadow-sm text-uppercase">Siparişi Tamamla</button>
                        </form>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="col-12 text-center py-5">
                    <div class="card cart-card p-5">
                        <h3 class="text-muted mb-3">Sepetinizde henüz ürün bulunmuyor.</h3>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-success btn-lg fw-bold shadow-sm px-4">🌿 Alışverişe Başla</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>