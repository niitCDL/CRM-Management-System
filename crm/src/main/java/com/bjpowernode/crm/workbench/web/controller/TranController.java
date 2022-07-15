package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactService;
import com.bjpowernode.crm.workbench.service.CustomerService;
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
import java.io.InputStream;
import java.util.*;

@Controller
public class TranController {

    @Autowired
    private TranService tranService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactService contactService;

    @RequestMapping(value = "workbench/transaction/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "workbench/transaction/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){
        List<String> nList=customerService.getCustomerName(name);
        return nList;
    }
    //workbench/transaction/saveTran.do
    @RequestMapping(value = "workbench/transaction/saveTran.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveTran(String customerName, Tran tran, HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("success",true);
        tran.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag=tranService.saveTran(tran,customerName,((User) request.getSession().getAttribute("user")).getName());
        if(!flag){
            map.put("success",false);
        }
        return map;
    }

    //workbench/transaction/pageList.do
    @RequestMapping(value = "workbench/transaction/pageList.do")
    @ResponseBody
    public PaginationVO<Tran> pageList(Tran tran, HttpServletRequest request){
        int pageNo=Integer.parseInt(request.getParameter("pageNo"));
        int pageSize=Integer.parseInt(request.getParameter("pageSize"));
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("Tran",tran);
        PaginationVO<Tran> transactionVO = tranService.pageList(map);
        return transactionVO;
    }

    @RequestMapping(value = "workbench/transaction/detail.do")
    public ModelAndView detail(HttpServletRequest request, HttpServletResponse response){
        ModelAndView model=new ModelAndView();
        String id = request.getParameter("id");
        Tran tran = tranService.getTranById(id);
        String possibility="";
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        possibility=pMap.get(tran.getStage());
        tran.setPossibility(possibility);
        model.addObject("t",tran);
        model.setViewName("detail.jsp");
        return model;
    }

    //workbench/transaction/getTranHistoryListById.do
    @RequestMapping(value = "workbench/transaction/getTranHistoryListById.do")
    @ResponseBody
    public List<TranHistory> getTranHistoryListById(String tranId,HttpServletRequest request){
        List<TranHistory> tranHistoryList=tranService.getTranHistoryListById(tranId);
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        for (TranHistory tranHistory : tranHistoryList){
            String possibility = pMap.get(tranHistory.getStage());
            tranHistory.setPossibility(possibility);
        }
        return tranHistoryList;
    }

    //workbench/transaction/changeStage.do
    @RequestMapping(value = "workbench/transaction/changeStage.do")
    @ResponseBody
    public Map<String,Object> changeStage(Tran tran,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        String sysTime = DateTimeUtil.getSysTime();
        String username = ((User) request.getSession().getAttribute("user")).getName();
        tran.setEditTime(sysTime);
        tran.setEditBy(username);
        boolean flag=tranService.changeStage(tran);
        if(flag){
            map.put("success",true);
            Tran tran1 = tranService.getTranById(tran.getId());
            tran1.setPossibility(pMap.get(tran1.getStage()));
            map.put("t",tran1);
        }else {
            map.put("success",false);
        }
        return map;
    }

    //workbench/transaction/getCharts.do
    @RequestMapping(value = "workbench/transaction/getCharts.do")
    @ResponseBody
    public Map<String,Object> getCharts(){
        Map<String,Object> map=tranService.getCharts();
        return map;
    }

    //workbench/transaction/edit.do
    @RequestMapping(value = "workbench/transaction/edit.do")
    public ModelAndView editdetail(String id,HttpServletRequest request){
        ModelAndView mv=new ModelAndView();
        Tran tran = tranService.getTranById(id);
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);
        mv.addObject("t",tran);
        mv.setViewName("edit.jsp");
        return mv;
    }


    //workbench/transaction/getTran.do
    @RequestMapping(value = "workbench/transaction/getTran.do")
    @ResponseBody
    public Tran getTran(String id){
        Tran tran=tranService.getTran(id);
        return tran;
    }


    @RequestMapping(value = "workbench/transaction/getPossibility.do")
    @ResponseBody
    public String getPossibility(String stage,HttpServletRequest request){
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        String possibility = pMap.get(stage);
        return possibility;
    }

    @RequestMapping(value = "workbench/transaction/deleteTran.do")
    @ResponseBody
    public Map<String,Object> deleteTran(String id[]){
        Map<String,Object> map=new HashMap<>();
        boolean flag1=tranService.deleteHistoryByids(id);
        boolean flag2=tranService.deleteRemarkByids(id);
        boolean flag3=tranService.deleteByids(id);
        if(flag1&&flag2&&flag3){
            map.put("success",true);
        }else {
            map.put("success",false);
        }
        return map;
    }
    //workbench/transaction/getActivityByName.do
    @RequestMapping(value = "workbench/transaction/getActivityByName.do")
    @ResponseBody
    public List<Activity> getActivityByName(String aid,String aname){
        List<Activity> activities=activityService.getActivityByNameNotAid(aid,aname);
        return activities;
    }

    //workbench/transaction/update.do
    @RequestMapping(value = "workbench/transaction/update.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> update(Tran tran,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        String sysTime = DateTimeUtil.getSysTime();
        String username = ((User) request.getSession().getAttribute("user")).getName();
        tran.setEditTime(sysTime);
        tran.setEditBy(username);
        boolean flag=tranService.update(tran,username);
        map.put("success",flag);
        return map;
    }

    //workbench/transaction/getContacts.do
    @RequestMapping(value = "workbench/transaction/getContacts.do")
    @ResponseBody
    public List<Contacts> getContacts(String con,String name, HttpServletRequest request){
        List<Contacts> contactsList=contactService.getContacts(con,name);
        return contactsList;
    }

    //"workbench/transaction/getActivityByCon.do"
    @RequestMapping(value = "workbench/transaction/getActivityByCon.do")
    @ResponseBody
    public List<Activity> getActivityByCon(String aname){
        List<Activity> activities=activityService.getActivityByCon(aname);
        return activities;
    }

    //workbench/transaction/getContactsByName.do
    @RequestMapping(value = "workbench/transaction/getContactsByName.do")
    @ResponseBody
    public List<Contacts> getContactsByName(String name){
        List<Contacts> contactsList=contactService.getContactsByName(name);
        return contactsList;
    }

    //workbench/transaction/getRemarkList.do
    @RequestMapping(value = "workbench/transaction/getRemarkList.do")
    @ResponseBody
    public List<TranRemark> getRemarkList(String id){
        List<TranRemark> tranRemarkList=tranService.getRemarkList(id);
        return tranRemarkList;
    }

    //workbench/transaction/deleteRemark.do
    @RequestMapping(value = "workbench/transaction/deleteRemark.do")
    @ResponseBody
    public Map<String,Boolean> deleteRemark(String id){
        Map<String,Boolean> map=new HashMap<>();
        boolean flag=tranService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    //workbench/clue/updateRemark.do
    @RequestMapping(value = "workbench/transaction/updateRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> updateRemark(TranRemark remark,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        remark.setEditFlag("1");
        remark.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        remark.setEditTime(DateTimeUtil.getSysTime());
        boolean flag=tranService.updateRemark(remark);
        map.put("success",flag);
        return map;
    }

    //workbench/transaction/saveRemark.do
    @RequestMapping(value = "workbench/transaction/saveRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> saveRemark(TranRemark remark,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag=tranService.saveRemark(remark);
        map.put("success",flag);
        return map;
    }

}
