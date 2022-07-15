package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    int save(Activity activity);

    List<Activity> getActivityByCondition(Map<String,Object> map);

    int getTotalByCondition(Map<String,Object> map);

    int deleteById(String id);

    Activity getActivityById(String id);

    int update(Activity activity);

    List<Activity> getActivityByClueId(String clueId);

    List<Activity> getActivityListByNameNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);

    List<Map<String, Integer>> getCharts();

    boolean updateActivity(Activity activity);

    List<Activity> getActivityByNameNotAid(@Param(value = "aid")String aid, @Param(value = "aname")String aname);

    List<Activity> getActivityByCon(String aname);
}
