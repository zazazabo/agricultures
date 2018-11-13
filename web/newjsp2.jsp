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
            function  getinfo() {
                $.ajax({async: false, url: "sensor.sensorform.getAllSensor.action", type: "get", datatype: "JSON", data: {},
                    success: function (data) {
                        var value = data.rs;
                        for (var i = 0; i < value.length; i++) {
                            var v1 = value[i];
                            var strid = "infonum" + v1.infonum;
                            var str = v1.type == "1" ? "℃" : "%";
                            var val = v1.numvalue + str;
                            $("#" + strid).html(val);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
            $(function () {
                getinfo();
                setInterval('getinfo()', 10000);
            });

        </script>


    </head>
    <body id="activity_pane" >
        <div style=" width: 100%; height: 40%;" class='top'>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">湿度传感器1</div>
                <div id="infonum1" style=" text-align: center;padding-top: 10%; font-size: 2em;">数值：</div>
            </div>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">温度传感器1</div>
                <div id="infonum0" style=" text-align: center;padding-top: 10%; font-size: 2em;">数值：</div>
            </div>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">湿度传感2</div>
                <div id="infonum2" style=" text-align: center;padding-top: 10%; font-size: 2em;"></div>
            </div>
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
                <div style="text-align: center; padding-top: 10%; font-size: 2em;">温度传感器2</div>
                <div id="infonum3" style=" text-align: center;padding-top: 10%; font-size: 2em;"></div>
            </div>
        </div>
    </body>
</html>
