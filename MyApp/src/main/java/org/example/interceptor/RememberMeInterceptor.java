package org.example.interceptor;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.apache.struts2.ServletActionContext;
import org.example.model.User;
import org.example.service.UserService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class RememberMeInterceptor extends AbstractInterceptor {
    @Override
    public String intercept(ActionInvocation actionInvocation) throws Exception {
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUser")==null){
            Cookie[] cookies = request.getCookies();
            if (cookies != null){
                for (Cookie cookie : cookies){
                    if ("token".equals(cookie.getName())){
                        String token = cookie.getValue();

                        UserService userService = new UserService();
                        User user = userService.findByRememberToken(token);
                        if (user != null){
                            request.getSession(true).setAttribute("loggedUser", user);

                        }
                    }
                }
            }
        }
        if (request.getSession(false) != null
                && request.getSession(false).getAttribute("loggedUser") != null
                && "login".equals(actionInvocation.getProxy().getActionName())) {

            return "success";
        }


        return actionInvocation.invoke();
    }
}
