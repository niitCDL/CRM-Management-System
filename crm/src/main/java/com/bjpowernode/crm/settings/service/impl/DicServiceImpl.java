package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("DicService")
public class DicServiceImpl implements DicService {

    @Autowired
    private DicTypeDao dicTypeDao;
    @Autowired
    private DicValueDao dicValueDao;


    @Override
    public Map<String, List<DicValue>> getAll() {

        Map<String, List<DicValue>> map=new HashMap<>();

        List<DicType> DictypeList = dicTypeDao.getTypeList();

        for (DicType type : DictypeList){
            String code=type.getCode();

            List<DicValue> dicValueList=dicValueDao.getValueByCode(code);

            map.put(code+"List",dicValueList);
        }
        return map;
    }
}
