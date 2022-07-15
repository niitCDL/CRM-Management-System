package com.bjpowernode.test;

//递归类的题目
public class ExamTopic01 {

    /*
    一只小猴子一天摘了许多桃子，第一天吃了一半，
    然后忍不住又吃了一个；第二天又吃了一半，再加上一个；后面每天都是这样吃。
    到第10天的时候，小猴子发现只有一个桃子了。问小猴子第一天共摘了多少个桃子。
    */

    public static int peachNo(int day){
        if (day == 10){
            return 1;
        }
        return (peachNo(day + 1) + 1) * 2;
    }


    //阶乘
    public static int jieCheng(int i){
        if (i == 1){
            return i;
        }
        return i * jieCheng(i - 1);
    }

    //斐波那契
    public static int feiBoNaQie(int n){
        if (n == 1 || n == 2){
            return 1;
        }
        return (n - 1) + (n - 2);
    }

    public static void main(String[] args) {
        System.out.println("猴子摘了"+peachNo(1)+"个桃子");
        System.out.println("1-10的阶乘是:"+jieCheng(10));
        System.out.println("斐波那契:"+feiBoNaQie(3));
    }

}
