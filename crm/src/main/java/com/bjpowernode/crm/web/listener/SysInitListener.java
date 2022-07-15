package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {


    @Override
    public void contextInitialized(ServletContextEvent event) {
        ApplicationContext ac=new ClassPathXmlApplicationContext("applicationContext.xml");
        DicService dicService= (DicService) ac.getBean("DicService");
        System.out.println(dicService);
        ServletContext application = event.getServletContext();
        Map<String, List<DicValue>> dicMap = dicService.getAll();
        Set<String> set = dicMap.keySet();
        for (String type : set){
            application.setAttribute(type,dicMap.get(type));
        }

        ResourceBundle resourceBundle=ResourceBundle.getBundle("Stage2Possibility");
        Map<String,String> pMap=new HashMap<>();
        Enumeration<String> e = resourceBundle.getKeys();
        while (e.hasMoreElements()){
            String key = e.nextElement();
            String value = resourceBundle.getString(key);
            pMap.put(key,value);
        }
        application.setAttribute("Stage2Possibility",pMap);
    }
}
