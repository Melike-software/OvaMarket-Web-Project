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
import com.ovamarket.model.user;
import com.ovamarket.util.DBConnection;

@WebServlet("/admin/categories")
public class AdminCategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        user usr = (user) session.getAttribute("user");

        if (usr == null || !"ADMIN".equals(usr.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?errorMessage=Yetkisiz%20erisim!");
            return;
        }

        List<String[]> categoryList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM categories ORDER BY id ASC");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                String[] category = new String[3];
                category[0] = String.valueOf(rs.getInt("id"));
                category[1] = rs.getString("name");
                category[2] = rs.getString("description");
                categoryList.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("successMessage", request.getParameter("successMessage"));
        request.setAttribute("errorMessage", request.getParameter("errorMessage"));
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
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
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?errorMessage=Lutfen%20kategori%20adini%20bos%20birakmayiniz!");
            return;
        }

        try {
            if ("update".equals(action)) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("UPDATE categories SET name = ?, description = ? WHERE id = ?")) {
                    
                    ps.setString(1, name);
                    ps.setString(2, description);
                    ps.setInt(3, categoryId);
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories?successMessage=Kategori%20basariyla%20guncellendi.");
                return;
            } 
            else {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)")) {
                    
                    ps.setString(1, name);
                    ps.setString(2, description);
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories?successMessage=Kategori%20basariyla%20eklendi.");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?errorMessage=Sistemsel%20bir%20hata%20meydana%20geldi!");
        }
    }
}