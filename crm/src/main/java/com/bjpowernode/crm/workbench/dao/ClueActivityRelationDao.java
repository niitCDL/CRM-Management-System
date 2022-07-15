package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {


    int deleteByRelationId(String id);

    int bund(ClueActivityRelation relation);

    List<ClueActivityRelation> getclueActivityRelationByClueId(String clueId);

    int delete(String clueId);

    int deleteActivityClueRelation(String id);

    List<ClueActivityRelation> getRelationByAid(String id);

    List<ClueActivityRelation> getRelationByCid(String id);

    int deleteByCid(String id);
}
