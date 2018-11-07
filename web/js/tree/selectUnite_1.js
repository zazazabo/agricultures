/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
   
   //定义两个全局变量，为了防止其它地方有相同的，将变量的名称弄得特殊一些
   //当前使用对象的id和名称
    var currentUseObject_id;
    var currentUseObject_name;
    
    //bObj(by object)被选date的dateGrid，sObj(select object)已选data的dataGrid
    //加载数据
    function loadByObjData(bObj,bUrl){
        bObj.datagrid({   
            url:bUrl
        });            
    }


    //双击选择被选中项
    function onDblSelectRow(bObj,sObj){
        bObj.datagrid({   
            onDblClickRow:function(ri,rd){
                //双击人员树的时候先判断人员是否已存在选择树中
                //得到选择树中的所有数据
                var rw=sObj.datagrid('getData').rows;
                //如果还不存在数据就直接插入
                var flag=true;
                $.each(rw,function(si,sn){
                    if(sn.ID==rd.ID){
                        flag=false;
                    }
                });
                if(flag){
                    sObj.datagrid('appendRow',{
                        ID:rd.ID,
                        NAME:rd.NAME
                    });
                }
            }
        });      
    }

    //双击删除选中的项
    function onDblDeleteRow(sObj){
        sObj.datagrid({   
            onDblClickRow:function(ri,rd){
                sObj.datagrid('deleteRow',ri);  
            }
        }); 
    }

    //全选选中项
    function allSelectRow(bObj,sObj){
        var rows=bObj.datagrid('getSelections');
        $.each(rows,function(pi,pn){
             //双击人员树的时候先判断人员是否已存在选择树中
                //得到选择树中的所有数据
                var rw=sObj.datagrid('getData').rows;
                //如果还不存在数据就直接插入
                var flag=true;
                $.each(rw,function(si,sn){
                    if(sn.ID==pn.ID){
                        flag=false;
                    }
                });
                if(flag){
                    sObj.datagrid('appendRow',{
                        ID:pn.ID,
                        NAME:pn.NAME
                    });
                }
        });
    }


    //全删选中项
    function allDeleteRow(sObj){
        var rows=sObj.datagrid('getSelections');
        $.each(rows,function(si,sn){
              var index=sObj.datagrid('getRowIndex',sn);
              sObj.datagrid('deleteRow',index);
        });
    }


    //返回选中的数据,wObj 窗口对象，idObj(接受返回的id值的对象),nameObj(接受返回的name值的对象)
    function getDataGridSelected(wObj,sObj,idObj,nameObj){  
        //得到选择树中的所有数据
        var rw=sObj.datagrid('getData').rows;
        var ids='',names='';
        $.each(rw,function(index,none){
            if(ids !='')
                ids+=',';
            ids+=none.ID;

            if(names !='')
                names+=',';
            names+=none.NAME;
        });  
        idObj.val(ids);
        nameObj.val(names);
        wObj.window('close');
    }  
    
    
    
    //返回选中的数据,wObj 窗口对象，tObj 树对象，idObj(接受返回的id值的对象),nameObj(接受返回的name值的对象)
    function getTreeSelected(wObj,tObj,idObj,nameObj){  
        //得到选择树中的所有数据
        var nodes = tObj.tree('getChecked');  
        var id='';
        var s = '';  
        $.each(nodes,function(i,d){
            if(id !='')
                id+=',';
            id+=d.id;

            if(s !='')
                s+=',';
            s+=d.text;
        });
       
        idObj.val(id);
        nameObj.val(s);
        wObj.window('close');
    }


