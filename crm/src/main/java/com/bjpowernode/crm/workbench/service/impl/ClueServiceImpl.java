package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("ClueService")
public class ClueServiceImpl implements ClueService {
    //线索
    @Autowired
    private ClueDao clueDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;

    //客户
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    //联系人
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;

    //交易
    @Autowired
    private TranDao tranDao;
    //交易历史
    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Override
    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        PaginationVO<Clue> Info=new PaginationVO<>();
        int total = clueDao.getTotalByCondition(map);
        List<Clue> pageActivity = clueDao.getClueByCondition(map);
        Info.setActivities(pageActivity);
        Info.setTotal(total);
        return Info;
    }

    @Override
    public boolean save(Clue clue) {
        int count = clueDao.save(clue);
        if(count<1){
            return false;
        }
        return true;
    }

    @Override
    public Clue getClueById(String id) {
        Clue clue=clueDao.getClueById(id);
        return clue;
    }

    @Override
    public boolean deleteByRelationId(String id) {
        int count=clueActivityRelationDao.deleteByRelationId(id);
        return count>=1;
    }

    @Override
    public boolean bund(String[] ids,String clueId) {
        for(String id : ids){
            ClueActivityRelation relation=new ClueActivityRelation();
            relation.setId(UUIDUtil.getUUID());
            relation.setClueId(clueId);
            relation.setActivityId(id);
            System.out.println(id.length());
            int count=clueActivityRelationDao.bund(relation);
            if(count<1){
                return false;
            }
        }
        return true;
    }

    @Override
    @Transactional
    public boolean convert(String clueId, Tran tran, String createBy) {
        String createTime= DateTimeUtil.getSysTime();
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue=clueDao.getClueByConvert(clueId);
        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！
        Customer cus=customerDao.getCustomerByName(clue.getCompany());
        if(cus==null){
            cus=new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setCreateBy(createBy);
            cus.setCreateTime(createTime);
            cus.setDescription(clue.getDescription());
            cus.setName(clue.getCompany());
            cus.setOwner(clue.getOwner());
            cus.setAddress(clue.getAddress());
            cus.setContactSummary(clue.getContactSummary());
            cus.setNextContactTime(clue.getNextContactTime());
            cus.setWebsite(clue.getWebsite());
            cus.setPhone(clue.getPhone());
            int count1 = customerDao.save(cus);
            if(count1<1){
                return false;
            }
        }
        //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contacts=new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(cus.getId());
        contacts.setContactSummary(clue.getContactSummary());
        int count2=contactsDao.save(contacts);
        if (count2<1){
            return false;
        }
        //(4) 线索备注转换到客户备注以及联系人备注
        List<ClueRemark> clueRemarkList=clueRemarkDao.getnoteContentByClueId(clueId);
        for(ClueRemark clueRemark : clueRemarkList){
            CustomerRemark customerRemark=new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setCustomerId(cus.getId());
            int count3=customerRemarkDao.save(customerRemark);
            if (count3<1){
                return false;
            }

            ContactsRemark contactsRemark=new ContactsRemark();
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            int count10=contactsRemarkDao.save(contactsRemark);
            if (count10<1){
                return false;
            }
        }

        //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> clueActivityRelationList=clueActivityRelationDao.getclueActivityRelationByClueId(clueId);
        for(ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            ContactsActivityRelation contactsActivityRelation=new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelation.setContactsId(clueId);
            int count4=contactsActivityRelationDao.save(contactsActivityRelation);
            if (count4<1){
                return false;
            }
        }
        //(6) 如果有创建交易需求，创建一条交易
        if(tran!=null){
            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(clue.getOwner());
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(cus.getId());
            tran.setContactSummary(contacts.getContactSummary());
            tran.setCreateBy(createBy);
            tran.setCreateTime(createTime);
            tran.setSource(clue.getSource());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            int count5=tranDao.save(tran);
            if (count5<1){
                return false;
            }
            //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory=new TranHistory();
            tranHistory.setCreateBy(tran.getCreateBy());
            tranHistory.setCreateTime(tran.getCreateTime());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setTranId(tran.getId());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            int count6=tranHistoryDao.save(tranHistory);
            if (count6<1){
                return false;
            }
        }
        //(8) 删除线索备注
        if(clueRemarkDao.getnoteContentByClueId(clueId).size()>0){
            int count7=clueRemarkDao.delete(clueId);
            if (count7<1){
                return false;
            }
        }
        //(9) 删除线索和市场活动的关系
        if(clueActivityRelationDao.getclueActivityRelationByClueId(clueId).size()>0){
            int count8=clueActivityRelationDao.delete(clueId);
            if (count8<1){
                return false;
            }
        }

        //删除线索
        int count9=clueDao.delete(clueId);
        if (count9<1){
            return false;
        }

        return true;
    }

    @Override
    public Clue getClueById2(String id) {
        return clueDao.getClueById2(id);
    }

    @Override
    public boolean update(Clue clue) {
        return clueDao.update(clue)>0?true:false;
    }

    @Override
    @Transactional
    public boolean delete(String[] ids) {
        boolean flag=true;
        for (String id : ids){
            flag=clueDao.delete(id)>0?true:false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        Map<String, Object> map=new HashMap<>();
        List<Map<String,Integer>> dataList=clueDao.getCharts();
        int total=clueDao.getChartsTotal();
        map.put("dataList",dataList);
        map.put("total",total);
        return map;
    }

    @Transactional
    @Override
    public boolean deleteActivityClueRelation(List<String> idList) {
        boolean flag=true;
        for (String id : idList){
            if(clueActivityRelationDao.getRelationByAid(id).size()>0){
                flag=clueActivityRelationDao.deleteActivityClueRelation(id)>0;
            }
        }
        return flag;
    }

    @Transactional
    @Override
    public boolean deleteRelationByIds(String[] ids) {
        boolean flag=true;
        for (String id : ids){
            if(clueActivityRelationDao.getRelationByCid(id).size()>0){
                flag=clueActivityRelationDao.deleteByCid(id)>0;
            }
        }
        return flag;
    }
}
