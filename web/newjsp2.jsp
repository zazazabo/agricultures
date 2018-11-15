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
            .div1{
                border: 1px solid black; width: 20%; float: left; height: 80%;
                background-color:  #2aabd2;
            }
            .div2{
                text-align: center; padding-top: 10%; font-size: 2em;
            }
            #a{
                background:url(img/fs.png) no-repeat center 0;
            }
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <link rel="stylesheet" href="bootstrap-3.3.7-dist/css/bootstrap.css" type="text/css">
        <script>
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function  getinfo() {
                $.ajax({async: false, url: "homePage.homePage.getSensorList.action", type: "get", datatype: "JSON", data: {},
                    success: function (data) {
                        var value = data.rs;
                        console.log("1");
                        for (var i = 0; i < value.length; i++) {
                            console.log("2");
                            var v1 = value[i];
                            var strid = "infonum" + v1.infonum;
                            var str = v1.type == "1" ? "℃" : "%";
                            var val = v1.numvalue + str;
                            console.log("value:" + v1.numvalue);
                            $("#" + strid).html(val);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
            $(function () {
                var pid = parent.parent.getpojectId();
                $.ajax({url: "homePage.homePage.getSensorList.action", type: "POST", datatype: "JSON", data: {pid: pid},
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length > 0) {
                            for (var i = 0; i < arrlist.length; i++) {
                                var sensor = arrlist[i];
                                var div1 = document.createElement("div");
                                $(div1).addClass("div1");
                                var div2 = document.createElement("div");
                                $(div2).addClass("div2");
                                $(div2).append(sensor.name);
                                var div3 = document.createElement("div");
                                $(div3).addClass("div2");
                                $(div3).attr("id", "infonum" + sensor.infonum);
                                $(div1).append(div2);
                                $(div1).append(div3);
                                $("#parentdiv").append(div1);
                            }
                        }
                    },
                    error: function () {
                        layerAler("提交失败");
                    }
                });
                getinfo();
                setInterval('getinfo()', 10000);
            });

        </script>


    </head>
    <body id="activity_pane" >
        <div style=" width: 100%; height: 40%;" class='top' id="parentdiv">
            <!--            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; ">
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
                        </div>-->
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; background-color: yellowgreen;  ">
                <div style=" width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;">温度传感器2</div>
                <div style=" width: 50%; height: 50%; float: left; ">
                    <img src="./img/fs.png" style="width:100%;height:100%;">
                </div>
                <div style=" width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;">38%</div>
            </div>
            
            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; background-color: powderblue;  ">
                <div style=" width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;">湿度传感器1</div>
                <div style=" width: 50%; height: 50%; float: left; ">
                    <img src="./img/sd.png" style="width:100%;height:100%;">
                </div>
                <div style=" width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;">38%</div>
            </div>
        </div>
    </body>
</html>
