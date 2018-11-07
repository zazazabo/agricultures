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
        <title>报警记录</title>
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <link rel="stylesheet" type="text/css" href="bootstrap-3.3.7-dist/css/bootstrap.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script>


            var eventobj = {
                "ERC44": {
                    "status1": {
                        "0": "灯具故障",
                        "1": "温度故障",
                        "2": "超负荷故障",
                        "3": "功率因数过低故障",
                        "4": "时钟故障",
                        "5": "",
                        "6": "灯珠故障",
                        "7": "电源故障"
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC43": {
                    "status1": {
                        "0": "灯杆倾斜",
                        "1": "",
                        "2": "温度预警",
                        "3": "漏电流预警",
                        "4": "相位不符",
                        "5": "线路不符",
                        "6": "台区不符",
                        "7": "使用寿命到期"
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC46": {
                    "status1": {
                        "0": "A相超限",
                        "1": "B相超限",
                        "2": "C相超限",
                        "3": "A相过载",
                        "4": "A相欠载",
                        "5": "B相过载",
                        "6": "B相欠载",
                        "7": "C相过载"
                    },
                    "status2": {
                        "0": "C相欠载",
                        "1": "A相功率因数过低",
                        "2": "B相功率因数过低",
                        "3": "C相功率因数过低",
                        "4": "D相功率因数过低",
                        "5": "",
                        "6": "",
                        "7": ""
                    }
                },
                "ERC47": {
                    "status1": {
                        "0": "配电箱后门开",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC48": {
                    "status1": {
                        "0": "PM2.5设备通信故障",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }

                },
                "ERC51": {
                    "status1": {
                        "0": "线路负荷突增",
                        "1": "线路缺相",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }

                }
            }


            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var pid = parent.parent.getpojectId();

            $(function () {
                $.ajax({
                    url: 'even.json',
                    async: false,
                    success: function (data) {
                        console.log(data);
                    }
                });

                var aaa = $("span[name=xxxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $('#reordtabel').bootstrapTable({
                    url: 'login.policereord.reordInfo.action?pid=' + pid,
                    columns: [
                        {
                            field: 'f_comaddr',
                            title: langs1[120][lang], //设备名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_day',
                            title: '报警时间', //时间
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.replace(".0", "");
                            }
                        }, {
                            field: 'f_type',
                            title: langs1[121][lang], //异常类型
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_comment',
                            title: langs1[123][lang], //异常说明
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                        }
//                        {
//                            field: 'f_setcode',
//                            title: langs1[236][lang], //装置号
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }
                        , {
                            field: 'l_factorycode',
                            title: langs1[292][lang], //灯具编号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'f_detail',
                            title: '详情', //状态字2
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                //console.log(row);
                                var str = "";
                                var info = eventobj[row.f_type];
                                if (typeof info == "object") {
                                    var s1 = info.status1;
                                    var s2 = info.status2;
                                    for (var i = 0; i < 8; i++) {
                                        var temp = Math.pow(2, i);
                                        if ((row.f_status1 & temp) == temp) {
                                            if (s1[i] != "") {
                                                str = str + s1[i] + "|";
                                            }

                                        }
                                    }

                                    for (var i = 0; i < 8; i++) {
                                        var temp = Math.pow(2, i);
                                        if ((row.f_status2 & temp) == temp) {
                                            if (s1[i] != "") {
                                                str = str + s1[i] + "|";
                                            }

                                        }
                                    }

                                    return str.substr(0, str.length - 1);
                                } else {
                                    return  value;
                                }
                            }
                        },
                        {
                            field: 'f_handletime',
                            title: '处理时间', //异常类型
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value) {
                                if (value == null || value == "") {
                                    return  null;
                                } else {
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
                            }
                        },
                        {
                            field: 'f_handlep',
                            title: '处理人', //异常类型
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'f_Isfault',
                            title: langs1[122][lang], //处理状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    var str = "<span class='label label-success'>" + langs1[127][lang] + "</span>";  //已处理
                                    return  str;
                                } else {
                                    var str = "<span class='label label-warning'>" + langs1[128][lang] + "</span>";  //未处理
                                    return  str;
                                }
                            }
                        }

                        // {
                        //     field: 'f_state',
                        //     title: langs1[124][lang], //信息发送状态
                        //     width: 25,
                        //     align: 'center',
                        //     valign: 'middle',
                        //     formatter: function (value, row, index, field) {
                        //         if (value == 0) {
                        //             value = langs1[125][lang];  //已发送
                        //             return value;
                        //         } else if (value == 1) {
                        //             value = langs[126][lang]; //未发送
                        //             return value;
                        //         }
                        //     }
                        // }
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
                            type_id: "1",
                            statr: $("#sday").val(),
                            end: $("#eday").val()
                               
                        };      
                        return temp;  
                    },
                });
                $("#select").click(function () {
                    var statr = $("#sday").val();
                    var end = $("#eday").val();
                    var obj = {};

                    if (statr == "" && end == "") {
                        alert(langs1[129][lang]); //请选择查询的时间段
                        return;
                    }
                    if (statr == "") {

                        obj.statr = "2017-01-01";
                    } else {
                        obj.statr = statr;
                    }
                    if (end == "") {
                        var d = new Date();
                        end = d.toLocaleDateString();
                        obj.end = end;
                    } else {
                        obj.end = end;
                    }
                    obj.pid = pid;
                    var opt = {
                        url: "login.policereord.reordInfo.action",
                        silent: true,
                        query: obj
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


        <%--             <div class="row" style=" margin-top: 10px;">
                        <div class="col-xs-5">

                        <table id="prewarningtable"> 

                        </table> 
                    </div>
                    <div class="col-xs-5">
                        <table id="warningtable"  > 
                        </table> 
                    </div>

                </div>

                <div style=" margin-top: 20px;">

                </div>

            </div> --%>


    </body>
</html>
