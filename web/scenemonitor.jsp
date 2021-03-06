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
            var infolist = {};
            var scenenum = null;
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

                $('#table0').bootstrapTable({
//                    url: 'sensor.planForm.getSensorPlan.action',
                    clickToSelect: true,
                    rowStyle: function (row, index) {
                        console.log(scenenum);

                        if (scenenum == row.p_scenenum) {
                            return {css: {"color": "green"}}
                        }

                        return row;
                    },
                    columns: [
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
                        },
                        {
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
                                    var str = infolist[o1] + "&emsp;" + "下限:" + obj.down.toString() + "&emsp;" + "上限:" + obj.up.toString();
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
                                    var str = infolist[o1] + "&emsp;" + "下限:" + obj.down.toString() + "&emsp;" + "上限:" + obj.up.toString();
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
                                    var str = infolist[o1] + "&emsp;" + "下限:" + obj.down.toString() + "&emsp;" + "上限:" + obj.up.toString();
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
                                    var str = infolist[o1] + "&emsp;" + "下限:" + obj.down.toString() + "&emsp;" + "上限:" + obj.up.toString();
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
                                    var str = infolist[o1] + "&emsp;" + "下限:" + obj.down.toString() + "&emsp;" + "上限:" + obj.up.toString();
                                    return str;
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


                $('#gayway').on('check.bs.table', function (row, element) {
                    var l_comaddr = element.comaddr;


                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    console.log(obj);
                    var obj2 = {};
                    obj2.l_comaddr = element.comaddr;
                    obj2.pid = "${param.pid}";
                    obj2.p_comaddr = element.comaddr;
                    var opt = {
                        url: "plan.planForm.getSensorPlan.action",
                        query: obj2,
                        silent: true
                    };

                    $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            for (var i = 0; i < data.length; i++) {
                                var o = data[i];
                                infolist[o.id] = o.text;
                            }
                            $("#table0").bootstrapTable('refresh', opt);
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    getSceneNum(l_comaddr);

                });

                $('#scenenum').combobox({
                    url: "sensor.planForm.getSensorPlanBynum1.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);
                        }
                    }, onSelect: function (record) {
                        $("#scennum").val(record.text);
                    }
                });


            })


            function getSceneNumCB(obj) {
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {
                    v = v + sprintf("%02x", data[i]) + " ";
                }
                console.log(v);


                var sceneval = data[3] * 256 + data[4];
                console.log(scenenum, sceneval);
                if (scenenum != sceneval) {
                    scenenum=sceneval;
                    $("#table0").bootstrapTable('refresh');
                }
//                scenenum = sceneval;
//                console.log("场景:" + sceneval);
//                    var obj2 = {};
//                    obj2.l_comaddr = obj.comaddr;
//                    obj2.pid = "${param.pid}";
//                    obj2.p_comaddr = obj.comaddr;;
//                    var opt = {
//                        url: "plan.planForm.getSensorPlan.action",
//                        query: obj2,
//                        silent: true
//                    };


            }

            function getSceneNum(l_comaddr) {
                var vv = [];
                vv.push(1);
                vv.push(3);
                var infonum = 3800 | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);

                vv.push(0);
                vv.push(2); //寄存器数目 2字节   

                var data = buicode2(vv);
                console.log(data);
                dealsend2("03", data, "getSceneNumCB", l_comaddr, 0, 0, 3800);
            }

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



                    $.ajax({async: false, url: "plan.planForm.getscenenum.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            console.log(data);
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                scenenum = arrlist[0].scenenum
                                var name = arrlist[0].scenename;
                                $("#value2").val(name);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });


                    getSceneNum(l_comaddr);

                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    console.log(obj);
                    var obj2 = {};
                    obj2.l_comaddr = l_comaddr;
                    obj2.pid = "${param.pid}";
                    obj2.p_comaddr = l_comaddr;
                    var opt = {
                        url: "plan.planForm.getSensorPlan.action",
                        query: obj2,
                        silent: true
                    };
                    infolist = {};
                    $.ajax({async: false, url: "sensor.sensorform.getInfoNumList2.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            for (var i = 0; i < data.length; i++) {
                                var o = data[i];
                                infolist[o.id] = o.text;
                            }
//                                console.log(infolist);
                            //$("#table0").bootstrapTable('refresh', opt);
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    $("#table0").bootstrapTable('refresh', opt);
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
                        var infonum = 3800 | 0x1000;
                        var high = infonum >> 8 & 0xff;
                        var low = infonum & 0xff;
                        if (data[2] == high && data[3] == low) {

                            layerAler("设置成功");

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

                var obj = $("#form1").serializeObject();

                var o = {};
                var vv = [];
                vv.push(1);
                vv.push(0x10);               //头指令 
                var infonum = 3800 | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);

                vv.push(0);           //寄存器数目 2字节  
                vv.push(2);   //5
                vv.push(4);           //字节数目长度  1字节 10


                var val2 = parseInt(obj.scenenum);
                vv.push(val2 >> 8 & 0xff);   //场景值
                vv.push(val2 & 0xff);



                var worktype = 0;
                worktype = worktype & 0xfe;
                vv.push(worktype >> 8 & 0xff)   //工作模式
                vv.push(worktype & 0xff);





                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "switchloopCB", l_comaddr, 0, 0, 3800);
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
                        var infonum = 3801 | 0x1000;
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

                var obj = $("#form1").serializeObject();

                var o = {};
                var vv = [];
                vv.push(1);
                vv.push(0x10);               //头指令 
                var infonum = 3801 | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);

                vv.push(0);           //寄存器数目 2字节  
                vv.push(1);   //5
                vv.push(2);           //字节数目长度  1字节 10


                var val2 = parseInt(1);
                vv.push(val2 >> 8 & 0xff);   //场景值
                vv.push(val2 & 0xff);




                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "restoreloopCB", l_comaddr, 0, 0, 3801);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );

            }


        </script>
    </head>
    <body id="panemask">

        <div>
            <div style=" width: 15%; float: left;">
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
                            <!--                            <th data-width="100" data-field="comaddr" data-align="center"   data-formatter='formartcomaddr1'  >网关地址</th>-->
                            <th data-width="100" data-field="name" data-align="center"  data-formatter='formartcomaddr1'   >网关名称</th>
                        </tr>
                    </thead>       

                </table>
                <!--                    </div>
                                </div>    -->

            </div>   
            <div style=" width: 83%; float: left; margin-left: 2%; ">

                <form id="form1">
                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:10px;">
                                        <!-- 合闸开关-->
                                        场景控制
                                        &nbsp;</span>
                                    <select id="scenenum" class="easyui-combobox" data-options="editable:false,valueField:'id', textField:'text'" id="info11" name="scenenum" style="width:100px; height: 30px">
                                    </select>









                                    <!--<input id="value1" name="value1" style="width:100px; height: 30px;" class="form-control" type="text" >-->
                                    <!--        <select class="easyui-combobox" id="switch" name="switch" style="width:100px; height: 30px">
                                               <option value="0">断开</option>
                                               <option value="1">闭合</option>           
                                           </select> -->

                                    <button type="button" id="btnswitch" onclick="switchloop()" class="btn btn-success btn-sm">
                                        设置
                                    </button>
                                    <!--                                    <button type="button" id="btnswitch" onclick="readinfo()" class="btn btn-success btn-sm">
                                                                            读取
                                                                        </button>-->
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
                                <!--                                <td >
                                                                    <input  id="value2" readonly="true" name="value2" style="width:100px; margin-left: 10px; height: 30px;" class="form-control" type="text" >
                                                                    <button  type="button" onclick="tourloop()" class="btn btn-success btn-sm"><span name="xxx" id="454">读取回路状态</span></button>
                                                                    &nbsp;
                                                                </td>-->
                            </tr>


                        </tbody>
                    </table>
                </form>

                <table id="table0" style="width:100%; " class="text-nowrap table table-hover table-striped">

                </table> 
            </div>


        </div>
    </body>
</html>
