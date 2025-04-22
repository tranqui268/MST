package org.example.action;


import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.example.model.User;
import org.example.service.UserService;
import org.example.util.JwtUtil;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class LoginAction extends ActionSupport {
    private String email;
    private String password;
    private String message;

    private UserService userService;
    public LoginAction() throws Exception{
        userService = new UserService();
    }


    @Override
    public String execute() throws Exception {
        HttpServletRequest request = ServletActionContext.getRequest();
        String method = request.getMethod();
        String rememberParam = request.getParameter("remember");

        if ("GET".equalsIgnoreCase(method)){
            return INPUT;
        }

        if (email == null || password ==null){
            return INPUT;
        }

        User user = userService.authenticate(email,password);
        if (user != null){
            String token = JwtUtil.generateToken(user);

            HttpSession session = ServletActionContext.getRequest().getSession();
            session.setAttribute("loggedUser",user);
            userService.updateLastLogin(user.getId());

            userService.updateLastIp(user.getId(), getClientIp(request));

            Cookie cookie = new Cookie("token",token);
            cookie.setMaxAge(7 * 24 * 60 * 60);
            HttpServletResponse response = ServletActionContext.getResponse();
            response.addCookie(cookie);
            session.setAttribute("group_role", JwtUtil.getGroupRole(token));
            if ("on".equalsIgnoreCase(rememberParam)){
                userService.updateRememberToken(user.getId(),token);
            }
            return SUCCESS;
        }else {
            message = "Email or password incorrect!";
            return ERROR;
        }
    }

    private String getClientIp(HttpServletRequest request){
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)){
            ipAddress = request.getRemoteAddr();
        }
        System.out.println("IP" + ipAddress);
        return ipAddress;

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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }


}