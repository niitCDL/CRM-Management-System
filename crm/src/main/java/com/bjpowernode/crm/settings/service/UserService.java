package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User getUser(String LoginAct, String LoginPwd,String ip);

    List<User> getUserList();
}
