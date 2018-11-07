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
        <style>
            .btn {
                margin-left: 10px;
            }
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var websocket = null;
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function setNowTime() {
                var myDate = new Date();
                var timestr = sprintf("%02d:%02d", myDate.getHours(), myDate.getMinutes());

                for (var i = 1; i < 7; i++) {

                    $("#time" + i.toString()).spinner('setValue', timestr);
                }
            }
            function resetWowktypeCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var o = {};
                    o.l_comaddr = obj.comaddr;
                    o.l_worktype = obj.val;
                    o.l_groupe = obj.param;
                    $.ajax({
                        async: false, url: "lamp.lampform.modifyworktype.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                layerAler(langs1[391][lang]);  //更换工作方式成功
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
            }
            function resetWowktype() {
                var o = $("#form1").serializeObject();
                if (o.l_comaddr == "" || o.l_groupe == "") {
                    layerAler(langs1[392][lang]);   //网关或组号不能为空
                    return;
                }
                var oldlgroupe = "";
                var vv = [];
                o.type = 2;
                vv.push(o.type);  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器
                vv.push(parseInt(o.l_groupe)); //原组号


                vv.push(parseInt(o.l_worktype)); //新工作方式  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 120, vv); //01 03 F24    

                dealsend2("A4", data, 120, "resetWowktypeCB", comaddr, o.type, oldlgroupe, o.l_worktype);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function resetGroupeCB(obj) {
                $('#panemask').hideLoading();
                var o = {};
                o.l_comaddr = obj.comaddr;
                o.l_groupe = obj.val;
                if (obj.status == "success") {
                    o.oldlgroupe = obj.param;
                    $.ajax({
                        async: false, url: "lamp.lampform.modifygroup.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#l_groupe").combobox('clear');
                                var url = "lamp.GroupeForm.getGroupe.action?l_comaddr=" + o.l_comaddr + "&l_deplayment=1";
                                $("#l_groupe").combobox('reload', url);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    layerAler(langs1[143][lang]);   //修改成功

                }
            }
            function resetGroupe() {

                var o = $("#form1").serializeObject();
                if (o.l_comaddr == "" || o.l_groupe == "") {
                    layerAler(langs1[392][lang]);   //网关或组号不能为空
                    return;
                }
                o.type = 2;
                var vv = [];
                vv.push(o.type);
                vv.push(parseInt(o.l_groupe)); //原组号
                vv.push(parseInt(o.l_groupe1)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 110, vv); //01 03 F24    
                dealsend2("A4", data, 110, "resetGroupeCB", comaddr, o.type, o.l_groupe, o.l_groupe1);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }


            function readLampPlanCB(obj) {
                $('#panemask').hideLoading();
                console.log(obj);
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {

                    v = v + sprintf("%02x", data[i]) + " ";
                }
                console.log(v);
                if (obj.status == "success") {
                    if (obj.fn == 402) {
                        //读场景方案
                        for (var i = 0; i < 8; i++) {
                            var t0 = 20 + (i * 2);
                            var t1 = 20 + (i * 2) + 1;
                            $("#__num" + (i + 1).toString()).val(data[t0].toString());
                            $("#__val" + (i + 1).toString()).val(data[t1].toString());
                        }

                    } else if (obj.fn == 401) {
                        //读时间方案
                        for (var i = 0; i < 6; i++) {
                            var t0 = 20 + (i * 3);
                            var t1 = 20 + (i * 3) + 1;
                            var t2 = 20 + (i * 3) + 2;
                            var time = sprintf("%02x:%02x", data[t1], data[t0]);
                            $("#time" + (i + 1).toString()).timespinner('setValue', time);
                            $("#val" + (i + 1).toString()).val(data[t2].toString());

                        }

                    }
                }
            }

            function readLampPlan() {

                var obj = $("#form1").serializeObject();
                console.log(obj);
                if (obj.l_comaddr == "" || obj.l_groupe == "") {
                    layerAler(langs1[392][lang]);   //网关或组号不能为空
                    return;
                }
                var v = obj.p_type;
                if (v == "0") {

                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(obj.l_groupe));
                    var comaddr = obj.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xAA, num, 0, 401, vv); //01 03 F24    
                    dealsend2("AA", data, 401, "readLampPlanCB", comaddr, 0, obj.p_type, 0, 0);
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 10000);
                        }
                    }
                    );
                }

                if (v == "1") {
                    //console.log('读取分组场景方案');
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(obj.l_groupe));
                    var comaddr = obj.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xAA, num, 0, 402, vv); //01 03 F24    
                    dealsend2("AA", data, 402, "readLampPlanCB", comaddr, 0, obj.p_type, 0, 0);
                }
            }

            function setLampPlanCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    if (obj.fn == 140) { //时间
                        var oo = {p_code: obj.param, p_name: obj.type};
                        var p_code = JSON.stringify(oo);
                        var ooo = {l_comaddr: obj.comaddr, l_groupe: obj.val, l_plantime: p_code};
                        $.ajax({
                            async: false, url: "lamp.planForm.modifylampplantime.action", type: "get", datatype: "JSON", data: ooo,
                            success: function (data) {

                                var arrlist = data.rs;
                                if (arrlist.length == 1) {

                                }
                            },
                            error: function () {
                                alert("提交灯具挂钩的方案！");
                            }
                        });

                        var a = $("#form1").serializeObject();
                        var obj1 = {"time": a.time1, "value": parseInt(a.val1)};
                        var obj2 = {"time": a.time2, "value": parseInt(a.val2)};
                        var obj3 = {"time": a.time3, "value": parseInt(a.val3)};
                        var obj4 = {"time": a.time4, "value": parseInt(a.val4)};
                        var obj5 = {"time": a.time5, "value": parseInt(a.val5)};
                        var obj6 = {"time": a.time6, "value": parseInt(a.val6)};

                        a.p_time1 = JSON.stringify(obj1);
                        a.p_time2 = JSON.stringify(obj2);
                        a.p_time3 = JSON.stringify(obj3);
                        a.p_time4 = JSON.stringify(obj4);
                        a.p_time5 = JSON.stringify(obj5);
                        a.p_time6 = JSON.stringify(obj6);
                        $.ajax({
                            async: false, url: "lamp.planForm.editlamp.action", type: "get", datatype: "JSON", data: a,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    // $('#p_plan').combobox('reload');
                                    layerAler(langs1[394][lang]);   //部署灯具时间方案成功
                                    addlogon(u_name, "部署", o_pid, "灯具分组管理", "部署灯具方案");
                                    // $('#p_plan').combobox('setValue', a.p_code);
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    } else if (obj.fn == 480) {  //场景

                        var oo = {p_code: obj.param, p_name: obj.type};
                        var p_code = JSON.stringify(oo);
                        var ooo = {l_comaddr: obj.comaddr, l_groupe: obj.val, l_planscene: p_code};
                        $.ajax({
                            async: false, url: "lamp.planForm.modifylampplanscene.action", type: "get", datatype: "JSON", data: ooo,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {

                                }
                            },
                            error: function () {
                                alert("提交灯具挂钩场景的方案！");
                            }
                        });
                        var a = $("#form1").serializeObject();
                        console.log(a);
                        var o = {};
                        for (var i = 0; i < 8; i++) {
                            var f = "p_scene" + (i + 1).toString();
                            var num = "__num" + (i + 1).toString();
                            var val = "__val" + (i + 1).toString();
                            var o1 = {"num": a[num], "value": a[val]};
                            o[f] = JSON.stringify(o1);
                        }
                        o.p_code = obj.param;
                        o.p_name = obj.type;
                        var ret = false;
                        $.ajax({
                            async: false, url: "lamp.planForm.editlampscenebycode.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    layerAler(langs1[395][lang]);  //部署灯具场景方案成功
                                    // $('#p_plan').combobox('reload');
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });

                    }

                }
            }

            function setLampPlan() {

                var obj = $("#form1").serializeObject();
                if (obj.l_comaddr == "" || obj.l_groupe == "") {
                    layerAler(langs1[392][lang]);   //网关或组号不能为空
                    return;
                }
                var v = obj.p_type;
                if (v == "0") {
                    //console.log('部署分组时间方案');
                    for (var i = 0; i < 6; i++) {
                        var b = "val" + (i + 1).toString();
                        var val = parseInt(obj[b]);
                        if (!(/^([0-9][0-9]{0,1}|100)$/.test(val))) {
                            layerAler(langs1[409][lang]);  //调光值必须为0-100的正整数
                            return;
                        }

                    }
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(obj.l_groupe));
                    for (var i = 0; i < 6; i++) {
                        var a = "time" + (i + 1).toString();
                        var b = "val" + (i + 1).toString();
                        var time = obj[a];
                        var val = obj[b];
                        var a1 = time.split(":");
                        var m = parseInt(a1[1], 16);
                        var h = parseInt(a1[0], 16);
                        vv.push(m);
                        vv.push(h);
                        vv.push(parseInt(val));
                    }

                    var comaddr = obj.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 140, vv); //01 03 F24    
                    dealsend2("A4", data, 140, "setLampPlanCB", comaddr, obj.p_name, obj.p_code, obj.l_groupe);
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 10000);
                        }
                    }
                    );
                }

                if (v == "1") {
                    for (var i = 0; i < 8; i++) {
                        var b = "__val" + (i + 1).toString();
                        var val = obj[b];
                        if (!(/^([0-9][0-9]{0,1}|100)$/.test(val))) {
                            layerAler(langs1[409][lang]);  //调光值必须为0-100的正整数
                            return;
                        }

                    }
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(obj.l_groupe));
                    for (var i = 0; i < 8; i++) {
                        var a = "__num" + (i + 1).toString();
                        var b = "__val" + (i + 1).toString();
                        var num = parseInt(obj[a]);
                        var val = parseInt(obj[b]);
                        vv.push(num);
                        vv.push(val);
                    }
                    var comaddr = obj.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 480, vv); //01 03 F24    
                    dealsend2("A4", data, 480, "setLampPlanCB", comaddr, obj.p_name, obj.p_code, obj.l_groupe);
                }

            }

            function setlampAllPlanCB(obj) {
                $('#panemask').hideLoading();

            }

            function setlampAllPlan() {
                var obj = $("#form1").serializeObject();
                console.log(obj);
                if (obj.l_comaddr == "") {
                    layerAler(langs1[172][lang]);   //网关不能为空
                    return;
                }
                var vv = [];
                vv.push(0);
                for (var i = 0; i < 8; i++) {
                    var a = "__num" + (i + 1).toString();
                    var b = "__val" + (i + 1).toString();
                    var num = parseInt(obj[a]);
                    var val = parseInt(obj[b]);
                    vv.push(num);
                    vv.push(val);
                }
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 501, vv); //01 03 F24    
                dealsend2("A4", data, 501, "setlampAllPlanCB", comaddr, 0, obj.p_code, 0);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $('#type').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        }
                    },
                    onSelect: function (record) {
                        var rowdiv = $(".row");
                        for (var i = 0; i < rowdiv.length; i++) {
                            var row = rowdiv[i];
                            if (i == 0) {
                                continue;
                            }
                            $(row).hide();
                        }

                        var v = parseInt(record.id);
                        $(rowdiv[v]).show();

                    }
                });


                $('#l_comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].id;
                            }

                            $(this).combobox('select', data[0].id);

                        }
                    },
                    onSelect: function (record) {
                        var obj = {l_comaddr: record.id};
                        $("#l_groupe").combobox('clear');
                        var url = "lamp.GroupeForm.getGroupe.action?l_comaddr=" + record.id + "&l_deplayment=1";
                        $("#l_groupe").combobox('reload', url);


                    }
                });


                $('#p_plan').combobox({
                    url: "lamp.GroupeForm.getPlanlist.action?attr=1&pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.p_type == 0 ? "(时间)" : "(场景)";
                        var v = row.p_name + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {

                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].p_name;
                            }

                            $(this).combobox('select', data[0].id);

                        }




                        for (var i = 1; i < 9; i++) {
                            $("#__num" + i.toString()).attr('readonly', true);
                        }
                    },
                    onSelect: function (record) {
                        $('#type' + record.p_type).show();
                        var v = 1 - parseInt(record.p_type);
                        $('#type' + v.toString()).hide();
                        $('#p_type').val(record.p_type);
                        $('#p_name').val(record.p_name);
                        $('#p_code').val(record.id);
                        if (record.p_type == 0) {
                            for (var i = 0; i < 6; i++) {
                                var a = "p_time" + (i + 1).toString();
                                var b = "#time" + (i + 1).toString();
                                var c = "#val" + (i + 1).toString();
                                var o = eval('(' + record[a] + ')');
                                if (o.hasOwnProperty('time') == false || o.hasOwnProperty('value') == false) {
                                    continue;
                                }
                                $(b).timespinner('setValue', o.time);
                                $(c).val(o.value);
                            }
                        }

                        if (record.p_type == 1) {
                            for (var i = 0; i < 8; i++) {
                                var a = "p_scene" + (i + 1).toString();
                                var b = record[a];
                                if (isJSON(b)) {
                                    var obj = eval('(' + b + ')');
                                    var num = "#__num" + (i + 1).toString();
                                    var val = "#__val" + (i + 1).toString();
                                    $(num).val(obj.num);
                                    $(val).val(obj.value);
                                }
                            }
                        }

                    }
                });

                var d = [];
                for (var i = 0; i < 18; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }
                $("#l_groupe1").combobox({
                    data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    },
                });


            })


        </script>

    </head>

    <body id="panemask">

        <form id="form1">
            <input name="p_type" type="hidden" id="p_type" />
            <input name="p_code" type="hidden" id="p_code" />
            <input name="p_name" type="hidden" id="p_name" />
            <div class="row">
                <div class="col-xs-12">
                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                        <tr>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;
                                <span class="menuBox">
                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" data-options="editable:false,valueField:'id', textField:'text' "
                                           />

                                    <!--<select name="l_comaddr_lamp" id="l_comaddr_lamp" placeholder="回路" class="input-sm" style="width:150px;">-->
                                </span>
                            </td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="332">组号</span>&nbsp;
                                <span class="menuBox">
                                    <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:100px; height: 30px" data-options="editable:true,valueField:'id', textField:'text' "
                                           />
                                </span>
                            </td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="187">功能选择</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="type" name="type" data-options="editable:false,valueField:'id', textField:'text'" style="width:200px; height: 30px">
                                        <option value="3">部署分组方案</option>
                                        <option value="1" selected="true">更换分组</option>
                                        <option value="2">按组更换工作方式 </option>

                                    </select>
                                </span>
                            </td>


                        </tr>
                    </table>
                </div>
            </div>

            <div class="row" id="row1">
                <div class="col-xs-12">

                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-top: 10px;  ">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:10px;" name="xxx" id="206">新组号</span>
                                    <span class="menuBox">
                                        <input id="l_groupe1" class="easyui-combobox" name="l_groupe1" style="width:100px; height: 30px" data-options="editable:true,valueField:'id', textField:'text' "
                                               />
                                    </span>

                                    <button type="button" onclick="resetGroupe()" class="btn btn-success btn-sm"><span name="xxx" id="397">更换分组</span></button>&nbsp
                                    <!--<span  onclick="resetGroupe()" style=" margin-left: 2px;" class="label label-success" >更换分组</span>-->
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>


            <div class="row" id="row2" style=" display: none">
                <div class="col-xs-12">

                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-top: 10px;  ">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:20px;" name="xxx" id="208">新工作方式</span>&nbsp;
                                    <span class="menuBox">
                                        <select class="easyui-combobox" id="l_worktype" name="l_worktype" data-options='editable:false' style="width:100px; height: 30px">
                                            <option value="0">时间</option>
                                            <option value="1">经纬度</option>
                                            <option value="2">场景</option>
                                        </select>
                                    </span>
                                    <button type="button" onclick="resetWowktype()" class="btn btn-success btn-sm"><span name="xxx" id="165">更换工作方式</span></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="row" style=" display: none">
                <div class="col-xs-12">
                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-top: 10px;">
                        <tr>
                            <td>
                                <span style=" margin-left: 10px;" name="xxx" id="382">方案列表</span>
                                <span class="menuBox">
                                    <input id="p_plan" class="easyui-combobox" name="p_plan" style="width:150px; height: 30px" data-options="editable:false,valueField:'id', textField:'text'"
                                           />
                            </td>
                            <td>
                                <button onclick="setLampPlan()" type="button" class="btn btn-success btn-sm"><span name="xxx" id="398">部署分组灯具方案</span></button>

                                <%-- <button onclick="setlampAllPlan()" type="button" class="btn btn-success btn-sm">部署全网灯具场景方案</button> --%>
                                <button onclick="readLampPlan()" type="button" class="btn btn-success btn-sm"><span name="xxx" id="399">读取分组灯具方案</span></button>


                                <button onclick="setNowTime()" type="button" class="btn btn-success btn-sm"><span name="xxx" id="400">设置当前时间</span></button>

                                </form>


                                </body>

                                </html>

                            </td>
                        </tr>
                    </table>
                </div>

                <div class="col-xs-12">
                    <table id="type0" style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; display: none ">
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="75">时间一</span>&nbsp;
                            </td>
                            <td>
                                <input id="time1" name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;<span name="xxx" id="42">调光值</span></span>&nbsp;
                            </td>
                            <td>
                                <input id="val1" class="form-control" name="val1" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="76">时间二</span>&nbsp;
                            </td>
                            <td>
                                <input id="time2" name="time2" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;<span name="xxx" id="42">调光值</span></span>&nbsp;
                            </td>
                            <td>
                                <input id="val2" class="form-control" name="val2" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="78">时间三</span>&nbsp;
                            </td>
                            <td>
                                <input id="time3" name="time3" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;<span name="xxx" id="42">调光值</span></span>&nbsp;
                            </td>
                            <td>
                                <input id="val3" class="form-control" name="val3" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="79">时间四</span>&nbsp;
                            </td>
                            <td>
                                <input id="time4" name="time4" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;<span name="xxx" id="42">调光值</span></span>&nbsp;
                            </td>
                            <td>
                                <input id="val4" class="form-control" name="val4" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="80">时间五</span>&nbsp;
                            </td>
                            <td>
                                <input id="time5" name="time5" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;<span name="xxx" id="42">调光值</span></span>&nbsp;
                            </td>
                            <td>
                                <input id="val5" class="form-control" name="val5" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="81">时间六</span>&nbsp;
                            </td>
                            <td>
                                <input id="time6" name="time6" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;<span name="xxx" id="42">调光值</span></span>&nbsp;
                            </td>
                            <td>
                                <input id="val6" class="form-control" name="val6" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>

                    </table>

                    <table id="type1" style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; display: none ">
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num1" class="form-control" name="__num1" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val1" class="form-control" name="__val1" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num2" class="form-control" name="__num2" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val2" class="form-control" name="__val2" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num3" class="form-control" name="__num3" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val3" class="form-control" name="__val3" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num4" class="form-control" name="__num4" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val4" class="form-control" name="__val4" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num5" class="form-control" name="__num5" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val5" class="form-control" name="__val5" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num6" class="form-control" name="__num6" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val6" class="form-control" name="__val6" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num7" class="form-control" name="__num7" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val7" class="form-control" name="__val7" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="47">场景号</span>&nbsp;
                                <input id="__num8" class="form-control" name="__num8" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val8" class="form-control" name="__val8" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>
                    </table>
                </div>
            </div>


        </form>


    </body>

</html>