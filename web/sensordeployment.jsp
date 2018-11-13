<%-- 
    Document   : deplayment
    Created on : 2018-7-4, 15:32:48
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}'; //'zh_CN';
            var langs1 = parent.parent.getLnas();
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function  readSensorCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
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
                        var strw1 = w1 & 0x01 == 0x01 ? "开关量" : "模拟量";
                        var strw2 = w2 & 0x01 == 0x01 ? "打开" : "关闭";
                        ; //                        var worktype = data[9] * 256 + data[10];
                        var dataval = data[11] * 256 + data[12];
                        var f1 = data[13];
                        var strw3 = f1 & 0x01 == 0x01 ? "有" : "无";
                        var faultnum = data[15] * 256 + data[16];

                        layerAler("信息点:" + info + "<br>" + "站号" + site + "<br>" + "数据位置"
                                + regpos + "<br>" + "工作模式:" + strw1 + "<br>" + "通信故障参数:"
                                + strw2 + "<br>" + "探测值：" + dataval + "<br>" + "故障:" + strw3 + "<br>"
                                + "通信出错次数:" + faultnum);
                    }

                }
                console.log(obj);
            }
            function readSensor() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                var ele = selects[0];
                var vv = [];
                vv.push(1);
                vv.push(3);
                var info = parseInt(ele.infonum);
                var infonum = (2000 + info * 10) | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);
                vv.push(0);
                vv.push(7); //寄存器数目 2字节                         
                var data = buicode2(vv);
                dealsend2("03", data, "readSensorCB", o.l_comaddr, 0, ele.id, info);
            }

            function deploySensorCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (data[1] == 0x10) {
                        var infonum = (2000 + obj.val * 10) | 0x1000;
                        var high = infonum >> 8 & 0xff;
                        var low = infonum & 0xff;
                        if (data[2] == high && data[3] == low) {
                            var str = obj.type == 0 ? "移除成功" : "部署成功";
                            layerAler(str);
                            var obj1 = {id: obj.param, deplayment: obj.type};
                            console.log(obj1);
                            $.ajax({async: false, url: "sensor.sensorform.modifyDepayment.action", type: "get", datatype: "JSON", data: obj1,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {

                                        $("#gravidaTable").bootstrapTable('refresh');
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
            function deploySensor() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                console.log(o);
                var ele = selects[0];
                console.log(ele);
                var vv = [];
                vv.push(1);
                vv.push(0x10);
                var info = parseInt(ele.infonum);
                console.log(info);
                var infonum = (2000 + info * 10) | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);
                vv.push(0);
                vv.push(4); //寄存器数目 2字节
                vv.push(8); //寄存器数目长度  1字节


                vv.push(info >> 8 & 0xff);
                vv.push(info & 0xff); //信息点

                var site = parseInt(ele.sitenum);
                vv.push(site >> 8 & 0xff); //站点
                vv.push(site & 0xff);
                var reg = parseInt(ele.dreg);
                vv.push(reg >> 8 & 0xff)   //寄存器变量值
                vv.push(reg & 0xff);
                var worktype = parseInt(ele.worktype);
                vv.push(worktype >> 8 & 0xff)   //寄存器变量值
                vv.push(worktype & 0xff);
                var data = buicode2(vv);
                dealsend2("10", data, "deploySensorCB", o.l_comaddr, 1, ele.id, info);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function removeSensor() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler('请勾选表格数据'); //请勾选表格数据
                    return;
                }
                var ele = selects[0];
                var vv = [];
                vv.push(1);
                vv.push(0x10);
                var info = parseInt(ele.infonum);
                var infonum = (2000 + info * 10) | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);
                vv.push(0);
                vv.push(4); //寄存器数目 2字节
                vv.push(8); //寄存器数目长度  1字节


                vv.push(info >> 8 & 0xff); //信息点
                vv.push(info & 0xff);
//                var site = parseInt(ele.sitenum);
//                vv.push(site >> 8 & 0xff);   //站点
//                vv.push(site & 0xff);
                vv.push(0); //站点
                vv.push(0);
                vv.push(0); //寄存器变量值
                vv.push(0);
                vv.push(0); //工作方式
                vv.push(0);
//                var reg = parseInt(ele.dreg);
//                vv.push(reg >> 8 & 0xff)   //寄存器变量值
//                vv.push(reg & 0xff);

//                var worktype = parseInt(ele.worktype);
//                vv.push(worktype >> 8 & 0xff)   //寄存器变量值
//                vv.push(worktype & 0xff);

                var data = buicode2(vv);
                dealsend2("10", data, "deploySensorCB", o.l_comaddr, 0, ele.id, info);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            //  var websocket = null;
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $('#l_comaddr').combobox({
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
                            url: "lamp.lampform.getlampList.action",
                            query: obj
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });
                $('#gravidaTable').bootstrapTable({
                    // url: 'lamp.lampform.getlampList.action',
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
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
                            field: 'name',
                            title: '传感器名称', //灯具名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'model',
                            title: '型号', //灯具名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'sitenum',
                            title: '站号', //组号
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }

                            }
                        }, {
                            field: 'dreg',
                            title: '数据位置', //控制方案
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.toString();
                            }
                        }, {
                            field: 'Longitude',
                            title: '经度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: '纬度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'deplayment',
                            title: '部署情况', //部署情况
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == "1") {
                                    var str = "<span class='label label-success'>" + "已部署" + "</span>"; //已部署
                                    return  str;
                                } else {
                                    var str = "<span class='label label-warning'>" + "未部署" + "</span>"; //未部署
                                    return  str;
                                }
                            }
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 50,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [50, 100, 200, 300, 400],
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
                            pid: "${param.pid}",
                        };
                         l_comaddr:'';    
                        return temp;  
                    },
                });
            })
        </script>
    </head>
    <body id="panemask">

        <form id="form1">
            <div class="row">
                <div class="col-xs-12">

                    <table  >
                        <tbody>
                            <tr>
                                <td >
                                    <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;</td>
                                <td>

                                    <input  style="margin-left:10px;" id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:100px; height: 30px" 
                                            data-options="editable:false,valueField:'id', textField:'text' " />
                                </td>
                                <td>
                                    <button style="margin-left:10px;" id="btndeploySensor" onclick="deploySensor()" type="button" class="btn btn-success btn-sm">部署传感器</button>
                                </td>
                                <td>
                                    <button style="margin-left:10px;" id="btnremoveSensor" type="button" onclick="removeSensor()" class="btn btn-success btn-sm">移除传感器</button>
                                </td>
                                <td>
                                    <button style="margin-left:10px;"  type="button" onclick="readSensor()" class="btn btn-success btn-sm">读取传感器信息</button>
                                </td>
                                <!--                                <td>
                                                                    <button style="margin-left:10px;"  type="button" onclick="tourlamp()" class="btn btn-success btn-sm"><span name="xxxx" id="403">巡测灯具状态</span></button>
                                                                </td>-->
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>

        </form> 





        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>



    </body>
</html>