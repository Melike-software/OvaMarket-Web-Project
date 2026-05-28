package com.ovamarket.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.ovamarket.dao.UserDAO;
import com.ovamarket.model.user; // Senin küçük harfli model sınıfın kanka!

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Sunucu Tarafı Validasyon 
        if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Lütfen zorunlu alanları (*) boş bırakmayınız!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // E-posta Kontrolü 
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Bu e-posta adresi zaten sisteme kayıtlı!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        user newUser = new user(); // User modelimizden nesne oluşturduk
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setPhone(phone);
        newUser.setAddress(address);

        if (userDAO.register(newUser)) {
            request.setAttribute("successMessage", "Kayıt başarılı! Şimdi giriş yapabilirsiniz.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        
        } else {
            request.setAttribute("errorMessage", "Kayıt sırasında sistemsel bir hata oluştu!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}