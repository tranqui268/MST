package org.example.interceptor;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.apache.struts2.ServletActionContext;
import org.example.util.JwtUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthenticationInterceptor extends AbstractInterceptor {

    @Override
    public String intercept(ActionInvocation actionInvocation) throws Exception {
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpServletResponse response = ServletActionContext.getResponse();

        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // Bỏ "Bearer " để lấy token
        } else {
            if (request.getCookies() != null) {
                for (javax.servlet.http.Cookie cookie : request.getCookies()) {
                    if ("token".equals(cookie.getName())) {
                        token = cookie.getValue();
                        break;
                    }
                }
            }
        }


        try {
            if (token == null || token.trim().isEmpty()) {
                // Token không tồn tại, redirect về trang login
                response.sendRedirect(request.getContextPath() + "/login.action");
                return null;
            }


            JwtUtil.verifyToken(token);

            ActionContext.getContext().getSession().put("token", token);
            ActionContext.getContext().getSession().put("group_role", JwtUtil.getGroupRole(token));


            return actionInvocation.invoke();
        } catch (JWTVerificationException e) {
            System.err.println("Invalid token: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/login.action");
            return null;
        }
    }
}
