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
            function tourloopCB(obj) {
                $('#panemask').hideLoading();
                var v = Str2BytesH(obj.data);
                var s = "";
                for (var i = 0; i < v.length; i++) {

                    s = s + sprintf("%02x", v[i]) + " ";
                }
                var s1 = v[72];
                var a1 = s1 & 1 == 1 ? "手动" : "自动";
                var a2 = s1 >> 1 & 1 == 1 ? "经纬度" : "时间表";
                var a3 = s1 >> 2 & 1 == 1 ? "闭合" : "断开"

                var l_switch = s1 >> 2 & 1 == 1 ? 85 : 170;
                var str = "运行方式:" + a1 + "<br>" + "运行方案:" + a2 + "<br>" + "当前状态:" + a3;
                var o = {id: obj.val, l_switch: l_switch};
                $.ajax({async: false, url: "loop.loopForm.modifySwitch.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            var selects = $('#gravidaTable').bootstrapTable('getSelections');
                            var ele = selects[0];
                            console.log(ele);
                            $("#gravidaTable").bootstrapTable('updateCell', {index: ele.index, field: "l_switch", value: l_switch});





                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

                layerAler(str);

            }
            function tourloop() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]); //请勾选表格数据
                    return;
                }

                var o1 = $("#form1").serializeObject();
                var ele = selects[0];
                console.log(ele);
                var vv = [];
                var setcode = ele.l_code;
                var l_code = parseInt(setcode);
                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(b);//装置序号  2字节            
                vv.push(a);//装置序号  2字节              
                var num = randnum(0, 9) + 0x70; //随机帧序列号
                var comaddr = ele.l_comaddr;
                var data = buicode(comaddr, 0x04, 0xAC, num, 0, 608, vv); //0320    
                dealsend2("AC", data, 608, "tourloopCB", comaddr, 0, 0, ele.id);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function switchloopCB(obj) {
                $('#panemask').hideLoading();
                console.log(obj);
                if (obj.status == "success") {
                    var param = obj.param;
                    var o = {};
                    o.id = param.id;
                    o.l_switch = obj.val;
                    $.ajax({async: false, url: "loop.loopForm.modifySwitch.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_switch", value: obj.val});
                            layerAler(langs1[328][lang]);  //回路控制成功
                            //$("#gravidaTable").bootstrapTable('refresh');
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                }
            }
            function switchloop() {
                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;
                var o1 = $("#form1").serializeObject();
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);  //请勾选表格数据
                    return;
                }
                var select = selects[0];
                if (select.l_deplayment == "0") {
                    layerAler(langs1[330][lang]); //请部署后再操作
                    return;
                }


                var switchval = o1.switch;

                var vv = new Array();
                var c = parseInt(select.l_code);
                var h = c >> 8 & 0x00ff;
                var l = c & 0x00ff;
                vv.push(l);
                vv.push(h); //装置序号  2字节

                vv.push(parseInt(switchval));
                var num = randnum(0, 9) + 0x70;
                var param = {};

                param.row = select.index;
                param.id = select.id;

                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 208, vv); //01 03 F24     
                addlogon(u_name, "合闸开关", o_pid, "回路断合闸", "回路断合闸", l_comaddr);
                dealsend2("A5", data, 208, "switchloopCB", l_comaddr, o1.type, param, switchval);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function restoreloopCB(obj) {
                $('#panemask').hideLoading();
                console.log(obj);
                if (obj.status == "success") {
                    layerAler(langs1[308][lang]); //恢复成功
                }

            }
            function restoreloop() {
                var s2 = $('#gayway').bootstrapTable('getSelections');
                if (s2.length == 0) {
                    layerAler("请勾选网关");
                }
                var l_comaddr = s2[0].comaddr;

                var o1 = $("#form1").serializeObject();
                if (o1.type == "0") {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler(langs1[73][lang]);  //请勾选表格数据
                        return;
                    }
                    var select = selects[0];
                    var vv = new Array();
                    var c = parseInt(select.l_code);
                    var h = c >> 8 & 0x00ff;
                    var l = c & 0x00ff;
                    vv.push(l);
                    vv.push(h); //装置序号  2字节
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 280, vv); //01 03 F24     
                    addlogon(u_name, "恢复自动运行", o_pid, "回路断合闸", "恢复回路自动运行", l_comaddr);
                    dealsend2("A5", data, 280, "restoreloopCB", l_comaddr, o1.type, 0, 0);
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 10000);
                        }
                    }
                    );
                } else if (o1.type == "1") {
       
                    var vv = new Array();
                    var switchval = o1.switch;
                    vv.push(parseInt(switchval));
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 240, vv); //01 03 F24     
                    addlogon(u_name, "恢复自动运行", o_pid, "回路断合闸", "恢复回路自动运行", l_comaddr);
                    dealsend2("A5", data, 240, "restoreloopCB", l_comaddr, o1.type, 0, 0);
                    $('#panemask').showLoading({
                        'afterShow': function () {
                            setTimeout("$('#panemask').hideLoading()", 10000);
                        }
                    }
                    );
                }
            }
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {

                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                });

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
                            field: 'l_name',
                            title: langs1[331][lang], //回路名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_code',
                            title: langs1[315][lang], //装置序号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_groupe',
                            title: langs1[332][lang], //组号
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                var groupe = value.toString();
                                return  groupe;
                            }
                        }, {
                            field: 'l_switch',
                            title: '状态', //合闸参数
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 170) {
                                    return langs1[340][lang];  //断开
                                } else if (value == 85) {
                                    return langs1[339][lang];  //闭合
                                }

//                                var groupe = value.toString();
//                                return  groupe;
                            }
                        }, {
                            field: 'l_deployment',
                            title: langs1[317][lang], //部署情况
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.l_deplayment == "0") {
                                    var str = "<span class='label label-warning'>" + langs1[318][lang] + "</span>";  //未部署
                                    return  str;
                                } else if (row.l_deplayment == "1") {
                                    var obj1 = {index: index, data: row};
                                    var str = "<span class='label label-success'>" + langs1[319][lang] + "</span>";  //已部署
                                    return  str;
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
                    var opt = {
                        url: "loop.loopForm.getLoopList.action",
                        silent: true,
                        query: obj
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);

                });






            })
            function  formartcomaddr(value, row, index, field) {
                console.log(row);
                var val = value;
                var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                return  val + v1;
            }

        </script>
    </head>
    <body id="panemask">

        <div class="row "   >
            <div class="col-xs-2 " >

<!--                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 align='center' class="panel-title">
                            网关列表
                        </h3>
                    </div>
                    <div class="panel-body">-->
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
                                    <th data-width="25"    data-select="false" data-align="center"  data-checkbox="true"  ></th>
                                    <th data-width="100" data-field="comaddr" data-align="center" data-formatter='formartcomaddr'   >网关地址</th>
                                    <!--<th data-width="100" data-field="name" data-align="center"    >网关名称</th>-->
                                </tr>
                            </thead>       

                        </table>
<!--                    </div>
                </div>    -->

            </div>   
            <div class="col-xs-10">

                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>
            </div>



        </div>



    </body>
</html>
