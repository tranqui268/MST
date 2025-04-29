package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.json.annotations.JSON;
import org.example.dto.AddResponse;
import org.example.dto.MessageResponse;
import org.example.dto.PaginationResponse;
import org.example.model.User;
import org.example.service.UserService;
import org.example.util.Validate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserAction extends ActionSupport {
    private int page =1;
    private int pageSize = 20;
    private int totalUsers;
    private int totalPages;
    private List<User> users;

    private Map<String, Object> paginationInfo;
    private UserService userService;

    // filter
    private String name;
    private String email;
    private String group;
    private String status;

    // delete
    private int id;

    // add, update
    private String password;

    // update permission;
    private int isActive;

    // deleteUsersBulk
    private List<Integer> selectedIds;

    // Response
    private PaginationResponse<List<User>> paginationResponse;
    private MessageResponse messageResponse;


    public UserAction() throws Exception{
        userService = new UserService();
    }


    public String list() throws Exception {
        users = userService.getAllUser();
        return SUCCESS;
    }

    public String getListUserFilter(){
        paginationResponse = new PaginationResponse<>();
        boolean check = true;
        System.out.println("DATARESULT" + name + email + group + status);

        String nameError = Validate.validateInput(name);
        if (nameError != null){
            paginationResponse.setMessage(nameError);
            check = false;
        }

        String emailError = Validate.validateEmail(email,false);
        if (emailError != null){
            paginationResponse.setMessage(emailError);
            check = false;

        }

        String groupError = Validate.validateInput(group);
        if (groupError != null){
            paginationResponse.setMessage(groupError);
            check = false;

        }

        String statusError = Validate.validateInput(status);
        if (statusError != null){
            paginationResponse.setMessage(statusError);
            check = false;

        }

        String statusValueError = Validate.validateStatus(status);
        if (statusValueError != null){
            paginationResponse.setMessage(statusValueError);
            check = false;
        }

        if (!check){
            paginationResponse.setSuccess(false);
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
            return SUCCESS;
        }



        users = userService.getUsersWithPagination(name,email,group,status,page,pageSize);
        System.out.println("Users after filter: " + users);

        totalUsers = userService.countUsers(name,email,group,status);
        totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        paginationInfo = new HashMap<>();
        paginationInfo.put("currentPage", page);
        paginationInfo.put("pageSize", pageSize);
        paginationInfo.put("totalUsers", totalUsers);
        paginationInfo.put("totalPages", totalPages);

        if (users != null){
            paginationResponse.setData(users);
            paginationResponse.setPaginationInfo(paginationInfo);
            paginationResponse.setSuccess(true);
            paginationResponse.setMessage("Lấy dữ liệu thành công");
        }else {
            paginationResponse.setData(null);
            paginationResponse.setPaginationInfo(null);
            paginationResponse.setSuccess(false);
            paginationResponse.setMessage("Lấy dữ liệu thất bại");
        }

        return SUCCESS;
    }

    public String deleteUser (){
        messageResponse = new MessageResponse();
        int row = userService.deleteUser(id);
        if (row > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Xóa thành công");
        }
        else{
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Xóa thất bại");
        }
        return SUCCESS;
    }

    public String addUser (){
        messageResponse = new MessageResponse();
        boolean check = true;


        String nameError = Validate.validateInput(name);
        if (nameError != null){
            messageResponse.setMessage(nameError);
            check = false;
        }

        String emailError = Validate.validateEmail(email, true);
        if (emailError != null){
            messageResponse.setMessage(emailError);
            check = false;

        }

        String groupError = Validate.validateInput(group);
        if (groupError != null){
            messageResponse.setMessage(groupError);
            check = false;

        }


        if (!check){
            messageResponse.setSuccess(false);
            return SUCCESS;
        }

        int rowAdd = userService.addUser(name, email,password, group);
        if (rowAdd > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Thêm thành công");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Thêm thất bại");
        }
        return SUCCESS;
    }

    public String updateUser (){
        messageResponse = new MessageResponse();
        System.out.println("DATARESULT" + name + email + group + status);
        boolean check = true;


        String nameError = Validate.validateInput(name);
        if (nameError != null){
            messageResponse.setMessage(nameError);
            check = false;
        }

        String emailError = Validate.validateEmail(email, true);
        if (emailError != null){
            messageResponse.setMessage(emailError);
            check = false;

        }

        String groupError = Validate.validateInput(group);
        if (groupError != null){
            messageResponse.setMessage(groupError);
            check = false;

        }


        if (!check){
            messageResponse.setSuccess(false);
            return SUCCESS;
        }

        int rowEdit = userService.updateUser(id,name,email,password,group);
        if (rowEdit > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Sửa thành công");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Sửa thất bại");
        }
        return SUCCESS;
    }

    public String checkEmailExist(){
        User user = userService.getUserByEmail(id,email);
        messageResponse = new MessageResponse();
        if (user != null){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Email chưa tồn tại");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Email đã tồn tại");
        }
        return SUCCESS;
    }

    public String managePermission(){
        messageResponse = new MessageResponse();
        System.out.println("IDACTIVE" + id + "-" +isActive);
        int rowUpdate = userService.updateIsActive(id, isActive);
        if (rowUpdate > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Cập nhật thành công ");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Cập nhật thất bại");
        }

        return SUCCESS;
    }

    public String deleteUsersBulk(){
        messageResponse = new MessageResponse();
        int delete = userService.deleteUsersBulk(selectedIds);
        if (delete > 0){
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Xóa thành công ");
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Xóa thất bại ");
        }
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

    public PaginationResponse<List<User>> getPaginationResponse() {
        return paginationResponse;
    }

    public void setPaginationResponse(PaginationResponse<List<User>> paginationResponse) {
        this.paginationResponse = paginationResponse;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public List<Integer> getSelectedIds() {
        return selectedIds;
    }

    public void setSelectedIds(List<Integer> selectedIds) {
        this.selectedIds = selectedIds;
    }

    public MessageResponse getMessageResponse() {
        return messageResponse;
    }

    public void setMessageResponse(MessageResponse messageResponse) {
        this.messageResponse = messageResponse;
    }
}
