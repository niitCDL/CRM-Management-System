package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;


public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    List<CustomerRemark> getReamrkByid(String id);

    int deleteRemarkByCid(String id);

    int updateRemark(CustomerRemark remark);

    int saveRemark(CustomerRemark remark);

    int deleteRemark(String id);
}
