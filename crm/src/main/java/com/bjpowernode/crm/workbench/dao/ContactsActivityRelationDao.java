package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.Collection;
import java.util.List;


public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);

    int deleteActivityClueRelation(String id);

    List<ContactsActivityRelation> getRelationByAid(String id);

    List<ContactsActivityRelation> getRelationByConid(String id);

    int deleteActivityContactRelation(String id);

    int bund(ContactsActivityRelation contactsActivityRelation);

    int deleteByRelationId(String id);
}
