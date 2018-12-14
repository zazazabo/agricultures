<%-- 
    Document   : scene
    Created on : 2018-12-3, 13:39:14
    Author     : Administrator
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>* { margin: 0; padding: 0; } 
            /*            body, html { width: 99%; height: 100%; } */
            .pull-right.pagination-detail{display:none;}
            /*          table thead{
                          background-color:  #ddd
                      }*/
            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 
        </style>
        <script>
            var infolist = {};


            function  Search() {
                var obj = {};
                var ooo = $("#form1").serializeObject();
                obj.l_comaddr = ooo.l_comaddr;
                obj.p_comaddr = ooo.l_comaddr;
                obj.pid = "${param.pid}";
                var opt = {
//                                    url: "plan.planForm.getSensorPlan.action",
                    query: obj,
                    silent: false
                };
                $("#table0").bootstrapTable('refresh', opt);
            }

            function editfinish() {
                var ooo = $("#form2").serializeObject();
                for (var i = 0; i < 5; i++) {
                    var ii = (i + 1).toString();
                    var info = "info" + ii;
                    var up = "up" + ii;
                    var down = "down" + ii;
                    var p_scene = "p_scene" + ii;
                    if (isNumber(ooo[info]) == false) {

                        layerAler("请选择信息点");
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
                            Search();
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });










                //sensor.planForm.editSensorScenePlan.action

                return false;

            }


            $(function () {


                $('#table0').bootstrapTable({
//                    url: 'sensor.planForm.getSensorPlan.action',
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
                                return value;
                            }

                        }, {
                            field: 'p_comaddr',
                            title: '网关', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                return value;
                            }
                        },
                        {
                            field: 'p_name',
                            title: '场景名', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                return value;
                            }
                        }, {
                            field: 'p_scenenum',
                            title: '场景号', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }
                            }
                        }, {
                            field: 'p_scene',
                            title: '条件1', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (isJSON(row.p_scene1)) {
                                    var obj = eval('(' + row.p_scene1 + ')');
                                    var o1 = obj.info.toString();
                                    var str = infolist[o1] + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                    return str;
                                }
                            }
                        }, {
                            field: 'p_scene',
                            title: '条件2', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (isJSON(row.p_scene2)) {
                                    var obj = eval('(' + row.p_scene2 + ')');
                                    var o1 = obj.info.toString();
                                    var str = infolist[o1] + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                    return str;
                                }
                            }
                        }, {
                            field: 'p_scene',
                            title: '条件3', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (isJSON(row.p_scene3)) {
                                    var obj = eval('(' + row.p_scene3 + ')');
                                    var o1 = obj.info.toString();
                                    var str = infolist[o1] + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                    return str;
                                }
                            }
                        }, {
                            field: 'p_scene',
                            title: '条件4', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (isJSON(row.p_scene4)) {
                                    var obj = eval('(' + row.p_scene4 + ')');
                                    var o1 = obj.info.toString();
                                    var str = infolist[o1] + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                    return str;
                                }
                            }
                        }, {
                            field: 'p_scene',
                            title: '条件5', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (isJSON(row.p_scene5)) {
                                    var obj = eval('(' + row.p_scene5 + ')');
                                    var o1 = obj.info.toString();
                                    var str = infolist[o1] + "&emsp;" + "上限值:" + obj.up.toString() + "&emsp;" + "下限值:" + obj.down.toString();
                                    return str;
                                }
                            }
                        }, {
                            field: 'p_deployment',
                            title: '部署情况', //信息点
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 1,
                            formatter: function (value, row, index, field) {
                                if (row.p_deployment == "0" || row.p_deployment == null) {
                                    var str = "<span class='label label-warning'>" + '未部署' + "</span>";  //未部署
                                    return  str;
                                } else if (row.p_deployment == "1") {
                                    var str = "<span class='label label-success'>" + '已部署' + "</span>";  //已部署
                                    return  str;
                                }
                            }
                        }
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
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            p_attr: 1,
                            p_type: 1,
                            p_show: 1,
                            type_id: "1",
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
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
                        console.log(record);
                        var obj = {};
                        obj.l_comaddr = record.id;
                        obj.pid = "${param.pid}";
                        obj.p_comaddr = record.id;
                        var opt = {
                            url: "plan.planForm.getSensorPlan.action",
                            query: obj,
                            silent: true
                        };

//                        console.log();

                        $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: obj,
                            success: function (data) {
                                for (var i = 0; i < data.length; i++) {
                                    var o = data[i];
                                    infolist[o.id] = o.text;
                                }
//                                console.log(infolist);
                                $("#table0").bootstrapTable('refresh', opt);
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });


//                        $("#table0").bootstrapTable('refresh', opt);
                    }
                });

                $('#l_plan').combobox({
                    url: "loop.planForm.getPlanlist.action?attr=1&p_type=1&pid=${param.pid}",
                    formatter: function (row) {
                        var v = row.p_name;
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
                    },
                    onSelect: function (record) {
                        console.log(record);
                        $("#scenenum").val(record.p_scenenum);
                        for (var i = 0; i < 5; i++) {
                            var index = (i + 1).toString();
                            var scene = "p_scene" + (i + 1).toString();
                            var obj = eval('(' + record[scene] + ')');

                            $("#info" + index).val(obj.info.toString());
                            $("#up" + index).val(obj.up.toString());
                            $("#down" + index).val(obj.down.toString());


                        }
                    }

                });

                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 500,
                    position: ["top", "top"],
                    buttons: {
                        添加: function () {
                            var bclose = addshow(1);
                            console.log("close", bclose);
                            if (bclose) {
                                $(this).dialog("close");
                                Search();
                            }
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
                            editfinish();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });



            })

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function editshow() {
                var selects = $("#table0").bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请选择表格数据');  //请选择表格数据
                    return false;
                } else if (selects.length > 1) {
                    layerAler('只能编辑单行数据');  //只能编辑单行数据
                    return false;
                }

                var select = selects[0];

                $("#p_name1").val(select.p_name);
                $("#hidden_id").val(select.id);


                var o1 = {l_comaddr: select.p_comaddr, pid: select.pid};
                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
                        console.log(data);
                        for (var i = 0; i < data.length; i++) {
                            var o = data[i];
                        }

                        for (var i = 0; i < 5; i++) {
                            var index = (i + 1).toString();
                            var scene = "p_scene" + (i + 1).toString();
                            var val = select[scene];
                            var obj = eval('(' + val + ')');





                            $("#info" + index + index).combobox('loadData', data);
                            var up = "#up" + index + index;
                            var down = "#down" + index + index;
                            $(up).numberspinner({
                                min: 0,
                                max: 10000,
                                icrement: 1,
                                editable: true
                            })
                            $(up).numberspinner('setValue', obj.up);
                            $(down).numberspinner({
                                min: 0,
                                max: 10000,
                                icrement: 1,
                                editable: true
                            })
                            $(down).numberspinner('setValue', obj.down);

                            $("#info" + index + index).combobox('setValue', obj.info);

                            if (select.p_deployment == 1) {
                                $("#info" + index + index).combobox('readonly', true);
                                $(down).numberspinner('readonly', true);
                                $(up).numberspinner('readonly', true);
                            } else {
                                $("#info" + index + index).combobox('readonly', false);
                                $(down).numberspinner('readonly', false);
                                $(up).numberspinner('readonly', false);
                            }




                        }


                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });




//                for (var i = 0; i < 5; i++) {
//                    var up = "#up" + (i + 1).toString() + (i + 1).toString();
//                    var down = "#down" + (i + 1).toString() + (i + 1).toString();
//                    $(up).numberspinner({
//                        min: 0,
//                        max: 10000,
//                        icrement: 1,
//                        editable: true
//                    })
//
//                    $(down).numberspinner({
//                        min: 0,
//                        max: 10000,
//                        icrement: 1,
//                        editable: true
//                    })
//                }

                // var code = select.p_code;


//                $("#p_scenenum1").combobox('setValue', select.p_scenenum);
//                if (select.p_type == "1") {
//
//                for (var i = 0; i < 5; i++) {
//                    var index = (i + 1).toString();
//                    var scene = "p_scene" + (i + 1).toString();
//                    var val = select[scene];
//                    var obj = eval('(' + val + ')');
//                    console.log(obj);
////                        $("#info" + index + index).combobox('setValue', obj.info.toString());
////                        $("#up" + index + index).spinner("setValue", obj.up.toString());
////                        $("#down" + index + index).spinner("setValue", obj.down.toString());
//                }
//
//                }
                $('#dialog-edit').dialog('open');
                return false;
            }

            function showDialog() {
                var o1 = $("#form1").serializeObject();
                $("#p_comaddr").val(o1.l_comaddr);

                for (var i = 0; i < 5; i++) {
                    var up = "#up" + (i + 1).toString();
                    var down = "#down" + (i + 1).toString();
                    $(up).numberspinner({
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
                }


                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
                        console.log(data);
                        for (var i = 0; i < data.length; i++) {
                            var o = data[i];
                        }

                        for (var i = 0; i < 5; i++) {
                            $("#info" + (i + 1).toString()).combobox('loadData', data);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                var scenearr = {};
                for (var i = 0; i < 10; i++) {
                    scenearr[i.toString()] = i;
                }
                var o = {pid: "${param.pid}", p_comaddr: o1.l_comaddr};
                console.log(o);

                var open = false;
                $.ajax({async: false, url: "plan.planForm.getAllScennum.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        console.log(data);
                        var arrlist = data.rs;
                        for (var i = 0; i < arrlist.length; i++) {
                            var scennum = arrlist[i].p_scenenum;
                            delete scenearr[scennum.toString()];
                        }
                        var arr = [];
                        for (var ii in scenearr) {
                            arr.push(scenearr[ii]);
                        }
                        console.log(arr[0]);
                        if (arr.length > 0) {
                            $("#p_scenenum").val(arr[0].toString());
                            open = true;
                        } else {
                            layerAler("此网关下已有十个场景");
                            return;
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });


//                $('#l_plan').combobox('clear')
//                $('#l_plan').combobox('reload');
                if (open == true) {
                    $('#dialog-add').dialog('open');
                }

                return false;
            }
            function addshow(val) {


                var ooo = $("#formadd").serializeObject();
                ooo.p_attr = 1;
                ooo.p_type=1;
                for (var i = 0; i < 5; i++) {
                    var ii = (i + 1).toString();
                    var info = "info" + ii;
                    var up = "up" + ii;
                    var down = "down" + ii;
                    var p_scene = "p_scene" + ii;

                    if (isNumber(ooo[info]) == false) {

                        layerAler("请选择信息点");
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
                console.log(ooo);
                var ret = false;
                $.ajax({async: false, url: "plan.planForm.addSensorScenePlan2.action", type: "get", datatype: "JSON", data: ooo,
                    success: function (data) {

                        var arrlist = data.rs;
                        console.log(arrlist);
                        if (arrlist.length == 1) {
                            ret = true;
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

                return ret;


            }

            function deployscenPlanCB(obj) {

                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (data[1] == 0x10) {
                        var infonum = (3600 + obj.val * 20) | 0x1000;
                        console.log(infonum);
                        var high = infonum >> 8 & 0xff;
                        var low = infonum & 0xff;
                        if (data[2] == high && data[3] == low) {
                            var str = obj.type == 0 ? "移除成功" : "部署成功";
                            layerAler(str);
                            var param = obj.param;
                            var obj1 = {id: param.id, p_deployment: obj.type};
                            console.log(obj1);
                            $.ajax({async: false, url: "sensor.planForm.editscenDeployment.action", type: "get", datatype: "JSON", data: obj1,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        $("#table0").bootstrapTable('refresh');
                                        // $("#table0").bootstrapTable('updateCell', {index: param.index, field: "p_deployment", value: obj.val});

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

            function readinfoCB(obj) {

            }

            function  removeshow() {
                var selects = $('#table0').bootstrapTable('getSelections');
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }

                for (var i = 0; i < selects.length; i++) {
                    var ooo = selects[i];

                    console.log(ooo);

                    var o = {p_code: ooo.p_code, p_show: 0, p_scenenum: ooo.p_scenenum, id: ooo.id};

                    if (ooo.p_deployment == 1) {
                        layerAler("已部署不能删除");
                        return;
                        continue;
                    }
                    $.ajax({async: false, url: "loop.planForm.deletePlan.action", type: "get", datatype: "JSON", data: o,
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

                $("#table0").bootstrapTable('refresh');

            }

            function deployscenPlan(val) {
                var ooo = $("#form1").serializeObject();
                console.log(ooo);

                var selects = $('#table0').bootstrapTable('getSelections');
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                var ele = selects[0];

                var vv = [];
                vv.push(1);
                vv.push(0x10);
                var scenenum = parseInt(ele.p_scenenum);
                var infonum = 3600 + scenenum * 20 | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);
                vv.push(0);           //寄存器数目 2字节  
                vv.push(20);   //5
                vv.push(40);           //字节数目长度  1字节 10
                for (var j = 0; j < 5; j++) {
                    var scene = "p_scene" + (j + 1).toString();
                    var obj = eval('(' + ele[scene] + ')');
                    if (val == 0) {
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                    } else if (val == 1) {
                        vv.push(obj.info >> 8 & 0xff)   //寄存器变量值
                        vv.push(obj.info & 0xff);
                        vv.push(obj.down >> 8 & 0xff);   //下限
                        vv.push(obj.down & 0xff);
                        vv.push(obj.up >> 8 & 0xff);//上限
                        vv.push(obj.up & 0xff);
                    }

                    vv.push(0);
                    vv.push(0)
                }
                var ooo1 = {id: ele.id, index: ele.index};
                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "deployscenPlanCB", ooo.l_comaddr, val, ooo1, scenenum);

            }

        </script>
        <title>JSP Page</title>
    </head>
    <body id="panemask">
        <form id="form1">

            <input type="hidden" name="p_type" readonly="true"/>
            <input type="hidden" name="pid" value="${param.pid}"/>
            <table id="scentable" style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center" >
                <tbody>
                    <tr>

                        <td>
                            <span style="margin-left:10px;">
                                网关名称
                                &nbsp;</span>
                        </td>
                        <td>

                            <span class="menuBox">
                                <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                       data-options="editable:true,valueField:'id', textField:'text' " />
                            </span>  
                        </td>



                        <td>
                            <button   type="button" style="margin-left: 20px;" onclick="deployscenPlan(1)" class="btn btn-success btn-sm">部署</button>&emsp;
                        </td>
                        <td>
                            <button   type="button" style="margin-left: 20px;" onclick="deployscenPlan(0)" class="btn btn-success btn-sm">移除</button>&emsp;
                        </td>

                    </tr>




                </tbody>
            </table>




        </form>



        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" onclick="showDialog()" data-toggle="modal" data-target="#pjj5" id="add" >  
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>

            <button class="btn btn-primary ctrol"  onclick="editshow();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="removeshow()"  id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <span >导入Excel</span>
            </button>
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                <span >导出Excel</span>
            </button>
        </div>

        <table id="table0" style="width:100%; " class="text-nowrap table table-hover table-striped">
        </table> 

        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="场景方案添加">

            <form action="" method="POST" id="formadd" onsubmit="return addscenPlan()">      
                <input type="hidden" name="pid" value="${param.pid}"/>
                <input type="hidden" id="p_comaddr" name="p_comaddr" value="1"/>
                <input type="hidden" name="p_type" value="1"/>
                <input type="hidden" id="p_scenenum" name="p_scenenum" value=""/>
                <input type="hidden" id="p_show" name="p_show" value="1"/>
                <!--console.log(scennum);-->

                <table>
                    <tbody>
                        <tr>

                            <td>
                                <span >&nbsp;&nbsp;&nbsp;
                                    场景名称
                                </span>&nbsp;
                                <input id="p_name" class="form-control"  name="p_name" style="width:150px;display: inline;" placeholder="场景名称" type="text"></td> 
                            </td>
                            <td></td>
                            <td>
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
                                    场景名称
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
