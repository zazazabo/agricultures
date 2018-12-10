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



                $("#p_name1").val("");
                $('#dialog-add').dialog('open');
                return false;
            }


            function addscenPlan() {
                var ooo = $("#formadd").serializeObject();
                ooo.p_attr = 1;
                for (var i = 0; i < 5; i++) {
                    var ii = (i + 1).toString();
                    var info = "info" + ii;
                    var up = "up" + ii;
                    var down = "down" + ii;
                    var p_scene = "p_scene" + ii;



                    if (isNumber(ooo[info]) == false) {

                        layerAler("信息点号必须是数字");
                        return false;
                    }

                    if (isNumber(ooo[up]) == false) {

                        layerAler("上限值必须是数字");
                        return false;
                    }

                    if (isNumber(ooo[down]) == false) {

                        layerAler("下限值必须是数字");
                        return false;
                    }
                    var iinfo = parseInt(ooo[info]);
                    var iup = parseInt(ooo[up]);
                    var idown = parseInt(ooo[down]);
                    var o3 = {info: iinfo, up: iup, down: idown};
                    ooo[p_scene] = JSON.stringify(o3);

                }

                $.ajax({async: false, url: "sensor.planForm.addSensorScenePlan.action", type: "get", datatype: "JSON", data: ooo,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {

                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

            }


            function editscenPlan_finish() {
                var a = $("#form2").serializeObject();
                addlogon(u_name, "修改", o_pid, "传感器场景策略", "修改传感器场景方案");
       
                var ooo = $("#form2").serializeObject();
                for (var i = 0; i < 5; i++) {
                    var ii = (i + 1).toString();
                    var info = "info" + ii;
                    var up = "up" + ii;
                    var down = "down" + ii;
                    var p_scene = "p_scene" + ii;



                    if (isNumber(ooo[info]) == false) {

                        layerAler("信息点号必须是数字");
                        return false;
                    }

                    if (isNumber(ooo[up]) == false) {

                        layerAler("上限值必须是数字");
                        return false;
                    }

                    if (isNumber(ooo[down]) == false) {

                        layerAler("下限值必须是数字");
                        return false;
                    }
                    var iinfo = parseInt(ooo[info]);
                    var iup = parseInt(ooo[up]);
                    var idown = parseInt(ooo[down]);
                    var o3 = {info: iinfo, up: iup, down: idown};
                    ooo[p_scene] = JSON.stringify(o3);

                }

                $.ajax({async: false, url: "sensor.planForm.editSensorScenePlan.action", type: "get", datatype: "JSON", data: ooo,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            $("#table0").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });










                    //sensor.planForm.editSensorScenePlan.action
                
                return false;

            }

            function editscenPlan() {

                var selects = $("#table0").bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请选择表格数据');  //请选择表格数据
                    return false;
                } else if (selects.length > 1) {
                    layerAler('只能编辑单行数据');  //只能编辑单行数据
                    return false;
                }
                var select = selects[0];
                console.log(select);
                // var code = select.p_code;

                 $("#p_name1").val(select.p_name);
                  $("#hidden_id").val(select.id);
                  $("#p_scenenum1").combobox('setValue',select.p_scenenum);
                 if (select.p_type == "1") {

               for (var i = 0; i < 5; i++) {
                        var index= (i+1).toString();
                        var scene="p_scene" + (i+1).toString();
                        var val=select[scene];
                        var obj = eval('(' + val + ')');   

                       $("#info" + index + index).combobox('setValue',obj.info.toString());
                        $("#up" + index + index).spinner("setValue",obj.up.toString()); 
                        $("#down" + index + index).spinner("setValue",obj.down.toString());    
                    
                   }

                 }
                $('#dialog-edit').dialog('open');
                return false;
                //$("#MODAL_EDIT").modal();
            }

            function deleteplan() {

                var selects = $("#table0").bootstrapTable('getSelections');
                if (selects.length==0) {
                    layerAler("请选择表格数据");
                    return;
                }
                var select = selects[0];

                layer.confirm('您确定要删除吗？', {//您确定要删除吗？
                    btn: ['确定', '取消按钮'], //确定、取消按钮
                    icon: 3,
                    offset: 'center',
                    title: '提示'   //提示
                }, function (index) {

                        $.ajax({async: false, url: "loop.planForm.deletePlan.action", type: "get", datatype: "JSON", data: {id: select.id},
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    $("#table0").bootstrapTable('refresh');
                                }

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    
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
                            editscenPlan_finish();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });



                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList.action", type: "get", datatype: "JSON", data: {},
                    success: function (data) {
                        for (var i = 0; i < 10; i++) {
                            $("#info" + (i + 1).toString()).combobox('loadData', data);
                            $("#info" + (i + 1).toString() + (i + 1).toString()).combobox('loadData', data);

                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });




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

                for (var i = 0; i < 10; i++) {
                    var up = "#up" + (i + 1).toString();
                    var up1 = "#up" + (i + 1).toString() + (i + 1).toString();
                    var down = "#down" + (i + 1).toString();
                    var down1 = "#down" + (i + 1).toString() + (i + 1).toString();
                    $(up).numberspinner({
                        min: 0,
                        max: 10000,
                        icrement: 1,
                        editable: true
                    })
                    $(up1).numberspinner({
                        min: 0,
                        max: 10000,
                        icrement: 1,
                        editable: true
                    })
                    $(down).numberspinner({
                        min: 0,
                        max: 10000,
                        icrement: 1,
                        editable: true
                    })

                    $(down1).numberspinner({
                        min: 0,
                        max: 10000,
                        icrement: 1,
                        editable: true
                    })
                }


                $('#table0').bootstrapTable({
                    url: 'loop.planForm.getLoopPlan.action',
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
                            {
                                field: 'p_code',
                                title: '方案编号', //方案编号
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_scene',
                                title: '场景', //
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 15,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_scene',
                                title: '信息点1', //信息点
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(row.p_scene1)) {
                                        var obj = eval('(' + row.p_scene1 + ')');
                                        var str = "信息点号:" + obj.info.toString() + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                        return str;
                                    }
                                }
                            }, {
                                field: 'p_scene',
                                title: '信息点2', //信息点
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(row.p_scene2)) {
                                        var obj = eval('(' + row.p_scene2 + ')');
                                        var str = "信息点号:" + obj.info.toString() + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                        return str;
                                    }
                                }
                            }, {
                                field: 'p_scene',
                                title: '信息点3', //信息点
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(row.p_scene3)) {
                                        var obj = eval('(' + row.p_scene3 + ')');
                                        var str = "信息点号:" + obj.info.toString() + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                        return str;
                                    }
                                }
                            }, {
                                field: 'p_scene',
                                title: '信息点4', //信息点
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(row.p_scene4)) {
                                        var obj = eval('(' + row.p_scene4 + ')');
                                        var str = "信息点号:" + obj.info.toString() + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                        return str;
                                    }
                                }
                            }, {
                                field: 'p_scene',
                                title: '信息点5', //信息点
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    if (isJSON(row.p_scene5)) {
                                        var obj = eval('(' + row.p_scene5 + ')');
                                        var str = "信息点号:" + obj.info.toString() + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                        return str;
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



    </head>

    <body>


        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" onclick="showDialog()" data-target="#modal_add1" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <span name="xxx" id="65">添加</span>
            </button>
            <button class="btn btn-primary ctrol"   onclick="editscenPlan()"  id="update">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;
                <span name="xxx" id="66">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteplan();" id="del" >
                <span class="glyphicon glyphicon-trash"></span>&nbsp;
                <span name="xxx" id="67">删除</span>
            </button>
<!--             <span style="margin-left:20px;" name="xxx" id="68">方案类型</span>&nbsp;
            <span class="menuBox">
                <select class="easyui-combobox" data-options="editable:false" id="p_type" name="p_type" style="width:150px; height: 30px; margin-left: 3px;">
                    <option value="1">场景</option>           
                </select>
            </span>  -->
        </div>

        <table id="table0" style="width:100%; " class="text-nowrap table table-hover table-striped">
        </table> 


        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="场景方案添加">

            <form action="" method="POST" id="formadd" onsubmit="return addscenPlan()">      
                <input type="hidden" name="pid" value="${param.pid}"/>

                <input type="hidden" name="p_type" value="1"/>
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span >&nbsp;&nbsp;&nbsp;
                                    方案名称
                                </span>&nbsp;
                                <input id="p_name" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td> 
                            </td>
                            <td></td>
                            <td>
  <!--                                  <span style="margin-left: 20px;" >
                                    场景号
                                </span>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="p_scenenum" name="p_scenenum" style="width:70px; height: 30px">
                                            <option value="0">0</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                            <option value="8">8</option>
                                            <option value="9">9</option>
                                </select> -->
                            </td>
                        </tr>


                    </tbody>
                </table>

                <table id="scentable" style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center" >
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号一</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info1" name="info1" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up1" style="width:100px; height: 30px;" value="0" name="up1">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down1" style="width:100px; height: 30px;" value="0" name="down1">&emsp;
                            </td>

                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号二</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info2" name="info2" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up2" style="width:100px; height: 30px;" value="0" name="up2">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down2" style="width:100px; height: 30px;" value="0" name="down2">
                            </td>


                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号三</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info3" name="info3" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up3" style="width:100px; height: 30px;" value="0" name="up3">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down3" style="width:100px; height: 30px;" value="0" name="down3">
                            </td>


                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号四</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info4" name="info4" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up4" style="width:100px; height: 30px;" value="0" name="up4">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down4" style="width:100px; height: 30px;" value="0" name="down4">
                            </td>

                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号五</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info5" name="info5" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up5" style="width:100px; height: 30px;" value="0" name="up5">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down5" style="width:100px; height: 30px;" value="0" name="down5">
                            </td>

                        </tr>
                    </tbody>
                </table>

            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="场景方案修改">
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hidden_id" name="id">  
                <input type="hidden" name="pid" value="${param.pid}"/>
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span >&nbsp;&nbsp;&nbsp;
                                    方案名称
                                </span>&nbsp;
                                <input id="p_name1" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td> 
                            </td>
                            <td></td>
                            <td>
<!--                                 <span style="margin-left: 20px;"  >
                                    场景号
                                </span>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="p_scenenum1" name="p_scenenum" style="width:70px; height: 30px">
                                            <option value="0">0</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                            <option value="8">8</option>
                                            <option value="9">9</option>
                                </select> -->
                            </td>
                        </tr>


                    </tbody>
                </table>
                <table id="scentable" style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center" >
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号一</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info11" name="info1" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up11" style="width:100px; height: 30px;" value="0" name="up1">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down11" style="width:100px; height: 30px;" value="0" name="down1">&emsp;
                            </td>

                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号二</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info22" name="info2" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up22" style="width:100px; height: 30px;" value="0" name="up2">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down22" style="width:100px; height: 30px;" value="0" name="down2">
                            </td>


                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号三</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info33" name="info3" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up33" style="width:100px; height: 30px;" value="0" name="up3">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down33" style="width:100px; height: 30px;" value="0" name="down3">
                            </td>


                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号四</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info44" name="info4" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up44" style="width:100px; height: 30px;" value="0" name="up4">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down44" style="width:100px; height: 30px;" value="0" name="down4">
                            </td>

                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号五</span>&nbsp;
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info55" name="info5" style="width:100px; height: 30px">
                                </select>
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up55" style="width:100px; height: 30px;" value="0" name="up5">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down55" style="width:100px; height: 30px;" value="0" name="down5">
                            </td>

                        </tr>
                    </tbody>
                </table>

            </form>
        </div>


    </body>
</html>