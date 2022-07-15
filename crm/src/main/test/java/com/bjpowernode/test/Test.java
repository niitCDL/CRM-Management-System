package com.bjpowernode.test;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

public class Test {

    @org.junit.Test
    public void test(){
        ResourceBundle resourceBundle=ResourceBundle.getBundle("Stage2Possibility");
        Map<String,String> pMap=new HashMap<>();
        Enumeration<String> e = resourceBundle.getKeys();
        while (e.hasMoreElements()){
            String key = e.nextElement();
            String value = resourceBundle.getString(key);
            System.out.println(key + " = " + value);
        }
    }
}
