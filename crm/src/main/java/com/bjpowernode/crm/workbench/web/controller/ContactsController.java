package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.dao.ContactsRemarkDao;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ContactService;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactsController {
    @Autowired
    private ContactService contactService;
    @Autowired
    private UserService userService;
    @Autowired
    private TranService tranService;

    @RequestMapping(value = "workbench/contact/pageList.do")
    @ResponseBody
    public PaginationVO<Contacts> pageList(Contacts contacts, HttpServletRequest request){
        int pageNo=Integer.parseInt(request.getParameter("pageNo"));
        int pageSize=Integer.parseInt(request.getParameter("pageSize"));
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("Contact",contacts);
        PaginationVO<Contacts> contactsPaginationVO = contactService.pageList(map);
        return contactsPaginationVO;
    }

    @RequestMapping(value = "workbench/contact/save.do")
    @ResponseBody
    public Map<String,Boolean> save(Contacts contacts, HttpServletRequest request) {
        Map<String,Boolean> map=new HashMap<>();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag = contactService.saveContact(contacts);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/contact/getUserListandContact.do")
    @ResponseBody
    public Map<String,Object> getUserListandActivity(String id,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        Contacts contacts = contactService.getContactById(id);
        List<User> userList = userService.getUserList();
        map.put("contact",contacts);
        map.put("userList",userList);
        return map;
    }

    @RequestMapping(value = "workbench/contact/update.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> update(Contacts contacts,HttpServletRequest request){
        HashMap<String,Boolean> map=new HashMap<>();
        contacts.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        contacts.setEditTime(DateTimeUtil.getSysTime());
        boolean flag=contactService.update(contacts);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/contact/delete.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> deleteContact(HttpServletRequest request){
        HashMap<String,Boolean> map=new HashMap<>();
        List<String> idList=new ArrayList();
        String[] ids = request.getParameterValues("id");
        for (String id : ids){
            idList.add(id);
        }
        //删除的记录条数
        boolean flag1 = tranService.deleteTranByConids(idList);
        boolean flag2 = contactService.deleteByConids(idList);
        if(flag1&&flag2){
            map.put("success",true);
        }
        return map;
    }

    @RequestMapping(value = "workbench/contact/detail.do")
    public ModelAndView detail(String id,HttpServletRequest request){
        ModelAndView model=new ModelAndView();
        Contacts contacts = contactService.getContactById(id);
        model.addObject("con",contacts);
        model.setViewName("/workbench/contacts/detail.jsp");
        return model;
    }

    @RequestMapping(value = "workbench/contact/getRemark.do")
    @ResponseBody
    public List<ContactsRemark> getRemark(String id, HttpServletRequest request){
        List<ContactsRemark> remarks = contactService.getRemarkByConid(id);
        return remarks;
    }

    @RequestMapping(value = "workbench/contact/saveRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveRemark(ContactsRemark remark,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        boolean flag = contactService.saveRemark(remark);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/contact/updateRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> updateRemark(ContactsRemark remark,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        remark.setEditFlag("1");
        remark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        remark.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = contactService.updateRemark(remark);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/contact/deleteRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteRemark(String id,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        boolean flag = contactService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    //workbench/contact/forwardTran.do
    @RequestMapping(value = "workbench/contact/forwardTran.do")
    @ResponseBody
    public ModelAndView forwardTransave(String conid, String conname){
        ModelAndView md=new ModelAndView();
        md.setViewName("/workbench/transaction/save.jsp?conid="+conid+"&conname="+conname+"");
        return md;
    }

    @RequestMapping(value = "workbench/contact/getTranByConid.do")
    @ResponseBody
    public List<Tran> getTranByConid(String conid, HttpServletRequest request){
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        List<Tran> tranList = tranService.getTranByConid(conid);
        for (Tran tran : tranList){
            tran.setPossibility(pMap.get(tran.getStage()));
        }
        return tranList;
    }

    @RequestMapping(value = "workbench/contact/delTranBtn.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> delTranBtn(String tid,HttpServletRequest request){
        Map<String,Boolean> map= new HashMap<>();
        boolean flag1=tranService.deleteRemark(tid);
        boolean flag2=tranService.deleteHistoryByids(new String[]{tid});
        boolean flag3=tranService.deleteByids(new String[]{tid});
        if(flag1&&flag2&&flag3){
            map.put("success",true);
        }else {
            map.put("success",false);
        }
        return map;
    }

    @RequestMapping(value = "workbench/contact/getActivityList.do")
    @ResponseBody
    public List<Activity> getActivityList(String conid,HttpServletRequest request){
        List<Activity> activityList=contactService.getActivityByConId(conid);
        return activityList;
    }

    @RequestMapping(value = "workbench/contact/deleteByRelationId.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteByRelationId(String id,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        boolean flag = contactService.deleteByRelationId(id);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/contact/getActivityListByNameNotByConId.do")
    @ResponseBody
    public List<Activity> getActivityListByNameNotByConId(String aname,String conid){
        List<Activity> activityList=contactService.getActivityListByNameNotByConId(aname,conid);
        return activityList;
    }

    @RequestMapping(value = "workbench/contact/bund.do")
    @ResponseBody
    public Map<String,Object> bund(String conid,String id[],HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        boolean flag = contactService.bund(id,conid);
        map.put("success",flag);
        return map;
    }

    //workbench/contact/update.do
    @RequestMapping(value = "workbench/contact/update.do")
    @ResponseBody
    public Map<String,Object> bund(Contacts contacts,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        boolean flag = contactService.update(contacts);
        map.put("success",flag);
        return map;
    }

}
