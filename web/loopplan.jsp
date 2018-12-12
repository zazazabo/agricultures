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
        <style>
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

                $('#dialog-add').dialog('open');
                return false;
            }
            function editsubmit() {

                var obj = $("#form2").serializeObject();


                if (obj.p_type == "0") {
                    for (var i = 0; i < 5; i++) {
                        var ptimeval = "timeval" + (i + 1).toString();
                        var ptime = "time" + (i + 1).toString();
                        var timeval = obj[ptimeval];
                        var time = obj[ptime];
                        if (isNumber(timeval) == false) {
                            layerAler("控制值是一个数字 ");
                            return false;
                        }

                        var obj1 = {"time": time, "value": parseInt(timeval)};
                        var str = "p_time" + (i + 1).toString();
                        obj[str] = JSON.stringify(obj1);
                    }
                    var ret = false;
                    $.ajax({async: false, url: "loop.planForm.editLoopTimePlan.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var tables = $(".bootstrap-table");
                                for (var i = 0; i < tables.length; i++) {
                                    $(tables[i]).hide();
                                }
                                var index = parseInt(obj.p_type);
                                $(tables[index]).show();
                                $("#table" + obj.p_type).bootstrapTable('refresh');


                                ret = true;
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                if (obj.p_type == 1) {
                    for (var i = 0; i < 5; i++) {
                        var pscene = "scen" + (i + 1).toString();
                        var pval = "val" + (i + 1).toString();
                        var scene = obj[pscene];
                        var val = obj[pval];
                        if (isNumber(val) == false || isNumber(scene) == false) {
                            layerAler("场景与控制值是数字类型 ");
                            return false;
                        }

                        var obj1 = {"scene": parseInt(scene), "value": parseInt(val)};
                        var str = "p_scene" + (i + 1).toString();
                        obj[str] = JSON.stringify(obj1);
                    }

                    obj.pid = obj.pid;
                    var ret = false;
                    $.ajax({async: false, url: "loop.planForm.editLoopScenePlan.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var tables = $(".bootstrap-table");
                                for (var i = 0; i < tables.length; i++) {
                                    $(tables[i]).hide();
                                }
                                var index = parseInt(obj.p_type);
                                $(tables[index]).show();
                                $("#table" + obj.p_type).bootstrapTable('refresh');
                                ret = true;
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                } else if (obj.p_type == 2) {
                    for (var i = 0; i < 4; i++) {
                        var pinfo = "info" + (i + 1).toString();
                        var pinfoval = "infoval" + (i + 1).toString();
                        var info = obj[pinfo];
                        var val = obj[pinfoval];
                        if (isNumber(info) == false || isNumber(val) == false) {
                            layerAler("信息点与控制值是数字类型 ");
                            return false;
                        }

                        var obj1 = {"info": parseInt(info), "value": parseInt(val)};
                        var str = "p_info" + (i + 1).toString();
                        obj[str] = JSON.stringify(obj1);
                    }
                    var obj2 = {"num": parseInt(obj.infonum), "offset": parseInt(obj.offset)};
                    obj.p_info = JSON.stringify(obj2);

                    var ret = false;
                    $.ajax({async: false, url: "loop.planForm.editLoopInfoPlan.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var tables = $(".bootstrap-table");
                                for (var i = 0; i < tables.length; i++) {
                                    $(tables[i]).hide();
                                }
                                var index = parseInt(obj.p_type);
                                $(tables[index]).show();
                                $("#table" + obj.p_type).bootstrapTable('refresh');
                                ret = true;
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                return false;
            }

            function editloopplan() {
                var v = $(".bootstrap-table");
                var v0 = $(v[0]).css('display');
                var v1 = $(v[1]).css('display');
                var v2 = $(v[2]).css('display');
                var b = "";
                if (v0 == "block") {
                    b = "#table0";
                }
                if (v1 == "block") {
                    b = "#table1";
                }
                if (v2 == "block") {
                    b = "#table2";
                }
                var selects = $(b).bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请选择表格数据');  //请选择表格数据
                    return false;
                } else if (selects.length > 1) {
                    layerAler('只能编辑单行数据');  //只能编辑单行数据
                    return false;
                }
                var select = selects[0];
                var code = select.p_code;
                $("#hidden_id").val(select.id);
                $("#p_type2").combobox('readonly', true);
                $("#p_type2").combobox('select', select.p_type);

                if (select.p_type == "0") {
                    console.log('时间方式');
                    var obj1 = eval('(' + select.p_time1 + ')');
                    var obj2 = eval('(' + select.p_time2 + ')');
                    var obj3 = eval('(' + select.p_time3 + ')');
                    var obj4 = eval('(' + select.p_time4 + ')');
                    var obj5 = eval('(' + select.p_time5 + ')');

                    var ooo = [obj1, obj2, obj3, obj4, obj5];
                    $("#p_name1").val(select.p_name);
                    for (var i = 0; i < ooo.length; i++) {
                        var istr = (i + 1).toString();
                        var time = "#time" + istr + istr;
                        var val = "#timeval" + istr + istr;
                        $(time).timespinner('setValue', ooo[i].time);
                        $(val).val(ooo[i].value);
                    }


                } else if (select.p_type == "1") {
                    var obj1 = eval('(' + select.p_scene1 + ')');
                    var obj2 = eval('(' + select.p_scene2 + ')');
                    var obj3 = eval('(' + select.p_scene3 + ')');
                    var obj4 = eval('(' + select.p_scene4 + ')');
                    var obj5 = eval('(' + select.p_scene5 + ')');

                    var ooo = [obj1, obj2, obj3, obj4, obj5];
                    $("#p_name1").val(select.p_name);
                    for (var i = 0; i < ooo.length; i++) {
                        var istr = (i + 1).toString();
                        var scene = "#scen" + istr + istr;
                        var val = "#val" + istr + istr;
//                        $(scene).val(ooo[i].scene);
                        $(scene).combobox('setValue',ooo[i].scene.toString());
                        $(val).val(ooo[i].value);
                    }
                } else if (select.p_type == "2") {
                    var obj1 = eval('(' + select.p_info1 + ')');
                    var obj2 = eval('(' + select.p_info2 + ')');
                    var obj3 = eval('(' + select.p_info3 + ')');
                    var obj4 = eval('(' + select.p_info4 + ')');
                    var obj5 = eval('(' + select.p_info + ')');
//
                    var ooo = [obj1, obj2, obj3, obj4];
                    $("#p_name1").val(select.p_name);
                    for (var i = 0; i < ooo.length; i++) {
                        var istr = (i + 1).toString();
                        var info = "#info" + istr + istr;
                        var val = "#infoval" + istr + istr;
                        $(info).val(ooo[i].info);
                        $(val).val(ooo[i].value);
                    }
                    $("#infonum1").combobox('setValue', obj5.num);
                    $("#offset1").val(obj5.offset);

                }



                $('#dialog-edit').dialog('open');
                return false;

            }

            function deleteloopplan() {
                var v = $(".bootstrap-table");
                var v0 = $(v[0]).css('display');
                var v1 = $(v[1]).css('display');
                var v2 = $(v[2]).css('display');
                var b = "";
                if (v0 == "block") {
                    b = "#table0";
                }
                if (v1 == "block") {
                    b = "#table1";
                }
                if (v2 == "block") {
                    b = "#table2";
                }
                var selects = $(b).bootstrapTable('getSelections');

                layer.confirm('您确定要删除吗？', {//您确定要删除吗？
                    btn: ['确定', '取消按钮'], //确定、取消按钮
                    icon: 3,
                    offset: 'center',
                    title: '提示'   //提示
                }, function (index) {
                    addlogon(u_name, "删除", o_pid, "策略", "删除回路方案");
                    for (var i = 0; i < selects.length; i++) {
                        var select = selects[i];
                        $.ajax({async: false, url: "loop.planForm.deletePlan.action", type: "get", datatype: "JSON", data: {id: select.id},
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

            function checkPlanLoopAdd() {
                var obj = $("#formadd").serializeObject();
                var a = {};
                var ret = false;
                if (obj.p_type == "0") {
                    for (var i = 0; i < 5; i++) {
                        var ptimeval = "timeval" + (i + 1).toString();
                        var ptime = "time" + (i + 1).toString();
                        var timeval = obj[ptimeval];
                        var time = obj[ptime];
                        if (isNumber(timeval) == false) {
                            layerAler("控制值是一个数字 ");
                            return false;
                        }

                        var obj1 = {"time": time, "value": parseInt(timeval)};
                        var str = "p_time" + (i + 1).toString();
                        a[str] = JSON.stringify(obj1);
                    }

                    a.p_type = 0;
                    a.p_attr = 0;
                    a.pid = obj.pid;
                    a.p_name = obj.p_name;
                    console.log(a);
                    var ret = false;
                    $.ajax({async: false, url: "loop.planForm.addLoopTimePlan.action", type: "get", datatype: "JSON", data: a,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                } else if (obj.p_type == "1") {
                    for (var i = 0; i < 5; i++) {
                        var pscene = "scen" + (i + 1).toString();
                        var pval = "val" + (i + 1).toString();
                        var scene = obj[pscene];
                        var val = obj[pval];
                        if (isNumber(val) == false || isNumber(scene) == false) {
                            layerAler("场景与控制值是数字类型 ");
                            return false;
                        }

                        var obj1 = {"scene": parseInt(scene), "value": parseInt(val)};
                        var str = "p_scene" + (i + 1).toString();
                        a[str] = JSON.stringify(obj1);
                    }

                    a.p_type = 1;
                    a.p_attr = 0;
                    a.pid = obj.pid;
                    console.log(a);
                    var ret = false;
                    $.ajax({async: false, url: "loop.planForm.addLoopScenePlan.action", type: "get", datatype: "JSON", data: a,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });


                } else if (obj.p_type == "2") {


                    for (var i = 0; i < 4; i++) {
                        var pinfo = "info" + (i + 1).toString();
                        var pinfoval = "infoval" + (i + 1).toString();
                        var info = obj[pinfo];
                        var val = obj[pinfoval];
                        if (isNumber(info) == false || isNumber(val) == false) {
                            layerAler("信息点与控制值是数字类型 ");
                            return false;
                        }

                        var obj1 = {"info": parseInt(info), "value": parseInt(val)};
                        var str = "p_info" + (i + 1).toString();
                        a[str] = JSON.stringify(obj1);
                    }

                    var obj2 = {"num": parseInt(obj.infonum), "offset": parseInt(obj.offset)};
                    a.p_info = JSON.stringify(obj2);

                    a.p_type = 2;
                    a.p_attr = 0;
                    a.pid = obj.pid;
                    a.p_name = obj.p_name;
                    console.log(a);
                    var ret = false;
                    $.ajax({async: false, url: "loop.planForm.addLoopInfoPlan.action", type: "get", datatype: "JSON", data: a,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                ret = true;
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                return  ret;
            }

            var sceneninfo = {};
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
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
                                if (rs[i].code == "400101" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400102" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400103" && rs[i].enable != 0) {
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


                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 350,
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
                    height: 350,
                    position: "top",
                    buttons: {
                        修改: function () {

                            editsubmit();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });


                for (var i = 0; i < 5; i++) {
                    var ii = "#time" + (i + 1).toString();
                    $(ii).timespinner('setValue', '00:00');
                }

                $("#scentable").hide();
                $("#infotable").hide();
                $('#p_type').combobox({
                    onSelect: function (record) {
                        if (record.value == "0") {
                            $("#scentable").hide();
                            $("#infotable").hide();
                            $("#timetable").show();
                        }
                        if (record.value == "1")
                        {
                            $("#scentable").show();
                            $("#infotable").hide();
                            $("#timetable").hide();
                        } else if (record.value == "2") {
                            $("#scentable").hide();
                            $("#timetable").hide();
                            $("#infotable").show();
                            console.log("aaaaaaaaaaaa");

                        }
                    }
                });

                $('#p_type2').combobox({
                    onSelect: function (record) {
                        if (record.value == "0") {
                            $("#scentable1").hide();
                            $("#infotable1").hide();
                            $("#timetable1").show();
                        }
                        if (record.value == "1")
                        {
                            $("#scentable1").show();
                            $("#infotable1").hide();
                            $("#timetable1").hide();
                        } else if (record.value == "2") {
                            $("#scentable1").hide();
                            $("#timetable1").hide();
                            $("#infotable1").show();

                        }
                    }
                });


                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList.action", type: "get", datatype: "JSON", data: {},
                    success: function (data) {
                        $("#infonum").combobox('loadData', data);
                        $("#infonum1").combobox('loadData', data);
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });


                $.ajax({async: false, url: "sensor.planForm.getSensorPlanBynum1.action", type: "get", datatype: "JSON", data: {pid: "${param.pid}"},
                    success: function (data) {
                        console.log(data);
                       for(var i=0;i<5;i++){
                           var scen="#scen" + (i+1).toString();
                           var scen1="#scen" + (i+1).toString() + (i+1).toString();
                           $(scen).combobox('loadData',data);
                           $(scen1).combobox('loadData',data);
                        }
                        for (var i = 0; i < data.length; i++) {
                            var o = data[i];
                            sceneninfo[o.id] = o.text;
                        }
                        console.log(sceneninfo);
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });











                $('#table0').bootstrapTable({
                    url: 'loop.planForm.getPlanList.action',
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
                                title: '方案名称', //方案名称
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
//                            {
//                                field: 'p_code',
//                                title: '方案编码', //方案编码
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle',
//                                rowspan: 2,
//                                colspan: 1
//                            },
                            {
                                field: 'p_time',
                                title: '时间一', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间二', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间三', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间四', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间五', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_time1',
                                title: '时间', //时间
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
                                title: '控制值', //
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
                                title: '时间', //
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
                                title: '控制值', //
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
                                title: '时间', //
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
                                title: '控制值', //调光
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
                                title: '时间', //
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
                                title: '控制值', //调光控制值
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
                                title: '时间', //时间
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
                                title: '控制值', //调光控制控制值
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
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [20, 40, 80, 160, 320],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            p_attr: "0",
                            p_type: "0",
                            type_id: "1",
                            pid: "${param.pid}"   
                        };      
                        return temp;  
                    },
                });



                $('#table1').bootstrapTable({
                    url: 'loop.planForm.getPlanList.action',
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
                                title: '方案名称', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
//                            {
//                                field: 'p_code',
//                                title: '方案编号', //
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle',
//                                rowspan: 2,
//                                colspan: 1
//                            },
                            {
                                field: 'p_scene',
                                title: '场景一', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: '场景二', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: '场景三', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: '场景四', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_scene',
                                title: '场景五', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_scene1',
                                title: '场景号', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');

                                        return obj.scene;
                                    }

                                }
                            },
                            {
                                field: 'p_val1',
                                title: '控制值', //调光控制控制值
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
                                title: '场景号', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.scene;
                                    }

                                }
                            },
                            {
                                field: 'p_val2',
                                title: '控制值', //调光控制控制值
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
                                title: '场景号', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.scene;
                                    }

                                }
                            },
                            {
                                field: 'p_val3',
                                title: '控制值', //调光控制控制值
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
                                title: '场景号', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.scene;
                                    }

                                }
                            },
                            {
                                field: 'p_val4',
                                title: '控制值', //调光控制控制值
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
                                title: '场景号', //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.scene;
                                    }

                                }
                            },
                            {
                                field: 'p_val5',
                                title: '控制值', //调光控制控制值
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
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [10, 20, 40, 80, 160],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            p_attr: 0,
                            p_type: 1,
                            type_id: "1",
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
                });


                $('#table2').bootstrapTable({
                    url: 'loop.planForm.getPlanList.action',
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
                                title: '方案名称', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
//                            {
//                                field: 'p_code',
//                                title: '方案编号', //
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle',
//                                rowspan: 2,
//                                colspan: 1
//                            },
                            {
                                field: 'p_infonum',
                                title: '信息点号', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_infonum',
                                title: '一', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_infonum',
                                title: '二', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_infonum',
                                title: '三', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_infonum',
                                title: '四', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_info',
                                title: '信息点', //场景号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(value)) {

                                        var obj = eval('(' + value + ')');
                                        return obj.num.toString();
                                    }

                                }
                            },
                            {
                                field: 'p_info',
                                title: '偏差值', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        if (obj.offset != null) {
                                            return obj.offset.toString();
                                        }
                                    }
                                }
                            },
                            {
                                field: 'p_info1',
                                title: '数值', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.info;
                                    }

                                }
                            },
                            {
                                field: 'p_val1',
                                title: '控制值', //调光控制控制值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_info1)) {
                                        var obj = eval('(' + row.p_info1 + ')');
                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }

                            }, {
                                field: 'p_info2',
                                title: '数值', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.info;
                                    }

                                }
                            },
                            {
                                field: 'p_val2',
                                title: '控制值', //调光控制控制值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_info2)) {
                                        var obj = eval('(' + row.p_info2 + ')');
                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_info3',
                                title: '数值', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.info;
                                    }

                                }
                            },
                            {
                                field: 'p_val3',
                                title: '控制值', //调光控制控制值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_info3)) {
                                        var obj = eval('(' + row.p_info3 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {

                                field: 'p_info4',
                                title: '数值', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.info;
                                    }
                                }
                            },
                            {
                                field: 'p_val4',
                                title: '控制值', //调光控制控制值
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_info4)) {
                                        var obj = eval('(' + row.p_info4 + ')');
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
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [10, 20, 40, 80, 160],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            p_attr: 0,
                            p_type: 2,
                            type_id: "1",
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
                });


                var tables = $(".bootstrap-table");
                for (var i = 0; i < tables.length; i++) {
                    $(tables[i]).hide();
                    if (i == 0) {
                        $(tables[i]).show();
                    }
                }







                $("#p_type_query").combobox({
                    onSelect: function (record) {
                        var v = $(".bootstrap-table");
                        for (var i = 0; i < v.length; i++) {
                            $(v[i]).hide();
                        }
                        var index = parseInt(record.value);
                        console.log(index);
                        $(v[index]).show();

                    }
                })
            })

        </script>

    </head>

    <body>

        <div class="btn-group zuheanniu" id="btn_add" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <!-- data-toggle="modal" data-target="#pjj" -->
            <button class="btn btn-success ctrol" onclick="showDialog()" data-toggle="modal" data-target="#modal_add22" id="add" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <!--添加-->
                <span >添加</span>
            </button>
            <button class="btn btn-primary ctrol" type="button"   onclick="editloopplan();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;
                <!--编辑-->
                <span >编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteloopplan();" id="del">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;
                <!--删除-->
                <span >删除</span>
            </button>

            <span style="margin-left:20px;">
                <!--方案类型-->
                <span >方案类型</span>
                &nbsp;</span>
            <span class="menuBox">

                <select class="easyui-combobox" data-options="editable:false" id="p_type_query" name="p_type_query" style="width:150px; height: 30px">
                    <option value="0"> 时间</option>
                    <option value="1">场景</option>    
                    <option value="2">信息点</option>  
                </select>
            </span>  

        </div>

        <div class="clearfix"></div>
        <!--        <div class="bootstrap-table">
                    <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">-->
        <!--        <table id="table_loop" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table> -->

        <table id="table0" style="width:100%; " class="text-nowrap table table-hover table-striped">
        </table> 
        <table id="table1" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>  
        <table id="table2" style="width:100%; " class="text-nowrap table table-hover table-striped">
        </table> 

        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="回路方案添加">
            <form action="" method="POST" id="formadd" onsubmit="return checkPlanLoopAdd()">      
                <input type="hidden" name="pid" value="${param.pid}"/>
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">
                                    <!--方案类型-->
                                    <span id="68" name="xxx">方案类型</span>
                                    &nbsp;</span>
                                <span class="menuBox">
                                    <select class="easyui-combobox" data-options="editable:false" id="p_type" name="p_type" style="width:150px; height: 30px">
                                        <option value="0">时间</option>
                                        <option value="1">场景</option>     
                                        <option value="2">信息点</option> 
                                    </select>
                                </span>  
                            </td>
                            <td></td>
                            <td>
                                <!--方案名称-->
                                <span style="margin-left:20px;" >方案名称</span>&nbsp;
                                <input id="p_name" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                            </td>
                        </tr>
                    </tbody>
                </table>
                <p>
                <table id="timetable">
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间一</span>&nbsp;
                                <input id="time1" name="time1" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值一</span>&nbsp;
                                <input id="timeval1" class="form-control"  name="timeval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间二</span>&nbsp;
                                <input id="time2" name="time2" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值二</span>&nbsp;
                                <input id="timeval2" class="form-control"  name="timeval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间三</span>&nbsp;
                                <input id="time3" name="time3" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值三</span>&nbsp;
                                <input id="timeval3" class="form-control"  name="timeval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间四</span>&nbsp;
                                <input id="time4" name="time4" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值四</span>&nbsp;
                                <input id="timeval4" class="form-control"  name="timeval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间五</span>&nbsp;
                                <input id="time5" name="time5" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值五</span>&nbsp;
                                <input id="timeval5" class="form-control"  name="timeval5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>                        


                    </tbody>
                </table>
                <table id="scentable" >
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景一</span>&nbsp;
                                <!--<input id="scen1" class="form-control"  name="scen1" style="width:50px;display: inline;" placeholder="场景1" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen1" name="scen1" style="width:100px; height: 30px">
                                </select>                               

                                <span style="margin-left:10px;">控制值一</span>&nbsp;
                                <input id="val1" class="form-control"  name="val1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景二</span>&nbsp;
                                <!--<input id="scen2" class="form-control"  name="scen2" style="width:50px;display: inline;" placeholder="场景2" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen2" name="scen2" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;"  >控制值二</span>&nbsp;
                                <input id="val2" class="form-control"  name="val2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                            </td>
                        </tr>

                        <tr id="">
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景三</span>&nbsp;
                                <!--<input id="scen3" class="form-control"  name="scen3" style="width:50px;display: inline;" placeholder="场景3" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen3" name="scen3" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;">控制值三</span>&nbsp;
                                <input id="val3" class="form-control"  name="val3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景四</span>&nbsp;
                                <!--<input id="scen4" class="form-control"  name="scen4" style="width:50px;display: inline;" placeholder="场景4" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen4" name="scen4" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;"  >控制值四</span>&nbsp;
                                <input id="val4" class="form-control"  name="val4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                            </td>
                        </tr>

                        <tr id="">
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景五</span>&nbsp;
                                <!--<input id="scen5" class="form-control"  name="scen5" style="width:50px;display: inline;" placeholder="场景5" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen5" name="scen5" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;">控制值五</span>&nbsp;
                                <input id="val5" class="form-control"  name="val5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>
                    </tbody>
                </table>
                <table id="infotable">
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >信息点号</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infonum" name="infonum" style="width:70px; height: 30px">
                                </select>
                                <span style="margin-left:10px;">偏差值</span>&nbsp;
                                <input id="offset" class="form-control"  name="offset" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info1" name="info1" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info1" name="info1" style="width:70px; height: 30px">
                                                                     <input id="infoval1" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval1" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info2" name="info2" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info2" name="info2" style="width:70px; height: 30px">
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval2" class="form-control"  name="infoval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info3" name="info3" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info3" name="info3" style="width:70px; height: 30px">
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval3" class="form-control"  name="infoval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info4" name="info4" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info4" name="info4" style="width:70px; height: 30px">
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval4" class="form-control"  name="infoval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                            </td>
                        </tr>                      



                    </tbody>
                </table>
            </form>      
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="回路方案修改">

            <form action="" method="POST" id="form2" >  
                <input type="hidden" name="pid" value="${param.pid}"/>
                <input type="hidden" id="hidden_id" name="id" />
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">
                                    <!--方案类型-->
                                    方案类型
                                    &nbsp;</span>
                                <span class="menuBox">
                                    <select class="easyui-combobox" data-options="editable:false" id="p_type2" name="p_type" style="width:150px; height: 30px">
                                        <option value="0">时间</option>
                                        <option value="1">场景</option>     
                                        <option value="2">信息点</option> 
                                    </select>
                                </span>  
                            </td>
                            <td></td>
                            <td>
                                <!--方案名称-->
                                <span style="margin-left:20px;" >方案名称</span>&nbsp;
                                <input id="p_name1" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                            </td>
                        </tr>
                    </tbody>
                </table>
                <p>
                <table id="timetable1">
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间一</span>&nbsp;
                                <input id="time11" name="time1" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值一</span>&nbsp;
                                <input id="timeval11" class="form-control"  name="timeval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间二</span>&nbsp;
                                <input id="time22" name="time2" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值二</span>&nbsp;
                                <input id="timeval22" class="form-control"  name="timeval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间三</span>&nbsp;
                                <input id="time33" name="time3" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值三</span>&nbsp;
                                <input id="timeval33" class="form-control"  name="timeval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间四</span>&nbsp;
                                <input id="time44" name="time4" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值四</span>&nbsp;
                                <input id="timeval44" class="form-control"  name="timeval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;时间五</span>&nbsp;
                                <input id="time55" name="time5" style=" height: 28px; width: 75px;  "  class="easyui-timespinner">
                                <span style="margin-left:5px;">控制值五</span>&nbsp;
                                <input id="timeval55" class="form-control"  name="timeval5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>                        


                    </tbody>
                </table>
                <table id="scentable1" >
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景一</span>&nbsp;
                                <!--<input id="scen11" class="form-control"  name="scen1" style="width:50px;display: inline;" placeholder="场景1" type="text" />-->

                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen11" name="scen1" style="width:100px; height: 30px">
                                </select>  

                                <span style="margin-left:10px;">控制值一</span>&nbsp;
                                <input id="val11" class="form-control"  name="val1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景二</span>&nbsp;
                                <!--<input id="scen22" class="form-control"  name="scen2" style="width:50px;display: inline;" placeholder="场景2" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen22" name="scen2" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;"  >控制值二</span>&nbsp;
                                <input id="val22" class="form-control"  name="val2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                            </td>
                        </tr>

                        <tr id="">
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景三</span>&nbsp;
                                <!--<input id="scen33" class="form-control"  name="scen3" style="width:50px;display: inline;" placeholder="场景3" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen33" name="scen3" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;">控制值三</span>&nbsp;
                                <input id="val33" class="form-control"  name="val3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景四</span>&nbsp;
                                <!--<input id="scen44" class="form-control"  name="scen4" style="width:50px;display: inline;" placeholder="场景4" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen44" name="scen4" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;"  >控制值四</span>&nbsp;
                                <input id="val44" class="form-control"  name="val4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                            </td>
                        </tr>

                        <tr id="">
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景五</span>&nbsp;
                                <!--<input id="scen55" class="form-control"  name="scen5" style="width:50px;display: inline;" placeholder="场景5" type="text" />-->
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen55" name="scen5" style="width:100px; height: 30px">
                                </select>  
                                <span style="margin-left:10px;">控制值五</span>&nbsp;
                                <input id="val55" class="form-control"  name="val5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>
                    </tbody>
                </table>
                <table id="infotable1">
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >信息点号</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infonum1" name="infonum" style="width:70px; height: 30px">
                                </select>
                                <span style="margin-left:10px;">偏差值</span>&nbsp;
                                <input id="offset1" class="form-control"  name="offset" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info11" name="info1" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info1" name="info1" style="width:70px; height: 30px">
                                                                     <input id="infoval1" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval11" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info22" name="info2" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info2" name="info2" style="width:70px; height: 30px">
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval22" class="form-control"  name="infoval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info33" name="info3" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info3" name="info3" style="width:70px; height: 30px">
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval33" class="form-control"  name="infoval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                <input  class="form-control" id="info44" name="info4" style="width:70px;display: inline;" placeholder="值" type="text" />
                                <!--                                <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info4" name="info4" style="width:70px; height: 30px">
                                                                </select>-->
                                <span style="margin-left:10px;">控制值</span>&nbsp;
                                <input id="infoval44" class="form-control"  name="infoval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                            </td>
                        </tr>                      
                    </tbody>
                </table>        
            </form>
        </div>








    </body>
</html>