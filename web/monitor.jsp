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
                            title: '名称', //回路名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'numvalue',
                            title: '数值', //装置序号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'unit1',
                            title: '单位', //组号
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
                            field: 'l_switch',
                            title: '状态', //合闸参数
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 170) {
                                    return langs1[340][lang];  //断开
                                } else if (value == 85) {
                                    return langs1[339][lang];  //闭合
                                }

//                                var groupe = value.toString();
//                                return  groupe;
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
                    },
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
            })


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
