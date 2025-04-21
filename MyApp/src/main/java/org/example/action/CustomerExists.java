package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.model.Customer;
import org.example.service.CustomerService;

public class CustomerExists extends ActionSupport {
    private String email;
    private boolean exist;
    private int customer_id;
    private CustomerService customerService;

    public CustomerExists() throws Exception {
        customerService = new CustomerService();
    }

    public String checkCustomerExist(){
        Customer customer = customerService.getCustomerByEmail(customer_id, email);
        if (customer != null) exist=true;
        else exist=false;
        return SUCCESS;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isExist() {
        return exist;
    }

    public void setExist(boolean exist) {
        this.exist = exist;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }
}
