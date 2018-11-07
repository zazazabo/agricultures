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

        </style>
        <script type="text/javascript" src="js/genel.js"></script>

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
    <body id="activity_pane">


<!--        <div id="tooltip">
            <input id="age" title="dsfsdfsd" />
        </div>-->


                <h1>Hello World!</h1>
                <form id="form1">
                    <input value="回" name="l_comaddr" />
                    <input type="button" onclick="hit()" value="搜索" />
                </form>
        
        
        
                <div class="link_category">     
                    <div class="link">
                        <a class="loading-ajax">simulate 1-second Ajax load</a>
                    </div>
                </div>
                <input name="aa" id="aaa" style="width:300px;height: 100px;" type="textarea" value=""/>
                <input type="button" onclick="sendmsg();" value="发送hex" id="aaa" value=""/>
        
                <input name="aa" id="bbb" style="width:300px;height: 100px;" type="textarea" value=""/>
                <input type="button" onclick="sendmsgascill();" value="发送ascill" id="aaa" value=""/>    
        
           <input type="button" onclick="connect1();" value="连接" id="aaa" value=""/>    
           <input type="button" onclick="close1();" value="断开" id="aaa" value=""/>    
    </body>
</html>
