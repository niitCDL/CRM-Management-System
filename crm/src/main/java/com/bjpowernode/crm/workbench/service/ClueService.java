package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    PaginationVO<Clue> pageList(Map<String, Object> map);

    boolean save(Clue clue);

    Clue getClueById(String id);

    boolean deleteByRelationId(String id);

    boolean bund(String[] ids,String clueId);

    boolean convert(String clueId, Tran tran, String createBy);

    Clue getClueById2(String id);

    boolean update(Clue clue);

    boolean delete(String[] id);

    Map<String, Object> getCharts();

    boolean deleteActivityClueRelation(List<String> idList);

    boolean deleteRelationByIds(String[] id);
}
