package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.UserService;

public class UserDelete extends ActionSupport {
    private int id;
    private boolean success;

    private UserService userService;

    public  UserDelete() throws Exception {
        userService = new UserService();
    }

    public String deleteUser(){
        int row = userService.deleteUser(id);
        if (row > 0) success = true;
        else  success = false;
        return SUCCESS;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
