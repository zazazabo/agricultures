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
        <script type="text/javascript" src="js/md5.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
        <title>JSP Page</title>

        <style>
            * { margin: 0; padding: 0; } 
            body, html { width: 100%; height: 100%; }
            .zuheanniu { margin-top: 2px; margin-left: 10px; }
            table { font-size: 14px; } .modal-body input[type="text"], 
            .modal-body select, .modal-body input[type="radio"] { height: 30px; } 
            .modal-body table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; }
            .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
            .getMenu li:hover { background: #eee; cursor: pointer; }
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 }
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer }
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 
            .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; }
            .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }
        </style>


        <script>
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var uid = parent.parent.getuserId();
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                //var pinfo = [];
                $("#add").attr("disabled", true);
                $("#del").attr("disabled", true);
                $("#update").attr(":disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {
                                if (rs[i].code == "800301" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "800302" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "800303" && rs[i].enable != 0) {
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
                    //url: 'login.project.queryProject.action?pid=' + userporject,
                    columns: [
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
                            field: 'name',
                            title: langs1[256][lang], //项目名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'code',
                            title: langs1[257][lang], //项目编号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'area',
                            title: langs1[258][lang], //项目地址
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }],
                    singleSelect: false,
                    locale: 'zh-CN', //中文支持,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 10,
                    pageList: [10, 20, 40, 80]
                });
                var pid = getuserporject(uid);
                var pinfo = getprojectInfo(pid);
                $('#gravidaTable').bootstrapTable('load', pinfo);

            });
            //获取当前用户的管理项目
            function  getuserporject(uid) {
                var s = "";
                $.ajax({async: false, url: "login.project.getuserProject.action", type: "get", datatype: "JSON", data: {id: uid},
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            s = arrlist[0].pid;
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                return s;
            }
            //获取项目信息
            function getprojectInfo(pid) {
                var pinfo = [];
                var pids = pid.split(",");
                for (var i = 0; i < pids.length; i++) {
                    $.ajax({async: false, url: 'login.project.queryProject.action', type: "get", datatype: "JSON", data: {pid: pids[i]},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                pinfo = pinfo.concat(arrlist);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                return pinfo;
            }
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function  checkProjectAdd() {
                var obj = $("#Form_User").serializeObject();
                if (obj.name == "") {
                    layerAler(langs1[259][lang]);   //项目不能为空
                    return false;
                }
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 2000);
                    }

                });
                obj.uid = uid;
                addlogon(u_name, "添加", o_pid, "项目管理", "添加【"+obj.name+"】项目");
                var isflesh = false;
                $.ajax({url: "login.project.queryProject.action", async: false, type: "POST", datatype: "JSON", data: obj,
                    success: function (data) {
                        if (data.rs.length == 0) {
                            $.ajax({async: false, url: "login.project.addProject.action", type: "get", datatype: "JSON", data: obj,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        $.ajax({async: false, url: "login.project.selectlatcode.action", type: "get", datatype: "JSON", data: {},
                                            success: function (data) {
                                                var newcode;
                                                var code = data.codes;
                                                if (code.length == 1) {
                                                    newcode = code[0].code;
                                                    var s = getuserporject(uid);
                                                    if (s == null || s == "") {
                                                        var pidobj1 = {};
                                                        pidobj1.id = uid;
                                                        pidobj1.npid = newcode;
                                                        $.ajax({async: false, url: "login.project.addpid1.action", type: "get", datatype: "JSON", data: pidobj1,
                                                            success: function (data) {

                                                            },
                                                            error: function () {
                                                                alert("提交失败！");
                                                            }
                                                        });
                                                    } else {
                                                        var pidobj = {};
                                                        pidobj.id = uid;
                                                        pidobj.npid = "," + newcode;
                                                        $.ajax({async: false, url: "login.project.addpid.action", type: "get", datatype: "JSON", data: pidobj,
                                                            success: function (data) {

                                                            },
                                                            error: function () {
                                                                alert("提交失败！");
                                                            }
                                                        });
                                                    }

                                                    var pobj = {};
                                                    pobj.id = uid;
                                                    var parentid = 0;
                                                    do {
                                                        $.ajax({async: false, url: "login.project.selectparent.action", type: "get", datatype: "JSON", data: pobj,
                                                            success: function (data) {
                                                                var parentids = data.ups;
                                                                parentid = parentids[0].u_parent_id;
                                                                pobj.id = parentid;
                                                                if (parentid != 0) {
                                                                    var pid = getuserporject(parentid);
                                                                    if (pid == null || pid == "") {
                                                                        var ppobj = {};
                                                                        ppobj.id = parentid;
                                                                        ppobj.npid = newcode;
                                                                        $.ajax({async: false, url: "login.project.addpid1.action", type: "get", datatype: "JSON", data: ppobj,
                                                                            success: function (data) {

                                                                            },
                                                                            error: function () {
                                                                                alert("提交失败！");
                                                                            }
                                                                        });
                                                                    } else {
                                                                        var ppobj2 = {};
                                                                        ppobj2.id = parentid;
                                                                        ppobj2.npid = "," + newcode;
                                                                        $.ajax({async: false, url: "login.project.addpid.action", type: "get", datatype: "JSON", data: ppobj2,
                                                                            success: function (data) {

                                                                            },
                                                                            error: function () {
                                                                                alert("提交失败！");
                                                                            }
                                                                        });
                                                                    }

                                                                }
                                                            }
                                                        });
                                                    } while (parentid != 0);

                                                    var pid = getuserporject(uid);
                                                    parent.parent.porject(pid);  //首页刷新项目列表

                                                }

                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                    }
                                    isflesh = true;
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });



                        } else if (data.rs.length > 0) {
                            layerAler(langs1[260][lang]);  //此项目已存在
                        }
                        return  false;
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });
                return isflesh;
            }

            //编辑
            function editporject() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[261][lang]);  //请选择您要编辑的项目
                    return;
                }
                $("#pname").val(selects[0].name);
                $("#parea").val(selects[0].area);
                $("#code").val(selects[0].code);
                $("#p_id").val(selects[0].id);
                $("#pjj2").modal();
            }

            function update() {
                var pname = $("#pname").val();
                if (pname == "") {
                    layerAler(langs1[262][lang]);  //项目名不能为空
                    return;
                }
                addlogon(u_name, "修改", o_pid, "项目管理", "修改【" + pname + "】项目信息");
                var obj = {};
                obj.area = $("#parea").val();
                obj.name = pname;
                obj.id = $("#p_id").val();
                $.ajax({async: false, url: "login.project.updProject.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            var pid = getuserporject(uid);
                            var pinfo = getprojectInfo(pid);
                            $('#gravidaTable').bootstrapTable('load', pinfo);
                            $("#pjj2").modal('hide'); //手动关闭
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
            //删除
             function deleteUser() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                console.log(selects[0]);
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[263][lang]);  //请选择您要删除的记录
                    return;
                }
                layer.confirm(langs1[145][lang], {//确认要删除吗？
                    btn: [langs1[146][lang], langs1[147][lang]]//确定、取消按钮
                }, function (index) {
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 2000);
                        }

                    });
                    $.ajax({async: false, url: "login.project.getbase.action", type: "POST", datatype: "JSON", data: {pid: selects[0].code},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                layerAler(langs1[264][lang]);  //该项目下存在网关，不可删除
                            } else {
                                if (uid == selects[0].uid) {
                                    addlogon(u_name, "删除", o_pid, "项目管理", "删除项目【"+selects[0].name+"】");
                                    $.ajax({async: false, url: "login.project.delete.action", type: "POST", datatype: "JSON", data: {id: selects[0].id},
                                        success: function (data) {
                                            var arrlist = data.rs;
                                            if (arrlist.length > 0) {
                                                var code = selects[0].code;
                                                var pid = getuserporject(uid);
                                                var pinfo = getprojectInfo(pid);
                                                $('#gravidaTable').bootstrapTable('load', pinfo);
                                                $.ajax({async: false, url: "login.project.getpidUser.action", type: "get", datatype: "JSON", data: {pid: code},
                                                    success: function (data) {
                                                        var arrlist = data.rs;
                                                        for (var i = 0; i < arrlist.length; i++) {
                                                            var pids = arrlist[i].pid.split(",");
                                                            console.log(i + ":" + pids);
                                                            for (var j = 0; j < pids.length; j++) {
                                                                if (pids[j] == code) {
                                                                    pids.splice(j, 1);
                                                                }
                                                            }
                                                            console.log(i + ":" + pids);
                                                            var newcode = "";
                                                            for (var k = 0; k < pids.length; k++) {
                                                                if (k == 0) {
                                                                    newcode += pids[k];
                                                                } else {
                                                                    newcode += ",";
                                                                    newcode += pids[k];
                                                                }
                                                            }
                                                            console.log(i + "new:" + newcode);
                                                            var uobj = {};
                                                            console.log("id:" + arrlist[i].id);
                                                            uobj.id = arrlist[i].id;
                                                            uobj.pid = newcode;
                                                            $.ajax({async: false, url: "login.project.upduserpid.action", type: "get", datatype: "JSON", data: uobj,
                                                                success: function (data) {
                                                                    // var arrlist = data.rs;
                                                                    var pid = getuserporject(uid);
                                                                    parent.parent.porject(pid);  //首页刷新项目列表
                                                                },
                                                                error: function () {
                                                                    alert("提交失败！");
                                                                }
                                                            });

                                                        }
                                                    },
                                                    error: function () {
                                                        alert("提交失败！");
                                                    }
                                                });
                                            }
                                        },
                                        error: function () {
                                            layerAler("提交失败");
                                        }
                                    });
                                } else {
                                    var pobj = {};
                                    pobj.id = selects[0].uid;
                                    var parentid = 0;
                                    var ok = 0;
                                    do {
                                        $.ajax({async: false, url: "login.project.selectparent.action", type: "get", datatype: "JSON", data: pobj,
                                            success: function (data) {
                                                var parentids = data.ups;
                                                if (parentids.length > 0) {
                                                    parentid = parentids[0].u_parent_id;
                                                    pobj.id = parentid;
                                                    if (parentid != 0) {
                                                        if (uid == parentid) {
                                                            addlogon(u_name, "删除", o_pid, "项目管理", "删除项目【"+selects[0].name+"】");
                                                            $.ajax({async: false, url: "login.project.delete.action", type: "POST", datatype: "JSON", data: {id: selects[0].id},
                                                                success: function (data) {
                                                                    var arrlist = data.rs;
                                                                    if (arrlist.length > 0) {
                                                                        var code = selects[0].code;
                                                                        var pid = getuserporject(uid);
                                                                        var pinfo = getprojectInfo(pid);
                                                                        $('#gravidaTable').bootstrapTable('load', pinfo);
                                                                        $.ajax({async: false, url: "login.project.getpidUser.action", type: "get", datatype: "JSON", data: {pid: code},
                                                                            success: function (data) {
                                                                                var arrlist = data.rs;
                                                                                for (var i = 0; i < arrlist.length; i++) {
                                                                                    var pids = arrlist[i].pid.split(",");
                                                                                    console.log(i + ":" + pids);
                                                                                    for (var j = 0; j < pids.length; j++) {
                                                                                        if (pids[j] == code) {
                                                                                            pids.splice(j, 1);
                                                                                        }
                                                                                    }
                                                                                    console.log(i + ":" + pids);
                                                                                    var newcode = "";
                                                                                    for (var k = 0; k < pids.length; k++) {
                                                                                        if (k == 0) {
                                                                                            newcode += pids[k];
                                                                                        } else {
                                                                                            newcode += ",";
                                                                                            newcode += pids[k];
                                                                                        }
                                                                                    }
                                                                                    console.log(i + "new:" + newcode);
                                                                                    var uobj = {};
                                                                                    console.log("id:" + arrlist[i].id);
                                                                                    uobj.id = arrlist[i].id;
                                                                                    uobj.pid = newcode;
                                                                                    $.ajax({async: false, url: "login.project.upduserpid.action", type: "get", datatype: "JSON", data: uobj,
                                                                                        success: function (data) {
                                                                                            // var arrlist = data.rs;
                                                                                            var pid = getuserporject(uid);
                                                                                            parent.parent.porject(pid);  //首页刷新项目列表
                                                                                        },
                                                                                        error: function () {
                                                                                            alert("提交失败！");
                                                                                        }
                                                                                    });

                                                                                }
                                                                            },
                                                                            error: function () {
                                                                                alert("提交失败！");
                                                                            }
                                                                        });
                                                                    }
                                                                },
                                                                error: function () {
                                                                    layerAler("提交失败");
                                                                }
                                                            });
                                                            ok = 1;
                                                            parentid = 0;
                                                        }
                                                    }

                                                }else{
                                                    parentid = 0;
                                                }

                                            }
                                        });
                                    } while (parentid != 0);
                                    if (ok == 0) {
                                        layerAler("子用户不可删除父用户创建的项目"); //"子用户不可删除父用户创建的项目"
                                    }
                                }


                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    layer.close(index);

                });
            }




        </script>

    </head>
    <body id="panemask" >

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;<span name="xxx" id="65">添加</span>
            </button>
            <button class="btn btn-primary ctrol"   onclick="editporject()"  id="update">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;<span name="xxx" id="66">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteUser();" id="del" >
                <span class="glyphicon glyphicon-trash"></span>&nbsp;<span name="xxx" id="67">删除</span>
            </button> 
        </div>

        <table id="gravidaTable" style="width:100%; height: 100%;" class="text-nowrap table table-hover table-striped"></table>  



        <!-- 添加 -->
        <div class="modal" id="pjj">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;"><span name="xxx" id="266">添加项目</span></h4></div>

                    <form action="" method="POST" id="Form_User" onsubmit="return checkProjectAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;" name="xxx" id="256">项目名称</span>&nbsp;
                                            <input id="name"    class="form-control"  name="name" style="width:150px;display: inline;" placeholder="项目名称" type="text">
                                        </td>

                                        <td></td>
                                    </tr>                                

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;" name="xxx" id="258">项目地址</span>&nbsp;
                                            <input id="area"    class="form-control"  name="area" style="width:150px;display: inline;" placeholder="区域" type="text">
                                        </td>
                                        <td></td>
                                        <td>

                                        </td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer">
                            <!-- 添加按钮 -->
                            <button id="tianjia1" type="submit" class="btn btn-primary"><span id="65" name="xxx">添加</span></button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal"><span id="57" name="xxx">关闭</span></button></div>
                    </form>
                </div>
            </div>
        </div>

        <!--编辑-->
        <div class="modal" id="pjj2">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;"><span name="xxx" id="267">修改项目</span></h4></div>
                    <div class="modal-body">
                        <input type="hidden" id="p_id" name="id" />
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;" name="xxx" id="257">项目编号</span>&nbsp;
                                        <input id="code"    class="form-control"  name="name" style="width:150px;display: inline; " readonly="readonly" type="text">
                                    </td>

                                    <td></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;" name="xxx" id="256">项目名称</span>&nbsp;
                                        <input id="pname"    class="form-control"  name="name" style="width:150px;display: inline; "  type="text">
                                    </td>

                                    <td></td>
                                </tr>                                

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;" name="xxx" id="258">项目地址</span>&nbsp;
                                        <input id="parea"    class="form-control"  name="area" style="width:150px;display: inline;" placeholder="区域" type="text">
                                    </td>
                                    <td></td>
                                    <td>

                                    </td>
                                </tr>

                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 添加按钮 -->
                        <button id="tianjia1" type="button" class="btn btn-primary" onclick="update()"><span name="xxx" id="151">修改</span></button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal"><span name="xxx" id="57">关闭</span></button>
                    </div>
                </div>
            </div>
        </div>




    </body>
</html>
