/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * form 表单转json数据
 * @param {type} formObj
 * @returns {unresolved}
 */
function formToJson(formObj) {
    var o = {};
    var a = formObj.serializeArray();
    $.each(a, function() {
        if (this.value) {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || null);
            } else {
                if ($("[name='" + this.name + "']:checkbox", formObj).length) {
                    o[this.name] = [this.value];
                } else {
                    o[this.name] = this.value || null;
                }
            }
        }
    });
    return o;
}
/* url: 没带参数的url
 * param:参数a=2&b=6&u=9   form表单的话 $('fm1').serialize();
 * data: 返回值
 * 默认为post方式
 */
function getURLData(url, param) {
    var aaaa;
    var data = $.ajax({
        url: url,
        data: param,
        type: "post",
        async: false,
        success: function(data) {
            aaaa = data;
        }
    });
    return aaaa;

}

function toUrl(url) {
    window.location = url;
}

/*
 * id  div的id
 * url 后台处理的action
 * fileTypeExts 上传文件后缀名  '*.gif;*.jpg;*.png'
 * 
 */
function upLoadFile(id, url, fileTypeExts, func) {
    $("#" + id).uploadify({
        //指定swf文件
        'swf': 'jquery.uploadify/uploadify.swf',
        //后台处理的页面
        'uploader': url,
        //按钮显示的文字
        'buttonText': '上传',
        //显示的高度和宽度，默认 height 30；width 120
        //'height': 15,
        //'width': 80,
        //上传文件的类型  默认为所有文件    'All Files'  ;  '*.*'
        //在浏览窗口底部的文件类型下拉菜单中显示的文本
        'fileTypeDesc': 'Image Files',
        //允许上传的文件后缀
        'fileTypeExts': fileTypeExts,
        //发送给后台的其他参数通过formData指定
        //'formData': { 'someKey': 'someValue', 'someOtherKey': 1 },
        //上传文件页面中，你想要用来作为文件队列的元素的id, 默认为false  自动生成,  不带#
        //'queueID': 'fileQueue',
        //选择文件后自动上传
        'auto': true,
        //设置为true将允许多文件上传
        'multi': true,
        'onUploadSuccess': func(file, data, response)
    });
}

var code; //在全局定义验证码 
//产生验证码
window.onload = function createCode() {
    code = "";
    var codeLength = 4;//验证码的长度
    var checkCode = document.getElementById("code");
    var random = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
            'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');//随机数
    for (var i = 0; i < codeLength; i++) {//循环操作
        var index = Math.floor(Math.random() * 36);//取得随机数的索引（0~35）
        code += random[index];//根据索引取得随机数加到code上
    }
    checkCode.value = code;//把code值赋给验证码
}
//校验验证码
function validate() {
    var inputCode = document.getElementById("input").value.toUpperCase(); //取得输入的验证码并转化为大写      
    if (inputCode.length <= 0) { //若输入的验证码长度为0
        alert("请输入验证码！"); //则弹出请输入验证码
    }
    else if (inputCode != code) { //若输入的验证码与产生的验证码不一致时
        alert("验证码输入错误！@_@"); //则弹出验证码输入错误
        createCode();//刷新验证码
        document.getElementById("input").value = "";//清空文本框
    }
    else { //输入正确时
        alert("^-^"); //弹出^-^
    }
}