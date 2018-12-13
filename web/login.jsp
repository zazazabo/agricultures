<%-- 
    Document   : login
    Created on : 2018-8-21, 9:47:23
    Author     : Administrator
--%>

<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8" language="java"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>登录系统平台</title>
        <link rel="icon" href="Images/logo.ico" type="image/x-icon" />
        <style>
            *{margin:0;padding:0;}
            html,body{
                margin:0;
                padding:0;
                width:100%;
                height:100%;
                overflow: hidden;
            }
            ::-webkit-scrollbar {
                width:0px;
                height:4px;
            }
            ::-webkit-scrollbar-button    {
                background-color:#000208;
            }
            ::-webkit-scrollbar-track     {
                background:#000208;
            }
            ::-webkit-scrollbar-track-piece {
                background:#000208;
            }
            ::-webkit-scrollbar-thumb{
                background:#000208;
                border-radius:4px;
            }
            ::-webkit-scrollbar-corner {
                background:#000208;
            }
            ::-webkit-scrollbar-resizer  {
                background:#000208;
            }
            html{
                scrollbar-3dlight-color	:#000208;
                scrollbar-highlight-color :	#000208;
                scrollbar-face-color : #000208;
                scrollbar-arrow-color : #000208;
                scrollbar-shadow-color : #000208;
                scrollbar-dark-shadow-color	:#000208;
                scrollbar-base-color :	#000208;
                scrollbar-track-color : #000208;
            }
            .logo-animate{
                height:410px;
                position:absolute;
                left:8%;   
                top:20%;
                display:none;
            }
            @media screen and (min-width:1024px) and (max-width:1366px){  
                .logo-animate{
                    top:30%;
                }
                .logo-animate img{  

                    height:410px;  
                }  
            } 
            @media screen and (min-width:1366px) and (max-width:1440px){  
                .logo-animate{
                    top:30%;
                }
                .logo-animate img{  
                    height:410px; 
                }  
            } 
            @media screen and (min-width:1440px) and (max-width:1600px){  
                .logo-animate{
                    top:30%;
                }
                .logo-animate img{  
                    height:410px; 
                }  
            } 
            @media screen and (min-width:1600px) and (max-width:1920px){  
                .logo-animate img{  
                    height:610px; 
                }  
            } 
            @media screen and (min-width:1920px) and (max-width:2000px){  
                .logo-animate img{  
                    height:610px;  
                }  
            }		
            #rememberPW{
                color:  #FFB800;
            }
            input{
                outline-style:none;
            }
            body{
                width:100%;
                height:100%;
                /* 			background:url(imgs/login/login-bg.jpg) no-repeat center center;
                                        background-size:100% 100%;
                                        -moz-background-size: 100% 100%; 
                                        -o-background-size: 100% 100%; 
                                        -webkit-background-size: 100% 100%;  */
                font-family: "microsoft yahei";font-weight:normal;
            } 
            label{
                color:#ccc;
            }
            .logo,.h3{
                -webkit-user-select:none;
                -moz-user-select:none;
                -o-user-select:none;
                user-select:none;
            }
            .changeLanguage div{
                -webkit-user-select:none;
                -moz-user-select:none;
                -o-user-select:none;
                user-select:none;
                color:  #FFB800;
            }
            .logo{
                padding-top: 55px;
                padding-left: 70px;
                box-sizing: border-box;
                font-size:30px;
                color: #e6e6e6;
                display:none; 
                position: absolute;
                top: 0;
            }
            .loginBox{
                width: 443px;
                height: 400px;
                position:absolute;
                right:37%;   
                top:33%;
                /* transform: translate(-50%,-50%); */  
                border-style:none;
                border:1px solid #022D7D;
                box-shadow:0 5px 15px rgba(0,0,0,.5);
                -moz-box-shadow:0 5px 15px rgba(0,0,0,.5);
                -webkit-box-shadow:0 5px 15px rgba(0,0,0,.5);
                border-radius:15px;
                -webkit-border-radius:15px;
                -moz-border-radius:15px; 
                -ms-border-radius:15px;  
                -o-border-radius:15px;
                /*                background:rgba(2,8,25,0.49);*/
                display:none;  
            }

            .register{
                width:100%;
                height:300px;
                text-align:center;
                position:relative;
            }
            .register form{
                width:400px;
                height:300px;
                position:absolute;
                left:50%;    /* 若�鵝�&#65533;띄벨&#65533;&#65533;50% */
                top:155px;
                transform: translate(-50%,-50%); /*&#65533;ゅ런&#65533;&#65533;50% */
            }
            .loginBox .h3{
                height: 60px;
                line-height: 60px;
                text-align: center;
                font-size: 30px;
                color: #FFB800;
            }
            .inputText{
                width: 315px;
                height: 50px;
                border:1px solid #123374;
                -webkit-border-radius:15px;
                -moz-border-radius:15px; 
                -ms-border-radius:15px;  
                -o-border-radius:15px;
                border-radius:5px;
                padding-left:5px;
                background-color:whitesmoke;
                /*                -webkit-box-shadow: 0 0 0px 1000px #04193A inset;
                                -moz-box-shadow: 0 0 0px 1000px #04193A inset;*/
                /*                box-shadow: 0 0 0px 1000px #04193A inset;*/
                color: #FFB800;
            }
            label.name{
                display:none;
            }
            .checkBox{
                width: 345px;
                margin-top: 10px;
                padding-right:180px;
                font-size: 14px;
                line-height: 30px;
                margin-left: 18%;

            }
            .logion{
                width:315px;height:50px;
                -webkit-border-radius:15px;
                -moz-border-radius:15px; 
                -ms-border-radius:15px;  
                -o-border-radius:15px;
                border-radius:5px;
                margin-left:54px;
                background: -webkit-linear-gradient(top,#0F3284,#031946);  
                background: -o-linear-gradient(top,#0F3284,#031946);  
                background: -moz-linear-gradient(top,#0F3284,#031946);  
                background: -ms-linear-gradient(top,#0F3284 0%,#031946 100%);  
                background: linear-gradient(top,#0F3284,#031946);  
                color: #FFB800;
                text-align:center;
                line-height:20px;
                border:1px solid #123374;
                margin-top:10px;
                cursor:pointer;
                font-size:16px;
                letter-spacing:8px;
            }
            .visitReg{
                float:right;
                margin-right:50px;
                cursor:pointer;
                color:#009999;
            }
            input:-webkit-autofill {
                -webkit-animation: autofill-fix 1s infinite;
            }

            @-webkit-keyframes autofill-fix {
                from {
                    background-color: transparent;
                    color:#ccc;
                    border:1px solid #123374;
                }
                to {
                    background-color: transparent;
                    color:#ccc;
                    border:1px solid #123374;
                }
            }
            input:hover{
                background-color:#BFD4F8;
                border-color:#123374;
            }
            .icon{
                float:left;
                width:50px;
                height:50px;

            }
            .iconName{
                background:url(img/user-scret.png) no-repeat 10px 10px;


            }
            .iconPassword{
                background:url(img/user-scret.png) no-repeat 10px -61px;
            }
            .changeLanguage{
                width:150px;
                height:40px;
                position:absolute;
                top:20px;
                right:4%;
            }
            .Zh{
                float:left;
                width:70px;
                height:40px;
                line-height:40px;
                font-size:14px;
                color:#BFD4F8;
                cursor:pointer;
            }
            .En{
                float:right;
                width:60px;
                height:40px;
                line-height:40px;
                font-size:14px;
                color:#BFD4F8;
                cursor:pointer;
            }
            .line{
                margin-top:10px;
                margin-left:-10px;
                float:left;
                font-size:14px;
                color:#BFD4F8;
            }

            @media screen and (min-width:0px) and (max-width:736px){  
                .logo-animate{
                    top:30%;
                }
                .logo-animate img{  
                    display:none;
                }  
                .phoneTit{
                    height:37px;
                }
                .loginBox{
                    width: 305px;
                    height: 325px;
                    position: inherit;
                    right: 12%;
                    top: 28%;
                    transform: translate(-50%,-50%);  	 			
                    border-style:none;
                    border:1px solid #022D7D;
                    box-shadow:0 5px 15px rgba(0,0,0,.5);
                    -moz-box-shadow:0 5px 15px rgba(0,0,0,.5);
                    -webkit-box-shadow:0 5px 15px rgba(0,0,0,.5);
                    border-radius:15px;
                    -webkit-border-radius:15px;
                    -moz-border-radius:15px; 
                    -ms-border-radius:15px;  
                    -o-border-radius:15px;
                    /*                    background:rgba(2,8,25,0.49);*/
                    /*                    margin: 50px auto 0 auto; */
                    margin-left: 50%;
                    margin-top: 70%;

                    display:none;  
                }
                .inputText{
                    width: 186px;
                    height: 37px;
                    padding-left:15px;
                    box-sizing: border-box;
                }
                .register form {
                    width: 249px;
                    height: 215px;
                    position: absolute;
                    left: 50%;
                    top: 114px;
                    transform: translate(-50%,-50%);
                }
                .logion{
                    width: 190px;
                    height: 40px;
                }
                .loginBox .h3 {
                    height: 40px;
                    line-height: 40px;
                    text-align: center;
                    font-size: 24px;
                    color: #BFD4F8;
                }
                .register {
                    width: 100%;
                    height: 224px;
                    text-align: center;
                    position: relative;
                }		
                .logo {
                    padding-top: 125px;
                    padding-left: 0;
                    width: 300px;
                    margin: 0 auto;
                    text-align: center;
                    position: relative;
                }
                #large-header{
                    display: none;
                }
            }
            @media screen and (min-width:736px) and (max-width:1024px){  
                .logo-animate{
                    top:30%;
                }
                .logo-animate img{  
                    display:none;
                }
                .phoneTit{
                    height:37px;
                }  
                .loginBox{
                    width: 305px;
                    height: 325px;
                    position: inherit; 
                    right: 12%;
                    top: 28%;
                    transform: translate(-50%,-50%);
                    border-style:none;
                    border:1px solid #022D7D;
                    box-shadow:0 5px 15px rgba(0,0,0,.5);
                    -moz-box-shadow:0 5px 15px rgba(0,0,0,.5);
                    -webkit-box-shadow:0 5px 15px rgba(0,0,0,.5);
                    border-radius:15px;
                    -webkit-border-radius:15px;
                    -moz-border-radius:15px; 
                    -ms-border-radius:15px;  
                    -o-border-radius:15px;
                    background:rgba(2,8,25,0.49);                  
                    /*                    margin: 50px auto 0 auto;*/
                    margin-left: 50%;
                    margin-top: 40%;
                    display:none;  
                }
                .logion{
                    width: 190px;
                    height: 40px;
                }
                .register form {
                    width: 249px;
                    height: 215px;
                    position: absolute;
                    left: 50%;
                    top: 114px;
                    transform: translate(-50%,-50%);
                }
                .loginBox .h3 {
                    height: 40px;
                    line-height: 40px;
                    text-align: center;
                    font-size: 24px;
                    color: #BFD4F8;
                }		
                .register {
                    width: 100%;
                    height: 224px;
                    text-align: center;
                    position: relative;
                }	
                .inputText{
                    width: 186px;
                    height: 37px;
                    padding-left:15px;
                    box-sizing: border-box;
                }
                .logo {
                    padding-top: 125px;
                    padding-left: 0;
                    width: 300px;
                    margin: 0 auto;
                    text-align: center;
                    position: relative;
                }
                #large-header{
                    display: none;
                }
            } 

        </style>

        <%@include  file="js.jspf" %>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/md5.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript">
            $.extend({
                PostSubmitForm: function (url, args) {
                    var body = $(document.body),
                            form = $("<form method='post' style='display:none'></form>"),
                            input;
                    form.attr({"action": url});
                    $.each(args, function (key, value) {
                        input = $("<input type='hidden'>");
                        input.attr({"name": key});
                        input.val(value);
                        form.append(input);
                    });

                    //IE低版本和火狐下
                    form.appendTo(document.body);
                    form.submit();
                    document.body.removeChild(form[0]);
                }
            });

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            $(function () {
                //获取cookie的值
                var username = getCookieValue("username");
                var password = getCookieValue("password");
                $("#username").val(username);
                $("#password").val(password);
                if (username != null && password != null) {
                    $("#cc").prop("checked", true);

                }
                if (username == null && password == null) {
                    $("#cc").prop("checked", false);
                }
                //登陆
                $("#login").click(function () {
                    var pass = $("#password").val();
                    var name = $("#username").val();
                    var password = hex_md5(pass);
                    var obj = {};
                    obj.name = name;
                    obj.password = password;
                    $.ajax({async: false, url: "login.loginform.loginhand.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            // console.log(data);
                            var arrlist1 = data.rs;
                            if (arrlist1.length > 0) {
                                var pid = "";
                                if (arrlist1[0].pid == "" || arrlist1[0].pid == null) {
                                    pid = "";
                                } else {
                                    var pids = arrlist1[0].pid.split(",");   //项目编号
                                    pid = pids[0];
                                }
                                console.log(pid);
                                addlogon(name, "登陆", pid, "登陆", "登陆");

                                var o1 = arrlist1[0];
                                o1.role = arrlist1[0].m_code;
                                console.log(o1);
                                $.PostSubmitForm('login.main.home.action', arrlist1[0]);


                            } else if (arrlist1.length == 0) {
                                //alert("用户名或密码错误！");
                                layerAler("账号或密码错误！");

                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                });

                //打勾记住密码
                $("#cc").click(function () {
                    var pwd = $("#password").val();
                    var username = $("#username").val();
                    if (pwd == "" || username == "") {
                        $("#cc").prop("checked", false);
                    } else if ($("#cc").is(":checked")) {
                        //记住密码前先清除原先记住的密码
                        addCookie("rmbUser", "false", -1);
                        addCookie("username", "", -1);
                        addCookie("password", "", -1);
                        //记住新密码
                        addCookie("rmbUser", "true", 7);
                        addCookie("username", username, 7);
                        addCookie("password", pwd, 7);

                    } else {
                        addCookie("rmbUser", "false", -1);
                        addCookie("username", "", -1);
                        addCookie("password", "", -1);
                    }
                })
                //添加ckooie 记住密码
                function addCookie(username, value, days) {
                    var username = escape(username).trim();
                    var value = escape(value).trim();
                    var expires = new Date();
                    expires.setTime(expires.getTime() + days * 3600000 * 24);
                    var _expires = (typeof days) == "String" ? "" : ";expires=" + expires.toUTCString();
                    document.cookie = username + "=" + value + _expires;
                }

                //获取cookie 得到密码
                function getCookieValue(username) {
                    var allcookies = document.cookie;
                    var aCookie = document.cookie.split(";");
                    for (var i = 0; i < aCookie.length; i++) {
                        var aCurmb = aCookie[i].split("=");
                        var username2 = aCurmb[0].toString().trim();
                        username = username.toString();
                        if (username == username2) {
                            return unescape(String(aCurmb[1]));
                        }

                    }
                    return  null;

                }

                //清除cookie
                function clearCookie(cname) { //为了删除指定的cookice
                    var date = new Date();
                    date.setTime(date.getTime() - 10000);
                    document.cookie = name + "=a;expires=" + date.toGMTString();

                }
                //切换中文
                $("#chinese").click(function () {
                    $("#chinese").html("中文");
                    $("#rememberPW").html("记住密码");
                    $("#login").val("登陆");
                    $("#top").html("账号登陆");
                    setCookie("lang", "zh_CN");
                });
                //切换英文
                $("#english").click(function () {
                    $("#chinese").html("Chinese");
                    $("#rememberPW").html("remember password");
                    $("#login").val("Login");
                    $("#top").html("Account login");
                    setCookie("lang", "en_US");
                });
               
               $("#username").focus();

            });
            //回车登录
            document.onkeydown = function mykeyDown(e) {
                //compatible IE and firefox because there is not event in firefox
                e = e || event;
                if (e.keyCode == 13) {
                    document.getElementById("login").click(); //调用登录按钮的登录事件
                }
            };

        </script>
    </head>
    <body>
        <div id="large-header" class="large-header" style="height: 914px;">
            <canvas id="demo-canvas" width="1398" height="914"></canvas>
        </div>

        <img src="./img/ny.jpg" style="position:absolute;top:0;left:0;z-index:-1;width:100%;height:100%;">

        <div class="changeLanguage">
            <div language="zh_CN" class="Zh" id="chinese">中文</div>
            <div class="line">|</div>
            <div language="en_US" class="En" id="english">English</div>
        </div>

        <!--
                <div class="logo-animate animated bounceIn" style="display: block;">
                    <img src="./img/sz-animate.png">
                </div>-->

        <div class="loginBox animated bounceInUp" style="display: block;">
            <div class="h3" id="top">账号登陆</div>
            <div style="width:100%;height:40px;">
                <span style="margin-top:5px;color:red;margin-left:140px;display:block;">

                </span>
            </div>
            <div class="register">
                <form id="myfrom">
                    <input type="hidden" name="_refererView" value="login">
                    <div class="userNameBox"> 
                        <div class="icon iconName"></div>
                        <label for="userName" class="name">用户名</label>
                        <input type="text" class="inputText" id="username" name="username" value="">
                    </div>
                    <div style="width:100%;height:40px;"></div>
                    <div class="passwordBox">
                        <div class="icon iconPassword"></div>
                        <label for="passWord" class="name">密码</label>
                        <input type="password" class="inputText" id="password" name="password" value="">
                    </div>
                    <div class="checkBox">
                        <input type="checkbox" id="cc" value="">
                        <label for="rememberPW" id="rememberPW">记住密码</label>
                    </div>
                    <input class="logion" type="button" id="login" value="登陆">
                </form>  	
            </div>

        </div>

    </body>
</html>
