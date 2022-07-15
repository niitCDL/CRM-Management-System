package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueByCondition(Map<String, Object> map);

    Clue getClueById(String id);

    int delete(String clueId);

    Clue getClueById2(String id);

    int update(Clue clue);

    List<Map<String, Integer>> getCharts();

    int getChartsTotal();

    Clue getClueByConvert(String clueId);
}
