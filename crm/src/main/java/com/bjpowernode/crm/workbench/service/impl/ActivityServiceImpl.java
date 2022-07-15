package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("ActivityService")
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityDao activityDao;

    @Override
    public boolean save(Activity activity) {
        int count = activityDao.save(activity);
        if(count<1){
            return false;
        }
        return true;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {
        PaginationVO<Activity> Info=new PaginationVO<>();
        int total = activityDao.getTotalByCondition(map);
        List<Activity> pageActivity = activityDao.getActivityByCondition(map);
        Info.setActivities(pageActivity);
        Info.setTotal(total);
        return Info;
    }

    @Override
    @Transactional
    public boolean deleteById(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            flag=activityDao.deleteById(id)>0?true:false;
        }
        return flag;
    }

    @Override
    public Activity getActivityById(String id) {
        Activity activity = activityDao.getActivityById(id);
        return activity;
    }

    @Override
    public boolean update(Activity activity) {
        int count=activityDao.update(activity);
        if(count<1){
            return false;
        }
        return true;
    }

    @Override
    public List<Activity> getActivityByClueId(String clueId) {
        List<Activity> activityList=activityDao.getActivityByClueId(clueId);
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByNameNotByClueId(Map<String,String> map) {
        List<Activity> activityList=activityDao.getActivityListByNameNotByClueId(map);
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByName(String aname) {
        List<Activity> activityList=activityDao.getActivityListByName(aname);
        return activityList;
    }

    @Override
    public Map<String, Object> getCharts() {
        Map<String, Object> map=new HashMap<>();
        List<Map<String,Integer>> dataList=activityDao.getCharts();
        map.put("dataList",dataList);
        return map;
    }

    @Override
    public boolean updateActivity(Activity activity) {
        return activityDao.updateActivity(activity);
    }

    @Override
    public List<Activity> getActivityByNameNotAid(String aid, String aname) {
        return activityDao.getActivityByNameNotAid(aid,aname);
    }

    @Override
    public List<Activity> getActivityByCon(String aname) {
        return activityDao.getActivityByCon(aname);
    }
}
