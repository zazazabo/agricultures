<%-- 
    Document   : newjsp1
    Created on : 2018-8-6, 18:19:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>



        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>


        <style type="text/css">
            body{
                height: 800px;
            }
            .top{
                display: flex;
                justify-content: space-around;
                align-items: center;
            }
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <link rel="stylesheet" href="bootstrap-3.3.7-dist/css/bootstrap.css" type="text/css">
        <script>

            $(function () {

            });

        </script>


    </head>
    <body id="activity_pane" >
        <div style=" width: 100%; height: 40%;" class='top'>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">湿度传感器1</div>
                <div style=" text-align: center;padding-top: 10%; font-size: 2em;">数值：32.5%</div>
            </div>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">温度传感器1</div>
                <div style=" text-align: center;padding-top: 10%; font-size: 2em;">数值：28.2.5</div>
            </div>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">湿度传感2</div>
                <div style=" text-align: center;padding-top: 10%; font-size: 2em;">数值：32.5%</div>
            </div>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">温度传感器2</div>
                <div style=" text-align: center;padding-top: 10%; font-size: 2em;">数值：32.5%</div>
            </div>
        </div>
    </body>
</html>
