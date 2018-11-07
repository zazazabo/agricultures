<%-- 
    Document   : newjsp
    Created on : 2014-7-24, 14:06:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="../../jspf/newjsf.jspf" %>
        <script>
                
            
            $(document).ready(function() {
                $('#tree1').tree({   
                    url:'test1.f4.tree.action'  
                }); 
                var pager = $('#dg').datagrid('getPager');
                pager.pagination({buttons: [{
                            iconCls: 'icon-save',
                            handler: function() {
                                var gr = $('#toolbar').find("input,select").serializeArray();
                                var url = "mdbtbb1.json?m=lists";
                                url += "&__SPL_PARA__=" + encodeURIComponent($.param(gr));
                                url += "&__dsm__=XLST";
                                window.open(url);
                            }
                        }]});
            });
            function joinobj(o, n) {
                for (var p in n)
                    if (n.hasOwnProperty(p) && !o.hasOwnProperty(p))
                        o[p] = n[p];
                return o;
            }
            function SELECTQD() {
//                  $.messager.alert("warnning","you are right");      
                var obj = formToJson($('#fm1'));

                $("#dg").datagrid("reload", obj);
            }
            function aaa() {
                var dd = encodeURIComponent("SNAME=去");
                window.location.href = "test1.f4.h2.action?" + dd;
            }
            function bbb() {
                var url = "test1.f4.h2.action";
                var param = $('#fm1').serialize();
                var data = getURLData(url, param);
                alert(data);
            }
            function tipjson1() {
                $.ajax({
                    url: "test1.f4.h3.action",
                    data: $("#fm1").serialize(),
                    success: function(data) {
//                    $.each(data,function(i,val){
//                        for(var r in val){
//                            alert(val[r]);
//                        }
//                    });
                        $("#abc").text(data);
                    }
                });
            }
        </script>
    </head>
    <body>
 <div id="cc" class="easyui-layout" style="  width:600px;height:300px;">  
   <div data-options="region:'north'" style="height:100px;"></div>  
    <div data-options="region:'south'" style="margin-top: 3px;  height:100px;"></div>  
 <!--    <div data-options="region:'east'" style=" margin-top: 1px; width:100px;"></div>  
    <div data-options="region:'west'" style=" margin-top: 1px; width:100px;"></div>  
    <div data-options="region:'center'" style="margin-top: 1px; padding:2px;"></div>  -->
</div>  
       
        
        
        
        <div class=" easyui-layout" style="margin-top: 3px; width:100%;height:400px;">
            <div data-options="region:'north'" style="  height: 200px;">

                <div id="toolbar">
                    <form id="fm1">
                        <table>
                            <tr>
                                <td>姓名列表项:</td>
                                <td>
<input id="cc" class="easyui-combobox" name="SNAME"  
    data-options="valueField:'ID',textField:'TEXT',url:'test1.f4.nameList.action'" />  
  
<!--                                </td>
                                <td align="right">姓名:</td>
                                <td>
                                    <input type="text"  name="SNAME" style="width:70px;"/>
                                </td>-->
                                <td align="right">学号:</td>
                                <td>
                                    <input type="text" name="SAGE" style="width:70px;"/>
                                </td>
                                <td align="right">开学时间:</td>
                                <td>
                                    <input class="easyui-datebox" name="SBEGIN1" </input>
                                </td>    
                                <td>
                                                 TO
                                </td>                           
                                <td>
                                    <input class="easyui-datebox" name="SBEGIN2"></input>
                                </td>
                                <td><a href="#" class="easyui-linkbutton" onclick="SELECTQD()" iconCls="icon-search">查询</a></td>
                                <!--                                <td><a href="#" class="easyui-linkbutton" onclick="aaa()" iconCls="icon-search">查询</a></td>-->
                            </tr>
                        </table>
                    </form>
                </div> 
                <table id="dg"  class="easyui-datagrid" style="width: 1200%;height: 400px;" data-options="" title="门店补贴报表1" iconCls="icon-lc" toolbar="#toolbar" rownumbers="true" pagination="true"
                       url="test1.f4.h3.action" singleSelect="true">
                    <thead>
                        <tr>
                            <th width="50" colspan="1" rowspan="1"	align="left" field="SNAME">姓名</th>
                            <th width="50" colspan="1" rowspan="1"	align="left" field="SAGE">学号</th>
                            <th width="100" colspan="1" rowspan="1"	align="left" field="BEGINTIME">开学时间</th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div data-options="region:'west'" style="margin-top: 1px; width: 200px; height: 50px">
                sssssssssssssssssssss
                <ul id="tree1" class="easyui-tree"></ul>  
            </div>
<!--           <div data-options="region:'South'" style="margin-top: 2px; width: 300px;height: 100px;">
               bbb
            </div> -->
        </div>

<!--        <form id="fm1" action="test1.f4.h2.action">
            <input type="text" name="SNAME"/>
            <input type="button"  onclick="bbb();" value="ajax表单提交"/>
            <input type="button"  onclick="tipjson1();" value="请求json对象"/>
            <input type="button"  onclick="tipjson2();" value="请求json字符串"/>
            aaaaaaaa
        </form>
        <div id="abc">a b c</div>-->
    </body>
</html>
