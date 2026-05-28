<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ova Market - Giriş Yap</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; flex-direction: column; }
        .login-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #2e7d32; margin-top: 0; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; color: #333; font-weight: bold; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-login { width: 100%; padding: 10px; background-color: #2e7d32; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; font-weight: bold; }
        .btn-login:hover { background-color: #1b5e20; }
        .error-msg { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 10px; border-radius: 4px; text-align: center; margin-bottom: 15px; font-size: 14px; }
        .success-msg { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; padding: 10px; border-radius: 4px; text-align: center; margin-bottom: 15px; font-size: 14px; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #666; }
        .footer-links a { color: #2e7d32; text-decoration: none; font-weight: bold; }
        .footer-links a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="login-container">
    <h2>🌿 Ova Market Giriş</h2>
    
    <%-- HOCANIN İSTEDİĞİ JSTL HATA MESAJI KONTROLÜ --%>
    <c:if test="${not empty errorMessage}">
        <div class="error-msg">⚠️ ${errorMessage}</div>
    </c:if>
    
    <%-- MELİKE KAYIT OLUNCA ÇIKACAK YEŞİL BAŞARI KUTUSU --%>
    <c:if test="${not empty param.successMessage}">
        <div class="success-msg">✅ ${param.successMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label>E-posta Adresi:</label>
            <input type="email" name="email" required placeholder="melike@gmail.com">
        </div>
        <div class="form-group">
            <label>Şifre:</label>
            <input type="password" name="password" required placeholder="••••••••">
        </div>
        <button type="submit" class="btn-login">Giriş Yap</button>
    </form>
    
    <%-- YENİ ÜYE OLMA LİNKİ  --%>
    <div class="footer-links">
        Hesabınız yok mu? <a href="${pageContext.request.contextPath}/register">Hemen Kayıt Olun</a>
        <br><br>
        <a href="${pageContext.request.contextPath}/home" style="color: #666; font-weight: normal;">← Ana Sayfaya Dön</a>
    </div>
</div>

</body>
</html>