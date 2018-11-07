<%-- 
    Document   : newjsp
    Created on : 2018-10-25, 16:37:40
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <script type="text/javascript" src="js/PerfectLoad.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">

            var MaskUtil = (function () {

                var $mask, $maskMsg;
                var defMsg = '正在处理，请稍待。。。';
                function init() {
                    if (!$mask) {
                        $mask = $("<div></div>")
                                .css({
                                    'position': 'absolute'
                                    , 'left': '0'
                                    , 'top': '0'
                                    , 'width': '100%'
                                    , 'height': '100%'
                                    , 'opacity': '0.3'
                                    , 'filter': 'alpha(opacity=30)'
                                    , 'display': 'none'
                                    , 'background-color': '#ccc'
                                })
                                .appendTo("body");
                    }
                    if (!$maskMsg) {
                        $maskMsg = $("<div></div>")
                                .css({
                                    'position': 'absolute'
                                    , 'top': '50%'
                                    , 'margin-top': '-20px'
                                    , 'padding': '5px 20px 5px 20px'
                                    , 'width': 'auto'
                                    , 'border-width': '1px'
                                    , 'border-style': 'solid'
                                    , 'display': 'none'
                                    , 'background-color': '#ffffff'
                                    , 'font-size': '14px'
                                })
                                .appendTo("body");
                    }

                    $mask.css({width: "100%", height: $(document).height()});

                    var scrollTop = $(document.body).scrollTop();

                    $maskMsg.css({
                        left: ($(document.body).outerWidth(true) - 190) / 2
                        , top: (($(window).height() - 45) / 2) + scrollTop
                    });

                }

                return {
                    mask: function (msg) {
                        init();
                        $mask.show();
                        $maskMsg.html(msg || defMsg).show();
                    }
                    , unmask: function () {
                        $mask.hide();
                        $maskMsg.hide();
                    }
                }

            }());

            function doSomething(msg) {
                MaskUtil.mask(msg);
                setTimeout(function () {
                    // 模拟操作时间,3秒后关闭
                    MaskUtil.unmask();

                }, 3000);
            }
            $(function () {
                $("#btn_submit").on("click", function () {
                    // $.bootstrapLoading.start({loadingTips: "正在处理数据，请稍候..."});
                    alert("dd");
                    ;
                    //ajaxLoading();
                })

            });
        </script>

        <style type="text/css">






        </style>    

    </head>
    <body>
        <button type="button" id="btn_submit" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span>加载测试</button>

        
        <input type="button" value="操作" onclick="doSomething()">
        <input type="button" value="操作2" onclick="doSomething('正在查询中...')">
        
                   <div class="row" id="row7"  >
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="delAllLoop()" class="btn btn-success btn-sm"><span id="211" name="xxx">删除全部回路开关信息</span></button>&nbsp;
                                                <button  type="button" onclick="delAllLoopPlan()" class="btn btn-success btn-sm"><span id="212">删除全部回路时间表</span></button>&nbsp;
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
        
        
    </body>
</html>
