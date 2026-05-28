package com.ovamarket.dao;

import com.ovamarket.model.Category;
import com.ovamarket.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    // Tüm Aktif Kategorileri Getirir
    public List<Category> getAllActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories WHERE is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_active")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            System.out.println("Kategoriler çekilirken hata: " + e.getMessage());
        }
        return categories;
    }
}