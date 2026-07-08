package com.tap.Utility;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // MealMate database
    private static final String URL = "jdbc:mysql://localhost:3306/mealmate_db";
    
    // MySQL username
    private static final String USER = "root"; 
    
    // MySQL password as specified
    private static final String PASS = "Root123"; 

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish the connection using your credentials
            connection = DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return connection;
    }
}