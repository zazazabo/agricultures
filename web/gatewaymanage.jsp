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


        <!--<style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style></head>-->
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } 

            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 

        </style>

        <script type="text/javascript" src="SheetJS-js-xlsx/dist/xlsx.core.min.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            function excel() {
                $('#dialog-excel').dialog('open');
                return false;

            }

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function deleteGateway() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请选择您要删除的数据");//请选择您要删除的数据
                } else {
                    layer.confirm('确认要删除吗？', {//确认要删除吗？
                        btn: ['确定', '取消'] //确定、取消按钮
                    }, function (index) {
                        for (var i = 0; i < num; i++) {
                            var obj = {};
                            obj.id = selects[i].id;
                            $.ajax({url: "homePage.gatewaymanage.delcode.action", type: "POST", datatype: "JSON", data: obj,
                                success: function (data) {

                                }
                            });

                        }
                        $("#gravidaTable").bootstrapTable('refresh');
                        layer.close(index);
                    });
                }
            }



            function showDialog() {

                $('#dialog-add').dialog('open');
                return false;
            }

            function modifyModal() {

                var selectRow1 = $("#gravidaTable").bootstrapTable("getSelections");
                if (selectRow1.length > 1) {
                    //只能选择一行进行修改
                    layer.alert('只能选择一行进行修改', {
                        icon: 6,
                        offset: 'center'
                    });
                } else if (selectRow1.length == 0) {
                    //请勾选表格数据
                    layer.alert('请勾选表格数据', {
                        icon: 6,
                        offset: 'center'
                    });
                } else {
                    var s = $("#gravidaTable").bootstrapTable("getSelections")[0];
                    console.log(s);
                    $("#id_").val(s.id);
                    $("#comaddr_").val(s.comaddr);
                    $("#feebleday1").val(s.feebleday);
                    $("#remarks1").val(s.remarks);
                    $('#dialog-edit').dialog('open');
                    return false;
                }
            }


            function  editComplete() {
                var obj = $("#form2").serializeObject();
                $.ajax({async: false, cache: false, url: "homePage.gatewaymanage.upcode.action", type: "GET", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            $("#dialog-edit").dialog("close");
                            $("#gravidaTable").bootstrapTable('refresh');
                        }

                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {
                            icon: 6,
                            offset: 'center'
                        });
                    }
                });

            }

            $(function () {

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


                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }

                $('#warningtable').bootstrapTable({
                    columns: [
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 10,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: "序号", //序号
                            field: '序号',
                            width: 20,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: "编号",
                            field: '编号', //网关名称
                            width: 80,
                            align: 'center',
                            valign: 'middle'
                        }
                    ],
                    singleSelect: false,
                    locale: 'zh-CN', //中文支持,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 40,
                    pageList: [20, 40, 80, 160]

                });

                $('#excel-file').change(function (e) {
                    var files = e.target.files;
                    var fileReader = new FileReader();
                    fileReader.onload = function (ev) {
                        try {
                            var data = ev.target.result,
                                    workbook = XLSX.read(data, {
                                        type: 'binary'
                                    }), // 以二进制流方式读取得到整份excel表格对象
                                    persons = []; // 存储获取到的数据
                        } catch (e) {
                            alert("文件类型不正确");  //文件类型不正确
                            return;
                        }
                        // 表格的表格范围，可用于判断表头是否数量是否正确
                        var fromTo = '';
                        // 遍历每张表读取
                        for (var sheet in workbook.Sheets) {
                            if (workbook.Sheets.hasOwnProperty(sheet)) {
                                fromTo = workbook.Sheets[sheet]['!ref'];
                                persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
                                // break; // 如果只取第一张表，就取消注释这行
                            }
                        }
                        var headStr = '序号,编号';
                        for (var i = 0; i < persons.length; i++) {
                            if (Object.keys(persons[i]).join(',') !== headStr) {
                                alert("导入文件格式不正确"); //导入文件格式不正确
                                persons = [];
                            }
                        }
                        $("#warningtable").bootstrapTable('load', []);
                        if (persons.length > 0) {
                            $('#warningtable').bootstrapTable('load', persons);

                        }
                    };
                    // 以二进制方式打开文件
                    fileReader.readAsBinaryString(files[0]);
                });

                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 400,
                    height: 300,
                    position: ["top", "top"],
                    buttons: {
                        添加: function () {
                            checkAdd();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });
                $("#dialog-edit").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 400,
                    height: 300,
                    position: "top",
                    buttons: {
                        修改: function () {
                            editComplete();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#dialog-excel").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 750,
                    height: 500,
                    position: "top",
                    buttons: {
                        保存: function () {
                            addexcel();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $('#gravidaTable').bootstrapTable({
                    url: 'homePage.gatewaymanage.gcodeLlist.action',
                    columns: [
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 20,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'comaddr',
                            title: '编号',
                            width: 150,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'inserday',
                            title: '添加日期',
                            width: 150,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value) {
                                if (value != "" && value != null) {

                                    var index = value.indexOf(".");
                                    var str = value.substring(0, index);
                                    return str;
                                } else {
                                    return  value;
                                }
                            }
                        }, {
                            field: 'feebleday',
                            title: '无效期',
                            width: 150,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value) {
                                if (value != "" && value != null) {
                                    return  value.replace(".0", "");
                                } else {
                                    return value;
                                }
                            }
                        }, {
                            field: 'inserpeople',
                            title: '添加人',
                            width: 150,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'remarks',
                            title: '备注',
                            width: 150,
                            align: 'center',
                            valign: 'middle'
                        }],
                    clickToSelect: true,
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
                    pageList: [10, 15],
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

            //导入excel的添加按钮事件
            function addexcel() {
                var selects = $('#warningtable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请选择您要保存的数据");  //请选择您要保存的数据
                    return;
                }
                for (var i = 0; i <= selects.length - 1; i++) {
                    var comaddr = selects[i].编号;
                    var obj = {};
                    comaddr = comaddr.toString();
                    while (comaddr.length < 18) {
                        comaddr = "0" + comaddr;
                    }
                    obj.comaddr = comaddr;
                    $.ajax({async: false, url: "homePage.gatewaymanage.existence.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 0) {
                                var adobj = {};
                                adobj.comaddr = comaddr;
                                $.ajax({url: "homePage.gatewaymanage.addcode.action", async: false, type: "get", datatype: "JSON", data: adobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            var ids = [];//定义一个数组
                                            var xh = selects[i].序号;
                                            ids.push(xh);//将要删除的id存入数组
                                            $("#warningtable").bootstrapTable('remove', {field: '序号', values: ids});
                                        }
                                    },
                                    error: function () {
                                        alert("提交添加失败！");
                                    }
                                });


                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });

                }
                $("#gravidaTable").bootstrapTable('refresh');
            }


            function checkAdd() {
                var obj = $("#formadd").serializeObject();
                if (obj.comaddr == "") {
                    layerAler("请填写网关地址");
                    return;
                }
                if (obj.comaddr.length > 18) {
                    layerAler("网关地址不能大于18长度");
                    return;
                }
                var comaddr = obj.comaddr;
                while (comaddr.length < 18) {
                    comaddr = "0" + comaddr;
                }
                obj.comaddr = comaddr;
                obj.inserpeople = parent.getusername();
                $.ajax({async: false, cache: false, url: "homePage.gatewaymanage.existence.action", type: "GET", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            layerAler("该网关地址已存在");
                        } else {
                            $.ajax({async: false, cache: false, url: "homePage.gatewaymanage.addcode.action", type: "GET", data: obj,
                                success: function (data) {
                                    var rs = data.rs;
                                    if (rs.length > 0) {
                                        $("#dialog-add").dialog("close");
                                        $("#gravidaTable").bootstrapTable('refresh');
                                    }
                                },
                                error: function () {
                                    layer.alert('系统错误，刷新后重试', {
                                        icon: 6,
                                        offset: 'center'
                                    });
                                }
                            });
                        }

                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {
                            icon: 6,
                            offset: 'center'
                        });
                    }
                });
            }
        </script>
    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" onclick="showDialog()" data-toggle="modal" data-target="#pjj33" id="add">
                <span class="glyphicon glyphicon-plus-sign">&nbsp;添加</span>
            </button>
            <button class="btn btn-primary ctrol" onclick="modifyModal()" id="xiugai1">
                <span class="glyphicon glyphicon-pencil">&nbsp;编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteGateway()" id="shanchu">
                <span class="glyphicon glyphicon-trash">&nbsp;删除</span>
            </button>
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="$('#wgmb').tableExport({type: 'excel', escape: 'false'})">
                <span>导出Excel模板</span>
            </button>
            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign">&nbsp;导入Excel</span>
            </button>
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                <span name="xxx" id="110">导出Excel</span>
            </button>


        </div>
        <table id="gravidaTable" style="width:100%;">
        </table>




        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="网关编号添加">

            <form action="" method="POST" id="formadd">   
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:10px;" >网关编号</span>&nbsp;
                                <input id="comaddr" class="form-control" name="comaddr" style="width:150px;display: inline;" placeholder="请输入网关编号" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:23px;" >无效期</span>&nbsp; 
                                <input type="text" class="form-control form_datetime" name="feebleday"  readOnly id="timeMin1" style=" width: 150px;">  
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:35px;" >备注</span>&nbsp;
                                <input id="remarks" class="form-control" name="remarks" style="width:150px;display: inline;" placeholder="请输入备注" type="text">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="网关编号修改">
            <form action="" method="POST" id="form2">  
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <input id="id_" name="id" type="hidden">
                                <span style="margin-left:10px;" >网关编号</span>&nbsp;
                                <input id="comaddr_" class="form-control" name="comaddr" disabled="disabled" style="width:150px;display: inline;"  type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:23px;" >无效期</span>&nbsp; 
                                <input type="text" class="form-control form_datetime" name="feebleday"  readOnly id="feebleday1" style=" width: 150px;">  
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:35px;" >备注</span>&nbsp;
                                <input id="remarks1" class="form-control" name="remarks" style="width:150px;display: inline;" placeholder="请输入备注" type="text">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>

        <div id="dialog-excel"  class="bodycenter"  style=" display: none" title="导入Excel">
            <input type="file" id="excel-file" style=" height: 40px;">
            <table id="warningtable"></table>

        </div>


        <div  style=" top:-60%;position:absolute; z-index:9999;background-color:#FFFFFF;">
            <table id="wgmb" style=" border: 1px">
                <tr>
                    <td>序号</td>
                    <td>编号</td>
                </tr>
                <tr>
                    <td>如1、2、3</td>
                    <td>编号不可重复</td>
                </tr>
            </table>
        </div>




    </body>
</html>
