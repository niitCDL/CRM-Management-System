package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.jws.WebParam;
import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {

    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityRemarkService remarkService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ContactService contactService;


    @RequestMapping("/workbench/activity/getUserList.do")
    @ResponseBody
    public List<User> getUserList() {
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "workbench/activity/save.do")
    @ResponseBody
    public Map<String,Boolean> save(Activity activity, HttpServletRequest request) {
        Map<String,Boolean> map=new HashMap<>();
        map.put("success",false);
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag = activityService.save(activity);
        if (flag) {
            map.put("success",true);
        }
        return map;
    }

    @RequestMapping(value = "workbench/activity/pageList.do")
    @ResponseBody
    public PaginationVO<Activity> pageList(Activity activity, HttpServletRequest request){
        int pageNo=Integer.parseInt(request.getParameter("pageNo"));
        int pageSize=Integer.parseInt(request.getParameter("pageSize"));
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("Activity",activity);
        PaginationVO<Activity> activityVO = activityService.pageList(map);
        return activityVO;
    }

    @RequestMapping(value = "workbench/activity/delete.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> deleteActivityById(HttpServletRequest request){
        HashMap<String,Boolean> map=new HashMap<>();
        map.put("success",false);
        List<String> idList=new ArrayList();
        String[] ids = request.getParameterValues("id");
        for (String id : ids){
            idList.add(id);
        }
        //删除的记录条数
        boolean flag1 = remarkService.deleteByAids(idList);
        boolean flag2=  tranService.deleteByAids(idList);
        boolean flag3=clueService.deleteActivityClueRelation(idList);
        boolean flag4=contactService.deleteActivityContactRelation(idList);
        boolean flag5 = activityService.deleteById(idList);

        if(flag1&&flag2&&flag3&&flag4&&flag5){
            map.put("success",true);
        }
        return map;
    }


    @RequestMapping(value = "workbench/activity/getUserListandActivity.do")
    @ResponseBody
    public Map<String,Object> getUserListandActivity(HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        String id = request.getParameter("id");
        Activity activity = activityService.getActivityById(id);
        List<User> userList = userService.getUserList();
        map.put("activity",activity);
        map.put("userList",userList);
        return map;
    }

    @RequestMapping(value = "workbench/activity/update.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> update(Activity activity,HttpServletRequest request){
        HashMap<String,Boolean> map=new HashMap<>();
        map.put("success",false);
        activity.setId(request.getParameter("id"));
        activity.setEditBy(request.getParameter("editBy"));
        activity.setEditTime(DateTimeUtil.getSysTime());
        boolean flag=activityService.update(activity);
        if(flag){
            map.put("success",true);
        }
        return map;
    }

    //detail.do
    @RequestMapping(value = "workbench/activity/detail.do")
    public ModelAndView detail(HttpServletRequest request){
        ModelAndView model=new ModelAndView();
        String id = request.getParameter("id");
        Activity activity = activityService.getActivityById(id);
        model.addObject("a",activity);
        model.setViewName("detail.jsp");
        return model;
    }

    @RequestMapping(value = "workbench/activity/getRemark.do")
    @ResponseBody
    public List<ActivityRemark> getRemark(HttpServletRequest request){
        String id=request.getParameter("id");
        List<ActivityRemark> remarks = remarkService.getRemarkByAids(id);
        return remarks;
    }

    @RequestMapping(value = "workbench/activity/deleteRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteRemark(HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("success",false);
        String id=request.getParameter("id");
        boolean flag = remarkService.deleteRemark(id);
        if(flag){
            map.put("success",true);
        }
        return map;
    }

    @RequestMapping(value = "workbench/activity/saveRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveRemark(ActivityRemark remark,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("success",false);
        remark.setId(UUIDUtil.getUUID());
        remark.setActivityId(request.getParameter("Aid"));
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        boolean flag = remarkService.saveRemark(remark);
        if(flag){
            map.put("success",true);
        }
        return map;
    }

    @RequestMapping(value = "workbench/activity/updateRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> updateRemark(ActivityRemark remark,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        map.put("success",false);
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        remark.setEditFlag("1");
        boolean flag = remarkService.updateRemark(remark);
        if(flag){
            map.put("success",true);
        }
        return map;
    }


    //workbench/activity/getCharts.do
    @RequestMapping(value = "workbench/activity/getCharts.do")
    @ResponseBody
    public Map<String,Object> getCharts(){
        Map<String,Object> map=activityService.getCharts();
        return map;
    }

    @RequestMapping(value = "workbench/activity/updateActivity.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> updateActivity(Activity activity,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        activity.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = activityService.updateActivity(activity);
        map.put("success",flag);
        return map;
    }
}
