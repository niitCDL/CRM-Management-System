package com.bjpowernode.test;

import java.util.Arrays;
import java.util.Random;

public class ExamTopic03 {

    //对角线之和
    public static void digitalSum(){
        int[][] tempArr = new int[3][3];
        int ele = 1;
        for (int i = 0;i<tempArr.length;i++){
            for (int j = 0;j<tempArr[i].length;j++){
                tempArr[i][j] = ele++;
            }
        }

        int sumVal = 0;
        for (int i = 0,j = tempArr.length - 1;i < tempArr.length;i++,j--){
            sumVal += tempArr[i][i] + tempArr[i][j];
        }

        System.out.println(sumVal);
    }

    /*
        海滩上有一堆桃子，五只猴子来分。第一只猴子把这堆桃子平均分为五份，
        多了一个，这只猴子把多的一个扔入海中，拿走了一份。第二只猴子把剩下的桃子又平均分成五份，
        又多了一个，它同样把多的一个扔入海中，拿走了一份。第三、第四、第五只猴子都是这样做的，
        问海滩上原来最少有多少个桃子？
    */
    public static void monkeyPeach(){
        int peach = 6;
        boolean flag = true;
        while (true){
            int temp = peach;
            flag = true;
            for (int i = 1;i<=5;i++){
                if (temp % 5 != 1){
                    flag = false;
                    break;
                }
                temp -= temp / 5 + 1;
            }
            if (flag){
                System.out.println(peach);
                break;
            }
            peach++;
        }
    }


    //水仙花数
    public static void flowers(){
        int ge;
        int shi;
        int bai;
        for (int i = 100;i<=999;i++){
            ge = i % 10;
            shi = i / 10 % 10;
            bai = i / 100;
            if (Math.pow(ge,3) + Math.pow(shi,3) + Math.pow(bai,3) == i){
                System.out.println(i);
            }
        }
    }

    //公鸡每只 3 元，母鸡每只 5 元，小鸡 3 只 1 元，用 100 元钱买 100 只鸡
    public static void hundredChicken(){
        int c = 0;
        for (int a = 0; a <= 33; a++){
            for (int b = 0; b <= 20; b++){
                c = 100 - a - b;
                if (c % 3 == 0 && a * 3 + b * 5 + c / 3 == 100){
                    System.out.println("公:" + a + " 母:" + b + " 小:" + c);
                }
            }
        }
    }

    //生成五个不相同的随机数放在数组中
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

    //杨辉三角
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

    public static void main(String[] args) {
        System.out.println("----------水仙花数-----------");
        flowers();

        System.out.println("\n----------百钱白鸡-----------");
        hundredChicken();

        System.out.println("\n----------猴子分桃-----------");
        monkeyPeach();

        System.out.println("\n----------对角线和-----------");
        digitalSum();

        System.out.println("\n----------生成五个不相同的随机数-----------");
        for (int i = 1;i<=10;i++){
            System.out.println("=========第"+i+"次运行的结果===========");
            randomArray();
            System.out.println("======================================");
        }

        System.out.println("\n----------杨辉三角-----------");
        yangHuiSanJiao(10);

    }
}
