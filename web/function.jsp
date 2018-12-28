<%-- 
    Document   : policereord
    Created on : 2018-9-13, 15:40:10
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>运行记录</title>
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <link rel="stylesheet" type="text/css" href="bootstrap-3.3.7-dist/css/bootstrap.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script>
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var pid = parent.parent.getpojectId();
            $(function () {
                $("#l_comaddr2").combobox({
                    url: "homePage.gayway.getComaddr.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        $(this).combobox('select', data[0].id);
                    },
                    onSelect: function (record) {
                        console.log(record);
                        var l_comaddr = record.id;
                        $("#sensorlist").combobox({
                            url: "homePage.function.gesensroList.action?l_comaddr=" + l_comaddr,
                            onLoadSuccess: function (data) {
                                $(this).combobox('select', data[0].id);
                            }
                        });
                    }
                });
                console.log();
                $('#reordtabel').bootstrapTable({
                    url: 'homePage.function.getdayinfo.action',
                    columns: [
                        {
                            field: 'days',
                            title: "日期",
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'times',
                            title: '时间点', //时间
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.replace(".0", "");
                            }
                        }, {
                            field: 'name',
                            title: "传感器名称",
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'value',
                            title: "数值",
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.type == "1") {
                                    if (parseInt(value) > 0) {
                                        return (parseInt(value) / 10).toString() + "℃";
                                    } else {
                                        return value + "℃";
                                    }
                                } else if (row.type == "2") {
                                    if (parseInt(value) > 0) {
                                        return (parseInt(value) / 10).toString() + "%RH";
                                    } else {
                                        return value + "%RH";
                                    }
                                } else if (row.type == "3") {
                                    if (parseInt(value) == "1") {
                                        return "闭合";
                                    } else {
                                        return "断开";
                                    }
                                }
                            }
                        }
                    ],
                    clickToSelect: true,
                    singleSelect: true,
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
                    pageList: [5, 10, 15, 20, 25],
                    striped: true,
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },

                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type: "1",
                            statr: $("#sday").val(),
                            end: $("#eday").val(),
                            name:encodeURI($("#sensorlist").val()),
                            comaddr:$("#l_comaddr2").val()
                               
                        };      
                        return temp;  
                    }
                });

                $("#select").click(function () {
                    var statr = $("#sday").val();
                    var end = $("#eday").val();
                    var obj = {};
                    obj.type = "ALL";
                    if (statr == "") {

                    } else {
                        obj.statr = statr;
                    }
                    if (end == "") {

                    } else {
                        obj.end = end;
                    }
                    obj.name = encodeURI($("#sensorlist").val());
                    obj.comaddr = $("#l_comaddr2").val();
                    var opt = {
                        url: "homePage.function.getdayinfo.action",
                        query: obj,
                        silent: false
                    };
                    $("#reordtabel").bootstrapTable('refresh', opt);
                });
                $(".day").datetimepicker({
                    format: 'yyyy/mm/dd',
                    language: 'zh-CN',
                    minView: "month",
                    todayBtn: 1,
                    autoclose: 1
                });
            });
        </script>
    </head>
    <body>
        <div style=" margin-top: 10px;"> 
            <span style=" margin-left: 10px;">网关名称：</span>
            <input id="l_comaddr2" name="l_comaddr" class="easyui-combobox"  style="width:150px; height: 30px" 
                   data-options="editable:true,valueField:'id', textField:'text' " />
            <span style=" margin-left: 10px;">传感器：</span>
            <input id="sensorlist" class="easyui-combobox"  style="width:150px; height: 30px" 
                   data-options="editable:true,valueField:'id', textField:'text' " />
        </div>

        <div style="margin-top:15px; font-size: 18px;margin-left: 10px;" id="Day">
            <form action="" id="day1" class="form-horizontal" role="form" style="float:left; width: 166px;">
                <label for="dtp_input2" class="control-label" style="float: left;"></label>
                <input id="dtp_input2" value="" type="hidden">
                <span class="input-group date col-md-2 day" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                    <input id="sday" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </span>
            </form>
            <span style=" font-size: 18px; float: left; margin-top: 4px;">&nbsp;
                <span name="xxxx" id="119">至</span>
                &nbsp;</span>
            <form action="" id="day2" class="form-horizontal" role="form" style="float:left; width: 166px;">
                <label for="dtp_input2" class="control-label" style="float: left;"></label>
                <input id="dtp_input2" value="" type="hidden">
                <span class="input-group date col-md-2 day" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                    <input id="eday" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </span>
            </form>
            <span style="font-size: 18px; margin-left: 10px;">
                <button type="button" class="btn btn-sm btn-success" id="select" >
                    <span name="xxxx" id="34">搜索</span>
                </button>
            </span>
            <button style=" height: 30px;" type="button" id="btn_download" class="btn btn-primary" onClick ="$('#reordtabel').tableExport({type: 'excel', escape: 'false'})">
                <span id="110" name="xxxx">导出Excel</span>
            </button>
        </div>
        <div>
            <table id="reordtabel">

            </table>
        </div>


    </body>
</html>
