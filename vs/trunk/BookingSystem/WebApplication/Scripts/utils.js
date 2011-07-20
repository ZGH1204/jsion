///<reference path="/Scripts/vswd-ext_2.0.2.js" />
function GetResJsion(response)
{
    if(response.result.success)
        return response.result.data;
    else
        return response.result.errors;
}

//method(string),fields(Array)
//创建数据集,用于绑定
function CreateStore(method,fields,baseParams)
{
    return new Ext.data.JsonStore({
        url: ADMIN_AJAX_PATH + '?Method='+method,
        root: 'data',
        successProperty: 'success',
        baseParams: baseParams,
        fields: fields
    });
}
function CreatePagingStore(method, fields, baseParams) {
    return new Ext.data.JsonStore({
        url: ADMIN_AJAX_PATH + '?Method=' + method,
        root: 'data',
        totalProperty: 'totalCount',
        successProperty: 'success',
        baseParams: baseParams,
        fields: fields
    });
}

function CreateGroupingSotre(method, fields, baseParams, sortField, groupField) {
    var r = Ext.data.Record.create(fields);
    var reader = new Ext.data.JsonReader({
        root: 'data'
    }, r);
    return new Ext.data.GroupingStore({
        url: ADMIN_AJAX_PATH + '?Method=' + method,
        successProperty: 'success',
        root: 'data',
        baseParams: baseParams,
        //fields: fields,
        reader: reader,
        sortInfo: { field: sortField, direction: "DESC" },
        groupField: groupField
    });
}

//id(string),title(string),cols(Array),ctrlBar(Array),store(Ext.data.JsonStore)
//创建网格视图
function CreateGrid(id,title,cols,store,tbars,bbars,fbars,renderLoad, loadParams)
{
    var sm = new Ext.grid.RowSelectionModel();//Ext.grid.CheckboxSelectionModel
    var grid = new Ext.grid.GridPanel({
        id: id,
        view: new Ext.grid.GridView({
            forceFit: true
        }),
        clicksToEdit: 2,
        stripeRows: true,
        loadMask: true,
        store: store,
        columns: cols,
        sm: sm,
        tbar: tbars,
        bbar: bbars,
        fbar: fbars,
        tripeRows: true,
        title: title,
        layout: 'fit',
        enableDragDrop: true,
        columnLines: true
    });
    if (renderLoad == null || renderLoad == undefined || renderLoad) {
        grid.on('render', function () {
            store.load({
                params: loadParams,
                callback: function (r, options, success) {
                    if (!success) {
                        ShowMsg(false, '请求数据失败,可能登陆已超时!');
                    }
                }
            });
        });
    }
    
    return grid;
}
function CreateGroupingGrid(id, title, cols, store, tbars, bbars, fbars, groupTxtTpl, startCollapsed) {
    if (groupTxtTpl) { } else { groupTxtTpl = '{text} &nbsp;&nbsp; \[{[values.rs.length]} 项\]'; }
    var sm = new Ext.grid.RowSelectionModel();//Ext.grid.CheckboxSelectionModel
    var grid = new Ext.grid.GridPanel({
        id: id,
        view: new Ext.grid.GroupingView({
            showGroupName: false,
            forceFit: true,
            groupByText: '按此列分组',
            showGroupsText: '分组显示',
            startCollapsed: startCollapsed,
            groupTextTpl: groupTxtTpl
        }),
        stripeRows: true,
        loadMask: true,
        store: store,
        columns: cols,
        sm: sm,
        tbar: tbars,
        bbar: bbars,
        fbar: fbars,
        tripeRows: true,
        title: title,
        layout: 'fit',
        enableDragDrop: true,
        columnLines: true,
        autoWidth: true
    });

    grid.on('render', function () {
        store.load({
            params: '',
            callback: function (r, options, success) {
                if (!success) {
                    ShowMsg(false, '请求数据失败,可能登陆已超时!');
                }
            }
        });
    });
    
    return grid;
}

//创建Form表单的一个输入项,包含label
function CreateFormItem(label, id, emptytext, allowblank, blanktext, maxlen, minlen, maxlentxt, minlentxt, val)
{
    var obj = {
        fieldLabel: label,
        id: id,
        name: id,
        anchor: '100%',
        selectOnFocus: true
    };

    if (emptytext) {
        obj.emptyText = emptytext;
    }

    if (allowblank != null && allowblank != undefined) {
        obj.allowBlank = allowblank;
    }

    if (blanktext) {
        obj.blankText = blanktext;
    }

    if (maxlen != null && maxlen != undefined) {
        obj.maxLength = maxlen;
    }

    if (minlen != null && minlen != undefined) {
        obj.minLength = minlen;
    }

    if (maxlentxt) {
        obj.maxLengthText = maxlentxt;
    }

    if (minlentxt) {
        obj.minLengthText = minlentxt;
    }

    if (val) {
        obj.value = val;
    }

    return obj;
}
//创建数据集和网格的每列的配置对象
function CreateStoreAndGridItem(name, type, id, header, width, align, sortable, hidden, editor)
{
    return {
        name: name,
        type: type,
        id: id,
        header: header,
        width: width,
        dataIndex: name,
        align: align,
        sortable: sortable,
        hidden: hidden,
        editor: editor
    };
}

function CreateStoreAndGrid(gridid, gridtitle, getDataSrvMethod, getDataConfigArray, tbars, bbars, fbars, baseParams)
{
    var store = CreateStore(getDataSrvMethod, getDataConfigArray, baseParams);

    var grid = CreateGrid(gridid, gridtitle, getDataConfigArray, store, tbars, bbars, fbars);
    return grid;
}

function CreatePagingStoreAndGrid(gridid, gridtitle, getDataSrvMethod, getDataConfigArray, tbars, bbars, fbars, baseParams) {
    var store = CreatePagingStore(getDataSrvMethod, getDataConfigArray, baseParams);
    var pagesize = 30;
    if (tbars) { } else { tbars = []; }
    //服务端以start和limit接收查询记录,start为起始索引,limit为pagesize
    tbars.push(new Ext.PagingToolbar({
        pageSize: pagesize,
        store: store,
        displayInfo: true,
        displayMsg: 'Displaying {0} - {1} of {2}',
        emptyMsg: "No topics to display"

    }));

    var grid = CreateGrid(gridid, gridtitle, getDataConfigArray, store, tbars, bbars, fbars, true, { start: 0, limit: pagesize });
    return grid;
}

function CreateGroupingStoreAndGrid(gridid, gridtitle, getDataSrvMethod, getDataConfigArray, tbar, baseParams, sortField, groupField, groupTxtTpl, bbars, fbars, startCollapsed) {
    var store = CreateGroupingSotre(getDataSrvMethod, getDataConfigArray, baseParams, sortField, groupField);
    var grid = CreateGroupingGrid(gridid, gridtitle, getDataConfigArray, store, tbar, bbars, fbars, groupTxtTpl, startCollapsed);
    return grid;
}

function CreateComboBox(getDataMethod, fields, id, bindFields, selectedFunc, label, allowblank) {
    var ds = new Ext.data.JsonStore({
        url: ADMIN_AJAX_PATH + '?Method=' + getDataMethod,
        root: 'data',
        totalProperty: 'totalCount',
        fields: fields,
        autoLoad: false
    });

    var obj = {
        id: id,
        store: ds,
        displayField: bindFields[0],
        valueField: bindFields[1],
        editable: false,
        width: 110,
        typeAhead: true,
        triggerAction: 'all',
        emptyText: 'Please select...',
        selectOnFocus: true
    }

    if (label != null && label != undefined) {
        obj.fieldLabel = label;
    }

    if (allowblank != null && allowblank != undefined) {
        obj.allowBlank = allowblank;
    }

    var combo = new Ext.form.ComboBox(obj);

    combo.on('select', selectedFunc);

    return combo;
}

function RefreshGrid(gridid) {
    var grid = Ext.getCmp(gridid);
    if (grid) { grid.getStore().reload(); }
}

function ShowMsg(success, msg, confirm, confirmCallback) {
    if (confirm) {
        Ext.Msg.confirm(TIP_TITLE, msg, confirmCallback);
    } else {
        if (success) {
            Ext.Msg.show({
                buttons: Ext.Msg.OK,
                title: TIP_TITLE,
                msg: msg,
                icon: Ext.MessageBox.INFO,
                width: 250,
                minWidth: 250,
                maxWidth: 350,
                multiline: false,
                closable: false
            });
        } else {
            Ext.Msg.show({
                buttons: Ext.Msg.OK,
                title: TIP_TITLE,
                msg: msg,
                icon: Ext.MessageBox.ERROR,
                width: 250,
                minWidth: 250,
                maxWidth: 350,
                multiline: false,
                closable: false
            });
        }
    }
}

function FocusFormItem(formpanel, itemId) {
    formpanel.on("render", function () {
        var it = Ext.getCmp(itemId);
        if (it) { it.focus(false, 500); it.focus(false, 600); }
    });
}

function SubmitForm(formpanelId, winId, confirm, confirmCallback, successFn, failureFn) {
    if (formpanelId) {
        var frm = Ext.getCmp(formpanelId);
        var f = frm.getForm();
        if (!f.isValid()) {
            return;
        }
        f.submit({
            waitMsg: LOGINBTN_WAIT_MSG,
            url: ADMIN_AJAX_PATH,
            waitTitle: TIP_TITLE,
            method: 'POST',
            success: function (sender, response) {
                if (successFn) { successFn(sender, response); }
                ShowSubmitResult(sender, response, confirm, confirmCallback);
                if (winId) {
                    var win = Ext.getCmp(winId);
                    if (win) { win.close(); }
                }
            },
            failure: function (sender, response) {
                if (failureFn) { failureFn(sender, response); }
                ShowSubmitResult(sender, response);
            }
        });
    }
}

function ShowSubmitResult(sender, response, confirm, confirmCallback) {
    var data = GetResJsion(response);
    ShowMsg(response.result.success, data.msg, confirm, confirmCallback);
}

function RefreshGridView(gridId) {
    var grid = Ext.getCmp(gridId);
    if (grid) grid.getView().refresh();
}

function GetGridStore(gridId) {
    var grid = Ext.getCmp(gridId);
    return grid.getStore();
}

function GetGridSelected(gridId) {
    var grid = Ext.getCmp(gridId);
    return grid.getSelectionModel().getSelected();
}

function GetGridSelectedData(gridId) {
    var grid = Ext.getCmp(gridId);
    if (grid.getSelectionModel().getSelected()) {
        return grid.getSelectionModel().getSelected().data;
    }
    return null;
}

function RemoveGridSelectedRow(gridId) {
    var g = Ext.getCmp(gridId);
    var store = GetGridStore(gridId);
    store.remove(g.getSelectionModel().getSelected());
}

function CreateFormPanel(id, method, items, buttons) {
    items.push(GetAjaxHidden(method));
    var formpanel = new Ext.FormPanel({
        id: id,
        formId: id + '-form',
        url: ADMIN_AJAX_PATH,
        frame: true,
        border: false,
        bodyStyle: 'padding:5px 5px 0',
        labelWidth: 55,
        region: 'center',
        baseCls: 'x-window',
        width: 300,
        defaults: { width: 230 },
        defaultType: 'textfield',
        items: items,
        buttons: buttons
    });

    return formpanel
}

function CreateWin(childs, id, title, w, h, closable, modal) {
    var win = new Ext.Window({
        id: id,
        title: title,
        modal: modal,
        width: w + 10,
        height: h + 10,
        closable: closable,
        layout: 'border',
        plain: true,
        items: childs
    });
    win.show();
}

function UpdateButtonState(btn, sm, sender, record, index) {
    if (btn && sm) {
        if (sm.getSelected()) {
            btn.setDisabled(false);
        } else {
            btn.setDisabled(true);
        }
    }

    if (btn && sender) {
        if (sender.selectedIndex != -1) {
            btn.setDisabled(false);
        } else {
            btn.setDisabled(true);
        }
    }
}

function ExtAjaxRequest(method, params, successFn, failedFn) {
    Ext.Ajax.request({
        url: ADMIN_AJAX_PATH + "?Method=" + method,
        params: params,
        callback: function (options, success, response) {
            var result = Decode(response["responseText"]);

            if (result.success) {
                ShowMsg(result.success, result.data.msg);
                if (successFn) { successFn(result); }
            } else {
                ShowMsg(result.success, result.errors.msg);
                if (failedFn) { failedFn(result); }
            }
        }
    });
}

function ExtAjaxData(method, params, successFunc) {
    Ext.Ajax.request({
        url: ADMIN_AJAX_PATH + "?Method=" + method,
        params: params,
        callback: function (options, success, response) {
            var result = Decode(response["responseText"]);

            if (result.success) {
                //ShowMsg(result.success, result.data.msg);
                if (successFunc) { successFunc(result); }
            }
        }
    });
}

function GetAjaxHidden(val) {
    return {
        id: 'Method',
        name: 'Method',
        xtype: 'hidden',
        value: val,
        readOnly: true
    };
}

function Decode(json) { return eval("(" + json + ")") }

function ShowObjectProp(obj) {
    var str = "";
    for (var key in obj) {
        str = str + "key: " + key + "  content: " + obj[key] + "\r\n\r\n";
    }
    alert(str);
}