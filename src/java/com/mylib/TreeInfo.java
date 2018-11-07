/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mylib;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Administrator
 */
public class TreeInfo {

    public String id;
    public String pid;
    public String checked;

    public String getLevl() {
        return leve;
    }

    public static List<TreeInfo> formatTree(List list) {
        List<TreeInfo> treeInfos1 = new ArrayList<TreeInfo>();
        HashMap<String, TreeInfo> treeMap = new HashMap<String, TreeInfo>();
        for (int i = 0; i < list.size(); i++) {
            TreeInfo a1 = mapToBean((Map) list.get(i));
            treeMap.put(a1.getId(), a1);
        }

        for (int i = 0; i < list.size(); i++) {
            TreeInfo a2 = mapToBean((Map) list.get(i));
            String pidString = a2.getPid().toString();
            if ((a2.getPid() != null) && treeMap.containsKey(pidString)) {
                TreeInfo tt = treeMap.get(a2.getId());
                treeMap.get(pidString).children.add(tt);
            } else {
                treeInfos1.add(treeMap.get(a2.getId()));
            }
        }

        return treeInfos1;
    }

    private static TreeInfo mapToBean(Map m1) {
        TreeInfo ti1 = new TreeInfo();
        if (m1.containsKey("id")) {
            if (m1.get("id") != null) {
                ti1.setId((String) m1.get("id"));
            }
        }
        if (m1.containsKey("pid")) {
            if (m1.get("pid") != null) {
                ti1.setPid((String) m1.get("pid"));
            }
        }

        if (m1.containsKey("url")) {
            if (m1.get("url") != null) {
                ti1.setUrl((String) m1.get("url"));
            }
        }

        if (m1.containsKey("iconCls")) {
            if (m1.get("iconCls") != null) {
                ti1.setIconCls((String) m1.get("iconCls"));
            }
        }

        if (m1.containsKey("state")) {
            if (m1.get("state") != null) {
                ti1.setState((String) m1.get("state"));
            }
        }

        if (m1.containsKey("checked")) {
            if (m1.get("checked") != null) {
                ti1.setChecked((String) m1.get("checked"));
            }
        }
        if (m1.containsKey("leve")) {
            if (m1.get("leve") != null) {
                ti1.setLevl((String) m1.get("leve"));
            }
        }

        if (m1.containsKey("text")) {
            if (m1.get("text") != null) {
                ti1.setText((String) m1.get("text"));
            }
        }
        return ti1;
    }

    public void setLevl(String leve) {
        this.leve = leve;
    }
    public String leve;
    public String state;
    public List<TreeInfo> children = new ArrayList<TreeInfo>();

    public String getChecked() {
        return checked;
    }

    public void setChecked(String checked) {
        this.checked = checked;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public List<TreeInfo> getChildren() {
        return children;
    }

    public void setChildren(List<TreeInfo> children) {
        this.children = children;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getIconCls() {
        return iconCls;
    }

    public void setIconCls(String iconCls) {
        this.iconCls = iconCls;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
    public String text;
    public String iconCls;
    public String url;
}
