
package com.codequest.util;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {

    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {
            System.out.println("CodeQuest database connected successfully!");
        } 
        catch (SQLException e) 
        {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
