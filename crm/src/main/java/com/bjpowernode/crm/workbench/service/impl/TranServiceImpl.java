package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.dao.TranRemarkDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranDao tranDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;
    @Autowired
    private TranRemarkDao tranRemarkDao;

    @Override
    @Transactional
    public boolean saveTran(Tran tran, String customerName,String createBy) {
        Customer customer = customerDao.getCustomerByName(customerName);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(createBy);
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setDescription(tran.getDescription());
            customer.setOwner(tran.getOwner());
            customer.setWebsite("www.baidu.com");
            customer.setName(customerName);
            customer.setPhone("123456789");
            customer.setAddress("杭州");
            customerDao.save(customer);
        }
        tran.setId(UUIDUtil.getUUID());
        tran.setCustomerId(customer.getId());
        tranDao.save(tran);
        TranHistory tranHistory=new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setCreateBy(createBy);
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistoryDao.save(tranHistory);
        return true;
    }

    @Override
    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        PaginationVO<Tran> Info=new PaginationVO<>();
        int total = tranDao.getTotalByCondition(map);
        List<Tran> pageTransaction = tranDao.getTranByCondition(map);
        Info.setActivities(pageTransaction);
        Info.setTotal(total);
        return Info;
    }

    @Override
    public Tran getTranById(String id) {
        return tranDao.getTranById(id);
    }

    @Override
    public List<TranHistory> getTranHistoryListById(String tranId) {

        return tranHistoryDao.getTranHistoryListById(tranId);
    }

    @Override
    public boolean changeStage(Tran tran) {
        boolean flag=true;
        flag=tranDao.changeStage(tran)>0?true:false;
        TranHistory tranHistory=new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateTime(tran.getEditTime());
        tranHistory.setStage(tran.getStage());
        flag=tranHistoryDao.addTranHistory(tranHistory)>0?true:false;
        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        //total stageList numberList
        Map<String,Object> map=new HashMap<>();
        int total=tranDao.getTotal();
        List<Map<String,Integer>> stageList=tranDao.getCharts();
        map.put("total",total);
        map.put("dataList",stageList);
        return map;
    }

    @Override
    public Tran getTran(String id) {
        return tranDao.getTran(id);
    }

    @Transactional
    @Override
    public boolean deleteByAids(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            List<Tran> tranList = tranDao.getTranListByAId(id);
            if(tranList.size()>0){
                for (Tran tran : tranList){
                    if(tranHistoryDao.getTranHistoryByid(tran.getId()).size()>0){
                        flag=tranHistoryDao.deleteByid(tran.getId())>0;
                    }
                    if(tranRemarkDao.getRemarkByTranId(tran.getId()).size()>0){
                        flag=tranRemarkDao.deleteByTranId(tran.getId())>0;
                    }
                }
                if(flag){
                    flag=tranDao.deleteByAid(id)>0;
                }
            }
        }
        return flag;
    }

    @Transactional
    @Override
    public boolean deleteByids(String[] ids) {
        boolean flag=true;
        for (String id : ids){
            flag=tranDao.deleteByid(id)>0;
        }
        return flag;
    }

    @Transactional
    @Override
    public boolean deleteHistoryByids(String[] ids) {
        boolean flag=true;
        for (String id : ids){
            if(tranHistoryDao.getTranHistoryListById(id).size()>0){
                flag=tranHistoryDao.deleteByid(id)>0;
            }
        }
        return flag;
    }

    @Override
    public boolean update(Tran tran,String createBy) {
        Customer customer = customerDao.getCustomerByName(tran.getCustomerName());
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(createBy);
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setDescription(tran.getDescription());
            customer.setOwner(tran.getOwner());
            customer.setWebsite("www.baidu.com");
            customer.setName(tran.getCustomerName());
            customer.setPhone("123456789");
            customer.setAddress("杭州");
            customerDao.save(customer);
        }
        tran.setCustomerId(customer.getId());
        return tranDao.update(tran)>0;
    }

    @Override
    public List<TranRemark> getRemarkList(String id) {
        return tranRemarkDao.getRemarkList(id);
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag=true;
        if(tranRemarkDao.getRemarkByTranId(id).size()>0){
            flag=tranRemarkDao.deleteRemark(id)>0;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(TranRemark remark) {
        return tranRemarkDao.updateRemark(remark)>0;
    }

    @Override
    public boolean saveRemark(TranRemark remark) {
        return tranRemarkDao.saveRemark(remark)>0;
    }

    @Transactional
    @Override
    public boolean deleteRemarkByids(String[] ids) {
        boolean flag=true;
        for (String id : ids){
            if(tranRemarkDao.getRemarkByTranId(id).size()>0){
                flag=tranRemarkDao.deleteByTranId(id)>0;
            }
        }
        return flag;
    }

    @Transactional
    @Override
    public boolean deleteByCids(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            List<Tran> tranList = tranDao.getTranListByCId(id);
            if(tranList.size()>0){
                for (Tran tran : tranList){
                    if(tranHistoryDao.getTranHistoryByid(tran.getId()).size()>0){
                        flag=tranHistoryDao.deleteByid(tran.getId())>0;
                    }
                    if(tranRemarkDao.getRemarkByTranId(tran.getId()).size()>0){
                        flag=tranRemarkDao.deleteByTranId(tran.getId())>0;
                    }
                }
                if(flag){
                    flag=tranDao.deleteByCid(id)>0;
                }
            }
        }
        return flag;
    }

    @Override
    public List<Tran> getTranByCid(String cid) {
        return tranDao.getTranListByCId(cid);
    }

    @Transactional
    @Override
    public boolean deleteTranByConids(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            List<Tran> tranList = tranDao.getTranListByConId(id);
            if(tranList.size()>0){
                for (Tran tran : tranList){
                    if(tranHistoryDao.getTranHistoryByid(tran.getId()).size()>0){
                        flag=tranHistoryDao.deleteByid(tran.getId())>0;
                    }
                    if(tranRemarkDao.getRemarkByTranId(tran.getId()).size()>0){
                        flag=tranRemarkDao.deleteByTranId(tran.getId())>0;
                    }
                }
                if(flag){
                    flag=tranDao.deleteByConid(id)>0;
                }
            }
        }
        return flag;
    }

    @Override
    public List<Tran> getTranByConid(String conid) {
        return tranDao.getTranListByConId(conid);
    }


}
