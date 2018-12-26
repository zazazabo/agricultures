<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/md5.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>

        <link rel="stylesheet" href="ztree/css/bootstrapStyle/bootstrapStyle.css" type="text/css">

        <!--<script type="text/javascript" src="ztree/js/jquery.min.js"></script>-->
        <script type="text/javascript" src="ztree/js/jquery.ztree.core.js"></script>
        <script type="text/javascript" src="ztree/js/jquery.ztree.excheck.js"></script>
        <script type="text/javascript" src="ztree/js/jquery.ztree.exedit.js"></script> 
        <script type="text/javascript"  src="js/getdate.js"></script>
        <title>JSP Page</title>

        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }
        </style>

        <style type="text/css">
            div#rMenu {position:absolute; visibility:hidden; top:0; text-align: left;padding:4px;}
            div#rMenu a{
                padding: 3px 15px 3px 15px;
                background-color:#cad4e6;
                vertical-align:middle;
            }
        </style>




        <script>
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            //添加角色
            function addrole() {
                var name = $("#rolename").val();
                if (name == "") {
                    layerAler("角色名不能为空");  //角色名不能为空
                    return;
                }
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 2000);
                    }

                });
                $.ajax({async: false, url: "login.rolemanage.getrole.action", type: "POST", datatype: "JSON", data: {roletype: ${param.role}, name: name, enable: 1},
                    success: function (data) {
                        console.log(data);
                        if (data != null) {
                            var rsname = data.rsname;
                            if (rsname.length > 0) {
                                layerAler("此角色已存在");  //此角色已存在
                                return;
                            }
                            var list = data.rs;
                            for (var i = 0; i < list.length; i++) {
                                var role = ${param.role}; //当前登陆的用户角色Id
                                var obj = list[i];
                                obj.enable = 0;
                                obj.roletype = parseInt(data.rsmax[0].maxtype) + 1;
                                obj.name = name;
                                obj.parent_id = role;
                                $.ajax({async: false, url: "login.rolemanage.addrole.action", type: "get", datatype: "JSON", data: obj,
                                    success: function (data) {
                                        //console.log(data);
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });

                            }
                            alert(langs1[144][lang]); //添加成功
                            getcombox();
                            addlogon(u_name, "添加", o_pid, "角色权限管理", "添加【" + name + "】角色");
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            function getIdSelections() {
                return $.map($("#gravidaTable").bootstrapTable('getSelections'), function (row) {
                    return row.id;
                });
            }
// 在ztree上的右击事件
            function OnRightClick(event, treeId, treeNode) {
                var curName = "";
                if (treeNode == null) {
                    var a = 1; // 什么都不做
                } else if (treeNode && treeNode.name) {
                    curName = treeNode.name;
                    //&& treeNode.isParent == false
                    if (treeNode.checked == true) {
                        //再判断是否为父节点
                        if (treeNode.isParent) {
                            $("#isParent").val("1");
                        } else {
                            $("#isParent").val("2");
                        }
                        //将当前点击的节点id存起来
                        $("#treeid").val(treeNode.id);
                        showRMenu("root", event.clientX, event.clientY);
                    }
                } else {
                    curName = undefined;
                }
            }
//显示右键菜单
            function showRMenu(type, x, y) {
                $("#rMenu ul").show();
                var rMenu = $("#rMenu");
                rMenu.css({"top": y + "px", "left": x + "px", "visibility": "visible"}); //设置右键菜单的位置、可见              
                $("body").bind("mousedown", onBodyMouseDown);
            }
//隐藏右键菜单
            function hideRMenu() {
                var rMenu = $("#rMenu");

                if (rMenu)
                    rMenu.css({"visibility": "hidden"}); //设置右键菜单不可见
                $("body").unbind("mousedown", onBodyMouseDown);
            }
//鼠标按下事件
            function onBodyMouseDown(event) {
                var rMenu = $("#rMenu");
                if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0)) {
                    rMenu.css({"visibility": "hidden"});
                } else {
                    if (event.target.name = "cancel") {
                        var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                        var id = $("#treeid").val();
                        var node = zTreeOjb.getNodeByParam("id", id);
                        if (node.checked == true) {

                            layer.confirm(langs1[251][lang], {//确认要取消权限吗？
                                btn: [langs1[146][lang], langs1[147][lang]]  //确定、取消按钮
                            }, function (index) {
                                layer.close(index);
                                var role = $("#role").val();
                                var isparent = $("#isParent").val();
                                if (role == "") {
                                    layerAler("请选择要取消权限的角色");  //请选择要取消权限的角色
                                    return;
                                }
                                var iscodeobj = {};
                                iscodeobj.code = id;
                                iscodeobj.roletype = role;
                                //判断是否拥有该权限
                                var isok = false;
                                $.ajax({async: false, url: "login.rolemanage.iscode.action", type: "get", datatype: "JSON", data: iscodeobj,
                                    success: function (data) {
                                        if (data.rs.length > 0) {
                                            isok = true;
                                        } else {
                                            layerAler(langs1[253][lang]);   //该角色不拥有该权限
                                        }
                                        freshenTree(role);
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                                if (isok) {
                                    //选中父节点
                                    if (isparent == "1") {
                                        var obj = {};
                                        obj.code = id;
                                        obj.roletype = role;
                                        $.ajax({async: false, url: "login.rolemanage.updateMrole.action", type: "get", datatype: "JSON", data: obj,
                                            success: function (data) {
                                                if (data.rs.length > 0) {
                                                    layerAler(langs1[254][lang]);   //取消成功
                                                    addlogon(u_name, "取消权限", o_pid, "角色权限管理", "取消角色权限");
                                                } else {
                                                    layerAler(langs1[255][lang]);  //取消失败
                                                }
                                                freshenTree(role);
                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                    } else if (isparent == "2") { //选中子节点
                                        var obj = {};
                                        obj.code = id;
                                        obj.roletype = role;
                                        $.ajax({async: false, url: "login.rolemanage.updaterole.action", type: "get", datatype: "JSON", data: obj,
                                            success: function (data) {
                                                if (data.rs.length > 0) {
                                                    layerAler(langs1[254][lang]);   //取消成功
                                                    addlogon(u_name, "取消权限", o_pid, "角色权限管理", "取消角色权限");
                                                } else {
                                                    layerAler(langs1[255][lang]);  //取消失败
                                                }
                                                freshenTree(role);
                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                    }
                                }
                                $("#isParent").val("");
                                $("#treeid").val("");
                            });


                            // layerAler("取消息当明操作的节点");
                        }
                        rMenu.css({"visibility": "hidden"});
                    }
                }


            }

            //分配权限
            function addauthor() {
                var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                var pnode = zTreeOjb.getNodes(); //可以获取所有的父节点
                var allnodes = zTreeOjb.transformToArray(pnode);  //获取所有节点
                var nodes = zTreeOjb.getCheckedNodes();

                var roletype = $("#role").combobox('getValue');
                var name = $("#role").combobox('getText');
                if ($("#role").val() == "") {
                    layerAler("请选择要分配权限的角色");   //请选择要分配权限的角色
                    return;
                }

//                if (nodes.length == 0) {
//                    layerAler(langs1[240][lang]);  //请勾选菜单列表
//                    return;
//                }
                layer.confirm("确认要分配权限吗?", {//确认要分配权限吗？
                    btn: ['确定', '取消']//确定、取消按钮
                }, function (index) {
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 2000);
                        }

                    });

                    addlogon(u_name, "分配权限权限", o_pid, "角色权限管理", "修改角色【" + $("#role").combobox('getText') + "】权限");
                    var obj1 = {};
                    obj1.name = name;
                    obj1.roletype = roletype;
                    for (var i = 0; i < allnodes.length; i++) {
                        obj1.code = allnodes[i].id;
                        var code = allnodes[i].id;  //节点编号
                        if (allnodes[i].id == "0") {
                            continue;
                        }
                        if (allnodes[i].checked == true) {
                            $.ajax({async: false, url: "login.rolemanage.havecode.action", type: "POST", datatype: "JSON", data: obj1,
                                success: function (data) {
                                    var rs = data.rs;
                                    var prs = data.prs;
                                    if (rs.length > 0) {
                                        obj1.enable = 1;
                                        $.ajax({async: false, url: "login.rolemanage.getpower.action", type: "POST", datatype: "JSON", data: obj1,
                                            success: function (data) {
                                                //console.log(data);
                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                    } else {
                                        //添加一行数据
                                        //name,roletype,code,enable,parent_id
                                        var obj = {};
                                        obj.name = name;
                                        obj.roletype = roletype;
                                        obj.code = code;
                                        obj.enable = 1;
                                        obj.parent_id = prs[0].parent_id;
                                        $.ajax({async: false, url: "login.rolemanage.addrole.action", type: "get", datatype: "JSON", data: obj,
                                            success: function (data) {
                                                //console.log(data);
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

                        } else {
                            obj1.enable = 0;
                            $.ajax({async: false, url: "login.rolemanage.getpower.action", type: "POST", datatype: "JSON", data: obj1,
                                success: function (data) {
                                    //console.log(data);
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                            var rtype = roletype;  //角色编号
                            uprole(rtype, code);
                        }

                    }
                    layerAler("权限分配成功!");  //权限分配成功！
                    layer.close(index);
                });
            }
            //删除角色
            function delrole() {
                if ($("#role").val() == "") {
                    layerAler("请选择要删除的角色");   //请选择要删除的角色
                    return;
                }
                var obj = {};
                obj.m_code = $("#role").val();
                //查看角色是否已分配给用户
                $.ajax({async: false, url: "login.rolemanage.lookrole.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            layerAler("该角色已分配给用户不可删除");
                        } else {
                            layer.confirm(langs1[145][lang], {//确认删除吗？
                                btn: [langs1[146][lang], langs1[147][lang]]//确定、取消按钮
                            }, function (index) {
                                $('#panemask').showLoading({
                                    'afterShow': function () {
                                        setTimeout("$('#panemask').hideLoading()", 2000);
                                    }

                                });
                                addlogon(u_name, "删除角色", o_pid, "权限管理", "删除【" + $("#role").combobox('getText') + "】角色");
                                var obj2 = {};
                                obj2.roletype = $("#role").val();
                                $.ajax({async: false, url: "login.rolemanage.deleterole.action", type: "POST", datatype: "JSON", data: obj2,
                                    success: function (data) {
                                        var list = data.rs;
                                        if (list.length > 0) {
                                            getcombox();
                                            layerAler("删除成功");  //删除成功！
                                        }
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                                layer.close(index);
                            });
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }


            $(function () {
                var lang = "${param.lang}";
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                var obj = {};
                obj.roletype = ${param.role};
                var zNodes = [
                ];
                $.ajax({async: false, url: "login.rolemanage.queryZtree.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        for (var i = 0; i < data.length; i++) {
//                            console.log(data[i]);
                            var obj1 = eval('(' + data[i].name + ')');
//                            console.log(obj1);
                            data[i].name = obj1[lang];
                        }
                        var obj2 = {id: "0", pId: 0, name: '菜单目录', open: true};   //菜单目录
                        data.push(obj2);
                        zNodes = data;
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                var setting = {
                    callback: {
                        //  onRightClick: OnRightClick
                    },
                    check: {
                        enable: true
                    },
                    data: {
                        simpleData: {
                            enable: true
                        }
                    }
                };
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);

                $("#btnauthor").show(true);



            });

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            //获取角色
            function  getcombox() {
                $("#role").combobox({
                    url: "login.usermanage.rolemenu.action?parent_id=${param.role}"
//                    onLoadSuccess: function (data) {
//                        $(this).combobox("select", data[0].id);
//                        $(this).val(data[0].text);
//                    }
                });
            }

            $(function () {
                getcombox();
                $('#role').combobox({
                    onSelect: function (record) {
                        var objrole = {role: record.id};
                        $.ajax({type: "post", url: "formuser.mainmenu.querysub.action", dataType: "json", data: objrole,
                            success: function (datas) {
                                //console.log(datas);
                                var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                                zTreeOjb.checkAllNodes(false);
                                datas.forEach(function (data) {
                                    //console.log(data);
                                    var m_code = data.m_code;
                                    var node = zTreeOjb.getNodeByParam("id", m_code);
                                    zTreeOjb.checkNode(node, true, false);
                                    zTreeOjb.updateNode(node);
                                });
                            }
                        });
                    }
                });


            });
            //修改权限后刷新权限树形图
            function  freshenTree(roleid) {
                var objrole = {role: roleid};
                $.ajax({type: "post", url: "formuser.mainmenu.querysub.action", dataType: "json", data: objrole,
                    success: function (datas) {
                        //console.log(datas);
                        var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");

                        zTreeOjb.checkAllNodes(false);
                        datas.forEach(function (data) {
                            //console.log(data);
                            var m_code = data.m_code;
                            var node = zTreeOjb.getNodeByParam("id", m_code);
                            zTreeOjb.checkNode(node, true, false);
                            zTreeOjb.updateNode(node);
                        });
                    }
                });
            }
             
            function uprole(rtype, code) {
                var robj = {};
                var roletype = rtype;
                robj.roletype = roletype;
                $.ajax({async: false, url: "login.rolemanage.zirole.action", type: "POST", datatype: "JSON", data: robj,
                    success: function (data) {
                        var rs = data.rs;
                        var rolers = data.rolers;  //子角色列表
                        if (rolers.length > 0) {
                            for (var k = 0; k < rolers.length; k++) {
                                roletype = rs[k].roletype;
                                for (var j = 0; j < rs.length; j++) {
                                    if (code == rs[j].code) {
                                        var uobj = {};
                                        uobj.roletype = roletype;
                                        uobj.code = code;
                                        uobj.enable = 0;
                                        $.ajax({async: false, url: "login.rolemanage.getpower.action", type: "POST", datatype: "JSON", data: uobj,
                                            success: function (data) {
                                                //console.log(data);
                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                        break;
                                    }
                                }
                                uprole(roletype, code);
                            }

                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

        </script>

    </head>
    <body id="panemask">

        <div class="panel panel-success">
            <div class="panel-heading">
                <h3 class="panel-title"><span name="xxx" id="243">权限分配</span></h3>
            </div>
            <div class="panel-body" >
                <div class="container" style="width: 100%"  >
                    <div class="" style=" width: 100%;">
                        <div class="" style="width:20%;float: left;">
                            <ul id="treeDemo" class="ztree"></ul>
                        </div>
                        <div class="" style=" width: 50%; margin-left: 5%; float: left; margin-top: 2%;">
                            <div id="btnauthor" style=" display: none;" >

                                <button class="btn btn-success" onclick="addauthor()" style=" margin-left: 30%;"><span>修改权限</span></button>

                            </div>
                            <div style=" margin-top: 3%;">
                                <span style=" width: 20%;" name="xxx" id="245">角色列表</span>
<!--                            <input id="role" class="easyui-combobox" name="role" style="width:40%; height: 34px;" data-options="editable:true,valueField:'id', textField:'text',url:'login.usermanage.rolemenu.action?parent_id=${param.role}'" />-->
                                <input id="role" data-options='editable:false,valueField:"id", textField:"text"' style="width:35%; height: 34px;" class="easyui-combobox"/>
                                <button class="btn btn-success" style=" width:18%;" onclick="delrole()" ><span>删除角色</span></button>
                            </div>
                            <div style=" margin-top: 3%;">
                                <span style=" width: 20%;" name="xxx" id="246">角色名称</span>&nbsp;
                                <input id="rolename" class="form-control" name="rolename" style="width:35%;display: inline;" placeholder="请输入角色名称" type="text">
                                <button id="btnrole" onclick="addrole()" class="btn btn-success" style=" width: 18%;"><span name="xxx" id="247">生成角色</span></button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="rMenu">
            <input id="treeid" type="hidden" value="" />
            <input id="isParent" type="hidden" value="" />
            <a href="#" class="list-group-item" type="m_expand" name="cancel" ><span name="xxx" id="248">取消权限</span></a>
        </div>

    </body>
</html>
