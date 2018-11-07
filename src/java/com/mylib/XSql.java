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
public class XSql {

    public String id;
    //数据库操作类型:SQL  DDL PROC
    public String tpe;
    public String sql;
    //每条SQL对应的返回值
    public String var;
    //前台页面传的条件参数
    public String para;
    public String parenid;
    //数据库存储过程输出参数
    public String outpara;
    public String islist;
    public HashMap<String,xFlt> xFlt = new HashMap<String, xFlt>();
}