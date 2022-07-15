package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> getRemarkList(String id);

    boolean deleteRemark(String id);

    boolean saveRemark(ClueRemark clueRemark);

    boolean updateRemark(ClueRemark clueRemark);

    boolean deleteRemarkByIds(String[] id);
}
