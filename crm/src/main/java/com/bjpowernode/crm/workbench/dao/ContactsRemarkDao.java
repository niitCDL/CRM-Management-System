package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.Collection;
import java.util.List;

public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    List<ContactsRemark> getRemarkByConid(String id);

    int deleteRemarkByConid(String id);

    int updateRemark(ContactsRemark remark);

    int deleteRemark(String id);
}
