package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ContactsActivityRelationDao;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.dao.ContactsRemarkDao;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class ContactServiceImpl implements ContactService {
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Autowired
    private CustomerDao customerDao;

    @Transactional
    @Override
    public boolean deleteActivityContactRelation(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            if(contactsActivityRelationDao.getRelationByAid(id).size()>0){
                flag=contactsActivityRelationDao.deleteActivityClueRelation(id)>0;
            }
        }
        return flag;
    }

    @Override
    public List<Contacts> getContacts(String con, String name) {
        return contactsDao.getContacts(con,name);
    }

    @Override
    public List<Contacts> getContactsByName(String aname) {
        return contactsDao.getContactsByName(aname);
    }

    @Override
    public List<Contacts> getContactByCid(String cid) {
        return contactsDao.getContactByCid(cid);
    }

    @Transactional
    @Override
    public boolean deleteByConids(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            if(contactsActivityRelationDao.getRelationByConid(id).size()>0){
                flag=contactsActivityRelationDao.deleteActivityContactRelation(id)>0;
            }
            if(contactsRemarkDao.getRemarkByConid(id).size()>0){
                flag=contactsRemarkDao.deleteRemarkByConid(id)>0;
            }
            flag=contactsDao.delete(id)>0;
        }
        return flag;
    }

    @Override
    public boolean save(Contacts contacts) {
        return contactsDao.save(contacts)>0;
    }

    @Override
    public PaginationVO<Contacts> pageList(Map<String, Object> map) {
        PaginationVO<Contacts> Info=new PaginationVO<>();
        int total = contactsDao.getTotalByCondition(map);
        List<Contacts> pageContact = contactsDao.getContactyByCondition(map);
        Info.setActivities(pageContact);
        Info.setTotal(total);
        return Info;
    }

    @Override
    public boolean saveContact(Contacts contacts) {
        boolean flag=true;
        Customer customer = customerDao.getCustomerByName(contacts.getCustomerName());
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(contacts.getCreateBy());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setOwner(contacts.getOwner());
            customer.setWebsite("www.baidu.com");
            customer.setName(contacts.getCustomerName());
            customer.setPhone("123456789");
            customer.setAddress("杭州");
            flag=customerDao.save(customer)>0;
        }
        contacts.setCustomerId(customer.getId());
        flag=contactsDao.save(contacts)>0;
        return flag;
    }

    @Override
    public Contacts getContactById(String id) {
        return contactsDao.getContactById(id);
    }

    @Override
    public boolean update(Contacts contacts) {
        boolean flag=true;
        Customer customer = customerDao.getCustomerByName(contacts.getCustomerName());
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(contacts.getCreateBy());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setOwner(contacts.getOwner());
            customer.setWebsite("www.baidu.com");
            customer.setName(contacts.getCustomerName());
            customer.setPhone("123456789");
            customer.setAddress("杭州");
            flag=customerDao.save(customer)>0;
        }
        contacts.setCustomerId(customer.getId());
        flag=contactsDao.update(contacts)>0;
        return flag;
    }

    @Override
    public List<ContactsRemark> getRemarkByConid(String id) {
        return contactsRemarkDao.getRemarkByConid(id);
    }

    @Override
    public boolean saveRemark(ContactsRemark remark) {
        return contactsRemarkDao.save(remark)>0;
    }

    @Override
    public boolean updateRemark(ContactsRemark remark) {
        return contactsRemarkDao.updateRemark(remark)>0;
    }

    @Override
    public boolean deleteRemark(String id) {
        return contactsRemarkDao.deleteRemark(id)>0;
    }

    @Override
    public List<Activity> getActivityByConId(String conid) {
        return contactsDao.getActivityByConId(conid);
    }

    @Override
    public boolean deleteByRelationId(String id) {
        return contactsActivityRelationDao.deleteByRelationId(id)>0;
    }

    @Override
    public List<Activity> getActivityListByNameNotByConId(String aname, String conid) {
        return contactsDao.getActivityListByNameNotByConId(aname,conid);
    }

    @Transactional
    @Override
    public boolean bund(String[] ids, String conid) {
        boolean flag=true;
        for (String id : ids){
            ContactsActivityRelation contactsActivityRelation=new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(id);
            contactsActivityRelation.setContactsId(conid);
            flag=contactsActivityRelationDao.bund(contactsActivityRelation)>0;
        }
        return flag;
    }
}
