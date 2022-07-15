package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranRemarkDao {
    List<TranRemark> getRemarkList(String id);

    int deleteRemark(String id);

    int updateRemark(TranRemark remark);

    int saveRemark(TranRemark remark);

    List<TranRemark> getRemarkByTranId(String id);

    int deleteByTranId(String id);
}
