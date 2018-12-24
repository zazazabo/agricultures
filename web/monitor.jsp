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
        <style>
            .btn { margin-left: 10px;}
             html {
                height: 100%;
                width: 100%;
                display: table;
            }

            body {
                display: table-cell;
                height: 100%;
                width: 100%;
            }
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
        <script>

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
                        var f1 = data[13] * 256 + data[14];
                        var strw3 = f1 & 0x01 == 0x01 ? "开" : "关";

                        var faultnum = data[15] * 256 + data[16];

                        layerAler("信息点:" + info + "<br>" + "站号:" + site + "<br>" + "数据位置："
                                + regpos + "<br>" + "工作模式:" + strw1 + "<br>" + "通信故障参数:"
                                + strw3 + "<br>" + "探测值：" + dataval + "<br>"
                                + "通信出错次数:" + faultnum);
                    }

                }
                console.log(obj);
            }

            function readSensor(comaddr, infonum) {

                var vv = [];
                vv.push(1);
                vv.push(3);
                var info = parseInt(infonum);
                var infonum = (2000 + info * 10) | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);
                vv.push(0);
                vv.push(7); //寄存器数目 2字节                         
                var data = buicode2(vv);
                dealsend2("03", data, "readSensorCB", comaddr, 0, 0, infonum);
            }


            function toursensor(comaddr, infonum) {
                console.log(comaddr);
                console.log(infonum);
            }
            $(function () {
                $('#gravidaTable').bootstrapTable({
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
                    //url: "loop.loopForm.getLoopList.action",
                    columns: [
                        {
                            //field: 'Number',//可不加  
                            title: '序号', //标题  可不加  
                            align: "center",
                            width: "132px",
                            visible: false,
                            formatter: function (value, row, index) {
                                row.index = index;
                                return index + 1;
                            }
                        },
                        {
                            field: 'name',
                            title: '名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'numvalue',
                            title: '数值',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.type == 3) {
                                    if (value == 0) {
                                        return "关";
                                    } else {
                                        return "开";
                                    }
                                } else {
                                    return value / 10;
                                }
                            }
                        }, {
                            field: 'unit1',
                            title: '单位',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.type == null) {
                                    return value;
                                }

                                if (row.type == "1") {
                                    return  "℃";
                                } else if (row.type == "2") {
                                    return  "%RH";
                                } else if (row.type == 3) {
                                    return  "开/关";
                                }
                            }
                        }, {
                            field: 'onlinetime',
                            title: '运行状态',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                var str = value;
                                if (row.online1 == "1") {
                                    if (row.errflag == "1") {
                                        var str = '<img   src="img/off.png" onclick="readSensor(\'' + row.l_comaddr + '\',\'' + row.infonum + '\'' + ')"/>';
                                        return  str;
                                    } else {
                                        var str = '<img   src="img/online1.png" onclick="readSensor(\'' + row.l_comaddr + '\',\'' + row.infonum + '\'' + ')"/>';
                                        return  str;
                                    }
                                } else {
                                    var str = '<img   src="img/off.png" onclick="readSensor(\'' + row.l_comaddr + '\',\'' + row.infonum + '\'' + ')"/>';
                                    return  str;
                                }
                                return  str;
                            }
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    search: true,
                    locale: 'zh-CN', //中文支持,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 50,
                    showRefresh: false,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [50, 100, 150, 200, 250],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数 
                        var selects = $('#gravidaTable').bootstrapTable('getSelections');
                        var comaddr = "";
                        if (selects.length > 0) {
                            comaddr = selects[0];
                        }
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            pid: "${param.pid}",
                            comaddr: comaddr

                        };      
                        return temp;  
                    }
                });

                $('#gayway').on('check.bs.table', function (row, element) {
                    var l_comaddr = element.comaddr;
                    var vv = [];
                    dealsend2("sensor", "00", "sensorCB", l_comaddr, 0, 0, 0);

                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    var opt = {
                        url: "monitor.monitorForm.getSensorList.action",
                        silent: true,
                        query: obj
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);

                });
            });
            //定时刷新数据
            //setInterval('getcominfo()', 6000);
            function  getcominfo() {
                var selects = $('#gayway').bootstrapTable('getSelections');
                var l_comaddr = selects[0].comaddr;
                var obj = {};
                obj.l_comaddr = l_comaddr;
                obj.pid = "${param.pid}";
                var opt = {
                    url: "monitor.monitorForm.getSensorList.action",
                    silent: true,
                    query: obj
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);
            }

            //计算时间差
            function TimeDifference(time1, time2)
            {

                time1 = new Date(time1.replace(/-/g, '/'));
                time2 = new Date(time2.replace(/-/g, '/'));
                var ms = Math.abs(time1.getTime() - time2.getTime());
                return ms / 1000 / 60;

            }


            function formartcomaddr(value, row, index) {
                if (index == 0) {
                    
                    var l_comaddr = row.comaddr;

                    var vv = [];
                    dealsend2("sensor", "00", "sensorCB", l_comaddr, 0, 0, 0);

                    var l_comaddr = row.comaddr;
                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    var opt = {
                        url: "monitor.monitorForm.getSensorList.action",
                        silent: true,
                        query: obj
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);

                    return {disabled: false, //设置是否可用
                        checked: true//设置选中
                    };

                } else {
                    return {checked: false//设置选中
                    };

                }
            }
            function formartcomaddr1(value, row, index) {
                var val = value;
                var v1 = row.online == 1 ? "&nbsp;<img style='float:right' src='img/online1.png'>" : "&nbsp;<img style='float:right' src='img/off.png'>";
                return  val + v1;
            }
        </script>
    </head>
    <body id="panemask">
        <div>
            <div  style=" width: 15% ; float: left;" >
                <!--                data-height="800"-->
                <table id="gayway" style="width:100%;"    data-toggle="table" 
                       data-single-select="true"
                       data-striped="true"
                       data-click-to-select="true"
                       data-search="false"
                       data-checkbox-header="true"
                       data-url="gayway.GaywayForm.getComaddrList.action?pid=${param.pid}&page=ALL" style="width:200px;" >
                    <thead >
                        <tr >
                            <th data-width="25"    data-select="false" data-align="center" data-formatter='formartcomaddr'  data-checkbox="true"  ></th>
                            <th data-width="100" data-field="name" data-formatter='formartcomaddr1' data-align="center"     >网关名称</th>
                        </tr>
                    </thead>       

                </table>
            </div>   
            <div  style=" width: 83%; float: left; margin-left: 2%;">

                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>
            </div>
        </div>



    </body>
</html>
