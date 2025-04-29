package org.example.util;

import java.util.regex.Pattern;

public class Validate {
    private static final Pattern SPECIAL_CHAR_PATTERN = Pattern.compile("^[\\p{L}0-9\\s_-]+$");

    // Biểu thức chính quy để kiểm tra các từ khóa SQL injection
    private static final Pattern SQL_INJECTION_PATTERN = Pattern.compile(
            "(SELECT|INSERT|UPDATE|DELETE|DROP|TRUNCATE|UNION|EXEC|CREATE|ALTER|GRANT|REVOKE|--|\\/\\*|\\*\\/|;)",
            Pattern.CASE_INSENSITIVE
    );
    private static final Pattern NUMBER_PATTERN = Pattern.compile("^[0-9]+(\\.[0-9]+)?$");

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );


    public static boolean isValidSpecialChar(String input) {
        if (input == null || input.trim().isEmpty()) {
            return true;
        }
        return SPECIAL_CHAR_PATTERN.matcher(input).matches();
    }

    public static boolean isSafeFromSqlInjection(String input) {
        if (input == null || input.trim().isEmpty()) {
            return true;
        }
        return !SQL_INJECTION_PATTERN.matcher(input).find();
    }

    public static String validateInput(String input) {
        if (input == null || input.trim().isEmpty()) {
            return null;
        }
        if (!isValidSpecialChar(input)) {
            return "Chuỗi chứa ký tự đặc biệt không hợp lệ.";
        }
        if (!isSafeFromSqlInjection(input)) {
            return "Chuỗi chứa câu lệnh SQL không hợp lệ.";
        }
        return null;
    }

    public static String validatePrice(Double price, String fieldName) {
        if (price != null && price < 0) {
            return fieldName + " không được nhỏ hơn 0.";
        }
        return null;
    }

    public static String validateNumber(String input, String fieldName) {
        if (input == null || input.trim().isEmpty()) {
            return null;
        }
        if (!NUMBER_PATTERN.matcher(input).matches()) {
            return fieldName + " phải là một số hợp lệ.";
        }
        return null;
    }


    public static String validatePriceRange(Double priceFrom, Double priceTo) {
        if (priceFrom != null && priceTo != null && priceFrom > priceTo) {
            return "Giá từ (priceFrom) phải nhỏ hơn hoặc bằng giá đến (priceTo).";
        }
        return null;
    }

    public static String validateStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return null;
        }
        if (!status.equals("0") && !status.equals("1")) {
            return "Trạng thái chỉ được nhận giá trị 0 hoặc 1.";
        }
        return null;
    }

    public static String validateEmail(String email, boolean isRequired) {
        if (isRequired && (email == null || email.trim().isEmpty())) {
            return "Email không được để trống.";
        }

        if (email == null || email.trim().isEmpty()) {
            return null;
        }

        if (!isSafeFromSqlInjection(email)) {
            return "Email chứa câu lệnh SQL không hợp lệ.";
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            return "Email không đúng định dạng (ví dụ: user@example.com).";
        }

        if (email.length() > 255) {
            return "Email không được dài quá 255 ký tự.";
        }

        return null;
    }
}

