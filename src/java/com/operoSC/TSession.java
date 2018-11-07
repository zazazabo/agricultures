/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.operoSC;

import com.mylib.ControlServlet;
import com.mylib.Info;
import com.mylib.XsqlInfo;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONArray;

/**
 *
 * @author Administrator
 */
public class TSession {

    /**
     *
     * @param request
     * @param response
     */
    public void dealPost(HttpServletRequest request, HttpServletResponse response, Info a1) {
        System.out.println(a1.url);
    }
    /*设置验证码
     * 
     */

    public void setCheckCode(HttpServletRequest request, HttpServletResponse response, Info info1) throws IOException {
        List li = info1.sqlLis;
        if (li.size() <= 0) {
            return;
        }
        XsqlInfo aa = (XsqlInfo) li.get(0);
        response.setContentType("image/jpeg");
        //禁止图像缓存。  
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        ValidateCode vCode = new ValidateCode(120, 40, 4, 20);
        vCode.write(response.getOutputStream());
        request.getSession().setAttribute("checkcode", vCode.getCode());
    }

    public void getCheckCode(HttpServletRequest request, HttpServletResponse response, Info info1) throws IOException {
        String str1 = (String) request.getSession().getAttribute("checkcode");
        Map map = new HashMap();
        map.put("checkcode", str1); 
        setJsonMap(map, request, response);

    }
    
  public void setJsonMap(Map m, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String jsonstr = null;
        jsonstr = JSONArray.fromObject(m).toString();
        Logger.getLogger(TSession.class.getName()).log(Level.INFO, jsonstr);
        response.getOutputStream().write(jsonstr.getBytes("UTF-8"));
        response.setContentType("text/json; charset=UTF-8");
    }
    
      public void setJsonList(List li, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String jsonstr = null;
        jsonstr = JSONArray.fromObject(li).toString();
        Logger.getLogger(TSession.class.getName()).log(Level.INFO, jsonstr);
        response.getOutputStream().write(jsonstr.getBytes("UTF-8"));
        response.setContentType("text/json; charset=UTF-8");
    }  
    
}
