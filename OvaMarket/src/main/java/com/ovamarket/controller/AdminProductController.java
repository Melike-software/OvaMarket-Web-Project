package com.ovamarket.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.ovamarket.model.Product;
import com.ovamarket.model.user;
import com.ovamarket.util.DBConnection;

@WebServlet("/admin/products")
public class AdminProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        user usr = (user) session.getAttribute("user");

        if (usr == null || !"ADMIN".equals(usr.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?errorMessage=Yetkisiz%20erisim!");
            return;
        }

        List<Product> productList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM products ORDER BY id ASC");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setImageUrl(rs.getString("image_url"));
                productList.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("successMessage", request.getParameter("successMessage"));
        request.setAttribute("errorMessage", request.getParameter("errorMessage"));
        
        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        user usr = (user) session.getAttribute("user");

        if (usr == null || !"ADMIN".equals(usr.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String imageUrl = request.getParameter("imageUrl");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty() || priceStr == null || stockStr == null || categoryIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?errorMessage=Lutfen%20zorunlu%20alanlari%20bos%20birakmayiniz!");
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);
            int categoryId = Integer.parseInt(categoryIdStr);

            if (price <= 0) { 
                response.sendRedirect(request.getContextPath() + "/admin/products?errorMessage=Fiyat%20sifirdan%20buyuk%20olmalidir!");
                return;
            }
            if (stock < 0) { 
                response.sendRedirect(request.getContextPath() + "/admin/products?errorMessage=Stok%20miktari%20negatif%20olamaz!");
                return;
            }

            if ("update".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                         "UPDATE products SET category_id = ?, name = ?, description = ?, price = ?, stock = ?, image_url = ? WHERE id = ?")) {
                    
                    ps.setInt(1, categoryId);
                    ps.setString(2, name);
                    ps.setString(3, description);
                    ps.setDouble(4, price);
                    ps.setInt(5, stock);
                    ps.setString(6, imageUrl);
                    ps.setInt(7, productId);
                    
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/admin/products?successMessage=Ürün%20başarıyla%20güncellendi.");
                return;
            } 
            
            else {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, TRUE)")) {
                    
                    ps.setInt(1, categoryId);
                    ps.setString(2, name);
                    ps.setString(3, description);
                    ps.setDouble(4, price);
                    ps.setInt(5, stock);
                    ps.setString(6, imageUrl);
                    
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/admin/products?successMessage=Yeni%20urun%20basariyla%20envantere%20eklendi.");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?errorMessage=Sistemsel%20bir%20hata%20meydana%20geldi!");
        }
    }
}