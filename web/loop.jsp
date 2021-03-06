<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="SheetJS-js-xlsx/dist/xlsx.core.min.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <style>
            .t tr td{
                border: 1px solid #16645629;
                text-align:center;
            }
            .t tr th{
                border: 1px solid #16645629;
                text-align:center;
            }
        </style>
        <script>
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function excel() {
                $('#dialog-excel').dialog('open');
                return false;

            }

            //导入excel的添加按钮事件
            function addexcel() {
                var selects = $('#warningtable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[350][lang]); //请选择您要保存的数据
                    return;
                }
                addlogon(u_name, "添加", o_pid, "回路管理", "导入Excel文件");
                var pid = parent.parent.getpojectId();
                for (var i = 0; i <= selects.length - 1; i++) {
                    var comaddr = selects[i].网关地址;
                    var l_code = selects[i].回路编号;
                    var obj = {};
                    obj.pid = pid;
                    obj.comaddr = comaddr;
                    $.ajax({async: false, url: "login.loop.isporject.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                $.ajax({async: false, url: "login.loop.getl_code.action", type: "POST", datatype: "JSON", data: {l_code: l_code},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 0) {
                                            var cmdname = selects[i].网关名称;
                                            var lname = selects[i].回路名称;
                                            var groupe = selects[i].回路组号;
                                            var adobj = {};
                                            adobj.l_name = lname;
                                            adobj.l_code = l_code;
                                            adobj.l_worktype = 0;
                                            adobj.l_comaddr = comaddr;
                                            adobj.l_deplayment = 0;
                                            adobj.l_groupe = groupe;
                                            adobj.name = cmdname;
                                            $.ajax({url: "login.loop.addloop.action", async: false, type: "get", datatype: "JSON", data: adobj,
                                                success: function (data) {
                                                    var arrlist = data.rs;
                                                    if (arrlist.length == 1) {

                                                        var ids = [];//定义一个数组
                                                        var xh = selects[i].序号;
                                                        ids.push(xh);//将要删除的id存入数组
                                                        $("#warningtable").bootstrapTable('remove', {field: '序号', values: ids});
                                                    }
                                                },
                                                error: function () {
                                                    alert("提交添加失败！");
                                                }
                                            });
                                        }
                                    },
                                    error: function () {
                                        layerAler("提交失败");
                                    }
                                });

                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });

                }
            }

            function showDialog() {
                var o1 = $("#formsearch").serializeObject();
                o1.pid = "${param.pid}";
                console.log(o1);
                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
//                        console.log(data);
                        $("#infonum").combobox('loadData', data);

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });


                $.ajax({async: false, url: "plan.planForm.getSensorPlanBynum1.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
                        console.log(data);
                        for (var i = 0; i < 5; i++) {
                            $("#scen" + (i + 1)).combobox('loadData', data);
                        }
//                        $("#infonum").combobox('loadData', data);

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });






                $('#dialog-add').dialog('open');
                return false;
            }

            function checkLoopAdd() {
                var o = $("#formadd").serializeObject();

                var objplan = {code: o.l_plan, name: o.planname};
                o.l_plan = JSON.stringify(objplan);

                if (o.l_comaddr == "") {
                    layerAler("网关不能为空");  //网关不能为空
                    return  false;
                }

                var namesss = false;
                addlogon(u_name, "添加", o_pid, "回路管理", "添加回路【"+o.l_name+"】");

                if (isNumber(o.l_site) == false || isNumber(o.l_pos) == false) {
                    layerAler("数据位置站号是数字");
                    return false;
                }
                $.ajax({async: false, cache: false, url: "loop.loopForm.ExistLoop.action", type: "GET", data: o,
                    success: function (data) {
                        console.log(data);
                        if (data.total > 0) {
                            layerAler("此回路已存在"); //此回路已存在
                            return false;
                        }
                        if (data.total == 0) {
                            if (o.l_worktype == 3) {

                                for (var i = 0; i < 5; i++) {
                                    var time = "time" + (i + 1).toString();
                                    var timeval = "timeval" + (i + 1).toString();
                                    var o1 = {time: o[time], value: parseInt(o[timeval])};

                                    var valobj = JSON.stringify(o1);
                                    var val = "l_val" + (i + 1).toString();
                                    o[val] = valobj;
                                }
                                console.log(o);
                            } else if (o.l_worktype == 5) {
                                for (var i = 0; i < 5; i++) {
                                    var scene = "scen" + (i + 1).toString();
                                    var val = "val" + (i + 1).toString();
                                    var o1 = {scene: o[scene], value: parseInt(o[val])};
                                    var valobj = JSON.stringify(o1);
                                    var val = "l_val" + (i + 1).toString();
                                    o[val] = valobj;
                                }
                                console.log(o);
                            } else if (o.l_worktype == 9) {

                                var oo = {infonum: parseInt(o.infonum), offset: parseInt(o.offset)};
                                var oostr = JSON.stringify(oo);
                                o.l_val1 = oostr;
                                for (var i = 0; i < 4; i++) {
                                    var info = "info" + (i + 1).toString();
                                    var val = "infoval" + (i + 1).toString();
                                    var valdata = o[val] == null ? 0 : parseInt(o[val]);
                                    var o1 = {info: o[info], value: valdata};
                                    var valobj = JSON.stringify(o1);
                                    var val = "l_val" + (i + 1 + 1).toString();
                                    o[val] = valobj;
                                }
                                console.log(o);

                            }

                            $.ajax({async: false, cache: false, url: "loop.loopForm.addLoop1.action", type: "GET", data: o,
                                success: function (data) {
//                                    search();
                                    $("#gravidaTable").bootstrapTable('refresh');

                                },
                                error: function () {
                                    layerAler("系统错误，刷新后重试");
                                }
                            });
                            return  false;
                        }

                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {icon: 6, offset: 'center'
                        });

                    }

                })

                return  namesss;
            }

            function  deleteloop() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请勾选您要删除的数据');   //请勾选您要删除的数据
                    return;
                }
                layer.confirm('确定要删除吗？', {//确定要删除吗？
                    btn: ['确定', '取消按钮'], //确定、取消按钮
                    icon: 3,
                    offset: 'center',
                    title: langs1[174][lang]  //提示
                }, function (index) {
                    for (var i = 0; i < selects.length; i++) {
                        var select = selects[i];
                        var l_deployment = select.l_deplayment;
                        if (l_deployment == 1) {
                            layerAler('已部署不能删除');  //已部署不能删除
                            continue;
                        } else {
                          
                            $.ajax({url: "loop.loopForm.deleteLoop.action", type: "POST", datatype: "JSON", data: {id: select.id},
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        addlogon(u_name, "删除", o_pid, "回路管理", "删除回路【"+select.l_name+"】");
                                        layer.open({
                                            content: '删除成功', //删除成功
                                            icon: 1,
                                            yes: function (index, layero) {
                                                search();
                                                layer.close(index);
                                            }
                                        });
                                    }
                                    layer.close(index);
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                        }
                    }

                    layer.close(index);

                });
            }

            function  readinfoCB(obj) {
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {
                    v = v + sprintf("%02x", data[i]) + " ";
                }
                console.log(v);
                if (data[1] == 0x03) {
                    layerAler("读取成功");
                    var len = data[2];
                    var info = data[3] * 256 + data[4];
                    var site = data[5] * 256 + data[6];
                    var regpos = data[7] * 256 + data[8];
                    var w1 = data[9];
                    var w2 = data[10];

                    var strw1 = w2 & 0x01 == 0x01 ? "自动" : "手动";
                    var strworktype = "";
                    if (w2 == 3) {
                        strworktype = "时间模式";
                    } else if (w2 == 5) {
                        strworktype = "场景模式";
                    } else if (w2 == 9) {
                        strworktype = "信息点模式";
                    }
                    ; //                        var worktype = data[9] * 256 + data[10];
                    var dataval = data[11] * 256 + data[12];
                    layerAler("控制点:" + info + "<br>" + "站号" + site + "<br>" + "数据位置"
                            + regpos + "<br>" + "工作模式:" + strw1 + "<br>" + "执行方式:"
                            + strworktype + "<br>" + "控制值：" + dataval);
                }



            }

            function  readinfo() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();

                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                var ele = selects[0];
                o.l_comaddr = ele.l_comaddr;
                var vv = [];
                vv.push(1);
                vv.push(3);
                var info = parseInt(ele.l_info);
                var infonum = (3000 + info * 20) | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);

                vv.push(0);
                vv.push(20); //寄存器数目 2字节                         
                var data = buicode2(vv);
                console.log(data);
                dealsend2("03", data, "readinfoCB", o.l_comaddr, 0, ele.id, info);
            }

            function deployLoopCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (data[1] == 0x10) {
                        var infonum = (3000 + obj.val * 20) | 0x1000;
                        console.log(infonum);
                        var high = infonum >> 8 & 0xff;
                        var low = infonum & 0xff;
                        if (data[2] == high && data[3] == low) {
                            var str = obj.type == 0 ? "移除成功" : "部署成功";
                            layerAler(str);
                            var obj1 = {id: obj.param, l_deplayment: obj.type};
                            console.log(obj1);
                            $.ajax({async: false, url: "loop.loopForm.modifyDepayment.action", type: "get", datatype: "JSON", data: obj1,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        var obj = {};
                                        obj.l_comaddr = $("#l_comaddr").val();
                                        obj.pid = "${param.pid}";
                                        var opt = {
                                            url: "loop.loopForm.getLoopList.action",
                                            query: obj,
                                            silent: false
                                        };
                                        $("#gravidaTable").bootstrapTable('refresh', opt);
                                    }
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                        }

                    }

                }

            }

            function deployLoop() {

                var infoalldata = $("#formsearch").serializeObject();

                console.log(infoalldata);

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                var ele = selects[0];
                o.l_comaddr = ele.l_comaddr;
                console.log(ele);
                var vv = [];
                vv.push(1);
                vv.push(0x10);
                var info = parseInt(ele.l_info);
                console.log(info);

                var infonum = (3000 + info * 20) | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);

                vv.push(0);           //寄存器数目 2字节  
                vv.push(20);   //5
                vv.push(40);           //字节数目长度  1字节 10


                vv.push(info >> 8 & 0xff);  //信息点
                vv.push(info & 0xff);


                var site = parseInt(ele.l_site); //站点
                vv.push(site >> 8 & 0xff);
                vv.push(site & 0xff);

                var reg = parseInt(ele.l_pos);
                vv.push(reg >> 8 & 0xff)   //寄存器变量值
                vv.push(reg & 0xff);

                var worktype = parseInt(ele.l_worktype);
                vv.push(worktype >> 8 & 0xff)   //工作模式
                vv.push(worktype & 0xff);


                var val2 = parseInt(infoalldata.controlVal);

                vv.push(val2 >> 8 & 0xff);   //控制值
                vv.push(val2 & 0xff);

                for (var i = 0; i < 5; i++) {
                    vv.push(0);
                    vv.push(0);
                }

                for (var i = 0; i < 5; i++) {
                    var num = "l_val" + (i + 1).toString();

                    var val1 = "val" + (i + 1).toString();

                    if (ele.l_worktype == "3") {
                        var time = ele[num];
                        var o = eval('(' + time + ')');
                        var timearr = o.time.split(":");
                        var h = parseInt(timearr[0]);
                        var m = parseInt(timearr[1]);
                        var valuenum = parseInt(o.value);

                        vv.push(h);
                        vv.push(m);
                        vv.push(valuenum >> 8 & 0xff)   //寄存器变量值
                        vv.push(valuenum & 0xff);

                    } else if (ele.l_worktype == "5") {
                        var scene = ele[num];
                        var o = eval('(' + scene + ')');

                        var scenenum = o.scene;

                        vv.push(scenenum >> 8 & 0xff)   //寄存器变量值
                        vv.push(scenenum & 0xff);
                        var valuenum = o.value;
                        vv.push(valuenum >> 8 & 0xff)   //寄存器变量值
                        vv.push(valuenum & 0xff);
                    } else if (ele.l_worktype == "9") {
                        var info = ele[num];
                        var o = eval('(' + info + ')');
                        if (i == 0) {
                            var num = o.infonum;
                            var offset = o.offset;
                            vv.push(num >> 8 & 0xff)   //寄存器变量值
                            vv.push(num & 0xff);


                            vv.push(offset >> 8 & 0xff)   //寄存器变量值
                            vv.push(offset & 0xff);

                        } else {

                            var infonum1 = parseInt(o.info);
                            vv.push(infonum1 >> 8 & 0xff)   //寄存器变量值
                            vv.push(infonum1 & 0xff);
                            var valuenum = parseInt(o.value);
                            vv.push(valuenum >> 8 & 0xff)   //寄存器变量值
                            vv.push(valuenum & 0xff);
                        }


                    }
                }


                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "deployLoopCB", ele.l_comaddr, 1, ele.lid, ele.l_info);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }

            function removeLoop() {
                var infoalldata = $("#formsearch").serializeObject();
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                var ele = selects[0];
                o.l_comaddr = ele.l_comaddr;
                var vv = [];
                vv.push(1);
                vv.push(0x10);
                var info = parseInt(ele.l_info);
                var infonum = (3000 + info * 20) | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);

                vv.push(0);           //寄存器数目 2字节  
                vv.push(20);   //5
                vv.push(40);           //字节数目长度  1字节 10


                for (var i = 0; i < 20; i++) {
                    vv.push(0);
                    vv.push(0);
                }
                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "deployLoopCB", o.l_comaddr, 0, ele.lid, info);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }



            function modifyLoopName() {
                var o = $("#form2").serializeObject();
                o.id = o.hide_id;

                addlogon(u_name, "修改", o_pid, "回路管理", "修改回路");

                if (o.l_worktype == 3) {

                    for (var i = 0; i < 5; i++) {
                        var time = "time" + (i + 1).toString();
                        var timeval = "timeval" + (i + 1).toString();
                        var o1 = {time: o[time], value: parseInt(o[timeval])};

                        var valobj = JSON.stringify(o1);
                        var val = "l_val" + (i + 1).toString();
                        o[val] = valobj;
                    }


                } else if (o.l_worktype == 5) {
                    for (var i = 0; i < 5; i++) {
                        var scene = "scen" + (i + 1).toString();
                        var val = "val" + (i + 1).toString();
                        var o1 = {scene: o[scene], value: parseInt(o[val])};
                        var valobj = JSON.stringify(o1);
                        var val = "l_val" + (i + 1).toString();
                        o[val] = valobj;
                    }
                } else if (o.l_worktype == 9) {

                    var oo = {infonum: parseInt(o.infonum), offset: parseInt(o.offset)};
                    var oostr = JSON.stringify(oo);
                    o.l_val1 = oostr;
                    for (var i = 0; i < 4; i++) {
                        var info = "info" + (i + 1).toString();
                        var val = "infoval" + (i + 1).toString();
                        var o1 = {info: o[info], value: parseInt(o[val])};
                        var valobj = JSON.stringify(o1);
                        var val = "l_val" + (i + 1 + 1).toString();
                        o[val] = valobj;
                    }
                    console.log(o);
                }



                $.ajax({async: false, url: "loop.loopForm.modifyloop.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        console.log(data);
                        $("#gravidaTable").bootstrapTable('refresh');
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                return  false;
            }

            function modifyModal() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');

                if (selects.length == 0) {
                    //请勾选您要编辑的数据
                    layer.alert(langs1[363][lang], {
                        icon: 6,
                        offset: 'center'
                    });
                    return;
                }
                var select = selects[0];
                console.log(select);

                var o1 = $("#formsearch").serializeObject();
                o1.pid = "${param.pid}";

                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
//                        console.log(data);
                        $("#infonum1").combobox('loadData', data);

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

                $.ajax({async: false, url: "plan.planForm.getSensorPlanBynum1.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
                        console.log(data);
                        for (var i = 0; i < 5; i++) {
                            var a = (i + 1).toString();
                            $("#scen" + a + a).combobox('loadData', data);
                        }
//                        $("#infonum").combobox('loadData', data);

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });







                if (select.l_worktype == 3) {
                    for (var i = 0; i < 5; i++) {
                        var o1 = (i + 1).toString();
                        var str = "l_val" + o1;
                        var timestr = select[str];
                        console.log(timestr)
                        if (isJSON(timestr)) {
                            var objtime = eval('(' + timestr + ')');
                            $("#time" + o1 + o1).spinner('setValue', objtime.time);
                            // $("#timeval" + o1 + o1).val(objtime.value);
                            $("#timeval" + o1 + o1).combobox('setValue', objtime.value);
                        }

                        if (select.l_deplayment == 1) {
                            $("#time" + o1 + o1).spinner('readonly', true);
                            $("#timeval" + o1 + o1).combobox('readonly', true);
                            
                            
                        } else {
                            $("#time" + o1 + o1).spinner('readonly', false);
                            $("#timeval" + o1 + o1).combobox('readonly', false);
                        }


                    }
                } else if (select.l_worktype == 5) {
                    for (var i = 0; i < 5; i++) {
                        var o1 = (i + 1).toString();
                        var str = "l_val" + o1;
                        var timestr = select[str];
                        console.log(timestr)
                        var objtime = eval('(' + timestr + ')');
                        $("#scen" + o1 + o1).combobox('setValue', objtime.scene.toString());
                        $("#scenval" + o1 + o1).val(objtime.value);

                        if (select.l_deplayment == 1) {
                            $("#scen" + o1 + o1).combobox('readonly', true);
                            $("#scenval" + o1 + o1).attr('readonly', true);
                        } else {
                            $("#scen" + o1 + o1).combobox('readonly', false);
                            $("#scenval" + o1 + o1).attr('readonly', false);
                        }


                    }
                } else if (select.l_worktype == 9) {
                    var obj1 = eval('(' + select.l_val1 + ')');
                    $("#infonum1").combobox('setValue', obj1.infonum.toString());
                    $("#offset1").val(obj1.offset == null ? "0" : obj1.offset.toString());

                      if (select.l_deplayment == 1) {
                            $("#offset1").attr('readonly', true);
                            $("#infonum1").combobox('readonly', true)
                        } else {
                             $("#offset1").attr('readonly', false);
                             $("#infonum1").combobox('readonly', false)
                        }




                    for (var i = 0; i < 4; i++) {
                        var o1 = (i + 1 + 1).toString();
                        var o2 = (i + 1).toString();
                        var str = "l_val" + o1;
                        var timestr = select[str];
                        var objtime = eval('(' + timestr + ')');
                        console.log(timestr)
                        $("#info_" + o2 + o2).val(objtime.info.toString());
                        $("#infoval" + o2 + o2).combobox('setValue', objtime.value);

                        if (select.l_deplayment == 1) {
                            $("#info_" + o2 + o2).attr('readonly', true);
                            $("#infoval" + o2 + o2).combobox('readonly', true)
                        } else {
                            $("#info_" + o2 + o2).attr('readonly', false);
                            $("#infoval" + o2 + o2).combobox('readonly', false)
                        }


                    }
                }

                $("#l_comaddr1").combobox('setValue', select.l_comaddr);
                $("#l_deployment").val(select.l_deplayment);
                $("#comaddrname1").val(select.commname);
                $("#l_name1").val(select.l_name);

                $("#hide_id").val(select.lid);
                $("#l_site1").val(select.l_site);
                $("#l_pos1").val(select.l_pos);
                console.log(select.l_worktype);
                $('#l_pos1').attr('readonly', true);
                $('#l_site1').attr('readonly', true);
                if (select.l_deplayment == "1") {
                    $('#l_worktype1').combobox('readonly', true);


                } else if (select.l_deplayment == "0") {
                    $('#l_worktype1').combobox('readonly', false);

                }
                $('#l_worktype1').combobox('setValue', select.l_worktype);
                $('#dialog-edit').dialog('open');

            }

            //搜索
            function  search() {
                var obj = {};
                obj.l_comaddr = $("#l_comaddr").val();
                var busu = $("#busu").val();
                if (busu != "-1") {
                    obj.l_deplayment = busu;
                }
                var opt = {
                    url: "loop.loopForm.getLoopList.action",
                    silent: false,
                    query: obj
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);
            }

            $(function () {

//                $("#add").attr("disabled", true);
//                $("#shanchu").attr("disabled", true);
//                $("#update").attr("disabled", true);
                //                $("#addexcel").attr("disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {
                                if (rs[i].code == "500301" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    $("#addexcel").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "500302" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "500303" && rs[i].enable != 0) {
                                    $("#shanchu").attr("disabled", false);
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
                    //                    url: 'loop.loopForm.getLoopList.action',
                    //服务器url
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
                            field: 'commname',
                            title: '网关名称', //网关名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
//                        {
//                            field: 'l_comaddr',
//                            title: '网关地址',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, 
                        {
                            field: 'l_name',
                            title: "回路名称",
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_site',
                            title: '站号', //站号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },{
                            field: 'l_pos',
                            title: '寄存器位置', //信息点号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },{
                            field: 'l_info',
                            title: '控制点号', //信息点号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },{
                            field: 'l_worktype',
                            title: '工作模式', //控制方式
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == null) {
                                    return value;
                                }
                                if (value == 3) {
                                    return "时间";
                                } else if (value == "5") {
                                    return "场景";
                                } else if (value == 9) {
                                    return "信息点";
                                }
                                return value;
                            }
                        }, {
                            field: 'show',
                            title: '是否首页显示', //是否首页显示
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 1) {
                                    var str = "<span class='label label-success'>" + '是' + "</span>";
                                    return  str;
                                } else {
                                    var str = "<span class='label label-warning'>" + '否' + "</span>";  //未部署
                                    return  str;
                                }
                            }
                        }, {
                            field: 'l_deployment',
                            title: '部署情况', //部署情况
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.l_deplayment == "0") {
                                    var str = "<span class='label label-warning'>" + '未部署' + "</span>";  //未部署
                                    return  str;
                                } else if (row.l_deplayment == "1") {
                                    var str = "<span class='label label-success'>" + '已部署' + "</span>";  //已部署
                                    return  str;
                                }
                            }
                        }],
                    singleSelect: false,
                    clickToSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [10, 20, 40, 80, 160],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        //                        console.info("加载成功");
                    }, queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            pid: "${param.pid}",
                            l_comaddr:$("#l_comaddr").val()   
                        };      
                        return temp;  
                    }, });


                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }

                $('#comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        console.log(row[opts.textField]);
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].name;
                            }

                            $(this).combobox('select', data[0].id);
                        }
                    }, onSelect: function (record) {
                        $("#comaddrname").val(record.name);
                    }
                });


                $("#l_comaddr").combobox({
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
                                data[i].text = data[i].name;
                            }
                            $(this).combobox('select', data[0].id);
                        }

                    },
                    onSelect: function (record) {
                        var obj = {};
                        obj.l_comaddr = record.id;
                        obj.pid = "${param.pid}";
                        var opt = {
                            url: "loop.loopForm.getLoopList.action",
                            query: obj,
                            silent: false
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });

//                $('#excel-file').change(function (e) {
//                    var files = e.target.files;
//                    var fileReader = new FileReader();
//                    fileReader.onload = function (ev) {
//                        try {
//                            var data = ev.target.result,
//                                    workbook = XLSX.read(data, {
//                                        type: 'binary'
//                                    }), // 以二进制流方式读取得到整份excel表格对象
//                                    persons = []; // 存储获取到的数据
//                        } catch (e) {
//                            alert(langs1[348][lang]);  //文件类型不正确
//                            return;
//                        }
//                        // 表格的表格范围，可用于判断表头是否数量是否正确
//                        var fromTo = '';
//                        // 遍历每张表读取
//                        for (var sheet in workbook.Sheets) {
//                            if (workbook.Sheets.hasOwnProperty(sheet)) {
//                                fromTo = workbook.Sheets[sheet]['!ref'];
//                                console.log(fromTo);
//                                persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
//                                // break; // 如果只取第一张表，就取消注释这行
//                            }
//                        }
//                        var headStr = '序号,网关名称,网关地址,回路名称,回路编号,回路组号';
//                        for (var i = 0; i < persons.length; i++) {
//                            if (Object.keys(persons[i]).join(',') !== headStr) {
//                                alert(langs1[366][lang]);   //导入文件格式不正确                                 persons = [];
//                            }
//                        }
//                        console.log("p2:" + persons.length);
//                        $("#warningtable").bootstrapTable('load', []);
//                        if (persons.length > 0) {
//                            $('#warningtable').bootstrapTable('load', persons);
//
//                        }
//                    };
//                    // 以二进制方式打开文件
//                    fileReader.readAsBinaryString(files[0]);
//                });
                //####### Dialogs
                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 390,
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
                    height: 390,
                    position: "top",
                    buttons: {
                        修改: function () {
                            modifyLoopName();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#dialog-excel").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 750,
                    height: 500,
                    position: "top",
                    buttons: {
                        保存: function () {
                            addexcel();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $('#l_worktype').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);
                        }
                    },
                    onSelect: function (record) {
                        $("#l_plan").combobox('clear');
                        if (record.id == "3") {
                            $("#l_plan").combobox({url: 'loop.planForm.getPlanlist.action?attr=0&p_type=0&pid=${param.pid}'});
                            $("#scentable").hide();
                            $("#infotable").hide();
                            $("#timetable").show();
                        } else if (record.id == "5") {
                            $("#l_plan").combobox({url: 'loop.planForm.getPlanlist.action?attr=0&p_type=1&pid=${param.pid}'});
                            $("#timetable").hide();
                            $("#infotable").hide();
                            $("#scentable").show();
                        } else if (record.id == "9") {
                            $("#l_plan").combobox({url: 'loop.planForm.getPlanlist.action?attr=0&p_type=2&pid=${param.pid}'});
                            $("#timetable").hide();
                            $("#scentable").hide();
                            $("#infotable").show();
                        }
                    }
                });
                $('#l_worktype1').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);
                        }
                    },
                    onSelect: function (record) {
                        $("#l_plan1").combobox('clear');
                        if (record.id == "3") {
                            $("#l_plan1").combobox({url: 'loop.planForm.getPlanlist.action?attr=0&p_type=0&pid=${param.pid}'});
                            $("#scentable1").hide();
                            $("#infotable1").hide();
                            $("#timetable1").show();
                        } else if (record.id == "5") {
                            $("#l_plan1").combobox({url: 'loop.planForm.getPlanlist.action?attr=0&p_type=1&pid=${param.pid}'});
                            $("#timetable1").hide();
                            $("#infotable1").hide();
                            $("#scentable1").show();
                        } else if (record.id == "9") {
                            $("#l_plan1").combobox({url: 'loop.planForm.getPlanlist.action?attr=0&p_type=2&pid=${param.pid}'});
                            $("#timetable1").hide();
                            $("#scentable1").hide();
                            $("#infotable1").show();
                        }
                    }
                });
            });

            //添加到首页显示
            function addshow() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }

                for (var i = 0; i < selects.length; i++) {
                    if (selects[i].deplayment == 0) {
                        layerAler('设备未部署不能添加到首页'); //请勾选表格数据
                        return;
                    }
                }

                for (var i = 0; i < selects.length; i++) {
                    var id = selects[i].id;
                    $.ajax({async: false, url: "homePage.loop.addshow.action", type: "get", datatype: "JSON", data: {id: id}, success: function (data) {

                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                    layerAler("添加成功！");
                    var obj = {};
                    obj.l_comaddr = $("#l_comaddr").val();
                    obj.pid = "${param.pid}";
                    var opt = {
                        url: "loop.loopForm.getLoopList.action",
                        query: obj,
                        silent: false
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);
                }


            }

            function removeshow() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }

                for (var i = 0; i < selects.length; i++) {
                    var id = selects[i].id;
                    $.ajax({async: false, url: "homePage.loop.removeshow.action", type: "get", datatype: "JSON", data: {id: id}, success: function (data) {

                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                    layerAler("移除成功！");
                    var obj = {};
                    obj.l_comaddr = $("#l_comaddr").val();
                    obj.pid = "${param.pid}";
                    var opt = {
                        url: "loop.loopForm.getLoopList.action",
                        query: obj,
                        silent: false
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);
                }


            }



        </script>


        <style>* { margin: 0; padding: 0; } 
            /*            body, html { width: 99%; height: 100%; } */

            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 
        </style>
    </head>



    <body id="panemask">


        <!--        <a data-toggle="modal" href="lamp.jsp" data-target="#modal">Click me</a>-->


        <div>
            <form id="formsearch">
                <div>
                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:10px;">
                                        <span >网关名称</span>
                                        &nbsp;</span>
                                </td>
                                <td>

                                    <span class="menuBox">
                                        <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;">
                                        <span id="317" name="xxxx">部署情况</span>
                                        &nbsp;</span>
                                </td>
                                <td>
                                    <select class="easyui-combobox" id="busu" name="l_deplayment" style="width:150px; height: 30px">
                                        <option value="-1">全部</option>   
                                        <option value="1">已部署</option>   
                                        <option value="0">未部署</option>

                                    </select>
                                </td>
                                <td>
                                    <button  type="button" style="margin-left:20px;" onclick="search()" class="btn btn-success btn-xm">
                                        <!-- 搜索-->
                                        筛选
                                    </button>&nbsp;
                                    <button  type="button" style="margin-left:20px;" onclick="deployLoop()" class="btn btn-success btn-xm">
                                        部署
                                    </button>&nbsp;

                                    <button  type="button" style="margin-left:20px;" onclick="removeLoop()" class="btn btn-success btn-xm">
                                        移除
                                    </button>&nbsp;
                                    <!--                                    <button  type="button" style="margin-left:20px;" onclick="readinfo()" class="btn btn-success btn-xm">
                                                                            读取
                                                                        </button>&nbsp;-->

                                </td>
                            </tr>
                        </tbody>
                    </table> 
                </div>
            </form>
        </div>





        <!-- 页面中的弹层代码 -->
        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" onclick="showDialog();" data-toggle="modal" data-target="#pjj5" id="add" >  
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>

            <button class="btn btn-primary ctrol"  onclick="modifyModal();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteloop()"  id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <button class="btn btn-success ctrol" onclick="addshow()">  
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加首页显示
            </button>
            <button class="btn btn-danger ctrol" onclick="removeshow()">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;移除首页显示
            </button>
<!--            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <span >导入Excel</span>
            </button>-->
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                <span >导出Excel</span>
            </button>
        </div>

        <div style="width:100%;">
            <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
            </table>
        </div>



        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="回路添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkLoopAdd()">    
                <input type="hidden" name="pid" value="${param.pid}"/>

                <table >
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" >网关地址</span>&nbsp;
                                <span class="menuBox">

                                    <input id="comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span>  


                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >网关名称</span>&nbsp;
                                <input id="comaddrname" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;">&emsp;&emsp;站号</span>&nbsp;
                                <input id="l_site" class="form-control" name="l_site" style="width:150px;display: inline;" placeholder="站号" type="text">

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">回路名称</span>&nbsp;
                                <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">
                            </td>
                            </td>
                            </td>
                        </tr> 

                        <tr>
                            <td>
                                <span style="margin-left:8px;" >寄存器位置</span>&nbsp;
                                <span class="menuBox">
                                    <input id="l_pos" class="form-control"  name="l_pos" style="width:150px;display: inline;" placeholder="寄存器位置" type="text">
                                </span>
                                <!--                                <span style="margin-left:20px;" >控制点号</span>&nbsp;
                                                                <span class="menuBox">
                                                                    <input id="l_info" class="form-control"  name="l_info" style="width:150px;display: inline;" placeholder="控制点号" type="text">
                                                                </span>-->
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >工作方式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="l_worktype" name="l_worktype"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                        <!--<option value="0">手动</option>-->
                                        <option value="3">时间</option>
                                        <option value="5">场景</option>
                                        <option value="9">信息点</option>
                                    </select>
                                </span>
                            </td>
                        </tr>                 
                    </tbody>
                </table> 

                <table id="timetable" style=" border: 1px solid #888; margin-left: 10px; margin-top: 10px; width: 90%; " class="t">
                    <!--                    <tbody>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;时间一</span>&nbsp;
                                                    <input id="time1" name="time1" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner">
                                                    <span style="margin-left:5px;">控制值一</span>&nbsp;
                                                    <input id="timeval1" class="form-control"  name="timeval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;时间二</span>&nbsp;
                                                    <input id="time2" name="time2" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner">
                                                    <span style="margin-left:5px;">控制值二</span>&nbsp;
                                                    <input id="timeval2" class="form-control"  name="timeval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />&emsp;
                                                </td>
                                            </tr>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;时间三</span>&nbsp;
                                                    <input id="time3" name="time3" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner">
                                                    <span style="margin-left:5px;">控制值三</span>&nbsp;
                                                    <input id="timeval3" class="form-control"  name="timeval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;时间四</span>&nbsp;
                                                    <input id="time4" name="time4" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner">
                                                    <span style="margin-left:5px;">控制值四</span>&nbsp;
                                                    <input id="timeval4" class="form-control"  name="timeval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                                                </td>
                                            </tr>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;时间五</span>&nbsp;
                                                    <input id="time5" name="time5" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner">
                                                    <span style="margin-left:5px;">控制值五</span>&nbsp;
                                                    <input id="timeval5" class="form-control"  name="timeval5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                    
                                                </td>
                                            </tr>                        
                                        </tbody>-->
                    <tr style=" height: 40px;">
                        <th></th>
                        <th>条件1</th>
                        <th>条件2</th>
                        <th>条件3</th>
                        <th>条件4</th>
                        <th>条件5</th>
                    </tr>
                    <tr>
                        <td>时间值</td>
                        <td><input id="time1" name="time1" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner"></td>
                        <td><input id="time2" name="time2" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner"></td>
                        <td><input id="time3" name="time3" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner"></td>
                        <td><input id="time4" name="time4" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner"></td>
                        <td><input id="time5" name="time5" style=" height: 28px; width: 75px;  " value="00:00"  class="easyui-timespinner"></td>
                    </tr>
                    <tr>
                        <td>控制值</td>
                        <td>
                            <select class="easyui-combobox"  id="timeval1" class="form-control"  name="timeval1" style="width:75px;display: inline; height: 30px;" >
                                <option value="1"> 开</option>
                                <option value="0"> 关</option>
                            </select>
                        </td>
                        <td>
                            <select class="easyui-combobox"  id="timeval2" class="form-control"  name="timeval2" style="width:75px;display: inline; height: 30px;" >
                                <option value="1"> 开</option>
                                <option value="0"> 关</option>
                            </select>
                        </td>
                        <td>
                            <select class="easyui-combobox"  id="timeval3" class="form-control"  name="timeval3" style="width:75px;display: inline; height: 30px;" >
                                <option value="1"> 开</option>
                                <option value="0"> 关</option>
                            </select>
                        </td>
                        <td>
                            <select class="easyui-combobox"  id="timeval4" class="form-control"  name="timeval4" style="width:75px;display: inline; height: 30px;" >
                                <option value="1"> 开</option>
                                <option value="0"> 关</option>
                            </select>
                        </td>
                        <td>
                            <select class="easyui-combobox"  id="timeval5" class="form-control"  name="timeval5" style="width:75px;display: inline; height: 30px;" >
                                <option value="1"> 开</option>
                                <option value="0"> 关</option>
                            </select>
                        </td>
                    </tr>
                </table>

                <table id="scentable" style=" border: 1px solid #888; margin-left: 10px; margin-top: 10px; width: 90%; " class="t">
                    <!--                    <tbody>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;场景一</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen1" name="scen1" style="width:100px; height: 30px">
                                                    </select>
                                                    <input id="scen1" class="form-control"  name="scen1" style="width:50px;display: inline;" placeholder="场景1" type="text" />
                                                    <span style="margin-left:10px;">控制值一</span>&nbsp;
                                                    <input id="scenval1" class="form-control"  name="val1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;场景二</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen2" name="scen2" style="width:100px; height: 30px">
                                                    </select>
                                                    <input id="scen2" class="form-control"  name="scen2" style="width:50px;display: inline;" placeholder="场景2" type="text" />
                                                    <span style="margin-left:10px;"  >控制值二</span>&nbsp;
                                                    <input id="scenval2" class="form-control"  name="val2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />&emsp;
                                                </td>
                                            </tr>
                    
                                            <tr id="">
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;场景三</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen3" name="scen3" style="width:100px; height: 30px">
                                                    </select>
                                                    <input id="scen3" class="form-control"  name="scen3" style="width:50px;display: inline;" placeholder="场景3" type="text" />
                                                    <span style="margin-left:10px;">控制值三</span>&nbsp;
                                                    <input id="scenval3" class="form-control"  name="val3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;场景四</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen4" name="scen4" style="width:100px; height: 30px">
                                                    </select>
                                                    <input id="scen4" class="form-control"  name="scen4" style="width:50px;display: inline;" placeholder="场景4" type="text" />
                                                    <span style="margin-left:10px;"  >控制值四</span>&nbsp;
                                                    <input id="scenval4" class="form-control"  name="val4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                                                </td>
                                            </tr>
                    
                                            <tr id="">
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;场景五</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen5" name="scen5" style="width:100px; height: 30px">
                                                    </select>
                                                    <input id="scen5" class="form-control"  name="scen5" style="width:50px;display: inline;" placeholder="场景5" type="text" />
                                                    <span style="margin-left:10px;">控制值五</span>&nbsp;
                                                    <input id="scenval5" class="form-control"  name="val5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                    
                                                </td>
                                            </tr>
                                        </tbody>-->
                    <tbody>
                        <tr style=" height: 40px;">
                            <th></th>
                            <th>条件1</th>
                            <th>条件2</th>
                            <th>条件3</th>
                            <th>条件4</th>
                            <th>条件5</th>
                        </tr>
                        <tr>
                            <td>场景</td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen1" name="scen1" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen2" name="scen2" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen3" name="scen3" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen4" name="scen4" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen5" name="scen5" style="width:100px; height: 30px"></select></td>
                        </tr>
                        <tr>
                            <td>控制值</td>
                            <td><input id="scenval1" class="form-control"  name="val1" style="width:100px;display: inline;" placeholder="控制值1" type="text" /></td>
                            <td><input id="scenval2" class="form-control"  name="val2" style="width:100px;display: inline;" placeholder="控制值2" type="text" /></td>
                            <td><input id="scenval3" class="form-control"  name="val3" style="width:100px;display: inline;" placeholder="控制值3" type="text" /></td>
                            <td><input id="scenval4" class="form-control"  name="val4" style="width:100px;display: inline;" placeholder="控制值4" type="text" /></td>
                            <td><input id="scenval5" class="form-control"  name="val5" style="width:100px;display: inline;" placeholder="控制值5" type="text" /></td>
                        </tr>
                    </tbody>
                </table>
                <table id="infotable" style=" border: 1px solid #888; margin-left: 10px; margin-top: 10px; width: 90%; " class="t">
                    <!--                    <tbody>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >信息点名</span>&nbsp;
                                                    <input  class="form-control" id="infonum" name="infonum" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infonum" name="infonum" style="width:150px; height: 30px">
                                                    </select>
                                                    <span style="margin-left:10px;">偏差值</span>&nbsp;
                                                    <input id="offset" class="form-control"  name="offset" style="width:50px;display: inline;" placeholder="偏差值" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                    
                                                </td>
                                            </tr>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                    <input  class="form-control" id="info_1" name="info1" style="width:50px;display: inline;" placeholder="值" type="text" />
                    
                                                    <span style="margin-left:10px;">控制值</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval1" name="infoval1" style="width:60px; height: 30px">
                                                        <option value="0" >关</option>
                                                        <option value="1" >开</option>
                                                    </select>
                                                    <input id="infoval1" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />&emsp;
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                    <input  class="form-control" id="info_2" name="info2" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                    <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info2" name="info2" style="width:70px; height: 30px">
                                                                                    </select>
                                                    <span style="margin-left:10px;">控制值</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval2" name="infoval2" style="width:60px; height: 30px">
                                                        <option value="0" >关</option>
                                                        <option value="1" >开</option>
                                                    </select>
                                                    <input id="infoval2" class="form-control"  name="infoval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                                                </td>
                                            </tr>
                                            <tr >
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                    <input  class="form-control" id="info_3" name="info3" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                    <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info3" name="info3" style="width:70px; height: 30px">
                                                                                    </select>
                                                    <span style="margin-left:10px;">控制值</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval3" name="infoval3" style="width:60px; height: 30px">
                                                        <option value="0" >关</option>
                                                        <option value="1" >开</option>
                                                    </select>
                                                    <input id="infoval3" class="form-control"  name="infoval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                                                </td>
                                                <td>
                    
                                                </td>
                                                <td>
                                                    <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                    <input  class="form-control" id="info_4" name="info4" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                    <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info4" name="info4" style="width:70px; height: 30px">
                                                                                    </select>
                                                    <span style="margin-left:10px;">控制值</span>&nbsp;
                                                    <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval4" name="infoval4" style="width:60px; height: 30px">
                                                        <option value="0" >关</option>
                                                        <option value="1" >开</option>
                                                    </select>
                                                    <input id="infoval4" class="form-control"  name="infoval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />&emsp;
                                                </td>
                                            </tr>                      
                                        </tbody>-->
                    <tbody>
                        <tr>
                            <td colspan="5"align="left">

                                <span>
                                    信息点:
                                </span>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infonum" name="infonum" style="width:100px; height: 30px"></select>
                                <span style=" margin-left: 100px;">
                                    偏差值:
                                </span>

                                <input id="offset" class="form-control"  name="offset" style="width:50px;display: inline;" placeholder="偏差值" type="text" />
                            </td>

                        </tr>
                        <tr style=" height: 40px;">
                            <th></th>
                            <th>条件1</th>
                            <th>条件2</th>
                            <th>条件3</th>
                            <th>条件4</th>
                        </tr>
                        <tr>
                            <td>读数值</td>
                            <td><input  class="form-control" id="info_1" name="info1" style="width:60px;display: inline;" placeholder="值" type="text" /></td>
                            <td><input  class="form-control" id="info_2" name="info2" style="width:60px;display: inline;" placeholder="值" type="text" /></td>
                            <td><input  class="form-control" id="info_3" name="info3" style="width:60px;display: inline;" placeholder="值" type="text" /></td>
                            <td><input  class="form-control" id="info_4" name="info4" style="width:60px;display: inline;" placeholder="值" type="text" /></td>
                        </tr>
                        <tr>
                            <td>控制值</td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval1" name="infoval1" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval2" name="infoval2" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval3" name="infoval3" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval4" name="infoval4" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>     



            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="回路修改">
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hide_id" name="hide_id" />
                <input type="hidden" name="pid" value="${param.pid}"/>
                <input type="hidden" id="l_deployment" name="l_deployment" />
                <table  >
                    <tbody>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" >&emsp;&emsp;站号</span>&nbsp;
                                <input id="l_site1"  class="form-control" name="l_site" style="width:150px;display: inline;" placeholder="站号" type="text">

                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >回路名称</span>&nbsp;
                                <input id="l_name1" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">
                            </td>
                            </td>
                            </td>
                        </tr> 

                        <tr>
                            <td>
                                <span style="margin-left:8px;" >寄存器位置</span>&nbsp;
                                <span class="menuBox">
                                    <input id="l_pos1"  class="form-control"  name="l_pos" style="width:150px;display: inline;" placeholder="寄存器位置" type="text">
                                </span>
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >工作方式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="l_worktype1" name="l_worktype"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                        <option value="3">时间</option>
                                        <option value="5">场景</option>
                                        <option value="9">信息点</option>
                                    </select>
                                </span>
                            </td>
                        </tr>                 


                    </tbody>
                </table>

                <table id="timetable1" style=" border: 1px solid #888; margin-left: 10px; margin-top: 10px; width: 90%; " class="t">
                    <tbody>
                        <!--                        <tr >
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
                                                        <input id="timeval22" class="form-control"  name="timeval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />&emsp;
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
                                                </tr>                        -->

                        <tr style=" height: 40px;">
                            <th></th>
                            <th>条件1</th>
                            <th>条件2</th>
                            <th>条件3</th>
                            <th>条件4</th>
                            <th>条件5</th>
                        </tr>
                        <tr>
                            <td>时间值</td>
                            <td><input id="time11" name="time1" style=" height: 28px; width: 75px;  "  class="easyui-timespinner"></td>
                            <td><input id="time22" name="time2" style=" height: 28px; width: 75px;  "  class="easyui-timespinner"></td>
                            <td><input id="time33" name="time3" style=" height: 28px; width: 75px;  "  class="easyui-timespinner"></td>
                            <td><input id="time44" name="time4" style=" height: 28px; width: 75px;  "  class="easyui-timespinner"></td>
                            <td><input id="time55" name="time5" style=" height: 28px; width: 75px;  "  class="easyui-timespinner"></td>
                        </tr>
                        <tr>
                            <td>控制值</td>
                            <td>
                                <select class="easyui-combobox"  id="timeval11" class="form-control"  name="timeval1" style="width:75px;display: inline; height: 30px;" >
                                    <option value="1"> 开</option>
                                    <option value="0"> 关</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox"  id="timeval22" class="form-control"  name="timeval2" style="width:75px;display: inline; height: 30px;" >
                                    <option value="1"> 开</option>
                                    <option value="0"> 关</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox"  id="timeval33" class="form-control"  name="timeval3" style="width:75px;display: inline; height: 30px;" >
                                    <option value="1"> 开</option>
                                    <option value="0"> 关</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox"  id="timeval44" class="form-control"  name="timeval4" style="width:75px;display: inline; height: 30px;" >
                                    <option value="1"> 开</option>
                                    <option value="0"> 关</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox"  id="timeval55" class="form-control"  name="timeval5" style="width:75px;display: inline; height: 30px;" >
                                    <option value="1"> 开</option>
                                    <option value="0"> 关</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table id="scentable1" style=" border: 1px solid #888; margin-left: 10px; margin-top: 10px; width: 90%; " class="t">
                    <tbody>
                        <!--                        <tr >
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;场景一</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen11" name="scen1" style="width:100px; height: 30px">
                                                        </select>
                                                        <input id="scen11" class="form-control"  name="scen1" style="width:50px;display: inline;" placeholder="场景1" type="text" />
                                                        <span style="margin-left:10px;">控制值一</span>&nbsp;
                                                        <input id="scenval11" class="form-control"  name="val1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                                                    </td>
                                                    <td>
                        
                                                    </td>
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;场景二</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen22" name="scen2" style="width:100px; height: 30px">
                                                        </select>
                                                        <input id="scen22" class="form-control"  name="scen2" style="width:50px;display: inline;" placeholder="场景2" type="text" />
                                                        <span style="margin-left:10px;"  >控制值二</span>&nbsp;
                                                        <input id="scenval22" class="form-control"  name="val2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />&emsp;
                                                    </td>
                                                </tr>
                        
                                                <tr id="">
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;场景三</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen33" name="scen3" style="width:100px; height: 30px">
                                                        </select>
                                                        <input id="scen33" class="form-control"  name="scen3" style="width:50px;display: inline;" placeholder="场景3" type="text" />
                                                        <span style="margin-left:10px;">控制值三</span>&nbsp;
                                                        <input id="scenval33" class="form-control"  name="val3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                                                    </td>
                                                    <td>
                        
                                                    </td>
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;场景四</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen44" name="scen4" style="width:100px; height: 30px">
                                                        </select>
                                                        <input id="scen44" class="form-control"  name="scen4" style="width:50px;display: inline;" placeholder="场景4" type="text" />
                                                        <span style="margin-left:10px;"  >控制值四</span>&nbsp;
                                                        <input id="scenval44" class="form-control"  name="val4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />
                                                    </td>
                                                </tr>
                        
                                                <tr id="">
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;场景五</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen55" name="scen5" style="width:100px; height: 30px">
                                                        </select>
                                                        <input id="scen55" class="form-control"  name="scen5" style="width:50px;display: inline;" placeholder="场景5" type="text" />
                                                        <span style="margin-left:10px;">控制值五</span>&nbsp;
                                                        <input id="scenval55" class="form-control"  name="val5" style="width:50px;display: inline;" placeholder="控制值5" type="text" />
                                                    </td>
                                                    <td>
                        
                                                    </td>
                                                    <td>
                        
                                                    </td>
                                                </tr>-->
                        <tr style=" height: 40px;">
                            <th></th>
                            <th>条件1</th>
                            <th>条件2</th>
                            <th>条件3</th>
                            <th>条件4</th>
                            <th>条件5</th>
                        </tr>
                        <tr>
                            <td>场景</td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen11" name="scen1" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen22" name="scen2" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen33" name="scen3" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen44" name="scen4" style="width:100px; height: 30px"></select></td>
                            <td><select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="scen55" name="scen5" style="width:100px; height: 30px"></select></td>
                        </tr>
                        <tr>
                            <td>控制值</td>
                            <td><input id="scenval11" class="form-control"  name="val1" style="width:100px;display: inline;" placeholder="控制值1" type="text" /></td>
                            <td><input id="scenval22" class="form-control"  name="val2" style="width:100px;display: inline;" placeholder="控制值2" type="text" />&emsp;</td>
                            <td><input id="scenval33" class="form-control"  name="val3" style="width:100px;display: inline;" placeholder="控制值3" type="text" />&emsp;</td>
                            <td><input id="scenval44" class="form-control"  name="val4" style="width:100px;display: inline;" placeholder="控制值4" type="text" />&emsp;</td>
                            <td><input id="scenval55" class="form-control"  name="val5" style="width:100px;display: inline;" placeholder="控制值5" type="text" />&emsp;</td>
                        </tr>
                    </tbody>
                </table>
                <table id="infotable1" style=" border: 1px solid #888; margin-left: 10px; margin-top: 10px; width: 90%; " class="t">
                    <tbody>

                        <!--                        <tr >
                                                    <td>
                                                        <span style="margin-left:20px;" >信息点号</span>&nbsp;
                                                        <input  class="form-control" id="infonum1" name="infonum" style="width:50px;display: inline;" placeholder="值" type="text" />
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
                                                        <input  class="form-control" id="info_11" name="info1" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                        <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info1" name="info1" style="width:70px; height: 30px">
                                                                                             <input id="infoval1" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />
                                                                                        </select>
                                                        <span style="margin-left:10px;">控制值</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval11" name="infoval1" style="width:60px; height: 30px">
                                                            <option value="0" >关</option>
                                                            <option value="1" >开</option>
                                                        </select>
                                                        <input id="infoval11" class="form-control"  name="infoval1" style="width:50px;display: inline;" placeholder="控制值1" type="text" />&emsp;
                                                    </td>
                                                    <td>
                        
                                                    </td>
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                        <input  class="form-control" id="info_22" name="info2" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                        <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info2" name="info2" style="width:70px; height: 30px">
                                                                                        </select>
                                                        <span style="margin-left:10px;">控制值</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval22" name="infoval2" style="width:60px; height: 30px">
                                                            <option value="0" >关</option>
                                                            <option value="1" >开</option>
                                                        </select>
                                                        <input id="infoval22" class="form-control"  name="infoval2" style="width:50px;display: inline;" placeholder="控制值2" type="text" />
                                                    </td>
                                                </tr>
                                                <tr >
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                        <input  class="form-control" id="info_33" name="info3" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                        <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info3" name="info3" style="width:70px; height: 30px">
                                                                                        </select>
                                                        <span style="margin-left:10px;">控制值</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval33" name="infoval3" style="width:60px; height: 30px">
                                                            <option value="0" >关</option>
                                                            <option value="1" >开</option>
                                                        </select>
                                                        <input id="infoval33" class="form-control"  name="infoval3" style="width:50px;display: inline;" placeholder="控制值3" type="text" />
                                                    </td>
                                                    <td>
                        
                                                    </td>
                                                    <td>
                                                        <span style="margin-left:20px;" >&emsp;&emsp;数值</span>&nbsp;
                                                        <input  class="form-control" id="info_44" name="info4" style="width:50px;display: inline;" placeholder="值" type="text" />
                                                                                        <select class="easyui-combobox" data-options="editable:true,valueField:'id', textField:'text'" id="info4" name="info4" style="width:70px; height: 30px">
                                                                                        </select>
                                                        <span style="margin-left:10px;">控制值</span>&nbsp;
                                                        <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval44" name="infoval4" style="width:60px; height: 30px">
                                                            <option value="0" >关</option>
                                                            <option value="1" >开</option>
                                                        </select>
                                                        <input id="infoval44" class="form-control"  name="infoval4" style="width:50px;display: inline;" placeholder="控制值4" type="text" />&emsp;
                                                    </td>
                                                </tr>                      -->
                        <tr>

                            <td colspan="5"align="left">

                                <span>
                                    信息点:
                                </span>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infonum1" name="infonum" style="width:100px; height: 30px"></select>
                                <span style=" margin-left: 100px;">
                                    偏差值:
                                </span>

                                <input id="offset1" class="form-control"  name="offset" style="width:50px;display: inline;" placeholder="偏差值" type="text" />
                            </td>
                        </tr>
                        <tr style=" height: 40px;">
                            <th></th>
                            <th>条件1</th>
                            <th>条件2</th>
                            <th>条件3</th>
                            <th>条件4</th>
                        </tr>
                        <tr>
                            <td>读数值</td>
                            <td>
                                <input  class="form-control" id="info_11" name="info1" style="width:60px;display: inline;" placeholder="值" type="text" />
                            </td>
                            <td>
                                <input  class="form-control" id="info_22" name="info2" style="width:60px;display: inline;" placeholder="值" type="text" />
                            </td>
                            <td><input  class="form-control" id="info_33" name="info3" style="width:60px;display: inline;" placeholder="值" type="text" /></td>
                            <td><input  class="form-control" id="info_44" name="info4" style="width:60px;display: inline;" placeholder="值" type="text" /></td>
                        </tr>
                        <tr>
                            <td>控制值</td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval11" name="infoval1" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval22" name="infoval2" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval33" name="infoval3" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>

                            </td>
                            <td>
                                <select class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="infoval44" name="infoval4" style="width:60px; height: 30px">
                                    <option value="0" >关</option>
                                    <option value="1" >开</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table> 
            </form>
        </div>


        <div id="dialog-excel"  class="bodycenter"  style=" display: none" title="导入Excel">
            <input type="file" id="excel-file" style=" height: 40px;">
            <table id="warningtable"></table>
        </div>


    </body>
</html>
