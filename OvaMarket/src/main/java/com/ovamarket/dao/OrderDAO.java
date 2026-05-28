package com.ovamarket.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import com.ovamarket.model.CartItem;
import com.ovamarket.util.DBConnection;

public class OrderDAO {

    // Siparişi ve sepet altındaki tüm ürünleri veritabanına tek seferde kaydeder 
    public boolean createOrder(int userId, double totalAmount, String address, List<CartItem> cartItems) {
        String orderQuery = "INSERT INTO orders (user_id, total_amount, shipping_address, status) VALUES (?, ?, ?, 'PENDING')";
        String itemQuery = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String updateStockQuery = "UPDATE products SET stock = stock - ? WHERE id = ?";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        PreparedStatement psStock = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); //  Hepsi yüklensin ya da hata varsa geri alınsın 

            // Ana Siparişi Oluşturuyoruz
            psOrder = conn.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, totalAmount);
            psOrder.setString(3, address);
            
            int affectedRows = psOrder.executeUpdate();
            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }

            // Yeni oluşan siparişin ID'sinı alıyoruz
            int orderId = 0;
            try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                }
            }

            //Sepetteki Ürünleri order_items Tablosuna Tek Tek Dönüyoruz ve Stok Düşüyoruz 
            psItem = conn.prepareStatement(itemQuery);
            psStock = conn.prepareStatement(updateStockQuery);

            for (CartItem item : cartItems) {
                // HATA ALAN YERLER
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getProductId()); 
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getPrice()); 
                psItem.addBatch();

                // Stok güncelleme parametreleri
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getProductId());
                psStock.addBatch();
            }

            // Batch olarak
            psItem.executeBatch();
            psStock.executeBatch();

            conn.commit(); // Her şey başarılıysa veritabanına kalıcı yaz
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Bir yerde hata çıktıysa yapılan tüm işlemleri geri al!
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // Bağlantıları güvenli kapatıyoruz 
            try {
                if (psOrder != null) psOrder.close();
                if (psItem != null) psItem.close();
                if (psStock != null) psStock.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}