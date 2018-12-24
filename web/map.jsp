<%-- 
    Document   : map
    Created on : 2018-8-2, 15:29:53
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <script src="layer/layer.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <style type="text/css">
            body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
            .search>tr>td {
                padding-top: 20px;
            }
            #showtext{
                width: 230px;
                height: 50px;
                font-size: 20px;
            }
            #fdiv{
                width: 70%;
                margin-left: -20%;
            }
            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 

            #up-map-div{
                width:300px;
                top:10%;
                left:60%;
                position:absolute;
                z-index:9999;
                border:1px solid blue;
                background-color:#FFFFFF;
            }
            #ta tr td{
                margin-top: 20px;

            }
            .items li{ 
                width: 100px;
                height:20px; 
                text-align:left; 
                margin-left: -40px;
                line-height:20px; 
                cursor:pointer;

            } 
            .items li:hover {color: #FF00FF}
            #showdiv{
                top:0%;
                left:14%;
                position:absolute;
                z-index:9999;
                filter:alpha(opacity=40);
            }
        </style>
        <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=19mXqU4pjrrqSH20w2gORu6OhFaKddYo"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script type="text/javascript" src="bootstrap-table/dist/bootstrap-table.js"></script>
        <script type="text/javascript" src="bootstrap-table/dist/locale/bootstrap-table-zh-CN.min.js"></script>
        <script type="text/javascript" src="bootstrap-table/dist/locale/bootstrap-table-zh-CN.js"></script>
        <script>
            function wg() {
                var allOver = map.getOverlays(); //获取全部标注
                for (var j = 0; j < allOver.length; j++) {
                    if (allOver[j].toString() == "[object Marker]") {
                        //清除所有标记
                        map.removeOverlay(allOver[j]);
                    }
                    if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                        map.removeOverlay(allOver[j]);
                    }
                }
                var pid = parent.getpojectId();
                var objw = {};
                objw.pid = pid;
                if ($("#lampcomaddrlist2").val() != "") {
                    objw.comaddr = $("#lampcomaddrlist2").val();
                }
                $.ajax({async: false, url: "login.map.lnglat.action", type: "get", datatype: "JSON", data: objw,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length > 0) {
                            wglist(arrlist);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            function  cgq() {
                var allOver = map.getOverlays(); //获取全部标注
                for (var j = 0; j < allOver.length; j++) {
                    if (allOver[j].toString() == "[object Marker]") {
                        //清除所有标记
                        map.removeOverlay(allOver[j]);
                    }
                    if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                        map.removeOverlay(allOver[j]);
                    }
                }
                var pid = parent.getpojectId();
//                    var d = new Date();
//                    var day = d.toLocaleDateString();
                var lobj = {};
                lobj.pid = pid;
                if ($("#lampcomaddrlist2").val() != "") {
                    lobj.comaddr = $("#lampcomaddrlist2").val();
                }
                $.ajax({async: false, url: "login.map.queryLamp.action", type: "get", datatype: "JSON", data: lobj,
                    success: function (data) {

                        var arrlist = data.rs;
                        if (arrlist.length > 0) {
                            lamplists(arrlist);
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
        </script>
    </head>
    <body>
        <div id="showdiv">
            <input type="text" id="showtext" readonly="true" >
            <span style=" margin-left: 20px;">网关</span>：
            <input id="lampcomaddrlist2" data-options="editable:true,valueField:'id', textField:'text'"  class="easyui-combobox"/>&nbsp;
            <button onclick="wg()"><span>网关</span></button>
            <button onclick="cgq()" id="dj"><span >传感器</span></button>
            <button id="bzzt"><span>标识状态</span></button>
        </div>
        <div id="allmap">

        </div>
        <div id="up-map-div" style=" display: none">
            <table style=" margin-left: 10%; width: 80%;">
                <tr style=" border-bottom:1px solid green">
                    <th><span id="12" name="xxxx">状态</span></th>
                    <th></th>
                    <th><spn name="xxxx" id="283">标识</spn></th>
                </tr>
                <tr>
                    <td><span name="xxxx" id="298">传感器在线</span>:</td>
                    <td style=" color: green;">-----------------</td>
                    <td><img src="img/cglv.png" style=" margin-left:-7px;"></td>
                </tr>
                <tr>
                    <td><span name="xxxx" id="299">传感器离线</span>:</td>
                    <td style=" color: #93a1a1;">-----------------</td>
                    <td><img src="img/cglan.png" style=" margin-left: -10px;"></td>
                </tr>
                <tr>
                    <td><span name="xxxx" id="300">传感器异常</span>:</td>
                    <td style=" color: red;">-----------------</td>
                    <td><img src="img/cgred.png" style=" margin-left: -10px;"></td>
                </tr>
                <tr>
                    <td><span name="xxxx" id="296">网关在线</span>:</td>
                    <td style=" color: green;">-----------------</td>
                    <td><img src="img/wzx.png"></td>
                </tr>
                <tr>
                    <td><span name="xxxx" id="297">网关离线</span>:</td>
                    <td style=" color: #93a1a1;">-----------------</td>
                    <td><img src="img/wlx.png"></td>
                </tr>
            </table>
        </div>
        <!-- 添加 网关-->
        <div  id="addwanguang" class="bodycenter"  style=" display: none" >
            <div class="">
                <div class="">
                    <table>
                        <tbody class="search">
                            <tr>
                                <td>
                                    <span style="margin-left:0px;" id="64" name="xxxx">
                                        所属区域
                                    </span>&nbsp;
                                    <input type="text" id ="area" style="width:150px; height: 30px;">
                                </td>
                                <td>
                                    <span style="margin-left:30px;">                                     
                                        <span id="25" name="xxxx">网关地址</span>
                                        &nbsp;</span>
                                    <input id="comaddrlist" data-options='editable:false,valueField:"id", textField:"text"' class="easyui-combobox"/>
                                </td>
                                <td>
                                    <!-- <input type="button" class="btn btn-sm btn-success" onclick="selectlamp()" value="搜索" style="margin-left:10px;">-->
                                    <button class="btn btn-sm btn-success" onclick="getInfoByComaddr()" style="margin-left:10px;"><span id="34" name="xxxx">搜索</span></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <hr>
                <div>
                    <table id="wgtable">

                    </table>
                </div>
            </div>
        </div>
        <!--添加传感器-->
        <div  id="addlamp" class="bodycenter"  style=" display: none" >
            <div class="">
                <div  style="min-width:700px;">   
                    <div class="">
                        <table>
                            <tbody class="search">
                                <tr>
                                    <td>
                                        <span style="margin-left:30px;" id="54" name="xxxx">
                                            传感器名称
                                        </span>&nbsp;
                                        <input type='text' id='lampname'>
                                    <td>
                                        <span style="margin-left:50px;">
                                            <span id="55" name="xxxx">所属网关</span>
                                            &nbsp;</span>
                                        <input id="lampcomaddrlist" data-options='editable:false,valueField:"id", textField:"text"' class="easyui-combobox"/>
                                    </td>
                                    <td>
                                        <!-- <input type="button" class="btn btn-sm btn-success" onclick="selectlamp()" value="搜索" style="margin-left:10px;">-->
                                        <button class="btn btn-sm btn-success" onclick="selectlamp()" style="margin-left:10px;"><span id="34" name="xxxx">搜索</span></button>
                                    </td>
                                </tr>                                   
                            </tbody>
                        </table>
                    </div>
                    <hr>
                    <div>
                        <table id="lamptable">

                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            //创建网关在线图标
            var wggreenicon = new BMap.Icon('./img/wzx.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建网关离线图标
            var wghuiicon = new BMap.Icon('./img/wlx.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建传感器离线图标
            var lhui = new BMap.Icon('./img/cglan.png', new BMap.Size(27, 32), {//20，30是图片大小
                // anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建传感器在线图标
            var lgreen = new BMap.Icon('./img/cglv.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建传感器异常图标
            var lred = new BMap.Icon('./img/cgred.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建传感器亮灯图标
            var lyello = new BMap.Icon('./img/lyello.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
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

            var pid = parent.parent.getpojectId();
            //调用父页面的方法获取用户名
            var u_name = parent.getusername();

            var lans = parent.parent.getLnas();
            var lang = "${param.lang}";
            //加载所有传感器信息
            function  getAllLampInfo(pid) {

                $('#lamptable').bootstrapTable({
                    url: 'login.map.sensor.action?pid=' + pid,
                    columns: [
                        {
                            title: 'id',
                            field: 'id',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            visible: false, //不显示
                            class: 'lampId'
                        },
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'name',
                            title: '传感器名称', //传感器名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_comaddr',
                            title: '所属网关', //所属网关
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.replace(/\b(0+)/gi, "");
                            }
                        },
                        {
                            field: 'longitude',
                            title: '经度', //经度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: '纬度', //纬度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'onlinetime',
                            title: '在线状态', //在线状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                var str = "";
                                var time1 = value.substring(0, 16);
                                var time2 = row.dtime.substring(0, 16);
                                var stime = TimeDifference(time1, time2);
                                var obj = {};
                                obj.comaddr = row.l_comaddr; //selects[0];
                                $.ajax({url: "login.gateway.comaddrzx.action", async: false, type: "get", datatype: "JSON", data: obj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist[0].online == 1) {
                                            if (stime <= 15) {
                                                str = "<img  src='img/online1.png'/>";
                                            } else {
                                                str = "<img  src='img/off.png'/>";
                                            }
                                        } else {
                                            str = "<img  src='img/off.png'/>";
                                        }
                                    },
                                    error: function () {
                                        alert("提交添加失败！请刷新");
                                    }
                                });
                                return  str;
                            }
                        }],
                    method: "post",
                    contentType: "application/x-www-form-urlencoded",
                    singleSelect: false, //设置单选还是多选，true为单选 false为多选
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 15,
                    showRefresh: false,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1"   
                        };      
                        return temp;  
                    }
                });
            }
            //加载所有所属网关信息
            function getAllInfo() {
                var pid = parent.getpojectId();
                $("#wgtable").bootstrapTable({
                    url: 'login.map.map.action?pid=' + pid,
                    columns: [
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'model',
                            title: lans[62][lang], //型号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'name',
                            title: lans[63][lang], //名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'comaddr',
                            title: lans[25][lang], //网关地址
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.replace(/\b(0+)/gi, "");
                            }
                        }, {
                            field: 'Longitude',
                            title: lans[59][lang], //经度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: lans[60][lang], //纬度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'online',
                            title: lans[61][lang], //在线状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value == 1) {
                                    return "<img  src='img/online1.png'/>";
                                } else {
                                    return "<img  src='img/off.png'/>";
                                }

                            }
                        }],
                    singleSelect: false,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    // minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: false, //是否显示刷新
                    // showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1"   
                        };      
                        return temp;  
                    }
                });
            }

            //根据所属网关查询网关信息
            function getInfoByComaddr() {

                var comaddr = $("#comaddrlist").val();
                var area = $("#area").val();
                var obj = {};
                obj.type = "ALL";
                if (comaddr != "") {
                    obj.comaddr = comaddr;
                }
                if (area != "") {
                    obj.area = encodeURI(area);
                }
                var pid = parent.getpojectId();
                obj.pid = pid;

                var opt = {
                    //method: "post",
                    url: "login.map.map.action",
                    silent: true,
                    query: obj
                };
                $("#wgtable").bootstrapTable('refresh', opt);
            }
            //关闭添加传感器弹窗
            function  lampout() {
                $("#lamptable input:checkbox").each(function () {
                    if ($(this).is(":checked")) {
                        $(this).prop("checked", false);
                    }
                });
                layer.close(layer.index);
            }
            //关闭添加网关弹窗
            function closeAddComaddr() {
                $("#wgtable input:checkbox").each(function () {
                    if ($(this).is(":checked")) {
                        $(this).prop("checked", false);
                    }
                });
                layer.close(layer.index);
            }
            // 百度地图API功能
            var map = new BMap.Map("allmap", {enableMapClick: false}); // 创建Map实例
            map.centerAndZoom(new BMap.Point(116.404, 39.915), 15); // 初始化地图,设置中心点坐标和地图级别
            //添加地图类型控件
            map.addControl(new BMap.MapTypeControl({
                mapTypes: [
                    BMAP_NORMAL_MAP,
                    BMAP_HYBRID_MAP
                ]}));
          //  map.centerAndZoom("湛江", 15); // 设置地图显示的城市 此项是必须设置的
            map.enableScrollWheelZoom(true); //开启鼠标滚轮缩放

            var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}); // 左上角，添加比例尺
            var top_left_navigation = new BMap.NavigationControl(); //左上角，添加默认缩放平移控件
            var top_right_navigation = new BMap.NavigationControl({anchor: BMAP_ANCHOR_TOP_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); //右上角，仅包含平移和缩放按钮
            /*缩放控件type有四种类型:
             BMAP_NAVIGATION_CONTROL_SMALL：仅包含平移和缩放按钮；BMAP_NAVIGATION_CONTROL_PAN:仅包含平移按钮；BMAP_NAVIGATION_CONTROL_ZOOM：仅包含缩放按钮*/
            map.addControl(top_left_control);
            map.addControl(top_left_navigation);
            map.addControl(top_right_navigation);
            function ZoomControl() {
                // 默认停靠位置和偏移量
                this.defaultAnchor = BMAP_ANCHOR_TOP_LEFT;
                this.defaultOffset = new BMap.Size(450, 5);
            }

            // 通过JavaScript的prototype属性继承于BMap.Control
            ZoomControl.prototype = new BMap.Control();
            // 自定义控件必须实现自己的initialize方法,并且将控件的DOM元素返回
            // 在本方法中创建个div元素作为控件的容器,并将其添加到地图容器中
            //           ZoomControl.prototype.initialize = function (map) {
//                var o = parent.parent.getLnas();
//                var lang = "${param.lang}";
//                // 创建一个DOM元素
//                var div = document.createElement("div");
//                div.setAttribute("id", "fdiv");
//                var button1 = document.createElement("input");
//                var text = document.createElement("input"); //显示经纬度
//                text.setAttribute("type", "text");
//                text.setAttribute("value", "");
//                text.setAttribute("id", "showtext");
//                text.setAttribute("style", "margin-right: 40px;");
//                text.setAttribute("readonly", "readonly");
//                div.appendChild(text);
//                button1.setAttribute("type", "text");
//                button1.setAttribute("value", "");
//                button1.setAttribute("id", "seartxt");
//                div.appendChild(button1);
//                var button2 = document.createElement("input");
//                button2.setAttribute("type", "button");
//                button2.setAttribute("value", o[34][lang]);//搜索按钮
//                button2.setAttribute("style", "margin-left: 5px");
//                button2.setAttribute("id", "search");
//                div.appendChild(button2);
//                var button3 = document.createElement("input");
//                button3.setAttribute("type", "button");
//                button3.setAttribute("value", o[50][lang]);//网关按钮
//                button3.setAttribute("style", "margin-left: 5px");
//                button3.setAttribute("id", "jzq");
//                div.appendChild(button3);
//                var button4 = document.createElement("input");
//                button4.setAttribute("type", "button");
//                button4.setAttribute("value", o[51][lang]); //传感器按钮
//                button4.setAttribute("style", "margin-left: 5px");
//                button4.setAttribute("id", "dj");
//                div.appendChild(button4);
//
//                var button5 = document.createElement("input");
//                button5.setAttribute("type", "button");
//                button5.setAttribute("value", o[52][lang]);//状态标识
//                button5.setAttribute("style", "margin-left: 5px");
//                button5.setAttribute("id", "zt");
//                div.appendChild(button5);
//
//                var button6 = document.createElement("input");
//                button6.setAttribute("type", "button");
//                button6.setAttribute("value", o[414][lang]);//状态标识
//                button6.setAttribute("style", "margin-left: 5px");
//                button6.setAttribute("id", "zt");
//                div.appendChild(button6);
//
//                //网关单击事件
//                button3.onclick = function (e) {
//                    var allOver = map.getOverlays(); //获取全部标注
//                    for (var j = 0; j < allOver.length; j++) {
//                        if (allOver[j].toString() == "[object Marker]") {
//                            //清除所有标记
//                            map.removeOverlay(allOver[j]);
//                        }
//                        if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
//                            map.removeOverlay(allOver[j]);
//                        }
//                    }
//                    var pid = parent.getpojectId();
//                    var objw = {};
//                    objw.pid = pid;
//                    $.ajax({async: false, url: "login.map.lnglat.action", type: "get", datatype: "JSON", data: objw,
//                        success: function (data) {
//                            var arrlist = data.rs;
//                            if(arrlist.length>0){
//                                 wglist(arrlist);
//                            }
//                        },
//                        error: function () {
//                            alert("提交失败！");
//                        }
//                    });
//                };
//                //搜索网关
//                button2.onclick = function (e) {
//                    var pid = parent.getpojectId();
//                    var allOver = map.getOverlays(); //获取全部标注
//                    for (var j = 0; j < allOver.length; j++) {
//                        if (allOver[j].toString() == "[object Marker]") {
//                            //清除所有标记
//                            map.removeOverlay(allOver[j]);
//                        }
//                        if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
//                            map.removeOverlay(allOver[j]);
//                        }
//                    }
//                    var obj = {};
//                    var comaddr = $("#seartxt").val();
//                    if (comaddr != "") {
//                        obj.comaddr = comaddr;
//                    }
//                    obj.pid = pid;
//                    $.ajax({async: false, url: "login.map.lnglat.action", type: "get", datatype: "JSON", data: obj,
//                        success: function (data) {
//                            var arrlist = data.rs;
//                            if (arrlist.length > 0) {
//                                for (var i = 0; i < arrlist.length; i++) {
//                                    var obj = arrlist[i];
//                                    var Longitude = obj.Longitude;
//                                    var latitude = obj.latitude;
//                                    var Iszx = o[285][lang];   //离线    
//                                    if (obj.online == 1) {
//                                        Iszx = o[284][lang];   //在线    
//                                    }
//                                    if (Longitude != "" && latitude != "") {
//                                        var point = new BMap.Point(Longitude, latitude);
//                                        var marker1;
//                                        var marker1;
//                                        if (obj.online == 1) {
//                                            marker1 = new BMap.Marker(point, {
//                                                icon: wggreenicon
//                                            });
//                                        } else {
//                                            marker1 = new BMap.Marker(point, {
//                                                icon: wghuiicon
//                                            });
//                                        }
//                                        marker1.setTitle(obj.comaddr + "," + Iszx);   //这里设置maker的title (鼠标放到marker点上,会出现它的title,所以我这里把name,放到title里)
//                                        map.addOverlay(marker1);
//                                        map.panTo(point);
//                                    }
//                                }
//                            } else {
//                                alert(o[301][lang]);  //不存在该网关
//                            }
//                        },
//                        error: function () {
//                            alert("提交失败！");
//                        }
//                    });
//                };
//
//                //传感器
//                button4.onclick = function (e) {
//                    var allOver = map.getOverlays(); //获取全部标注
//                    for (var j = 0; j < allOver.length; j++) {
//                        if (allOver[j].toString() == "[object Marker]") {
//                            //清除所有标记
//                            map.removeOverlay(allOver[j]);
//                        }
//                        if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
//                            map.removeOverlay(allOver[j]);
//                        }
//                    }
//                    var pid = parent.getpojectId();
//                    var d = new Date();
//                    var day = d.toLocaleDateString();
//                    var lobj = {};
//                    lobj.pid = pid;
//                    lobj.f_day = day;
//                    $.ajax({async: false, url: "login.map.queryLamp.action", type: "get", datatype: "JSON", data: lobj,
//                        success: function (data) {
//
//                            var arrlist = data.rs;
//                            if(arrlist.length>0){
//                               lamplists(arrlist);
//                            }
//                            
//                        },
//                        error: function () {
//                            alert("提交失败！");
//                        }
//                    });
//                };
//                var ij = 0;
//                button5.onclick = function (e) {
//                    if (ij == 0) {
//                        $("#up-map-div").show();
//                        ij = 1;
//                    } else {
//                        $("#up-map-div").hide();
//                        ij = 0;
//                    }
//                };
//
//                button6.onclick = function (e) {
//                    dealsend3("CheckLamp", "a", 0, 0, "check", 0, 0, "${param.pid}");
//                }
//                // 添加DOM元素到地图中
//                map.getContainer().appendChild(div);
//                // 将DOM元素返回
//                return div;
//            };

            var txtMenuItem = [
                {
                    text: '添加传感器', //添加传感器
                    callback: function () {
                        var allOver = map.getOverlays(); //获取全部标注
                        for (var j = 0; j < allOver.length; j++) {
                            if (allOver[j].toString() == "[object Marker]") {
                                //清除所有标记
                                map.removeOverlay(allOver[j]);
                            }
                            if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                                map.removeOverlay(allOver[j]);
                            }
                        }

                        //加载所有传感器信息
                        var porjectId = parent.getpojectId();
                        var obj = {};
                        obj.pid = porjectId;
                        var opt = {
                            method: "post",
                            contentType: "application/x-www-form-urlencoded",
                            url: "login.map.sensor.action",
                            silent: true,
                            query: obj
                        };
                        $("#lamptable").bootstrapTable('refresh', opt);
                        var id = "#lampcomaddrlist";
                        combobox(id, porjectId);
                        //清空标记
                        draw = false;
                        idlist = [];
                        onedraw = false;
                        wgdraw = false;
                        wgonedraw = false;
                        wgidlist = [];
                        $("#addlamp").dialog("open");


                    }
                },
                {
                    text: '添加网关', //添加网关
                    callback: function () {

                        var allOver = map.getOverlays(); //获取全部标注
                        for (var j = 0; j < allOver.length; j++) {
                            if (allOver[j].toString() == "[object Marker]") {
                                //清除所有标记
                                map.removeOverlay(allOver[j]);
                            }
                            if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                                map.removeOverlay(allOver[j]);
                            }
                        }
                        var porjectId = parent.getpojectId();
                        var obj = {};
                        obj.pid = porjectId;
                        //加载所有网关信息
                        var opt = {
                            method: "post",
                            contentType: "application/x-www-form-urlencoded",
                            url: "login.map.map.action",
                            silent: true,
                            query: obj
                        };
                        $("#wgtable").bootstrapTable('refresh', opt);
                        //加载所属网关
                        var id = "#comaddrlist";
                        combobox(id, porjectId);
                        //清空标记
                        wgdraw = false;
                        wgonedraw = false;
                        wgidlist = [];
                        draw = false;
                        idlist = [];
                        onedraw = false;
                        $('#addwanguang').dialog('open');
                    }
                }
            ];
            //传感器选点绘线
            var draw = false;   //标记是否多点绘线
            var onedraw = false;  //勾选单个传感器
            var lampchecck;   //勾选单个传感器对象
            var idlist = new Array();  //标记选中的id
            function  Drawing() {
                var lampchecck2 = $("#lamptable").bootstrapTable('getSelections');
                if (lampchecck2.length > 1) {
                    draw = true;
                    for (var i = 0; i < lampchecck2.length; i++) {
                        idlist.push(lampchecck2[i].id);
                    }
                    $("#lamptable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#lamptable").bootstrapTable('refresh');
                    $('#addlamp').dialog("close");
                } else if (lampchecck2.length == 1) {
                    onedraw = true;
                    lampchecck = lampchecck2[0];
                    $("#lamptable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#lamptable").bootstrapTable('refresh');
                    $('#addlamp').dialog("close");
                } else {
                    alert(lans[73][lang]);  //请勾选表格数据
                }
            }
            //网关选点绘线
            var wgdraw = false;   //标记网关是否多点绘线
            var wgonedraw = false;  //勾选单个网关
            var wgchecck;   //勾选单个网关对象
            var wgidlist = new Array();  //标记选中网关的id
            function  wgDrawing() {
                var wgcheck2 = $("#wgtable").bootstrapTable('getSelections');
                if (wgcheck2.length > 1) {
                    wgdraw = true;
                    for (var i = 0; i < wgcheck2.length; i++) {
                        wgidlist.push(wgcheck2[i].comaddr);
                    }
                    $("#wgtable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#wgtable").bootstrapTable('refresh');
                    $('#addwanguang').dialog("close");
                } else if (wgcheck2.length == 1) {
                    wgonedraw = true;
                    wgchecck = wgcheck2[0];
                    $("#wgtable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#wgtable").bootstrapTable('refresh');
                    $('#addwanguang').dialog("close");
                } else {
                    alert("请勾选表格数据");  //请勾选表格数据
                }
            }
            //根据条件查询传感器
            function selectlamp() {
                var porjectId = parent.getpojectId();
                var lampname = $("#lampname").val();
                var l_commadr = $("#lampcomaddrlist").val();
                var obj = {};
                obj.type = "ALL";
                if (lampname != "") {
                    obj.l_name = encodeURI(lampname);
                }
                obj.l_comaddr = l_commadr;
                obj.pid = porjectId;
                var opt = {
                    url: "login.map.lamp.action",
                    silent: true,
                    query: obj
                };
                $("#lamptable").bootstrapTable('refresh', opt);
            }
            $(function () {
                var porjectId = parent.getpojectId();
                combobox("#lampcomaddrlist2", porjectId);
                $("#bzzt").mouseover(function () {
                    $("#up-map-div").show();
                });
                $("#bzzt").mouseout(function () {
                    $("#up-map-div").hide();
                });
                var obj2 = {};
                obj2.pid = porjectId;
                $.ajax({async: false, url: "login.map.getAllinfo.action", type: "get", datatype: "JSON", data: obj2,
                    success: function (data) {
                        var arrlist = data.wgrs;   //网关集合
                        var lamplist = data.lamprs;  //灯具集合
                        if (arrlist.length > 0) {
                            wglist(arrlist);
                        }
                        if (lamplist.length > 0) {
                            lamplists(lamplist);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                $('#slide_lamp_val').slider({
                    onChange: function (v1, v2) {
                        $("#val").val(v1);
                    }
                });
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(lans[e][lang]);
                }
                //加载所有网关信息
                getAllInfo();
                //加载传感器信息
                getAllLampInfo(porjectId);
                $("#addwanguang").dialog({
                    autoOpen: false,
                    modal: false,
                    width: 650,
                    height: 550,
                    left: 150,
                    top: 50,
                    buttons: {
                        选点绘线: function () {
                            wgDrawing();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#addlamp").dialog({
                    autoOpen: false,
                    modal: false,
                    width: 720,
                    height: 550,
                    left: 150,
                    top: 50,
                    buttons: {
                        选点绘线: function () {   //选点绘线
                            Drawing();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#switchCj").dialog({
                    autoOpen: false,
                    modal: false,
                    width: 420,
                    height: 200,
                    position: ["top", "top"],
                    buttons: {
                        关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#ddljtg").dialog({
                    autoOpen: false,
                    modal: false,
                    width: 350,
                    height: 200,
                    position: ["top", "top"],
                    buttons: {
                        关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });



                var marker; //创建标注对象
                // 创建控件
                var myZoomCtrl = new ZoomControl();
                // 添加到地图当中
                map.addControl(myZoomCtrl);
                var menu = new BMap.ContextMenu();
                for (var i = 0; i < txtMenuItem.length; i++) {
                    menu.addItem(new BMap.MenuItem(txtMenuItem[i].text, txtMenuItem[i].callback, 100));
                }
                map.addContextMenu(menu);
                //鼠标移动事件
                map.addEventListener("mousemove", function (e) {
                    var str = e.point.lng + "," + e.point.lat;
                    $("#showtext").val(str);
                });
                //修改网关经纬度
                function updatelnglat(lng, lat, comaddr) {
                    var porjectId = parent.getpojectId();
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.comaddr = comaddr;
                    $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var obj = {};
                                obj.pid = porjectId;
                                //加载所有网关信息
                                var opt = {
                                    //method: "post",
                                    url: "login.map.map.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#wgtable").bootstrapTable('refresh', opt);
                                var now_point = new BMap.Point(lng, lat);
                                marker = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                                var label = new BMap.Label(comaddr, {offset: new BMap.Size(20, 0)}); //创建marker点的标记,这里注意下,因为百度地图可以对label样式做编辑,所以我这里吧重要的id放在了label(然后再隐藏)   
                                label.setStyle({display: "none"}); //对label 样式隐藏    
                                marker.setLabel(label); //把label设置到maker上 
                                marker.enableDragging(); //标注可拖拽
                                map.addOverlay(marker); // 添加标注
                                // 开启事件监听,标注移动事件
                                marker.addEventListener("dragend", function (e) {
                                    var x = e.point.lng; //经度
                                    var y = e.point.lat; //纬度
                                    if (confirm("该设备已有经纬度了，您确定更改吗?")) {  //该设备已有经纬度了，您确定更改吗?
                                        var obj2 = {};
                                        obj2.Longitude = x;
                                        obj2.latitude = y;
                                        obj2.comaddr = e.target.getLabel().content; //获取标注隐藏的值
                                        $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                            success: function (data) {
                                                var arrlist = data.rs;
                                                if (arrlist.length == 1) {
                                                    var obj = {};
                                                    obj.pid = porjectId;
                                                    //加载所有网关信息
                                                    var opt = {
                                                        //method: "post",
                                                        url: "login.map.map.action",
                                                        silent: true,
                                                        query: obj
                                                    };
                                                    $("#wgtable").bootstrapTable('refresh', opt);

                                                } else {
                                                    alert(lans[281][lang]);  //修改失败
                                                }
                                            },
                                            error: function () {
                                                alert("提交添加失败！");
                                            }
                                        });
                                    }

                                });
                            } else {
                                alert("修改失败");  //修改失败
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                }
                //修改多个传感器的经纬度
                function updateMayLamplnglat(lng, lat, id) {
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.id = id;
                    $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });

                }
                //修改单个传感器经纬度
                function updateLamplnglat(lng, lat, id) {
                    var porjectId = parent.getpojectId();
                    var nobj2 = {};
                    nobj2.name = u_name;
                    var day = getNowFormatDate2();
                    nobj2.time = day;
                    nobj2.type = "修改";
                    nobj2.comment = "修改传感器经纬度";
                    nobj2.page = "地图导航";
                    nobj2.pid = porjectId;
                    $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj2,
                        success: function (data) {
                            var arrlist = data.rs;
                        }
                    });
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.id = id;
                    $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var obj = {};
                                obj.pid = porjectId;
                                var opt = {
                                    //method: "post",
                                    url: "login.map.lamp.action",
                                    silent: true,
                                    query: obj
                                };
                                //  $("#lamptable").bootstrapTable('refresh', opt);
                                var now_point = new BMap.Point(lng, lat);
                                marker = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                                var label = new BMap.Label(id, {offset: new BMap.Size(20, 0)}); //创建marker点的标记,这里注意下,因为百度地图可以对label样式做编辑,所以我这里吧重要的id放在了label(然后再隐藏)   
                                label.setStyle({display: "none"}); //对label 样式隐藏    
                                marker.setLabel(label); //把label设置到maker上 
                                marker.enableDragging(); //标注可拖拽
                                map.addOverlay(marker); // 添加标注
                                // 开启事件监听,标注移动事件
                                marker.addEventListener("dragend", function (e) {
                                    var x = e.point.lng; //经度
                                    var y = e.point.lat; //纬度
                                    if (confirm(lans[288][lang])) {  //该设备已有经纬度了，您确定更改吗?
                                        var obj2 = {};
                                        obj2.Longitude = x;
                                        obj2.latitude = y;
                                        obj2.id = e.target.getLabel().content; //获取标注隐藏的值
                                        $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                            success: function (data) {
                                                var arrlist = data.rs;
                                                if (arrlist.length == 1) {
                                                    alert(lans[143][lang]);  //修改成功
                                                } else {
                                                    alert(lans[281][lang]);  //修改失败
                                                }
                                            },
                                            error: function () {
                                                alert("提交添加失败！");
                                            }
                                        });
                                    }

                                });
                            } else {
                                alert(lans[281][lang]);  //修改失败
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                }
                //给地图添加点击事件
                var array = [];   //存储排练标注的经纬度数组
                var wgarray = []; //存储排练标注网关的经纬度数组
                map.addEventListener("click", function (e) {
                    var comaddr; //存储选中数据的通信地址
                    var lng; //经度
                    var lat; //纬度
                    //修改单个网关
                    if (wgonedraw) {
                        if (wgchecck.Longitude != null && wgchecck.latitude != null) {
                            if (confirm("该设备已有经纬度了，您确定更改吗?")) {  //该设备已有经纬度了，您确定更改吗?
                                updatelnglat(e.point.lng, e.point.lat, wgchecck.comaddr);
                                var allOver = map.getOverlays(); //获取全部标注
                                for (var j = 0; j < allOver.length; j++) {
                                    if (allOver[j].toString() == "[object Marker]") {
                                        if (allOver[j].getPosition().lng == lng && allOver[j].getPosition().lat == lat) {
                                            map.removeOverlay(allOver[j]);
                                        }
                                    }
                                }
                            }
                        } else {
                            updatelnglat(e.point.lng, e.point.lat, wgchecck.comaddr);
                        }
                        wgonedraw = false;
                        wgchecck = [];
                    }

                    //修改多个网关
                    if (wgdraw) {
                        var obj3 = {};
                        obj3.x = e.point.lng;
                        obj3.y = e.point.lat;
                        wgarray.push(obj3);
                        var now_point = new BMap.Point(e.point.lng, e.point.lat);
                        var marker2 = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                        map.addOverlay(marker2); // 添加标注

                        if (wgarray.length > 1) {
                            var polyline = new BMap.Polyline([
                                new BMap.Point(wgarray[wgarray.length - 2].x, wgarray[wgarray.length - 2].y), //起始点的经纬度
                                new BMap.Point(wgarray[wgarray.length - 1].x, wgarray[wgarray.length - 1].y)//终止点的经纬度
                            ], {strokeColor: "red", //设置颜色
                                strokeWeight: 3, //宽度
                                strokeOpacity: 0.5});//透明度
                            map.addOverlay(polyline);

                            if (confirm("你还要继续选点吗？")) {  //你还要继续选点吗？

                            } else {
                                for (var i = 0; i < wgidlist.length; i++) {
                                    updatelnglat(wgarray[i].x, wgarray[i].y, wgidlist[i]);
                                }
                                alert("配置经纬度成功"); //配置经纬度成功
                                var nobj = {};
                                nobj.name = u_name;
                                var day = getNowFormatDate2();
                                nobj.time = day;
                                nobj.type = "修改";
                                nobj.pid = porjectId;
                                nobj.comment = "批量修改网关的经纬度";
                                nobj.page = "地图导航";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                //刷新，重置
                                wgarray = [];
                                wgdraw = false;
                                wgidlist = [];
                            }
                        }
                    }

                    //单个传感器修改经纬度
                    if (onedraw) {
                        if (lampchecck.Longitude != null && lampchecck.latitude != null) {
                            if (confirm(lans[288][lang])) {  //该设备已有经纬度了，您确定更改吗?
                                updateLamplnglat(e.point.lng, e.point.lat, lampchecck.id);
                                var allOver = map.getOverlays(); //获取全部标注
                                for (var j = 0; j < allOver.length; j++) {
                                    if (allOver[j].toString() == "[object Marker]") {
                                        if (allOver[j].getPosition().lng == lampchecck.Longitude && allOver[j].getPosition().lat == lampchecck.latitude) {
                                            map.removeOverlay(allOver[j]);
                                        }
                                    }
                                }
                            }
                        } else {
                            updateLamplnglat(e.point.lng, e.point.lat, lampchecck.id);
                        }
                        lampchecck = [];
                        onedraw = false;
                    }
                    //多个传感器
                    if (draw) {
                        var obj3 = {};
                        obj3.x = e.point.lng;
                        obj3.y = e.point.lat;
                        array.push(obj3);
                        var now_point = new BMap.Point(e.point.lng, e.point.lat);
                        var marker2 = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                        map.addOverlay(marker2); // 添加标注

                        if (array.length > 1) {
                            var polyline = new BMap.Polyline([
                                new BMap.Point(array[array.length - 2].x, array[array.length - 2].y), //起始点的经纬度
                                new BMap.Point(array[array.length - 1].x, array[array.length - 1].y)//终止点的经纬度
                            ], {strokeColor: "red", //设置颜色
                                strokeWeight: 3, //宽度
                                strokeOpacity: 0.5});//透明度
                            map.addOverlay(polyline);

                            if (confirm("你还要继续选点吗？")) {  //你还要继续选点吗？

                            } else {
                                for (var i = 0; i < idlist.length; i++) {
                                    //alert("id:" + idlist[i] + "lng:" + array[i].x + "lat:" + array[i].y);
                                    updateMayLamplnglat(array[i].x, array[i].y, idlist[i]);
                                }
                                alert("配置成功"); //配置经纬度成功
                                var nobj = {};
                                nobj.name = u_name;
                                var day = getNowFormatDate2();
                                nobj.time = day;
                                nobj.type = "修改";
                                nobj.pid = porjectId;
                                nobj.comment = "批量修改传感器的经纬度";
                                nobj.page = "地图导航";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                //刷新，重置
                                array = [];
                                draw = false;
                                idlist = [];
                            }
                        }
                    }
                });
            });
            //网关标注
            function wglist(arrlist) {
                for (var i = 0; i < arrlist.length; i++) {
                    (function (x) {
                        var obj = arrlist[i];
                        var Longitude = obj.Longitude;
                        var latitude = obj.latitude;
                        var Iszx = lans[285][lang];   //离线    
                        if (obj.online == 1) {
                            Iszx = lans[284][lang];   //在线    
                        }
                        if (Longitude != "" && latitude != "") {
                            var point = new BMap.Point(Longitude, latitude);
                            var marker1;
                            if (obj.online == 1) {
                                marker1 = new BMap.Marker(point, {
                                    icon: wggreenicon
                                });
                            } else {
                                marker1 = new BMap.Marker(point, {
                                    icon: wghuiicon
                                });
                            }
                            var textvalue = "<div style='line-height:1.8em;font-size:12px;'>\n\
                                   \n\
                                    <table style='text-align:center'>\n\
                                        <tr>\n\
                                            <td>" + lans[25][lang] + ":</td>\n\
                                            <td>" + obj.comaddr.replace(/\b(0+)/gi, "") + "</td>\n\
                                            <td></td>\n\
                                            <td>" + "名称" + ":</td>\n\
                                            <td>" + obj.name + "</td>\n\
                                        </tr>\n\
                                        <tr>\n\
                                            <td>" + lans[12][lang] + ":</td>\n\
                                            <td>" + Iszx + "</td>\n\
                                             <td>&nbsp&nbsp</td>\n\
                                        </tr>\n\ \n\
                                    </table></div>";
                            var opts = {title: '<span style="font-size:14px;color:#0A8021">' + "网关信息" + '</span>'};//设置信息框、信息说明
                            var infoWindow = new BMap.InfoWindow(textvalue, opts); // 创建信息窗口对象，引号里可以书写任意的html语句。
                            marker1.addEventListener("mouseover", function () {
                                this.openInfoWindow(infoWindow);
                            });
                            marker1.addEventListener("rightclick", function () {
                                //移动、移除
                                var textvalue2 = "<ul style='list-style-type:none;width=100px;' class='items'><li id='kdl'>" + "移动" + "</li><li id='yc'>" + "移除" + "</li></ul>";
                                var opts2 = {title: '<span style="font-size:14px;color:#0A8021">' + "功能操作" + '</span>'};//设置信息框、功能操作
                                var infoWindow2 = new BMap.InfoWindow(textvalue2, opts2); // 创建信息窗口对象，引号里可以书写任意的html语句。
                                this.openInfoWindow(infoWindow2);
                                //移动
                                $("#kdl").click(function () {
                                    // console.log("ok");
                                    layer.confirm("确定要移动该网关吗？", {//确定要移动该网关吗？
                                        btn: ["确定", "取消"] //确定、取消按钮
                                    }, function (index) {
                                        marker1.enableDragging(); //标注可拖拽
                                        marker1.addEventListener("dragend", function (e) {
                                            var x = e.point.lng; //经度
                                            var y = e.point.lat; //纬度
                                            var obj2 = {};
                                            obj2.Longitude = x;
                                            obj2.latitude = y;
                                            obj2.comaddr = obj.comaddr;
                                            $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                                success: function (data) {
                                                    var arrlist = data.rs;
                                                    if (arrlist.length == 1) {
                                                        alert("修改成功");  //修改成功
                                                    } else {
                                                        alert("修改失败");  //修改失败
                                                    }
                                                },
                                                error: function () {
                                                    console.log("提交失败");
                                                }
                                            });

                                        });
                                        layer.close(index);
                                        //此处请求后台程序，下方是成功后的前台处理……
                                    });
                                });
                                //移除网关
                                $("#yc").click(function () {
                                    layer.confirm("确定要移除该网关吗?", {//确定要移除该网关吗？
                                        btn: ["确定", "取消"] //确定、取消按钮
                                    }, function (index) {
                                        var allOverlay = map.getOverlays();
                                        for (var i = 0; i < allOverlay.length; i++) {
                                            if (allOverlay[i].toString() == "[object Marker]") {
                                                if (allOverlay[i].getPosition().lng == obj.Longitude && allOverlay[i].getPosition().lat == obj.latitude) {
                                                    map.removeOverlay(allOverlay[i]);
                                                    var obj3 = {};
                                                    obj3.Longitude = "";
                                                    obj3.latitude = "";
                                                    obj3.comaddr = obj.comaddr; //获取标注隐藏的值
                                                    $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj3,
                                                        success: function (data) {
                                                            var arrlist = data.rs;
                                                            if (arrlist.length == 1) {
                                                                alert("移除成功!");  //移除成功

                                                            } else {
                                                                alert("移除失败");  //移除失败
                                                            }
                                                        },
                                                        error: function () {
                                                            console.log("提交失败");
                                                        }
                                                    });
                                                }
                                            }
                                        }
                                        layer.close(index);
                                    });
                                });

                            });
                            marker1.setTitle(obj.comaddr.replace(/\b(0+)/gi, "") + "," + Iszx);   //这里设置maker的title (鼠标放到marker点上,会出现它的title,所以我这里把name,放到title里)
                            map.addOverlay(marker1);
                            map.panTo(point);
                        }
                    })(i);

                }
            }

            //传感器标注
            function lamplists(arrlist) {
                for (var i = 0; i < arrlist.length; i++) {
                    (function (x) {
                        var obj = arrlist[i];
                        var Longitude = obj.longitude;
                        var latitude = obj.latitude;
                        var time1 = obj.onlinetime.substring(0, 16);
                        var time2 = obj.dtime.substring(0, 16);
                        var stime = TimeDifference(time1, time2);
                        var lx = "离线";
                        var isLx = 0;  //判断是否在线
                        var gobj = {};
                        gobj.comaddr = obj.l_comaddr; //selects[0];
                        $.ajax({url: "login.gateway.comaddrzx.action", async: false, type: "get", datatype: "JSON", data: gobj,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist[0].online == 1) {
                                    if (stime > 15) {
                                        lx = "离线";
                                    } else {
                                        lx = "在线";
                                        isLx = 1;
                                    }
                                } else {
                                    lx = "离线";
                                }
                            },
                            error: function () {
                                alert("提交添加失败！请刷新");
                            }
                        });
                        //var s = obj.l_name;
//                        var Iszx = lans[285][lang];    //是否离线,离线
//                        var Isfault = lans[13][lang]; //是否有故障,默认正常
//                        var isfault2 = 0;
//                        if (obj.l_fault == 1) {
//                            Isfault = lans[14][lang]; //异常
//                            isfault2 = 1;
//                        }
//                        if (obj.presence == 1) {
//                            Iszx = lans[284][lang];  //在线
//                        }
                        var type = "";
                        var numvalue = "";
                        if (obj.type == 1) {
                            type = "温度";
                            if (obj.numvalue > 0) {
                                numvalue = obj.numvalue / 10 + "℃";
                            } else {
                                numvalue = obj.numvalue + "℃";
                            }
                        } else if (obj.type == 2) {
                            type = "湿度";
                            if (obj.numvalue > 0) {
                                numvalue = obj.numvalue / 10 + "%RH";
                            } else {
                                numvalue = obj.numvalue + "%RH";
                            }
                        } else {
                            type = "开关";
                            if (obj.numvalue != null && obj.numvalue != 0) {
                                numvalue = "开";
                            } else {
                                numvalue = "关";
                            }
                        }
                        var lampcode = parseInt(arrlist[i].l_factorycode);
                        //lans[][]代表的文字依次是：亮度、名称、灯具编号、网关地址、在线情况、状态、电压、电流
                        var activepower = arrlist[i].activepower * 1000;  //有功功率
                        activepower = activepower.toFixed(2);
                        var textvalue = "<div style='line-height:1.8em;font-size:12px;'>\n\
                                   \n\
                                    <table style='text-align:center'>\n\
                                        <tr>\n\
                                            <td>" + "名称" + ":</td>\n\
                                            <td>" + obj.name + "</td>\n\
                                            <td>&nbsp;&nbsp;</td>\n\
                                            <td>" + "所属网关" + ":</td>\n\
                                            <td>" + obj.l_comaddr.replace(/\b(0+)/gi, "") + "</td>\n\
                                        </tr>\n\
                                        <tr>\n\
                                            <td>" + "型号" + ":</td>\n\
                                            <td>" + obj.model + "</td>\n\
                                            <td>&nbsp;&nbsp;</td>\n\
                                            <td>" + "类型" + ":</td>\n\
                                            <td>" + type + "</td>\n\
                                        </tr>\n\
                                         <tr>\n\
                                            <td>" + "数值" + ":</td>\n\
                                            <td>" + numvalue + "</td>\n\
                                            <td>&nbsp;&nbsp;</td>\n\
                                            <td>" + "状态" + ":</td>\n\
                                            <td>" + lx + "</td>\n\
                                        </tr>\n\
                                    </table></div>";
                        if ((Longitude != "" && latitude != "") && (Longitude != null && latitude != null)) {
                            var point = new BMap.Point(Longitude, latitude);
                            var marker1;
                            if (isLx == 1) {
                                marker1 = new BMap.Marker(point, {
                                    icon: lgreen
                                });
                            } else {
                                marker1 = new BMap.Marker(point, {
                                    icon: lhui
                                });
                            }


//                            if (isfault2 == 1) {
//                                marker1 = new BMap.Marker(point, {
//                                    icon: lred
//                                });
//                            }else if(lxfault==1){
//                                marker1 = new BMap.Marker(point, {
//                                    icon: lred
//                                });
//                            } else if (obj.presence == 1 && obj.l_value > 0) {
//                                marker1 = new BMap.Marker(point, {
//                                    icon: lyello
//                                });
//                            } else if (obj.presence == 1) {
//                                marker1 = new BMap.Marker(point, {
//                                    icon: lgreen
//                                });
//                            } else {
//                                marker1 = new BMap.Marker(point, {
//                                    icon: lhui
//                                });
//                            }

                            var opts = {title: '<span style="font-size:14px;color:#0A8021">' + "传感器信息" + '</span>'};//设置信息框、信息说明
                            var infoWindow = new BMap.InfoWindow(textvalue, opts); // 创建信息窗口对象，引号里可以书写任意的html语句。
                            marker1.addEventListener("mouseover", function () {
                                this.openInfoWindow(infoWindow);
                            });
                            //标注点点击事件

                            marker1.addEventListener("rightclick", function () {
                                //开灯、关灯、调光值、请输入调光值、调光
                                var textvalue2 = "<ul class='items' style='list-style-type:none;'>\n\
                                                                <li id='move'>" + "移动" + "</li>\n\
                                                                <li id='clean'>" + "清除" + "</li>\n\
                                                                </ul>";
                                var opts2 = {title: '<span style="font-size:14px;color:#0A8021">' + "功能操作" + '</span>'};//设置信息框、功能操作
                                var infoWindow2 = new BMap.InfoWindow(textvalue2, opts2); // 创建信息窗口对象，引号里可以书写任意的html语句。
                                this.openInfoWindow(infoWindow2);




                                //移动
                                $("#move").click(function () {
                                    marker1.closeInfoWindow(infoWindow2);
                                    layer.confirm("确认要移动该传感器吗？", {//确认要移动该灯具吗？
                                        btn: ["确定", "取消"] //确定、取消按钮
                                    }, function (index) {
                                        marker1.enableDragging(); //标注可拖拽
                                        marker1.addEventListener("dragend", function (e) {
                                            var x = e.point.lng; //经度
                                            var y = e.point.lat; //纬度
                                            var obj2 = {};
                                            obj2.Longitude = x;
                                            obj2.latitude = y;
                                            obj2.id = obj.id; //获取标注隐藏的值
                                            $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                                success: function (data) {
                                                    var arrlist = data.rs;
                                                    if (arrlist.length == 1) {
                                                        alert("修改成功");  //修改成功
                                                    } else {
                                                        alert(lans[281][lang]);  //修改失败
                                                    }
                                                },
                                                error: function () {
                                                    console.log("提交失败");
                                                }
                                            });

                                        });
                                        layer.close(index);
                                        //此处请求后台程序，下方是成功后的前台处理……
                                    });
                                });
                                //移除传感器
                                $("#clean").click(function () {
                                    marker1.closeInfoWindow(infoWindow2);
                                    layer.confirm("确认要移动该传感器吗？", {//确认要移动该灯具吗？
                                        btn: ["确定", "取消"] //确定、取消按钮
                                    }, function (index) {
                                        var allOverlay = map.getOverlays();
                                        for (var i = 0; i < allOverlay.length; i++) {
                                            if (allOverlay[i].toString() == "[object Marker]") {
                                                if (allOverlay[i].getPosition().lng == obj.Longitude && allOverlay[i].getPosition().lat == obj.latitude) {
                                                    map.removeOverlay(allOverlay[i]);
                                                    var obj3 = {};
                                                    obj3.Longitude = "";
                                                    obj3.latitude = "";
                                                    obj3.id = obj.id; //获取标注隐藏的值
                                                    $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj3,
                                                        success: function (data) {
                                                            var arrlist = data.rs;
                                                            if (arrlist.length == 1) {
                                                                alert("移除成功");  //移除成功
                                                            } else {
                                                                alert("移除失败");  //移除失败
                                                            }
                                                        },
                                                        error: function () {
                                                            console.log("提交失败");
                                                        }
                                                    });
                                                }
                                            }
                                        }
                                        layer.close(index);
                                    });
                                });

                            });
                            map.addOverlay(marker1);
                            map.panTo(point);
                        }
                    })(i);
                }
            }

            //网关下拉框
            function combobox(id, pid) {
                $(id).combobox({
                    url: "login.map.getallcomaddr.action?pid=" + pid
//                    onLoadSuccess: function (data) {
//                        $(this).combobox("select", data[0].id);
//                        $(this).val(data[0].text);
//                    }
                });
            }
        </script>
    </body>
</html>
