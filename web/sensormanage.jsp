<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns:f="http://java.sun.com/jsf/core">
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="SheetJS-js-xlsx/dist/xlsx.core.min.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            function excel() {
                $('#dialog-excel').dialog('open');
                return false;

            }
            //导入excel的添加按钮事件
            function addexcel() {
                var selects = $('#warningtable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[350][lang]);  //请选择您要保存的数据
                    return;
                }
                var pid = parent.parent.getpojectId();
                for (var i = 0; i <= selects.length - 1; i++) {
                    var comaddr = selects[i].网关地址;
                    var lampid = selects[i].灯具编号;
                    var obj = {};
                    obj.pid = pid;
                    obj.comaddr = comaddr;
                    $.ajax({async: false, url: "login.lampmanage.getpid.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            console.log("1");
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                console.log("w:" + arrlist.length);
                                $.ajax({async: false, url: "login.lampmanage.getfactorycode.action", type: "POST", datatype: "JSON", data: {l_factorycode: lampid},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 0) {
                                            console.log("d:" + arrlist.length);
                                            var comname = selects[i].网关名称;
                                            var lampname = selects[i].灯具名称;
                                            var zh = selects[i].组号;
                                            var kzfs = selects[i].控制方式;
                                            var lng = selects[i].经度;
                                            var lat = selects[i].纬度;
                                            var adobj = {};
                                            adobj.l_name = lampname;
                                            adobj.l_worktype = kzfs;
                                            adobj.l_comaddr = comaddr;
                                            adobj.l_deplayment = 0;
                                            adobj.l_factorycode = lampid;
                                            adobj.l_groupe = zh;
                                            adobj.lng = lng;
                                            adobj.lat = lat;
                                            adobj.wname = comname;
                                            $.ajax({url: "login.lampmanage.addlamp.action", async: false, type: "get", datatype: "JSON", data: adobj,
                                                success: function (data) {
                                                    var arrlist = data.rs;
                                                    if (arrlist.length == 1) {
                                                        var ids = [];//定义一个数组
                                                        var xh = selects[i].序号;
                                                        console.log("xh:" + xh);
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
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });

                }
            }
            function showDialog() {

                $('#dialog-add').dialog('open');
                return false;
            }

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function deleteLamp() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请勾选您要删除的数据");  //请勾选您要删除的数据
                    return;
                }
                var select = selects[0];
                if (select.deplayment == "1") {
                    layerAler("已部署的不能删除");  //已部署的不能删除
                    return;
                }
                layer.confirm("确认要删除吗？", {//确认要删除吗？
                    btn: ["确定","取消"] //确定、取消按钮
                }, function (index) {
                    $.ajax({url: "sensor.sensormanage.deletesensor.action", type: "POST", datatype: "JSON", data: {id: select.id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#gravidaTable").bootstrapTable('refresh');
                                layer.close(index);
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    layer.close(index);
                    //此处请求后台程序，下方是成功后的前台处理……
                });
            }

            function  editlamp() {
                //addlogon(u_name, "修改", o_pid, "灯具管理", "修改灯具");
                var o = $("#formedi").serializeObject();
                $.ajax({async: false, url: "sensor.sensormanage.updsensor.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        var a = data.rs;
                        if (a.length == 1) {
                             layerAler("修改成功");
                             $("#gravidaTable").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            function editsensorInfo() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length <= 0) {
                    layerAler("请勾选您要编辑的数据");  //请勾选您要编辑的数据
                    return;
                }
                var s = selects[0];
                $("#dreg1").val(s.dreg);  //位置
                $("#informationnum1").val(s.informationnum);//信息点号
                $("#sitenum1").val(s.sitenum);  //站号
                $("#name1").val(s.name);  //名称
                $("#l_worktype1").combobox('setValue', s.l_worktype);
                $("#unit1").combobox('setValue', s.unit);

                if (s.deplayment == "1") {    //判断是否部署
                    $("#informationnum1").attr("readOnly",true);//信息点号
                    $("#sitenum1").attr("readOnly",true);  //站号
//                    $("#l_groupe1").combobox("readonly", true);
//                    $("#l_worktype1").combobox("readonly", true);
                }
                $("#hide_id").val(s.id);
                $('#dialog-edit').dialog('open');
                return false;


            }

            function checkLampAdd() {

                var o = $("#formadd").serializeObject();
                console.log("o:" + o);
                var isflesh = false;
                $.ajax({url: "sensor.sensormanage.addsensor.action", async: false, type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            isflesh = true;
                            $("#gravidaTable").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });
                return  isflesh;

            }
            
            //添加首页显示
            function  addshow(){
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length <= 0) {
                    layerAler("请勾选您要添加的数据");  //请勾选您要编辑的数据
                    return;
                }
                var s = selects[0];
                if(s.deplayment !=1){
                     layerAler("未部署的传感器无法添加");  
                    return;
                } 
                $.ajax({url: "sensor.sensormanage.showsensor.action", type: "POST", datatype: "JSON", data: {id: s.id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                               layerAler("添加成功");
                            }else{
                               layerAler("添加失败"); 
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                
            }
            
            //搜索
            function  search() {
                var obj = $("#formsearch").serializeObject();
                console.log(obj);
                var opt = {
                    url: "lamp.lampform.getlampList.action",
                    silent: false,
                    query: obj
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);
            }


            $(function () {


                $('#gravidaTable').bootstrapTable({
                    // url: 'lamp.lampform.getlampList.action',
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
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
                            title: '传感器名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'model',
                            title: '型号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'sitenum',
                            title: '站号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }

                            }
                        }, {
                            field: 'dreg',
                            title: '数据位置',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.toString();
                            }
                        }, {
                            field: 'Longitude',
                            title: '经度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: '纬度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'numvalue',
                            title: '数值',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'unit',
                            title: '单位',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },{
                            field: 'deplayment',
                            title: '部署状态',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == "1") {
                                    var str = "<span class='label label-success'>已部署</span>";  //已部署
                                    return  str;
                                }else{
                                    var str = "<span class='label label-warning'>未部署</span>";  //未部署
                                    return  str;
                                }
                            }
                        }, 
                        {
                            field: 'online',
                            title: '在线状态', //在线状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value == 1) {
                                    return "<img  src='img/online1.png'/>";  //onclick='hello()'

                                } else {
                                    return "<img  src='img/off.png'/>";  //onclick='hello()'
                                }

                            },
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 50,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [50, 100, 200, 300, 400],
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
                            pid: "${param.pid}",
                        };
                         l_comaddr:'';    
                        return temp;  
                    },
                });



                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $("#l_comaddr2").combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].id;
                            }
                            $(this).combobox('select', data[0].id);
                        }

                    },
                    onSelect: function (record) {
                        var obj = {};
                        obj.l_comaddr = record.id;
                        obj.pid = "${param.pid}";
                        var opt = {
                            url: "lamp.lampform.getlampList.action",
                            query: obj,
                            silent: false
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }




//                    url: "login.map.getallcomaddr.action?pid=" + o_pid,
//                    onLoadSuccess: function (data) {
////                        $(this).combobox("select", data[0].id);
////                        $(this).val(data[0].text);
//                    }
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
                            alert(langs1[384][lang]);  //文件类型不正确
                            return;
                        }
                        // 表格的表格范围，可用于判断表头是否数量是否正确
                        var fromTo = '';
                        // 遍历每张表读取
                        for (var sheet in workbook.Sheets) {
                            if (workbook.Sheets.hasOwnProperty(sheet)) {
                                fromTo = workbook.Sheets[sheet]['!ref'];
                                console.log(fromTo);
                                persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
                                // break; // 如果只取第一张表，就取消注释这行
                            }
                        }
                        var headStr = '序号,网关名称,网关地址,灯具名称,灯具编号,组号,控制方式,经度,纬度';
                        for (var i = 0; i < persons.length; i++) {
                            if (Object.keys(persons[i]).join(',') !== headStr) {
                                alert(langs1[366][lang]);  //导入文件格式不正确
                                persons = [];
                            }
                        }
                        console.log("p2:" + persons.length);
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
                    width: 700,
                    height: 300,
                    position: ["top", "top"],
                    buttons: {
                        添加: function () {
                            $("#formadd").submit();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#dialog-edit").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 350,
                    position: "top",
                    buttons: {
                        修改: function () {
                            editlamp();
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



                $("#addexcel").attr("disabled", true);

                $('#l_comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].id;
                            }

                            $(this).combobox('select', data[0].id);

                        }
                    },
                    onSelect: function (record) {
                        $("#comaddrname").val(record.name);

                    }
                });


                var d = [];
                for (var i = 0; i < 18; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }
                $("#l_groupe").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });
                $("#l_groupe1").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });

                $("#l_groupe2").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });


                $('#gravidaTable').on('click-cell.bs.table', function (field, value, row, element)
                {

                });




            });
        </script>

        <style>

            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; }        

        </style>

    </head>

    <body>
        <div class="row" >
            <form id="formsearch">
                <div class="col-xs-12">
                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:10px;">
                                        网关编号
                                        &nbsp;</span>
                                </td>
                                <td>

                                    <span class="menuBox">
                                        <input id="l_comaddr2" name="l_comaddr" class="easyui-combobox"  style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;">
                                        部署情况
                                        &nbsp;</span>
                                </td>
                                <td>
                                    <select class="easyui-combobox" name="l_deplayment"  id="busu" style="width:150px; height: 30px">
                                        <option value="0">未部署</option>
                                        <option value="1">已部署</option>           

                                    </select>
                                </td>
                                <td>
                                    <button  type="button" style="margin-left:20px;" onclick="search()" class="btn btn-success btn-xm">
                                        搜索
                                    </button>&nbsp;
                                </td>
                            </tr>
                        </tbody>
                    </table> 
                </div>
            </form>
        </div>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol"  onclick="showDialog();" data-toggle="modal" data-target="#pjj33" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol" onclick="editsensorInfo()"   id="xiugai1">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteLamp();" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="addshow()">
                添加到首页显示
            </button>
            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                导入Excel
            </button>
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                导出Excel
            </button>
        </div>

        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>


        <!-- 添加 -->
        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="传感器添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkLampAdd()">      
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" >网关编号</span>&nbsp;
                                <span class="menuBox">

                                    <input id="l_comaddr"  class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span> 
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >寄存器位置</span>&nbsp;
                                <input id="dreg"  name="dreg" style="width:150px;display: inline;" placeholder="寄存器位置" type="text">
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" >信息点号</span>&nbsp;
                                <input id="informationnum" name="informationnum" style="width:150px;display: inline;" placeholder="信息点号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >传感器名</span>&nbsp;
                                <input id="name" class="form-control"  name="name" style="width:150px;display: inline;" placeholder="请输入传感器名称" type="text">

                            </td>
                        </tr>   

                        <tr>
                            <td>
                                <span style="margin-left:20px;" >&#8195;&#8195;站号</span>&nbsp;
                                <input id="sitenum" class="form-control" name="sitenum" style="width:150px;display: inline;" placeholder="站号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >工作模式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox"  id="worktype" name="worktype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0">时间</option>
                                        <option value="1">场景</option>
                                        <option value="2">信息点</option>
                                    </select>
                                </span>
                            </td>
                        </tr>                  
                        <tr>
                            <td>
                                <span style="margin-left:20px;" >&#8195;&#8195;单位</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="unit" name="unit" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="m/s">m/s</option>
                                        <option value="㎜">㎜</option>
                                        <option value="℃">℃</option>
                                        <option value="%">%</option>
                                    </select>
                                </span>
                            </td> 

                        </tr> 
                    </tbody>
                </table>
            </form>                        
        </div>
        <!--编辑-->
        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="传感器编辑">
            <form action="" method="POST" id="formedi" onsubmit="return editlamp()">  
                <input type="hidden" id="hide_id" name="id" />
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" >网关编号</span>&nbsp;
                                <span class="menuBox">
                                    <input  readonly="true"  id="l_comaddr1" readonly="true"  class="form-control"  name="l_comaddr" style="width:150px;display: inline;" placeholder="网关地址" type="text">     
                                </span>  
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >寄存器位置</span>&nbsp;
                                <input id="dreg1"  name="dreg" style="width:150px;display: inline;" placeholder="寄存器位置" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" >信息点号</span>&nbsp;
                                <input id="informationnum1" name="informationnum" style="width:150px;display: inline;" placeholder="信息点号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >传感器名</span>&nbsp;
                                <input id="name1" class="form-control"  name="name" style="width:150px;display: inline;" placeholder="请输入传感器名称" type="text">

                            </td>
                        </tr>   

                        <tr>
                            <td>
                                <span style="margin-left:20px;" >&#8195;&#8195;站号</span>&nbsp;
                                <input id="sitenum1"  name="sitenum" style="width:150px;display: inline;" placeholder="站号" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" >工作模式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox"  id="worktype1" name="worktype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0">时间</option>
                                        <option value="1">场景</option>
                                        <option value="2">信息点</option>
                                    </select>
                                </span>
                            </td>
                        </tr>                  
                        <tr>
                            <td>
                                <span style="margin-left:20px;" >&#8195;&#8195;单位</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="unit1" name="unit" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="m/s">m/s</option>
                                        <option value="㎜">㎜</option>
                                        <option value="℃">℃</option>
                                        <option value="%">%</option>
                                    </select>
                                </span>
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
    </body>
</html>