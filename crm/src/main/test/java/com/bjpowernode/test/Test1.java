package com.bjpowernode.test;

import org.junit.Test;
import org.w3c.dom.ranges.RangeException;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class Test1 {

    @Test
    public void test1(){
        //byte short int long double float boolean char
        byte a = 1;
        short a1 = 1;
        int a2 = 1;
        long a3 = 1;
        System.out.printf("%d%d%d%d\n",a,a1,a2,a3);
        double d1 = 10.568;
        float d2 = 10.568f;
        System.out.printf("%.4f %f",d1,d2);

        char c1 = 'c';
        System.out.println((int)c1);
        System.out.printf("%c\n",c1);

        monkeyPeach();
    }


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

    @Test
    public void test2(){

        new Thread(() -> System.out.println("啊飒飒")).start();



        for (int i = 1;i<=100;i++){
            Person person = new Person("張"+i);
            person = null;
            System.gc();
        }
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("person's count:"+Person.count);



    }

    @Test
    public void test3(){
        int[]arr = {1,2,3,4};
        //arr = extendArray(arr,5);
/*        deleteArray(0,arr);
        System.out.println(Arrays.toString(arr));*/
        int[][] arr2 = {
                {1,2,3,4}
        };
        for (int i = 0;i<arr2.length;i++){

        }

        //[3][2][4]
        int[][][] arr3 = {
                {
                    {1,2,3,4},{4,5,6,7}
                }
        };

        for (int i = 0;i<arr3.length;i++){
            for (int j = 0;j<arr3[i].length;j++){
                for (int k = 0;k<arr3[i][j].length;k++){
                    System.out.print(arr3[i][j][k]+" ");
                }
            }
        }
        int[][][] arr4 = new int[3][2][4];
        System.out.println(arr4.length);//3
        System.out.println(arr4[0].length);//2
        System.out.println(arr4[0][0].length);//4

    }

    @Test
    public void test09(){
        // 1234  length = 4
        //System.out.println(endswith("aksaknxmcnahskas", "aksaknxmcnahskaskajska,z,mz,mx,ma,skas"));
        System.out.println(startswith("asnmasnman", "asnm"));
    }

    public static boolean endswith(String originStr,String tempStr){
        if (originStr == null || tempStr == null || tempStr.length() > originStr.length()) return false;
        StringBuilder stringBuilder = new StringBuilder();
        int originLength = originStr.length();
        int tempStrLength = tempStr.length();
        for (int i = originLength - tempStrLength;i<originLength;i++){
            stringBuilder.append(originStr.charAt(i));
        }
        return tempStr.equals(stringBuilder.toString());
    }

    public static boolean startswith(String originStr,String tempStr){
        if (originStr == null || tempStr == null || tempStr.length() > originStr.length()) return false;
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0;i<tempStr.length();i++){
            stringBuilder.append(originStr.charAt(i));
        }
        return tempStr.equals(stringBuilder.toString());
    }



    public static int[] extendArray(int[] arr,int length){
        int []newArr = new int[arr.length + length];
        System.arraycopy(arr,0,newArr,0,arr.length);
        return newArr;
    }

    public static void deleteArray(int[] arr,int index){
        System.arraycopy(arr,index + 1,arr,index,arr.length - 1 - index);
        arr[arr.length - 1] = 0;
    }

    public static void deleteArray(int index,int[] arr){
        int []newArr = new int[arr.length - 1 - index];

        for (int i = index + 1,n = 0;i<arr.length;i++,n++){
            newArr[n] = arr[i];
        }

        for (int i = index,n = 0;i<arr.length - 1;i++,n++){
            arr[i] = newArr[n];
        }
/*        for (int n = 0;n < newArr.length; n++){
            arr[index++] = newArr[n];
        }*/

        arr[arr.length - 1] = 0;
    }


    @Test
    public void test15(){
        String str = "我是asd123";
        System.out.println(str.getBytes().length);
    }





}




class Person{
    String name;
    static int count = 0;

    public Person() {
    }



    public Person(String name) {
        this.name = name;
    }

    @Override
    protected void finalize() throws Throwable {
        System.out.println(this.name+"即將被銷毀");
        count++;
    }
}




