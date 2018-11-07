<%-- 
    Document   : newjsp1
    Created on : 2018-8-6, 18:19:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <script type="text/javascript" src="js/genel.js"></script>

        <!--        <script type="text/javascript" src="jquery-easyui-1.5.5.4/jquery.easyui.min.js"></script>-->

        <!--        <link type="text/css" href="jquery-ui-bootstrap/css/custom-theme/jquery-ui-1.10.0.custom.css" rel="stylesheet" />
                <script src="jquery-ui-bootstrap/assets/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
                
               <link rel="stylesheet" type="text/css" href="jquery-easyui-1.5.5.4/themes/default/easyui.css"/>
                <link rel="stylesheet" type="text/css" href="jquery-easyui-1.5.5.4/themes/icon.css"/>
                <script type="text/javascript" src="jquery-easyui-1.5.5.4/jquery.easyui.min.js"></script>
                
        -->


        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script>

            function hit() {
                $("#dialog").dialog();
            }

            $(function () {
//                 var o={};
//                 var v= [{id:1,zh_ch:"aaa"}]
//                 
//                  o[v[i].id]={zh_ch:"计划能耗",en_us:"计划能耗1"};
//                  
//                 var ooo={};
//                 ooo[v[0].id]=v[0];
//                 o[1]={zh_ch:"计划能耗",en_us:"计划能耗1"};
//                 
//                 console.log(o);
//                 var a=1;
//                 var b="en_us";
//                 o[a][b]
//                 console.log(o[a][b]);
//                 
//                 
//                var arr=[{id:11,text:11},{id:11,text:11}];
//                console.log(arr.distinct());
//                alert(['a','b','c','d','b','a','e'].distinct());






                // Dialog Link
                $('#dialog_link').click(function () {
                    $('#dialog_simple').dialog('open');
                    return false;
                });

                // Modal Link
                $('#modal_link').click(function () {
                    $('#dialog-message').dialog('open');
                    return false;
                });

//
                $('#dialog_simple').dialog({
                    autoOpen: false,
                    width: 600,
                    buttons: {
                        "Ok": function () {
                            $(this).dialog("close")
                        },
                        "Cancel": function () {
                            $(this).dialog("close");
                        }
                    }
                });
//
//                //####### Dialogs
                $("#dialog-message").dialog({
                    autoOpen: false,
                    modal: true,
                    buttons: {
                        Ok: function () {
                            $(this).dialog("close");
                        }
                    }
                });



            });


        </script>


    </head>
    <body>
        <h1>Hello World!</h1>
        <%int a = 80;
    out.println(a);%>

        <h1>

        </h1>

        <script>
            var o = {};
            o[1] = {zh_ch: "计划能耗", en_us: "计划能耗1"};
            console.log(o);
            var a = 1;
            var b = "en_us";
            document.write(o[a][b]);

        </script>


        //显示遮罩
        $(".add_test_img").showLoading();  
   











        <input type="button" value="hit" onclick="hit()"/>
        <div class="container">
            <input class="easyui-combobox" name="language[]" style="width:100%;" data-options="
                   url: 'test1.gayway.comaddr.action',
                   method:'get',
                   valueField:'id',
                   textField:'text',
                   ">





            <select name="number" id="number">
                <option>1</option>
                <option selected="selected">2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
                <option>6</option>
                <option>7</option>
                <option>8</option>
                <option>9</option>
                <option>10</option>
                <option>11</option>
                <option>12</option>
                <option>13</option>
                <option>14</option>
                <option>15</option>
                <option>16</option>
                <option>17</option>
                <option>18</option>
                <option>19</option>
            </select>














            <!-- Dialog -->

            <p class="dialog-button">
                <a href="#" id="dialog_link" class="ui-state-default ui-corner-all">
                    <span class="ui-icon ui-icon-newwin"></span>Open Dialog
                </a>
                &nbsp;
                <a href="#" id="modal_link" class="ui-state-default ui-corner-all">
                    <span class="ui-icon ui-icon-newwin"></span> Open Modal Dialog
                </a>
            </p>


            <div id="dialog_simple" title="Dialog Simple Title">
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
            </div>

            <div id="dialog-message" title="Modal Dialog">
                <p>
                    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span> 
                    Your files have downloaded successfully into the My Downloads folder.
                </p>

            </div>


        </div>



        <div id="dialog" title="基本的对话框">
            <p>这是一个默认的对话框，用于显示信息。对话框窗口可以移动，调整尺寸，默认可通过 'x' 图标关闭。</p>
        </div>
        <script>
            //                // Dialog Simple


        </script>


    </body>
</html>
