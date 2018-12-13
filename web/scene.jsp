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

            $(function () {



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
                                data[i].text = data[i].id;
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



                $.ajax({async: false, url: "sensor.sensorform.getInfoNumList.action", type: "get", datatype: "JSON", data: {},
                    success: function (data) {
                        for (var i = 0; i < data.length; i++) {
                            var o = data[i];
                            infolist[o.id] = o.text;
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });




                $('#table0').bootstrapTable({
                    url: 'sensor.planForm.getSensorPlan.action',
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
                            p_show: 1,
                            type_id: "1",
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
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
                            addshow(1);
                            $(this).dialog("close");
                            $("#table0").bootstrapTable('refresh');
                        }, 移除: function () {
                            addshow(0);
                            $(this).dialog("close");
                            $("#table0").bootstrapTable('refresh');
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



            function showDialog() {

                $('#dialog-add').dialog('open');
                return false;
            }
            function addshow(val) {








                var ooo = $("#formadd").serializeObject();
                if (ooo.l_plan == "") {
                    layerAler("请选择方案");
                    return;
                }

                var scenearr = {};
                for (var i = 0; i < 10; i++) {
                    scenearr[i.toString()] = i;
                }
                var o = {pid: "${param.pid}"};
                $.ajax({async: false, url: "plan.planForm.getAllScennum.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
//                        console.log(data);
                        var arrlist = data.rs;
                        console.log(arrlist);

                        for (var i = 0; i < arrlist.length; i++) {
                            var scennum = arrlist[i].p_scenenum;
                            console.log(scennum);
                            delete scenearr[scennum.toString()];
                        }
                        var arr = [];
                        for (var ii in scenearr) {
                           arr.push(scenearr[ii]);
                        }
                        if (arr.length>0) {
                            var aa = arr[0];
                            var o1 = {p_code: ooo.l_plan, p_show: val, p_scenenum: aa};
                            console.log(o1);
                            $.ajax({async: false, url: "sensor.planForm.editscenshow.action", type: "get", datatype: "JSON", data: o1,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        $("table0").bootstrapTable('refresh');
                                    }
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



                return false;

//                var o = {p_code: ooo.l_plan, p_show: val, p_scenenum: ooo.p_scenenum};
//                console.log(o);
//
//                $.ajax({async: false, url: "sensor.planForm.editscenshow.action", type: "get", datatype: "JSON", data: o,
//                    success: function (data) {
//                        var arrlist = data.rs;
//                        if (arrlist.length == 1) {
//                            $("table0").bootstrapTable('refresh');
//                        }
//                    },
//                    error: function () {
//                        alert("提交失败！");
//                    }
//                });


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
                    var o = {p_code: ooo.p_code, p_show: 0, p_scenenum: ooo.p_scenenum};


                    $.ajax({async: false, url: "sensor.planForm.editscenshow.action", type: "get", datatype: "JSON", data: o,
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
                                网关地址
                                &nbsp;</span>
                        </td>
                        <td>

                            <span class="menuBox">
                                <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                       data-options="editable:true,valueField:'id', textField:'text' " />
                            </span>  
                        </td>




                        <td>


                            <!--                                 <span style="margin-left:8px;" >场景方案</span>&nbsp;
                                                            <span class="menuBox">
                                                                <select class="easyui-combobox" id="l_plan" name="l_plan"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                            
                                                                </select>
                                                            </span> -->



                        </td>


                        <td>
                            <button   type="button" style="margin-left: 20px;" onclick="showDialog()" class="btn btn-success btn-sm">添加</button>&emsp;
                        </td>
                        <td>
                            <button   type="button" style="margin-left: 20px;" onclick="deployscenPlan(1)" class="btn btn-success btn-sm">部署</button>&emsp;
                        </td>
                        <td>
                            <button   type="button" style="margin-left: 20px;" onclick="deployscenPlan(0)" class="btn btn-success btn-sm">移除</button>&emsp;
                        </td>

                        <td>
                            <button   type="button" style="margin-left: 20px;" onclick="removeshow()" class="btn btn-success btn-sm">删除</button>&emsp;
                        </td>
                    </tr>




                </tbody>
            </table>




        </form>





        <table id="table0" style="width:100%; " class="text-nowrap table table-hover table-striped">
        </table> 

        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="场景方案添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkLoopAdd()">    

                <table id="scentable" style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center" >
                    <tbody>
                        <tr >
                            <td>

                                <span style="margin-left:20px;" >&emsp;&emsp;场景方案</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="l_plan" name="l_plan"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          

                                    </select>
                                </span>




                            </td>

                            <td>

                                <!-- <input  id="info1" name="info1" readonly="true" style="width:100px; height: 30px;"  > -->
                                <!-- <input id="scenenum"  name="scenenum"  readonly="true" class="form-control" style="width:100px;display: inline;" type="text"> -->
<!--                                <span style="margin-left: 20px;"  >
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

                            <td>

                            </td>

                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号一</span>&nbsp;
                                <!-- <input  id="info1" name="info1" readonly="true" style="width:100px; height: 30px;"  > -->
                                <input id="info1"  name="info1"  readonly="true" class="form-control" style="width:100px;display: inline;" type="text">

                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up1" style="width:100px; height: 30px; display: inline;" class="form-control" readonly="true"  type="text" name="up1">


                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down1" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="down1">&emsp;
                            </td>

                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号二</span>&nbsp;
                                <input  id="info2" name="info2" readonly="true" class="form-control" type="text" style="width:100px; height: 30px;"  >
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up2" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="up2">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down2" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="down2">
                            </td>


                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号三</span>&nbsp;
                                <input  id="info3" name="info3" readonly="true" class="form-control" type="text" style="width:100px; height: 30px;"  >
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up3" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="up3">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down3" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="down3">
                            </td>


                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号四</span>&nbsp;
                                <input  id="info4" name="info4" readonly="true" style="width:100px; height: 30px;" class="form-control" type="text"  >
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up4" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="up4">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down4" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="down4">
                            </td>

                        </tr>

                        <tr >
                            <td>
                                <span style="margin-left:20px;" >&emsp;信息点号五</span>&nbsp;
                                <input  id="info5" name="info5" readonly="true" style="width:100px; height: 30px;" class="form-control" type="text" >
                            </td>

                            <td>
                                <span style="margin-left:20px;">上限值</span>&nbsp;
                                <input id="up5" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="up5">

                            </td>

                            <td>
                                <span style="margin-left:20px;" >下限值</span>&nbsp;
                                <input id="down5" style="width:100px; height: 30px;" class="form-control" type="text" readonly="true" name="down5">
                            </td>

                        </tr>
                    </tbody>
                </table>

            </form>                        
        </div>




    </body>
</html>
