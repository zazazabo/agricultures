<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns:f="http://java.sun.com/jsf/core">
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } 

            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 

        </style>    


        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function showDialog() {

                for (var i = 1; i < 9; i++) {
                    $("#time" + i.toString()).timespinner('setValue', '00:00');
                    $("#num" + i.toString()).val(i.toString());
                    $("#num" + i.toString()).attr('readonly', true);
                }

                var u = $("#p_type").combobox('getValue');
                $("#p_type1").combobox('setValue', u);

                $("#p_name1").val("");
                $('#dialog-add').dialog('open');
                return false;
            }
            function checkPlanLampAdd() {

                var a = $("#formadd").serializeObject();
                // addlogon(u_name, "添加", o_pid, "灯具策略", "添加灯具方案");
                if (a.p_type == "0") {
                    var val1 = 0;
                    var val2 = 0;
                    var val3 = 0;
                    var val4 = 0;
                    var val5 = 0;
                    var val6 = 0;
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val1))) {
                        val1 = a.val1;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val2))) {
                        val2 = a.val2;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val3))) {
                        val3 = a.val3;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val4))) {
                        val4 = a.val4;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val5))) {
                        val5 = a.val5;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val6))) {
                        val6 = a.val6;
                    }
                    var obj1 = {"time": a.time1, "value": parseInt(val1)};
                    var obj2 = {"time": a.time2, "value": parseInt(val2)};
                    var obj3 = {"time": a.time3, "value": parseInt(val3)};
                    var obj4 = {"time": a.time4, "value": parseInt(val4)};
                    var obj5 = {"time": a.time5, "value": parseInt(val5)};
                    var obj6 = {"time": a.time6, "value": parseInt(val6)};

                    a.p_time1 = JSON.stringify(obj1);
                    a.p_time2 = JSON.stringify(obj2);
                    a.p_time3 = JSON.stringify(obj3);
                    a.p_time4 = JSON.stringify(obj4);
                    a.p_time5 = JSON.stringify(obj5);
                    a.p_time6 = JSON.stringify(obj6);
                    var ret = false;
                    $.ajax({async: false, url: "lamp.planForm.addlamp.action", type: "get", datatype: "JSON", data: a,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                                $("#table_lamp").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    return ret;
                }
                if (a.p_type == "1") {
                    console.log("场景方案");
                    var o = {};
                    for (var i = 0; i < 8; i++) {
                        var f = "p_scene" + (i + 1).toString();
                        var num = "num" + (i + 1).toString();
                        var val = "_val" + (i + 1).toString();
                        var val2 = 0;
                        if ((/^([1-9][0-9]{0,1}|100)$/.test(a[val]))) {
                            val2 = a[val];
                        }
                        var o1 = {"num": a[num], "value": val2 };
                        o[f] = JSON.stringify(o1);
                    }
                    o.p_name = a.p_name;
                    o.p_type = a.p_type;
                    o.pid = a.pid;
                    console.log(o);
                    var ret = false;
//f                    return false;
                    $.ajax({async: false, url: "lamp.planForm.addscene.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                                $("#tablescene").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    return ret;

                }
                return  false;

            }


            function editlampplan_finish() {
                var a = $("#form2").serializeObject();
                addlogon(u_name, "修改", o_pid, "灯具策略", "修改灯具方案");
                if (a.p_type == "0") {
                    var val1 = 0;
                    var val2 = 0;
                    var val3 = 0;
                    var val4 = 0;
                    var val5 = 0;
                    var val6 = 0;
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val1))) {
                        val1 = a.val1;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val2))) {
                        val2 = a.val2;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val3))) {
                        val3 = a.val3;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val4))) {
                        val4 = a.val4;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val5))) {
                        val5 = a.val5;
                    }
                    if ((/^([1-9][0-9]{0,1}|100)$/.test(a.val6))) {
                        val6 = a.val6;
                    }
                    var obj1 = {"time": a.time1, "value": parseInt(val1)};
                    var obj2 = {"time": a.time2, "value": parseInt(val2)};
                    var obj3 = {"time": a.time3, "value": parseInt(val3)};
                    var obj4 = {"time": a.time4, "value": parseInt(val4)};
                    var obj5 = {"time": a.time5, "value": parseInt(val5)};
                    var obj6 = {"time": a.time6, "value": parseInt(val6)};

                    a.p_time1 = JSON.stringify(obj1);
                    a.p_time2 = JSON.stringify(obj2);
                    a.p_time3 = JSON.stringify(obj3);
                    a.p_time4 = JSON.stringify(obj4);
                    a.p_time5 = JSON.stringify(obj5);
                    a.p_time6 = JSON.stringify(obj6);

                    var ret = false;
                    $.ajax({async: false, url: "lamp.planForm.editlamp1.action", type: "get", datatype: "JSON", data: a,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                                $("#table_lamp").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                if (a.p_type == 1) {

                    var o = {};
                    for (var i = 0; i < 8; i++) {
                        var f = "p_scene" + (i + 1).toString();
                        var num = "num" + (i + 1).toString();
                        var val = "_val" + (i + 1).toString();
                        var val2 = 0;
                        if ((/^([1-9][0-9]{0,1}|100)$/.test(a[val]))) {
                            val2 = a[val];
                        }
                        var o1 = {"num": a[num], "value": val2};
                        o[f] = JSON.stringify(o1);
                    }
                    o.p_name = a.p_name;
                    o.p_type = a.p_type;
                    o.id = a.id;
                    var ret = false;
                    $.ajax({async: false, url: "lamp.planForm.editlampscene.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                                $("#tablescene").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                return false;

            }

            function editlampplan() {

                var v = $(".bootstrap-table");
                var v1 = $(v[0]).css('display');
                var v2 = $(v[1]).css('display');
                var b = "";
                if (v1 == "block") {
                    b = "#table_lamp";
                }
                if (v2 == "block") {
                    b = "#tablescene";
                }
                var selects = $(b).bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);  //请选择表格数据
                    return false;
                } else if (selects.length > 1) {
                    layerAler(langs1[74][lang]);  //只能编辑单行数据
                    return false;
                }
                var select = selects[0];
                console.log(select);
                var code = select.p_code;
                $("#lampcode").val(code);
                $("#hidden_id").val(select.id);
                $("#p_type2").combobox('readonly', true);
                $("#p_type2").combobox('select', select.p_type);

                var u = $("input[name='p_name']");
                $(u).val(select.p_name);
                if (select.p_type == "0") {
                    $('#scen1').hide();
                    $('#time_').show();
                    console.log('时间方式');
                    var obj1 = eval('(' + select.p_time1 + ')');
                    var obj2 = eval('(' + select.p_time2 + ')');
                    var obj3 = eval('(' + select.p_time3 + ')');
                    var obj4 = eval('(' + select.p_time4 + ')');
                    var obj5 = eval('(' + select.p_time5 + ')');
                    var obj6 = eval('(' + select.p_time6 + ')');
                    var valinput = $("input[name='val1']")[1];
                    $(valinput).val(obj1.value);
                    var valinput = $("input[name='val2']")[1];
                    $(valinput).val(obj2.value);
                    var valinput = $("input[name='val3']")[1];
                    $(valinput).val(obj3.value);
                    var valinput = $("input[name='val4']")[1];
                    $(valinput).val(obj4.value);
                    var valinput = $("input[name='val5']")[1];
                    $(valinput).val(obj5.value);
                    var valinput = $("input[name='val6']")[1];
                    $(valinput).val(obj6.value);
                    $('#time1_').timespinner('setValue', obj1.time);
                    $('#time2_').timespinner('setValue', obj2.time);
                    $('#time3_').timespinner('setValue', obj3.time);
                    $('#time4_').timespinner('setValue', obj4.time);
                    $('#time5_').timespinner('setValue', obj5.time);
                    $('#time6_').timespinner('setValue', obj6.time);

                }
                if (select.p_type == "1") {
                    $('#scen1').show();
                    $('#time_').hide();
                    console.log('场景方式');
                    for (var i = 0; i < 8; i++) {
                        var attr = 'p_scene' + (i + 1).toString();
                        var scene = select[attr];

                        if (isJSON(scene)) {
                            var obj = eval('(' + scene + ')');
                            var num = "#__num" + (i + 1).toString();
                            var val = "#__val" + (i + 1).toString();
                            $(num).val(obj.num);
                            $(num).attr('readonly', true);
                            $(val).val(obj.value);
                        }
                    }


                }
                $('#dialog-edit').dialog('open');
                return false;
                //$("#MODAL_EDIT").modal();
            }

            function deletelampplan() {
                var v = $(".bootstrap-table");
                var v1 = $(v[0]).css('display');
                var v2 = $(v[1]).css('display');
                var b = "";
                if (v1 == "block") {
                    b = "#table_lamp";
                }
                if (v2 == "block") {
                    b = "#tablescene";
                }
                var selects = $(b).bootstrapTable('getSelections');

                layer.confirm(langs1[145][lang], {//您确定要删除吗？
                    btn: [langs1[146][lang], langs1[147][lang]], //确定、取消按钮
                    icon: 3,
                    offset: 'center',
                    title: langs1[174][lang]   //提示
                }, function (index) {
                    addlogon(u_name, "删除", o_pid, "灯具策略", "删除灯具方案");
                    for (var i = 0; i < selects.length; i++) {
                        var select = selects[i];
                        $.ajax({async: false, url: "loop.planForm.deleteloop.action", type: "get", datatype: "JSON", data: {id: select.id},
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    $(b).bootstrapTable('refresh');
                                }

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    }
                    layer.close(index);
                });


            }

            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 500,
                    position: ["top", "top"],
                    buttons: {
                        添加: function () {
                            $("#formadd").submit();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#dialog-edit").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 500,
                    position: "top",
                    buttons: {
                        修改: function () {
                            editlampplan_finish();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#p_type1").combobox(
                        {
                            onSelect: function (record) {
                                if (record.value == "0") {
                                    $("#scen").hide();
                                    $("#time").show();
                                }
                                if (record.value == "1")
                                {
                                    $("#scen").show();
                                    $("#time").hide();
                                }
                            }
                        }
                )
                $("#p_type").combobox('select', '0');
                $('#p_type').combobox({
                    onSelect: function (record) {
                        if (record.value == 0) {
                            var v = $(".bootstrap-table");
                            $(v[0]).show();
                            $(v[1]).hide();
                            var url = "lamp.planForm.getLampPlan.action";
                            var obj = {p_type: record.value, p_attr: 1};
                            var opt = {
                                url: url,
                                silent: true,
                                query: obj
                            };

                            $("#table_lamp").bootstrapTable('refresh', opt);

                        } else if (record.value == 1) {
                            var v = $(".bootstrap-table");
                            $(v[1]).show();
                            $(v[0]).hide();

                            var url = "lamp.planForm.getLampPlan.action";
                            var obj = {p_type: record.value, p_attr: 1};
                            var opt = {
                                url: url,
                                silent: true,
                                query: obj
                            };

                            $("#tablescene").bootstrapTable('refresh', opt);


                        }
                    }
                })

                $("#add").attr("disabled", true);
                $("#update").attr("disabled", true);
                $("#del").attr("disabled", true);

                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {
                                if (rs[i].code == "400201" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400202" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400203" && rs[i].enable != 0) {
                                    $("#del").attr("disabled", false);
                                    continue;
                                }
                            }
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });




                $('#table_lamp').bootstrapTable({
                    url: 'lamp.planForm.getLampPlan.action',
                    clickToSelect: true,
                    columns: [
                        [
                            {
                                title: '单选',
                                field: 'select',
                                //复选框
                                checkbox: true,
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1

                            },
                            {
                                field: 'p_name',
                                title: langs1[69][lang], //方案名称
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_code',
                                title: langs1[70][lang], //方案编码
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_time',
                                title: langs1[75][lang], //时间一
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: langs1[76][lang], //时间二
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: langs1[78][lang], //时间三
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: langs1[79][lang], //时间四
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: langs1[80][lang], //时间五
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: langs1[81][lang], //时间六
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_time1',
                                title: langs1[82][lang], //时间
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val1',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time1)) {
                                        var obj = eval('(' + row.p_time1 + ')');
                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }


                                    }

                                }

                            }, {
                                field: 'p_time2',
                                title: langs1[82][lang], //时间
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val2',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time2)) {
                                        var obj = eval('(' + row.p_time2 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time3',
                                title: langs1[82][lang], //时间
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val3',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time3)) {
                                        var obj = eval('(' + row.p_time3 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time4',
                                title: langs1[82][lang], //时间
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val4',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time4)) {
                                        var obj = eval('(' + row.p_time4 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time5',
                                title: langs1[82][lang], //时间
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val5',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time5)) {
                                        var obj = eval('(' + row.p_time5 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time6',
                                title: langs1[82][lang], //时间
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val6',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time6)) {
                                        var obj = eval('(' + row.p_time6 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }
                        ]
                    ],
                    singleSelect: false,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 5,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            p_attr: "1",
                            p_type: 0,
                            type_id: "1",
                            pid: "${param.pid}"   
                        };      
                        return temp;  
                    },
                });



                $('#tablescene').bootstrapTable({
                    url: 'lamp.planForm.getLampPlan.action',
                    clickToSelect: true,
                    columns: [
                        [
                            {
                                title: '单选',
                                field: 'select',
                                //复选框
                                checkbox: true,
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1

                            },
                            {
                                field: 'p_name',
                                title: langs1[69][lang], //方案名称
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_code',
                                title: langs1[70][lang], //方案编号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_scene',
                                title: langs1[83][lang], //场景一
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[84][lang], //场景二
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[85][lang], //场景三
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[86][lang], //场景四
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[87][lang], //场景五
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[88][lang], //场景六
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[90][lang], //场景七
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: langs1[91][lang], //场景八
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_scene1',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val1',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene1)) {
                                        var obj = eval('(' + row.p_scene1 + ')');
                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }


                                    }

                                }

                            }, {
                                field: 'p_scene2',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val2',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene2)) {
                                        var obj = eval('(' + row.p_scene2 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_scene3',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val3',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene3)) {
                                        var obj = eval('(' + row.p_scene3 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_scene4',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val4',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene4)) {
                                        var obj = eval('(' + row.p_scene4 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_scene5',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val5',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene5)) {
                                        var obj = eval('(' + row.p_scene5 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_scene6',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val6',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene6)) {
                                        var obj = eval('(' + row.p_scene6 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_scene7',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val7',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene7)) {
                                        var obj = eval('(' + row.p_scene7 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_scene8',
                                title: langs1[89][lang], //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.num;
                                    }

                                }
                            },
                            {
                                field: 'p_val8',
                                title: langs1[42][lang], //调光值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_scene8)) {
                                        var obj = eval('(' + row.p_scene8 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }
                        ]
                    ],
                    singleSelect: false,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 5,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            p_attr: 1,
                            p_type: 1,
                            type_id: "1",
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
                });



                var tables = $(".bootstrap-table");
                $(tables[1]).hide();


            })

        </script>

        <!--        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
                <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>-->

    </head>

    <body>


        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" onclick="showDialog()" data-target="#modal_add1" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <span name="xxx" id="65">添加</span>
            </button>
            <button class="btn btn-primary ctrol"   onclick="editlampplan()"  id="update">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;
                <span name="xxx" id="66">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deletelampplan();" id="del" >
                <span class="glyphicon glyphicon-trash"></span>&nbsp;
                <span name="xxx" id="67">删除</span>
            </button>
            <span style="margin-left:20px;" name="xxx" id="68">方案类型</span>&nbsp;
            <span class="menuBox">
                <select class="easyui-combobox" data-options="editable:false" id="p_type" name="p_type" style="width:150px; height: 30px; margin-left: 3px;">
                    <option value="0">时间</option>
                    <option value="1">场景</option>           
                </select>
            </span> 
        </div>
        <table id="table_lamp" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>  
        <table id="tablescene" style="width:100%; " class="text-nowrap table table-hover table-striped">
        </table> 


        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="灯具方案添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkPlanLampAdd()">      
                <input type="hidden" name="pid" value="${param.pid}"/>
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span >&nbsp;&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="68">方案类型</span>
                                    &nbsp;</span>
                                <span class="menuBox">
                                    <select class="easyui-combobox" data-options="editable:false" id="p_type1" name="p_type" style="width:150px; height: 30px; margin-left: 3px;">
                                        <option value="0">时间</option>
                                        <option value="1">场景</option>           
                                    </select>
                                </span>  
                            </td>
                            <td></td>
                            <td>

                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span id="69" name="xxx">方案名称</span>
                                </span>&nbsp;
                                <input id="p_name1" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                            </td>
                        </tr>


                    </tbody>
                </table>

                <table  id="time" class="aaa">
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="75">时间一</span>&nbsp;

                                <input id="time1"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val1" class="form-control" name="val1" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr>                                   
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="76">时间二</span>&nbsp;
                                <input id="time2" name="time2" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val2" class="form-control" name="val2" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="78" name="xxx">时间三</span>&nbsp;
                                <input id="time3" name="time3" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val3" class="form-control" name="val3" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="79">时间四</span>&nbsp;
                                <input id="time4" name="time4" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val4" class="form-control" name="val4" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="80" name="xxx">时间五</span>&nbsp;
                                <input id="time5" name="time5" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val5" class="form-control" name="val5" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="81">时间六</span>&nbsp;
                                <input id="time6" name="time6" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val6" class="form-control" name="val6" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                    </tbody>
                </table>


                <table id="scen"  class="aaa" style=" display: none">
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num1" class="form-control" name="num1" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" id="42" name="xxx">调光值</span>&nbsp;
                                <input id="_val1" class="form-control" name="_val1" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="89" name="xxx">场景号</span>&nbsp;
                                <input id="num2" class="form-control" name="num2" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" id="42" name="xxx">调光值</span>&nbsp;
                                <input id="_val2" class="form-control" name="_val2" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num3" class="form-control" name="num3" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="_val3" class="form-control" name="_val3" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num4" class="form-control" name="num4" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="_val4" class="form-control" name="_val4" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num5" class="form-control" name="num5" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="_val5" class="form-control" name="_val5" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num6" class="form-control" name="num6" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="_val6" class="form-control" name="_val6" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 

                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num7" class="form-control" name="num7" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="_val7" class="form-control" name="_val7" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="num8" class="form-control" name="num8" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="_val8" class="form-control" name="_val8" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 


                    </tbody>
                </table>

            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="灯具方案修改">
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hidden_id" name="id">  
                <input type="hidden" name="pid" value="${param.pid}"/>
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span >&nbsp;&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="68">方案类型</span>
                                    &nbsp;</span>
                                <span class="menuBox">
                                    <select class="easyui-combobox" data-options="editable:false" id="p_type2" name="p_type" style="width:150px; height: 30px; margin-left: 3px;">
                                        <option value="0">时间</option>
                                        <option value="1">场景</option>           
                                    </select>
                                </span>  
                            </td>
                            <td></td>
                            <td>

                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="69">方案名称</span>
                                </span>&nbsp;
                                <input id="p_name1" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                            </td>
                        </tr>


                    </tbody>
                </table>

                <table  id="time_">
                    <tbody>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="75" name="xxx">时间一</span>&nbsp;
                                <input id="time1_"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val1_" class="form-control" name="val1" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr>                                   
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="76">时间二</span>&nbsp;
                                <input id="time2_" name="time2" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val2_" class="form-control" name="val2" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="78">时间三</span>&nbsp;
                                <input id="time3_" name="time3" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val3_" class="form-control" name="val3" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="79" name="xxx">时间四</span>&nbsp;
                                <input id="time4_" name="time4" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val4_" class="form-control" name="val4" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="80" name="xxx">时间五</span>&nbsp;
                                <input id="time5_" name="time5" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val5_" class="form-control" name="val5" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="81">时间六</span>&nbsp;
                                <input id="time6_" name="time6" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;
                                    <span name="xxx" id="42">调光值</span>
                                </span>&nbsp;
                                <input id="val6_" class="form-control" name="val6" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                            </td>
                        </tr> 
                    </tbody>
                </table>

                <table id="scen1"  style=" display: none">
                    <tbody>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" id="89" name="xxx">场景号</span>&nbsp;
                                <input id="__num1" class="form-control" name="num1" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" id="42" name="xxx">调光值</span>&nbsp;
                                <input id="__val1" class="form-control" name="_val1" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num2" class="form-control" name="num2" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val2" class="form-control" name="_val2" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num3" class="form-control" name="num3" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val3" class="form-control" name="_val3" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num4" class="form-control" name="num4" value="4" readonly="true" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val4" class="form-control" name="_val4"   style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num5" class="form-control" name="num5" value="5" readonly="true" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" id="42" name="xxx">调光值</span>&nbsp;
                                <input id="__val5" class="form-control" name="_val5" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num6" class="form-control" name="num6"  style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val6" class="form-control" name="_val6" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 

                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num7" class="form-control" name="num7" value="7" readonly="true" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" id="42" name="xxx">调光值</span>&nbsp;
                                <input id="__val7" class="form-control" name="_val7" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="89">场景号</span>&nbsp;
                                <input id="__num8" class="form-control" name="num8"  style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="42">调光值</span>&nbsp;
                                <input id="__val8" class="form-control" name="_val8" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr>                   


                    </tbody>
                </table>

            </form>
        </div>


    </body>
</html>