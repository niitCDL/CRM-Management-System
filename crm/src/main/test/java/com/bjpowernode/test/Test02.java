package com.bjpowernode.test;

import org.junit.Test;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class Test02 {
    public static void main(String[] args) throws ParseException {
/*        long begin = System.currentTimeMillis();
        print();
        long end = System.currentTimeMillis();
        System.out.println(end - begin);

        DecimalFormat decimalFormat = new DecimalFormat("###,###.##");
        String format = decimalFormat.format(1100);
        System.out.println(format);

        BigDecimal decimal1 = new BigDecimal(10);
        BigDecimal decimal2 = new BigDecimal(100);
        BigDecimal big3 = decimal1.divide(decimal2);
        System.out.println(big3);*/
        for (int i = 1;i<=10;i++){
            System.out.println("=========第"+i+"次运行的结果===========");
            randomArray();
            System.out.println("======================================");
        }

    }

    public static void print(){
        ArrayList<Integer> list = new ArrayList<>();
        Random random = new Random();
        int val;
        while (list.size() != 5){
            val = random.nextInt(10);
            if (!list.contains(val)){
                list.add(val);
            }
        }
        System.out.println(list);
    }


    public static void randomArray(){
        int[] arr = new int[5];
        int index = -1;
        Random random = new Random();
        int val;
        boolean flag = true;
        while (index != arr.length - 1){
            val = random.nextInt(11);
            flag = true;
            if (val == 0){
                System.out.println("index = " + index + " val = " + val);
            }
            for (int i = 0;i <= index;i++)
            {
                if (arr[i] == val){
                    flag = false;
                }
            }
            if (flag){
                arr[++index] = val;
            }
        }
        System.out.println(Arrays.toString(arr));
    }

    @Test
    public void testMath(){
        double sqrt = Math.sqrt(4.3);
        System.out.println(sqrt);
        doSome(10,2,3,0,6,5,4);
        //三位数最大为\377 两位数\77 一位数\7
        char c = '\377';
        System.out.println(c);
    }

    @Test
    public void testYanghuiSanjiao(){
        yangHuiSanJiao(2);
    }

    /*
        1
        1 1
        1 2 1   [2][1] = [1][1] + [1][0]
    */
    public static void yangHuiSanJiao(int row){
        int [][]arr = new int[row][];

        for (int i = 0;i<arr.length;i++){
            arr[i] = new int[i + 1];
        }

        for (int i = 0;i<arr.length;i++){
            arr[i][0] = 1;
            arr[i][arr[i].length - 1] = 1;
        }

        for (int i = 2;i<arr.length;i++){
            for (int j = 1;j<arr[i].length - 1;j++){
                arr[i][j] = arr[i - 1][j] + arr[i - 1][j - 1];
            }
        }

        for (int []val : arr){
            for (int arrVal : val){
                System.out.print(arrVal + " ");
            }
            System.out.println();
        }

    }

    public static void doSome(Integer ...args){

    }
}

