<%-- 
    Document   : oplog
    Created on : 2018-9-13, 17:50:48
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>操作日志</title>
        <script type="text/javascript" src="js/getdate.js"></script>
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <link rel="stylesheet" type="text/css" href="bootstrap-3.3.7-dist/css/bootstrap.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <script>
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var pid = parent.parent.getpojectId();
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $('#oplogtabel').bootstrapTable({
                    url: 'login.oplog.oplogInfo.action?pid=' + pid,
                    columns: [
                        {
                            field: 'o_time',
                            title: "时间", //时间
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value) {
                                var date = new Date(value);
                                var year = date.getFullYear();
                                var month = date.getMonth() + 1; //月份是从0开始的 
                                var day = date.getDate(), hour = date.getHours();
                                var min = date.getMinutes(), sec = date.getSeconds();
                                var preArr = Array.apply(null, Array(10)).map(function (elem, index) {
                                    return '0' + index;
                                });////开个长度为10的数组 格式为 00 01 02 03 
                                var newTime = year + '-' + (preArr[month] || month) + '-' + (preArr[day] || day) + ' ' + (preArr[hour] || hour) + ':' + (preArr[min] || min) + ':' + (preArr[sec] || sec);
                                return newTime;
                            }
                        }, {
                            field: 'o_page',
                            title: "操作页面", //操作页面
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            sortable: true,
                            sortOrder: "desc"
                        }, {
                            field: 'o_type',
                            title: "操作类型", //操作类型
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            sortable: true,
                            sortOrder: "desc"
                        }, {
                            field: 'o_comment',
                            title: "详细内容", //详细内容
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'o_comaddr',
                            title: "网关名称",
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value) {
                                var name;
                                if (value != "" && value != null) {
                                    var obj = {};
                                    obj.comaddr = value;
                                    $.ajax({url: "homePage.gayway.getnamebycode.action", async: false, type: "get", datatype: "JSON", data: obj,
                                        success: function (data) {
                                            var rs = data.rs;
                                            name = rs[0].name;
                                        },
                                        error: function () {
                                            console.log("提交失败");
                                        }
                                    });
                                }
                                return  name;
                            }
                        }, {
                            field: 'o_name',
                            title: "操作人", //操作人
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            sortable: true,
                            sortOrder: "desc"
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    sortName: 'o_time',
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
                        var v1 = params.sort + " " + params.order;    
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            sort: v1, //排序字段 和 （desc、ase）
                            sortOrder: params.order,
                            statr: $("#sday").val(),
                            end: $("#eday").val(),
                            pid: pid 
                        };      
                        return temp;  
                    },
                });
                $("#select").click(function () {
                    var statr = $("#sday").val();
                    var end = $("#eday").val();
                    var obj = {};

                    if (statr == "" && end == "") {
                        alert(langs1[129][lang]);
                        return;
                    }
                    if (statr == "") {

                        obj.statr = "2017-01-01";
                    } else {
                        obj.statr = statr;
                    }
                    if (end == "") {
                        obj.end = getNowFormatDate2();
                    } else {
                        obj.end = end;
                    }
                    obj.pid = pid;
                    var opt = {
                        url: "login.oplog.oplogInfo.action",
                        silent: true,
                        query: obj
                    };
                    $("#oplogtabel").bootstrapTable('refresh', opt);
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
        <!--        <div style="float:left;position:relative;z-index:100;margin:12px 0 20px 50px; font-size: 18px">
                    <span>搜索时间：<input type="date" id="startime"/></span>
                    <span style="margin-left: 10px">至：<input type="date" id="endtime"/></span>
                    <span><input type="button" class="btn btn-sm btn-success" value="查询" id="select"></span>
                </div>-->
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
                <span name="xxx" id="119">至</span>
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
                    <span id="34" name="xxx">搜索</span>
                </button>
            </span>
            <button style=" height: 30px;" type="button" id="btn_download" class="btn btn-primary" onClick ="$('#oplogtabel').tableExport({type: 'excel', escape: 'false'})">
                <span id="110" name="xxx">导出Excel</span>
            </button>
        </div>
        <div>
            <table id="oplogtabel">

            </table>
        </div>
    </body>
</html>
