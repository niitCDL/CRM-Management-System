package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.*;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranService tranService;
    @Autowired
    private UserService userService;
    @Autowired
    private ContactService contactService;

    //workbench/customer/pageList.do
    @RequestMapping(value = "workbench/customer/pageList.do")
    @ResponseBody
    public PaginationVO<Customer> pageList(Customer customer, HttpServletRequest request){
        System.out.println("进入了控制器");
        int pageNo=Integer.parseInt(request.getParameter("pageNo"));
        int pageSize=Integer.parseInt(request.getParameter("pageSize"));
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("Customer",customer);
        PaginationVO<Customer> customerVO = customerService.pageList(map);
        return customerVO;
    }

    //workbench/customer/save.do
    @RequestMapping(value = "workbench/customer/save.do")
    @ResponseBody
    public Map<String,Boolean> save(Customer customer, HttpServletRequest request) {
        Map<String,Boolean> map=new HashMap<>();
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag = customerService.save(customer);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/customer/delete.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> deleteCustomerById(HttpServletRequest request){
        HashMap<String,Boolean> map=new HashMap<>();
        map.put("success",false);
        List<String> idList=new ArrayList();
        String[] ids = request.getParameterValues("id");
        for (String id : ids){
            idList.add(id);
        }
        //删除的记录条数
        boolean flag1=tranService.deleteByCids(idList);
        boolean flag2 = customerService.deleteByCids(idList);
        if(flag1&&flag2){
            map.put("success",true);
        }
        return map;
    }

    //workbench/customer/getUserListandCustomer.do
    @RequestMapping(value = "workbench/customer/getUserListandCustomer.do")
    @ResponseBody
    public Map<String,Object> getUserListandCustomer(String id,HttpServletRequest request){
        HashMap<String,Object> map=new HashMap<>();
        List<User> userList = userService.getUserList();
        Customer customer=customerService.getCustomerByid(id);
        map.put("userList",userList);
        map.put("customer",customer);
        return map;
    }

    //workbench/customer/update.do
    @RequestMapping(value = "workbench/customer/update.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> update(Customer customer,HttpServletRequest request){
        HashMap<String,Boolean> map=new HashMap<>();
        customer.setId(request.getParameter("id"));
        customer.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        customer.setEditTime(DateTimeUtil.getSysTime());
        boolean flag=customerService.update(customer);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/customer/detail.do")
    public ModelAndView detail(String id,HttpServletRequest request){
        ModelAndView model=new ModelAndView();
        Customer customer = customerService.getCustomerByid(id);
        model.addObject("c",customer);
        model.setViewName("detail.jsp");
        return model;
    }

    //workbench/customer/getRemark.do
    @RequestMapping(value = "workbench/customer/getRemark.do")
    @ResponseBody
    public List<CustomerRemark> getRemark(HttpServletRequest request){
        String id=request.getParameter("id");
        List<CustomerRemark> remarks = customerService.getRemarkByCid(id);
        return remarks;
    }

    @RequestMapping(value = "workbench/customer/updateRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> updateRemark(CustomerRemark remark,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        remark.setEditFlag("1");
        boolean flag = customerService.updateRemark(remark);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/customer/saveRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveRemark(CustomerRemark remark,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        boolean flag = customerService.saveRemark(remark);
        map.put("success",flag);
        return map;
    }

    @RequestMapping(value = "workbench/customer/deleteRemark.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> deleteRemark(String id,HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        boolean flag = customerService.deleteRemark(id);
        map.put("success",flag);
        return map;
    }

    //workbench/customer/getTranByCid.do
    //workbench/customer/getRemark.do
    @RequestMapping(value = "workbench/customer/getTranByCid.do")
    @ResponseBody
    public List<Tran> getTranByCid(String cid,HttpServletRequest request){
        ServletContext application = request.getServletContext();
        Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
        List<Tran> tranList = tranService.getTranByCid(cid);
        for (Tran tran : tranList){
            tran.setPossibility(pMap.get(tran.getStage()));
        }
        return tranList;
    }

    //workbench/customer/delTranBtn.do
    @RequestMapping(value = "workbench/customer/delTranBtn.do",method = RequestMethod.POST)
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

    //workbench/customer/forwardTransave.do
    @RequestMapping(value = "workbench/customer/forwardTransave.do")
    @ResponseBody
    public void forwardTransave(String cname, String cid,HttpServletRequest request, HttpServletResponse response){
        try {
            request.getRequestDispatcher("/workbench/transaction/save.jsp?cname="+cname+"&cid="+cid).forward(request,response);
        } catch (ServletException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //workbench/customer/getContactByCid.do
    @RequestMapping(value = "workbench/customer/getContactByCid.do")
    @ResponseBody
    public List<Contacts> getContactByCid(String cid,HttpServletRequest request){
        List<Contacts> contactsList = contactService.getContactByCid(cid);
        return contactsList;
    }

    //workbench/customer/delContact.do
    @RequestMapping(value = "workbench/customer/delContact.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> delContact(String conid,HttpServletRequest request){
        Map<String,Boolean> map= new HashMap<>();
        List<String> idList=new ArrayList<>();
        idList.add(conid);
        boolean flag1=tranService.deleteTranByConids(idList);
        boolean flag2=contactService.deleteByConids(idList);
        if(flag1&&flag2){
            map.put("success",true);
        }else {
            map.put("success",false);
        }
        return map;
    }

    //workbench/customer/saveContact.do
    @RequestMapping(value = "workbench/customer/saveContact.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> saveContact(Contacts contacts,HttpServletRequest request){
        Map<String,Boolean> map= new HashMap<>();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag=contactService.save(contacts);
        map.put("success",flag);
        return map;
    }

}
