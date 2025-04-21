package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.json.annotations.JSON;
import org.example.model.User;
import org.example.service.UserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserAction extends ActionSupport {
    private int page =1;
    private int pageSize = 20;
    private int totalUsers;
    private int totalPages;
    private List<User> users;
    private boolean success;

    private Map<String, Object> paginationInfo;
    private UserService userService;

    // filter
    private String name;
    private String email;
    private String group;
    private String status;

    public UserAction() throws Exception{
        userService = new UserService();
    }


    public String list() throws Exception {
        users = userService.getAllUser();
        return SUCCESS;
    }

    public String getListUserFilter(){
        System.out.println("DATARESULT" + name + email + group + status);
        users = userService.getUsersWithPagination(name,email,group,status,page,pageSize);
        System.out.println("Users after filter: " + users);

        totalUsers = userService.countUsers(name,email,group,status);
        totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        paginationInfo = new HashMap<>();
        paginationInfo.put("currentPage", page);
        paginationInfo.put("pageSize", pageSize);
        paginationInfo.put("totalUsers", totalUsers);
        paginationInfo.put("totalPages", totalPages);
        return SUCCESS;
    }



    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
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

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public Map<String, Object> getPaginationInfo() {
        return paginationInfo;
    }

    public void setPaginationInfo(Map<String, Object> paginationInfo) {
        this.paginationInfo = paginationInfo;
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

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
