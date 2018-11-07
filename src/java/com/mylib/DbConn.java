/*
 * 数据库操作类
 */
package com.mylib;

import com.mysql.jdbc.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DbConn {

    @SuppressWarnings("unchecked")
    static int rowCount = 0;
    static int colCount = 0;
    public static String[] type = null;
    static boolean flag = true;
    /**
     * 由于参数的值是靠外部servlet进行传递的，而变量却需要多次使用，因此设为全局变量
     * 并且由于servlet传入值只会在容器启动的时候,因此设为static
     *
     */
    static String classNames = null;
    static String url = null;
    static String user = null;
    static String psw = null;

    /**
     * 进行查询的sql的实现
     *
     */
    @SuppressWarnings("unchecked")
    public static ArrayList<HashMap<Object, Object>> query(String sql) throws SQLException, Exception {
        return getData(sql);
    }
//    
/*
     * 执行存储过程
     * 
     */

    public static List execProcedure(String sql, HashMap<String, Integer> para) throws SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
        Connection conn = null;
        CallableStatement callStmt = null;
        conn = DbConn.getconn();
        callStmt = (CallableStatement) conn.prepareCall("{" + sql + "}");
        int bb = 1;
        if (para.size() > 0) {
            String sql1 = sql.substring(0, sql.length() - 1);
            for (Map.Entry<String, Integer> entry : para.entrySet()) {
                String paraname = entry.getKey();
                Integer sqltype = entry.getValue();
                callStmt.registerOutParameter(paraname, sqltype);
                bb++;
            }
        }
        callStmt.execute();
        List abc = new ArrayList();
        for (Map.Entry<String, Integer> entry : para.entrySet()) {
            Map aa = new HashMap();
            String paraname = entry.getKey();
            aa.put(paraname, callStmt.getString(paraname));
            abc.add(aa);
        }
        return abc;
    }

    /**
     * 执行除查询外的所有sql语句
     *
     */
    public static int exceptQuery(String sql) throws SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
        Connection conn = DbConn.getconn();
        Statement stmt = null;
        int count = 0;
        conn.setAutoCommit(false);
        stmt = conn.createStatement();
        count = stmt.executeUpdate(sql);
        conn.commit();
        conn.rollback();
        DbConn.closeConn(conn);
        return count;
    }

    /**
     * 执行查询的sql语句
     *
     */
    @SuppressWarnings("unchecked")
    private static ArrayList<HashMap<Object, Object>> getData(String sql) throws SQLException, Exception {
        Connection conn = DbConn.getconn();
        Statement stmt;
        ResultSet rs;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);
        flag = true;
        if (null != rs) {
            ArrayList dd = convertResultSetToArrayList(rs);
            closeConn(conn);
            return dd;
        }
        closeConn(conn);
        return null;

    }

    /**
     * 进行数据库的基本连接
     *
     */
    public static Connection getconn() throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {
        Class.forName(classNames).newInstance();
        Connection conn;
        conn = DriverManager.getConnection(url, user, psw);
        return conn;
    }

    /**
     * 初始化连接
     */
    public static void Initconn(String className, String connUrl, String uname, String upsw) throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException {
        classNames = className;
        url = connUrl;
        user = uname;
        psw = upsw;
        Connection con = DbConn.getconn();
        DbConn.closeConn(con);
        Logger.getLogger(DbConn.class.getName()).log(Level.INFO, "Initconn()_数据库连接信息:{" + className + "-" + connUrl + "-" + uname + "-" + psw + "}");
    }

    /**
     * 进行数据库连接的关闭
     *
     */
    public static void closeConn(Connection conn) throws SQLException {

        conn.close();
    }

    /*
     * 查询到的数据转成list
     */
    private static ArrayList<HashMap<Object, Object>> convertResultSetToArrayList(
            ResultSet rs) throws Exception {
        // 获取rs 集合信息对象
        ResultSetMetaData rsmd = rs.getMetaData();
        // 创建数组列表集合对象
        ArrayList<HashMap<Object, Object>> tempList = new ArrayList<HashMap<Object, Object>>();
        HashMap<Object, Object> tempHash;
        // 填充数组列表集合
        while (rs.next()) {
            // 创建键值对集合对象
            tempHash = new HashMap<Object, Object>();
            for (int i = 0; i < rsmd.getColumnCount(); i++) {
            String columName=      rsmd.getColumnLabel(i+1);
                // 遍历每列数据，以键值形式存在对象tempHash中
                tempHash.put(columName, rs.getString(columName));
            }
            // 第一个键值对，存储在tempList列表集合对象中
            tempList.add(tempHash);
        }
        return tempList;// 返回填充完毕的数组列表集合对象
    }
}