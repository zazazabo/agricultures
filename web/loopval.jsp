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
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
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

            $(function () {

                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }

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
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'l_name',
                            title: '回路名称', //
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_site',
                            title: '站号', //
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_info',
                            title: '控制点号', //
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return value;
                            }
                        }, {
                            field: 'l_worktype',
                            title: '工作模式', //合闸参数
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                var type = parseInt(value);
//                                var str = type & 0x1 == 1 ? "自动" : "手动";

                                var str="";
                                if (type >> 1 & 0x1 == 1) {
                                    return "时间"
                                } else if (type >> 2 & 0x1 == 1) {
                                    return '场景' 
                                } else if (type >> 3 & 0x1 == 1) {
                                    return '信息点'
                                } else {
                                    return  str;
                                }
                            }
                        }, {
                            field: 'l_plan',
                            title: '工作方案', //
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                
//                            console.log(isJSON(value))    
                                
                                if(isJSON(value)){
                                     var obj = eval('(' + value + ')');
                                     console.log(obj);
                                     return obj.name;
                                }
                   
//                                var worktype = parseInt(row.l_worktype);
//                                if (worktype >> 1 & 0x1 == 1) {
//                                    var str = row.l_val1;
//                                    var strtime = "";
//                                    for (var i = 0; i < 5; i++) {
//                                        var index = "l_val" + (i + 1).toString();
//                                        var strobj = row[index];
//                                        if (isJSON(strobj)) {
//                                            var obj = eval('(' + strobj + ')');
//                                            strtime = strtime + "时间:" + obj.time + "  " + " 值:" + obj.value + "&emsp;";
//
//                                        }
//                                    }
//                                    // strtime = strtime.substr(0, strtime.length - 1);
//                                    return strtime;
//                                } else if (worktype >> 3 & 0x1 == 1) {
//                                    var strtime = "";
//                                    for (var i = 0; i < 5; i++) {
//                                        var index = "l_val" + (i + 1).toString();
//                                        var strobj = row[index];
//                                        if (isJSON(strobj)) {
//                                            var obj = eval('(' + strobj + ')');
//                                            if (i == 0) {
//                                                strtime = strtime + "信息点号:" + obj.info + "  " + "偏差值:" + obj.value + "&emsp;";
//                                            } else
//                                            {
//                                                strtime = strtime + "信:" + obj.info + "  " + "值:" + obj.value + "&emsp;";
//                                            }
//
//                                        }
//                                    }
//                                    return  strtime;
//                                }
                                return value;
                            }
                        }, {
                            field: 'l_switch',
                            title: '状态', //
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                               if(value ==1){
                                   return "闭合";
                               }else{
                                   return "断开"; 
                               }
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
                    pageSize: 20,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [20, 40, 80, 160, 320],
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
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
                });

                $('#gayway').on('check.bs.table', function (row, element) {
                    var l_comaddr = element.comaddr;
                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    console.log(obj);
//                    var opt = {
//                        url: "loop.loopForm.getLoopList.action",
//                        silent: true,
//                        query: obj
//                    };
//                    $("#gravidaTable").bootstrapTable('refresh', opt);
                });

            })
            function formartcomaddr(value, row, index) {
                if (index == 0) {
                    var l_comaddr = row.comaddr;
                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    obj.l_deplayment = 1;
                    console.log(obj);
                    var opt = {
                        url: "loop.loopForm.getLoopList.action",
                        silent: true,
                        query: obj
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);
                    return {disabled: false, checked: true//设置选中
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

            function switchloopCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (data[1] == 0x10) {
                        var infonum = (3000 + obj.val * 20 + 3) | 0x1000;
                        var high = infonum >> 8 & 0xff;
                        var low = infonum & 0xff;
                        if (data[2] == high && data[3] == low) {
                            var str = obj.type == 0 ? "断开成功" : "闭合成功";
                            var param = {id: obj.param, l_switch: obj.type};
                            $.ajax({async: false, url: "loop.loopForm.modifySwitch.action", type: "get", datatype: "JSON", data: param,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        $("#table_loop").bootstrapTable('refresh');
                                    }
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });

                            layerAler(str);
                            var opt = {
                                url: "loop.loopForm.getLoopList.action",
                                silent: true,
                                query: obj
                            };
                            $("#gravidaTable").bootstrapTable('refresh', opt);




                        }

                    }

                }

            }

            function switchloop() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler('请勾选网关');  //请勾选网关
                }
                var l_comaddr = s2[0].comaddr;
                var o1 = $("#form1").serializeObject();
                console.log(o1);
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请勾选表格数据');  //
                    return;
                }
                var ele = selects[0];
                addlogon(u_name, "设置", o_pid, "回路监控", "设置回路【"+ele.l_name+"】状态");
                var o = {};
                o.l_comaddr = ele.l_comaddr;
                console.log(ele);
                var vv = [];
                vv.push(1);
                vv.push(0x10);               //头指令 
                var info = parseInt(ele.l_info);
                console.log(info);
                var infonum = (3000 + info * 20 + 3) | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);

                vv.push(0);           //寄存器数目 2字节  
                vv.push(2);   //5
                vv.push(4);           //字节数目长度  1字节 10




                var worktype = parseInt(ele.l_worktype);
                worktype = worktype & 0xfe;
                vv.push(worktype >> 8 & 0xff)   //工作模式
                vv.push(worktype & 0xff);



                var val2 = parseInt(o1.switch);
                vv.push(val2 >> 8 & 0xff);   //控制值
                vv.push(val2 & 0xff);

                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "switchloopCB", ele.l_comaddr, o1.switch, ele.lid, info);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function  restoreloopCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (data[1] == 0x10) {
                        var infonum = (3000 + obj.val * 20 + 3) | 0x1000;
                        console.log(infonum);
                        var high = infonum >> 8 & 0xff;
                        var low = infonum & 0xff;
                        if (data[2] == high && data[3] == low) {
                            layerAler("恢复成功");
                        }

                    }

                }

                console.log(obj);
            }
            function restoreloop() {

                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler('请勾选网关');  //请勾选网关
                }
                var l_comaddr = s2[0].comaddr;
                var o1 = $("#form1").serializeObject();
                console.log(o1);
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler('请勾选表格数据');  //
                    return;
                }
                var ele = selects[0];
                var o = {};
                o.l_comaddr = ele.l_comaddr;
                console.log(ele);
                var vv = [];
                vv.push(1);
                vv.push(0x10);               //头指令 
                var info = parseInt(ele.l_info);
                console.log(info);
                var infonum = (3000 + info * 20 + 3) | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);

                vv.push(0);           //寄存器数目 2字节  
                vv.push(1);   //5
                vv.push(2);           //字节数目长度  1字节 10


                var worktype = parseInt(ele.l_worktype);
                vv.push(worktype >> 8 & 0xff)   //工作模式
                vv.push(worktype & 0xff);

                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "restoreloopCB", ele.l_comaddr, 0, 0, info);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );

            }


            function readinfoCB(obj) {
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
                    if (w2 >> 1 & 0x1 == 1) {
                        strworktype = "时间模式";
                    } else if (w2 >> 2 & 1 == 1) {
                        strworktype = "场景模式";
                    } else if (w2 >> 2 & 0x1 == 1) {
                        strworktype = "信息点模式";
                    }
                    ; //                        var worktype = data[9] * 256 + data[10];
                    var dataval = data[11] * 256 + data[12];
                    var isclose = dataval == 0 ? "断开" : "闭合";
                    layerAler("控制点:" + info + "<br>" + "站号" + site + "<br>" + "数据位置"
                            + regpos + "<br>" + "工作模式:" + strw1 + "<br>" + "执行方式:"
                            + strworktype + "<br>" + "闭合状态：" + isclose);
                }
            }

            function readinfo() {
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
        </script>
    </head>
    <body id="panemask">

        <div class="row "   >
            <div class="col-xs-2 " >

                <table id="gayway" style="width:100%;"    data-toggle="table" 
                       data-height="800"
                       data-single-select="true"
                       data-striped="true"
                       data-click-to-select="true"
                       data-search="true"
                       data-checkbox-header="true"
                       data-url="gayway.GaywayForm.getComaddrList.action?pid=${param.pid}&page=ALL" style="width:200px;" >
                    <thead >
                        <tr >
                            <th data-width="25"    data-select="false" data-align="center" data-formatter='formartcomaddr'  data-checkbox="true"  ></th>
                            <th data-width="100" data-field="comaddr" data-align="center"   data-formatter='formartcomaddr1'  >网关地址</th>
                            <!--<th data-width="100" data-field="name" data-align="center"    >网关名称</th>-->
                        </tr>
                    </thead>       

                </table>
                <!--                    </div>
                                </div>    -->

            </div>   
            <div class="col-xs-10">

                <form id="form1">
                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:10px;">
                                        <!-- 合闸开关-->
                                        回路控制
                                        &nbsp;</span>

                                    <select class="easyui-combobox" id="switch" name="switch" style="width:100px; height: 30px">
                                        <option value="0">断开</option>
                                        <option value="1">闭合</option>           
                                    </select>

                                    <button type="button" id="btnswitch" onclick="switchloop()" class="btn btn-success btn-sm">
                                        设置
                                    </button>
                                    <button type="button" id="btnswitch" onclick="readinfo()" class="btn btn-success btn-sm">
                                        读取
                                    </button>
                                    <!--
                                                                        <span style="margin-left:10px;" id="48" name="xxx">回路</span>
                                                                        <select class="easyui-combobox" id="type" name="type" style="width:100px; height: 30px">
                                                                            <option value="0">单个回路</option>
                                                                            <option value="1">所有回路</option>           
                                                                        </select>-->

                                </td>

                                <td>

                                    <button type="button" id="btnswitch" onclick="restoreloop()" class="btn btn-success btn-sm">
                                        恢复自动运行
                                    </button>

                                </td>
                                <td>
                                    <!--<button  type="button" onclick="tourloop()" class="btn btn-success btn-sm"><span name="xxx" id="454">读取回路状态</span></button>-->
                                    &nbsp;
                                </td>
                            </tr>


                        </tbody>
                    </table>
                </form>


                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>
            </div>



        </div>



    </body>
</html>
