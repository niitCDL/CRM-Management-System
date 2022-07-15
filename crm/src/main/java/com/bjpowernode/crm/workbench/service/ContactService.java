package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

public interface ContactService {
    boolean deleteActivityContactRelation(List<String> idList);

    List<Contacts> getContacts(String con, String name);

    List<Contacts> getContactsByName(String aname);

    List<Contacts> getContactByCid(String cid);

    boolean deleteByConids(List<String> idList);

    boolean save(Contacts contacts);

    PaginationVO<Contacts> pageList(Map<String, Object> map);

    boolean saveContact(Contacts contacts);

    Contacts getContactById(String id);

    boolean update(Contacts contacts);

    List<ContactsRemark> getRemarkByConid(String id);

    boolean saveRemark(ContactsRemark remark);

    boolean updateRemark(ContactsRemark remark);

    boolean deleteRemark(String id);

    List<Activity> getActivityByConId(String conid);

    boolean deleteByRelationId(String id);

    List<Activity> getActivityListByNameNotByConId(String aname, String conid);

    boolean bund(String[] id, String conid);
}
