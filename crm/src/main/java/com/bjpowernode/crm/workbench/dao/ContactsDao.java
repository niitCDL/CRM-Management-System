package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts contacts);

    List<Contacts> getContacts(@Param(value = "con") String con, @Param(value = "name") String name);

    List<Contacts> getContactsByName(String aname);

    List<Contacts> getContactByCid(String cid);

    int delete(String id);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getContactyByCondition(Map<String, Object> map);

    Contacts getContactById(String id);

    int update(Contacts contacts);

    List<Activity> getActivityByConId(String conid);

    List<Activity> getActivityListByNameNotByConId(@Param("aname") String aname,@Param("conid") String conid);


}
