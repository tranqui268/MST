package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.example.dto.FileResponse;
import org.example.dto.MessageResponse;
import org.example.dto.PaginationResponse;
import org.example.model.Customer;
import org.example.service.CustomerService;
import org.example.util.Validate;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CustomerAction extends ActionSupport {
    private String name;
    private String email;
    private String status;
    private String address;
    private List<Customer> customers;
    private Map<String, Object> paginationInfo;
    private int page = 1;
    private int pageSize = 20;
    private int totalCustomers;
    private int totalPages;
    private CustomerService customerService;

    // check exists
    private int customer_id;

    // add customer
    private String tel_num;

    // import, export file
    private File file;
    private String fileContentType;
    private String fileFileName;

    private List<String> errors;

    // Response
    private PaginationResponse<List<Customer>> paginationResponse;
    private MessageResponse messageResponse;
    private FileResponse fileResponse;

    public CustomerAction() throws Exception {
        customerService = new CustomerService();
    }


    public String getFilteredCustomer(){
        paginationResponse = new PaginationResponse<>();

        String nameError = Validate.validateInput(name);
        if (nameError != null){
            paginationResponse.setSuccess(false);
            paginationResponse.setMessage(nameError);
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
        }

        String addressError = Validate.validateInput(address);
        if (addressError != null){
            paginationResponse.setSuccess(false);
            paginationResponse.setMessage(addressError);
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
        }

        String emailError = Validate.validateInput(email);
        if (emailError != null){
            paginationResponse.setSuccess(false);
            paginationResponse.setMessage(emailError);
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
        }

        customers = customerService.getCustomerWithPagination(name,email,status,address,page,pageSize);
        totalCustomers = customerService.countFilteredCustomer(name,email,status,address);
        totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        paginationInfo = new HashMap<>();
        paginationInfo.put("currentPage", page);
        paginationInfo.put("pageSize", pageSize);
        paginationInfo.put("totalCustomers", totalCustomers);
        paginationInfo.put("totalPages", totalPages);


        if (customers != null) {
            paginationResponse.setSuccess(true);
            paginationResponse.setMessage("Lấy dữ liệu thành công");
            paginationResponse.setData(customers);
            paginationResponse.setPaginationInfo(paginationInfo);
        }
        else{
            paginationResponse.setSuccess(false);
            paginationResponse.setMessage("Lấy dữ liệu thất bại");
            paginationResponse.setData(customers);
            paginationResponse.setPaginationInfo(null);
        }
        return SUCCESS;
    }

    public String checkCustomerExist(){
        messageResponse = new MessageResponse();
        Customer customer = customerService.getCustomerByEmail(customer_id, email);
        if (customer == null) {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Khách hàng chưa tồn tại");
        }
        else{
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Khách hàng đã tồn tại");
        }
        return SUCCESS;
    }

    public String addCustomer(){
        messageResponse = new MessageResponse();
        int rowInsert =customerService.addCustomer(name, email, tel_num, address);
        if (rowInsert > 0) {
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Thêm thành công");
        }
        else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Thêm không thành công");
        }
        return SUCCESS;
    }

    public String updateCustomer(){
        messageResponse = new MessageResponse();
        int rowUpdate = customerService.updateUser(customer_id,name, email, tel_num, address);
        if (rowUpdate > 0) {
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Sửa thành công");
        }
        else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Sửa không thành công");
        }
        return SUCCESS;
    }

    public String importFile(){
        fileResponse = new FileResponse();
        System.out.println("File received: " + file);
        System.out.println("File name: " + fileFileName);
        System.out.println("Content type: " + fileContentType);
        errors = new ArrayList<>();
        if (file == null) {

            errors.add("Không nhận được file Excel.");
            return SUCCESS;
        }
        errors = customerService.importCustomer(file);
        if (errors.isEmpty()){
            fileResponse.setSuccess(true);
            fileResponse.setMessage("Import thành công");
            fileResponse.setFileName(fileFileName);
            fileResponse.setErrors(null);
        }else {
            fileResponse.setSuccess(false);
            fileResponse.setMessage("Import thất bại ");
            fileResponse.setFileName(null);
            fileResponse.setErrors(errors);
        }

        return SUCCESS;
    }

    public String exportFile(){
        messageResponse = new MessageResponse();
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setHeader("Content-Disposition", "attachment;filename=customers.xlsx");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        boolean success = customerService.exportCustomer(response,name,email,status,address,page,pageSize);
        if (success){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Export thành công");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Export thất bại");
        }
        return NONE;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public List<Customer> getCustomers() {
        return customers;
    }

    public void setCustomers(List<Customer> customers) {
        this.customers = customers;
    }

    public Map<String, Object> getPaginationInfo() {
        return paginationInfo;
    }

    public void setPaginationInfo(Map<String, Object> paginationInfo) {
        this.paginationInfo = paginationInfo;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public String getTel_num() {
        return tel_num;
    }

    public void setTel_num(String tel_num) {
        this.tel_num = tel_num;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getFileContentType() {
        return fileContentType;
    }

    public void setFileContentType(String fileContentType) {
        this.fileContentType = fileContentType;
    }

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public List<String> getErrors() {
        return errors;
    }

    public void setErrors(List<String> errors) {
        this.errors = errors;
    }

    public PaginationResponse<List<Customer>> getPaginationResponse() {
        return paginationResponse;
    }

    public void setPaginationResponse(PaginationResponse<List<Customer>> paginationResponse) {
        this.paginationResponse = paginationResponse;
    }

    public MessageResponse getMessageResponse() {
        return messageResponse;
    }

    public void setMessageResponse(MessageResponse messageResponse) {
        this.messageResponse = messageResponse;
    }

    public FileResponse getFileResponse() {
        return fileResponse;
    }

    public void setFileResponse(FileResponse fileResponse) {
        this.fileResponse = fileResponse;
    }
}
