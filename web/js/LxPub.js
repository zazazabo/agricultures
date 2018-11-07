/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function loadSelectVal(xid, uri) {
    $.get(uri, null, function(obj) {
        var html = "";
        var xi = $(xid);
        var vl = xi.attr("ovl");
        if (!obj.join) {
            obj = obj.rows;
        }
        $.each(obj, function(i, o) {
            if (vl == o.V_NUM) {
                html += "<option value='" + o.V_NUM + "' selected='selected' ";

            } else {
                html += "<option value='" + o.V_NUM + "' ";
            }
            for (var name   in   o) {
                if (name == 'V_NUM' || name == 'V_NAME') {
                    continue;
                }
                html += name + "='" + o[name] + "' ";
            }
            html += ">" + o.V_NAME + "</option>";

        });
        xi.empty().append(html);
    }, "json");
}
