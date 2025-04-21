package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.CustomerService;

public class CustomerInsert extends ActionSupport {
    private int customer_id;
    private String name;
    private String email;
    private String tel_num;
    private String address;
    private boolean success;
    private CustomerService customerService;

    public CustomerInsert() throws Exception {
        customerService = new CustomerService();
    }

    public String addCustomer(){
        int rowInsert =customerService.addCustomer(name, email, tel_num, address);
        if (rowInsert > 0) success=true;
        else success=false;
        return SUCCESS;
    }

    public String updateCustomer(){
        int rowUpdate = customerService.updateUser(customer_id,name, email, tel_num, address);
        if (rowUpdate > 0) success=true;
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

    public String getTel_num() {
        return tel_num;
    }

    public void setTel_num(String tel_num) {
        this.tel_num = tel_num;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }
}
