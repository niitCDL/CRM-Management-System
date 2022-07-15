package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao dao;

    public UserDao getDao() {
        return dao;
    }

    public void setDao(UserDao dao) {
        this.dao = dao;
    }

    @Override
    public User getUser(String LoginAct, String LoginPwd,String ip) {
        Map<String,String> usermap=new HashMap<>();
        usermap.put("loginAct",LoginAct);
        usermap.put("loginPwd", MD5Util.getMD5(LoginPwd));
        User user=dao.getUser(usermap);
        if(user!=null){
            String currentTime= DateTimeUtil.getSysTime();
            String expireTime = user.getExpireTime();
            String allowIps = user.getAllowIps();
            String lockState = user.getLockState();
            if(allowIps!=null&&allowIps!=""&&!allowIps.contains(ip)){
                user.setMsg("用户ip不允许登录");
            }else if(!(expireTime.compareTo(currentTime)>0)){
                user.setMsg("用户账号已过期");
            }else if(!"1".equals(lockState)){
                user.setMsg("此账号处于封号状态请联系管理员");
            }
            return user;
        }
        return user;
    }

    @Override
    public List<User> getUserList() {
        return dao.getUserList();
    }
}
