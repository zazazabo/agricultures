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
            body {background:url(./img/jdbj.jpg) top center no-repeat; background-size:cover; -moz-background-size:100% 100%;}
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
                border: 1px solid black; width: 13%; float: left; height: 256px;   margin-left: 3%; margin-top: 2%;
            }

            .sd{
                border: 1px solid black; width: 13%; float: left; height: 256px;margin-left: 3%; margin-top: 2%; 
            }

            .kg{ border: 1px solid black; width: 13%; float: left; height: 256px;    margin-left: 3%; margin-top: 2%;}

            .hl{ border: 1px solid black; width: 13%; float: left; height: 256px;background:rgba(144, 238 ,144,0.6); filter:alpha(opacity=60); margin-left: 3%; margin-top: 2%;  }
            .lx{background:rgba(96, 96 ,96,0.6); filter:alpha(opacity=60);}
            .cgqzx{background:rgba(255,165,0,0.6); filter:alpha(opacity=60);}
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
                        var loops = data.looprs;
                        for (var i = 0; i < value.length; i++) {
                            var v1 = value[i];
                            var strid = "infonum" + v1.id;
                            // var str = v1.type == "1" ? "℃" : "%";
                            var str = "";
                            var pd = 0;
                            if (v1.type == "1") {
                                str = "℃";

                            } else if (v1.type == "2") {
                                str = "%RH";

                            } else if (v1.type == 3) {
                                if (v1.numvalue != null && v1.numvalue != "" && v1.numvalue != 0) {
                                    str = "闭合";
                                } else {
                                    str = "断开";
                                }
                                pd = 1;
                            }
                            var val = "";
                            if (pd == 1) {
                                val = str;
                            } else {
                                var numvalue = parseInt(v1.numvalue);
                                if (numvalue != 0) {
                                    numvalue = numvalue / 10;
                                }
                                val = numvalue + "<br>" + str;
                            }
                            $("#" + strid).innerHTML = val;
                        }

                        for (var j = 0; j < loops.length; j++) {
                            var loop = loops[j];
                            var lid = "loop" + loop.id;
                            var limg = "limg" + loop.id;
                            var str = "闭合";
                            if (loop.l_switch == 1) {
                                str = "闭合";
                                $("#" + limg).attr("src", "./img/l.png");
                            } else {
                                str = "断开";
                                $("#" + limg).attr("src", "./img/h.png");
                            }
                            $("#" + lid).html(str);


                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
            
             //计算时间差
            function TimeDifference(time1, time2)
            {

                time1 = new Date(time1.replace(/-/g, '/'));
                time2 = new Date(time2.replace(/-/g, '/'));
                var ms = Math.abs(time1.getTime() - time2.getTime());
                return ms / 1000 / 60;

            }
            $(function () {
               var pid = parent.parent.getpojectId();
               var slen = 0;
                $.ajax({url: "homePage.homePage.getSensorList.action", type: "POST", datatype: "JSON", data: {pid: pid},
                    success: function (data) {
                        var arrlist = data.rs;
                        var loops = data.looprs;
                        slen = arrlist.length + loops.length;
                        if (loops.length > 0) {
                            for (var j = 0; j < loops.length; j++) {
                                var loop = loops[j];
                                var bodydiv2 = document.createElement("div");
                                var img2 = document.createElement("img");
                                $(img2).attr("id", "limg" + loop.id);
                                str = "断开"; //状态
                                $(bodydiv2).addClass("hl");
                                if (loop.l_switch == 1) {
                                    str = "闭合";
                                    img2.src = "./img/l.png";
                                } else {
                                    str = "断开";
                                    img2.src = "./img/h.png";
                                }
                                var div11 = document.createElement("div");
                                $(div11).addClass("div1");
                                div11.innerHTML = "状态";
                                var div22 = document.createElement("div");
                                $(div22).addClass("div2");
                                $(div22).attr("id", "loop" + loop.id);
                                div22.innerHTML = str;
                                var div33 = document.createElement("div");
                                $(div33).addClass("div3");
                                $(div33).append(img2);
                                var div44 = document.createElement("div");
                                $(div44).addClass("div4");
                                $(div44).append(loop.l_name);
                                $(bodydiv2).append(div11);
                                $(bodydiv2).append(div22);
                                $(bodydiv2).append(div33);
                                $(bodydiv2).append(div44);
                                $("#parentdiv").append(bodydiv2);

                            }
                        }

                        if (arrlist.length > 0) {
                            for (var i = 0; i < arrlist.length; i++) {
                                var sensor = arrlist[i];
                                var bodydiv = document.createElement("div");
                                var img = document.createElement("img");
                                var str = "";
                                var str2 = "";  //湿度温度描述
                                var pd = 0;
                                var time1 = sensor.onlinetime.substring(0, 16);
                                var time2 = sensor.dtime.substring(0, 16);
                                var stime = TimeDifference(time1, time2);
                                if(stime>15){
                                    $(bodydiv).addClass("lx");  //离线
                                }else{
                                    $(bodydiv).addClass("cgqzx");  //在线 
                                }
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
                                        str = "闭合";
                                        img.src = "./img/k.png";
                                    } else {
                                        str = "断开";
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
                                    val = numvalue + "<br>" + str;
                                }
                                var div1 = document.createElement("div");
                                $(div1).addClass("div1");
                                div1.innerHTML = str2;
                                var div2 = document.createElement("div");
                                $(div2).addClass("div2");
                                $(div2).attr("id", "infonum" + sensor.id);
                                div2.innerHTML = val;
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
              
                setInterval('getinfo()', 10000);
                
                if(slen<=12){
                    //$("#activity_pane").style.height = 700px;
                    document.getElementById("activity_pane").style.height=850 +"px";
                }
                
            });

        </script>


    </head>
    <body id="activity_pane">
        <div style=" width: 100%;" class='top' id="parentdiv">
        </div>
    </body>
</html>
