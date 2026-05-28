package com.ovamarket.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.ovamarket.model.user; // Senin küçük harfli model sınıfın
import com.ovamarket.util.DBConnection;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        user usr = (user) session.getAttribute("user");

        // GÜVENLİK KONTROLÜ: Giriş yapmayan veya rolü ADMIN olmayan kişi giremez.
        if (usr == null || !"ADMIN".equals(usr.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?errorMessage=Bu alana sadece yöneticiler erişebilir!");
            return;
        }

        // istatistik verilerini veritabanından çekiyoruz
        int totalProducts = 0;
        int totalOrders = 0;
        double totalEarnings = 0.0;

        try (Connection conn = DBConnection.getConnection()) {
            // Toplam Ürün Sayısı
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM products");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalProducts = rs.getInt(1);
            }
            // Toplam Sipariş Sayısı
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalOrders = rs.getInt(1);
            }
            // Toplam Ciro 
            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(total_amount) FROM orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalEarnings = rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalEarnings", totalEarnings);

        // Yönetici paneli 
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}