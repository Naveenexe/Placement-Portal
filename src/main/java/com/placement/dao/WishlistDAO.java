package com.placement.dao;

public interface WishlistDAO {
    boolean addToWishlist(int studentId, int jobId);
    boolean removeFromWishlist(int studentId, int jobId);
    boolean isJobInWishlist(int studentId, int jobId);
}
