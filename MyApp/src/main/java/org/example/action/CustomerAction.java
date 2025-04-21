package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.model.Customer;
import org.example.service.CustomerService;

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
    private boolean success;
    private CustomerService customerService;

    public CustomerAction() throws Exception {
        customerService = new CustomerService();
    }

    public String getFilteredCustomer(){
        customers = customerService.getCustomerWithPagination(name,email,status,address,page,pageSize);
        totalCustomers = customerService.countFilteredCustomer(name,email,status,address);
        totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        paginationInfo = new HashMap<>();
        paginationInfo.put("currentPage", page);
        paginationInfo.put("pageSize", pageSize);
        paginationInfo.put("totalUsers", totalCustomers);
        paginationInfo.put("totalPages", totalPages);
        if (customers != null) success=true;
        else success=false;
        return SUCCESS;
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

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
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
}
