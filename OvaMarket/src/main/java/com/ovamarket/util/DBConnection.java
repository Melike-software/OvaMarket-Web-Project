package com.ovamarket.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // ovamarket_db
    private static final String URL = "jdbc:mysql://localhost:3306/ovamarket_db?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
    private static final String USERNAME = "root"; 
    private static final String PASSWORD = "root123";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Veritabanı bağlantısı
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Sürücüsü bulunamadı: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Veritabanına bağlanırken hata oluştu: " + e.getMessage());
        }
        return connection;
    }
}