


$.fn.serializeObject = function () {
    var o = {};
    var a = this.serializeArray();
    //    console.log(a);
    $.each(a, function () {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
}
function setCookie(name, value) {
    var Days = 30;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}

function getCookie(name) {
    var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
    if (arr = document.cookie.match(reg))
        return unescape(arr[2]);
    else
        return null;
}
Array.prototype.distinct = function () {
    return this.reduce(function (new_array, old_array_value) {
        var str1 = JSON.stringify(new_array);
        var str2 = JSON.stringify(old_array_value);
        if (str1.indexOf(str2) == -1)
            new_array.push(old_array_value);
        return new_array; //最终返回的是 prev value 也就是recorder
    }, []);
}

String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");

}


function str_repeat(i, m) {
    for (var o = []; m > 0; o[--m] = i)
        ;
    return o.join('');
}
function sprintf() {
    var i = 0, a, f = arguments[i++], o = [], m, p, c, x, s = '';
    while (f) {
        if (m = /^[^\x25]+/.exec(f)) {
            o.push(m[0]);
        } else if (m = /^\x25{2}/.exec(f)) {
            o.push('%');
        } else if (m = /^\x25(?:(\d+)\$)?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(f)) {
            if (((a = arguments[m[1] || i++]) == null) || (a == undefined)) {
                throw ('Too few arguments.');
            }
            if (/[^s]/.test(m[7]) && (typeof (a) != 'number')) {
                throw ('Expecting number but found ' + typeof (a));
            }
            switch (m[7]) {
                case 'b':
                    a = a.toString(2);
                    break;
                case 'c':
                    a = String.fromCharCode(a);
                    break;
                case 'd':
                    a = parseInt(a);
                    break;
                case 'e':
                    a = m[6] ? a.toExponential(m[6]) : a.toExponential();
                    break;
                case 'f':
                    a = m[6] ? parseFloat(a).toFixed(m[6]) : parseFloat(a);
                    break;
                case 'o':
                    a = a.toString(8);
                    break;
                case 's':
                    a = ((a = String(a)) && m[6] ? a.substring(0, m[6]) : a);
                    break;
                case 'u':
                    a = Math.abs(a);
                    break;
                case 'x':
                    a = a.toString(16);
                    break;
                case 'X':
                    a = a.toString(16).toUpperCase();
                    break;
            }
            a = (/[def]/.test(m[7]) && m[2] && a >= 0 ? '+' + a : a);
            c = m[3] ? m[3] == '0' ? '0' : m[3].charAt(1) : ' ';
            x = m[5] - String(a).length - s.length;
            p = m[5] ? str_repeat(c, x) : '';
            o.push(s + (m[4] ? a + p : p + a));
        } else {
            throw ('Huh ?!');
        }
        f = f.substring(m[0].length);
    }
    return o.join('');
}

function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj = JSON.parse(str);
            if (typeof obj == 'object' && obj) {
                return true;
            } else {
                return false;
            }

        } catch (e) {
//            console.log('error：' + str + '!!!' + e);
            return false;
        }
    }
    console.log('It is not a string!')
}

function Str2Bytes(str) {
    var pos = 0;
    var len = str.length;
    if (len % 2 != 0) {
        return null;
    }
    len /= 2;
    var hexA = new Array();
    for (var i = 0; i < len; i++) {
        var s = str.substr(pos, 2);
        var v = parseInt(s);
        hexA.push(v);
        pos += 2;
    }
    return hexA;
}

function Str2BytesH(str) {
    var pos = 0;
    var len = str.length;
    if (len % 2 != 0) {
        return null;
    }
    len /= 2;
    var hexA = new Array();
    for (var i = 0; i < len; i++) {
        var s = str.substr(pos, 2);
        var v = parseInt(s, 16);
        hexA.push(v);
        pos += 2;
    }
    return hexA;
}


function get2byte(num) {

    var ddd = parseInt(num);
    var str = ddd.toString(16);
    var str1 = sprintf("%04s", str);
    return str1;
}


function b2s(param) {
    var retstr;
    var s = param.toString(16);
    if (param < 16) {
        retstr = "0" + s;
    } else {
        retstr = s;
    }

    return retstr;
}


function randnum(n, m) {
    var c = m - n + 1;
    return Math.floor(Math.random() * c + n);

}

function buicode2(paraArr) {
    var ByteToSend = "";
    for (var i = 0; i < paraArr.length; i++) {
        // console.log(hexData[i]);
        ByteToSend = ByteToSend + b2s(paraArr[i]) + " ";
        //console.log(hexData[i].toString(16));
    }
    return  ByteToSend;
}


function delendchar(str) {
    while (str.lastIndexOf('|') == str.length - 1) {
        if (str.lastIndexOf('|') == -1) {
            break;
        }
        str = str.substring(0, str.lastIndexOf('|'));
    }
    return str;
}


function isNumber(val) {

    var regPos = /^\d+(\.\d+)?$/; //非负浮点数
    var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
    if (regPos.test(val) || regNeg.test(val)) {
        return true;
    } else {
        return false;
    }

}

function dealsend2(msg, data, func, comaddr, type, param, val) {
    var user = new Object();
    user.res = 1;
    user.status = "";
    user.comaddr = comaddr;
    user.function = func;
    user.param = param;
    user.page = 2;
    user.msg = msg;
    user.val = val;
    user.type = type;
    user.data = data;
    user.len = data.length;
    console.log(user);
    parent.parent.sendData(user);
}
