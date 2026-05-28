package com.ovamarket.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int productId;
    private String name;
    private double price;
    private int quantity;
    private String imageUrl;
    private int maxStock; // Stok aşımını engellemek için tutuyoruz 

    public CartItem() {}

    // Birim Fiyat x Adet
    public double getTotalPrice() {
        return this.price * this.quantity;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public int getMaxStock() { return maxStock; }
    public void setMaxStock(int maxStock) { this.maxStock = maxStock; }
}