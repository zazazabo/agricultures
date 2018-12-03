/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
 //获取当前时间
            function getNowFormatDate2() {
                var date = new Date();
                var seperator1 = "-";
                var seperator2 = ":";
                var month = date.getMonth() + 1;
                var strDate = date.getDate();
                if (month >= 1 && month <= 9) {
                    month = "0" + month;
                }
                if (strDate >= 0 && strDate <= 9) {
                    strDate = "0" + strDate;
                }
                var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
                        + " " + date.getHours() + seperator2 + date.getMinutes()
                        + seperator2 + date.getSeconds();
                return currentdate;
            }
            
            
            function  addlogon(name,type,pid,page,comment,l_comaddr){
                var nobj = {};
                                nobj.name = name;
                                nobj.time = getNowFormatDate2();
                                nobj.type = type;
                                nobj.comment = comment;
                                nobj.page = page;
                                nobj.pid = pid;
                                nobj.l_comaddr=l_comaddr;
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {
                                            
                                        }
                                    }
                                });
                
            }



