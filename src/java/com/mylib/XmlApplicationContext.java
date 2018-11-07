package com.mylib;

import java.io.InputStream;
import java.net.MalformedURLException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

/**
 * 以下使用Dom4j来进行xml文件的解析
 *
 */
public class XmlApplicationContext{

    public XmlApplicationContext(String filePath) throws Exception {

    }
    public  List getfile(InputStream is) throws DocumentException, MalformedURLException {
        List li1 = new ArrayList();
        SAXReader reader = new SAXReader();
        Document doc = reader.read(is);
        //得到跟节点beans
        Element root = doc.getRootElement();
        for (Object object : root.elements()) {
            Element formElement = (Element) object;
            li1.add(formElement.attributeValue("id"));
        }
        return li1;

    }
    public  void initdatabaseinfo(InputStream stream) throws DocumentException, MalformedURLException, SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
        SAXReader reader = new SAXReader();
        Document document = reader.read(stream);
        //得到跟节点beans
        Element root = document.getRootElement();
        for (Object object : root.elements()) {
            Element infoElement = (Element) object;
            String strclass = infoElement.attributeValue("class");
            String strurl = infoElement.attributeValue("url");
            String psw = infoElement.attributeValue("psw");
            String uname = infoElement.attributeValue("uname");
            DbConn.Initconn(strclass, strurl, uname, psw);
        }


    }
    @SuppressWarnings("empty-statement")
    public  void initMyxml(InputStream stream, String filePath) throws DocumentException, MalformedURLException {

        SAXReader reader = new SAXReader();
        Document document = reader.read(stream);
        //得到跟节点beans
        Xxx b1 = new Xxx();
        Element root = document.getRootElement();
        for (Object object : root.elements()) {
            XForm aa = new XForm();
            Element formElement = (Element) object;
            //获取Bean元素中的id属性
            aa.id = formElement.attributeValue("id");
      
            //获取bean元素中的scope属性
            aa.dese = formElement.attributeValue("desc");
            for (Object ob1 : formElement.elements()) {
                Element objhand = (Element) ob1;
                Xhand hand1 = new Xhand();
                hand1.id = objhand.attributeValue("id");
                hand1.rtn = objhand.attributeValue("rtn");
                hand1.rtnype = objhand.attributeValue("rtnype");
                hand1.desc = objhand.attributeValue("desc");
                hand1.fileName = objhand.attributeValue("fileName");
                hand1.xslt = objhand.attributeValue("xslt");
                hand1.parentid = aa.id;
                aa.xhand.put(hand1.id, hand1);
                for (Object obj2 : objhand.elements()) {
                    Element objxsql = (Element) obj2;
                    
                    XSql xspl = new XSql();
                    
                    
                    xspl.id = objxsql.attributeValue("id");
                    xspl.tpe = objxsql.attributeValue("tpe");
                    xspl.sql = objxsql.attributeValue("tpl");
                    xspl.var = objxsql.attributeValue("var");
                    xspl.para = objxsql.attributeValue("para");
                    xspl.outpara=objxsql.attributeValue("outpara");
                    xspl.islist=objxsql.attributeValue("list");;
                    xspl.parenid = hand1.id;
                    hand1.xsql.put(xspl.id, xspl);
                    hand1.xsqlist.add(xspl);
                    for (Object obj3 : objxsql.elements()) {
                        Element xfltelement = (Element) obj3;
                        xFlt xflt = new xFlt();
                        xflt.id = xfltelement.attributeValue("id");
                        xflt.tpl = xfltelement.attributeValue("tpl");
                        xflt.nrp = xfltelement.attributeValue("nrp");
                        xspl.xFlt.put(xflt.id, xflt);
                        for (Object obj4 : xfltelement.elements()) {
                            Element xfltpara1 = (Element) obj4;
                            xFltPara xpra1 = new xFltPara();
                            xpra1.id = xfltpara1.attributeValue("id");
                            xpra1.nrp = xfltpara1.attributeValue("nrp");
                            xpra1.para = xfltpara1.attributeValue("para");
                            xpra1.sql = xfltpara1.attributeValue("sql");
                            xflt.xfltpara.put(xpra1.id, xpra1);
                        }

                    }
                }
            }
            b1.xx.put(aa.id, aa);
        }
        XFile.xfile.put(filePath, b1);
        XFile.xmlfile=filePath+".xml";
        String xformsize =   String.valueOf(XFile.xfile.get(filePath).xx.size());
        String strin=XFile.xmlfile + "有" + xformsize + "个xform";
        Logger.getLogger(XmlApplicationContext.class.getName()).log(Level.INFO,strin );
    }
    public  void emptydata(){
        XFile.xfile.clear();
    }
    
    public  void InitAll(ServletContext context) throws DocumentException, MalformedURLException, Exception{
            XFile.xfile.clear();
            InputStream is = context.getResourceAsStream("/WEB-INF/config/allconfig.xml");
            Logger.getLogger(XmlApplicationContext.class.getName()).log(Level.INFO, "begin load allconfig.xml" + " ....");
            List aList = getfile(is);
            for (int i = 0; i < aList.size(); i++) {
                String dd = aList.get(i).toString();
                String filename = dd.substring(dd.lastIndexOf("/") + 1, dd.lastIndexOf("."));
                InputStream is2 = context.getResourceAsStream(dd);
                String sssString="begin load " + filename + ".xml" + " ....";
                Logger.getLogger(XmlApplicationContext.class.getName()).log(Level.INFO,sssString );
                initMyxml(is2, filename);
            }
            InputStream is3 = context.getResourceAsStream("/WEB-INF/config/database.xml");
            Logger.getLogger(XmlApplicationContext.class.getName()).log(Level.INFO, "begin load database.xml ...");
            initdatabaseinfo(is3);  
            
    }
}