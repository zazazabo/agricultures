/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mylib;

import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author Administrator
 */
public class Xhand {

    public String id;
    public String desc;
    //返回值类型PGE  JSON
    public String rtnype;
    //PGE->URL
    public String rtn;
    public String parentid;
    public String xslt;
    public String fileName;
    public HashMap<String, XSql> xsql= new HashMap<String, XSql>();
    public ArrayList xsqlist=new ArrayList();
}
