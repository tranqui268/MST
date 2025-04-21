package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.UserService;

public class UserManagePermission extends ActionSupport {
    private int id;
    private int isActive;
    private boolean success;
    private UserService userService;
    public UserManagePermission() throws Exception{
        userService = new UserService();
    }
    public String managePermission(){
        System.out.println("IDACTIVE" + id + "-" +isActive);
        int rowUpdate = userService.updateIsActive(id, isActive);
        success = rowUpdate > 0;

        return SUCCESS;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public boolean getSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
