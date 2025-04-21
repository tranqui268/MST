package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.model.User;
import org.example.service.UserService;

public class UserExists extends ActionSupport {
    private String email;
    private Boolean exist;
    private int id;

    private UserService userService;

    public UserExists() throws Exception {
        userService = new UserService();
    }

    public String checkEmailExist(){
        User user = userService.getUserByEmail(id,email);
        if (user != null){
            exist = true;
        }else {
            exist = false;
        }
        return SUCCESS;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getExist() {
        return exist;
    }

    public void setExist(Boolean exist) {
        this.exist = exist;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
