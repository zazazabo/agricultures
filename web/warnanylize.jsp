<%-- 
    Document   : testdatetime
    Created on : 2018-8-6, 11:12:54
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>



        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache"> 

        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">

        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <style>
            select{
                border-style:none;
                border:1px solid #aaa;
                border-radius:4px;
            }
            .lineTable tr{
                line-height:40px;
            }
            .lineTable tr td input{
                border:1px solid #ccc;
                width:130px;
            }
        </style>
        <script>
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
                for (var i = 0; i < 12; i++) {
                    var s = (i + 1).toString();
                    $("#warning_value" + s).attr('readonly', true);
                }


            })

            function  saveplan() {
                var f1 = $("#form3").serializeObject();
                console.log(f1);
                var vday = $("#formyear").serializeObject();

                if (vday.day == "") {
                    layerAler(langs1[152][lang]); //请选择年
                    return;
                }

                for (var k in f1) {
                    var len1 = "plan_value".length;
                    var t = k.indexOf("plan_value");
                    if (t != -1) {
                        var a = k.substring(t + len1);
                        var warningstr = "warning_value" + a;
                        //var warningval=f1[warningstr];
                        var warnbl = $("#warning_ration").val();
                        var warningval = parseInt(f1[k]) * parseInt(warnbl) / 100;
                        var obj = {"day": vday.day, "m": a};
                        obj.pid =  '${param.pid}';
                        var oo = {"day": vday.day + "-" + a + "-01", "power": f1[k], "warnpower": warningval, "year": vday.day, "month": a};
                        oo.pid = '${param.pid}';
                        console.log(obj);
                        $.ajax({async: false, url: "param.power.anylize1.action", type: "get", datatype: "JSON", data: obj,
                            success: function (data) {
                                var arr = data.rs;
                                console.log(arr);
                                if (arr.length == 0) {
                                    $.ajax({async: false, url: "param.power.insert.action", type: "get", datatype: "JSON", data: oo,
                                        success: function (data) {

                                        },
                                        error: function () {
                                            alert("提交插入失败！");
                                        }
                                    });

                                } else if (arr.length > 0) {


                                    $.ajax({async: false, url: "param.power.update.action", type: "get", datatype: "JSON", data: oo,
                                        success: function (data1) {

                                        },
                                        error: function () {
                                            alert("提交插入失败！");
                                        }
                                    });

                                }
                                layerAler("保存成功");

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });


                        // console.log(k, ":", f1[k]);
                    }

                }
            }
            //查询
            function querryPower() {
                var day = $("#day").val();
                var obj = {};
                obj.day = day;
                obj.pid = '${param.pid}';
                $.ajax({async: false, url: "param.power.anylize.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        console.log(data);
                        var arrbefor = data.befor;
                        var arrnow = data.now;
                        var s1 = 0; //总计划值
                        var s2 = 0; //总预警值
                        for (var i = 0; i < 12; i++) {
                            $("#plan_valueto" + (i + 1).toString()).val("0");
                            $("#warning_valueto" + (i + 1).toString()).val("0");

                            $("#plan_value" + (i + 1).toString()).val("0");
                            $("#warning_value" + (i + 1).toString()).val("0");

                        }
                        if (arrnow.length > 0) {
                            for (var i = 0; i < arrnow.length; i++) {
                                var v1 = arrnow[i];
                                console.log(v1);
                                var id = "#plan_value" + v1.m;
                                $(id).val(v1.power);
                                s1 = s1 + parseInt(v1.power);
                                console.log("总计划值："+s1);
                                s2 = s2 + parseInt(v1.warnpower);
                                $("#warning_value" + v1.m).val(v1.warnpower);
                            }
                        }
                        if (arrbefor.length > 0) {
                            for (var i = 0; i < arrbefor.length; i++) {
                                var v1 = arrbefor[i];
                                console.log(v1);
                                var id = "#plan_valueto" + v1.m;
                                $(id).val(v1.power);
                            }
                        }
                        $("#annual_plan_value").html(s1.toString());
                        var s3 = 0;
                        if(s2 !=0 && s1!=0){
                            s3 = s2 / s1 * 100;
                        }
                       
                        $("#warning_ration").val(s3.toString());

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }


        </script>
    </head>
    <body>
    <body style="margin: 10px">

        <div id="big" style="height:auto;width:100%;border:1px solid #CECECE;border-bottom:none;">
            <div id="condition" style="height:60px;width:100%;padding-top: 12px">
                <span style="margin-left:360px;font-size:16px; " name="xxx" id="153">时间(年)</span>
                <form action="" id="formyear" class="form-horizontal" role="form" style="float:left;position:absolute;top:21px;left:450px;width: 166px;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date form_date col-md-2" style="float:initial;" data-date="" data-date-format="yyyy" data-link-field="dtp_input2" data-link-format="yyyy">
                        <input id="day" name="day"  class="form-control" style="width:100px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>

                <button id="butt" name="But" onclick="querryPower();" class="btn btn-info btn-sm" style="display: inline;margin-left: 224px;">
                    <span class="glyphicon glyphicon-search"></span><span name="xxx" id="154">查询</span>
                </button>
            </div>


        </div> 



        <div style="width:100%;border:1px solid #ccc;height:500px;border-top:none;"> 
            <table style="width:90%">
                <tbody><tr>
                        <td width="15%">
                        </td>
                        <td width="15%">
                            <span name="xxx" id="155">年计划值</span>：
                        </td>
                        <td style="text-align: left">
                            <div id="annual_plan_value" style="font-size:26px;font-weight: bold; color: #009933;width:20%;height:30px;">0</div>
                        </td>
                        <td width="10%">
                            <span name="xxx" id="156">预警比例</span>：
                        </td>
                        <td width="24%" align="left">
                            <input id="warning_ration" runat="server" name="warning_ration" cssclass="tdfont" font-size="20px" style="width: 150px; font-size: 26px; font-weight: bold; color: #009933; height: 30px;
                                   border: 0px; text-align: center; border-bottom: 1px solid #ddd;" value="0" type="text">
                            <span style="font-size: 33px;">%</span>&nbsp;
                        </td>
                        <td width="200px" align="center">
                            <!--                            <input id="saveEnergyPlan" onclick="saveplan();" name="But" class="btn btn-info btn-sm" value="保存配置" style="display: inline; margin-left: 5px;" type="button">-->
                            <button id="saveEnergyPlan" onclick="saveplan();" name="But" class="btn btn-info btn-sm" style="display: inline; margin-left: 5px;" >
                                <span id="157" name="xxx">保存配置</span>
                            </button>
                        </td>
                    </tr>
                </tbody></table>

            <form id="form3">
                <table class="lineTable" width="100%">
                    <tbody><tr class="trCss">
                            <td style="width:5%;">
                            </td>
                            <td style="width:5%;">
                            </td>
                            <td class="tdfont" width="10%" align="center">
                                <span name="xxx" id="158">计划值</span> 
                            </td>
                            <td class="tdfont" width="10%" align="center">
                                <span name="xxx" id="159">去年计划值</span>
                            </td>
                            <td class="tdfont" width="10%" align="center">
                                <span name="xxx" id="160">预警值</span>
                            </td>
                            <td style="width:5%;">
                            </td>
                            <td style="width:5%;">
                            </td>
                            <td class="tdfont" width="10%" align="center">
                                <span name="xxx" id="158">计划值</span>
                            </td>
                            <td class="tdfont" width="10%" align="center">
                                <span name="xxx" id="159">去年计划值</span>
                            </td>
                            <td class="tdfont" width="10%" align="center">
                                <span name="xxx" id="160">预警值</span>
                            </td>
                            <td style="width:5%;">
                            </td>
                            <td style="width:5%;">
                            </td>
                        </tr>
                        <tr class="trCss">
                            <td class="space">
                                <input id="pId1" type="hidden">
                            </td>
                            <td class="tdfont" width="50px">
                                1月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value1" id="plan_value1" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="janPlanLast" id="plan_valueto1" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value1" id="warning_value1" value="0" type="text">
                            </td>
                            <td class="space">
                                <input id="pId2" type="hidden">
                            </td>
                            <td class="tdfont" width="50px">
                                2月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value2" id="plan_value2" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="febPlanLast" id="plan_valueto2" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value2" id="warning_value2" value="0" type="text">
                            </td>
                        </tr>
                        <tr class="trCss">
                            <td>
                                <input id="pId3" type="hidden">
                            </td>
                            <td class="tdfont">
                                3月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value3" id="plan_value3" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="marPlanLast" id="plan_valueto3" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value3" id="warning_value3" value="0" type="text">
                            </td>
                            <td>
                                <input id="pId4" type="hidden">
                            </td>
                            <td class="tdfont">
                                4月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value4" id="plan_value4" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="aprPlanLast" id="plan_valueto4" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value4" id="warning_value4" value="0" type="text">
                            </td>
                        </tr>
                        <tr class="trCss">
                            <td>
                                <input id="pId5" type="hidden">
                            </td>
                            <td class="tdfont">
                                5月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value5" id="plan_value5" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="mayPlanLast" id="plan_valueto5" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value5" id="warning_value5" value="0" type="text">
                            </td>
                            <td>
                                <input id="pId6" type="hidden">
                            </td>
                            <td class="tdfont">
                                6月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value6" id="plan_value6" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="junPlanLast" id="plan_valueto6" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value6" id="warning_value6" value="0" type="text">
                            </td>
                        </tr>
                        <tr class="trCss">
                            <td>
                                <input id="pId7" type="hidden">
                            </td>
                            <td class="tdfont">
                                7月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value7" id="plan_value7" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="julPlanLast" id="plan_valueto7" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value7" id="warning_value7" value="0" type="text">
                            </td>
                            <td>
                                <input id="pId8" type="hidden">
                            </td>
                            <td class="tdfont">
                                8月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value8" id="plan_value8" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="augPlanLast" id="plan_valueto8" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value8" id="warning_value8" value="0" type="text">
                            </td>
                        </tr>
                        <tr class="trCss">
                            <td>
                                <input id="pId9" type="hidden">
                            </td>
                            <td class="tdfont">
                                9月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value9" id="plan_value9" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="sepPlanLast" id="plan_valueto9" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value9" id="warning_value9" value="0" type="text">
                            </td>
                            <td>
                                <input id="pId10" type="hidden">
                            </td>
                            <td class="tdfont">
                                10月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value10" id="plan_value10" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="octPlanLast" id="plan_valueto10" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value10" id="warning_value10" value="0" type="text">
                            </td>
                        </tr>
                        <tr class="trCss">
                            <td>
                                <input id="pId11" type="hidden">
                            </td>
                            <td class="tdfont">
                                11月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value11" id="plan_value11" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="novPlanLast" id="plan_valueto11" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value11" id="warning_value11" value="0" type="text">
                            </td>
                            <td>
                                <input id="pId12" type="hidden">
                            </td>
                            <td class="tdfont">
                                12月
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="plan_value12" id="plan_value12" value="0" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="decPlanLast" id="plan_valueto12" value="0" disabled="disabled" type="text">
                            </td>
                            <td class="tdfont">
                                <input style="text-align: right;" class="input-sm" name="warning_value12" id="warning_value12" value="0" type="text">
                            </td>
                        </tr>
                    </tbody></table>
            </form>
        </div> 




        <script>
            $('.form_date').datetimepicker({
                language: 'zh',
                weekStart: 1,
                todayBtn: 1,
                autoclose: 1,
                startView: 'decade',
                minView: 'decade',
                format: 'yyyy',
                maxViewMode: 2,
                minViewMode: 2,
            });
        </script>
        <div class="datetimepicker datetimepicker-dropdown-bottom-right dropdown-menu" style="left: 725px; z-index: 1010; display: none; top: 45px;">
        </div>
    </body>


</body>
</html>
