<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tld/fn.tld" prefix="fn" %>
<!DOCTYPE html>
<html xmlns:f="http://java.sun.com/jsf/core">
    <head>
        <%@include  file="js.jspf" %>
        <script type="text/javascript" src="js/genel.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache"> 
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <style type="text/css">
            .btn{ margin-left: 20px; }
        </style>
        <script>
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var websocket = null;
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            /**
             * 合并单元格
             * 
             * @param data
             *            原始数据（在服务端完成排序）
             * @param fieldName
             *            合并参照的属性名称
             * @param colspan
             *            合并开始列
             * @param target
             *            目标表格对象	 
             * @param fieldList
             *            要合并的字段集合
             */
            function mergeCells(data, fieldName, colspan, target, fieldList) {
// 声明一个map计算相同属性值在data对象出现的次数和
                var sortMap = {};
                for (var i = 0; i < data.length; i++) {
                    for (var prop in data[i]) {
                        //例如people.unit.name
                        var fieldArr = fieldName.split(".");
                        getCount(data[i], prop, fieldArr, 0, sortMap);
                    }
                }
                var index = 0;
                for (var prop in sortMap) {
                    var count = sortMap[prop];
                    for (var i = 0; i < fieldList.length; i++) {
                        $(target).bootstrapTable('mergeCells', {index: index, field: fieldList[i], colspan: colspan, rowspan: count});
                    }
                    index += count;
                }
            }


            /**
             * 递归到最后一层 统计数据重复次数
             * 比如例如people.unit.name 就一直取到name
             * 类似于data["people"]["unit"]["name"]
             */
            function getCount(data, prop, fieldArr, index, sortMap) {
                if (index == fieldArr.length - 1) {
                    if (prop == fieldArr[index]) {
                        var key = data[prop];
                        if (sortMap.hasOwnProperty(key)) {
                            sortMap[key] = sortMap[key] + 1;
                        } else {
                            sortMap[key] = 1;
                        }
                    }
                    return;
                }
                if (prop == fieldArr[index]) {
                    var sdata = data[prop];
                    index = index + 1;
                    getCount(sdata, fieldArr[index], fieldArr, index, sortMap);
                }

            }


            /**
             * 合并列
             * @param data 原始数据（在服务端完成排序）
             * @param fieldName 合并属性数组
             * @param target 目标表格对象
             */
            function mergeColspan(data, fieldNameArr, target) {
                if (data.length == 0) {
                    alert("不能传入空数据");
                    return;
                }
                if (fieldNameArr.length == 0) {
                    alert("请传入属性值");
                    return;
                }
                var num = -1;
                var index = 0;
                for (var i = 0; i < data.length; i++) {
                    num++;
                    for (var v in fieldNameArr) {
                        index = 1;
                        if (data[i][fieldNameArr[v]] != data[i][fieldNameArr[0]]) {
                            index = 0;
                            break;
                        }
                    }
                    if (index == 0) {
                        continue;
                    }
                    $(target).bootstrapTable('mergeCells', {index: num, field: fieldNameArr[0], colspan: fieldNameArr.length, rowspan: 1});
                }
            }
            function myformatter(date) {
                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                var d = date.getDate() - 1;
                return m + '/' + d + '/' + y;
            }


            function search() {

                var o = $("#form1").serializeObject();
                console.log(o);
                var opt = {
                    url: "param.report.queryRecord.action",
                    query: o
                };
                $('#gravidaTable').bootstrapTable('refresh', opt);

            }





            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                
                var curr_time = new Date();
                $("#dd").datebox("setValue", myformatter(curr_time));
                var val = $("#dd").datebox("getValue");



                $('#comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                            $("#comaddrname").val(data[0].name);
                        }
                    },
                    onSelect: function (record) {
                        $("#comaddrname").val(record.name);

                    }
                });




                var o = $("#form1").serializeObject();
                console.log(o);
                var comaddr = o.comaddr;


                $('#gravidaTable').bootstrapTable({
                    url: 'param.report.queryRecord.action', //test1.report.queryRecord.action
                    columns: [
                        [
                            {
                                field: 'detail',
                                title: langs1[92][lang], //详细数据
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 16
                            }
                        ],
                        [
                            {
                                field: 'dayalis',
                                title: langs1[93][lang], //日期
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2
                            }, {
                                field: 'time',
                                title: langs1[94][lang],  //时间点
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2
                            }, {
                                field: 'voltage',
                                title: langs1[95][lang]+'(V)',  //电压
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 3,
                                rowspan: 1
                            }, {
                                field: 'electric',
                                title: langs1[96][lang]+'(A)',  //电流
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 3,
                                rowspan: 1
                            }, {
                                field: 'activepower',
                                title: langs1[97][lang]+'(KW)', //有功功率
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 3,
                                rowspan: 1
                            }, {
                                field: 'powerfactor',
                                title: langs1[98][lang],  //功率因数
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 4,
                                rowspan: 1
                            }, {
                                field: 'power',
                                title: langs1[99][lang]+'(KW)', //正向有功电能量
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2
                            }
                        ],
                        [

                            {
                                field: 'VAField',
                                title: langs1[100][lang],  //A相
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'VBField',
                                title: langs1[101][lang],  //B相
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'VCField',
                                title: langs1[102][lang],  //C相
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'EAField',
                                title: langs1[100][lang],  //A相
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'EBField',
                                title: langs1[101][lang],  //B相
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ECField',
                                title: langs1[102][lang],  //C相
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ACTIVEAField',
                                title: langs1[103][lang],  //A相有功功率
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ACTIVEBField',
                                title: langs1[104][lang],  //B相有功功率
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ACTIVECField',
                                title: langs1[105][lang],  //C相有功功率
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORAField',
                                title: langs1[106][lang], //A相功率因数
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORBField',
                                title:  langs1[107][lang], //B相功率因数
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORCField',
                                title: langs1[108][lang], //C相功率因数
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORDField',
                                title: langs1[109][lang], //总功率因数
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }
                        ]
                    ],
                    clickToSelect: true,
                    singleSelect: false,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 64,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [64, 128],
                    onLoadSuccess: function (data) {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.log(data);
                        var obj = new Object();
                        var rows = data.rows;
                        var a = new Array();
                        obj.total = 0;
                        obj.rows = new Array();
                        for (var i = 0; i < rows.length; i++) {

                            var row = rows[i];
                            var v = row.voltage;
                            var e = row.electric;
                            var pf = row.powerfactor;

                            var pa = row.activepower;
                            var p = row.power;

                            var josonv = null;
                            var josone = null;
                            var josonpf = null;
                            var josonpa = null;
                            var josonp = null;
                            if (v != null) {
                                josonv = eval('(' + v + ')');
                            }
                            if (e != null) {
                                josone = eval('(' + e + ')');
                            }

                            if (pa != null) {
                                josonpa = eval('(' + pa + ')');
                            }

                            if (pf != null) {
                                josonpf = eval('(' + pf + ')');
                            }

                            if (p != null) {
                                josonp = eval('(' + p + ')');
                            }


                            if (josonv != null) {
                                var voltageArrA = josonv.A.split("|");
                                var voltageArrB = josonv.B.split("|");
                                var voltageArrC = josonv.C.split("|");
                                var z = 0;
                                for (var j = 0; j < josonv.len; j++) {

                                    var o = new Object();
                                    // var o={"VAField":voltageArr[j],"dayalis":row.dayalis};
                                    o.VAField = voltageArrA[j];
                                    o.VBField = voltageArrB[j];
                                    o.VCField = voltageArrC[j];
                                    o.dayalis = row.dayalis;
                                    var a1 = z * 15 % 60;
                                    var a2 = z * 15 / 60;
                                    var time = sprintf("%02d:%02d", a2, a1);
                                    o.time = time;
                                    a.push(o);
                                    z++;

                                }

                            }

                            if (josone != null) {
                                var electricArrA = josone.A.split("|");
                                var electricArrB = josone.B.split("|");
                                var electricArrC = josone.C.split("|");
                                var len1 = a.length >= josone.len ? a.length : josone.len;
                                z = 0;
                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].EAField = electricArrA[j];
                                        a[j].EBField = electricArrB[j];
                                        a[j].ECField = electricArrC[j];
                                    } else {
                                        var o = new Object();
                                        o.EAField = electricArrA[j];
                                        o.EBField = electricArrB[j];
                                        o.ECField = electricArrC[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);

                                    }
                                    z++;

                                }
                            }

                            if (josonpa != null) {
                                var activeArrA = josonpa.A.split("|");
                                var activeArrB = josonpa.B.split("|");
                                var activeArrC = josonpa.C.split("|");
                                var len1 = a.length >= josonpa.len ? a.length : josonpa.len;
                                z = 0;
                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].ACTIVEAField = activeArrA[j];
                                        a[j].ACTIVEBField = activeArrB[j];
                                        a[j].ACTIVECField = activeArrC[j];
                                    } else {
                                        var o = new Object();
                                        o.ACTIVEAField = activeArrA[j];
                                        o.ACTIVEBField = activeArrB[j];
                                        o.ACTIVECField = activeArrC[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);

                                    }
                                    z++;

                                }
                            }

                            if (josonpf != null) {
                                var factorArrA = josonpf.A.split("|");
                                var factorArrB = josonpf.B.split("|");
                                var factorArrC = josonpf.C.split("|");
                                var factorArrD = josonpf.D.split("|");
                                var len1 = a.length >= josonpf.len ? a.length : josonpf.len;
                                z = 0;


                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].FACTORAField = factorArrA[j];
                                        a[j].FACTORBField = factorArrB[j];
                                        a[j].FACTORCField = factorArrC[j];
                                        a[j].FACTORDField = factorArrD[j];

                                    } else {
                                        var o = new Object();
                                        o.FACTORAField = factorArrA[j];
                                        o.FACTORBField = factorArrB[j];
                                        o.FACTORCField = factorArrC[j];
                                        o.FACTORDField = factorArrD[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);
                                    }
                                    z++;
                                }

                            }

                            if (josonp != null) {
                                var powerArrA = josonp.A.split("|");
                                console.log(powerArrA);
                                var len1 = a.length >= josonp.len ? a.length : josonp.len;
                                z = 0;
                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].power = powerArrA[j];

                                    } else {
                                        var o = new Object();
                                        o.power = powerArrA[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);
                                    }
                                    z++;
                                }
                            }

                        }
                        obj.rows = a;
                        $("#gravidaTable").bootstrapTable("load", obj)
                        var data = $('#gravidaTable').bootstrapTable('getData', true);
                        // 合并单元格
                        var fieldList = ["dayalis"];
                        mergeCells(data, "dayalis", 1, $('#gravidaTable'), fieldList);
                    },

                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            day: val,
                            comaddr: o.comaddr
                        };      
                        return temp;  
                    },
                });




            });

            function aaa() {
                var data = $('#gravidaTable').bootstrapTable('getData', true);
                console.log(data);


                //合并单元格
                mergeCells(data, "l_factorycode", 0, $('#gravidaTable'));

//                alert("ddd");
            }

        </script>


    </head>

    <body>


        <div class="row" style=" padding-bottom: 5px;" >
            <div class="col-xs-12">
                <form id="form1">
                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629;">
                        <tbody>
                            <tr>

                                <td>
                                    <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;

                                    <span class="menuBox">
                                        <input id="comaddr" class="easyui-combobox" name="comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                    <span style="margin-left:10px;" name="xxx" id="93">日期</span>&nbsp;
                                    <input id="dd" class="easyui-datebox" name="day" data-options="formatter:myformatter,parser:myparser"></input>
                                    <script type="text/javascript">
                                        function myformatter(date) {
                                            var y = date.getFullYear();
                                            var m = date.getMonth() + 1;
                                            var d = date.getDate();
                                            return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
                                        }
                                        function myparser(s) {
                                            if (!s)
                                                return new Date();
                                            var ss = (s.split('-'));
                                            var y = parseInt(ss[0], 10);
                                            var m = parseInt(ss[1], 10);
                                            var d = parseInt(ss[2], 10);
                                            if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
                                                return new Date(y, m - 1, d);
                                            } else {
                                                return new Date();
                                            }
                                        }
                                    </script>
                                    <button type="button" class="btn btn-sm btn-success" onclick="search()" >
                                        <span name="xxx" id="34">搜索</span>
                                    </button>
                                    <button style=" height: 30px;" type="button" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                                        <span id="110" name="xxx">导出Excel</span>
                                    </button>
                                </td>
                                <td>


                                    <span style=" margin-left: 20px;"></span>
                                </td>
                            </tr>
                        </tbody>
                    </table> 
                </form>
            </div>
        </div>

        <%-- 

            <span style="margin-left:20px;">&nbsp;
                <label class="label label-lg label-success ">日&nbsp;&nbsp;期</label>
            </span>
            <span >
                <!--<input id="dd" type="text" class="easyui-datebox" >-->

                <input id="dd" class="easyui-datebox" data-options="formatter:myformatter,parser:myparser"></input>
                <script type="text/javascript">
                    function myformatter(date) {
                        var y = date.getFullYear();
                        var m = date.getMonth() + 1;
                        var d = date.getDate();
                        return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
                    }
                    function myparser(s) {
                        if (!s)
                            return new Date();
                        var ss = (s.split('-'));
                        var y = parseInt(ss[0], 10);
                        var m = parseInt(ss[1], 10);
                        var d = parseInt(ss[2], 10);
                        if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
                            return new Date(y, m - 1, d);
                        } else {
                            return new Date();
                        }
                    }
                </script>

            </span> 
            <span style="margin-left:20px;">
                <button type="button" class="btn btn-sm btn-success" onclick="search()" >查找</button>
            </span> --%>


        <%-- <div style="width:100%;" id="div1"> --%>

        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>
        <%-- </div> --%>
    </body>
</html>