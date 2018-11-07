<%-- 
    Document   : newjsp
    Created on : 2014-7-24, 14:06:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include  file="../../jspf/newjsf.jspf" %>
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <table id="tt" class="easyui-datagrid" style="width:600px;height:400px"  
               data-options="url:'get_data.php',idField:'id',treeField:'name'">  
            <thead>  
                <tr>  
                    <th data-options="field:'name',width:180">Task Name</th>  
                    <th data-options="field:'persons',width:60,align:'right'">Persons</th>  
                    <th data-options="field:'begin',width:80">Begin Date</th>  
                    <th data-options="field:'end',width:80">End Date</th>  
                </tr>  
            </thead>  
        </table>  

    </body>
</html>
