package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<String> getCustomerName(String name);

    PaginationVO<Customer> pageList(Map<String, Object> map);

    boolean save(Customer customer);

    boolean deleteByCids(List<String> idList);

    Customer getCustomerByid(String id);

    boolean update(Customer customer);

    List<CustomerRemark> getRemarkByCid(String id);

    boolean updateRemark(CustomerRemark remark);

    boolean saveRemark(CustomerRemark remark);

    boolean deleteRemark(String id);
}
