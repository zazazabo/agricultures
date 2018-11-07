/*
 * 解析配置信息 比较重要的
 * and open the template in the editor.
 */
package com.mylib;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Administrator
 */
public class Info extends HttpServlet {
    //返回的页面

    public String url = "";
    public String rtnype = "";  //类型决定返回值类型
    public String var = "";      //变量指定返回list json
    public List sqlLis = new ArrayList();

    public void getinfo(HttpServletRequest re) {
        String pathName = re.getServletPath();
        int n11 = pathName.lastIndexOf("/");
        if (n11 >= 0) {
            pathName = pathName.substring(n11 + 1);
        }
        String strpaString = pathName.substring(0, pathName.lastIndexOf("."));
        Logger.getLogger(Info.class.getName()).log(Level.INFO, "url:" + pathName);
        int n = strpaString.indexOf(".");
        int n1 = strpaString.indexOf(".", n + 1);
        int n2 = strpaString.indexOf(".", n1 + 1);
        if (n == -1 && n1 == -1 && n2 == -1) {
            Logger.getLogger(Info.class.getName()).log(Level.SEVERE, "url和配置文件不匹配");
            Logger.getLogger(Info.class.getName()).log(Level.SEVERE, "xml-name.xForm-id.xHand-id.action?......");
        }
        String filesString = strpaString.substring(0, n);
        String formsString = strpaString.substring(n + 1, n1);
        String handsString = strpaString.substring(n1 + 1);
        Xxx xxx = XFile.xfile.get(filesString);
        if (xxx == null) {
            Logger.getLogger(Info.class.getName()).log(Level.SEVERE, "配置文件加载有问题");
        }
        XForm f1 = xxx.xx.get(formsString);
        if (f1 == null) {
            Logger.getLogger(Info.class.getName()).log(Level.SEVERE, "xform在" + XFile.xmlfile + "配置中找不到");
        }
        Xhand h1 = f1.xhand.get(handsString);
        if (h1 == null) {
            Logger.getLogger(Info.class.getName()).log(Level.SEVERE, "xhand在id为" + f1.id + "的xform里找不到");
        }
        url = h1.rtn;
        rtnype = h1.rtnype;
        List li1 = h1.xsqlist;
        for (int i = 0; i < li1.size(); i++) {
            XSql xsql = (XSql) li1.get(i);

            String type = xsql.tpe;
            if ((xsql.islist != null) && (xsql.islist.equals("true"))) {
                var = xsql.var;
            }
            if (type.equals("SQL")) {
                try {
                    XsqlInfo info1 = getQuery(xsql, re);
                    sqlLis.add(info1);
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(Info.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (type.equals("DDL")) {
                try {
                    XsqlInfo info1 = getDDL(xsql, re);
                    sqlLis.add(info1);
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(Info.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (type.equals("PROC")) {
                try {
                    XsqlInfo info1 = getProc(xsql, re);
                    sqlLis.add(info1);
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(Info.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

        }
    }
//获取获取查询xsql

    private XsqlInfo getProc(XSql xsql, HttpServletRequest re) throws UnsupportedEncodingException {
        XsqlInfo xsqlinfo = new XsqlInfo();
        String sql = xsql.sql;
        if (xsql.para == null) {
            xsql.para = "";
        }
        String paraString = xsql.para.trim();
        String[] para = null;
        if (!paraString.equals("")) {
            para = paraString.split(",");
            for (int i = 0; i < para.length; i++) {
                String fpara1 = re.getParameter(para[i]);
                String paravalue = null;
                if (fpara1 != null) {
                    paravalue = new String(re.getParameter(para[i]).getBytes("ISO-8859-1"), "UTF-8");
                }
                xsqlinfo.first = xsqlinfo.first + para[i] + "=" + paravalue + ",";
                sql = sql.replace(":" + para[i], paravalue);
            }
        }
        String outString = xsql.outpara;
        if (outString != null) {
            String[] out1 = outString.split(",");
            for (int i = 0; i < out1.length; i++) {
                String[] para5 = out1[i].split(":");
                sql = sql.replace("@" + para5[0], para5[0]);
                xsqlinfo.outpara.put(para5[0], Integer.parseInt(para5[1]));
            }
        }

        xsqlinfo.sql = sql;
        xsqlinfo.type = xsql.tpe;
        xsqlinfo.var = xsql.var;
        xsqlinfo.id = xsql.id;
        return xsqlinfo;

    }

    private XsqlInfo getQuery(XSql xsql, HttpServletRequest re) throws UnsupportedEncodingException {
        XsqlInfo xsqlinfo = new XsqlInfo();
        String sql = getsqlString(xsql, re, xsql.sql, xsqlinfo);
        xsqlinfo.sql = sql;
        xsqlinfo.type = xsql.tpe;
        xsqlinfo.var = xsql.var;
        xsqlinfo.id = xsql.id;

        return xsqlinfo;

    }

    public String getsqlString(XSql xsql, HttpServletRequest re, String sql1, XsqlInfo xsqlinfo) throws UnsupportedEncodingException {
        String sql = sql1 + " ";
        int being1 = sql.indexOf("@CONDITION");
        
        
        int end1 = sql.indexOf(" ", being1);
        String conString1 = sql.substring(being1 + 1, end1);
        while (being1 != -1) {
            boolean balive = xsql.xFlt.containsKey(conString1);
            if (balive == false) {
                Logger.getLogger(Info.class.getName()).log(Level.SEVERE, "sql_tpl有条件,而下面没条件");
                break;
            }
            if (balive) {

                //"@AID AND @APASSWORD"
                String condString = " ";
                condString += xsql.xFlt.get(conString1).tpl;
                String[] dd = condString.split("AND");
                for (int i = 0; i < dd.length; i++) {
                    String str1 = dd[i].trim();
                    //url的参数
                    //str2=AID
                    String bpara = str1.substring(1);   //@param1 and @param2
                    xFlt xflt = xsql.xFlt.get(conString1);
                    xFltPara xfltpara = xflt.xfltpara.get(bpara);
                    if (xfltpara == null) {

                        Logger.getLogger(ControlServlet.class.getName()).log(Level.WARNING, "前台传过的" + bpara + "参数为空...", "前台传过的" + bpara + "参数为空...");
                    }
                    String nrpString = "";
                    if (xflt.nrp != null) {
                        nrpString = xfltpara.nrp;
                    }

                    String sqlsString = xfltpara.sql;
                    String fpara = xfltpara.para;              //前台传过来的参数
                    if (xfltpara.para == null) {
                        Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, "配置文件参数para错误");
                    }

                    String fparaVal = re.getParameter(fpara);
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, "参数值:" + fpara + "=" + fparaVal);
                    String fparaValue = null;
                    if (fparaVal != null) {
                        fparaValue = java.net.URLDecoder.decode(re.getParameter(fpara), "UTF-8");
                        //                  fparaValue = new String(re.getParameter(fpara).getBytes("ISO-8859-1"), "UTF-8");
                    }
                    xsqlinfo.second = xsqlinfo.second + fpara + "=" + fparaValue + ",";
                    if (fparaValue == null || fparaValue.equals("")) {
                        if (nrpString == null) {
                            condString = condString.replace(str1, "1=1");
                        } else {
                            condString = condString.replace(str1, nrpString);
                        }
                    } else {
                        xsqlinfo.fpara.put(fpara, fparaValue);
                        xsqlinfo.bpara.put(bpara, fparaValue);
                        condString = condString.replace(str1, sqlsString);
                        int n1 = condString.indexOf("(", 0);
                        if (n1 == 1) {
                            condString = condString.replace("AND", ",");
                        }
                        condString = condString.replace(":" + fpara, fparaValue);
                    }
                }
                sql = sql.replace("@" + conString1, condString);
                being1 = sql.indexOf("@");
                end1 = sql.indexOf(" ", being1);
                conString1 = sql.substring(being1 + 1, end1);
            }
        }
        return sql;
    }

    private XsqlInfo getDDL(XSql xsql, HttpServletRequest re) throws UnsupportedEncodingException {

        XsqlInfo xsqlinfo = new XsqlInfo();
        String sql = xsql.sql;

        if (xsql.para == null) {
            xsql.para = "";
        }
        String paraString = xsql.para.trim();

        String[] para = null;
        if (!paraString.equals("")) {
            para = paraString.split(",");
            for (int i = 0; i < para.length; i++) {
                String fpara1 = re.getParameter(para[i]);
                String paravalue = null;
                if (fpara1 != null) {
                    paravalue = new String(re.getParameter(para[i]).getBytes("ISO-8859-1"), "UTF-8");
                }
                if (paravalue == null) {
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, para[i] + ":null");
                    paravalue="";
                }
                xsqlinfo.first = xsqlinfo.first + para[i] + "=" + paravalue + ",";
                sql = sql.replaceFirst(":" + para[i], paravalue);
            }
        }
        sql = getsqlString(xsql, re, sql, xsqlinfo);
        xsqlinfo.sql = sql;
        xsqlinfo.type = xsql.tpe;
        xsqlinfo.var = xsql.var;
        xsqlinfo.id = xsql.id;
        return xsqlinfo;

    }
}
