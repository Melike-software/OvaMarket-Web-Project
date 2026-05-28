package com.ovamarket.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.ovamarket.model.user; // Burayı küçük user yaptık kanka!
import com.ovamarket.util.DBConnection;

public class UserDAO {

    // Kullanıcı Giriş Kontrolü
    public user login(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user usr = new user(); // Küçük user sınıfından nesne üretiyoruz
                    usr.setId(rs.getInt("id"));
                    usr.setFullName(rs.getString("full_name"));
                    usr.setEmail(rs.getString("email"));
                    usr.setRole(rs.getString("role"));
                    usr.setPhone(rs.getString("phone"));
                    usr.setAddress(rs.getString("address"));
                    return usr;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Yeni Kullanıcı Kaydı 
    public boolean register(user usr) {
        String query = "INSERT INTO users (full_name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, 'CUSTOMER')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, usr.getFullName());
            ps.setString(2, usr.getEmail());
            ps.setString(3, usr.getPassword());
            ps.setString(4, usr.getPhone());
            ps.setString(5, usr.getAddress());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // E-posta  kayıt kontrolü 
    public boolean isEmailExists(String email) {
        String query = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}