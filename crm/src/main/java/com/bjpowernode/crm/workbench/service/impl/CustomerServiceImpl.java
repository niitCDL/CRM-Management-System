package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.CustomerRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    @Override
    public List<String> getCustomerName(String name) {
        List<String> nList=customerDao.getCustomerName(name);
        return nList;
    }

    @Override
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        PaginationVO<Customer> Info=new PaginationVO<>();
        int total = customerDao.getTotalByCondition(map);
        List<Customer> pageCustomer = customerDao.getCustomerByCondition(map);
        Info.setActivities(pageCustomer);
        Info.setTotal(total);
        return Info;
    }

    @Override
    public boolean save(Customer customer) {
        return customerDao.save(customer)>0;
    }

    @Transactional
    @Override
    public boolean deleteByCids(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            if(customerRemarkDao.getReamrkByid(id).size()>0){
                flag=customerRemarkDao.deleteRemarkByCid(id)>0;
            }
            flag=customerDao.deleteById(id)>0;
        }
        return flag;
    }

    @Override
    public Customer getCustomerByid(String id) {
        return customerDao.getCustomerByid(id);
    }

    @Override
    public boolean update(Customer customer) {
        return customerDao.update(customer)>0;
    }

    @Override
    public List<CustomerRemark> getRemarkByCid(String id) {
        return customerRemarkDao.getReamrkByid(id);
    }

    @Override
    public boolean updateRemark(CustomerRemark remark) {
        return customerRemarkDao.updateRemark(remark)>0;
    }

    @Override
    public boolean saveRemark(CustomerRemark remark) {
        return customerRemarkDao.saveRemark(remark)>0;
    }

    @Override
    public boolean deleteRemark(String id) {
        return customerRemarkDao.deleteRemark(id)>0;
    }



}
