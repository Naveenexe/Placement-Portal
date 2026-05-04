package com.placement.dao;

import com.placement.model.Admin;

public interface AdminDAO {

    // Admin login
    Admin login(String username, String password);
}