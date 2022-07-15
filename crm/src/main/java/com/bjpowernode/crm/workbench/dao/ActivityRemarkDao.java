package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {


    int deleteByAid(String id);

    List<ActivityRemark> getRemarkByAids(String id);

    int deleteRemarkByAid(String id);

    int insertRemark(ActivityRemark remark);

    int updateRemark(ActivityRemark remark);

    List<ActivityRemark> getRemarkByAid(String id);
}
