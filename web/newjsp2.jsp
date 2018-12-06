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
            body {background:url(./img/jdbj.jpg) top center no-repeat; background-size:cover;}
            .top{
                /*                display: flex;*/
                justify-content: space-around;
                align-items: center;
            }
            .div1{
                width: 50%; height: 128px;text-align: center;padding-top: 10%; float: left;font-size: 2em;position:relative;
            }
            .div2{
                width: 50%; height: 128px;text-align: center;padding-top: 10%; float: left;font-size: 2em;position:relative;
            }
            .div3{
                width: 30%; height: 128px;text-align: center;padding-top: 10%; float: left;position:relative;
            }
            .div4{
                width: 70%; height:128px;text-align: center;padding-top: 10%;float: left;font-size: 2em;position:relative;
            }

            .wd{
                border: 1px solid black; width: 13%; float: left; height: 256px;   margin-left: 3%; margin-top: 2%; background:rgba(255,165,0,0.6); filter:alpha(opacity=60);
            }

            .sd{
                border: 1px solid black; width: 13%; float: left; height: 256px;   background:rgba(255,165,0,0.6); filter:alpha(opacity=60);  margin-left: 3%; margin-top: 2%; 
            }

            .kg{ border: 1px solid black; width: 13%; float: left; height: 256px;    margin-left: 3%; margin-top: 2%; background:rgba(255,165,0,0.6); filter:alpha(opacity=60); }

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
                            var str2 = "";
                            var pd = 0;
                            if (v1.type == "1") {
                                str = "℃";
                                str2 = "温度值";
                            } else if (v1.type == "2") {
                                str = "%RH";
                                str2 = "湿度值";
                            } else if (v1.type == 3) {
                                if (v1.numvalue != null && v1.numvalue != "" && v1.numvalue != 0) {
                                    str = "开";
                                } else {
                                    str = "关";
                                }
                                pd = 1;
                                str2 = "状态";
                            }
                            var val = "";
                            if (pd == 1) {
                                val = str;
                            } else {
                                var numvalue = parseInt(v1.numvalue);
                                if (numvalue != 0) {
                                    numvalue = numvalue / 10;
                                }
                                val = numvalue + str;
                            }
                            $("#" + strid).html(str2 + "<br/>" + val);
                            ;
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
                                var str2 = "";  //湿度温度描述
                                var pd = 0;
                                if (sensor.type == 1) {   //温度
                                    $(bodydiv).addClass("wd");
                                    img.src = "./img/wd.png";
                                    str = "℃";
                                    str2 = "数值";
                                } else if (sensor.type == 2) {  //湿度
                                    $(bodydiv).addClass("sd");
                                    img.src = "./img/sd.png";
                                    str = "%RH";
                                    str2 = "数值";
                                } else if (sensor.type == 3) {
                                    $(bodydiv).addClass("kg");
                                    if (sensor.numvalue != null && sensor.numvalue != "" && sensor.numvalue != 0) {
                                        str = "开";
                                        img.src = "./img/k.png";
                                    } else {
                                        str = "关";
                                        img.src = "./img/g.png";
                                    }
                                    pd = 1;
                                    str2 = "状态";
                                }
//                                var div1 = document.createElement("div");
//
//                                $(div1).addClass("div1");
//                                $(div1).append(sensor.name);
//                                var div3 = document.createElement("div");
//                                $(div3).addClass("div3");
//                                var div2 = document.createElement("div");
//                                $(div2).addClass("div2");
//                                $(div2).append(img);
//                                
//                                $(div3).attr("id", "infonum" + sensor.infonum);
                                var numvalue = parseInt(sensor.numvalue);
                                if (numvalue != 0) {
                                    numvalue = numvalue / 10;
                                }
                                var val = "";
                                if (pd == 1) {
                                    val = str;
                                } else {
                                    val = numvalue+ "<br>" + str;
                                }
//                                $(div3).html(str2 + "<br/>" + val);
//                                $(bodydiv).append(div1);
//                                $(bodydiv).append(div3);
//                                $(bodydiv).append(div2);
                                var div1 = document.createElement("div");
                                $(div1).addClass("div1");
                                div1.innerHTML = str2;
                                var div2 = document.createElement("div");
                                $(div2).addClass("div2");
                                div2.innerHTML =val;
                                var div3 = document.createElement("div");
                                $(div3).addClass("div3");
                                $(div3).append(img);
                                var div4 = document.createElement("div");
                                $(div4).addClass("div4");
                                $(div4).append(sensor.name);
                                $(bodydiv).append(div1);
                                $(bodydiv).append(div2);
                                $(bodydiv).append(div3);
                                $(bodydiv).append(div4);
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
    <body id="activity_pane">
        <div style=" width: 100%;" class='top' id="parentdiv">
        </div>
    </body>
</html>
