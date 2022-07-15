package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ClueDao;
import com.bjpowernode.crm.workbench.dao.ClueRemarkDao;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkDao clueRemarkDao;


    @Override
    public List<ClueRemark> getRemarkList(String id) {
        return clueRemarkDao.getRemarkList(id);
    }

    @Override
    public boolean deleteRemark(String id) {
        return clueRemarkDao.deleteRemark(id)>0?true:false;
    }

    @Override
    public boolean saveRemark(ClueRemark clueRemark) {
        return clueRemarkDao.saveRemark(clueRemark)>0?true:false;
    }

    @Override
    public boolean updateRemark(ClueRemark clueRemark) {
        return clueRemarkDao.updateRemark(clueRemark)>0?true:false;
    }

    @Transactional
    @Override
    public boolean deleteRemarkByIds(String[] ids) {
        boolean flag=true;
        for (String id : ids){
            if(clueRemarkDao.getRemarkList(id).size()>0){
                flag=clueRemarkDao.deleteByCid(id)>0;
            }
        }
        return flag;
    }
}
