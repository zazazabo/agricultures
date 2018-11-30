<%-- 
    Document   : deplayment
    Created on : 2018-7-4, 15:32:48
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
            .btn { margin-left: 10px;}
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
        <script>

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {
                $('#gravidaTable').bootstrapTable({
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
                    //url: "loop.loopForm.getLoopList.action",
                    columns: [
                        {
                            //field: 'Number',//可不加  
                            title: '序号', //标题  可不加  
                            align: "center",
                            width: "132px",
                            visible: false,
                            formatter: function (value, row, index) {
                                row.index = index;
                                return index + 1;
                            }
                        },
                        {
                            field: 'name',
                            title: '名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'numvalue',
                            title: '数值',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.type == 3) {
                                    if (value == 0) {
                                        return "关";
                                    } else {
                                        return "开";
                                    }
                                } else {
                                    return value / 10;
                                }
                            }
                        }, {
                            field: 'unit1',
                            title: '单位',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.type == null) {
                                    return value;
                                }

                                if (row.type == "1") {
                                    return  "℃";
                                } else if (row.type == "2") {
                                    return  "%RH";
                                } else if (row.type == 3) {
                                    return  "开/关";
                                }
//                                var groupe = value.toString();
//                                return  groupe;
                            }
                        }, {
                            field: 'onlinetime',
                            title: '状态',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                var time1 = value.substring(0, 16);
                                var time2 = row.dtime.substring(0, 16);
                                console.log("1:"+time1+"//2:"+time2)
                                var stime = TimeDifference(time1, time2);
                                return  stime;
                            }
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    search: true,
                    locale: 'zh-CN', //中文支持,
                    sortOrder: 'desc',
                    pagination: true,
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
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    }
                });

                $('#gayway').on('check.bs.table', function (row, element) {
                    var l_comaddr = element.comaddr;
                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    console.log(obj);
                    var opt = {
                        url: "monitor.monitorForm.getSensorList.action",
                        silent: true,
                        query: obj
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);

                });
            });
            //定时刷新数据
            setInterval('getcominfo()', 6000);
            function  getcominfo() {
                var selects = $('#gayway').bootstrapTable('getSelections');
                var l_comaddr = selects[0].comaddr;
                var obj = {};
                obj.l_comaddr = l_comaddr;
                obj.pid = "${param.pid}";
                var opt = {
                    url: "monitor.monitorForm.getSensorList.action",
                    silent: true,
                    query: obj
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);
            }

            //计算时间差
            function TimeDifference(time1, time2)
            {

                time1 = new Date(time1.replace(/-/g, '/'));
                time2 = new Date(time2.replace(/-/g, '/'));
                var ms = Math.abs(time1.getTime() - time2.getTime());
                return ms / 1000 / 60 ;
                
            }


            function formartcomaddr(value, row, index) {
                if (index == 0) {
                    var l_comaddr = row.comaddr;
                    var l_comaddr = row.comaddr;
                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    obj.pid = "${param.pid}";
                    var opt = {
                        url: "monitor.monitorForm.getSensorList.action",
                        silent: true,
                        query: obj
                    };
                    $("#gravidaTable").bootstrapTable('refresh', opt);

                    return {disabled: false, //设置是否可用
                        checked: true//设置选中
                    };

                } else {
                    return {checked: false//设置选中
                    };

                }
            }
        </script>
    </head>
    <body id="panemask">
        <div class="row "   >
            <div class="col-xs-2 " >
                <table id="gayway" style="width:100%;"    data-toggle="table" 
                       data-height="800"
                       data-single-select="true"
                       data-striped="true"
                       data-click-to-select="true"
                       data-search="true"
                       data-checkbox-header="true"
                       data-url="gayway.GaywayForm.getComaddrList.action?pid=${param.pid}&page=ALL" style="width:200px;" >
                    <thead >
                        <tr >
                            <th data-width="25"    data-select="false" data-align="center" data-formatter='formartcomaddr'  data-checkbox="true"  ></th>
                            <th data-width="100" data-field="comaddr" data-align="center"    >网关地址</th>
                            <!--<th data-width="100" data-field="name" data-align="center"    >网关名称</th>-->
                        </tr>
                    </thead>       

                </table>
            </div>   
            <div class="col-xs-10">

                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>
            </div>
        </div>



    </body>
</html>
