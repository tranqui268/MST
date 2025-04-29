package org.example.action;


import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import org.example.dto.MessageResponse;
import org.example.model.User;
import org.example.service.UserService;
import org.example.util.JwtUtil;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.Serial;


public class LoginAction extends ActionSupport {
    private String email;
    private String password;

    // response
    private MessageResponse messageResponse;

    private UserService userService;
    public LoginAction() throws Exception{
        userService = new UserService();
    }


    @Override
    public String execute() throws Exception {
        HttpServletRequest request = ServletActionContext.getRequest();
        String method = request.getMethod();
        messageResponse = new MessageResponse();
        String rememberParam = request.getParameter("remember");

        if ("GET".equalsIgnoreCase(method)){
            return INPUT;
        }

        if (email == null || password ==null){
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Đăng nhập không thành công");
            return INPUT;
        }

        User user = userService.authenticate(email,password);
        if (user != null){
            String token = JwtUtil.generateToken(user);

            HttpSession session = ServletActionContext.getRequest().getSession();
            session.setAttribute("loggedUser",user);
            userService.updateLastLogin(user.getId());

            userService.updateLastIp(user.getId(), getClientIp(request));
            System.out.println("TOKEN"+token);
            Cookie cookie = new Cookie("token",token);
            cookie.setMaxAge(7 * 24 * 60 * 60);
            HttpServletResponse response = ServletActionContext.getResponse();
            response.addCookie(cookie);
            session.setAttribute("group_role", JwtUtil.getGroupRole(token));
            if ("on".equalsIgnoreCase(rememberParam)){
                userService.updateRememberToken(user.getId(),token);
            }
            password = null;
            messageResponse.setSuccess(true);
            messageResponse.setMessage("Đăng nhập thành công");
            return SUCCESS;
        }else {
            messageResponse.setSuccess(false);
            messageResponse.setMessage("Đăng nhập thất bại");
            addActionError("Tài khoản hoặc mật khẩu không đúng!");
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

    public MessageResponse getMessageResponse() {
        return messageResponse;
    }

    public void setMessageResponse(MessageResponse messageResponse) {
        this.messageResponse = messageResponse;
    }
}