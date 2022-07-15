package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean saveTran(Tran tran, String customerName,String createBy);

    PaginationVO<Tran> pageList(Map<String, Object> map);

    Tran getTranById(String id);

    List<TranHistory> getTranHistoryListById(String tranId);

    boolean changeStage(Tran tran);

    Map<String, Object> getCharts();

    Tran getTran(String id);

    boolean deleteByAids(List<String> idList);

    boolean deleteByids(String[] ids);

    boolean deleteHistoryByids(String[] id);

    boolean update(Tran tran,String createBy);

    List<TranRemark> getRemarkList(String id);

    boolean deleteRemark(String id);

    boolean updateRemark(TranRemark remark);

    boolean saveRemark(TranRemark remark);

    boolean deleteRemarkByids(String[] id);

    boolean deleteByCids(List<String> idList);

    List<Tran> getTranByCid(String cid);

    boolean deleteTranByConids(List<String> idList);

    List<Tran> getTranByConid(String conid);
}
