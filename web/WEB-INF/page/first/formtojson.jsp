<%-- 
    Document   : formtojson
    Created on : 2014-7-25, 9:55:31
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include  file="../../jspf/newjsf.jspf" %>
        <script type="application/javascript">
            function onClik(){
            //var data = $("#form1").serializeArray(); //自动将form表单封装成json
            //alert(JSON.stringify(data));
            var jsonuserinfo = formToJson($('#form1'));
            alert(JSON.stringify(jsonuserinfo));
            }
        </script>
    </head>

    <body>
        <form id="form1" name="form1" method="post" action="">
            <p>进货人 :
                <label for="name"></label>
                <input type="text" name="name" id="name" />
            </p>
            <p>性别:
                <label for="sex"></label>
                <select name="sex" size="1" id="sex">
                    <option value="1">男</option>
                    <option value="2">女</option>
                </select>
            </p>
            <table width="708" border="1">
                <tr>
                    <td width="185">商品名</td>
                    <td width="205">商品数量</td>
                    <td width="296">商品价格</td>
                </tr>
                <tr>
                    <td><label for="pro_name"></label>
                        <input type="text" name="pro_name" id="pro_name" /></td>
                    <td><label for="pro_num"></label>
                        <input type="text" name="pro_num" id="pro_num" /></td>
                    <td><label for="pro_price"></label>
                        <input type="text" name="pro_price" id="pro_price" /></td>
                </tr>
                <tr>
                    <td><input type="text" name="pro_name2" id="pro_name2" /></td>
                    <td><input type="text" name="pro_num2" id="pro_num2" /></td>
                    <td><input type="text" name="pro_price2" id="pro_price2" /></td>
                </tr>
            </table>
            <p> </p>
            <input type="button" name="submit" onclick="onClik();" value="提交"/>
        </form>
    </body>
</html>
