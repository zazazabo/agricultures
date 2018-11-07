<%-- 
    Document   : lightval
    Created on : 2018-7-23, 7:54:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/genel.js"></script>
        <style>
            .btn{ margin-left: 10px;}   
        </style>
        <script type="text/javascript"  src="js/getdate.js"></script>


        <script type="text/javascript" language=JavaScript charset="UTF-8">
            document.onkeydown = function (event) {
                var e = event || window.event || arguments.callee.caller.arguments[0];
                if (e && e.keyCode == 27) { // 按 Esc 
                    $('#panemask').hideLoading();
                }

            };
        </script>





        <script>
            var lang = '${param.lang}'; //'zh_CN';
            var langs1 = parent.parent.getLnas();
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function search() {
                var o = $("#formsearch").serializeObject();
                var opt = {
                    url: "lamp.lampform.getlampList.action",
                    query: o

                };
                $('#lamptable').bootstrapTable('refresh', opt);
            }
            //开灯
            function onlamp(val) {
                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;
                console.log(l_comaddr);
                val = parseInt(val);
                var o = $("#formsearch").serializeObject();
                var groupearr = $("#l_groupe").combobox("getData");
                console.log(groupearr);
                if (groupearr.length == 0) {
                    layerAler(langs1[305][lang]); //此网关下没部署灯具
                    return;
                }


                var vv = new Array();
                vv.push(groupearr.length);
                var param = [];
                for (var i = 0; i < groupearr.length; i++) {
                    vv.push(parseInt(groupearr[i].id));
                    vv.push(val);
                    param.push(groupearr[i].id);
                }
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 302, vv); //01 03 F24     
                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "开灯", l_comaddr);
                dealsend2("A5", data, 302, "lightCB", l_comaddr, 3, param, val);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }
            //关灯
            function offlamp(val) {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;
                val = parseInt(val);
                var o = $("#formsearch").serializeObject();
                var groupearr = $("#l_groupe").combobox("getData");
                console.log(groupearr);
                if (groupearr.length == 0) {
                    layerAler(langs1[305][lang]); //此网关下没部署灯具
                    return;
                }


                var vv = new Array();
                vv.push(groupearr.length);
                var param = [];
                for (var i = 0; i < groupearr.length; i++) {
                    vv.push(parseInt(groupearr[i].id));
                    vv.push(val);
                    param.push(groupearr[i].id);
                }

                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 302, vv); //01 03 F24     
                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "关灯", comaddr);
                dealsend2("A5", data, 302, "lightCB", l_comaddr, 3, param, val);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }


            function sceneCB(obj) {
                $('#panemask').hideLoading();
                console.log(obj);
                if (obj.status == "success") {
                    if (obj.fn == 304) {
                        layerAler(langs1[306][lang]); //单灯场景调光成功
                    } else if (obj.fn == 308) {
                        layerAler(langs1[307][lang]); //按组场景调光成功
                    }
                }
            }

            function restoreCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler(langs1[308][lang]); //恢复成功
                }
            }

            function restore() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;

                var o = $("#formsearch").serializeObject();
                if (o.type == "3") {
                    var vv = new Array();
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 180, vv); //01 03
                    //dealsend(sss, o1);
                    addlogon(u_name, "灯具调光", o_pid, "灯具调光", "全网恢复自动运行", l_comaddr);
                    dealsend2("A4", data, 180, "restoreCB", l_comaddr, 0, 0, 0);
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 30000);
                        }
                    }
                    );
                } else if (o.type == 2) {
                    var vv = new Array();
                    vv.push(1);
                    var groupe = o.l_groupe;
                    var l_groupe = parseInt(groupe, "10");
                    vv.push(l_groupe); //组号
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 140, vv); //01 03
                    addlogon(u_name, "灯具调光", o_pid, "灯具调光", "按组恢复自动运行", l_comaddr);
                    dealsend2("A4", data, 180, "restoreCB", l_comaddr, o.type, 0, groupe);
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 30000);
                        }
                    }
                    );
                } else if (o.type == 1) {
                    var selects = $('#lamptable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler(langs1[310][lang]); //请勾选灯具数据
                        return;
                    }

                    var select = selects[0];
                    var vv = new Array();
                    var c = parseInt(select.l_code);
                    var h = c >> 8 & 0x00ff;
                    var l = c & 0x00ff;
                    vv.push(l);
                    vv.push(h); //装置序号  2字节
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 140, vv); //01 03
                    addlogon(u_name, "灯具调光", o_pid, "灯具调光", "单灯恢复自动运行", l_comaddr);
                    dealsend2("A5", data, 180, "restoreCB", l_comaddr, o.type, 0, select.l_code);
                }
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }


            function sceneAllCB(obj) {
                $('#panemask').hideLoading()
                console.log(obj);
            }

            function sceneAll() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;

                var o = $("#formsearch").serializeObject();
                console.log(o);
                var groupearr = $("#l_groupe").combobox("getData");
                console.log(groupearr);
                if (groupearr.length == 0) {
                    layerAler(langs1[305][lang]); //此网关下没部署灯具
                    return;
                }
                var vv = new Array();
                vv.push(groupearr.length);

                for (var i = 0; i < groupearr.length; i++) {
                    vv.push(parseInt(groupearr[i].id));
                    var scenenum = o.scennum;
                    vv.push(parseInt(o.scennum));
                }
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 308, vv); //01 03

                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "全网场景调光", l_comaddr);
                dealsend2("A5", data, 308, "sceneAllCB", l_comaddr, 0, 0, 0);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }
            function scenegroupe() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;

                var obj = $("#formsearch").serializeObject();
                if (isNumber(obj.scennum) == false) {
                    layerAler(langs1[311][lang]); //场景号必须数字
                    return;
                }

                if (isNumber(obj.l_groupe) == false) {
                    layerAler(langs1[312][lang]); //网关或组号不是数字
                    return
                }

                var vv = new Array();
                vv.push(1);
                var groupe = obj.l_groupe;
                var l_groupe = parseInt(groupe, "10");
                vv.push(l_groupe); //组号


                var scenenum = obj.scennum;
                vv.push(parseInt(obj.scennum));
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 308, vv); //01 03
                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "按组场景调光", l_comaddr);
                dealsend2("A5", data, 308, "sceneCB", l_comaddr, obj.lighttype, groupe, scenenum);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }

            function scenesingle() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;
                var obj = $("#formsearch").serializeObject();
                if (isNumber(obj.scennum) == false) {
                    layerAler(langs1[311][lang]); //场景号必须数字
                    return;
                }
                var selects = $('#lamptable').bootstrapTable('getSelections');
                var select = selects[0];
                if (selects.length == 0) {
                    layerAler(langs1[310][lang]); //请勾选灯具数据
                    return;
                }

                var vv = new Array();
                var c = parseInt(select.l_code);
                var h = c >> 8 & 0x00ff;
                var l = c & 0x00ff;
                vv.push(l);
                vv.push(h); //装置序号  2字节
                var scenenum = obj.scennum;
                vv.push(parseInt(obj.scennum));
                var param = {};
                param.id = select.id;
                param.row = select.index;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 304, vv); //01 03
                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "单灯场景立即调光", l_comaddr);
                dealsend2("A5", data, 304, "sceneCB", l_comaddr, obj.lighttype, param, scenenum);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }

            function lightCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    if (obj.fn == 301) {
                        layerAler(langs1[313][lang]); //单灯调光成功
                        var param = obj.param;
                        var o = {};
                        o.l_value = obj.val;
                        o.id = param.id;
                        $.ajax({async: false, url: "test1.lamp.modifyvalue.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    $("#lamptable").bootstrapTable('updateCell', {index: param.row, field: "l_value", value: obj.val});
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    } else if (obj.fn == 302) {
                        var param = obj.param;
                        for (var i = 0; i < param.length; i++) {
                            var o = {};
                            o.l_value = obj.val;
                            o.l_comaddr = obj.comaddr;
                            o.l_groupe = param[i];
                            $.ajax({async: false, url: "lamp.lampform.modifygroupevalAll.action", type: "get", datatype: "JSON", data: o,
                                success: function (data) {

                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                        }

                        layerAler("调光成功");
                        var o = $("#formsearch").serializeObject();
                        var opt = {
                            url: "lamp.lampform.getlampList.action",
                            query: o

                        };
                        $('#lamptable').bootstrapTable('refresh', opt);
                    }
                }

            }

            function  lightsingle() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;
                var o = $("#formsearch").serializeObject();
                var selects = $('#lamptable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler(langs1[310][lang]); //请勾选灯具数据
                    return;
                }
                var select = selects[0];

                var lampval = $("#val").val();
                var vv = new Array();
                var c = parseInt(select.l_code);
                var h = c >> 8 & 0x00ff;
                var l = c & 0x00ff;
                vv.push(l);
                vv.push(h); //装置序号  2字节
                vv.push(parseInt(lampval));
                var num = randnum(0, 9) + 0x70;
                var param = {};
                param.id = select.id;
                param.row = select.index;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 301, vv); //01 03
                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "单灯立即调光", l_comaddr);
                dealsend2("A5", data, 301, "lightCB", l_comaddr, o.groupetype, param, lampval);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }

            function lightgroupe() {
                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;

                var obj = $("#formsearch").serializeObject();
                if (isNumber(l_comaddr) == false || isNumber(obj.l_groupe) == false) {
                    layerAler(langs1[312][lang]); //网关或组号不是数字
                    return
                }

                var vv = new Array();
                vv.push(1);
                var groupe = obj.l_groupe;
                var l_groupe = parseInt(groupe, "10");
                vv.push(l_groupe); //组号
                var groupeval = $("#val").val();
                vv.push(parseInt(groupeval, "10")); //组亮度值
                var num = randnum(0, 9) + 0x70;
                var param = [];
                param.push(l_groupe);
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 302, vv); //01 03 F24    
                addlogon(u_name, "灯具调光", o_pid, "灯具调光", "按组立即调光", comaddr);
                dealsend2("A5", data, 302, "lightCB", l_comaddr, obj.groupetype, param, groupeval);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 30000);
                    }
                }
                );
            }

            function tourControllampCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    var vv = [];
                    vv.push(1);
                    var l_code = parseInt(obj.val);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b); //装置序号  2字节            
                    vv.push(a); //装置序号  2字节                       
                    var comaddr = obj.comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xAC, num, 0, 40, vv);
                    dealsend2("AC", data, 40, "tourlampCB", comaddr, 0, 0, 0);
                }
            }
            function  tourControllamp() {

                dealsend2("CheckLamp", "a", 0, 0, "check", 0, 0, "${param.pid}");
//                var selects = $('#lamptable').bootstrapTable('getSelections');
//                // var o = $("#form1").serializeObject();
//                var vv = new Array();
//                if (selects.length == 0) {
//                    layerAler(langs1[73][lang]);   //请勾选表格数据
//                    return;
//                }
//                var vv = [];
//                vv.push(3);
//                vv.push(1);
//                vv.push(0);
//                var ele = selects[0];
//                var setcode = ele.l_code;
//                var l_code = parseInt(setcode);
//                var a = l_code >> 8 & 0x00FF;
//                var b = l_code & 0x00ff;
//                vv.push(b);//装置序号  2字节            
//                vv.push(a);//装置序号  2字节 
//                var comaddr = selects[0].l_comaddr;
//                var num = randnum(0, 9) + 0x70;
//                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 1, vv);
//                dealsend2("A5", data, 40, "tourControllampCB", comaddr, 0, 0, l_code);
//                $('#panemask').showLoading({
//                    'afterShow': function () {
//                        setTimeout("$('#panemask').hideLoading()", 10000);
//                    }
//                }
//                );


            }

            //巡测灯具状态
            function tourlamp(comaddr, l_code) {
                var vv = new Array();
                vv.push(1);
                var setcode = l_code;
                var l_code = parseInt(setcode);
                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(b); //装置序号  2字节            
                vv.push(a); //装置序号  2字节    
                var num = randnum(0, 9) + 0x70;
                var l_comaddr = comaddr.toString();
                console.log(typeof l_comaddr);
                var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 40, vv);
                console.log(data);
                dealsend2("AC", data, 40, "tourlampCB", l_comaddr, 0, 0, 0);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            //巡测回调函数
            function tourlampCB(obj) {
                $('#panemask').hideLoading();
                var v = Str2BytesH(obj.data);
                var s = "";
                for (var i = 0; i < v.length; i++) {

                    s = s + sprintf("%02x", v[i]) + " ";
                }
                console.log(s);
                var objwork = {"0": "时间表", "1": "经纬度", "2": "场景"};
                var objstatus = {"0": "自动", "1": "手动"};
                var objtiming = {"0": "末请求", "1": "请求"};
                var objfault = {"0": "灯具故障", "1": "温度故障", "2": "超负荷故障", "3": "功率因数过低故障", "4": "时钟故障", "5": "", "6": "灯珠故障", "7": "电源故障"};
                if (v[14] == 0 && v[15] == 0 && v[16] == 0x40 && v[17] == 0) {
                    var z = 19;
                    var len = v[18];
                    console.log(len);
                    for (i = 0; i < len; i++) {
                        var l_code = v[z + 1] * 256 + v[z];
                        //电压
                        console.log(l_code);
                        z = z + 2;
                        var bw = v[z + 1] >> 4 & 0xf;
                        var sw = v[z + 1] & 0xf;
                        var gw = v[z] >> 4 & 0xf;
                        var sfw = v[z] & 0xf;
                        var voltage = sprintf("%d%d%d.%d(V)", bw, sw, gw, sfw); //电压
                        console.log(voltage);
                        //电流
                        z = z + 2;
                        var sw = v[z + 1] >> 4 & 0xf;
                        var gw = v[z + 1] & 0xf;
                        var sfw = v[z] >> 4 & 0xf;
                        var bfw = v[z] & 0xf;
                        var electric = sprintf("%d%d.%d%d(A)", sw, gw, sfw, bfw);
                        console.log(electric);
                        //有功功率
                        z = z + 2;
                        var qw = v[z + 3] >> 4 & 0xf;
                        var bw = v[z + 3] & 0xf;
                        var sw = v[z + 2] >> 4 & 0xf;
                        var gw = v[z + 2] & 0xf;
                        var sfw = v[z + 1] >> 4 & 0xf;
                        var bfw = v[z + 1] & 0xf;
                        var qfw = v[z] >> 4 & 0xf;
                        var wfw = v[z] & 0xf;
                        var activepower = sprintf("%d%d%d.%d%d%d%d", qw, bw, gw, sfw, bfw, qfw, wfw);
                        console.log(activepower);
                        activepower = parseFloat(activepower) * 1000;
                        console.log(activepower);
                        //灯控器状态
                        z = z + 4;
                        var s1 = v[z];
                        var s2 = v[z + 1];
                        var s3 = v[z + 2];
                        var s4 = v[z + 3];
                        var worktype = s1 & 0x3;
                        //调光值
                        z = z + 4;
                        var l_value = v[z];
                        console.log(l_value);
                        //温度
                        z = z + 1;
                        var temperature = v[z + 1] == 1 ? -v[z] : v[z];
                        //抄表时间
                        z = z + 2;
                        var ms = v[z + 3] >> 4 & 0xf;
                        var mg = v[z + 3] & 0xf;
                        var ds = v[z + 2] >> 4 & 0xf;
                        var dg = v[z + 2] & 0xf;
                        var hs = v[z + 1] >> 4 & 0xf;
                        var hg = v[z + 1] & 0xf;
                        var mins = v[z] >> 4 & 0xf;
                        var ming = v[z] & 0xf;
                        var readtime = sprintf("%d%d月%d%d日 %d%d:%d%d", ms, mg, ds, dg, hs, hg, mins, ming);
                        var l_codestr = "装置号:" + l_code.toString() + "<br>";
                        var voltagestr = "电压：" + voltage + "<br>";
                        var electricstr = "电流：" + electric + "<br>";
                        var activepowerstr = "有功功率：" + activepower.toFixed(2) + "(w)<br>";
                        var l_valuestr = "调光值：" + l_value + "<br>";
                        var worktypstr = "工作方式:" + objwork[s2 & 3] + "<br>";
                        var n = s2 >> 2 & 0x1;
                        var controstatus = "控制状态:" + objstatus[n] + "<br>";
                        var n1 = s2 >> 3 & 0x1;
                        var timingstr = "校时状态:" + objtiming[n1] + "<br>";
                        var strfault = "";
                        for (var i = 0; i < 8; i++) {
                            var temp = Math.pow(2, i);
                            if ((s3 & temp) == temp) {
                                if (objfault[i] != "") {
                                    strfault = strfault + objfault[i] + "|";
                                }

                            }
                        }
                        strfault = strfault == "" ? "无" : strfault;
                        var strfault1 = "故障信息:" + strfault + "<br>";
                        var uuu = l_codestr + voltagestr + electricstr + activepowerstr + l_valuestr + worktypstr + timingstr + strfault1 + "抄读时间:" + readtime;
                        layerAler(uuu);
                    }

                }
            }

            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }










                $('#lamptable').on('click-cell.bs.table', function (field, value, row, element)
                {
                    if (value == "l_worktype") {
                        if (element.l_deplayment == "1") {
                            if (element.l_worktype == "0") {
                                var plan = "";
                                if (isJSON(element.l_plantime)) {
                                    var obj = eval('(' + element.l_plantime + ')');
                                    plan = obj.p_code;
                                } else {
                                    plan = element.l_plantime;
                                }

                                var o = {p_code: plan};
                                $.ajax({async: false, url: "lamp.planForm.getLampPlanData.action", type: "get", datatype: "JSON", data: o,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            var str = "";
                                            var oo = arrlist[0];
                                            for (var i = 0; i < 6; i++) {
                                                var aa = "p_time" + (i + 1).toString();
                                                var obj = eval('(' + oo[aa] + ')');
                                                if (typeof obj == 'object') {
                                                    str = str + "时间" + (i + 1).toString() + ":" + obj.time + "&nbsp;&nbsp;调光值:" + obj.value.toString() + "<br>";
                                                }


                                            }
                                            layerAler(str);
                                        }
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                            } else if (element.l_worktype == 2) {
                                var plan = "";
                                if (isJSON(element.l_planscene)) {
                                    var obj = eval('(' + element.l_planscene + ')');
                                    plan = obj.p_code;
                                } else {
                                    plan = element.l_planscene;
                                }
                                var o = {p_code: plan};
                                $.ajax({async: false, url: "lamp.planForm.getLampPlanData.action", type: "get", datatype: "JSON", data: o,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            var str = "";
                                            var oo = arrlist[0];
                                            for (var i = 0; i < 8; i++) {
                                                var aa = "p_scene" + (i + 1).toString();
                                                var obj = eval('(' + oo[aa] + ')');
                                                if (typeof obj == 'object') {
                                                    str = str + "场景号" + obj.num + ":" + "&nbsp;&nbsp;调光值:" + obj.value.toString() + "<br>";
                                                }
                                            }
                                            layerAler(str);
                                        }
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                            }
                        }
                    }


                });





                $('#gayway').on('check.bs.table', function (row, element) {
                    var l_comaddr = element.comaddr;
                    var url = "lamp.GroupeForm.getGroupe.action?l_comaddr=" + l_comaddr + "&l_deplayment=1";
                    $("#l_groupe").combobox("clear");
                    $("#l_groupe").combobox("reload", url);
                    var o = {l_comaddr: l_comaddr, pid: "${param.pid}"};
                    var opt = {
                        url: "lamp.lampform.getlampList.action",
                        query: o

                    };
                    $('#lamptable').bootstrapTable('refresh', opt);
                });










//             $('#gayway').on('onLoadSuccess', function (data) {
//                 console.log(data);
//                });





                $('#lamptable').bootstrapTable({
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
                    //url: 'lamp.lampform.getlampList.action',
                    clickToSelect: true,
                    columns: [
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                row.index = index;
                                return  value;
                            }
                        },
                        {
                            field: 'name',
                            title: langs1[314][lang], //网关名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_comaddr',
                            title: langs1[25][lang], //网关地址
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'l_name',
                            title: langs1[54][lang], //灯具名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: langs1[292][lang], //灯具编号
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    value = value.replace(/\b(0+)/gi, "");
                                    return value.toString();
                                }

                            }
                        },
//                        {
//                            field: 'l_code',
//                            title: langs1[315][lang], //装置序号
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//
//                        }, 
                        {
                            field: 'l_worktype',
                            title: langs1[316][lang], //控制方式
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "时间表";
                                    return value;
                                } else if (value == 1) {
                                    value = "经纬度";
                                    return value;
                                } else if (value == 2) {
                                    value = "场景";
                                    return value;
                                }
                            }
                        },
//                        {
//                            field: 'l_plan',
//                            title: langs1[373][lang], //控制方案
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle',
//                            formatter: function (value, row, index, field) {
//                                if (row.l_deplayment == 1) {
//                                    if (row.l_worktype == "0") {
//                                        if (isJSON(row.l_plantime)) {
//                                            var obj = eval('(' + row.l_plantime + ')');
//                                            return obj.p_name;
//                                        } else {
//                                            return  row.l_plantime;
//                                        }
//                                    } else if (row.l_worktype == "2") {
//                                        if (isJSON(row.l_planscene)) {
//                                            var obj = eval('(' + row.l_plantime + ')');
//                                            return obj.p_name;
//                                        } else {
//                                            return  row.l_planscene;
//                                        }
//
//                                    }
//                                }
//                            }
//                        },
                        {
                            field: 'l_groupe',
                            title: langs1[26][lang], //灯具组号
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.toString();
                            }
                        }, {
                            field: 'l_value',
                            title: langs1[42][lang], //调光值
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }


                            }
                        }, {
                            field: 'presence',
                            title: langs1[61][lang], //在线状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 1) { //data-toggle="tooltip"
                                    var str = '<img data-toggle="tooltip"  src="img/online1.png" onclick="tourlamp(' + row.l_comaddr + ',' + row.l_code + ')" />';
//                                    var str = '<a href="#"  class="tooltip-show" data-toggle="tooltip" title="show">' + str1 + '</a>';
                                    return  str;
                                } else {
                                    var str = '<img data-toggle="tooltip"  src="img/off.png" onclick="tourlamp(' + row.l_comaddr + ',' + row.l_code + ')" />';
                                    return str;
                                }
                            }

                        }],
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 100,
//                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [100, 200, 300, 400],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            l_deplayment: 1,
                            pid: "${param.pid}"
                        };      
                        return temp;  
                    },
                });





// 组号方式

                $('#groupetype').combobox({
                    onSelect: function (record) {
                        if (record.value == 0) {
                            var valinput1 = $("button[name='btnsingle']");
                            var valinput2 = $("button[name='btngroupe']");
                            var valinput3 = $("button[name='btnall']");
                            $(valinput1[0]).show();
                            $(valinput1[1]).show();
                            $(valinput2[0]).hide();
                            $(valinput2[1]).hide();
                            $(valinput3[0]).hide();
                            $(valinput3[1]).hide();
                        } else if (record.value == 1) {
                            var valinput1 = $("button[name='btnsingle']");
                            var valinput2 = $("button[name='btngroupe']");
                            var valinput3 = $("button[name='btnall']");
                            $(valinput1[0]).hide();
                            $(valinput1[1]).hide();
                            $(valinput2[0]).show();
                            $(valinput2[1]).show();
                            $(valinput3[0]).hide();
                            $(valinput3[1]).hide();
                        } else if (record.value == 2) {
                            var valinput1 = $("button[name='btnsingle']");
                            var valinput2 = $("button[name='btngroupe']");
                            var valinput3 = $("button[name='btnall']");
                            $(valinput1[0]).hide();
                            $(valinput1[1]).hide();
                            $(valinput2[0]).hide();
                            $(valinput2[1]).hide();
                            $(valinput3[0]).show();
                            $(valinput3[1]).show();
                        }
                    }
                })

                $('#scenetype').combobox({
                    onSelect: function (record) {
                        var o = $("#formsearch").serializeObject();
                        $("#light" + record.value).show();
                        var a1 = 1 - parseInt(record.value);
                        $("#light" + a1.toString()).hide();
                    }
                });
                $('#slide_lamp_val').slider({
                    onChange: function (v1, v2) {
                        $("#val").val(v1);
                    }
                });
            })

            function  formartcomaddr(value, row, index, field) {
                console.log(row);
                var val = value;
                var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                return  val + v1;
            }

        </script>
    </head>
    <body id="panemask">

        <div class="row "   >
            <div class="col-xs-2 " >

                <!--                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 align='center' class="panel-title">
                                            网关列表
                                        </h3>
                                    </div>
                                    <div class="panel-body">-->
                <table id="gayway" style="width:100%;"   data-toggle="table" 
                       data-height="800"
                       data-single-select="true"
                       data-striped="true"
                       data-click-to-select="true"
                       data-search="true"
                       data-checkbox-header="false"
                       data-show-header='true'
                       data-search-align='right'
                       data-silent-sort='true'
                       data-url="gayway.GaywayForm.getComaddrList.action?pid=${param.pid}&page=ALL" style="width:200px;" >
                    <thead >
                        <tr >
                            <th data-width="100"    data-select="false" data-align="center"  data-checkbox="true"  ></th>
                            <th data-width="100" data-field="comaddr" data-align="center" data-formatter='formartcomaddr'   >网关地址</th>
                            <!--<th data-width="100" data-field="name" data-align="center"    >网关名称</th>-->
                        </tr>
                    </thead>       

                </table>
                <!--                    </div>
                                </div>    -->

            </div>
            <div class="col-xs-10">

                <form id="formsearch">
                    <input type="hidden" name="pid" value="${param.pid}">
                    <div class="row"  >
                        <div class="col-xs-12">
                            <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; align-content:  center">
                                <tbody>
                                    <tr>

                                        <!--                                        <td style=" padding-left: 5px;">
                                                                                    <span  id="25" name="xxx" >
                                                                                        网关地址&nbsp;
                                                                                    </span>
                                                                                </td>
                                                                                <td  style=" padding-left: 5px;">
                                                                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                                                           data-options="editable:true,valueField:'id', textField:'text' " />
                                                                                </td>-->
                                        <td style=" padding-left: 10px;">
                                            <span id="26" name="xxx">
                                                灯具组号
                                                &nbsp;</span>
                                        </td>
                                        <td style=" padding-left: 5px;">

                                            <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:100px; height: 30px" 
                                                   data-options="editable:false,valueField:'id', textField:'text' " />
                                        </td>
                                        <td style=" padding-left: 10px;">
                                            <span id="28" name="xxx" >
                                                分组方式&nbsp;</span>
                                        </td>
                                        <td style=" padding-left: 5px;">
                                            <select class="easyui-combobox" id="groupetype" name="groupetype" style="width:120px; height: 30px">
                                                <option value="0" name="xxx" id="29">单灯调光</option>
                                                <option value="1" name="xxx" id="30">组号调光</option>           
                                                <option value="2" name="xxx" id="336">全部调光</option>           
                                            </select>

                                        </td>

                                        <td style=" padding-left: 10px;">
                                            <span id="31" name="xxx" >
                                                调光模式
                                                &nbsp;</span>
                                        </td>
                                        <td style=" padding-left: 10px;">
                                            <select class="easyui-combobox" id="scenetype" name="scenetype" style="width:150px; height: 30px">
                                                <option value="0" name="xxx" id="32">立即调光</option>
                                                <option value="1" name="xxx" id="33">场景调光</option>           
                                            </select>
                                        </td>

                                        <!--                                        <td>
                                                                                    <button  type="button"id="34" name="xxx"  onclick="search()" class="btn btn-success btn-sm">
                                                                                        <span id="34" name="xxx">搜索</span>
                                                                                    </button>&nbsp;
                                                                                </td>-->
                                        <td>
                                            <button  type="button" style="margin-left:20px;" onclick="onlamp(100)" class="btn btn-success btn-sm">
                                                <span id="35" name="xxx">开灯</span>
                                            </button>&nbsp;                                    
                                        </td>            
                                        <td>
                                            <button  type="button" style="margin-left:20px;" onclick="offlamp(0)" class="btn btn-success btn-sm">
                                                <span id="36" name="xxx">关灯</span>
                                            </button>&nbsp;
                                        </td>

                                        <td>
                                            <button   type="button" onclick="tourControllamp()" class="btn btn-success btn-sm"><span name="xxxx" id="403">巡测所有灯具状态</span></button>
                                        </td>

                                    </tr>


                                </tbody>
                            </table> 
                        </div>
                    </div>

                    <div class="row" style="  margin-top: 10px;">

                        <div class="col-xs-3">
                            <table  style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 320px;margin-left: 20px;">
                                <tr>
                                    <td style=" padding-left: 5px;">
                                        <span id="37" name="xxx" >
                                            恢复模式
                                            &nbsp;</span>
                                    </td>
                                    <td>
                                        <select class="easyui-combobox" id="type" name="type" style="width:120px; height: 30px">
                                            <option value="1" name="xxx" id="38">单灯恢复</option>
                                            <option value="2" name="xxx" id="39">按组恢复</option>    
                                            <option value="3" name="xxx" id="40">全部恢复</option>  
                                        </select>
                                        <button  type="button" onclick="restore()" class="btn btn-success btn-sm">
                                            <span id="41" name="xxx">恢复自动运行</span>
                                        </button>
                                    </td>
                                    <!--                                    <td>
                                                                            <button  type="button" onclick="restore()" class="btn btn-success btn-sm">
                                                                                <span id="41" name="xxx">恢复自动运行</span>
                                                                            </button>
                                                                        </td>-->
                                </tr>
                            </table>
                        </div>
                        <div class="col-xs-5"  style=" margin-left: 100px;"  id="light0">
                            <table   style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px;margin-left: 30px;">
                                <tr>
                                    <td  >
                                        <span id="42" name="xxx" style="margin-left:10px;">
                                            调光值
                                            &nbsp;</span>
                                        <input id="val" value="0" class="form-control" readonly="true" name="val" style="width:50px;display: inline; height: 30px; " placeholder="调光值" type="text">

                                    </td>
                                    <td>
                                        <div  id="slide_lamp_val"  class="easyui-slider"     data-options="showTip:true,min:0,max:100,step:1" style="width:100px;    "></div>

                                    </td>
                                    <td>
                                        <button  type="button"  name="btnsingle"  onclick="lightsingle()" class="btn btn-success btn-sm">
                                            <span id="43" name="xxx">单灯立即调光</span>
                                        </button>
                                        <button  type="button" name="btngroupe"  style="display: none"  onclick="lightgroupe()" class="btn btn-success btn-sm">
                                            <span id="44" name="xxx">按组立即调光</span>
                                        </button>

                                        <button  type="button" name="btnall"  style="display: none"  onclick='onlamp($("#val").val())' class="btn btn-success btn-sm">
                                            <span id="336" name="xxx">全网调光</span>
                                        </button>

                                    </td>
                                </tr>
                            </table>
                        </div>


                        <div class="col-xs-5"  id="light1" style="margin-left: 80px;display: none;">
                            <table   style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px; margin-left: 30px;">
                                <tbody>
                                    <tr>
                                        <td>

                                            <span style="margin-left:10px;">
                                                <span id="47" name="xxx">场景号</span>
                                                &nbsp;</span>
                                            <select class="easyui-combobox" id="scennum" name="scennum" style="width:150px; height: 30px">
                                                <option value="1" name="xxx" id="320">场景1</option>
                                                <option value="2" name="xxx" id="321">场景2</option>    
                                                <option value="3" name="xxx" id="322">场景3</option> 
                                                <option value="4" name="xxx" id="323">场景4</option> 
                                                <option value="5" name="xxx" id="324">场景5</option> 
                                                <option value="6" name="xxx" id="325">场景6</option> 
                                                <option value="7" name="xxx" id="326">场景7</option> 
                                                <option value="8" name="xxx" id="327">场景8</option> 
                                            </select>
                                            <button  type="button"  name="btnsingle" style="margin-left:20px;" onclick="scenesingle()" class="btn btn-success btn-sm">
                                                <span id="45" name="xxx">单灯场景调光</span>
                                            </button>
                                            <button  type="button" name="btngroupe" style="margin-left:20px; display: none" onclick="scenegroupe()" class="btn btn-success btn-sm">
                                                <span id="46" name="xxx">按组场景调光</span>
                                            </button>

                                            <button  type="button" name="btnall" style="margin-left:20px; display: none" onclick="sceneAll()" class="btn btn-success btn-sm">
                                                <span id="337" name="xxx">全网场景调光</span>
                                            </button>

                                        </td>

                                    </tr>

                                </tbody>
                            </table> 
                        </div>
                        <!--                        <div class="col-xs-2" style=" margin-top: 10px; margin-left: 25px; "  >
                        
                                                    <button   type="button" onclick="tourControllamp()" class="btn btn-success btn-sm"><span name="xxxx" id="403">巡测所有灯具状态</span></button>
                        
                                                </div>-->
                    </div>


                </form>

                <table id="lamptable" style="width:100%;"  >
                </table>
            </div>
        </div>

        <!--
        
                <form id="formsearch">
                    <input type="hidden" name="pid" value="${param.pid}">
        
        
                    <div class="row"  >
                        <div class="col-xs-12">
                            <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; align-content:  center">
                                <tbody>
                                    <tr>
        
                                        <td style=" padding-left: 5px;">
                                            <span  id="25" name="xxx" >
                                                网关地址
                                                网关地址&nbsp;
                                            </span>
                                        </td>
                                        <td  style=" padding-left: 5px;">
                                            <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                   data-options="editable:true,valueField:'id', textField:'text' " />
                                        </td>
                                        <td style=" padding-left: 10px;">
                                            <span id="26" name="xxx">
                                                灯具组号
                                                &nbsp;</span>
                                        </td>
                                        <td style=" padding-left: 5px;">
        
                                            <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:100px; height: 30px" 
                                                   data-options="editable:false,valueField:'id', textField:'text' " />
                                        </td>
                                        <td style=" padding-left: 10px;">
                                            <span id="28" name="xxx" >
                                                分组方式&nbsp;</span>
                                        </td>
                                        <td style=" padding-left: 5px;">
                                            <select class="easyui-combobox" id="groupetype" name="groupetype" style="width:120px; height: 30px">
                                                <option value="0" name="xxx" id="29">单灯调光</option>
                                                <option value="1" name="xxx" id="30">组号调光</option>           
                                                <option value="2" name="xxx" id="336">全部调光</option>           
                                            </select>
        
                                        </td>
        
                                        <td style=" padding-left: 10px;">
                                            <span id="31" name="xxx" >
                                                  调光模式
                                                调光模式
                                                &nbsp;</span>
                                        </td>
                                        <td style=" padding-left: 10px;">
                                            <select class="easyui-combobox" id="scenetype" name="scenetype" style="width:150px; height: 30px">
                                                <option value="0" name="xxx" id="32">立即调光</option>
                                                <option value="1" name="xxx" id="33">场景调光</option>           
                                            </select>
                                        </td>
        
                                        <td>
                                            <button  type="button"id="34" name="xxx"  onclick="search()" class="btn btn-success btn-sm">
                                                <span id="34" name="xxx">搜索</span>
                                            </button>&nbsp;
                                        </td>
                                        <td>
                                            <button  type="button" style="margin-left:20px;" onclick="onlamp(100)" class="btn btn-success btn-sm">
                                                <span id="35" name="xxx">开灯</span>
                                            </button>&nbsp;                                    
                                        </td>            
                                        <td>
                                            <button  type="button" style="margin-left:20px;" onclick="offlamp(0)" class="btn btn-success btn-sm">
                                                <span id="36" name="xxx">关灯</span>
                                            </button>&nbsp;
                                        </td>
        
                                                                        <td>
                                                                            <button style="margin-left:10px;"  type="button" onclick="tourlamp()" class="btn btn-success btn-xm"><span name="xxxx" id="403">巡测灯具状态</span></button>
                                                                        </td>
        
                                    </tr>
        
        
                                </tbody>
                            </table> 
                        </div>
                    </div>
        
                    <div class="row" style="  margin-top: 10px;">
        
                        <div class="col-xs-3">
                            <table  style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px;margin-left: 20px;">
                                <tr>
                                    <td style=" padding-left: 5px;">
                                        <span id="37" name="xxx" >
                                            恢复模式
                                            &nbsp;</span>
                                    </td>
                                    <td>
                                        <select class="easyui-combobox" id="type" name="type" style="width:120px; height: 30px">
                                            <option value="1" name="xxx" id="38">单灯恢复</option>
                                            <option value="2" name="xxx" id="39">按组恢复</option>    
                                            <option value="3" name="xxx" id="40">全部恢复</option>  
                                        </select>
                                    </td>
                                    <td>
                                        <button  type="button" onclick="restore()" class="btn btn-success btn-sm">
                                            恢复自动运行
                                            <span id="41" name="xxx">恢复自动运行</span>
                                        </button>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-xs-5"  style=" margin-left: 80px;"  id="light0">
                            <table   style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px;margin-left: 30px;">
                                <tr>
                                    <td >
                                        <span id="42" name="xxx">
                                            调光值
                                            &nbsp;</span>
                                        <input id="val" value="0" class="form-control" readonly="true" name="val" style="width:50px;display: inline; height: 30px; " placeholder="调光值" type="text">
        
                                    </td>
                                    <td>
                                        <div  id="slide_lamp_val"  class="easyui-slider"     data-options="showTip:true,min:0,max:100,step:1" style="width:100px;    "></div>
        
                                    </td>
                                    <td>
                                        <button  type="button"  name="btnsingle"  onclick="lightsingle()" class="btn btn-success btn-sm">
                                            <span id="43" name="xxx">单灯立即调光</span>
                                        </button>
                                        <button  type="button" name="btngroupe"  style="display: none"  onclick="lightgroupe()" class="btn btn-success btn-sm">
                                            <span id="44" name="xxx">按组立即调光</span>
                                        </button>
        
                                        <button  type="button" name="btnall"  style="display: none"  onclick='onlamp($("#val").val())' class="btn btn-success btn-sm">
                                            <span id="336" name="xxx">全网调光</span>
                                        </button>
        
                                    </td>
                                </tr>
                            </table>
                        </div>
        
        
                        <div class="col-xs-5"  id="light1" style="margin-left: 80px;display: none;">
                            <table   style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px; margin-left: 30px;">
                                <tbody>
                                    <tr>
                                        <td>
        
                                            <span style="margin-left:10px;">
                                                场景号
                                                <span id="47" name="xxx">场景号</span>
                                                &nbsp;</span>
                                            <input id="scennum" class="form-control" name="scennum" style="width:50px;display: inline;" placeholder="场景号" type="text">&nbsp;
                                            <select class="easyui-combobox" id="scennum" name="scennum" style="width:150px; height: 30px">
                                                <option value="1" name="xxx" id="320">场景1</option>
                                                <option value="2" name="xxx" id="321">场景2</option>    
                                                <option value="3" name="xxx" id="322">场景3</option> 
                                                <option value="4" name="xxx" id="323">场景4</option> 
                                                <option value="5" name="xxx" id="324">场景5</option> 
                                                <option value="6" name="xxx" id="325">场景6</option> 
                                                <option value="7" name="xxx" id="326">场景7</option> 
                                                <option value="8" name="xxx" id="327">场景8</option> 
                                            </select>
                                            <button  type="button"  name="btnsingle" style="margin-left:20px;" onclick="scenesingle()" class="btn btn-success btn-sm">
                                                单灯场景调光
                                                <span id="45" name="xxx">单灯场景调光</span>
                                            </button>
                                            <button  type="button" name="btngroupe" style="margin-left:20px; display: none" onclick="scenegroupe()" class="btn btn-success btn-sm">
                                                按组场景调光
                                                <span id="46" name="xxx">按组场景调光</span>
                                            </button>
        
                                            <button  type="button" name="btnall" style="margin-left:20px; display: none" onclick="sceneAll()" class="btn btn-success btn-sm">
                                                全网场景调光
                                                <span id="337" name="xxx">全网场景调光</span>
                                            </button>
        
                                        </td>
        
                                    </tr>
        
                                </tbody>
                            </table> 
                        </div>
                        <div class="col-xs-2" style=" margin-top: 10px; margin-left: -30px; "  >
        
                            <button   type="button" onclick="tourControllamp()" class="btn btn-success btn-xm"><span name="xxxx" id="403">巡测所有灯具状态</span></button>
        
                        </div>
                    </div>
        
        
                </form>
        
        
                <table id="lamptable" style="width:100%;"  class="text-nowrap table table-hover table-striped">
                </table>-->


    </body>
</html>
