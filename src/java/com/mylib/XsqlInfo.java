/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mylib;

import java.util.HashMap;

/**
 *
 * @author Administrator
 */
public class XsqlInfo {
    public String sql;
    public  String type;
    public  String var;
    public  String id;
    HashMap<String, String> fpara=new HashMap<String, String>();    //前台参数
    HashMap<String, String> bpara=new HashMap<String, String>(); //条件参数
    String first="";
    String second="";
    HashMap<String, Integer> outpara=new HashMap<String, Integer>(); //条件参数
}
