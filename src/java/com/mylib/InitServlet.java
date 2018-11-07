/*
 * servelet启动读取配置
 */
package com.mylib;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.util.logging.Level;
import java.util.logging.Logger;
public class InitServlet extends HttpServlet {

    /**
     * 负责数据库连接数据的获得，配置于web.xml
     */
    private static final long serialVersionUID = 1L;
    private String className = null;
    private String uname = null;
    private String connUrl = null;
    private String psw = null;
//         Logger.getLogger(this.getClass());
    /**
     * 在ServletConfig和ServletContext都有getInitParameter方法， 这两个方法的都能从web.xml中获取参数
     *
     */
    @Override
    public void init() throws ServletException {    
        try {
                XmlApplicationContext cgx = new XmlApplicationContext("");
                cgx.InitAll(this.getServletContext());
        } catch (Exception ex) {
            Logger.getLogger(InitServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}