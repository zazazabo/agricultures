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
                obj.p_Longitude = obj.longitudem26d + "." + obj.longitudem26m + "." + obj.longitudem26s;
                obj.p_latitude = obj.latitudem26d + "." + obj.latitudem26m + "." + obj.latitudem26s;
                var url = "";
                if (obj.p_type == "0") {
                    url = "loop.planForm.editlooptime.action";
                }
                if (obj.p_type == "1") {
                    url = "loop.planForm.editloopjw.action";
                }

                $.ajax({async: false, url: url, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            addlogon(u_name, "修改", o_pid, "回路策略", "修改回路方案");
                            var url = "loop.planForm.getLoopPlan.action";
                            var obj1 = {p_type: obj.p_type, pid: "${param.pid}"};
                            var opt = {url: url, silent: true, query: obj1};
                            $("#table_loop").bootstrapTable('refresh', opt);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            function editloopplan() {
                var selects = $('#table_loop').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);//请选择表格数据
                    return false;
                } else if (selects.length > 1) {
                    layerAler(langs1[74][lang]); //只能编辑单行数据
                    return false;
                }


                $("#p_type_").combobox('readonly', true);

//
                var select = selects[0];
                console.log(select);
                $("#p_name_").val(select.p_name);
                $('#p_intime_').timespinner('setValue', select.p_intime);
                $('#p_outtime_').timespinner('setValue', select.p_outtime);
                $("#hidden_id").val(select.id);
                if (select.p_type == "0") {
                    $("#tr_time_hide").show();
                    $("#tr_scene_hide").hide();
                    $('#p_type_').combobox('select', '0');

                } else if (select.p_type == "1") {
                    $("#tr_time_hide").hide();
                    $("#tr_scene_hide").show();
                    $('#p_type_').combobox('select', "1");
                    var long = select.p_Longitude;
                    var lati = select.p_latitude;
                    var l1 = long.split(".");
                    var l2 = lati.split(".");
                    $("#longitudem26d_").val(l1[0]);
                    $("#longitudem26m_").val(l1[1]);
                    $("#longitudem26s_").val(l1[2]);

                    $("#latitudem26d_").val(l2[0]);
                    $("#latitudem26m_").val(l2[1]);
                    $("#latitudem26s_").val(l2[2]);


                }
                $('#dialog-edit').dialog('open');
                return false;
//                $("#modal_plan_loop").modal();

            }

            function deleteloopplan() {
                var selects = $('#table_loop').bootstrapTable('getSelections');
                for (var i = 0; i < selects.length; i++) {
                    var select = selects[i];
                    var code = select.p_code;
                    $.ajax({async: false, url: "loop.planForm.deleteloop.action", type: "get", datatype: "JSON", data: {id: select.id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                addlogon(u_name, "删除", o_pid, "回路策略", "删除回路方案");
                                $('#table_loop').bootstrapTable('refresh');
                            }

                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
            }

            function checkPlanLoopAdd() {
                var obj = $("#formadd").serializeObject();
                obj.p_Longitude = obj.longitudem26m + "." + obj.longitudem26s + "." + obj.latitudem26d;
                obj.p_latitude = obj.latitudem26d + "." + obj.latitudem26m + "." + obj.latitudem26s;
                var url = "";
                if (obj.p_type == 1) {

                    if (obj.longitudem26m == "" || obj.longitudem26s == "" || obj.latitudem26d == "") {
                        layerAler("经度不能为空");
                        return;
                    }

                    if (obj.latitudem26d == "" || obj.latitudem26m == "" || obj.latitudem26s == "") {
                        layerAler("纬度不能为空");
                        return;
                    }
                    url = "loop.planForm.addloopjw.action";
                }
                if (obj.p_type == 0) {
                    if (obj.p_intime == "" || obj.p_outtime == "") {
                        layerAler("断开和闭合时间不能为空");
                        return false;
                    }
                    url = "loop.planForm.addlooptime.action";
                }
                console.log("表单对象", obj);
                var ret = false;
                addlogon(u_name, "添加", o_pid, "回路策略", "添加回路方案");
                $.ajax({async: false, url: url, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            ret = false;
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
//                return ret;
            }

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
                    width: 600,
                    height: 450,
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
                    width: 600,
                    height: 250,
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







//                $('#intime').timespinner('setValue', '00:00');
//                $('#outtime').timespinner('setValue', '23:00');


                $("#scenetype").hide();

                $('#p_type').combobox({
                    onSelect: function (record) {
                        if (record.value == "0") {
                            $("#tr_scene_hide_add").hide();
                            $("#tr_time_hide_add").show();
                        }
                        if (record.value == "1")
                        {
                            $("#tr_scene_hide_add").show();
                            $("#tr_time_hide_add").hide();
                        }
                        console.log(record);
                    }
                });


                $("#p_type_query").combobox({
                    onSelect: function (record) {
                        var url = "loop.planForm.getLoopPlan.action";
                        var obj = {p_type: record.value};
                        var opt = {
                            url: url,
                            silent: true,
                            query: obj
                        };

                        $("#table_loop").bootstrapTable('refresh', opt);


//                        if (record.value == "0") {
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_Longitude');
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_latitude');
//                            $("#table_loop").bootstrapTable('showColumn', 'p_outtime');
//                            $("#table_loop").bootstrapTable('showColumn', 'p_intime');
//                        }
//                        if (record.value == "1")
//                        {
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_outtime');
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_intime');
//
//                            $("#table_loop").bootstrapTable('showColumn', 'p_Longitude');
//                            $("#table_loop").bootstrapTable('showColumn', 'p_latitude');
//                        }
//                        console.log(record);
                    }
                })
                $("#p_type_query").combobox('select', '0');
                var p_type = $("#p_type_query").combobox('getValue');
//                console.log(p_type);
                var url = "loop.planForm.getLoopPlan.action";
                $('#table_loop').bootstrapTable({
                    url: url,
                    clickToSelect: true,
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
                            field: 'p_name',
                            title: langs1[69][lang], //方案名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_code',
                            title: langs1[70][lang], //方案编号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_intime',
                            title: langs1[71][lang], //闭合时间
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_outtime',
                            title: langs1[72][lang], //断开时间
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
//                        {
//                            field: 'p_Longitude',
//                            title: '经度',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'p_latitude',
//                            title: '纬度',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }
                        {
                            field: 'p_attr',
                            title: langs1[68][lang], //方案类型
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.p_type == "0") {
                                    return "时间方案";
                                } else if (row.p_type == "1") {
                                    return "经纬度方案";
                                }

                            }
                        }],
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
                            type_id: "1",
                            p_attr: "0",
                            p_type: p_type,
                            pid: "${param.pid}"
                        };      
                        return temp;  
                    },
                });
            })

        </script>

    </head>

    <body>

        <div class="btn-group zuheanniu" id="btn_add" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <!-- data-toggle="modal" data-target="#pjj" -->
            <button class="btn btn-success ctrol" onclick="showDialog()" data-toggle="modal" data-target="#modal_add22" id="add" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <!--添加-->
                <span id="65" name="xxx">添加</span>
            </button>
            <button class="btn btn-primary ctrol" type="button"   onclick="editloopplan();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;
                <!--编辑-->
                <span id="66" name="xxx">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteloopplan();" id="del">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;
                <!--删除-->
                <span id="67" name="xxx">删除</span>
            </button>

            <span style="margin-left:20px;">
                <!--方案类型-->
                <span id="68" name="xxx">方案类型</span>
                &nbsp;</span>
            <span class="menuBox">

                <select class="easyui-combobox" data-options="editable:false" id="p_type_query" name="p_type_query" style="width:150px; height: 30px">
                    <option value="0"> 时间</option>
                    <!--<option value="1">经纬度</option>-->           
                </select>

                <!--                <select name="p_type_query" id="p_type_query" class="input-sm" style="width:150px;">
                                    <option value="0">时间</option>
                                    <option value="1">经纬度</option>
                                </select>-->
            </span>  

        </div>
        <!--        <div class="bootstrap-table">
                    <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">-->
        <table id="table_loop" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table> 
        <!--            </div>
                </div>-->


        <!--</div>-->




        <!-- 添加 -->


        <!--修改回路方案-->


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
                                <span style="margin-left:20px;" id="69" name="xxx">方案名称</span>&nbsp;
                                <input id="p_name" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                            </td>
                        </tr>
                    </tbody>
                </table>
                <table id="timetable">
                    <tbody>

                        <tr >
                            <td>
                                闭合时间
                                <span style="margin-left:20px;" >闭合时间</span>&nbsp;
                                <input id="intime" class="form-control"  name="intime" style="width:150px;display: inline;" placeholder="请输入闭合时间" type="text">
                                <input id="intime" name="p_intime" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                            </td>
                            <td></td>
                            <td>
                                断开时间
                                <span style="margin-left:20px;" >断开时间</span>&nbsp;
                                <input id="outtime" name="p_outtime" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                            </td>
                            </td>
                        </tr>                                   

                    </tbody>
                </table>
                <table scentable>
                    <tbody>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景一</span>&nbsp;
                                <input id="scen1" class="form-control"  name="scen1" style="width:50px;display: inline;" placeholder="场景1" type="text" />
                                <span style="margin-left:10px;">值一</span>&nbsp;
                                <input id="val1" class="form-control"  name="val1" style="width:50px;display: inline;" placeholder="值1" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景二</span>&nbsp;
                                <input id="scen2" class="form-control"  name="scen2" style="width:50px;display: inline;" placeholder="场景2" type="text" />
                                <span style="margin-left:10px;"  >值二</span>&nbsp;
                                <input id="val2" class="form-control"  name="val2" style="width:50px;display: inline;" placeholder="值2" type="text" />
                            </td>
                        </tr>

                        <tr id="">
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景三</span>&nbsp;
                                <input id="scen3" class="form-control"  name="scen3" style="width:50px;display: inline;" placeholder="场景3" type="text" />
                                <span style="margin-left:10px;">值三</span>&nbsp;
                                <input id="val3" class="form-control"  name="val3" style="width:50px;display: inline;" placeholder="值3" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景四</span>&nbsp;
                                <input id="scen4" class="form-control"  name="scen4" style="width:50px;display: inline;" placeholder="场景4" type="text" />
                                <span style="margin-left:10px;"  >值四</span>&nbsp;
                                <input id="val4" class="form-control"  name="val4" style="width:50px;display: inline;" placeholder="值4" type="text" />
                            </td>
                        </tr>

                        <tr id="">
                            <td>
                                <span style="margin-left:20px;" >&emsp;场景五</span>&nbsp;
                                <input id="scen5" class="form-control"  name="scen5" style="width:50px;display: inline;" placeholder="场景5" type="text" />
                                <span style="margin-left:10px;">值五</span>&nbsp;
                                <input id="val5" class="form-control"  name="val5" style="width:50px;display: inline;" placeholder="值5" type="text" />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>      
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="回路方案修改">
            <input type="hidden" name="pid" value="${param.pid}"/>
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hidden_id" name="id" />
                <input type="hidden" id="p_code"  />
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">
                                    <!--方案类型-->
                                    <span id="68" name="xxx">方案类型</span>
                                    &nbsp;</span>
                                <span class="menuBox">


                                    <select class="easyui-combobox" data-options="editable:false" id="p_type_" name="p_type" style="width:150px; height: 34px">
                                        <option value="0">时间</option>
                                        <option value="1">经纬度</option>           
                                    </select>

                                </span>  
                            </td>
                            <td></td>
                            <td>
                                <!--方案名称-->
                                <span style="margin-left:20px;" id="69" name="xxx">方案名称</span>&nbsp;
                                <input id="p_name_" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                            </td>
                        </tr>

                        <tr id="tr_time_hide">
                            <td>
                                <span style="margin-left:20px;" id="71" name="xxx"></span>&nbsp;
                                <!--<input id="intime_edit" class="form-control"  name="intime_edit" style="width:150px;display: inline;" placeholder="请输入闭合时间" type="text">-->
                                <input id="p_intime_" name="p_intime" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">

                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;" id="72" name="xxx"></span>&nbsp;
                                <!--<input id="outtime_edit" class="form-control" name="outtime_edit" style="width:150px;display: inline;" placeholder="请输入断开时间" type="text">-->
                                <input id="p_outtime_" name="p_outtime" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                            </td>
                            </td>
                        </tr>                                   

                        <tr id="tr_scene_hide" >
                            <td>
                                <span style="margin-left:20px;">区域经度</span>&nbsp;
                                <input id="longitudem26d_" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="longitudem26m_" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="longitudem26s_" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">区域纬度&nbsp;</span>
                                <input id="latitudem26d_" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="latitudem26m_" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="latitudem26s_" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                            </td>
                        </tr>



                    </tbody>
                </table>

            </form>
        </div>








    </body>
</html>