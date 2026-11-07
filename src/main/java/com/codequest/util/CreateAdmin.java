
package com.codequest.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Scanner;

public class CreateAdmin {

    public static void main(String[] args) {

        try (Scanner sc = new Scanner(System.in)) {

            System.out.print("Enter admin username: ");
            String username = sc.nextLine().trim();

            System.out.print("Enter admin password: ");
            String password = sc.nextLine();

            if (username.isEmpty() || password.isEmpty()) {
                System.out.println("Username and password cannot be empty.");
                return;
            }

            String sql =
                "INSERT INTO admins (username, password_hash) VALUES (?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                String passwordHash = PasswordUtil.hashPassword(password);

                ps.setString(1, username);
                ps.setString(2, passwordHash);

                ps.executeUpdate();

                System.out.println("Admin account created successfully!");
                System.out.println("Username: " + username);
            }

        } catch (Exception e) {
            System.out.println("Could not create admin account.");
            e.printStackTrace();
        }
    }
}
