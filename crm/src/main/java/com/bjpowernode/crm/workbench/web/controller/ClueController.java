package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClueController {
    @Autowired
    private ClueService clueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping(value = "workbench/clue/getUserList.do")
    @ResponseBody
    public List<User> getUserList() {
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "workbench/clue/save.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> save(Clue clue, HttpServletRequest request) {
        Map<String,Boolean> map=new HashMap<>();
        map.put("success",false);
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag = clueService.save(clue);
        if (flag) {
            map.put("success",true);
        }
        return map;
    }


    @RequestMapping(value = "workbench/clue/pageList.do")
    @ResponseBody
    public PaginationVO<Clue> pageList(Clue clue, HttpServletRequest request){
        System.out.println(clue);
        int pageNo=Integer.parseInt(request.getParameter("pageNo"));
        int pageSize=Integer.parseInt(request.getParameter("pageSize"));
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("Clue",clue);
        PaginationVO<Clue> ClueVO = clueService.pageList(map);
        return ClueVO;
    }

    @RequestMapping(value = "workbench/clue/detail.do")
    public ModelAndView detail(HttpServletRequest request, HttpServletResponse response){
        ModelAndView model=new ModelAndView();
        String id = request.getParameter("id");
        Clue clue = clueService.getClueById(id);
        model.addObject("c",clue);
        model.setViewName("detail.jsp");
        return model;
    }

//    workbench/clue/getActivityList.do


    @RequestMapping(value = "workbench/clue/getActivityList.do")
    @ResponseBody
    public List<Activity> getActivityList(String clueId,HttpServletRequest request){
        List<Activity> activityList=activityService.getActivityByClueId(clueId);
        return activityList;
    }


    @RequestMapping(value = "workbench/clue/deleteByRelationId.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteRemark(String id,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("success",false);
        boolean flag = clueService.deleteByRelationId(id);
        if(flag){
            map.put("success",true);
        }
        return map;
    }

    @RequestMapping(value = "workbench/clue/getActivityListByNameNotByClueId.do")
    @ResponseBody
    public List<Activity> getActivityListByNameNotByClueId(String aname,String clueId){
        Map<String,String> map=new HashMap<>();
        map.put("aname",aname);
        map.put("clueId",clueId);
        List<Activity> activityList=activityService.getActivityListByNameNotByClueId(map);
        return activityList;
    }

    @RequestMapping(value = "workbench/clue/bund.do")
    @ResponseBody
    public Map<String,Object> bund(String clueId,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("success",false);
        String[] ids = request.getParameterValues("id");
        boolean flag = clueService.bund(ids,clueId);
        if(flag){
            map.put("success",true);
        }
        return map;
    }

    @RequestMapping(value = "workbench/clue/getActivityListByName.do")
    @ResponseBody
    public List<Activity> getActivityListByName(String aname){
        List<Activity> activityList=activityService.getActivityListByName(aname);
        return activityList;
    }


    @RequestMapping(value = "workbench/clue/convert.do",method = {RequestMethod.POST,RequestMethod.GET})
    public void convert(HttpServletRequest request,HttpServletResponse response,Tran tran1) throws IOException {
        String clueId = request.getParameter("clueId");
        String createBy=((User) request.getSession().getAttribute("user")).getName();
        String Flag = request.getParameter("flag");
        Tran tran=null;
        if("true".equals(Flag)){
            tran=tran1;
        }
        boolean flag=clueService.convert(clueId,tran,createBy);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/"+"workbench/clue/index.jsp");
        }
    }

    @RequestMapping(value = "workbench/clue/getClueById.do")
    @ResponseBody
    public Clue getClueById(String id,HttpServletRequest request){
        Clue clue = clueService.getClueById2(id);
        return clue;
    }

    @RequestMapping(value = "workbench/clue/update.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> update(Clue clue,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User) request.getSession().getAttribute("user")).getName();
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        boolean flag=clueService.update(clue);
        map.put("success",flag);
        return map;
    }

    //workbench/clue/delete.do
    @RequestMapping(value = "workbench/clue/delete.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> delete(String[] id,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        boolean flag1=clueRemarkService.deleteRemarkByIds(id);
        boolean flag2=clueService.deleteRelationByIds(id);
        boolean flag3=clueService.delete(id);
        if(flag1&&flag2&&flag3){
            map.put("success",true);
        }
        return map;
    }


    @RequestMapping(value = "workbench/clue/getRemarkList.do")
    @ResponseBody
    public List<ClueRemark> getRemarkList(String id, HttpServletRequest request){
        List<ClueRemark> remarkList=clueRemarkService.getRemarkList(id);
        return remarkList;
    }

    //workbench/clue/deleteRemark.do
    @RequestMapping(value = "workbench/clue/deleteRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> getRemarkList(String id){
        Map<String,Boolean> map=new HashMap<>();
        boolean flag=clueRemarkService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    //workbench/clue/saveRemark.do
    @RequestMapping(value = "workbench/clue/saveRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> saveRemark(ClueRemark clueRemark,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag=clueRemarkService.saveRemark(clueRemark);
        map.put("success",flag);
        return map;
    }
    //workbench/clue/updateRemark.do
    @RequestMapping(value = "workbench/clue/updateRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> updateRemark(ClueRemark clueRemark,HttpServletRequest request){
        Map<String,Boolean> map=new HashMap<>();
        clueRemark.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("1");
        boolean flag=clueRemarkService.updateRemark(clueRemark);
        map.put("success",flag);
        return map;
    }

    //workbench/clue/getCharts.do
    @RequestMapping(value = "workbench/clue/getCharts.do")
    @ResponseBody
    public Map<String,Object> getCharts(){
        Map<String,Object> map=clueService.getCharts();
        return map;
    }


}
