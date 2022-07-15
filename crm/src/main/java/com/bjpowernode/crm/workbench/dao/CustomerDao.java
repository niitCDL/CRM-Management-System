package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer cus);

    List<String> getCustomerName(String name);

    List<Customer> getCustomerByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int deleteById(String id);

    Customer getCustomerByid(String id);

    int update(Customer customer);
}
