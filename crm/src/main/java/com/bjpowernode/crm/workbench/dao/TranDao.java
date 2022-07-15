package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran tran);

    PaginationVO<Tran> pageList(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    List<Tran> getTranByCondition(Map<String, Object> map);

    Tran getTranById(String id);

    int changeStage(Tran tran);

    int getTotal();

    List<Map<String, Integer>> getCharts();

    Tran getTran(String id);

    int deleteByAid(String id);

    int deleteByid(String id);

    List<Tran> getTranListByAId(String id);

    int update(Tran tran);

    List<Tran> getTranListByCId(String id);

    int deleteByCid(String id);

    List<Tran> getTranListByConId(String id);

    int deleteByConid(String id);

}
