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
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>


    </head>
    <script>
        var lang = '${param.lang}';//'zh_CN';
        var langs1 = parent.parent.getLnas();
        $(function () {
            var aaa = $("span[name=xxx]");
            for (var i = 0; i < aaa.length; i++) {
                var d = aaa[i];
                var e = $(d).attr("id");
                $(d).html(langs1[e][lang]);
            }
            $('#project').combobox({
                onSelect: function (record) {
                    if (record.id == "1") {
                        $("#g1").show();
                    } else {
                        $("#g1").hide();
                    }

                }
            });

            $('#comaddr').combobox({
                url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                onLoadSuccess: function (data) {
                    if (Array.isArray(data) && data.length > 0) {
                        $(this).combobox("select", data[0].id);
                        $("#comaddrname").val(data[0].name);
                    }
                }
            });
            $('#querytype').combobox({
                onLoadSuccess: function (data) {
                    if (Array.isArray(data) && data.length > 0) {
                        $(this).combobox("select", data[0].id);
                    }

                },
                onSelect: function (record) {
                    for (var i = 0; i < 3; i++) {
                        var temp = (i + 1).toString();
                        if (temp == record.id) {
                            $("#divv" + temp).show();
                        } else {
                            $("#divv" + temp).hide();
                        }
                    }

                    var v = parseInt(record.id);
                    switchDate(v);

                }
            });

            $("#div1").hide();
            $("#div2").hide();
            $("#div3").show();
            $(".form_datetime").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm-dd', //显示格式
                todayHighlight: 1, //今天高亮
                minView: "month", //设置只显示到月份
                startView: 2,
                forceParse: 0,
                showMeridian: 1,
                autoclose: 1//选择后自动关闭
            });
            $(".form_datetime2").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm', //显示格式
                todayHighlight: 1, //今天高亮
                minView: 3, //设置只显示到月份
                startView: 4,
                forceParse: 0,
                showMeridian: 1,
                autoclose: 1//选择后自动关闭
            });
            $(".form_datetime3").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy', //显示格式
                todayHighlight: 1, //今天高亮
                minView: 4, //设置只显示到月份
                startView: 4,
                forceParse: 0,
                showMeridian: 1,
                autoclose: 1//选择后自动关闭
            });

        });


        function changeTime(num) {
            switch (num) {
                case 1:
                    $("#timeMin").val($("#timeMin1").val());
                    break;
                case 2:
                    $("#timeMax").val($("#timeMax1").val());
                    break;
                case 3:
                    $("#timeMin").val($("#timeMin2").val());
                    break;
                case 4:
                    $("#timeMax").val($("#timeMax2").val());
                    break;
                case 5:
                    $("#timeMin").val($("#timeMin3").val());
                    break;
                case 6:
                    $("#timeMax").val($("#timeMax3").val());
                    break;
            }
        }

        function clearDate()
        {
            $("#timeMin").val('');
            $("#timeMax").val('');
            $("#timeMin1").val('');
            $("#timeMax1").val('');
            $("#timeMin2").val('');
            $("#timeMax2").val('');
            $("#timeMin3").val('');
            $("#timeMax3").val('');
        }
        function switchDate(num) {
            var switchDay = $("#switchDay");
            var switchMonth = $("#switchMonth");
            var switchYear = $("#switchYear");
            clearDate();
            $("#timeType").val(num);
            switch (num) {
                case 1:
                    switchDay.css("background-color", "#cccccc");
                    switchMonth.css("background-color", "#ffffff");
                    switchYear.css("background-color", "#ffffff");
                    $("#div1").show();
                    $("#div2").hide();
                    $("#div3").hide();
                    break;
                case 2:
                    switchDay.css("background-color", "#ffffff");
                    switchMonth.css("background-color", "#cccccc");
                    switchYear.css("background-color", "#ffffff");
                    $("#div1").hide();
                    $("#div2").show();
                    $("#div3").hide();
                    break;
                case 3:
                    switchDay.css("background-color", "#ffffff");
                    switchMonth.css("background-color", "#ffffff");
                    switchYear.css("background-color", "#cccccc");
                    $("#div1").hide();
                    $("#div2").hide();
                    $("#div3").show();
                    break;
            }
            //search();
        }


        $(function () {
            $('#getYearTable').bootstrapTable({
                url: "login.reportmanage.getyear.action?pid=${param.pid}",
                columns: [[{
                            field: '',
                            title: langs1[111][lang], //年消耗量
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 5
                        }], [
                        {
                            field: 'years',
                            title: langs1[113][lang], //年份
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'val',
                            title: langs1[112][lang]+'(KW)', //消耗量
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }]
                ],
                showExport: true, //是否显示导出
                singleSelect: true,
                sortName: 'id',
                locale: 'zh-CN', //中文支持,
                // minimumCountColumns: 7, //最少显示多少列
                showColumns: true,
                sortOrder: 'desc',
                pagination: true,
                sidePagination: 'server',
                pageNumber: 1,
                pageSize: 10,
                showRefresh: false,
                showToggle: true,
                // 设置默认分页为 50
                pageList: [5, 10, 15, 20, 25],
                onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                    console.info("加载成功");
                },
                //服务器url
                queryParams: function (params)  {   //配置参数     
                    var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                        search: params.search,
                        skip: params.offset,
                        limit: params.limit,
                        type_id: "1"   
                    };      
                    return temp;  
                }
            });



            $('#getMotherTable').bootstrapTable({
                columns: [[{
                            field: '',
                            title: langs1[114][lang],  //月消耗量
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 5
                        }], [
                        {
                            field: 'mother',
                            title: langs1[115][lang],  //月份
                            width: 25,
                            align: 'center',
                            valign: 'middle'

                        }, {
                            field: 'val',
                            title: langs1[112][lang]+'(KW)', //消耗量
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }]
                ],
                showExport: true, //是否显示导出
                singleSelect: true,
                sortName: 'id',
                locale: 'zh-CN', //中文支持,
                // minimumCountColumns: 7, //最少显示多少列
                showColumns: true,
                sortOrder: 'desc',
                pagination: true,
                sidePagination: 'server',
                pageNumber: 1,
                pageSize: 10,
                showRefresh: false,
                showToggle: true,
                // 设置默认分页为 50
                pageList: [5, 10, 15, 20, 25],
                onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                    console.info("加载成功");
                },
                //服务器url
                queryParams: function (params)  {   //配置参数     
                    var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                        search: params.search,
                        skip: params.offset,
                        limit: params.limit,
                        type_id: "1"   
                    };      
                    return temp;  
                }
            });

            $('#getdayTable').bootstrapTable({
                columns: [[{
                            field: '',
                            title: langs1[116][lang],  //日消耗量
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 5
                        }], [
                        {
                            field: 'd',
                            title: langs1[93][lang],//日期
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'val',
                            title: langs1[112][lang]+'(KW)', //消耗量
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }]
                ],
                showExport: true, //是否显示导出
                singleSelect: true,
                sortName: 'id',
                locale: 'zh-CN', //中文支持,
                // minimumCountColumns: 7, //最少显示多少列
                showColumns: true,
                sortOrder: 'desc',
                pagination: true,
                sidePagination: 'server',
                pageNumber: 1,
                pageSize: 10,
                showRefresh: false,
                showToggle: true,
                // 设置默认分页为 50
                pageList: [5, 10, 15, 20, 25],
                onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                    console.info("加载成功");
                },
                //服务器url
                queryParams: function (params)  {   //配置参数     
                    var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                        search: params.search,
                        skip: params.offset,
                        limit: params.limit,
                        type_id: "1"   
                    };      
                    return temp;  
                }
            });

        })

        function search() {
            var timeobj = $("#searchForm").serializeObject();
            var o = $("#form1").serializeObject();
            var obj = {};
            if (o.project == "0") {
                obj.pid = "${param.pid}";
            } else if (o.project == "1") {
                obj.comaddr = o.comaddr;
            }


            switch (parseInt(o.querytype)) {
                case 1:
                    {
                        obj.star = timeobj.d1;
                        obj.end = timeobj.d2;
                        var opt = {
                            url: "login.reportmanage.getday.action",
                            silent: false,
                            query: obj
                        };
                        $("#getdayTable").bootstrapTable('refresh', opt);
                    }
                    break;
                case 2:
                    {
                        obj.star = timeobj.m1;
                        obj.end = timeobj.m2;
                        //加载所有网关信息
                        var opt = {
                            url: "login.reportmanage.getmother.action",
                            silent: false,
                            query: obj
                        };
                        $("#getMotherTable").bootstrapTable('refresh', opt);
                    }
                    break;
                case 3:
                    {
                        obj.star = timeobj.y1;
                        obj.end = timeobj.y2;
                        var opt = {
                            url: "login.reportmanage.getyear.action",
                            silent: false,
                            query: obj
                        };

                        $("#getYearTable").bootstrapTable('refresh', opt);
                    }
                    break;
                default:

                    break;
            }
            console.log(o);
            console.log(timeobj);
        }

    </script>
    <body>

        <div class="row" >
            <div class="col-sm-12">
                <form id="form1">
                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>

                                <td>
                                    <span style="margin-left:10px;" id="117" name="xxx">查询方式</span>&nbsp;
                                </td>

                                <td>
                                    <select class="easyui-combobox" id="querytype" data-options='editable:false,valueField:"id", textField:"text" ' name="querytype" style="width:150px; height: 30px">
                                        <option value="3">按年查询</option>
                                        <option value="2">按月查询</option>
                                        <option value="1">按日查询</option>
                                    </select>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;" id="118" name="xxx">查询范围</span>&nbsp;
                                </td>

                                <td>
                                    <select class="easyui-combobox" id="project" name="project" data-options="editable:true,valueField:'id', textField:'text' " style="width:150px; height: 30px">
                                        <option value="0">项目</option>
                                        <option value="1">网关</option>           
                                    </select>
                                    &nbsp;
                                </td>
                                <td id="g1"  style=" display: none">

                                    <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;

                                    <span class="menuBox">
                                        <input id="comaddr" class="easyui-combobox" name="comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                    &nbsp;
                                </td>
                            </tr>


                        </tbody>
                    </table> 
                </form>
            </div>
        </div>



        <form id="searchForm">
            <div class="row" style=" border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; "  >
                <div class="col-sm-3" id="div1" style="display:none">  
                    <div class="input-group input-inline-sm col-sm-12" >  
                        <span class="input-group-addon " id="82" name="xxx" >时间</span>  
                        <input type="text" class="form-control form_datetime" name="d1"  readOnly id="timeMin1" onchange="changeTime(1)">  
                        <span class="input-group-addon" id="119" name="xxx">至</span>  
                        <input type="text" class="form-control form_datetime" name="d2"   readOnly id="timeMax1" onchange="changeTime(2)">
                    </div>
                </div>

                <div class="col-sm-3" id="div2" style="display:none">  
                    <div class="input-group input-inline-sm col-sm-12" >  
                        <span class="input-group-addon " id="82" name="xxx" >时间</span>  
                        <input type="text" class="form-control form_datetime2" name="m1"  readOnly id="timeMin2" onchange="changeTime(3)">  
                        <span class="input-group-addon" id="119" name="xxx">至</span>  
                        <input type="text" class="form-control form_datetime2"  name="m2"   readOnly id="timeMax2" onchange="changeTime(4)">
                    </div>
                </div>

                <div class="col-sm-3" id="div3">  
                    <div class="input-group input-inline-sm col-sm-12" >  
                        <span class="input-group-addon " id="82" name="xxx" >时间</span>  
                        <input type="text" class="form-control form_datetime3" name="y1"  readOnly id="timeMin3" onchange="changeTime(5)">  
                        <span class="input-group-addon" id="119" name="xxx">至</span>  
                        <input type="text" class="form-control form_datetime3" name="y2"   readOnly id="timeMax3" onchange="changeTime(6)">
                    </div>
                </div>

                <div class="col-sm-3">
                    <button type="button" class="btn btn-success btn-sm" onclick="search();">
                        <span id="34" name="xxx">搜索</span>
                    </button>
                </div>
            </div>
        </form>


        <div  id="divv1">
            <table id="getdayTable">
            </table>
        </div>
        <div id="divv2" style="">
            <table id="getMotherTable">
            </table>
        </div>
        <div id="divv3">          
            <table id="getYearTable">
            </table>
        </div>
    </body>
</html>