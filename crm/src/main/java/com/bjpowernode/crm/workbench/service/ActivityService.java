package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityService {


    boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean deleteById(List<String> idList);

    Activity getActivityById(String id);

    boolean update(Activity activity);

    List<Activity> getActivityByClueId(String clueId);

    List<Activity> getActivityListByNameNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);

    Map<String, Object> getCharts();

    boolean updateActivity(Activity activity);

    List<Activity> getActivityByNameNotAid( String aid,String aname);

    List<Activity> getActivityByCon(String aname);
}
