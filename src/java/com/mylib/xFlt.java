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
public class xFlt {

 public String id;
 //条件参数连接字符串
 public String tpl;
 //条件查询为空时nrp is 1=1;
 public String nrp;
 public HashMap<String, xFltPara> xfltpara = new HashMap<String, xFltPara>();
}
