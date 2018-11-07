<%-- 
    Document   : mainaction
    Created on : 2018-8-2, 13:40:37
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


        <script type="text/javascript" src="main.action_files/jquery.js"></script>
        <script type="text/javascript" src="main.action_files/layer.js"></script>
        <link rel="stylesheet" href="main.action_files/layer.css" id="layui_layer_skinlayercss" style="">
        <script type="text/javascript" src="main.action_files/utils.js"></script>
        <script type="text/javascript" src="main.action_files/ajaxUtils.js"></script>
        <link type="text/css" href="main.action_files/index2.css" rel="stylesheet">
        <link type="text/css" href="main.action_files/animate.css" rel="stylesheet">  

        <style>
            html,body{min-width:1100px;}
            ul li{cursor: pointer;}
            .glyphicon-change:before{content:url(imgs/bootstrapicon/change.png)}
            #alarmTable{
                width:800px;
                height:544px;
                position:absolute;
                right:252px;
                top:61px;
                display:none;
                border:1px solid #ccc;
                background:white;
                index:9;
                padding:10px;
                -webkit-box-shadow: 2px 2px 5px #333333;
                box-shadow: 2px 2px 5px #777;
                border-radius: 5px;
            }
            .controlMessage{
                width: auto;
                position: absolute;
                list-style: none;
                height: 60px;
                margin-right: 20px;
                color: #666666;
                top: 0;
                right: 0;
            }
            .controlMessage span{
                padding:0;
            }
            .controlMessage .two{
                width:auto;
            }
            .secondMenu {
                width:113px;
                background: rgba(255,255,255,0);
            }
            .secondMenu .secondMenuList{
                width:113px;
                line-height:40px;
                color:white;
                font-size:14px;
                border-bottom: 0px solid #01657b;
                text-align:left;
                padding-left: 57px;
                box-sizing: border-box;
                cursor:pointer;
                background:rgba(255,255,255,0);
            }
            .secondMenu .secondMenuList:hover{
                background:rgba(255,255,255,0);
            }
            .Home{
                float:left;
            }
            #iframe {
                padding-left: 0px; /*左侧多出两像素，处理*/
            }
            .controlMessage span {
                color:#fff;
                background: #1c2c38;
            }
            .controlMessage .one {
                border-left: 1px solid #071519;
                border-right: 1px solid #071519;
            }
            .controlMessage .two li {
                border: 1px solid #071519;
                background-color: #071519;
                color: #fff;
            }
            .bodyLeft {
                border-right: 0px solid #01657b;
                background: -ms-linear-gradient(left,rgba(13, 86, 107, 0.9) -300%,#0E122D 100%);
                background: -webkit-linear-gradient(left,rgba(13, 86, 107, 0.9) -300%,#0E122D 100%);
                background: -mos-linear-gradient(left,rgba(13, 86, 107, 0.9) -300%,#0E122D 100%);
            }
            .active {
                border-style:none;
                border-radius:4px;
                background: rgba(71, 142, 232, 0.4);
            } 
            .bodyLeftTop {
                border-bottom: 0px solid #01657b;
            }
            .eachMenu .list {
                border-bottom: 0px solid #01657b;
                width:150px;
            }
            .eachMenu{
                width: 91%;
                padding: 5px 5px 5px 5px;
                box-sizing: border-box;
                margin-top: 8px;
                margin-left: 5px;
            }
            ul.navTop{
                list-style:none;
                width:540px;
                height:52px;
                padding-top:7px;
                float: left;
                /* 			position: absolute;
                                    top: 0;
                                    left: 0px; */
            }
            ul.navTop li{
                /* display: none; */
                width:30px;
                height: 32px;
                float: left;
                margin-left: 15px;
                margin-top:10px;
                cursor: pointer;
                position: relative;
            }
            ul.navTop li span{
                position: absolute;
                top: 40px;
                left: 5px;	
                color: #fff;			
            }
            .controlMessage .one {
                border-style: none;
            }
            .controlMessage .one:hover {
                border-style: none;
            }
            .controlMessage span {
                color: #fff;
                background: #071519;
            }
            .controlMessage .two li {
                border: 1px solid #071519;
                background-color: #071519;
                color: #fff;
            }
            .controlMessage .two li:hover {
                background: #02bfcc;
                color: white;
            }
            .eachMenu .list .navIcon{
                width:100%;
                height:100%;
                margin: 0;
                position:absolute;
                top:0;
                left:0;
                z-index:-1;
            }

        </style>   



    </head>
    <body>

        <div class="wraper"> 
            <div class="bodyLeft" style="">
                <div class="bodyLeftTop listdisplayNone">
                    <!-- <img src="imgs/index/logo.png" style="width:40px;height:40px;"/> -->
                    <!-- <span class="menuMessage" style="width:80px;margin-left:30px;">智慧照明</span> -->

                    <span class="menuMessage" style="width:80px;margin-left:30px;">智慧照明</span>
                </div>
                <div class="MenuBox">
                    <div class="eachMenu">
                        <div class="list listdisplayNone active" name="mainsub.jsp">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/home.png">
                            <span class="menuMessage">综合首页</span>
                        </div>
                    </div>
                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="lightTab.jsp">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/lighting.png">
                            <span class="menuMessage">照明控制</srpan>
                        </div>
                    </div>
                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="#">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/map.png">
                            <span class="menuMessage">地图监控</span>
                        </div>
                    </div>


                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="strategyTab.jsp">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/map.png">
                            <span class="menuMessage">策略管理</span>
                        </div>
                    </div>  

                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="reporttab.jsp">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/map.png">
                            <span class="menuMessage">报表管理</span>
                        </div>
                    </div>

                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="paramconfig.htm">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/map.png">
                            <span class="menuMessage">设备管理</span>
                        </div>
                    </div>               
                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="#">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/map.png">
                            <span class="menuMessage">参数设置</span>
                        </div>
                    </div>  


                    <div class="eachMenu">
                        <div class="list listdisplayNone" name="main/map.action">
                            <img class="navIcon" src="main.action_files/border.png">
                            <img src="main.action_files/map.png">
                            <span class="menuMessage">权限管理</span>
                        </div>
                    </div>

                </div>
            </div>

            <div class="bodyRight" style="padding-left: 173px;">
                <div id="navTop" style="width: 100%; height: 60px; border-bottom: 0px solid rgb(204, 204, 204); background: rgb(14, 18, 45) none repeat scroll 0% 0%;">
                    <button id="changeSize" class="navbar-minimalize clicks" style="cursor: pointer;display: none;">
                        <span class="glyphicon glyphicon-change"></span>
                    </button>
                    <div class="CCIOT-logo" style="display:none;height:60px;float:left;padding-top:7px;padding-left:15px;box-sizing:border-box;">
                        <img src="main.action_files/sz-tit.png" style="min-width:50px;height:50px;float:left;" id="logoImg">
                    </div>
                    <ul class="navTop" style="left: 200px; display: none;">
                        <!-- 首页顶部导航	 -->
                        <li title="照明" name="main/device.action" style="background:url(&quot;imgs/indexNav/2.png&quot;)"></li><li title="地图" name="main/map.action" style="background:url(&quot;imgs/indexNav/3.png&quot;)"></li></ul>
                    <ul class="controlMessage animated fadeInRight">
                        <li class="one imgM Home" style="display: none; border-left: 1px solid rgb(14, 18, 45); border-right: medium none rgb(14, 18, 45);">
                            <img alt="" src="main.action_files/home_s.png" style="height:21px;width:21px;margin-top:2px;">
                        </li>
                        <!-- <li class="one imgM phone">
                                <img src="imgs/index/phone_s.png"/>
                        </li> -->
                        <li class="one imgM" style="border-left: 1px solid rgb(14, 18, 45); border-right: medium none rgb(14, 18, 45);">
                            <img src="main.action_files/alarm_s.png" class="alarmLi">
                            <div class="alarmNub alarmLi" id="alarmNumber">0</div>
                        </li>
                        <li class="one setName" style="width: 74px; display: block; border-left: 1px solid rgb(14, 18, 45); border-right: medium none rgb(14, 18, 45);">
                            <span class="Till" style="width: 74px; text-align: center; background: rgb(14, 18, 45) none repeat scroll 0% 0%;">配置</span>
                            <ul class="two animated fadeInDown language setMenu">

                                <li action="config/paramConfig.action">参数配置</li><li action="config/gateway.action">网关配置</li><li action="config/alarmConfig.action">项目配置</li></ul>
                        </li>
                        <li class="one" style="width: 74px; border-left: 1px solid rgb(14, 18, 45); border-right: medium none rgb(14, 18, 45);">
                            <span class="Till" style="width: 74px; text-align: center; background: rgb(14, 18, 45) none repeat scroll 0% 0%;">语言</span>
                            <ul class="two animated fadeInDown language">
                                <li language="zh_CN">中文</li>
                                <li language="en_US" style="border-top:none;">英文</li>
                            </ul>
                        </li>
                        <li class="one" style="width: 74px; display: none; border-left: 1px solid rgb(14, 18, 45); border-right: medium none rgb(14, 18, 45);">
                            <span class="Till" style="width: 74px; text-align: center; background: rgb(14, 18, 45) none repeat scroll 0% 0%;">主题</span>
                            <ul class="two mainStyle">
                                <li>默认</li>
                                <li style="border-top:none;">颜色</li>
                            </ul>
                        </li>
                        <li class="one" style="width: 127px; padding-left: 5px; padding-right: 5px; border-left: 1px solid rgb(14, 18, 45); border-right: medium none rgb(14, 18, 45);">
                            <span class="Till" style="width: 174px; background: rgb(14, 18, 45) none repeat scroll 0% 0%;">
                                <img src="main.action_files/user_s.png" style="margin-right:6px;">
                                <span class="admin" style="background: rgb(14, 18, 45) none repeat scroll 0% 0%;">huaming1</span>
                            </span>
                            <ul class="two animated fadeInDown twoL">
                                <li>退出</li>
                                <li style="border-top:none;display:none;">修改密码</li>
                            </ul>
                        </li>
                    </ul> 
                </div>
                <input id="names" value="" type="hidden">
                <input id="configurations" value="[{&quot;title&quot;:&quot;参数配置&quot;,&quot;action&quot;:&quot;config/paramConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/paramConfiguration.png&quot;},{&quot;title&quot;:&quot;网关配置&quot;,&quot;action&quot;:&quot;config/gateway.action&quot;,&quot;icon&quot;:&quot;imgs/manager/gatewayConfiguration.png&quot;},{&quot;title&quot;:&quot;项目配置&quot;,&quot;action&quot;:&quot;config/alarmConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/alarmConfiguration.png&quot;}]" type="hidden">
                <iframe id="iframe" src="mainsub.jsp" seamless="" style="height: 849px;" width="100%" frameborder="0">
                </iframe>
            </div>
        </div>

        <iframe id="alarmTable" src="#" name="alarmTable" frameborder="0">
        </iframe>


        <script type="text/javascript">

            $(function () {


                $(".alarmLi").click(function () {
                    $("#alarmTable").css("display", "block");
                    document.getElementById('alarmTable').contentWindow.document.location.reload();
                });

                var tip = 0;
                $(".clicks").click(function () {
                    if (tip == 0) {
                        $(".bodyLeft").css("width", "56px");
                        $(".bodyRight").css("paddingLeft", "56px");
                        $(".menuMessage").css("display", "none");
                        $(".listdisplayNone").css("width", "56px");
                        $(".eachMenu").addClass("eachMenuSmaller");
                        $(".listdisplayNone").css("display", "none");
                        $(".secondMenu").css("display", "none");
                        setTimeout(function () {
                            $(".listdisplayNone").css("display", "block");
                        }, 500);
                        tip = 1;
                    } else {
                        $(".bodyLeft").css("width", "140px");
                        $(".bodyRight").css("paddingLeft", "140px");
                        $(".eachMenu").removeClass("eachMenuSmaller");
                        $(".listdisplayNone").css("display", "none");
                        setTimeout(function () {
                            $(".menuMessage").css("display", "block");
                            $(".listdisplayNone").css("width", "140px");
                            $(".listdisplayNone").css("display", "block");

                        }, 500);
                        tip = 0;
                    }
                })

                $("body").delegate(".list", "click", function () {
                    if ($(this).siblings(".secondMenu").length != 0) {
                        if ($(this).parent(".eachMenuSmaller").length == 0) {
                            if ($(this).siblings(".secondMenu").css("display") == "block") {
                                $(this).siblings(".secondMenu").css("display", "none");
                            } else {
                                $(this).siblings(".secondMenu").css("display", "block");
                            }
                        } else {
                        }
                    } else {
                        $(this).addClass("active");
                        $(this).parent(".eachMenu").siblings(".eachMenu").children(".list").removeClass("active");
                        $(this).parent(".eachMenu").siblings(".eachMenu").children(".secondMenu").children(".secondMenuList").removeClass("active");
                        var iframesrc = $(this).attr("name");
                        $("#iframe").attr("src", iframesrc);
                    }
                })

                $("body").delegate(".secondMenu .secondMenuList", "click", function () {
                    $(this).addClass("active");
                    $(this).parent(".secondMenu").siblings(".list").addClass("active");
                    $(this).siblings(".secondMenuList").removeClass("active");
                    $(this).parent(".secondMenu").parent(".eachMenu").siblings(".eachMenu").children(".list").removeClass("active");
                    $(this).parent(".secondMenu").parent(".eachMenu").siblings(".eachMenu").children(".secondMenu").children(".secondMenuList").removeClass("active");
                    var iframesrc = $(this).attr("name");
                    $("#iframe").attr("src", iframesrc);
                })

                $("body").delegate(".eachMenuSmaller", "mouseover", function () {
                    $(this).children(".secondMenu").css("display", "block");
                })

                $("body").delegate(".eachMenuSmaller", "mouseout", function () {
                    $(this).children(".secondMenu").css("display", "none");
                })

                function size() {
                    var iframeHeight = $(window).height() - 57;
                    $("#iframe").css("height", iframeHeight);
                }
                size();
                window.onresize = function () {
                    console.log("aaaa");
                    size();
                }

                /* 登录注销 */
                $(".Home").click(function () {
                    $("#iframe").attr("src", "main/homeIntelligent.action");
                    /* $('#navTop').css("background","#071519"); */
                    changeColor("#071519");
                })

                /* 登录注销 */
                $(".twoL li:eq(0)").click(function () {
                    doPostRequest({}, "user/userLogout.action", function (retult) {
                        layer.alert('注销成功!', {icon: 4, offset: 'center'});
                        window.top.location.href = "forward.jsp";
                    },
                            function (error) {
                                alert(error.message);
                            });
                })

                /* 加载左边菜单 */
                $.ajax({
                    type: "post",
                    url: "#", //getMainMenus.action
                    dataType: "json",
                    success: function (data) {
                        var htmls = '';
                        var isIntelligentLampPoleProject = false;
                        var includesHome = false;
                        var names = [];
                        var configurations = [];
                        for (var i = 0; i < data.length; i++) {
                            if (data[i].code != 1) {
                                if (data[i].children.length == 0) {
                                    htmls += '<div class="eachMenu" >'
                                            + '<div class="list listdisplayNone" name="' + data[i].action + '">'
                                            + '<img class="navIcon" src="imgs/index/border.png"/>'
                                            + '<img src="' + data[i].icon + '"/>'
                                            + '<span class="menuMessage">' + data[i].title + '</span>'
                                            + '</div>'
                                            + '</div>';
                                    if (data[i].code == 6) {
                                        names[names.length] = {title: data[i].title, code: data[i].code};
                                        //显示首页顶部导航中的图标
                                        /* $(".navTop").append('<li title="' + data[i].children[j].title +'" name="' + data[i].children[j].action 
                                         +'" style=background:url("imgs/indexNav/' + data[i].children[j].code + '.png")></li>'); */
                                    }
                                } else {
                                    htmls += '<div class="eachMenu" >'
                                            + '<div class="list listdisplayNone" name="' + data[i].action + '">'
                                            + '<img class="navIcon" src="imgs/index/border.png"/>'
                                            + '<img src="' + data[i].icon + '"/>'
                                            + '<span class="menuMessage">' + data[i].title + '</span>'
                                            + '</div>'
                                            + '<div class="secondMenu">';
                                    for (var j = 0; j < data[i].children.length; j++) {
                                        htmls += '<div class="secondMenuList" name="' + data[i].children[j].action + '">' + data[i].children[j].title + '</div>';
                                        if (data[i].code == 5) {
                                            if (2 != -1) {
                                                isIntelligentLampPoleProject = true;
                                            }
                                            if (data[i].children[j].code == '5b' || data[i].children[j].code == '5c') {
                                                isIntelligentLampPoleProject = false;
                                            }
                                            names[j] = {title: data[i].children[j].title, code: data[i].children[j].code};
                                            //显示首页顶部导航中的图标
                                            $(".navTop").append('<li title="' + data[i].children[j].title + '" name="' + data[i].children[j].action
                                                    + '" style=background:url("imgs/indexNav/' + data[i].children[j].code + '.png")></li>');
                                        } else if (data[i].code == 4) {
                                            configurations[j] = {title: data[i].children[j].title, action: data[i].children[j].action, icon: data[i].children[j].icon};
                                        }
                                    }
                                    htmls += '</div></div>';
                                }
                                if (data[i].code == 2) {//显示首页顶部导航中的“照明”图标
                                    $(".navTop").append('<li title="' + data[i].title + '" name="' + data[i].action + '" style=background:url("imgs/indexNav/' + data[i].code + '.png")></li>');
                                }
                                if (data[i].code == 3) {//显示首页顶部导航中的“地图”图标
                                    $(".navTop").append('<li title="' + data[i].title + '" name="' + data[i].action + '" style=background:url("imgs/indexNav/' + data[i].code + '.png")></li>');
                                }
                            } else {
                                includesHome = true;
                            }
                        }
                        if (isIntelligentLampPoleProject) {
                            $(".bodyRight").css("padding-left", "0px");
                            htmls = '<div class="eachMenu" >'
                                    + '<div class="list listdisplayNone" name="main/homeIntelligent.action">'
                                    + '<img class="navIcon" src="imgs/index/border.png"/>'
                                    + '<img src="imgs/index/home.png"/>'
                                    + '<span class="menuMessage">首页</span>'
                                    + '</div>'
                                    + '</div>' + htmls;
                        } else {
                            $(".bodyRight").css("padding-left", "140px");
                            $(".bodyLeft").css("display", "");
                            $(".navTop").css("left", "200px");//顶部导航
                            $("#changeSize").css("display", 'none');
                            $(".Home").css("display", 'none');
                            if (includesHome) {
                                htmls = '<div class="eachMenu" >'
                                        + '<div class="list listdisplayNone" name="main/home.action">'
                                        + '<img class="navIcon" src="imgs/index/border.png"/>'
                                        + '<img src="imgs/index/home.png"/>'
                                        + '<span class="menuMessage">首页</span>'
                                        + '</div>'
                                        + '</div>' + htmls;
                            }
                        }
                        if (names.length != 0) {
                            $("#names").val(JSON.stringify(names));
                        }
                        if (configurations.length != 0) {
                            $("#configurations").val(JSON.stringify(configurations));
                        }
                        $(".MenuBox").html(htmls);
                        $(".list:eq(0)").addClass("active");
                        var ifrsrc = $(".list:eq(0)").attr("name");
                        $("#iframe").attr("src", ifrsrc);

                        var user = false;
                        if (user && ($("#iframe").attr("src") == 'main/homeIntelligent.action')) {								//针对于地球平台logo
                            $(".CCIOT-logo").css('display', '');
                            var logoWidth = $(".CCIOT-logo img").width() + 20;
                            $(".navTop").css("left", logoWidth);
                        }


                        var navStand = $("#iframe").attr("src");
                        if (navStand == 'main/home.action') {		   //针对于root权限的顶部背景
                            $('.navTop').css("display", "none");
                            $("#changeSize").css("display", "none");
                            changeColor("#0E122D");
                        } else if (navStand == 'main/device.action') {//针对于照明平台初始化导航栏变色
                            changeColor("#0E122D");
                        }

                        var _configurations = $('#configurations').val();
                        if (_configurations != '') {
                            $(".setName").css("display", "block");
                            var configurationsObj = JSON.parse(_configurations);
                            $.each(configurationsObj, function (i, item) {
                                var li = $('<li action="' + item.action + '">' + item.title + '</li>');
                                $(".setMenu").append(li);
                                li.click(function () {
                                    $('#iframe').attr("src", $(this).attr('action'));
                                    $(".navCon").hide();
                                    $(".logo").hide();
                                });
                            });

                        }


                    }
                });

                $(".language li:eq(0)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                });
                $(".language li:eq(1)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                });

                //语言切换
                function changeLanguage(language) {
                    doPostRequest({locale: language}, "user/changeLocale.action", function (retult) {
                        window.top.location.href = "main.action";
                    },
                            function (error) {
                                alert(error.message);
                            });
                }



            });



            $(function () {
                $(".navTop").delegate("li", "click", function () {
                    var html = $(this).attr('name');
                    $("#iframe").attr('src', html);
                    //导航栏颜色
                    var standSrc = $("#iframe").attr("src");
                    if (standSrc == 'main/homeIntelligent.action') {
                        changeColor('#071519');
                    } else {
                        changeColor('#0E122D');
                    }
                });


                //控制首页顶部导航显示
                $("#navTop").mouseenter(function () {
                    var navArry = $(".navTop li");
                    var speed = 0;
                    for (var i = 0; i <= navArry.length; i++) {
                        $(".navTop li").eq(i).show(speed + 50);
                        speed += 50;
                    }
                });
                //控制首页顶部导航隐藏
                $(".navTop").mouseleave(function () {
                    var navArry_out = $(".navTop li");
                    var speed_out = 0;
                    for (var i = 0; i <= navArry_out.length; i++) {
                        $(".navTop li").eq(i).stop().hide(speed_out + 50);
                        speed_out += 50;
                    }
                });
            });


            function changeColor(color) {
                $("#navTop").css("background", color);
                $('.controlMessage .one').css({"border-left": "1px solid " + color, "border-right": color});
                /* $('.controlMessage .two li').css({"border":"1px solid " + color,"background-color":color}); */
                $(".controlMessage span").css("background", color);
            }
        </script>      



    </body>
</html>
