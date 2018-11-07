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
            var websocket = null;
            var conectstr = "ws://119.28.130.53:16181/";
            function onopen(e) {
            }
            function onmessage(e) {
                var info = eval('(' + e.data + ')');
                console.log("main onmessage");
                console.log(info);

                if (info.hasOwnProperty("page")) {
                    console.log(info.page);
                    var obj = $("iframe").eq(0);
                    var win = obj[0].contentWindow;
                    if (info.page == 1) {
                        var func = info.function;
                        console.log(func);
                        win[func](info);
                    } else if (info.page == 2) {
                        win.callchild(info);
                    }
                }
            }

            function onclose(e) {
                console.log(e);
                console.log("websocket close");
                websocket.close();
            }
            function  onerror(e) {
                console.log("Webscoket连接发生错误");
            }
            function onbeforeunload(e) {
                websocket.close();
            }
            function hit() {
                var obj = {};

                obj.pid = "lp00001";
                // obj.l_comaddr="我们";
                var code = encodeURI("回");
                obj.l_comaddr = code;
                obj.type = "ALL";
                console.log(code);
                var opt = {
                    url: "loop.loopForm.getLoopList.action",
                    query: obj
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);
            }



            $(function () {
                //####### Tooltip
                $("#tooltip").tooltip();
            });


            $(function () {


//                if ('WebSocket' in window) {
//                    websocket = new WebSocket(conectstr);
////                    websocket = new WebSocket("ws://localhost:5050/");
//                } else {
//                    alert('当前浏览器不支持websocket');
//                }
//                // 连接成功建立的回调方法
//                websocket.onopen = onopen;
//                //接收到消息的回调方法
//                websocket.onmessage = onmessage;
//                //连接关闭的回调方法
//                websocket.onclose = onclose;
//                //连接发生错误的回调方法
//                websocket.onerror = onerror;
//                //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
//                window.onbeforeunload = onbeforeunload;

            });
            function sendmsg() {
                var data = $("#aaa").val();
                var ddd = Str2BytesH(data);
                console.log(ddd);
                var binary = new Uint8Array(ddd.length);
                for (var i = 0; i < ddd.length; i++) {
                    binary[i] = ddd[i];
                }
                websocket.send(binary.buffer);
            }
            function sendmsgascill() {
                var data = $("#bbb").val();
                websocket.send(data);
            }
            function  connect1() {
                if ('WebSocket' in window) {
                    websocket = new WebSocket(conectstr);
//                    websocket = new WebSocket("ws://localhost:5050/");
                } else {
                    alert('当前浏览器不支持websocket');
                }
                // 连接成功建立的回调方法
                websocket.onopen = onopen;
                //接收到消息的回调方法
                websocket.onmessage = onmessage;
                //连接关闭的回调方法
                websocket.onclose = onclose;
                //连接发生错误的回调方法
                websocket.onerror = onerror;
                //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
                window.onbeforeunload = onbeforeunload;
            }
            function close1() {
                websocket.close();
            }
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
