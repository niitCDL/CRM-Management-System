package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.domain.UserLoginInfo;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping(value = "/login.do",method = RequestMethod.POST)
    @ResponseBody
    public UserLoginInfo doLogin(User tempuser, HttpServletRequest request) throws IOException {
            String currentIp=request.getRemoteAddr();
            String loginAct = tempuser.getLoginAct();
            String loginPwd = tempuser.getLoginPwd();
            UserLoginInfo info=new UserLoginInfo();
            User user=userService.getUser(loginAct,loginPwd,currentIp);
            //如果用户返回不为空并且提示报错信息为空的代表的是合理用户
            if(user!=null&&user.getMsg()==null){
                HttpSession session = request.getSession();
                session.setAttribute("user",user);
                info.setState(true);
                return info;
            }
            if(user==null){
                info.setMsg("用户名或密码错误");
            }else {
                info.setMsg(user.getMsg());
            }
            return info;
    }
}
