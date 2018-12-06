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

            .btn { margin-left: 20px;}
        </style>

        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            function isValidIP(ip) {
                var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
                return reg.test(ip);
            }


            function readTrueTimeCB(obj) {
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {

                        v = v + sprintf("%02x", data[i]) + " ";
                    }

                    console.log(obj);




                    var yh = data[15];
                    var yl = data[16];



                    var mh = data[11];
                    var ml = data[12];

                    var dh = data[9];
                    var dl = data[10];



                    var hh = data[7];
                    var hl = data[8];

                    var minh = data[5];
                    var minl = data[6];

                    var sh = data[3];
                    var sl = data[4];
                    var y = sprintf("%d", yl);
                    var m = sprintf("%d", ml);
                    var d = sprintf("%d", dl);
                    var h = sprintf("%d", hl);
                    var min = sprintf("%d", minl);
                    var s = sprintf("%d", sl);
                    var timestr = sprintf("%s-%s-%s %s:%s:%s", y, m, d, h, min, s);
                    $("#gaytime").val(timestr);
//                    console.log(timestr);
                }

            }
            function readTrueTime() {

                var obj = $("#form1").serializeObject();
                if (obj.l_comaddr == "") {
                    layerAler('网关不能为空'); //
                    return;
                }


                console.log(obj);

                var vv = [];
                vv.push(1);
                vv.push(3);
                var infonum = 1313 | 0x1000;
                vv.push(infonum >> 8 & 0xff);
                vv.push(infonum & 0xff);
                vv.push(0);
                vv.push(7); //寄存器数目 2字节                         
                var data = buicode2(vv);
                dealsend2("03", data, "readTrueTimeCB", obj.l_comaddr, 0, 0, 0);




//                var o1 = $("#form1").serializeObject();
//                var vv = [0];
//                var l_comaddr = o1.l_comaddr;
//                var num = randnum(0, 9) + 0x70;
//                var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 1, vv); //01 03
//                dealsend2("AC", data, 1, "readTrueTimeCB", l_comaddr, 0, 0, 0);
            }


            function dateFormatter(value) {
                var date = new Date(value);
                var year = date.getFullYear().toString();
                var month = (date.getMonth() + 1);
                var day = date.getDate().toString();
                var hour = date.getHours().toString();
                var minutes = date.getMinutes().toString();
                var seconds = date.getSeconds().toString();
                if (month < 10) {
                    month = "0" + month;
                }
                if (day < 10) {
                    day = "0" + day;
                }
                if (hour < 10) {
                    hour = "0" + hour;
                }
                if (minutes < 10) {
                    minutes = "0" + minutes;
                }
                if (seconds < 10) {
                    seconds = "0" + seconds;
                }
                return year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds;
            }

            function setNowtime() {
                var myDate = new Date();//获取系统当前时
                var y = myDate.getFullYear();
                var m = myDate.getMonth() + 1;
                var d = myDate.getDate();
                var h = myDate.getHours();
                var mm = myDate.getMinutes();
                var s = myDate.getSeconds();

                var str = y + "-" + m + "-" + d + " " + h + ":" + mm + ":" + s;
                console.log(str);
                $('#nowtime').datetimebox('setValue', str);

            }

            function  setTimeNowCB(obj) {
                console.log(obj);
            }
            function setTimeNow() {
                var time = $('#nowtime').datetimebox('getValue');
                var myDate = new Date(time);

                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var y = sprintf("%d", myDate.getFullYear()).substring(2, 4);


                var m = sprintf("%d", myDate.getMonth() + 1);
                var d = sprintf("%d", myDate.getDate());
                var h = sprintf("%d", myDate.getHours());
                var mm = sprintf("%d", myDate.getMinutes());
                var s = sprintf("%d", myDate.getSeconds());

                var sunday = myDate.get

                var y1 = parseInt(y);
                var m1 = parseInt(m);
                var d1 = parseInt(d);
                var h1 = parseInt(h);
                var mm1 = parseInt(mm);
                var s1 = parseInt(s);

//                console.log(m);
//                var vv = [];
//                vv.push(parseInt(s, 16));
//                vv.push(parseInt(mm, 16));
//                vv.push(parseInt(h, 16));
//                vv.push(parseInt(d, 16));
//                vv.push(parseInt(m, 16));
//                vv.push(parseInt(y, 16));



                var comaddr = o.l_comaddr;
                var vv = new Array();
                var vv = [];
                vv.push(1);
                vv.push(0x10);

                var infonum = 3920 | 0x1000;
                vv.push(infonum >> 8 & 0xff); //起始地址
                vv.push(infonum & 0xff);
                vv.push(0);           //寄存器数目 2字节  
                vv.push(8);
                vv.push(16);           //字节数目长度  1字节

                vv.push(y1 >> 8 & 0xff)   //年
                vv.push(y1 & 0xff);

                vv.push(0);
                vv.push(3);             //星期
                vv.push(m1 >> 8 & 0xff)   //寄存器变量值
                vv.push(m1 & 0xff);



                vv.push(d1 >> 8 & 0xff)   //寄存器变量值
                vv.push(d1 & 0xff);

                vv.push(h1 >> 8 & 0xff)   //寄存器变量值
                vv.push(h1 & 0xff);
                vv.push(mm1 >> 8 & 0xff)   //寄存器变量值
                vv.push(mm1 & 0xff);


                vv.push(s1 >> 8 & 0xff)   //寄存器变量值
                vv.push(s1 & 0xff);

                vv.push(0);
                vv.push(1);













                var data = buicode2(vv);
                console.log(data);
                dealsend2("10", data, "setTimeNowCB", comaddr, 1, 0, 0);

            }
            function allCallBack(obj) {
                if (obj.status == "success") {
                    //更换分组
                    if (obj.msg == "A4" && obj.fn == 110) {
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 1, l_groupe: obj.val};
                        // console.log(o);
                        $.ajax({async: false, url: "lamp.lampform.modifyAllgroup.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[162][lang]);   //更新灯具表组号失败
                                }

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[163][lang]); //更换分组成功

                    } else if (obj.msg == "A4" && obj.fn == 120) {
                        //更换工作方式
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 1, l_worktype: obj.val};
                        $.ajax({async: false, url: "lamp.lampform.modifyALLworktype.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[164][lang]); //更新灯具表工作模式失败
                                }
                                console.log(data);

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[165][lang]); //更换工作方式
                    } else if (obj.msg == "A4" && obj.fn == 108) {
                        //删除所有灯配置
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 0};
                        $.ajax({async: false, url: "lamp.lampform.modifyAllDepayment.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[166][lang]); //更新灯具表部署状态失败
                                }
                                console.log(data);

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[167][lang]); //删除全部灯具信息成功
                    } else if (obj.msg == "A4" && obj.fn == 180) {
                        layerAler(langs1[168][lang]);  //删除全部灯时间表成功
                    } else if (obj.msg == "A4" && obj.fn == 340) {
                        //删除全部回路信息
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 0};
                        $.ajax({async: false, url: "loop.loopForm.modifyAllDepayment.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[169][lang]);  //更新回路表部署状态失败
                                }
                                console.log(data);

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[170][lang]);  //删除所有回路信息

                    } else if (obj.msg == "A4" && obj.fn == 402) {
                        layerAler(langs1[171][lang]);  //删除全部回路时间表成功
                    } else if (obj.msg == "FE" && obj.fn == 10) {
                        var data = Str2BytesH(obj.data);
                        var i = 18;
                        var wfw = data[i] & 0xf;
                        var qfw = data[i] >> 4 & 0xf;
                        var bfw = data[i + 1] & 0xf;
                        var sfw = data[i + 1] >> 4 & 0xf;
                        var gw = data[i + 2] & 0xf;
                        var sw = data[i + 2] >> 4 & 0xf;
                        var bw = data[i + 3] & 0xf;
                        var qw = data[i + 3] >> 4 & 0xf;
                        var jd = sprintf("%d%d%d%d.%d%d%d%d", qw, bw, sw, gw, sfw, bfw, qfw, wfw);
                        console.log(jd);
                        i = i + 4;
                        wfw = data[i] & 0xf;
                        qfw = data[i] >> 4 & 0xf;
                        bfw = data[i + 1] & 0xf;
                        sfw = data[i + 1] >> 4 & 0xf;
                        gw = data[i + 2] & 0xf;
                        sw = data[i + 2] >> 4 & 0xf;
                        bw = data[i + 3] & 0xf;
                        qw = data[i + 3] >> 4 & 0xf;
                        var wd = sprintf("%d%d%d%d.%d%d%d%d", qw, bw, sw, gw, sfw, bfw, qfw, wfw);
                        console.log(wd);
                        i = i + 4;
                        var outoffset = data[i];
                        var inoffset = data[i + 1];
                        i = i + 2;
                        var timezone1 = data[i];
                        var timezone2 = data[i + 1];
                        var str1 = sprintf("%02d", timezone2);
                        $("#Longitude").val(jd);
                        $("#latitude").val(wd);
                        $("#outoffset").val(inoffset);
                        $("#inoffset").val(inoffset);
                        $("#timezone").val(str1);
                        var str = timezone1 >> 4 & 0xf;
                        $("#areazone").combobox("select", str);
                    } else if (obj.msg == "FF") {
                        layerAler("success");
                    }

                }
            }



            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    // $(d).html(langs1[e][lang]);
                }
                var d = [];
                for (var i = 0; i < 18; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }
                $("#l_groupe").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });


                $('#time4').timespinner('setValue', '00:00');
                $('#time3').timespinner('setValue', '00:00');

            })

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function readSiteCB(obj) {

                if (obj.status == "success") {

                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;
                    //dns解析的ip
                    var a = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var aport = src[z + 5] * 256 + src[z + 4];
                    console.log(a, aport);

                    //备用dns解析的ip
                    z = z + 6;
                    var b = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var bport = src[z + 5] * 256 + src[z + 4];
                    console.log(a, bport);
                    //主用ip
                    z = z + 6;
                    var c = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var cport = src[z + 5] * 256 + src[z + 4];
                    console.log(c, cport);

                    //备用ip
                    z = z + 6;
                    var d = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var dport = src[z + 5] * 256 + src[z + 4];
                    console.log(d, dport);

                    z = z + 6;
                    var apn = "";
                    for (var i = z; i < z + 16; i++) {
                        var s = src[i] == 0 ? "" : String.fromCharCode(src[i]);
                        apn = apn + s;
                    }
                    console.log(apn);
                    z = z + 16;

                    var lenarea = src[i];
                    console.log(lenarea);

                    z = z + 1;
                    var area = "";
                    for (var i = z; i < z + lenarea; i++) {

                        area = area + String.fromCharCode(src[i]);
                    }
                    console.log(area);
                    $("#apn").val(apn);




                    if (lenarea > 0) {
                        $("#ip").val(area);
                        $("#port").val(aport);
                        $("#sitetype").combobox('select', 0);
                    } else if (lenarea == 0) {
                        $("#ip").val(c);
                        $("#port").val(cport);
                        $("#sitetype").combobox('select', 1);
                    }

                }
            }
            function readSite() {
                var obj = $("#form1").serializeObject();
                if (obj.l_comaddr == "") {
                    layerAler(langs1[172][lang]); //网关不能为空
                    return;
                }


                var comaddr = obj.l_comaddr;
                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 1, vv); //01 03 F24    
                dealsend2("AA", data, 1, "readSiteCB", comaddr, 0, 0, 0);
            }


            function readTimeCB(obj) {
                if (obj.status == "success") {

                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;

                    var s = src[z] >> 4 & 0x0f;
                    var g = src[z + 0] & 0x0f;
                    var sw = src[z + 1] >> 4 & 0x0f;
                    var gw = src[z + 1] & 0x0f;
                    var timechg = sprintf("%d%d:%d%d", s, g, sw, gw);
                    $('#time4').spinner('setValue', timechg);
                    z += 2;
                    var s2 = src[z] >> 4 & 0x0f;
                    var g2 = src[z + 0] & 0x0f;
                    var sw2 = src[z + 1] >> 4 & 0x0f;
                    var gw2 = src[z + 1] & 0x0f;
                    var timefloze = sprintf("%d%d:%d%d", s2, g2, sw2, gw2);
                    $('#time3').spinner('setValue', timefloze);
                    var timestr = sprintf("换日时间 time:%s 冻结时间:%s", timechg, timefloze);
                    console.log(timestr);

                }

            }
            function readTime() {
                var obj = $("#form1").serializeObject();
                console.log(obj);
                var comaddr = obj.l_comaddr;
                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 4, vv); //01 03 F24    
                dealsend2("AA", data, 4, "readTimeCB", comaddr, 0, 0, 0);
            }

            function setSiteCB(obj) {

                console.log(obj);
                if (obj.status == "success") {
                    layer.confirm(langs1[173][lang], {//确定修改网关指向的域名？
                        btn: [langs1[146][lang], langs1[147][lang]], //确定、取消按钮
                        icon: 3,
                        offset: 'center',
                        title: langs1[174][lang]  //提示
                    }, function (index) {
                        var v1 = [];
                        var num = randnum(0, 9) + 0x70;
                        var data1 = buicode(obj.comaddr, 0x04, 0x00, num, 0, 1, v1); //01 03 F24    
                        dealsend2("00", data1, 1, "", obj.comaddr, 0, 0, 0);
                        layer.close(index);
                    });
                }

            }

            function setSite() {
                var obj = $("#form2").serializeObject();
                var obj1 = $("#form1").serializeObject();
                console.log(obj);
                if (isNumber(obj.port) == false) {
                    layerAler(langs1[175][lang]); //端口只能是数字
                    return;
                }

                if (obj.apn.length > 16) {
                    layerAler(langs1[176][lang]); //apn长度不能超过16
                    return;
                }
                var hexport = parseInt(obj.port);
                var u1 = hexport >> 8 & 0x00ff;
                var u2 = hexport & 0x000ff;
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置主站信息");
                var vv = [];
                if (obj.sitetype == "1") {
                    if (isValidIP(obj.ip) == false) {
                        layerAler(langs1[177][lang]);  //不是合法ip
                        return;
                    }
                    for (var i = 0; i < 12; i++) {
                        vv.push(0);
                    }
                    var iparr = obj.ip.split(".");
                    for (var i = 0; i < iparr.length; i++) {
                        vv.push(parseInt(iparr[i]));
                    }
                    vv.push(u2);
                    vv.push(u1);

                    for (var i = 0; i < 6; i++) {
                        vv.push(0);
                    }


                    for (var i = 0; i < 16; i++) {
                        var apn = obj.apn;
                        var len = apn.length;
                        if (len <= i) {
                            vv.push(0);
                        } else {
                            var c = apn.charCodeAt(i);
                            vv.push(c);
                        }

                    }

                    vv.push(0);
                    var comaddr = obj1.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 1, vv); //01 03 F24    

                    dealsend2("A4", data, 1, "setSiteCB", comaddr, 0, 0, 0);

                } else if (obj.sitetype == "0") {



                    if (isValidIP(obj.ip) == true) {
                        layerAler(langs1[178][lang]);  // 请填写正确的域名
                        return;
                    }


                    if (obj.ip != "") {
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(u2);
                        vv.push(u1);

                        for (var i = 0; i < 18; i++) {
                            vv.push(0);
                        }

                        for (var i = 0; i < 16; i++) {
                            var apn = obj.apn.trim();
                            var len = apn.length;
                            if (len <= i) {
                                vv.push(0);
                            } else {
                                var c = apn.charCodeAt(i);
                                vv.push(c);
                            }

                        }

                        var ip = obj.ip.trim();
                        var len = ip.length;
                        vv.push(len);
                        for (var i = 0; i < len; i++) {
                            var c = ip.charCodeAt(i);
                            vv.push(c);
                        }
                        var comaddr = obj1.l_comaddr;
                        var num = randnum(0, 9) + 0x70;
                        var data = buicode(comaddr, 0x04, 0xA4, num, 0, 1, vv); //01 03 F24    

                        dealsend2("A4", data, 1, "setSiteCB", comaddr, 0, 0, 0);

                    }

                }

            }


            $(function () {
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
                            url: "sensor.sensorform.getSensorList.action",
                            query: obj,
                            silent: false
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });

                $('#type').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        }
                    },
                    onSelect: function (record) {
                        var rowdiv = $(".row");
                        for (var i = 0; i < rowdiv.length; i++) {
                            var row = rowdiv[i];
                            if (i == 0) {
                                continue;
                            }
                            $(row).hide();
                        }

                        var v = parseInt(record.id);
                        $(rowdiv[v]).show();

                    }
                });

            })
        </script>
    </head>
    <body>


        <div class="panel panel-success" >
            <div class="panel-heading">
                <h3 class="panel-title"><span >网关参数设置</span></h3>
            </div>
            <div class="panel-body" >
                <div class="container" style=" height:400px;"  >



                    <div class="row" style=" padding-bottom: 20px;" >
                        <div class="col-xs-12">
                            <form id="form1">
                                <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>

                                            <td>
                                                <span style="margin-left:10px;" >网关地址</span>&nbsp;

                                                <span class="menuBox">
                                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                           data-options="editable:true,valueField:'id', textField:'text' " />
                                                </span>  
                                            </td>
                                            <td>
                                                <span style="margin-left:10px;" >功能选择</span>&nbsp;

                                                <span class="menuBox">
                                                    <select class="easyui-combobox" id="type" name="type" data-options="editable:false,valueField:'id', textField:'text' " style="width:200px; height: 30px">
                                                        <option value="1" >主站域名或IP设置</option>
                                                        <option value="2">读取网关时间</option> 
                                                        <!--                                                        <option value="2">设置换日冻结时间参数</option>    
                                                                                                                <option value="3">设置通信巡检次数</option> 
                                                                                                                <option value="4">读取网关时间</option> 
                                                                                                                <option value="5">网关行政区划码</option> 
                                                                                                                <option value="6">设置灯具</option> 
                                                                                                                <option value="7">设置回路</option> 
                                                                                                                <option value="8">设置经纬度</option> 
                                                                                                                <option value="9">设置巡测任务</option> -->
                                                    </select>
                                                </span>  
                                            </td>
                                            <!--                                            <td>
                                                                                            <button type="button"  onclick="refleshgayway()" class="btn  btn-success btn-sm" style="margin-left: 2px;">刷新网关在线列表</button>
                                                                                        </td>-->
                                        </tr>
                                    </tbody>
                                </table> 
                            </form>
                        </div>
                    </div>

                    <form id="form2">
                        <div class="row" id="row1">
                            <div class="col-xs-12" >

                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="188">域名IP选择</span>
                                            </td>
                                            <td>

                                                <select class="easyui-combobox" id="sitetype" name="sitetype" style="width:150px; height: 30px">
                                                    <option value="0">域名</option>
                                                    <option value="1">ip</option>            
                                                </select>   

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="189">主站ip或域名</span>
                                            </td>
                                            <td>
                                                <input id="ip"  class="form-control" name="ip"  style="width:150px; " placeholder="输入主站域名" type="text">
                                            </td>
                                        </tr>

                                        <tr >
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="190" >端口</span>
                                            <td>

                                                <input id="port"  class="form-control" name="port" style="width:150px;"  placeholder="输入端口" type="text">
                                            </td>

                                        </tr>                                   

                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="191" >运营商APN</span>
                                            </td>

                                            <td >
                                                <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;" placeholder="输入APN" type="text">
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <button type="button"  onclick="setSite()" class="btn  btn-success btn-sm" style="margin-left: 2px;"><span name="xxx" id="192">设置主站信息</span></button>
                                                <button  type="button" onclick="readSite()" class="btn btn-success btn-sm"><span name="xxx" id="193">读取主站信息</span></button>
                                                <button  type="button"  onclick="setAPN()" class="btn btn-success btn-sm"><span name="xxx" id="194">设置运营商APN</span></button>
                                            </td>

                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <div class="row" id="row2"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px;">当前时间</span>
                                                <span class="menuBox">
                                                    <input class="easyui-datetimebox" name="nowtime" id="nowtime"
                                                           data-options="formatter:dateFormatter,showSeconds:true" value="" style="width:180px">
                                                </span> 
                                                <button  type="button" onclick="setNowtime()"  class="btn btn-success btn-sm"><span >获取当前时间</sspan>
                                                </button>&nbsp; 

                                                <button  style="float:right; margin-right: 5px;" type="button" onclick="setTimeNow()" class="btn btn-success btn-sm"><span >设置</span></button>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <span style="margin-left:10px; " name="xxx" id="202">网关终端时间</span>&nbsp;
                                                <input id="gaytime" readonly="true" class="form-control" name="gaytime" value="" style="width:150px;" placeholder="网关终端时间" type="text">
                                                <button  type="button" onclick="readTrueTime()" class="btn btn-success btn-sm">读取</button>&nbsp;
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>




                    </form>
                </div>



            </div>


    </body>
</html>
