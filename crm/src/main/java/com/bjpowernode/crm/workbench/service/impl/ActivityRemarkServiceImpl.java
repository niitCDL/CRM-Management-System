package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("ActivityRemark")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkDao remarkDao;


    @Override
    @Transactional
    public boolean deleteByAids(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            if(remarkDao.getRemarkByAid(id).size()>0){
                flag=remarkDao.deleteByAid(id)>0?true:false;
            }
        }
        return flag;
    }

    @Override
    public List<ActivityRemark> getRemarkByAids(String id) {
        List<ActivityRemark> remark=remarkDao.getRemarkByAids(id);
        return remark;
    }

    @Override
    public boolean deleteRemark(String id) {
        int count=remarkDao.deleteRemarkByAid(id);
        if(count<1){
            return false;
        }
        return true;
    }

    @Override
    public boolean saveRemark(ActivityRemark remark) {
        int count=remarkDao.insertRemark(remark);
        if(count<1){
            return false;
        }
        return true;
    }

    @Override
    public boolean updateRemark(ActivityRemark remark) {
        int count=remarkDao.updateRemark(remark);
        if(count<1){
            return false;
        }
        return true;
    }
}
