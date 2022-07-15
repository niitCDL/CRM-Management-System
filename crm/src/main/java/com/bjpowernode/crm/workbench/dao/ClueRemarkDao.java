package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {


    int delete(String clueId);

    List<ClueRemark> getnoteContentByClueId(String clueId);

    List<ClueRemark> getRemarkList(String id);

    int deleteRemark(String id);

    int saveRemark(ClueRemark clueRemark);

    int updateRemark(ClueRemark clueRemark);

    int deleteByCid(String id);
}
