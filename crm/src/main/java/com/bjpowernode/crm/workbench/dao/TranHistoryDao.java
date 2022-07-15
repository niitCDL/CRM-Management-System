package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> getTranHistoryListById(String tranId);

    int addTranHistory(TranHistory tranHistory);

    List<Tran> getTranHistoryByid(String id);

    int deleteByid(String id);
}
