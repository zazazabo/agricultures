<%-- 
    Document   : tab1
    Created on : 2018-8-6, 15:48:58
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache"> 

        <title>调光</title>
        <link rel="stylesheet" type="text/css" href="layer/layui.css">
        <link rel="stylesheet" type="text/css" href="layer/subNavStyle.css">

        <link id="layuicss-laydate" rel="stylesheet" href="layer/laydate.css" media="all">
        <link id="layuicss-layer" rel="stylesheet" href="layer/layer.css" media="all">
        <link id="layuicss-skincodecss" rel="stylesheet" href="layer/code.css" media="all">


        <script type="text/javascript" src="js/genel.js"></script>
        <script>
            function callchild(obj) {
                var func = obj.function;
                var objchild = $("iframe").eq(0);
                var win = objchild[0].contentWindow;
                if (win.hasOwnProperty(func)) {
                    win[func](obj);
                }
            }
        </script>
    </head>

    <body>
        <div class="contents">
            <div class="top">
                <ul class="secondMenu layui-nav">
                    <!--                                        <li name="lightval.jsp" class="layui-nav-item layui-this active"><a href="javascript:;">单灯调光</a></li>
                    <li name="lightgroupe.jsp" class="layui-nav-item"><a href="javascript:;">按组调光</a></li>-->


                    <!--<span class="layui-nav-bar" style="width: 0px; left: 484px; opacity: 0; top: 45px;"></span>-->
                </ul>
            </div>

            <div  id="content-main">
                <iframe id="myiframe" class="J_iframe" name="iframe0" src="#"  seamless="" width="100%" frameborder="0"  height="800px"></iframe>
            </div>
        </div>
        <!--<script type="text/javascript" src="abc_files/jquery.js"></script>-->
        <script type="text/javascript" src="layer/layui.js"></script>  

        <script>
            $(function () {
                $(".secondMenu").children('li').remove();
                var objrole = {role: ${param.role}, m_parent:${param.m_parent}};

                $.ajax({
                    type: "post", async: false, url: "formuser.mainmenu.querysub.action", dataType: "json", data: objrole,
                    success: function (datas) {
//                        console.log(datas);
                        var htmls = "";
                        var i = 0;
                        datas.forEach(function (data) {
                            var action = data.m_action;
                            var lang = "${param.lang}";

                            var objlang = eval('(' + data.m_title + ')');
                            var u1 = action + "?m_parent=" + data.m_code + "&role=${param.role}&pid=${param.pid}&lang=${param.lang}";
                            //console.log(u1);
//                            htmls += '<li class="layui-nav-item" name="' + action + '">'

                            htmls += '<li class="layui-nav-item" name="' + u1 + '">'
                                    + '<a href="javascript:;">'
                                    + objlang[lang]
                                    + '</a>'
                                    + '</li>'
                        });
                        htmls += '<span class="layui-nav-bar" style="width: 0px; left: 484px; opacity: 0; top: 45px;"></span>';
                        $(".secondMenu").html(htmls);
                    }
                });


                /* 初始化加载三级菜单 */
                var htmlFirst = $(".secondMenu li:eq(0)").attr('name');
//                console.log(htmlFirst);
//
//                if (htmlFirst.indexOf("lightval.jsp") != -1) {
//                    dealsend3("CheckLamp", "a", 0, 0, "check", 0, 0, "${param.pid}");
//                }
                $(".J_iframe").attr('src', htmlFirst);

                $(".secondMenu li:eq(0)").addClass("layui-this active").siblings("li").removeClass("layui-this active");
                /* 结束 */

                $(".secondMenu li").click(function () {
                    $(this).addClass("layui-this active").siblings("li").removeClass("layui-this active");
                    var html = $(this).attr('name');
                    console.log(html);
                    $(".J_iframe").attr('src', html);
                })
                function size() {
                    var height = $(document.body).height() - 60;
                    $(".J_mainContent").height(height);
                }
                size();
                window.onresize = function () {
                    size();
                }
            })

        </script>
    </body>
</html>
