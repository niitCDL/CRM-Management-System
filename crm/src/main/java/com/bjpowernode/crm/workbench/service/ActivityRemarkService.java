package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    boolean deleteByAids(List<String> idList);

    List<ActivityRemark> getRemarkByAids(String id);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark remark);

    boolean updateRemark(ActivityRemark remark);
}
