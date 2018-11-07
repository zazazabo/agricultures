<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function excel() {
                $('#dialog-excel').dialog('open');
                return false;

            }

            //导入excel的添加按钮事件
            function addexcel() {
                var selects = $('#warningtable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[350][lang]); //请选择您要保存的数据
                    return;
                }
                addlogon(u_name, "添加", o_pid, "回路管理", "导入Excel文件");
                var pid = parent.parent.getpojectId();
                for (var i = 0; i <= selects.length - 1; i++) {
                    var comaddr = selects[i].网关地址;
                    var l_code = selects[i].回路编号;
                    var obj = {};
                    obj.pid = pid;
                    obj.comaddr = comaddr;
                    $.ajax({async: false, url: "login.loop.isporject.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                $.ajax({async: false, url: "login.loop.getl_code.action", type: "POST", datatype: "JSON", data: {l_code: l_code},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 0) {
                                            var cmdname = selects[i].网关名称;
                                            var lname = selects[i].回路名称;
                                            var groupe = selects[i].回路组号;
                                            var adobj = {};
                                            adobj.l_name = lname;
                                            adobj.l_code = l_code;
                                            adobj.l_worktype = 0;
                                            adobj.l_comaddr = comaddr;
                                            adobj.l_deplayment = 0;
                                            adobj.l_groupe = groupe;
                                            adobj.name = cmdname;
                                            $.ajax({url: "login.loop.addloop.action", async: false, type: "get", datatype: "JSON", data: adobj,
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

            function checkLoopAdd() {
                var o = $("#formadd").serializeObject();
                if (o.l_comaddr == "") {
                    layerAler(langs1[172][lang]);  //网关不能为空
                    return  false;
                }
                if (isNumber(o.l_factorycode) == false) {
                    layerAler(langs1[358][lang]);  //回路编号必须数字
                    return false;
                }
                if (parseInt(o.l_factorycode) > 54 && parseInt(o.l_factorycode) >= 1) {
                    layerAler(langs1[359][lang]);  //回路编号1字节必须在1-54
                    return false;
                }
                o.name = o.comaddrname;

                var namesss = false;

                addlogon(u_name, "添加", o_pid, "回路管理", "添加回路");
                $.ajax({async: false, cache: false, url: "loop.loopForm.getLoopList.action", type: "GET", data: o,
                    success: function (data) {
                        if (data.total > 0) {
                            layerAler(langs1[360][lang]); //此回路已存在
                            return false;
                        }
                        if (data.total == 0) {
                            $.ajax({async: false, cache: false, url: "loop.loopForm.addloop.action", type: "GET", data: o,
                                success: function (data) {
                                    $("#gravidaTable").bootstrapTable('refresh');
                                    namesss = true;
                                },
                                error: function () {
                                    layerAler("系统错误，刷新后重试");
                                }
                            });
                            return  false;
                        }

                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {icon: 6, offset: 'center'
                        });

                    }

                })

                return  namesss;
            }



            function switchWorkTypeCB(obj) {
                console.log(obj);
                if (obj.status == "success") {

                    var oo = {};
                    oo.id = obj.param;
                    oo.l_worktype = obj.val;
                    //  addlogon(u_name, "修改", o_pid, "回路管理", "修改回路");

                    $.ajax({async: false, url: "loop.loopForm.modifyWorkType.action", type: "get", datatype: "JSON", data: oo,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                //修改成功
                                layerAler(langs1[361][lang]);  //切换成功

                                $('#gravidaTable').bootstrapTable('refresh');
//                                layer.open({content: langs1[143][lang], icon: 1,
//                                    yes: function (index, layero) {
//                                        $("#gravidaTable").bootstrapTable('refresh');
//                                        layer.close(index);
//                                    }
//                                });
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });








                }

            }
            function switchWorkType() {
                var o = $("#form2").serializeObject();
                if (o.l_deployment == "0") {
                    layerAler(langs1[362][lang]);   //部署后能能切换
                    return;
                }
                console.log(o);
                var vv = [];
                var l_code = parseInt(o.l_code);

                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(b);
                vv.push(a);
                vv.push(parseInt(o.l_worktype2));
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 380, vv); //01 03 F24    
                dealsend2("A4", data, 380, "switchWorkTypeCB", comaddr, o.l_code, o.id, o.l_worktype2);
            }


            function modifyLoopName() {
                var o = $("#form2").serializeObject();
                o.id = o.hide_id;
                addlogon(u_name, "修改", o_pid, "回路管理", "修改回路");
                $.ajax({async: false, url: "loop.loopForm.modifyname.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            //修改成功
                            layer.open({content: langs1[143][lang], icon: 1,
                                yes: function (index, layero) {
                                    search();
                                    //$("#gravidaTable").bootstrapTable('refresh');
                                    layer.close(index);
                                }
                            });
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                return  false;
            }


            function modifyModal() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');

                if (selects.length == 0) {
                    //请勾选您要编辑的数据
                    layer.alert(langs1[363][lang], {
                        icon: 6,
                        offset: 'center'
                    });
                    return;
                }
                var select = selects[0];
                console.log(select);

                $("#l_factorycode1").val(select.l_factorycode);
                $("#l_comaddr1").combobox('setValue', select.l_comaddr);
                $("#l_deployment").val(select.l_deplayment);
                $("#comaddrname1").val(select.commname);
                $("#l_name1").val(select.l_name);
                $("#l_code").val(select.l_code);
                $("#hide_id").val(select.id);
                $('#l_worktype1').combobox('setValue', select.l_worktype);
                $("#l_groupe1").combobox('setValue', select.l_groupe);
                if (select.l_deplayment == "1") {
                    $("#trworktype").show();
                    $('#l_worktype1').combobox('readonly', true);
                    // $("#l_groupe1").combobox('readonly', true);
                } else if (select.l_deplayment == "0") {
                    $("#trworktype").hide();
                    $('#l_worktype1').combobox('readonly', false);
                    //$("#l_groupe1").combobox('readonly', false);
                }

                $('#dialog-edit').dialog('open');

            }


            //搜索
            function  search() {
                var obj = $("#formsearch").serializeObject();
                var opt = {
                    url: "loop.loopForm.getLoopList.action",
                    silent: false,
                    query: obj
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);
            }

            $(function () {


                $('#gravidaTable').bootstrapTable({
//                    url: 'loop.loopForm.getLoopList.action',
                    //服务器url
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
                            field: 'commname',
                            title:'网关名称', //网关名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_comaddr',
                            title: '网关地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_name',
                            title: "回路名称",
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_code',
                            title: '回路装置号', //回路装置号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title:'回路编号', //回路编号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_groupe',
                            title: '回路组号', //回路组号
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }
                            }
                        }, {
                            field: 'l_worktype',
                            title: '控制方式', //控制方式
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "时间表";
                                    return value;
                                } else if (value == 1) {
                                    value = "经纬度";
                                    return value;
                                }
                            }
                        }, {
                            field: 'l_deployment',
                            title: '部署情况', //部署情况
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.l_deplayment == "0") {
                                    var str = "<span class='label label-warning'>" + langs1[318][lang] + "</span>";  //未部署
                                    return  str;
                                } else if (row.l_deplayment == "1") {
                                    var str = "<span class='label label-success'>" + langs1[319][lang] + "</span>";  //已部署
                                    return  str;
                                }
                            }
                        }],
                    singleSelect: true,
                    clickToSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 5,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            pid: "${param.pid}"   
                        };      
                        return temp;  
                    },
                });






                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }


                $('#comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        console.log(row[opts.textField]);
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].id;
                            }

                            $(this).combobox('select', data[0].id);
                        }
                    }, onSelect: function (record) {
                        $("#comaddrname").val(record.name);
                    }
                });

                $("#l_comaddr").combobox({
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
                            url: "loop.loopForm.getLoopList.action",
                            query: obj,
                            silent: false
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });


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
                            title: langs1[345][lang], //序号
                            field: '序号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: langs1[314][lang], //网关名称
                            field: '网关名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '网关地址',
                            title: langs1[25][lang], //网关地址
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '回路名称',
                            title: langs1[331][lang], //回路名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '回路编号',
                            title: langs1[364][lang], //回路编号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '回路组号',
                            title: langs1[365][lang], //回路组号
                            width: 25,
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
                            alert(langs1[348][lang]);  //文件类型不正确
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
                        var headStr = '序号,网关名称,网关地址,回路名称,回路编号,回路组号';
                        for (var i = 0; i < persons.length; i++) {
                            if (Object.keys(persons[i]).join(',') !== headStr) {
                                alert(langs1[366][lang]);   //导入文件格式不正确
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
                //####### Dialogs
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
                    height: 300,
                    position: "top",
                    buttons: {
                        修改: function () {
                            modifyLoopName();
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


                var d = [];
                for (var i = 0; i < 19; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }

                $("#l_groupe").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });

                $("#l_groupe1").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });


                $("#add").attr("disabled", true);
                $("#update").attr("disabled", true);
                $("#shanchu").attr("disabled", true);
                $("#addexcel").attr("disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {

                                if (rs[i].code == "600201" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    $("#addexcel").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "600202" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "600203" && rs[i].enable != 0) {
                                    $("#shanchu").attr("disabled", false);
                                    continue;
                                }
                            }
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });




                $("#shanchu").click(function () {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler(langs1[263][lang]);   //请勾选您要删除的数据
                        return;
                    }
                    layer.confirm(langs1[145][lang], {//确定要删除吗？
                        btn: [langs1[146][lang], langs1[147][lang]], //确定、取消按钮
                        icon: 3,
                        offset: 'center',
                        title: langs1[174][lang]  //提示
                    }, function (index) {
                        addlogon(u_name, "删除", o_pid, "回路管理", "删除回路");
                        for (var i = 0; i < selects.length; i++) {
                            var select = selects[i];
                            var l_deployment = select.l_deplayment;
                            if (l_deployment == 1) {
                                layerAler(langs1[368][lang]);  //已部署不能删除
                                continue;
                            } else {
                                $.ajax({url: "loop.loopForm.deleteLoop.action", type: "POST", datatype: "JSON", data: {id: select.id},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            layer.open({
                                                content: langs1[342][lang], //删除成功
                                                icon: 1,
                                                yes: function (index, layero) {
                                                    search();
                                                    layer.close(index);
                                                }
                                            });
                                        }
                                        layer.close(index);
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                            }




                        }

                        layer.close(index);

                    });
                });

            })



        </script>


        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } 

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


        <!--        <a data-toggle="modal" href="lamp.jsp" data-target="#modal">Click me</a>-->


        <div class="row" >
            <form id="formsearch">
                <div class="col-xs-12">



                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 10px; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>
                                <td>
                                    <span style="margin-left:10px;">
                                        <span id="25" name="xxxx">网关地址</span>
                                        &nbsp;</span>
                                </td>
                                <td>

                                    <span class="menuBox">
                                        <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;">
                                        <span id="317" name="xxxx">部署情况</span>
                                        &nbsp;</span>
                                </td>
                                <td>
                                    <select class="easyui-combobox" id="busu" name="l_deplayment" style="width:150px; height: 30px">
                                        <option value="0">未部署</option>
                                        <option value="1">已部署</option>           
                                    </select>
                                </td>
                                <td>
                                    <button  type="button" style="margin-left:20px;" onclick="search()" class="btn btn-success btn-xm">
                                        <!-- 搜索-->
                                        <span id="34" name="xxxx">搜索</span>
                                    </button>&nbsp;
                                </td>
                            </tr>
                        </tbody>
                    </table> 

                </div>
            </form>
        </div>





        <!-- 页面中的弹层代码 -->
        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" onclick="showDialog();" data-toggle="modal" data-target="#pjj5" id="add" >  
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;<span name="xxxx" id="65">添加</span>
            </button>

            <button class="btn btn-primary ctrol"  onclick="modifyModal();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;<span name="xxxx" id="66">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;<span name="xxxx" id="67">删除</span>
            </button>
            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;
                <span name="xxxx" id="353">导入Excel</span>
            </button>
            <button type="button" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                <span name="xxxx" id="110">导出Excel</span>
            </button>
        </div>

        <div style="width:100%;">
            <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
            </table>
        </div>



        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="回路添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkLoopAdd()">    
                <input type="hidden" name="pid" value="${param.pid}"/>
                <table >
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxxx" id="25">网关地址</span>&nbsp;
                                <span class="menuBox">

                                    <input id="comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span>  


                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxxx" id="314">网关名称</span>&nbsp;
                                <input id="comaddrname" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxxx" id="364">回路编号</span>&nbsp;
                                <input id="l_factorycode" class="form-control" name="l_factorycode" style="width:150px;display: inline;" placeholder="请输入回路编号" type="text">

                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxxx" id="331">回路名称</span>&nbsp;
                                <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                            </td>
                            </td>
                        </tr> 

                        <tr>
                            <td>

                                <span style="margin-left:20px;" name="xxxx" id="316">控制方式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="switch" name="l_worktype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0" selected="true">走时间</option>
                                        <option value="1">走经纬度</option>           
                                    </select>
                                </span>



                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxxx" id="369">所属组号</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="l_groupe" name="l_groupe"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                    </select>
                                </span>
                            </td>
                        </tr>                 


                    </tbody>
                </table> 
            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="回路修改">
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hide_id" name="id" />
                <input type="hidden" name="pid" value="${param.pid}"/>
                <input type="hidden" name="l_code" id="l_code" value=""/>
                <input type="hidden" id="l_deployment" name="l_deployment" />
                <table >
                    <tbody>
                        <tr>
                            <td>

                                <span style="margin-left:20px;" name="xxxx" id="25">网关地址</span>&nbsp;
                                <span class="menuBox">

                                    <input id="l_comaddr1" readonly="true" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span>  
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxxx" id="314">网关名称</span>&nbsp;
                                <input id="comaddrname1" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxxx" id="364">回路编号</span>&nbsp;
                                <input id="l_factorycode1" readonly="true"  class="form-control" name="l_factorycode"  style="width:150px;display: inline;" placeholder="回路编号" type="text">

                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxxx" id="331">回路名称</span>&nbsp;
                                <input id="l_name1" class="form-control"   name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                            </td>
                            </td>
                        </tr>                                   
                        <tr>
                            <td>

                                <span style="margin-left:20px;" name="xxxx" id="316">控制方式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" readonly="true" id="l_worktype1" name="l_worktype" data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">
                                        <option value="0" selected="true">走时间</option>
                                        <option value="1">走经纬度</option>           
                                    </select>
                                </span>

                            </td>
                            <td>

                            </td>
                            <td>


                                <span style="margin-left:10px;" name="xxxx" id="369">所属组号</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" readonly="true" id="l_groupe1" name="l_groupe"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                    </select>
                                </span>
                            </td>
                        </tr>                 
                        <!--                        <tr id="trworktype">
                                                    <td>
                        
                                                        <span style="margin-left:20px;" name="xxxx" id="316">控制方式</span>&nbsp;
                                                        <span class="menuBox">
                                                            <select class="easyui-combobox"  id="l_worktype2" name="l_worktype2" data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">
                                                                <option value="0" selected="true">走时间</option>
                                                                <option value="1">走经纬度</option>           
                                                            </select>
                                                        </span>
                        
                                                    </td>
                                                    <td>
                                                        <span name="xxxx" id="375" style=" margin-left: 10px;" class="label label-success" onclick="switchWorkType()" >在线修改</span>
                                                    </td>
                        
                                                </tr> -->

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
