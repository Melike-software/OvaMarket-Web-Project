package com.ovamarket.dao;

import com.ovamarket.model.Product;
import com.ovamarket.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Tüm Aktif Ürünleri Listeleme (Ana Sayfa İçin)
    public List<Product> getAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock"),
                    rs.getString("image_url"),
                    rs.getBoolean("is_active")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Ürün listesi çekilirken hata: " + e.getMessage());
        }
        return products;
    }

    // Kategoriye Göre Filtreleme 
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category_id = ? AND is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.out.println("Kategoriye göre ürün çekilirken hata: " + e.getMessage());
        }
        return products;
    }
 // ID'ye Göre Tek Bir Ürün Getirme (Sepet İşlemleri İçin)
    public Product getProductById(int productId) {
        String query = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"), 
                        rs.getInt("stock"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("ID ile ürün çekilirken hata: " + e.getMessage());
        }
        return null;
    }
}