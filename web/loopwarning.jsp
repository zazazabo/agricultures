<%-- 
    Document   : table
    Created on : 2018-6-29, 17:48:10
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


        <style>
            .pull-right.pagination-detail{display:none;}
            table thead{
                background-color:  #ddd
            }
/*            table.table-bordered > tr >td {
                height: 80px;
                max-height: 80px;
            }*/
        </style>
    </head>

    <script type="text/javascript" src="js/genel.js"></script>
    <script type="text/javascript" src="js/getdate.js"></script>
    <script>
        var lang = '${param.lang}';//'zh_CN';
        var langs1 = parent.parent.getLnas();
        var u_name = parent.parent.getusername();
        var o_pid = parent.parent.getpojectId();
        function layerAler(str) {
            layer.alert(str, {
                icon: 6,
                offset: 'center'
            });
        }
        var vvvv = 0;
        var flag = null;

        $(function () {
            var aaa = $("span[name=xxx]");
            for (var i = 0; i < aaa.length; i++) {
                var d = aaa[i];
                var e = $(d).attr("id");
                $(d).html(langs1[e][lang]);
            }
            $('#l_comaddr').combobox({
                url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                onLoadSuccess: function (data) {
                    if (Array.isArray(data) && data.length > 0) {
                        $(this).combobox("select", data[0].id);
                    }
                },
                onSelect: function (record) {
                }
            });
            $('#time4').timespinner('setValue', '00:00');
            $('#time3').timespinner('setValue', '00:00');

            var data2 = [{"name": "A相电压超限"}, {"name": "B相电压超限"}, {"name": "C相电压超限"},
                {"name": "A相过载"}, {"name": "A相欠载"}, {"name": "B相过载"}, {"name": "B相欠载"},
                {"name": "C相过载"}, {"name": "C相欠载"}, {"name": "A相功率因数过低"}, {"name": "B相功率因数过低"}, {"name": "C相功率因数过低"}, {"name": "交流接触电故障"}];

            $('#warningtable').bootstrapTable({
                columns: [
                    {
                        title: '单选',
                        field: 'select',
                        //复选框
                        checkbox: true,
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'name',
                        title: langs1[216][lang],   //报警参数
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }
                ],
                paginationDetailHAlign: 'right',
                data: data2,
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 16,
                pageList: [16, 32],

            });
        })




        function LoopWarningCb(obj) {
            if (obj.status == "success") {

                if (obj.msg == "A4" && obj.fn == 610) {
                    layerAler(langs1[218][lang]);  //报警参数设置成功
                    addlogon(u_name, "设置", o_pid, "回路预报警", "设置回路预报警参数");
                }
            }
        }

        function setLoopWarning() {

            var obj = $("#form1").serializeObject();
            if (obj.l_comaddr == "") {
                layerAler(langs1[219][lang]);  //请选择网关
                return;
            }
            var arr = $("#warningtable").bootstrapTable('getData');
            var vv = [];
            var u = 0x00;
            var ss2 = "";
            var ss = "";
            for (var i = 0; i < arr.length; i++) {
                var a = arr[i];
                var s = a.select;
                var ii = s == true ? 0 : 1;
                if (i < 8) {

                    var s = ii.toString(2);
                    ss = s + ss;
                }
                if (i >= 8) {
                    if (i == arr.length - 1) {
                        ss2 = "0" + ss2;
                        ss2 = "0" + ss2;
                        ss2 = "0" + ss2;
                        var s = ii.toString(2);
                        ss2 = s + ss2;
                        //ss2 = ii;
                        break;
                    }
                    var s = ii.toString(2);
                    ss2 = s + ss2;

                }
            }
            var u = parseInt(ss, 2);
            vv.push(u);
            var u1 = parseInt(ss2, 2);
            vv.push(u1);

            var comaddr = obj.l_comaddr;
            var num = randnum(0, 9) + 0x70;
            var data = buicode(comaddr, 0x04, 0xA4, num, 0, 610, vv);
            dealsend2("A4", data, 610, "LoopWarningCb", comaddr, 0, 0, 0);
        }


    </script>
</head>
<body>

    <div class="panel panel-success" >
        <div class="panel-heading">
            <h3 class="panel-title"><span id="221" name="xxx">回路预报警参数设置</span></h3>
        </div>
        <div class="panel-body" >
            <div class="container"  >


                <div class="row" align="center" style=" padding-top: 20px; padding-bottom: 20px; padding-bottom: 20; width: 600px; " >
                    <div class="col-xs-12">
                        <form id="form1">
                            <table style="">
                                <tbody>
                                    <tr>

                                        <td>
                                            <span style="margin-left:10px;"><span id="25" name="xxx">网关地址</span>&nbsp;</span>
                                            <span class="menuBox">
                                                <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                       data-options="editable:true,valueField:'id', textField:'text' " />
                                            </span>  
                                            <button  type="button" style="margin-left:20px;" onclick="setLoopWarning()" class="btn btn-success"><span name="xxx" id="222">设置回路报警参数</span></button>
                                            &nbsp;
                                        </td>

                                    </tr>
                                </tbody>
                            </table> 
                        </form>
                    </div>
                </div>


                <div class="row" style="width: 400px;">
                    <div class="col-xs-12" style=" margin-left: 100px;">
                        <table  id="warningtable"  > 
                        </table> 
                    </div>
                </div>

                <div style=" margin-top: 20px;">

                </div>


            </div>
        </div>
    </div>


</body>
</html>
