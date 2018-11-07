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

            function StartCheck() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 1, vv); //01 03 F24   
                dealsend2("A5", data, 1, "allCallBack", comaddr, 0, 0, 0, 0);
            }

            function StopCheck() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 2, vv); //01 03 F24   
                dealsend2("A5", data, 2, "allCallBack", comaddr, 0, 0, 0, 0);
            }


            function refleshgayway(obj) {
                var vv = [];
                var l_comaddr = "17020101";
                var num = randnum(0, 9) + 0x70;
                var data = "0"
                dealsend2("ALL", data, 1, "ALL", l_comaddr, 0, 0, 0);
            }

            function readTrueTimeCB(obj) {
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {

                        v = v + sprintf("%02x", data[i]) + " ";
                    }

                    var yh = data[23] >> 4 & 0x0F;
                    var yl = data[23] & 0x0F;
                    var mh = data[22] >> 4 & 0x03;
                    var ml = data[22] & 0x0F;
                    var dh = data[21] >> 4 & 0x0F;
                    var dl = data[21] & 0x0F;
                    var hh = data[20] >> 4 & 0x0F;
                    var hl = data[20] & 0x0F;
                    var minh = data[19] >> 4 & 0x0F;
                    var minl = data[19] & 0x0F;
                    var sh = data[18] >> 4 & 0x0F;
                    var sl = data[18] & 0x0F;
                    var y = sprintf("20%d%d", yh, yl);
                    var m = sprintf("%d%d", mh, ml);
                    var d = sprintf("%d%d", dh, dl);
                    var h = sprintf("%d%d", hh, hl);
                    var min = sprintf("%d%d", minh, minl);
                    var s = sprintf("%d%d", sh, sl);
                    var timestr = sprintf("%s-%s-%s %s:%s:%s", y, m, d, h, min, s);
                    $("#gaytime").val(timestr);
                    console.log(timestr);
                }

            }
            function readTrueTime() {
                var o1 = $("#form1").serializeObject();
                var vv = [0];
                var l_comaddr = o1.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 1, vv); //01 03
                dealsend2("AC", data, 1, "readTrueTimeCB", l_comaddr, 0, 0, 0);
            }

            function  setChgTimeCB(obj) {
                obj.id = obj.val;
                console.log(obj.domain)

                if (obj.status == "success") {
                    $.ajax({async: false, url: "param.param.updatesite.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                layerAler(langs1[161][lang]); //读取站点信息成功
                                var opt = {
                                    url: "test1.f5.h1.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#gravidaTable").bootstrapTable('refresh', opt);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }

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

            function readjwd() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFE, num, 0, 10, vv); //01 03 F24   
                dealsend2("FE", data, 10, "allCallBack", comaddr, 0, 0, obj.l_groupe);
            }
            function setjwd() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var long = obj.Longitude;
                var lati = obj.latitude;
                var longarr = long.split(".");
                var latiarr = lati.split(".");
                console.log(longarr.length);
                if (longarr.length != 2 || latiarr.length != 2) {
                    layerAler("经纬度错误输入格式");
                    return;
                }
                if (longarr[0].length != 4 || longarr[1].length != 4) {
                    layerAler("经度4位十进制数字");
                    return;
                }
                if (latiarr[0].length != 4 || latiarr[1].length != 4) {
                    layerAler("纬度应是4位十进制数字");
                    return;
                }
                if (isNumber(longarr[0]) == false || isNumber(longarr[1]) == false) {
                    layerAler("经度应是4位十进制数字");
                    return;
                }
                if (isNumber(latiarr[0]) == false || isNumber(latiarr[1]) == false) {
                    layerAler("纬度应是4位十进制数字");
                    return;
                }
                if (isNumber(obj.timezone) == false) {
                    layerAler("时区应是数字");
                    return;
                }
                if (isNumber(obj.outoffset) == false) {
                    layerAler("日出偏移应是数字");
                    return;
                }
                if (isNumber(obj.inoffset) == false) {
                    layerAler("日落偏移应是数字");
                    return;
                }
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                var longh = Str2BytesH(longarr[0]);
                var longl = Str2BytesH(longarr[1]);

                var latih = Str2BytesH(latiarr[0]);
                var latil = Str2BytesH(latiarr[1]);
                vv.push(longl[1]);
                vv.push(longl[0]);
                vv.push(longh[1]);
                vv.push(longh[0]);

                vv.push(latil[1]);
                vv.push(latil[0]);
                vv.push(latih[1]);
                vv.push(latih[0]);

                vv.push(parseInt(obj.inoffset)); //新组号  1字节      
                vv.push(parseInt(obj.outoffset)); //新组号  1字节    
                vv.push(parseInt(obj.areazone));
                vv.push(parseInt(obj.timezone));

                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xff, num, 0, 10, vv); //01 03 F24   
                dealsend2("FF", data, 10, "allCallBack", comaddr, 0, 0, obj.l_groupe);
            }

            function setGroupe() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 110, vv); //01 03 F24    
                dealsend2("A4", data, 110, "allCallBack", comaddr, 0, 0, obj.l_groupe);
            }

            function delAllplan() {
                var o = $("#form1").serializeObject();
                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 180, vv); //01 03 F24    
                dealsend2("A4", data, 180, "allCallBack", comaddr, 0, 0, 0);
            }
            function delAllLoopPlan() {
                var o = $("#form1").serializeObject();
                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 402, vv); //01 03 F24    
                dealsend2("A4", data, 402, "allCallBack", comaddr, 0, 0, 0);
            }
            function delAllLoop() {
                var o = $("#form1").serializeObject();
                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 340, vv); //01 03 F24    
                dealsend2("A4", data, 340, "allCallBack", comaddr, 0, 0, 0);
            }
            function delAllLamp() {

                var o = $("#form1").serializeObject();

                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 108, vv); //01 03 F24    

                dealsend2("A4", data, 108, "allCallBack", comaddr, 0, 0, 0);
            }
            function setWowktype() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                console.log(obj);
                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_worktype)); //新工作方式  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 120, vv); //01 03 F24    

                dealsend2("A4", data, 120, "allCallBack", comaddr, 0, 0, obj.l_worktype);
            }

            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
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

            function setChgTimeCB(obj) {
                if (obj.status == "success") {
                    layerAler(langs1[179][lang]);  //设置换日时间和冻结时间成功
                }
            }

            function setChgTime() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var o4 = obj.time4;
                var o3 = obj.time3;
                var oo = {"o4": o4, "o3": o3};
                var a = o4.split(":");
                var b = o3.split(":");

                var h1 = parseInt(a[0], 16);
                var m1 = parseInt(a[1], 16);

                var h2 = parseInt(b[0], 16);
                var m2 = parseInt(b[1], 16);
                var vv = [];
                vv.push(h1);
                vv.push(m1);
                vv.push(h2);
                vv.push(m2);
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 4, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setChgTimeCB", comaddr, 0, oo, 0);
            }


            function setAPNCB(obj) {
                if (obj.status == "success") {
                    layerAler(langs1[180][lang]);  //设置运营商APN成功
                }
            }

            function setAPN() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                if (obj.apn == "") {
                    layerAler(langs1[181][lang]);  //apn不能为空
                    return;
                }
                if (obj.apn.length > 16) {
                    layerAler(langs1[176][lang]);
                    return;
                }
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置运营商APN");
                var vv = [];
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

                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 2, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setAPNCB", comaddr, 0, apn, 0);
            }

            function setInspectcb(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler(langs1[182][lang]);  //灯具通信失联巡检次数成功
                }
                if (obj.status == "fail") {
                    layerAler(langs1[183][lang]);  //灯具通信失联巡检次数失败
                }
            }
            function setInspect() {
                var obj1 = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var o = obj.inspect;
                if (o == "") {
                    layerAler(langs1[184][lang]);  //请填写巡检次数
                    return;
                }
                var vv = [];
                vv.push(parseInt(o));

                var comaddr = obj1.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 202, vv); //01 03 F24    
                dealsend2("A4", data, 202, "setInspectcb", comaddr, 0, 0, 0);
            }

            function readInspectcb(obj) {
                console.log(obj);
            }
            function readInspect() {
                var vv = [];
                var obj = $("#form1").serializeObject();
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 202, vv); //01 03 F24    
                dealsend2("AA", data, 202, "readInspectcb", comaddr, 0, 0, 0);
            }


            function readAreaCb(obj) {
                if (obj.status == "success") {
                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;
                    //dns解析的ip
                    var area1 = sprintf("%02x%02x", src[z + 1], src[z]);
                    var area2 = sprintf("%02x%02x", src[z + 3], src[z + 2]);
                    $("#area").val(area1);
                    $("#addr").val(area2);
                    console.log(area1, area2);
                }

            }
            function readArea() {
                var vv = [];
                var obj = $("#form1").serializeObject();
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFE, num, 0, 1, vv); //01 03 F24    
                dealsend2("FE", data, 1, "readAreaCb", comaddr, 0, 0, 0);
            }
            function setAreaCB(obj) {
                if (obj.status == "success") {
                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;

                }
            }
            function setArea() {
                var vv = [];
                var obj = $("#form1").serializeObject();
                var obj1 = $("#form2").serializeObject();
                if (!isNumber(obj1.area) || obj1.area.length != 4) {
                    layerAler(langs1[185][lang]); //区划码是2位字节4数字长度
                    return;
                }
                if (!isNumber(obj1.addr) || obj1.addr.length != 4) {
                    layerAler(langs1[185][lang]);
                    return;
                }

                var arr = Str2BytesH(obj1.area);
                vv.push(arr[1]);
                vv.push(arr[0]);

                arr = Str2BytesH(obj1.addr);
                vv.push(arr[1]);
                vv.push(arr[0]);


//                var h = area >> 8 && 0x00ff;
//                var l = area & 0x00ff;
//                vv.push(l);
//                vv.push(h);



//                var addr = parseInt(obj1.addr, 106);
//                var h1 = addr >> 8 && 0x0f;
//                var l1 = addr & 0x0f;
//                vv.push(l1);
//                vv.push(h1);

                console.log(area);
                console.log(obj1);
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFF, num, 0, 1, vv); //01 03 F24    
                dealsend2("FF", data, 1, "setAreaCB", comaddr, 0, 0, 0);
            }
            //检测时间
            function jcsj() {
                var obj = {};
                obj.jd = $("#Longitude").val();
                obj.wd = $("#latitude").val();
                if (obj.jd == "" || obj.wd == "") {
                    layerAler("请读取网关经纬度");
                    return;
                }
                $.ajax({async: false, url: "login.rc.r.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var list = data.cl[0];

                        $("#sunrise").val(list.rc);  //日出
                        $("#sunset").val(list.rl);  //日落
                        $("#sunriseSunset").show();
                        console.log(data);

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

            }

            $(function () {
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
                <h3 class="panel-title"><span id="186" name="xxx">网关参数设置</span></h3>
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
                                                <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;

                                                <span class="menuBox">
                                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                           data-options="editable:true,valueField:'id', textField:'text' " />
                                                </span>  
                                            </td>
                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="187">功能选择</span>&nbsp;

                                                <span class="menuBox">
                                                    <select class="easyui-combobox" id="type" name="type" data-options="editable:false,valueField:'id', textField:'text' " style="width:200px; height: 30px">
                                                        <option value="1" >主站域名或IP设置</option>
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

                        <div class="row" id="row2" style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span  style="margin-left:10px;"  name="xxx" id="195">换日时间</span>
                                                <input id="time4" name="time4" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                                                <span  style="margin-left:10px;"  name="xxx" id="196">冻结时间</span>
                                                <input id="time3" name="time3" style=" height: 30px; width: 100px;"  class="easyui-timespinner">
                                                &nbsp;
                                            </td>

                                        </tr>
                                        <tr><td></td></tr>
                                        <tr>
                                            <td>
                                                <button   type="button" onclick="setChgTime()" class="btn btn-success btn-sm"><span name="xxx" id="197">设置换日冻结时间</span></button>
                                                <button  type="button" onclick="readTime()" class="btn btn-success btn-sm"><span name="xxx" id="198">读取换日冻结时间</span></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row3"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>


                                                <span style="margin-left:10px; " name="xxx" id="199">通信巡检次数</span>&nbsp;
                                                <input id="inspect" class="form-control" name="inspect" value="" style="width:100px;" placeholder="灯具通信失联巡检次数" type="text">
                                                <button  type="button" onclick="setInspect()" class="btn btn-success btn-sm"><span name="xxx" id="200">设置通信失联巡检次数</span></button>
                                                <button  type="button"  onclick="readInspect()" class="btn btn-success btn-sm"><span name="xxx" id="201">读取通信失联巡检次数</span></button>
                                            </td>

                                        </tr>


                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row4"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px; " name="xxx" id="202">网关终端时间</span>&nbsp;
                                                <input id="gaytime" readonly="true" class="form-control" name="gaytime" value="" style="width:150px;" placeholder="网关终端时间" type="text">
                                                <button  type="button" onclick="readTrueTime()" class="btn btn-success btn-sm"><span name="xxx" id="203">读取时间</span></button>&nbsp;
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row5" style=" display: none">
                            <div class="col-xs-12" >

                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                                    <tbody>

                                        <tr >
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="204" >行政区域码</span>
                                            <td>

                                                <input id="area"  class="form-control" name="area" style="width:150px;"  placeholder="区域码" type="text">&nbsp;
                                            </td>

                                        </tr>                                   

                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="25" >网关地址</span>
                                            </td>

                                            <td >
                                                <input id="addr" class="form-control" name="addr" value="" style="width:150px;" placeholder="终端地址" type="text">
                                                &nbsp;
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <button  type="button" onclick="readArea()" class="btn btn-success btn-sm"><span id="205" name="xxx">读取</span> </button>
                                                <button type="button"  onclick="setArea()" class="btn  btn-success btn-sm" style="margin-left: 2px;"><span id="49" name="xxx">设置</span></button>

                                            </td>

                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row6"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="206">新组号</span>
                                                <span class="menuBox">
                                                    <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:100px; height: 30px" 
                                                           data-options="editable:true,valueField:'id', textField:'text' " />
                                                </span> 
                                                <!-- <button  type="button" onclick="chgLampGroupe()" class="btn btn-success btn-sm">更换所有灯具的组号</button>&nbsp; -->
                                                <button  onclick="setGroupe()" style=" margin-left: 2px;" class="btn btn-success btn-xs" name="xxx" id="207" >更换</button>

                                                <span style=" margin-left: 10px;" name="xxx" id="208">新工作方式</span>&nbsp;
                                                <span class="menuBox">
                                                    <select class="easyui-combobox" id="l_worktype" name="l_worktype" data-options='editable:false' style="width:100px; height: 30px">
                                                        <option value="0" >时间</option>
                                                        <option value="1">经纬度</option>
                                                        <option value="2">场景</option>           
                                                    </select>
                                                </span> 
                                                <button  onclick="setWowktype()" style=" margin-left: 2px;" class="btn btn-success btn-xs"  name="xxx" id="207">更换</button>

                                                <button  type="button" onclick="delAllLamp()" class="btn btn-success btn-sm"><span id="209" name="xxx">删除全部灯具信息</span></button>
                                                <button  style="float:right; margin-right: 5px;" type="button" onclick="delAllplan()" class="btn btn-success btn-sm"><span name="xxx" id="210">删除全部灯时间表</span></button>
                                            </td>
                                        </tr>



                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row7"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="delAllLoop()" class="btn btn-success btn-sm"><span id="211" name="xxx">删除全部回路开关信息</span></button>&nbsp;
                                                <button  type="button" onclick="delAllLoopPlan()" class="btn btn-success btn-sm"><span id="212">删除全部回路时间表</span></button>&nbsp;
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row8"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style=" float: right; " name="xxxx" id="199">经度&nbsp;</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="Longitude" name="Longitude"  value="" style="width:100px;" placeholder="经度" type="text">
                                            </td>
                                            <td>
                                                <span style="float: right; " name="xxxx" id="199">纬度&nbsp;</span>
                                            </td>
                                            <td>
                                                <input id="latitude" name="latitude"  value="" style="width:100px;" placeholder="纬度" type="text">
                                            </td>


                                            <td>
                                                <span style="float: right; " name="xxxx" id="199">&nbsp;时区范围:</span>


                                            </td>
                                            <td>
                                                <select class="easyui-combobox" id="areazone" name="areazone" data-options="editable:false,valueField:'id', textField:'text'" style="width:100px; height: 30px">
                                                    <option value="0" >东经</option>
                                                    <option value="1">西经</option>
                                                </select>

                                            </td>




                                            <td>
                                                <span style="float: right; " name="xxxx" id="199">&nbsp;时区</span>
                                            </td>



                                            <td>
                                                <input id="timezone" name="timezone" value="" style="width:100px;" placeholder="时区" type="text">

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px; " name="xxxx" id="199">日出偏移</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="outoffset" class="form-control" name="outoffset" value="" style="width:100px;" placeholder="日出偏移" type="text">
                                            </td>
                                            <td>
                                                <span style="margin-left:10px; " name="xxxx" id="199">日落偏移</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="inoffset"  name="inoffset" value="" style="width:100px;" placeholder="日落偏移" type="text">
                                            </td> 
                                            <td >
                                                <button  type="button" onclick="readjwd()" class="btn btn-success btn-sm"><span id="205" name="xxx">读取</span> </button>
                                            </td>
                                            <td>     <button type="button"  onclick="setjwd()" class="btn  btn-success btn-sm" style="margin-left: 10px;"><span id="49" name="xxx">设置</span></button></td>
                                            <td>     <button type="button"  onclick="jcsj()" class="btn  btn-success btn-sm" style="margin-left: 0px;"><span >检测时间</span></button></td>

                                        </tr>

                                        <tr id="sunriseSunset" style=" display: none">
                                            <td>
                                                <span style="margin-left:10px;">日出时间</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="sunrise" class="form-control" value="" style="width:100px;" placeholder="日出时间" type="text">
                                            </td>
                                            <td>
                                                <span style="margin-left:10px; " name="xxxx" id="199">日落时间</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="sunset"   value="" style="width:100px;" placeholder="日落偏移" type="text">
                                            </td> 
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row9"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="StartCheck()" class="btn btn-success btn-sm"><span id="415" name="xxx">启动巡测任务</span></button>&nbsp;
                                                <button  type="button" onclick="StopCheck()" class="btn btn-success btn-sm"><span id="416">结束巡测任务</span></button>&nbsp;
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
