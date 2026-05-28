package com.ovamarket.controller;

import com.ovamarket.dao.CategoryDAO;
import com.ovamarket.dao.ProductDAO;
import com.ovamarket.model.Category;
import com.ovamarket.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// bu anatasyon sayesinde tarayıcıya "http://localhost:8080/OvaMarket/" veya 
// "/home" yazıldığında bu Servlet çalışacak.
@WebServlet(urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        // DAO 
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        //Veritabanından aktif ürünleri ve kategorileri çekiyor
        List<Product> activeProducts;
        List<Category> activeCategories = categoryDAO.getAllActiveCategories();
        
        // Eğer kullanıcı sol menüden bir kategoriye tıkladıysa onun id'sini alıyoruz
        String categoryParam = request.getParameter("category");
        if (categoryParam != null && !categoryParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryParam);
            // Sadece o kategoriye ait ürünleri getir
            activeProducts = productDAO.getProductsByCategory(categoryId);
            request.setAttribute("selectedCategory", categoryId);
        } else {
            // Kategori seçilmediyse ana sayfada tüm aktif ürünleri göster
            activeProducts = productDAO.getAllActiveProducts();
        }

        // Çektiğim verileri JSP sayfasına göndermek üzere paketliyoruz
        request.setAttribute("productList", activeProducts);
        request.setAttribute("categoryList", activeCategories);

        // İstediği "index.jsp" sayfasına yönlendiriyoruz 
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}