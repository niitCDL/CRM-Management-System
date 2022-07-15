package com.bjpowernode.test;

import java.util.Arrays;

//查找、排序类的题目
public class ExamTopic02 {

    //二分法查找
    public static int binarySearch(int []arr,int val){
        int begin = 0;
        int end = arr.length;
        int mid = 0;
        while (begin <= end){
            mid = (begin + end) / 2;
            if (arr[mid] == val){
                return mid;
            } else if (arr[mid] < val){
                begin = mid + 1;
            } else {
                end = mid - 1;
            }
        }
        return -1;
    }

    //冒泡排序1算法
    public static void BubbleSort1(int[]arr){
        for (int i = arr.length - 1;i > 0;i--){
            for (int j = 0;j < i;j++){
                if (arr[j] > arr[j + 1]){
                    int temp = arr[j + 1];
                    arr[j + 1] = arr[j];
                    arr[j] = temp;
                }
            }
        }
    }

    //冒泡排序2算法
    public static void BubbleSort2(int[] arr){
        for (int i = 0;i < arr.length - 1;i++){
            for (int j = 0;j < arr.length - 1 - i;j++){
                if (arr[j] > arr[j + 1]){
                    int temp = arr[j + 1];
                    arr[j + 1] = arr[j];
                    arr[j] = temp;
                }
            }
        }
    }

    //选择排序算法
    public static void selectSort(int[] arr){
        int min = 0;
        for (int i = 0;i<arr.length - 1;i++){
            min = i;
            for (int j = i + 1;j < arr.length;j++){
                if (arr[min] > arr[j]){
                    min = j;
                }
            }
            if (min != i){
/*                int temp = arr[min];
                arr[min] = arr[i];
                arr[i] = temp;*/
                sort(arr,min,i);
            }
        }
    }

    //插入排序算法
    public static void insertSort(int[]arr){
        for (int i = 1;i<arr.length;i++){
            for (int j = i - 1;j >=0 && arr[j] > arr[j + 1];j--){
//                sort(arr,j,j+1);
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }

    //排序工具方法
    public static void sort(int[]arr,int i,int j){
        arr[i] = arr[i] ^ arr[j];//min
        arr[j] = arr[i] ^ arr[j];//i
        arr[i] = arr[i] ^ arr[j];//min
    }

    public static void main(String[] args) {
        int[] arr1 = {9,8,7,6,5,4,3,2,1};
        int[] arr2 = {19,18,17,16,15,14,13,12,11};
        int[] arr3 = {29,28,27,26,25,24,23,22,21};
        BubbleSort1(arr1);
        System.out.println("冒泡排序的结果:"+ Arrays.toString(arr1));
        insertSort(arr2);
        System.out.println("插入排序的结果:"+ Arrays.toString(arr2));
        selectSort(arr3);
        System.out.println("选择排序的结果:"+ Arrays.toString(arr3));
        int index = binarySearch(arr1,9);
        System.out.println("二分法查找的索引为:"+index);
    }


}
