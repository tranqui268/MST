package org.example.model;

import java.util.Date;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String rememberToken;
    private String verify_email;
    private Boolean is_active;
    private Boolean is_delete;
    private String group_role;
    private Date last_login_at;
    private String last_login_id;
    private Date created_at;
    private Date updated_at;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRememberToken() {
        return rememberToken;
    }

    public void setRememberToken(String rememberToken) {
        this.rememberToken = rememberToken;
    }

    public String getVerify_email() {
        return verify_email;
    }

    public void setVerify_email(String verify_email) {
        this.verify_email = verify_email;
    }

    public Boolean getIs_active() {
        return is_active;
    }

    public void setIs_active(Boolean is_active) {
        this.is_active = is_active;
    }

    public Boolean getIs_delete() {
        return is_delete;
    }

    public void setIs_delete(Boolean is_delete) {
        this.is_delete = is_delete;
    }

    public String getGroup_role() {
        return group_role;
    }

    public void setGroup_role(String group_role) {
        this.group_role = group_role;
    }

    public Date getLast_login_at() {
        return last_login_at;
    }

    public void setLast_login_at(Date last_login_at) {
        this.last_login_at = last_login_at;
    }

    public String getLast_login_id() {
        return last_login_id;
    }

    public void setLast_login_id(String last_login_id) {
        this.last_login_id = last_login_id;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }
}
