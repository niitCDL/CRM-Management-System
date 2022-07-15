package com.bjpowernode.crm.vo;


import java.util.List;

public class PaginationVO<T> {
    private Integer total;
    private List<T> activities;

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getActivities() {
        return activities;
    }

    public void setActivities(List<T> activities) {
        this.activities = activities;
    }
}
