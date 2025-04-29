package org.example.service;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.example.mapper.CustomerMapper;
import org.example.model.Customer;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerService {
    private SqlSessionFactory sqlSessionFactory;
    public CustomerService() throws Exception{
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    }

    public List<Customer> getCustomerWithPagination(String name, String email, String status, String address, int page, int pageSize) {
        try(SqlSession session = sqlSessionFactory.openSession()){
            CustomerMapper mapper = session.getMapper(CustomerMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            params.put("email", email);
            params.put("status", status);
            params.put("address", address);
            params.put("offset", (page - 1) * pageSize);
            params.put("pageSize", pageSize);
            System.out.println("FETCHDATA:" +mapper.getFilteredCustomer(params));
            return mapper.getFilteredCustomer(params);
        }
    }

    public int countFilteredCustomer(String name, String email, String status, String address){
        try(SqlSession session = sqlSessionFactory.openSession()) {
            CustomerMapper mapper = session.getMapper(CustomerMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            params.put("email", email);
            params.put("status", status);
            params.put("address", address);
            return mapper.countFilteredCustomer(params);
        }
    }

    public Customer getCustomerByEmail(int id, String email){
        try (SqlSession session = sqlSessionFactory.openSession()){
            CustomerMapper mapper = session.getMapper(CustomerMapper.class);
            return mapper.getCustomerByEmail(id, email);
        }
    }

    public Customer findByEmail(String email){
        try (SqlSession session = sqlSessionFactory.openSession()){
            CustomerMapper mapper = session.getMapper(CustomerMapper.class);
            return mapper.findByEmail(email);
        }
    }

    public int addCustomer(String name, String email, String tel_num, String address){
        try (SqlSession session = sqlSessionFactory.openSession(true)){
            CustomerMapper mapper = session.getMapper(CustomerMapper.class);
            return mapper.addCustomer(name, email, tel_num, address);
        }catch (Exception e) {
            e.printStackTrace();
            return 0;
        }

    }

    public int updateUser(int id,String name, String email, String tel_num, String address ){
        try (SqlSession session = sqlSessionFactory.openSession(true)){
            CustomerMapper mapper = session.getMapper(CustomerMapper.class);
            return mapper.updateCustomer(id,name, email, tel_num, address);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    public List<String> importCustomer(File file ){
        List<String> errors = new ArrayList<>();
        try (InputStream is = new FileInputStream(file)) {
            System.out.println("Reading file: " + file.getAbsolutePath());
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);
            System.out.println("Total rows: " + sheet.getLastRowNum());

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                String name = getCellValueAsString(row.getCell(0), i + 1, "Tên", errors);
                String email = getCellValueAsString(row.getCell(1), i + 1, "Email", errors);
                String phone = getCellValueAsString(row.getCell(2), i + 1, "Số điện thoại", errors);
                String address = getCellValueAsString(row.getCell(3), i + 1, "Địa chỉ", errors);

                if (!isValidName(name) || !isValidEmail(email) || !isValidPhone(phone) || !isValidAddress(address)) {
                    errors.add("Dòng " + (i + 1) + " có lỗi định dạng");
                    continue;
                } else {
                    try {
                        Customer existingCustomer = findByEmail(email);
                        if (existingCustomer != null){
                            boolean isSame = existingCustomer.getCustomer_name().equals(name) &&
                                    existingCustomer.getTel_num().equals(phone) &&
                                    existingCustomer.getAddress().equals(address);
                            if (isSame){
                                continue;
                            }else {
                                int result = updateUser(existingCustomer.getCustomer_id(),name, email, phone, address);
                                if (result > 0) {
                                    System.out.println("Row " + (i + 1) + ": Updated customer with email " + email + " successfully.");
                                } else {
                                    errors.add("Dòng " + (i + 1) + ": Lỗi khi cập nhật khách hàng với email " + email + ".");
                                }
                            }
                        }else {
                            int result = addCustomer(name, email, phone, address);
                            if (result == 0) {
                                errors.add("Dòng " + (i + 1) + ": Lỗi khi thêm khách hàng vào database.");
                            } else {
                                System.out.println("Row " + (i + 1) + ": Added customer successfully.");
                            }
                        }

                    } catch (Exception e) {
                        errors.add("Dòng " + (i + 1) + ": Lỗi khi thêm khách hàng - " + e.getMessage());
                    }
                }
            }
            workbook.close();

        } catch (Exception e) {
            errors.add("File không hợp lệ hoặc lỗi đọc file.");
            e.printStackTrace();
        }

        return errors;

    }

    public boolean exportCustomer(HttpServletResponse response, String name, String email, String status, String address, int page, int pageSize){
        List<Customer> customers = getCustomerWithPagination(name, email, status, address, page, pageSize);
        try (Workbook workbook = new SXSSFWorkbook()){
            Sheet sheet = workbook.createSheet("Customers");

            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("Tên khách hàng ");
            header.createCell(1).setCellValue("Email");
            header.createCell(2).setCellValue("TelNum");
            header.createCell(3).setCellValue("Địa chỉ");

            for (int i = 0; i < customers.size(); i++) {
                Customer c = customers.get(i);
                Row row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(c.getCustomer_name());
                row.createCell(1).setCellValue(c.getEmail());
                row.createCell(2).setCellValue(c.getTel_num());
                row.createCell(3).setCellValue(c.getAddress());
            }

            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
            workbook.close();
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private boolean isValidName(String name) {
        return name != null && !name.trim().isEmpty() && name.matches("^[\\p{L} .'-]+$");
    }

    private boolean isValidAddress(String address) {
        return address != null && !address.trim().isEmpty();
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^0\\d{9}$");
    }

    private String getCellValueAsString(Cell cell, int rowNum, String fieldName, List<String> errors) {
        if (cell == null) {
            errors.add("Dòng " + rowNum + ": " + fieldName + " trống.");
            return null;
        }

        try {
            switch (cell.getCellType()) {
                case STRING:
                    return cell.getStringCellValue().trim();
                case NUMERIC:
                    if (fieldName.equals("Số điện thoại")) {
                        String numericValue = String.valueOf((long) cell.getNumericCellValue());
                        // Thêm số 0 ở đầu nếu số không đủ 10 chữ số
                        if (numericValue.length() == 9) {
                            return "0" + numericValue;
                        }
                        return numericValue;
                    }
                    return String.valueOf((long) cell.getNumericCellValue());
                case BOOLEAN:
                    return String.valueOf(cell.getBooleanCellValue());
                case BLANK:
                    errors.add("Dòng " + rowNum + ": " + fieldName + " trống.");
                    return null;
                default:
                    errors.add("Dòng " + rowNum + ": " + fieldName + " có kiểu dữ liệu không hỗ trợ.");
                    return null;
            }
        } catch (Exception e) {
            errors.add("Dòng " + rowNum + ": " + fieldName + " không thể đọc: " + e.getMessage());
            return null;
        }
    }

}
