package org.example;

import org.example.model.User;
import org.example.service.UserService;

public class Main {
    public static void main(String[] args) {
        try {
            UserService userService = new UserService();
            String email = "a1@example.com"; // Thay bằng email bạn muốn kiểm tra
            String password = "password1";  // Thay bằng mật khẩu bạn muốn kiểm tra

            User user = userService.authenticate(email, password);
            if (user != null) {
                System.out.println("Thông tin người dùng đã được lấy thành công!");
                System.out.println("Email: " + user.getEmail());
                System.out.println("Tên: " + user.getName());
            } else {
                System.out.println("Không tìm thấy người dùng hoặc sai mật khẩu!");
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi kết nối với cơ sở dữ liệu:");
            e.printStackTrace();
        }
    }
}