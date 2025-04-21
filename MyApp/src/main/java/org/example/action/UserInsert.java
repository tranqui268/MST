package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.UserService;

public class UserInsert extends ActionSupport {
    private int id;
    private String name;
    private String email;
    private String password;
    private String groupRole;
    private boolean success;

    private UserService userService;

    public UserInsert () throws Exception {
        userService = new UserService();
    }

    public String addUser(){
        int rowAdd = userService.addUser(name, email, groupRole);
        if (rowAdd > 0){
            success = true;
        }else {
            success = false;
        }
        return SUCCESS;
    }

    public String updateUser(){
        int rowEdit = userService.updateUser(id,name,email,password,groupRole);
        if (rowEdit > 0){
            success = true;
        }else {
            success = false;
        }
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

    public String getGroupRole() {
        return groupRole;
    }

    public void setGroupRole(String groupRole) {
        this.groupRole = groupRole;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
