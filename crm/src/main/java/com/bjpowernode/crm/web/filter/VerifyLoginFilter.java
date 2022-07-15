package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class VerifyLoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request= (HttpServletRequest) req;
        HttpServletResponse response= (HttpServletResponse) resp;
        HttpSession session = request.getSession(false);
        if(session!=null){
            User user= (User) session.getAttribute("user");
            if(user!=null){
                chain.doFilter(request,response);
            }else {
                response.sendRedirect(request.getContextPath()+"/index.jsp");
            }
        }else {
            response.sendRedirect(request.getContextPath()+"/index.jsp");
        }
    }

}
