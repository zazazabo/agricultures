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
                /*                display: flex;*/
                justify-content: space-around;
                align-items: center;
            }
            .div1{
                width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;
            }
            .div2{
                width: 50%; height: 50%; float: left;
            }
            .div3{
                width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;
            }

            .wd{
                border: 1px solid black; width: 21%; float: left; height: 80%; background-color: #FAA523;  margin-left: 3%; margin-top: 2%;
            }

            .sd{
                border: 1px solid black; width: 21%; float: left; height: 80%; background-color: powderblue;  margin-left: 3%; margin-top: 2%; 
            }

            img{ width:100%;height:100%;}

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
                        for (var i = 0; i < value.length; i++) {
                            var v1 = value[i];
                            var strid = "infonum" + v1.infonum;
                            // var str = v1.type == "1" ? "℃" : "%";
                            var str = "";
                            if (v1.type == "1") {
                                str = "℃";
                            } else if (v1.type == "2") {
                                str = "%RH";
                            }
                            var numvalue = parseInt(v1.numvalue);
                            if (numvalue != 0) {
                                numvalue = numvalue / 10;
                            }
                            var val = numvalue + str;
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
                                var bodydiv = document.createElement("div");
                                var img = document.createElement("img");
                                var str = "";
                                if (sensor.type == 1) {   //温度
                                    $(bodydiv).addClass("wd");
                                    img.src = "./img/wd.png";
                                    str = "℃";
                                } else if (sensor.type == 2) {  //湿度
                                    $(bodydiv).addClass("sd");
                                    img.src = "./img/sd.png";
                                    str = "%RH";
                                }
                                var div1 = document.createElement("div");

                                $(div1).addClass("div1");
                                $(div1).append(sensor.name);
                                var div2 = document.createElement("div");
                                $(div2).addClass("div2");
                                $(div2).append(img);
                                var div3 = document.createElement("div");
                                $(div3).addClass("div3");
                                $(div3).attr("id", "infonum" + sensor.infonum);
                                var numvalue = parseInt(sensor.numvalue);
                                if (numvalue != 0) {
                                    numvalue = numvalue / 10;
                                }
                                var val = numvalue + str;
                                $(div3).append(val);
                                $(bodydiv).append(div1);
                                $(bodydiv).append(div2);
                                $(bodydiv).append(div3);
                                $("#parentdiv").append(bodydiv);
                            }
                        }
                    },
                    error: function () {
                        layerAler("提交失败");
                    }
                });
                //getinfo();
                setInterval('getinfo()', 10000);
            });

        </script>


    </head>
    <body id="activity_pane" >
        <div style=" width: 100%; height: 40%;" class='top' id="parentdiv">
<!--            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; background-color: yellowgreen;  margin-left: 4%; margin-top: 2%;  ">
                <div style=" width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;">温度传感器2</div>
                <div style=" width: 50%; height: 50%; float: left; ">
                    <img src="./img/wd.png" style="width:100%;height:100%;">
                </div>
                <div style=" width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;">38℃</div>
            </div>

            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; background-color: powderblue;  margin-left: 4%; margin-top: 2%;  ">
                <div style=" width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;">湿度传感器1</div>
                <div style=" width: 50%; height: 50%; float: left; ">
                    <img src="./img/sd.png" style="width:100%;height:100%;">
                </div>
                <div style=" width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;">38%</div>
            </div>


            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; background-color: yellowgreen;  margin-left: 4%; margin-top: 2%;  ">
                <div style=" width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;">温度传感器2</div>
                <div style=" width: 50%; height: 50%; float: left; ">
                    <img src="./img/wd.png" style="width:100%;height:100%;">
                </div>
                <div style=" width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;">38℃</div>
            </div>

            <div style=" border: 1px solid black; width: 20%; float: left; height: 80%; background-color: yellowgreen;  margin-left: 4%; margin-top: 2%;  ">
                <div style=" width: 100%; height: 50%;font-size: 2em;text-align: center;padding-top: 10%;">温度传感器2</div>
                <div style=" width: 50%; height: 50%; float: left; ">
                    <img src="./img/wd.png" style="width:100%;height:100%;">
                </div>
                <div style=" width: 50%; height: 50%; float: left;text-align: center;padding-top: 10%;font-size: 2em;">38℃</div>
            </div>-->
        </div>
    </body>
</html>
