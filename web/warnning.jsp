<%-- 
    Document   : warnning
    Created on : 2018-8-6, 9:10:54
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src ="layer/layer.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <title>JSP Page</title>
        <style>
            table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; }
        </style>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
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
                                if (rs[i].code == "700101" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "700102" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "700103" && rs[i].enable != 0) {
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

                $('#gravidaTable').bootstrapTable({
                    url: 'login.warnning.queryData.action?pid=' + o_pid,
                    columns: [[{
                                field: '',
                                title: langs1[134][lang],  //告警配置
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 6
                            }], [
                            {
                                title: '单选',
                                field: 'select',
                                //复选框
                                checkbox: true,
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            },
                            {
                                field: 'u_name',
                                title: langs1[135][lang],  //姓名
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_phone',
                                title: langs1[136][lang], //联系电话
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_email',
                                title: langs1[137][lang],  //邮箱
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_content',
                                title:'备注',  //告警类型
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }
                        ]
                    ],
                    clickToSelect: true,
                    singleSelect: true,
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
                            type_id: "1"    
                        };      
                        return temp;  
                    },
                });

                $("#update2").click(function () {
                    var uname = $("#updname").val();
                    var uphone = $("#updphone").val();
                    var uid = $("#updid").val();
                    var uemail = $("#updemail").val();
                   // var uwarntype = $("#upd_warntype").val();
                    var u_content = $("#u_content").val();
                    if (uname == "") {
                        alert(langs1[139][lang]);  //姓名不能为空
                        return;
                    }
                    if (uphone == "") {
                        alert(langs1[140][lang]);  //电话不能为空
                        return;
                    }
                    if (uemail == "") {
                        alert(langs1[141][lang]); //邮箱不能为空
                        return;
                    }
                   

                    var obj = {};
                    obj.u_name = uname;
                    obj.u_phone = uphone;
                    obj.u_email = uemail;
                    obj.u_content = u_content;
                    obj.u_id = uid;
                    $.ajax({url: "login.warnning.update.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                alert(langs1[143][lang]);  //修改成功
                                $("#gravidaTable").bootstrapTable('refresh');
                                $("#updatetable").modal('hide');  //手动关闭
                                addlogon(u_name, "修改", o_pid, "报警设置", "修改报警管理人员");
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                });

            });

            function updatepeople() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length < 1) {
                    alert(langs1[73][lang]); //请勾选表格数据
                    return;
                }
                var select = selects[0];
                $("#updname").val(select.u_name);
                $("#updphone").val(select.u_phone);
                $("#updemail").val(select.u_email);
                $("#updid").val(select.u_id);
                $("#u_content").val(select.u_content);
                $("#updatetable").modal();
            }
            //添加警告配置
            function  add() {
                var phone = $("#adphone").val();
                var name = $("#adname").val();
                var email = $("#ademail").val();
               // var warntype = $("#adu_warntype").val();
                var content = $("#adu_content").val();
                var pid = o_pid;
                if (name == "") {
                    alert(langs1[139][lang]);  //姓名不能为空
                    return;
                }
                if (phone == "") {
                    alert(langs1[140][lang]);  //电话不能为空
                    return;
                }
                if (email == "") {
                    alert(langs1[141][lang]);  //邮箱不能为空
                    return;
                }

                var obj = {};
                obj.u_phone = phone;
                obj.u_name = name;
                obj.u_email = email;
                obj.u_content = content;
                obj.u_pid = pid;
                $.ajax({url: "login.warnning.addpeople.action", async: false, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            alert(langs1[144][lang]);//添加成功
                            $("#gravidaTable").bootstrapTable('refresh');
                            $("#addtable").modal('hide');  //自动关闭
                            addlogon(u_name, "添加", o_pid, "报警设置", "添加报警管理人员");
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });

            }

            //删除告警配置
            function deletepeople() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length < 1) {
                    alert(langs1[73][lang]);  //请勾选数据
                    return;
                }
                layer.confirm(langs1[145][lang], {    //确定要删除吗？
                    btn: [langs1[146][lang], langs1[147][lang]]//按钮
                }, function (index) {
                    addlogon(u_name, "删除", o_pid, "报警设置", "删除报警管理人员");
                    var select = selects[0];
                    $.ajax({async: false, url: "login.warnning.deletepeople.action", type: "POST", datatype: "JSON", data: {u_id: select.u_id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#gravidaTable").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    layer.close(index);
                    //此处请求后台程序，下方是成功后的前台处理……
                });

            }
        </script>
    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#addtable" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <span name="xxx" id="65">添加</span>
            </button>
            <button class="btn btn-primary ctrol"   onclick="updatepeople()" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;
                 <span name="xxx" id="66">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deletepeople();"  id="del">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;
                 <span name="xxx" id="67">删除</span>
            </button> 

        </div>
        <div class="bootstrap-table">
            <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">
                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>  
            </div>
        </div>
        <div class="modal" id="addtable" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;"><span name="xxx" id="148">添加告警配置人员</span></h4></div>

                    <form action="" method="POST" id="Form_User" onsubmit="return checkUserAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;" name="xxx" id="135">姓名</span>&nbsp;
                                            <input id="adname"    class="form-control"   style="width:150px;display: inline;" placeholder="请输入名字" type="text">
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:50px;" name="xxx" id="149">备注</span>&nbsp;
                                            <input id="adu_content"    class="form-control"   style="width:150px;display: inline;" placeholder="请输入备注" type="text">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;" name="xxx" id="136">电话</span>&nbsp;
                                            <input id="adphone" class="form-control"  name="phone" style="width:150px;display: inline;" placeholder="请输入电话" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:50px;" name="xxx" id="137">邮箱</span>&nbsp;
                                            <input id="ademail" class="form-control" name="email" style="width:150px;display: inline;" placeholder="请输入邮箱" type="text">
                                        </td>
                                    </tr> 

                                </tbody>
                            </table>
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer">
                            <!-- 添加按钮 -->
                            <button id="tianjia1" type="button" class="btn btn-primary" onclick="add()">
                                <span name="xxx" id="65">添加</span>
                            </button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">
                                <sapn name="xxx" id="57">关闭</sapn> 
                            </button></div>
                    </form>
                </div>
            </div>
        </div>
        <div class="modal" id="updatetable" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;"><span name="xxx" id="150">修改告警配置人员信息</span></h4></div>   
                    <div class="modal-body">
                        <input type="hidden" id="updid" name="id" />
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;" name="xxx" id="135">姓名</span>&nbsp;
                                        <input id="updname"    class="form-control"  name="name" style="width:150px;display: inline;" placeholder="请输入名字" type="text">
                                    </td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:48px;">备注</span>&nbsp;
                                        <input type="text" class="form-control"  style="width:175px;display: inline;" id="u_content">
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;" name="xxx" id="136">电话</span>&nbsp;
                                        <input id="updphone" class="form-control"  style="width:150px;display: inline;" placeholder="请输入电话" type="text">
                                    </td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:48px;" name="xxx" id="137">邮箱</span>&nbsp;
                                        <input id="updemail" class="form-control"  style="width:175px;display: inline;" placeholder="请输入邮箱" type="text">
                                    </td>
                                </tr>   
                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 修改按钮 -->
                        <button id="update2" type="button" class="btn btn-success">
                            <span name="xxx" id="151">修改</span>
                        </button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">
                            <span name="xxx" id="57">关闭</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>



    </body>
</html>
