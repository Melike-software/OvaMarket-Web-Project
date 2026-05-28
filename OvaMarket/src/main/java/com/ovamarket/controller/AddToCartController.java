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
import com.ovamarket.model.CartItem;
import com.ovamarket.util.DBConnection;

@WebServlet("/addToCart")
public class AddToCartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        HttpSession session = request.getSession();
        
        // Session'da sepet listesi var mı bakıyoruz.
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Ürün zaten sepette var mı kontrolü 
        boolean isExist = false;
        for (CartItem item : cart) {
            if (item.getProductId() == productId) {
                // Stok sınırını aşmıyorsa adet artır 
                if (item.getQuantity() < item.getMaxStock()) {
                    item.setQuantity(item.getQuantity() + 1);
                }
                isExist = true;
                break;
            }
        }

        // Ürün sepette yoksa veritabanından bilgilerini çekip ekliyoruz
        if (!isExist) {
            String query = "SELECT id, name, price, stock, image_url FROM products WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query)) {
                
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        CartItem newItem = new CartItem();
                        newItem.setProductId(rs.getInt("id"));
                        newItem.setName(rs.getString("name"));
                        newItem.setPrice(rs.getDouble("price"));
                        newItem.setMaxStock(rs.getInt("stock"));
                        newItem.setImageUrl(rs.getString("image_url"));
                        newItem.setQuantity(1);
                        cart.add(newItem);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Sepeti ve toplam ürün adedini session'a geri yazıyoruz
        session.setAttribute("cart", cart);
        session.setAttribute("cartQuantity", cart.size());

        // Kullanıcıyı ana sayfaya geri gönderiyoruz.
        response.sendRedirect(request.getContextPath() + "/home");
    }
}