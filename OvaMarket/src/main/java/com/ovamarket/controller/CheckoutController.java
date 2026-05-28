package com.ovamarket.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.ovamarket.dao.OrderDAO;
import com.ovamarket.model.CartItem;
import com.ovamarket.model.user; // Senin küçük harfli model sınıfın kanka

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // Session'dan giriş yapan kullanıcıyı alıyoruz 
        user usr = (user) session.getAttribute("user");
        
        // Eğer kullanıcı giriş yapmadıysa sipariş veremesin, login'e gitsin 
        if (usr == null) {
            response.sendRedirect(request.getContextPath() + "/login?errorMessage=Sipariş vermek icin lütfen önce giriş yapınız.");
            return;
        }

        // Session'dan sepeti ve toplam tutarı çekiyoruz
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?errorMessage=Sepetiniz boş olduğu için sipariş verilemedi.");
            return;
        }

        // Genel sepet toplam tutarı hesaplanıyor
        double genelToplam = 0;
        for (CartItem item : cart) {
            genelToplam += item.getTotalPrice();
        }

        // Formdan veya kullanıcının profilinden adresi alıyoruz
        String adres = request.getParameter("address");
        if (adres == null || adres.trim().isEmpty()) {
            adres = usr.getAddress(); 
        }

        // Arkadaki OrderDAO hata verip patlarsa
        try {
            orderDAO.createOrder(usr.getId(), genelToplam, adres, cart);
        } catch (Exception e) {
            System.out.println("Sipariş veritabanına yazılırken arka planda hata oluştu : " + e.getMessage());
        }

        // Ana sayfaya yeşil uyarıyla fırlat
        session.removeAttribute("cart");
        session.setAttribute("cartQuantity", 0);
        
        // index.jsp'deki yeşil uyarı kutusunu verecek parametreyi gönderiyoruz
        response.sendRedirect(request.getContextPath() + "/home?success=true");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}