<%-- 
    Document   : ecchart
    Created on : 2018-8-1, 11:12:39
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tld/fn.tld" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="js/genel.js"></script>
        <script src="echarts/dist/echarts_3.8.5_echarts.min.js"></script>
        <style>

            @charset "utf-8";
            .clear {
                clear: both;
            }
            /* text-align */
            .tleft {
                text-align: left;
            }
            .tright {
                text-align: right;
            }
            .tcenter {
                text-align: center;
            }
            /* display */
            .dis {
                display: block;
            }
            .undis {
                display: none;
            }
            .w {
                width: 100%;
            }
            .h {
                height: 100%;
            }
            .minw {
                min-width: 1050px;
            }
            .fontFamily {
                font-family: "microsoft yahei";
                font-weight: normal;
            }
            .form-control {
                border: 1px solid #ccc;
                font-size: 14px;
            }
            .widMid {
                width: 120px !important;
            }
            .widBig {
                width: 150px !important;
            }
            .btn {
                height: 30px;
            }
            select {
                border: 1px solid #ccc;
            }
            * {
                margin: 0;
                padding: 0;
            }
            body,
            html {
                width: 100%;
                height: 100%;
                overflow: auto;
                font-family: "microsoft yahei";
                font-weight: normal;
            }
            .top {
                overflow: hidden;
                width: 100%;
                height: 45%;
                background: #f8f8f8;
            }
            .topLeft {
                float: left;
                display: inline;
                overflow: hidden;
/*                width: 18%;*/
               width: 260px;
                margin-left: 3%;
                height: 90%;
                
            }
            .topLeftOneBox {
                overflow: visible;
                width: 100%;
                height: 24%;
                margin-top: 1%;
            }
            .redius {
                display: block;
                border-radius: 50%;
                -moz-border-radius: 50%;
                -webkit-border-radius: 50%;
                -ms-border-radius: 50%;
                -o-border-radius: 50%;
                float: left;
                display: inline;
                width: 50px;
                height: 50px;
                margin: 8% 10px 0 10px;
            }
            .redius img {
                width: 30px;
                height: 30px;
                display: block;
                margin: 10px;
            }
            .Mess {
                float: left;
                display: inline;
                height: 100%;
                width: 180px;
                padding-top: 8%;
            }
            .Mess span {
                display: block;
                color: #666666;
                font-size: 16px;
            }
            .topCenter1 {
                overflow: hidden;
                float: left;
                display: inline;
                width: 25%;
                height: 90%;
                margin-left: 3%;
                margin-top: 20px;
            }
            .topCenter2 {
                overflow: hidden;
                float: left;
                display: inline;
                width: 17%;
                height: 90%;
                margin-top: 20px;
            }
            .topCenter2Mess {
                height: 70%;
                width: 100%;
                margin-top: 40%;
            }
            .nenghao {
                width: 100%;
                height: 20%;
                line-height: 30px;
                color: gray;
            }
            .nenghao1 {
                width: 100%;
                height: 30%;
                line-height: 30px;
                color: gray;
            }
            .tongbi {
                color: #90c948;
            }
            .topCenter3 {
                float: left;
                display: inline;
                width: 18%;
                height: 90%;
                margin-left: 2%;
                margin-top: 20px;
            }
            .topCenter3Mess {
                position: relative;
                width: 9%;
                float: left;
                display: inline;
                height: 90%;
                margin-top: 20px;
            }
            .topCenter3Mess .topCenter3MessMM {
                height: 60%;
                margin-top: 50%;
                width: 100%;
                color: gray;
            }
            .topCenter3Mess .topCenter3MessMM div{
                float:left;
            }
            .topCenter3Mess .topCenter3MessMM .first {
                width: 250px;
                /* float: left;
                display: inline;
                text-align: right; */
                line-height: 30px;
            }
            .topCenter3Mess .topCenter3MessMM .second {
                width: 250px;
                /*   text-align: left;
                  float: left;
                  display: inline; */
                line-height: 30px;
            }
            .bottom {
                width: 100%;
                height: 50%;
                background: #f8f8f8;
            }

            .bottom1 {
                height: 480px;
                background: #fff;
            }
            .echarts3 {
                width: 40%;
                height: 95%;
                float: left;
/*                float: right;*/
                display: inline;
                margin-top: 20px;
/*                margin-left: 20px;*/
            }
            .bottomRight {
                float: left;
                display: inline;
                width: 44%;
                height: 95%;
                margin-top: 20px;
                margin-left: 80px;
            }
            .echarts4 {
                width: 90%;
                height: 47%;
                float: right;
                display: inline;
            }
            .echarts5 {
                width: 90%;
                height: 46%;
                margin-top: 17px;
                float: right;
                display: inline;
            }
            .paraValue {
                font-size: 16px;
                color: #666;
            }
            .subPara {
                color: #999;
                font-size: 14px;
            }
            /*# sourceMappingURL=home.css.map */

        </style>

        <script>
            var myChart, myChart2, myChart3, myChart4, myChart5;
            var echarts;
            var lang = '${param.lang}';
            var langs1 = parent.parent.getLnas();
           // var pid = parent.parent.getpojectId();
            $(function () {
                var aaa = $("span[name=xxxxxxxxxxxxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);

                }
                var truevalmap = "";
                var status1 = "";
                var planvalue = "";
                var atualvalue = "";
                var date = new Date;
                var year = date.getFullYear();
                var month = date.getMonth() + 1;
                
                var wgsum = ${rs[0].num}; //网关总数
                var wgzx = ${onlineNumber[0].num};  //网关在线数
                var wglx = wgsum - wgzx;  //网关不在线数
                var gzdj = ${djgzs[0].num};  //灯具异常数
                var djzxs = ${djzxs[0].num}; //灯具在线数
                var lampNumber =  ${lampNumber[0].num};  //灯具总数
                var djlxs =  lampNumber -gzdj-djzxs;
                $("#wgms").html("集中器（在线："+wgzx+" 离线："+wglx+"）");
                $("#djms").html("灯具（在线："+djzxs+" 离线："+djlxs+" 异常："+gzdj+"）");
                if((${ybsdj[0].num-djgzs[0].num}-djlxs)<=0){
                    $("#ldl").html("0%");
                }else{
                    var ldl =((${(ybsdj[0].num-djgzs[0].num)}-djlxs)/${ybsdj[0].num}) * 100;
                    $("#ldl").html(ldl.toFixed(2)+"%");
                }
                //计划能耗
            <c:if test="${fn:length(rs4)==0}">
                planvalue = "";
            </c:if>
            <c:if test="${fn:length(rs4)>0}">
                planvalue = ${rs4[0].power eq null?"":rs4[0].power};
            </c:if>

            <c:if test="${fn:length(rs3)==0 }">
                atualvalue = 0;
            </c:if>
            <c:if test="${fn:length(rs3)==1 }">
                atualvalue =${rs3[0].mpower==NULL?0.00:rs3[0].mpower};

            </c:if>

                var fplanpower = parseFloat(planvalue); //计划能耗
                var fatualpower = parseFloat(atualvalue);
                var diffpower = fplanpower - fatualpower;
                $("#actualConsumption").html(atualvalue);
                diffpower = isNaN(diffpower) == true ? 0 : diffpower;

                $("#differenceConsumption").html(diffpower.toFixed(2));
                var status = diffpower < 0 ? langs1[286][lang] : langs1[13][lang];    //异常、正常
                $("#status").html(status);

                var jnl = 1 - fatualpower / fplanpower
                jnl = isNaN(jnl) == true ? 0 : jnl;
                $("#jnl").html((jnl * 100).toFixed(2) + "%");


                var aa = new Array();
                var obj = new Object();
                obj.Month = month;
                obj.plan_value = fplanpower;
                obj.num = fatualpower;
                obj.status = status;
                aa.push(obj);
                var data = aa;
                var pieData = [{value: data[0].plan_value, name: langs1[9][lang]}, {value: data[0].num, name: langs1[10][lang]}];  //计划能耗、实际能耗
                pieChart("echarts2", "", pieData, langs1[27][lang]);  //用能计划
            });


            $(function () {

                var a3 = new Array();
                var o3 = new Object();
                var date = new Date;
                var year = date.getFullYear();
                var month = date.getMonth() + 1;
                var yearobj = {};
                yearobj[year] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                yearobj[year - 1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                yearobj[year - 2] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                var yearbar = {};
                yearbar[year] = 0;
                yearbar[year - 1] = 0;
                yearbar[year - 2] = 0;
            <c:forEach items="${rs6}" var="t">
                var y = ${t.y};
                var m = ${t.m};

                var power =${t.val==null?0.00:t.val};
                console.log(power);
                if (yearobj.hasOwnProperty(y.toString())) {
                    yearobj[y.toString()][m - 1] = parseFloat(power);
                    yearbar[y.toString()] += power;
                }
            </c:forEach>
                console.log(yearbar);
                var a3 = new Array();
                var o3 = new Object();
                var titlearr = [];

                for (x in yearobj)
                {
                    titlearr.push(x);
                }
                o3.thisYear3 = yearobj[year];
                o3.thisYear2 = yearobj[year - 1];
                o3.thisYear1 = yearobj[year - 2];
//                console.log(o3);
                a3.push(o3);
                var data = a3;
                var dataTitleArray = titlearr;
                var echarts3DataX = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];
                var numberY0 = data[0].thisYear1;
                var numberY1 = data[0].thisYear2;
                var numberY2 = data[0].thisYear3;
                echarts3("echarts3", "横向对比分析", dataTitleArray, echarts3DataX, dataTitleArray[0], numberY0, dataTitleArray[1], numberY1, dataTitleArray[2], numberY2, "kW·h");


                var a4 = new Array();
                var o4 = new Object();
                o4.thisYear3 = Math.floor(yearbar[year] * 100) / 100;
                o4.thisYear2 = Math.floor(yearbar[year - 1] * 100) / 100;
                o4.thisYear1 = Math.floor(yearbar[year - 2] * 100) / 100;
                o4.date3 = year;
                o4.date2 = year - 1;
                o4.date1 = year - 2;
//                console.log(o4);
                a4.push(o4);
                var data = a4;
                var echarts4DataX = [data[0].date1, data[0].date2, data[0].date3];
                var echarts4DataY = [data[0].thisYear1, data[0].thisYear2, data[0].thisYear3];
                //var sjqs = $("#16").html();
                ech4('echarts4', langs1[16][lang], langs1[302][lang], echarts4DataX, echarts4DataY, 'bar', 'kW·h', "#337dd7"); //数据趋势、能耗


                var date = new Date();
                var year1 = date.getFullYear();
                var year2 = year1 - 1;
//                var month1 = date.getMonth() + 1;
//                var month2 = month1 - 1;
                var thisM = $("#18").html();  //本月耗能
                var latM = $("#19").html();  //上月耗能
                var latY = $("#21").html();  //去年同期
                var dataX = [thisM, latM, latY];

                var nowmonth = yearobj[year.toString()][month - 1]; //Math.floor(yearobj[year.toString()][month - 1] * 100) / 100;  //当月
                var premonth = yearobj[year.toString()][month - 2]; //Math.floor(yearobj[year1.toString()][month2 - 1] * 100) / 100;  //前个月

                var preyear = yearobj[(year - 1).toString()][month - 1];          //Math.floor(yearobj[year2.toString()][month1 - 1] * 100) / 100;  //去年当月
                var dataY = [nowmonth, premonth, preyear];
                var nhfx = $("#17").html();//能耗分析
                ech('echarts1', nhfx, '能耗', dataX, dataY, 'bar', 'kW·h', "#68b928");

                $("#benyue").html(nowmonth);
                $("#shangyue").html(premonth);
                var huanbi = nowmonth - premonth;
                var hh = Math.floor(huanbi * 100) / 100;
                $("#lastMonth").html(hh);
                var qiantb = nowmonth - preyear;
                qiantb = Math.floor(qiantb * 100) / 100;
                $("#lastYearSameMonth").html(qiantb);

            })

            function ech(id, title, titleY, signXAxis, signYAxis, type, danwei, bg) {

                myChart = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title
                    },
                    grid: {
                        left: '90',
                        x: 50,
                        x2: 10,
                        y2: 30
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var tar = params[0];
                            return tar.name + ' : ' + tar.value + ' kW·h';
                        }
                    },
                    legend: {
                        data: titleY
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            restore: {},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false, //去掉X轴辅助线
                        },
                        axisLabel: {
                            textStyle: {
                                fontSize: 12, //刻度大小
                            },
                        },
                        data: signXAxis
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            itemStyle: {
                                normal: {
                                    color: bg
                                }
                            },
                            name: titleY,
                            type: type,
                            data: signYAxis
                        }]
                };
                myChart.setOption(option);
            }

            //环状图
            function pieChart(id, title, dataY, zongbi) {
                var vvv = document.getElementById(id);
                myChart2 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title,
                        subtext: zongbi,
                        x: 'center',
                        y: 'center',
                        subtextStyle: {
                            fontSize: 18,
                            color: "skyblue"
                        }
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} kW·h ({d}%)"
                    },
                    color: ["#4fcdfd", "#fdd237"],
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    calculable: true,
                    series: [
                        {
                            name: langs1[303][lang], //访问来源
                            type: 'pie',
                            radius: ['40%', '70%'], //圈圈的边框粗细
                            itemStyle: {
                                normal: {
                                    label: {
                                        show: true
                                    },
                                    labelLine: {
                                        show: true
                                    }
                                },
                                emphasis: {

                                }
                            },
                            data: dataY
                        }
                    ]
                };
                myChart2.setOption(option);
            }

            //折线图
            function echarts3(id, title, dataTitle, dataX, title0, number0, title1, number1, title2, number2, danwei) {
                myChart3 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: ""
                    },
                    grid: {
                        containLabel: true,
                        x: 50,
                        x2: 30,
                        y2: 20
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            return params[0].seriesName + '-' + params[0].name + ' : ' + params[0].value + ' kW·h' + '<br/>' +
                                    +params[1].seriesName + '-' + params[1].name + ' : ' + params[1].value + ' kW·h' + '<br/>' +
                                    +params[2].seriesName + '-' + params[2].name + ' : ' + params[2].value + ' kW·h';
                        }
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    legend: {
                        data: dataTitle
                    },
                    xAxis: {
                        data: dataX
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            name: title0,
                            type: 'line',
                            data: number0
                        },
                        {
                            name: title1,
                            type: 'line',
                            data: number1
                        },
                        {
                            name: title2,
                            type: 'line',
                            data: number2
                        }
                    ]
                };
                myChart3.setOption(option);
            }

            function ech4(id, title, titleY, signXAxis, signYAxis, type, danwei, bg) {
                myChart4 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title
                    },
                    grid: {
                        left: '90',
                        x: 50,
                        x2: 10,
                        y2: 30
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var tar = params[0];
                            return tar.seriesName + "</br>" + tar.name + ' : ' + tar.value + ' kW·h';
                        }
                    },
                    legend: {
                        data: titleY
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            restore: {},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false, //去掉X轴辅助线
                        },
                        axisLabel: {
                            textStyle: {
                                fontSize: 12, //刻度大小
                            },
                        },
                        data: signXAxis
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            itemStyle: {
                                normal: {
                                    color: bg
                                }
                            },
                            name: titleY,
                            type: type,
                            data: signYAxis
                        }]
                };
                myChart4.setOption(option);
            }

            function ech5(id, title, titleY, signXAxis, signYAxis, type, danwei, bg) {
                myChart5 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title
                    },
                    grid: {
                        left: '90',
                        x: 50,
                        x2: 10,
                        y2: 30
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var tar = params[0];
                            return tar.seriesName + "</br>" + tar.name + ' : ' + tar.value + ' kW·h';
                        }
                    },
                    legend: {
                        data: titleY
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            restore: {},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false, //去掉X轴辅助线
                        },
                        axisLabel: {
                            textStyle: {
                                fontSize: 12, //刻度大小
                            },
                        },
                        data: signXAxis
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            itemStyle: {
                                normal: {
                                    color: bg
                                }
                            },
                            name: titleY,
                            type: type,
                            data: signYAxis
                        }]
                };
                myChart5.setOption(option);
            }
            function dealsend() {

                var user = new Object();
                user.count = 0;
                user.res = 1;
                user.afn = 0;
                user.status = "";
                user.function = "getCount";
                user.errcode = 0;
                user.frame = 0;
                user.msg = "Online";
                user.res = 1;
                user.page = 1;
                parent.sendData(user);
            }


            function getCount(obj) {
                console.log(obj);
                var count = obj.count;
                var a = count /${rs5[0].count} * 100;
                var str = a.toString() + '%';
                $('#online').html(str);
            }


        </script>


    </head>


    <body>



        <br>
        <div class="top" style="width:100%;height:450px;position:relative;">
            <div class="topTitle" style="position:absolute;top:2%;left:2%;color:#000;font-size:20px;font-weight:600;">
                <span id="5" name="xxxxxxxxxxxxx">设备分析</span>
                <!-- 设备分析-->
            </div>
            <div class="topLeft" style="height:400px;padding-top:40px;">
                <div class="topLeftOneBox">
                    <span class="redius" style="background:#fdd237;">
                        <img src="img/dp.png"></span>
                    <div class="Mess lightingRate">
                        <span id="ldl">100%</span>
                        <span name="xxxxxxxxxxxxx" id="6"> 亮灯率</span>
                    </div>
                </div>
                <div class="topLeftOneBox">
                    <span class="redius" style="background: lawngreen;"><img src="img/jien.png"></span>
                    <div class="Mess energySavingRate">
                        <span id="jnl"></span>
                        <span name="xxxxxxxxxxxxx" id="7">节能率</span>
                    </div>
                </div>
                <div class="topLeftOneBox">
                    <span class="redius" style="background:#42bcec;"><img src="img/jien.png"></span>
                    <div class="Mess energySavingRate">
                        <span>${rs[0].num}</span>
                        <span style="font-size: 14px;" id="wgms"></span>
                    </div>
                </div>
                <div class="topLeftOneBox">
                    <span class="redius" style="background: #bdebee;"><img src="img/dp.png"></span>
                    <div class="Mess energySavingRate">
                        <span>${lampNumber[0].num}</span>
                        <span style="font-size: 14px;" id="djms"></span>
                    </div>
                </div>
            </div>

            <!--用能计划-->
            <div class="topTitle" style="position:absolute;top:2%;left:24%;color:#000;font-size:20px;font-weight:600;">
                <!--用能计划-->
                <span id="27" name="xxxxxxxxxxxxx">用能计划</span>

                <br><br>
                <span style="color:#777;font-size:18px;font-weight:500;">
                    <!--单位-->
                    <span id="8" name="xxxxxxxxxxxxx">单位</span>
                    ：kW·h</span>
            </div>
            <div class="topCenter3" id="echarts2"  style="height: 400px;">    

            </div>
            <div class="topCenter3Mess" style="height:400px;">

                <div class="topCenter3MessMM" style="margin-top:40%;">
                    <div class="first">
                        <span class="subPara">
                            <!-- 计划能耗-->
                            <span id="9" name="xxxxxxxxxxxxx">计划能耗</span>
                            ：</span>
                        <span class="paraValue" id="planConsumption">${rs4[0].power}</span>
                    </div>
                    <!-- <div class="second"></div> -->
                    <div class="first">
                        <span class="subPara">
                            <!--实际能耗-->
                            <span id="10" name="xxxxxxxxxxxxx">实际能耗</span>
                            ：</span>
                        <span class="paraValue" id="actualConsumption">

                        </span>
                    </div>
                    <!-- <div class="second">1000</div> -->
                    <div class="first">
                        <span class="subPara">
                            <!--差值-->
                            <span id="11" name="xxxxxxxxxxxxx">差值</span>
                            ：</span>
                        <span class="paraValue" id="differenceConsumption"></span>
                    </div>
                    <!-- <div class="second">250</div> -->
                    <div class="first">
                        <span class="subPara">
                            <!-- 状态-->
                            <span name="xxxxxxxxxxxxx" id="12">状态</span>
                            ：</span>
                        <span class="subPara" id="status">

                        </span>
                    </div>

                </div>
            </div>

            <!--横向对比分析-->
            <div class="topTitle" style="position:absolute;top:2%;left:60%;color:#000;font-size:20px;font-weight:600;">
<!--                 position:absolute;top:2%;left:61%;color:#000;font-size:20px;font-weight:600;-->
                <!-- 横向对比分析-->
                <span id="15" name="xxxxxxxxxxxxx">横向对比分析</span>
            </div>
            <div class="echarts3" id="echarts3" style="height: 430px;">
            </div>

        </div>



        <div class="bottom1">
            <!--数据趋势-->
            <span name="xxxxxxxxxxxxx" id="16" style=" display: none" >数据趋势</span>
            <div class="echarts4" id="echarts4" style="width: 35%; height: 85%; float: left; margin: 20px 0px 20px 30px;">


            </div>
            <!--能耗分析-->
            <span name="xxxxxxxxxxxxx" id="17" style=" display: none" >能耗分析</span>
            <div class="topCenter4" style="width:10%;height:85%;float:right;">
                <div class="topCenter2Mess">	
                    <div class="nenghao">
                        <span class="subPara">
                            <!--本月耗能-->
                            <span name="xxxxxxxxxxxxx" id="18">本月耗能</span>
                            :</span><br>
                        <span id="benyue" class="paraValue"></span>kW·h</div>
                    <div class="nenghao1">
                        <span class="subPara">
                            <!--上月耗能-->
                            <span id="19" name="xxxxxxxxxxxxx">上月耗能</span>
                            :</span><br>
                        <span id="shangyue" class="paraValue"></span>kW·h<br>
                        <span><span id="20" name="xxxxxxxxxxxxx"></span>：</span>
                        <span class="tongbi" id="lastMonth"></span>
                        kW·h
                    </div>
                    <div class="nenghao1">

                        <span class="subPara">
                            <!--去年同期-->
                            <span id="21" name="xxxxxxxxxxxxx">去年同期</span>
                            :</span><br>
                        <span id="qunian" class="paraValue"></span>
                        <span>
                            <!--同比-->
                            <span id="22" name="xxxxxxxxxxxxx">同比</span>
                            ：</span>
                        <span class="tongbi" id="lastYearSameMonth"></span>
                        kW·h
                    </div>

                </div>
            </div> 


            <div class="topCenter1" id="echarts1" style="width: 45%; height: 85%; float: left;">

            </div>
        </div>			
        <!--子项分析-->
        <!--                <div style="width: 100%; overflow: hidden; height: 480px; display: none;" id="sub">
                            <div class="echarts5" id="echarts5" style="width: 85%; height: 450px; -moz-user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1530234242293"><div style="position: relative; overflow: hidden; width: 85px; height: 450px;">
                                    <canvas style="position: absolute; left: 0px; top: 0px; width: 85px; height: 450px; -moz-user-select: none;" width="85" height="450" data-zr-dom-id="zr_0">
                
                                    </canvas>
                                </div>
                                <div>
                
                                </div>
                            </div>
                        </div>	-->

        <!--<div id="qb-sougou-search" style="display: none; opacity: 0;"><p>搜索</p><p class="last-btn">复制</p><iframe src=""></iframe></div>-->

    </body>
</html>
