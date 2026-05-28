package com.ovamarket.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.ovamarket.model.CartItem;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        String action = request.getParameter("action");
        String pIdStr = request.getParameter("productId");

        // Eğer adet artırma, azaltma veya silme eylemi geldiyse
        if (action != null && pIdStr != null) {
            int productId = Integer.parseInt(pIdStr);
            if (cart != null) {
                for (int i = 0; i < cart.size(); i++) {
                    CartItem item = cart.get(i);
                    if (item.getProductId() == productId) {
                        if ("increase".equals(action)) {
                            if (item.getQuantity() < item.getMaxStock()) {
                                item.setQuantity(item.getQuantity() + 1);
                            }
                        } else if ("decrease".equals(action)) {
                            if (item.getQuantity() > 1) {
                                item.setQuantity(item.getQuantity() - 1);
                            } else {
                                cart.remove(i); 
                            }
                        } else if ("remove".equals(action)) {
                            cart.remove(i); 
                        }
                        break;
                    }
                }
            }
        }

        // Genel sepet toplam tutarını hesaplama 
        double grandTotal = 0;
        if (cart != null) {
            for (CartItem item : cart) {
                grandTotal += item.getTotalPrice();
            }
        }

        session.setAttribute("cart", cart);
        session.setAttribute("cartQuantity", cart != null ? cart.size() : 0);
        request.setAttribute("grandTotal", grandTotal);

        // Sepet JSP dosyasına yönlendiriyoruz
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }
}