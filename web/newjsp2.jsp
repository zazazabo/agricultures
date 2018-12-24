<%-- 
    Document   : newjsp1
    Created on : 2018-8-6, 18:19:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>



        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="js/genel.js"></script>
        <script src="echarts/dist/echarts_3.8.5_echarts.min.js"></script>
        <script src="js/chart/chart.js"></script>
        <link rel="stylesheet" href="bootstrap-3.3.7-dist/css/bootstrap.css" type="text/css">
        <style type="text/css">
            .topCenter1 {

                margin-left: 3%;
                margin-top: 20px;
            }

        </style>



    </head>
    <body id="activity_pane" style=" height: 100%;">
        <div style=" width: 70%; height: 800px; float: left">
            <div class="topCenter1" id="echarts1" style="width: 90%; height: 98%; ">

            </div>
        </div>
<!--        <div style=" width: 70%; height: 400px; float:  left; margin-top: 20px;">
            <div class="topCenter1" id="echarts2" style="width: 90%; height: 98%; ">

            </div>
        </div>-->
        <div style=" width: 30%; height: 800px; float: left; margin-top: 10px; overflow-x: scroll;">
            <table id="kgtype"></table>
        </div>
    </body>
    <script>
        //动态创建折线对象

        function functionNodname(data) {
            console.log(data);
            var series = [];
            for (var p = 0; p < data.length; p++) {
                var xyData = [];
                xyData = data[p].data;
                var item = {
                    name: data[p].name,
                    type: 'line',
                    data: xyData
                };

                series.push(item);
            }

            return series;

        }
        //温度
        function wd(id, qxbs, xdata, data, unit) {
            wdChart = echarts.init(document.getElementById(id));
            option = {
                title: {
                    text: '温度曲线图'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: qxbs
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: xdata
                },
                yAxis: {
                    type: 'value',
                    axisLabel: {
                        formatter: '{value} ' + unit
                    }
                },
                series: functionNodname(data)
            };
            wdChart.setOption(option);
        }
        //湿度
        function echarts3(id, qxbs, xdata, data) {
            myChart3 = echarts.init(document.getElementById(id));
            option = {
                title: {
                    text: '湿度曲线图'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: qxbs
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: xdata
                },
                yAxis: {
                    type: 'value',
                    axisLabel: {
                        formatter: '{value} '
                    }
                },
                series: functionNodname(data)
            };
            myChart3.setOption(option);
        }

        $(function () {
            var wdrs;
            var sdrs;
            var pid = parent.getpojectId();
            var obj = {};
            obj.pid = pid;

            $.ajax({async: false, url: "homePage.homePage.getSensorList.action", type: "get", datatype: "JSON", data: obj,
                success: function (data) {
                    wdrs = data.wdrs;
                    sdrs = data.sdrs;
                },
                error: function () {
                    alert("提交失败！");
                }
            });

            //['邮件营销', '联盟广告', '视频广告', '直接访问', '搜索引擎', 'wshadd']
//            var qxbs = [];  //曲线标识
//            var xdata = [];      //x轴描述 ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
//            var data = [];
//            if (wdrs.length > 0) {
//                var name = "";
//                for (var i = 0; i < wdrs.length; i++) {
//                    xdata.push(wdrs[i].times.substring(0,5));
//                    if (name == wdrs[i].name) {
//                        continue;
//                    } else {
//                        name = wdrs[i].name;
//                        qxbs.push(wdrs[i].name);
//                    }
//                }
//            }
//
//            if (qxbs.length > 0) {
//                for (var i = 0; i < qxbs.length; i++) {
//                    var obj = {};  
//                    var vals = []; //数值数组
//                    for (var j = 0; j < wdrs.length; j++) {
//                         if(qxbs[i]==wdrs[j].name){
//                             //.vals.push(wdrs[j].value);
//                              var  value = parseInt(wdrs[j].value);
//                             if(value>0){
//                                value = (value/10).toFixed(1);
//                             }
//                             vals.push(value);
//                         }
//                    }
//                    obj.name = qxbs[i];
//                    obj.data = vals;
//                    data.push(obj);
//                }
//            }

            var sdqxbs = [];  //湿度曲线标识
            var qxbstype = [];  //曲线标识类型
            var sdxdata = [];      //x轴描述 ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
            var sddata = [];   //填充数据
            if (sdrs.length > 0) {
                var wdname = "";   //温度传感器标识
                var sdname = "";   //湿度传感器标识
                for (var i = 0; i < sdrs.length; i++) {
                    // console.log(wdname +"///"+sdrs[i].name+"///"+);
                    if (wdname != sdrs[i].name && sdrs[i].type == "1") {
                        wdname = sdrs[i].name;
                        qxbstype.push(1);
                        sdqxbs.push(sdrs[i].name);
                    } else if (sdname != sdrs[i].name && sdrs[i].type == "2") {
                        sdname = sdrs[i].name;
                        sdqxbs.push(sdrs[i].name);
                        qxbstype.push(2);
                    } else {
                        continue;
                    }
                }
               
                for (var i = 0; i < sdrs.length;i = i+sdqxbs.length) {
                    
                    sdxdata.push(sdrs[i].times.substring(0, 5));
                   
                }
            }

            if (sdqxbs.length > 0) {
                for (var i = 0; i < sdqxbs.length; i++) {
                    var obj = {};
                    var wdvals = []; //数值数组
                    var sdvals = []; //数值数组
                    for (var j = 0; j < sdrs.length; j++) {
                        if (sdqxbs[i] == sdrs[j].name && sdrs[j].type == 1) {
                            var value = parseInt(sdrs[j].value);
                            if (value > 0) {
                                value = (value / 10).toFixed(1);
                            }
                            wdvals.push(value);
                        }
                        if (sdqxbs[i] == sdrs[j].name && sdrs[j].type == 2) {
                            var value = parseInt(sdrs[j].value);
                            if (value > 0) {
                                value = (value / 10).toFixed(1);
                            }
                            sdvals.push(value);
                        }
                    }
                    obj.name = sdqxbs[i];
                    console.log("1:" + sdqxbs[i]);
                    if (qxbstype[i] == 1) {
                        obj.data = wdvals;
                    } else {
                        obj.data = sdvals;
                    }

                    sddata.push(obj);
                }
            }
            echarts3("echarts1", sdqxbs, sdxdata, sddata);

          //  wd("echarts2", qxbs, xdata, data, "℃");

            $('#kgtype').bootstrapTable({
                url: 'homePage.homePage.getkgList.action?pid=' + pid,
                columns: [
                    {
                        field: 'name',
                        title: "名称",
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'numvalue',
                        title: "状态",
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index, field) {
                            if (value == 1) {
                                return "闭合";
                            } else {
                                return "断开";
                            }
                        }
                    }],
                clickToSelect: true,
                singleSelect: false,
                sortName: 'id',
                locale: 'zh-CN', //中文支持,
                showColumns: false,
                sortOrder: 'desc',
                pagination: true,
                sidePagination: 'server',
                pageNumber: 1,
                pageSize: 96,
                // 设置默认分页为 50
                pageList: [96],
                onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                    //                        console.info("加载成功");
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
                },
            });
        });
        //浏览器大小改变时重置大小
        window.onresize = function () {

            myChart3.resize();

            wdChart.resize();

        };
    </script>
</html>
