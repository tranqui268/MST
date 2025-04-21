package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.example.service.CustomerService;

import javax.servlet.http.HttpServletResponse;

public class ExportCustomer extends ActionSupport {
    private String name;
    private String email;
    private String status;
    private String address;
    private int page = 1;
    private int pageSize = 20;

    private boolean success;
    private CustomerService customerService;

    public ExportCustomer() throws Exception {
        customerService = new CustomerService();
    }

    public String execute(){
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setHeader("Content-Disposition", "attachment;filename=customers.xlsx");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        success = customerService.exportCustomer(response,name,email,status,address,page,pageSize);
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

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
