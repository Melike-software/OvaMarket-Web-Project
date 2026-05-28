<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Kayıt Ol</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .register-container { max-width: 500px; margin-top: 60px; margin-bottom: 60px; }
    </style>
</head>
<body>

<div class="container register-container">
    <div class="card shadow border-0 rounded-3">
        <div class="card-body p-5">
            <h3 class="text-center fw-bold text-success mb-4">📝 Müşteri Kayıt Formu</h3>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center shadow-sm" role="alert">
                    ⚠️ ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Ad Soyad <span class="text-danger">*</span></label>
                    <input type="text" name="fullName" class="form-control" placeholder="Örn: Melike Yılmaz" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-semibold">E-posta Adresi <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control" placeholder="melike@gmail.com" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-semibold">Şifre <span class="text-danger">*</span></label>
                    <input type="password" name="password" class="form-control" placeholder="Şifreniz" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-semibold">Telefon Numarası</label>
                    <input type="tel" name="phone" class="form-control" placeholder="0555XXXXXXX">
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-semibold">Teslimat Adresi</label>
                    <textarea name="address" class="form-control" rows="3" placeholder="Siparişlerinizin ulaştırılacağı açık adresiniz..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-success w-100 fw-bold py-2 shadow-sm">Kayıt İşlemini Tamamla</button>
            </form>
            
            <div class="text-center mt-4">
                <p class="mb-0 text-muted">Zaten hesabınız var mı? <a href="${pageContext.request.contextPath}/login" class="text-success fw-bold text-decoration-none">Giriş Yapın</a></p>
                <a href="${pageContext.request.contextPath}/home" class="d-block mt-3 text-secondary text-decoration-none">← Ana Sayfaya Dön</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>