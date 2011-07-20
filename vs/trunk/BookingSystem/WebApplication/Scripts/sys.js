///<reference path="/Scripts/vswd-ext_2.0.2.js" />

var leftItemTemplate = new Ext.Template("<p class='leftmenuitem'><a href='javascript:void(0);' onclick=\"ShowTabItem('{tabId}','{title}',{getGridFunc},{beforeCloseFunc})\">{title}</a></p>");


// 显示到中间区域
function ShowTabItem(id, title, getFunc, beforeClose) {
    var tmp = Ext.getCmp(id);
    if (!tmp) {
        tabs.add([{
            id: id,
            layout: 'fit',
            title: title,
            tabTip: title,
            closable: true,
            autoScroll: true,
            items: [getFunc()]
        }]);
    }
    var bcf = beforeClose;
    setTimeout(function () {
        tabs.activate(id);
        var t = Ext.getCmp(id);
        if (bcf)
            t.on('beforeclose', bcf);
    }, 1);
}

// 全局设置
function setAllGlobalItems(panelContaint) {
    ////////////////////////////////////////////////////////////////////////////  用户列表  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-users',
        title: '用户列表',
        getGridFunc: 'CreateUserGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  店铺列表  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-shops',
        title: '店铺列表',
        getGridFunc: 'CreateShopGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  预订设置  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-bookingsetting',
        title: '预订设置',
        getGridFunc: 'CreateBookingGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  结束预订  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-bookingover',
        title: '结束预订',
        getGridFunc: 'CreateBookingOverGrid',
        beforeCloseFunc: function () { }
    });
}

function setUserNavigationItems(panelContaint) {
    ////////////////////////////////////////////////////////////////////////////  充值记录  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-balnces',
        title: '充值记录',
        getGridFunc: 'CreateBalanceGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  预订记录  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-bookingrecord',
        title: '预订记录',
        getGridFunc: 'CreateBookingRecordGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  扣款记录  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-deduction',
        title: '扣款记录',
        getGridFunc: 'CreateDeductionRecordGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  预订查询  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-bookingquery',
        title: '预订查询',
        getGridFunc: 'CreateBookingQueryGrid',
        beforeCloseFunc: function () { }
    });
    ////////////////////////////////////////////////////////////////////////////  在线预订  ////////////////////////////////////////////////////////////////////////////
    leftItemTemplate.append(panelContaint.body, {
        tabId: 'tab-bookingonline',
        title: '在线预订',
        getGridFunc: 'CreateOnlineBookingGrid',
        beforeCloseFunc: function () { }
    });
}

function CreateDeductionRecordGrid() {
    var columnArray = [
        CreateStoreAndGridItem('Id', 'int', 'Id', '记录ID', 80, 'center', true),
        CreateStoreAndGridItem('Uid', 'int', 'Uid', '预订人ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopid', 'int', 'Shopid', '店铺ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Realname', 'string', 'Realname', '预订人', 130, 'left', true, true),
        CreateStoreAndGridItem('Deductionname', 'string', 'Bookingname', '扣款项目', 150, 'left', true),
        CreateStoreAndGridItem('Deductionvalue', 'float', 'Deductionvalue', '扣款金额', 100, 'left', true),
        CreateStoreAndGridItem('Deductioncount', 'float', 'Deductioncount', '数量', 80, 'left', true),
        CreateStoreAndGridItem('Deductionbalance', 'float', 'Deductionbalance', '余额', 80, 'left', true),
        CreateStoreAndGridItem('Shopname', 'string', 'Shopname', '店铺名称', 130, 'left', true),
        CreateStoreAndGridItem('Remarks', 'string', 'Remarks', '备注', 130, 'left', true)
    ];

    var btns = [];

    btns.push();

    var grid = CreatePagingStoreAndGrid('grid-deductionrecordlist', null, 'GetDeductionRecordList', columnArray, btns);
    return grid;
}

function CreateBookingRecordGrid() {
    var columnArray = GetBookingedListGridItem(false, false, true, false, false);

    var btns = [];

    var grid = CreatePagingStoreAndGrid('grid-bookingrecordlist', null, 'GetBookingRecordList', columnArray, btns);
    return grid;
}

function GetBookingshopGridItem(hideIsover) {
    var isoverColumn = CreateStoreAndGridItem('Isover', 'bool', 'Isover', '预订状态', 80, 'center', true, hideIsover);
    isoverColumn.xtype = 'booleancolumn';
    isoverColumn.trueText = '已结束';
    isoverColumn.falseText = '预订中';
    var columnArray = [
        CreateStoreAndGridItem('Id', 'int', 'Id', '记录ID', 80, 'center', true),
        CreateStoreAndGridItem('Bookingid', 'int', 'Bookingid', '预订ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Uid', 'int', 'Uid', '提供者ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopid', 'int', 'Shopid', '店铺ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopname', 'string', 'Shopname', '店铺名称', 130, 'left', true),
        CreateStoreAndGridItem('Bookingname', 'string', 'Bookingname', '预订名称', 130, 'left', true),
        CreateStoreAndGridItem('Realname', 'string', 'Realname', '提供者', 80, 'left', true),
        isoverColumn
    ];
    return columnArray;
}

function CreateOnlineBookingGrid() {

    var columnArray = GetBookingshopGridItem(false);

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-bookingonline');
        }
    }, '-'];

    var grid = CreateGroupingStoreAndGrid('grid-bookingonline', null, 'GetBookingshopOnlineList', columnArray, btns, undefined, 'Shopname', 'Bookingname', undefined, undefined, undefined, false); //CreateStoreAndGrid('grid-bookingonline', null, 'GetBookingOnlineList', columnArray, btns);

    grid.on('rowclick', function () {
        var d = GetGridSelectedData('grid-bookingonline');
        if (d) {
            Ext.getCmp('OnlineTradeListPanel').setTitle(d.Shopname.trim() + '菜单');
            GetGridStore('grid-tradeonlinelist').load({ params: { Id: d.Shopid} });
        } else {
            Ext.getCmp('OnlineTradeListPanel').setTitle('菜单列表');
            GetGridStore('grid-tradeonlinelist').load({ params: { Id: 0} });
        }
    });

    grid.getSelectionModel().on('selectionchange', function (sm) {
    });

    var columnArray2 = [
        CreateStoreAndGridItem('Id', 'int', 'id', 'ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Tradename', 'string', 'Tradename', '菜单项', 100, 'left', true),
        CreateStoreAndGridItem('Tradevalue', 'float', 'Tradevalue', '单价', 100, 'left', true)
    ];

    var btns2 = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-tradeonlinelist');
        }
    }, '-'];

    btns2.push({
        id: 'BookingSelectionBtn',
        text: '预订',
        disabled: true,
        handler: function () { CreateBookingSelectionForm(false) }
    });
    if (isAdmin) {
        btns2.push({
            id: 'BookingWithBtn',
            text: '代订',
            disabled: true,
            handler: function () { CreateBookingSelectionForm(true) }
        });
    }

    var grid2 = CreateStoreAndGrid('grid-tradeonlinelist', null, 'GetTradeList', columnArray2, btns2);

    RefreshGrid('grid-tradeonlinelist');

    grid2.on('rowdblclick', function () { CreateBookingSelectionForm(false); });

    grid2.getSelectionModel().on('selectionchange', function (sm) {
        var bookingData = GetGridSelectedData('grid-bookingonline');
        if (bookingData.isOver)
            Ext.getCmp('BookingSelectionBtn').setDisabled(false);
        else
            UpdateButtonState(Ext.getCmp('BookingSelectionBtn'), sm);
        if (isAdmin) { UpdateButtonState(Ext.getCmp('BookingWithBtn'), sm); }
    });

    var pp = new Ext.Panel({
        layout: 'anchor',
        items: [{
            anchor: 'right 35%',
            layout: 'fit',
            items: [grid]
        }, {
            id: 'OnlineTradeListPanel',
            anchor: 'right 65%',
            layout: 'fit',
            title: '菜单列表',
            items: [grid2]
        }]
    });

    return pp;
}

function CreateBookingSelectionForm(wth) {
    var h = 253;
    var items = [];
    var item = CreateFormItem('店铺记录ID', 'Id');
    item.xtype = 'hidden';
    items.push(item);
    item = CreateFormItem('菜单ID', 'Tradeid');
    item.xtype = 'hidden';
    items.push(item);
    item = CreateFormItem('代订对象ID', 'WithUid');
    item.xtype = 'hidden';
    items.push(item);
    item = CreateFormItem('预订名称', 'Bookingname', '', false, '预订名称不能为空', 10, 1, '预订名称允许的最大长度为: 10', '预订名称允许的最小长度为: 1');
    items.push(item);
    item.readOnly = true;
    item.disabled = true;
    item = CreateFormItem('店铺名称', 'Shopname', '', false, '店铺名称不能为空', 10, 1, '店铺名称允许的最大长度为: 10', '店铺名称允许的最小长度为: 1');
    items.push(item);
    item.readOnly = true;
    item.disabled = true;
    item = CreateFormItem('提供者', 'Realname', '', false, '提供者不能为空', 5, 1, '提供者允许的最大长度为: 5', '提供者允许的最小长度为: 1');
    items.push(item);
    item.readOnly = true;
    item.disabled = true;
    item = CreateFormItem('菜单项', 'Tradename', '', false, '提供者不能为空', 10, 1, '提供者允许的最大长度为: 10', '提供者允许的最小长度为: 1');
    items.push(item);
    item.readOnly = true;
    item.disabled = true;
    item = CreateFormItem('单价', 'Tradevalue', '', false, '单价不能为空', 10, 1, '单价允许的最大长度为: 10', '单价允许的最小长度为: 1');
    item.xtype = 'numberfield';
    item.readOnly = true;
    item.disabled = true;
    items.push(item);
    if (wth) {
        item = CreateComboBox('GetUserList', ['Realname', 'Uid'], 'cb-withbookingusers', ['Realname', 'Uid'], function (sender, record, index) {
            var frm = Ext.getCmp('ext-bookingonline').getForm();
            if (index != -1) {
                var d = sender.getValue();
                frm.setValues({ WithUid: d });
            } else {
                frm.setValues({ WithUid: 0 });
            }
        }, '预订用户', false);
        items.push(item);
        h += 30;
    }
    item = CreateFormItem('数量', 'Tradecount', '', false, '数量不能为空', 15, 1, '数量允许的最大长度为: 15', '数量允许的最小长度为: 1', '1');
    item.xtype = 'numberfield';
    items.push(item);

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-bookingonline', 'ext-bookingonline-win', null, null, function (sender, response) {
                RefreshCurrentBookingedList();
                RefreshUserInfoPropGrid();
            });
        }
    }];

    var bookingData = GetGridSelectedData('grid-bookingonline');
    var bookingTradeData = GetGridSelectedData('grid-tradeonlinelist');

    if (bookingData && bookingTradeData) {
        var formpanel = CreateFormPanel('ext-bookingonline', 'BookingOnline', items, buttons);


        var bookingRd = Ext.getCmp('grid-bookingonline').getSelectionModel().getSelected();
        var bookingTradeRd = Ext.getCmp('grid-tradeonlinelist').getSelectionModel().getSelected();
        bookingData.Bookingname = bookingData.Bookingname.trim();
        bookingData.Shopname = bookingData.Shopname.trim();
        bookingData.Realname = bookingData.Realname.trim();
        bookingTradeData.Tradename = bookingTradeData.Tradename.trim();

        FocusFormItem(formpanel, 'Tradecount');
        CreateWin([formpanel], 'ext-bookingonline-win', '预订', 325, h, true, true);

        formpanel.getForm().loadRecord(bookingTradeRd);
        formpanel.getForm().loadRecord(bookingRd);
        formpanel.getForm().setValues({ Tradeid: bookingTradeData.Id });
    }
}

function GetBookingedListGridItem(hideShopname, hideRemarks, hideRealname, hideTradevalue, hideBookingname) {
    var issettleColumn = CreateStoreAndGridItem('Issettle', 'bool', 'Issettle', '结束', 80, 'center', true);
    issettleColumn.xtype = 'booleancolumn';
    issettleColumn.trueText = '已结束';
    issettleColumn.falseText = '预订中';
    var isproxyColumns = CreateStoreAndGridItem('Proxyid', 'bool', 'Proxyid', '代订', 80, 'center', true);
    isproxyColumns.xtype = 'booleancolumn';
    isproxyColumns.trueText = '是';
    isproxyColumns.falseText = '否';
    var columnArray = [
        CreateStoreAndGridItem('Id', 'int', 'Id', '记录ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Bookingshopid', 'int', 'Bookingshopid', '接受预订ID', 90, 'center', true, true),
        CreateStoreAndGridItem('Bookingid', 'int', 'Bookingid', '预订ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Handlerid', 'int', 'Handlerid', '提供者ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Uid', 'int', 'Uid', '预订者ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopid', 'int', 'Shopid', '店铺ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Tradeid', 'int', 'Tradeid', '菜单项ID', 80, 'center', true, true),
        isproxyColumns,
        CreateStoreAndGridItem('Tradename', 'string', 'Tradename', '菜单项', 130, 'left', true),
        CreateStoreAndGridItem('Tradevalue', 'float', 'Tradevalue', '单价', 80, 'left', true, hideTradevalue),
        CreateStoreAndGridItem('Tradecount', 'int', 'Tradecount', '数量', 80, 'center', true),
        CreateStoreAndGridItem('Realname', 'string', 'Realname', '预订人', 80, 'left', true, hideRealname),
        CreateStoreAndGridItem('Proxyname', 'string', 'Proxyname', '代订人', 80, 'left', true, true),
        CreateStoreAndGridItem('Shopname', 'string', 'Shopname', '店铺名称', 130, 'left', true, hideShopname),
        CreateStoreAndGridItem('Bookingname', 'string', 'Bookingname', '预订名称', 130, 'left', true, hideBookingname),
        CreateStoreAndGridItem('Handlername', 'string', 'Handlername', '提供人', 80, 'left', true, true),
        CreateStoreAndGridItem('Remarks', 'string', 'Remarks', '备注', 100, 'left', true, hideRemarks),
        issettleColumn
    ];
    return columnArray;
}

function CreateCurrentBookingedListGrid() {
    var columnArray = GetBookingedListGridItem(true, true, true, true, true);

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshCurrentBookingedList();
            RefreshUserInfoPropGrid();
        }
    }, '-'];

    btns.push({
        id: 'CancelBookingedBtn',
        text: '取消预订',
        disabled: true,
        handler: function () {
            var data = GetGridSelectedData('grid-bookingedlist');
            Ext.Msg.prompt('取消' + data.Tradename, '请输入取消数量', function (result, input, sender) {
                if (result == 'ok') {
                    input = Ext.num(input, 0);
                    if (input <= 0) { ShowMsg(false, '输入错误,请输入一个正整数字!'); return; }
                    var d = GetGridSelectedData('grid-bookingedlist');
                    ExtAjaxRequest('CancelBookinged', { Id: d.Id, Tradecount: input }, function (response) {
                        if (response.success) {
                            RefreshCurrentBookingedList();
                            RefreshUserInfoPropGrid();
                        }
                    });
                }
            }, undefined, false);
        }
    });

    var grid = CreateGroupingStoreAndGrid('grid-bookingedlist', null, 'GetCurrentBookingedList', columnArray, btns, undefined, 'Realname', 'Realname', '{text}&nbsp;' +
            '<font color="red">&lt;计: ' +
            '<tpl for="rs">' +
                '<span class=hidehtml>{[ xindex == 1 ? parent.ct=0 : ""]}</span>' +
                '<span class=hidehtml>{[xindex == xcount ? parent.ct=parent.ct+values.data.Tradecount : parent.ct=parent.ct+values.data.Tradecount]}</span>' +
                '{[xindex == xcount ? parent.ct : ""]}' +
                '{[xindex == xcount ? "&nbsp;份, 共&nbsp;" : ""]}' +
                '{[xindex == xcount ? parent.ct * values.data.Tradevalue : ""]}' +
                '{[xindex == xcount ? "&nbsp;元" : ""]}' +
            '</tpl>&gt;</font>');

    grid.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('CancelBookingedBtn'), sm);
    });

    return grid;
}

function RefreshCurrentBookingedList() {
    RefreshGrid('grid-bookingedlist');
}

function RefreshUserInfoPropGrid() {
    ExtAjaxData('GetUserInfo', {}, function (rlt) {
        Ext.getCmp('PropGrid').setSource(rlt.data);
    });
}

var BookingedTextTpl = '{text} &nbsp;&nbsp; \[{[values.rs.length]} 项\] &nbsp;&nbsp; ' +
            '<font color="red">&lt;小计: ' +
            '<tpl for="rs">' +
                '<span class=hidehtml>{[ xindex == 1 ? parent.ct=0 : ""]}</span>' +
                '<span class=hidehtml>{[ xindex == 1 ? parent.ctv=0 : ""]}</span>' +
                '<span class=hidehtml>{[parent.ct=parent.ct+values.data.Tradecount]}</span>' +
                '<span class=hidehtml>{[parent.ctv=parent.ctv+values.data.Tradevalue*values.data.Tradecount]}</span>' +
                '{[xindex == xcount ? parent.ct : ""]}' +
                '{[xindex == xcount ? "&nbsp;份, 共&nbsp;" : ""]}' +
                '{[xindex == xcount ? parent.ctv : ""]}' +
                '{[xindex == xcount ? "&nbsp;元" : ""]}' +
            '</tpl> &gt;</font>';

function CreateBookingQueryGrid() {
    var columnArray = GetBookingshopGridItem(false);

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-bookingquerylist');
            GetGridStore('grid-bookingedquerytradelist').load({ params: { Bookingshopid: 0} });
        }
    }, '-'];



    var datef = new Ext.form.DateField({
        id: 'QueryDateTxt',
        name: 'QueryDateTxt',
        format: 'Y-m-d',
        showToday: true,
        maxValue: new Date(),
        allowBlank: false
    });
    datef.setValue(new Date());
    btns.push(datef);

    btns.push({
        text: '查询',
        handler: function () {
            var df = Ext.getCmp('QueryDateTxt');
            if (df.validate()) {
                GetGridStore('grid-bookingquerylist').load({ params: { Date: df.value} });
            } else {
                ShowMsg(false, '日期错误,请选择或输入日期!');
            }
        }
    });

    btns.push({
        text: '今天',
        handler: function () {
            var df = Ext.getCmp('QueryDateTxt');
            df.setValue(new Date());
            if (df.validate()) {
                GetGridStore('grid-bookingquerylist').load({ params: { Date: df.value} });
            }
        }
    });

    btns.push({
        id: 'ExportXlsBtn',
        disabled: true,
        text: '导出',
        handler: function () {
            var btn = Ext.getCmp('ExportXlsBtn');
            btn.setDisabled(true);
            var d = GetGridSelectedData('grid-bookingquerylist');
            //ShowObjectProp(d);
            ExtAjaxData('ExportXLS', { Bookingid: d.Bookingid }, function (response) {
                var btn = Ext.getCmp('ExportXlsBtn');
                btn.setDisabled(false);
                if (response.data.msg) ShowMsg(true, '<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="' + response.data.msg + '" target="_blank">请点击下载</a>');
            });
        }
    });

    var grid = CreateGroupingStoreAndGrid('grid-bookingquerylist', null, 'QueryBookingShopListByDate', columnArray, btns, undefined, 'Shopname', 'Bookingname');

    grid.on('rowclick', function () {
        var d = GetGridSelectedData('grid-bookingquerylist');
        GetGridStore('grid-bookingedquerytradelist').load({ params: { Bookingshopid: d.Id} });
    });

    grid.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('ExportXlsBtn'), sm);
    });

    var columnArray2 = GetBookingedListGridItem(false, false, false, true, true);


    var btns2 = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-bookingedquerytradelist');
        }
    }, '-'];

    var grid2 = CreateGroupingStoreAndGrid('grid-bookingedquerytradelist', null, 'QueryBookingedList', columnArray2, btns2, undefined, 'Tradename', 'Tradename', BookingedTextTpl, undefined, undefined, true);

    var pp = new Ext.Panel({
        layout: 'anchor',
        items: [{
            anchor: 'right 50%',
            layout: 'fit',
            items: [grid]
        }, {
            anchor: 'right 50%',
            layout: 'fit',
            title: '已预订列表',
            items: [grid2]
        }]
    });

    return pp;
}

function CreateBookingOverGrid() {

    var columnArray = GetBookingshopGridItem(false);

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-bookinglist');
            Ext.getCmp('FinishBookingBtn').setText('结束预订');
            GetGridStore('grid-allbookingedtradelist').load({ params: { Bookingshopid: 0} });
        }
    }, '-'];

    var datef = new Ext.form.DateField({
        id: 'SpecifiedDateTxt',
        name: 'SpecifiedDateTxt',
        format: 'Y-m-d',
        showToday: true,
        maxValue: new Date(),
        allowBlank: false
    });
    datef.setValue(new Date());
    btns.push(datef);

    btns.push({
        text: '查询',
        handler: function () {
            var df = Ext.getCmp('SpecifiedDateTxt');
            if (df.validate()) {
                GetGridStore('grid-bookinglist').load({ params: { Date: df.value} });
                Ext.getCmp('FinishBookingBtn').setText('结束预订');
            } else {
                ShowMsg(false, '日期错误,请选择或输入日期!');
            }
        }
    });

    btns.push({
        text: '今天',
        handler: function () {
            var df = Ext.getCmp('SpecifiedDateTxt');
            df.setValue(new Date());
            if (df.validate()) {
                GetGridStore('grid-bookinglist').load({ params: { Date: df.value} });
                Ext.getCmp('FinishBookingBtn').setText('结束预订');
            }
        }
    });

    if (isAdmin) {
        btns.push('-');

        btns.push({
            id: 'FinishBookingBtn',
            text: '结束预订',
            disabled: true,
            handler: function () {
                var data = GetGridSelectedData('grid-bookinglist');
                var id = data.Bookingid;
                ExtAjaxRequest('FinishBooking', { Id: id }, function () {
                    RefreshGrid('grid-bookinglist');
                    RefreshGrid('cb-bookinglist');
                });
            }
        });
    }

    var grid = CreateGroupingStoreAndGrid('grid-bookinglist', null, 'GetBookingShopListByDate', columnArray, btns, undefined, 'Shopname', 'Bookingname');

    grid.on('rowclick', function () {
        var d = GetGridSelectedData('grid-bookinglist');
        Ext.getCmp('FinishBookingBtn').setText('结束' + d.Bookingname);
        GetGridStore('grid-allbookingedtradelist').load({ params: { Bookingshopid: d.Id} });
    });

    grid.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('FinishBookingBtn'), sm);
    });


    var columnArray2 = GetBookingedListGridItem(false, false, false, true, true);


    var btns2 = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-allbookingedtradelist');
        }
    }, '-'];

    btns2.push({
        id: 'UnBookingBtn',
        text: '退订',
        disabled: true,
        handler: function () {
            var d = GetGridSelectedData('grid-allbookingedtradelist');
            ExtAjaxRequest('CancelBookinged', { Id: d.Id, Tradecount: d.Tradecount }, function (rlt) {
                RefreshGrid('grid-allbookingedtradelist');
            });
        }
    });

    var grid2 = CreateGroupingStoreAndGrid('grid-allbookingedtradelist', null, 'GetBookingedList', columnArray2, btns2, undefined, 'Tradename', 'Tradename', BookingedTextTpl, undefined, undefined, true);

    grid2.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('UnBookingBtn'), sm);
    });

    var pp = new Ext.Panel({
        layout: 'anchor',
        items: [{
            anchor: 'right 50%',
            layout: 'fit',
            items: [grid]
        }, {
            anchor: 'right 50%',
            layout: 'fit',
            title: '已预订列表',
            items: [grid2]
        }]
    });

    return pp;
}

function CreateBookingGrid() {
    var columnArray = [
        CreateStoreAndGridItem('Id', 'int', 'Id', '店铺ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopname', 'string', 'Shopname', '店铺名称', 200, 'left', true),
        CreateStoreAndGridItem('Phone', 'string', 'Phone', '店铺电话', 200, 'left', false)
    ];

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-bookingshoplist');
        }
    }, '-'];

    var combo = CreateComboBox('GetBookingList', ['Bookingname', 'Id'], 'cb-bookinglist', ['Bookingname', 'Id'], function (sender, record, index) {

        if (GetGridSelectedData('grid-bookingshoplist')) {
            UpdateButtonState(Ext.getCmp('JoinBookingBtn'), null, sender, record, index);
        }

        UpdateButtonState(Ext.getCmp('DelBookingBtn'), null, sender, record, index);

        if (index >= 0) {
            GetGridStore('grid-dateshoplist').load({ params: { Bookingid: sender.getValue()} });
        }

        var p = Ext.getCmp('BookingShopListPanel');
        if (p) {
            if (index != -1) {
                p.setTitle(sender.lastSelectionText + '接受预订的店铺');
            } else {
                p.setTitle('接受预订的店铺');
            }
        }
    });

    btns.push(combo);

    btns.push({
        text: '新建预订',
        handler: CreateAddBookingForm
    });

    btns.push({
        id: 'DelBookingBtn',
        text: '删除预订',
        disabled: true,
        handler: function () {
            var cb = Ext.getCmp('cb-bookinglist');
            var id = cb.getValue();
            ExtAjaxRequest('DelBooking', { Id: id }, function () {
                Ext.getCmp('cb-bookinglist').reset();
                GetGridStore('cb-bookinglist').reload();
                Ext.getCmp('DelBookingBtn').setDisabled(true);
                Ext.getCmp('JoinBookingBtn').setDisabled(true);
            });

        }
    });

    btns.push('-');

    btns.push({
        id: 'JoinBookingBtn',
        text: '加入预订',
        disabled: true,
        handler: function () {
            var cb = Ext.getCmp('cb-bookinglist');
            var bookingId = cb.getValue();
            var bookingName = cb.lastSelectionText.trim();
            var data = GetGridSelectedData('grid-bookingshoplist');
            if (data && bookingId && bookingId != '') {
                var params = {
                    Bookingid: bookingId,
                    Bookingname: bookingName,
                    Shopid: data.Id,
                    Shopname: data.Shopname.trim()
                }

                ExtAjaxRequest('JoinBooking', params, function () {
                    RefreshGrid('grid-dateshoplist');
                });
            }
        }
    });

    var grid = CreateStoreAndGrid('grid-bookingshoplist', null, 'GetShopList', columnArray, btns);

    grid.getSelectionModel().on('selectionchange', function (sm) {
        var cb = Ext.getCmp('cb-bookinglist');
        if (cb.getValue() != '') { UpdateButtonState(Ext.getCmp('JoinBookingBtn'), sm); }
    });

    //var isoverColumn = CreateStoreAndGridItem('Isover', 'bool', 'Isover', '是否结算', 100, 'center', false);
    //isoverColumn.xtype = 'booleancolumn';
    //isoverColumn.trueText = '已结算';
    //isoverColumn.falseText = '未结算';

    var columnArray2 = [
        CreateStoreAndGridItem('Id', 'int', 'id', '记录ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Uid', 'int', 'Uid', '提供者ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Bookingid', 'int', 'Bookingid', '预订ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopid', 'int', 'Shopid', '店铺ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopname', 'string', 'Shopname', '店铺名称', 130, 'left', true),
        CreateStoreAndGridItem('Bookingname', 'string', 'Bookingname', '预订名称', 130, 'left', true),
        CreateStoreAndGridItem('Realname', 'string', 'Realname', '提供者', 100, 'left', true)//,
        //isoverColumn
    ];

    var btns2 = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-dateshoplist');
        }
    }, '-'];

    btns2.push({
        id: 'DelBookingShopBtn',
        text: '删除店铺',
        disabled: true,
        handler: function () {
            var data = GetGridSelectedData('grid-dateshoplist');
            ExtAjaxRequest('DelBookingShop', { Id: data.Id }, function () {
                RemoveGridSelectedRow('grid-dateshoplist');
            });
        }
    });

    var grid2 = CreateStoreAndGrid('grid-dateshoplist', null, 'GetBookingShopList', columnArray2, btns2, undefined, 'JoinBookingGroup');

    grid2.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('DelBookingShopBtn'), sm);
    });

    var pp = new Ext.Panel({
        layout: 'anchor',
        items: [{
            anchor: 'right 50%',
            layout: 'fit',
            items: [grid]
        }, {
            id: 'BookingShopListPanel',
            anchor: 'right 50%',
            layout: 'fit',
            title: '接受预订的店铺',
            items: [grid2]
        }]
    });

    return pp;
}

function CreateAddBookingForm() {
    var items = [
        CreateFormItem('预订名称','Bookingname','请输入预订名称..',false,'预订名称不能为空',10,1,'预订名称允许的最大长度为: 10','预订名称允许的最小长度为: 1',"午餐预订")
    ];
    
    var d = new Ext.form.DateField({
        fieldLabel: '开始日期',
        id: 'Bookingtime',
        name: 'Bookingtime',
        format: 'Y-m-d',
        showToday: true,
        allowBlank: false,
        minValue: new Date()
    });

    items.push(d);

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-addbooking', 'ext-addbooking-win', null, null, function (sender, response) {
                GetGridStore('cb-bookinglist').reload();
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-addbooking', 'AddBooking', items, buttons);
    FocusFormItem(formpanel, 'Bookingname');
    CreateWin([formpanel], 'ext-addbooking-win', '新建预订', 325, 150, true, true);
}

function CreateShopGrid() {
    var columnArray = [
        CreateStoreAndGridItem('Id', 'int', 'id', '店铺ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Shopname', 'string', 'Shopname', '店铺名称', 200, 'left', true),
        CreateStoreAndGridItem('Phone', 'string', 'Phone', '店铺电话', 200, 'left', false)
    ];

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-shoplist');
            var store = GetGridStore('grid-tradelist');
            store.load({ params: { Id: 0} });
        }
    }, '-'];

    btns.push({
        text: '新增店铺',
        handler: CreateAddShopForm
    });

    btns.push({
        id: 'EditShopBtn',
        text: '修改店铺',
        disabled: true,
        handler: CreateEditShopForm
    });

    btns.push({
        id: 'DelShopBtn',
        text: '删除店铺',
        disabled: true,
        handler: function () {
            var data = GetGridSelectedData('grid-shoplist');
            var id = data.Id;
            ExtAjaxRequest('DelShop', { Id: id }, function () {
                RemoveGridSelectedRow('grid-shoplist');
            });
        }
    });

    btns.push({
        id: 'AddTradeBtn',
        text: '新增菜单',
        disabled: true,
        handler: CreateAddTradeForm
    });

//    btns.push({
//        id: 'ViewTradeBtn',
//        text: '查看菜单',
//        disabled: true,
//        handler: function () {
//            var data = GetGridSelectedData('grid-shoplist');
//            var id = data.Id;
//            var store = GetGridStore('grid-tradelist');
//            store.load({ params: { Id: id} });
//            var g = Ext.getCmp('TradeListPanel');
//            if (g) { g.setTitle(data.Shopname.trim() + '菜单'); }
//        }
//    });

    var grid = CreateStoreAndGrid('grid-shoplist', null, 'GetShopList', columnArray, btns);

    grid.on('rowclick', function () {
        var data = GetGridSelectedData('grid-shoplist');
        var id = data.Id;
        var store = GetGridStore('grid-tradelist');
        store.load({ params: { Id: id} });
        var g = Ext.getCmp('TradeListPanel');
        if (g) { g.setTitle(data.Shopname.trim() + '菜单'); }
    });
    grid.on('rowdblclick', CreateEditShopForm);

    grid.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('DelShopBtn'), sm);
        UpdateButtonState(Ext.getCmp('EditShopBtn'), sm);
        UpdateButtonState(Ext.getCmp('AddTradeBtn'), sm);
        UpdateButtonState(Ext.getCmp('ViewTradeBtn'), sm);
    });

    var columnArray2 = [
        CreateStoreAndGridItem('Id', 'int', 'id', 'ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Tradename', 'string', 'Tradename', '菜单项', 100, 'left', true),
        CreateStoreAndGridItem('Tradevalue', 'float', 'Tradevalue', '单价', 100, 'left', true)
    ];

    var btns2 = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-tradelist');
        }
    }, '-'];

    btns2.push({
        id: 'EditTradeBtn',
        text: '修改菜单',
        disabled: true,
        handler: CreateEditTradeForm
    });

    btns2.push({
        id: 'DelTradeBtn',
        text: '删除菜单',
        disabled: true,
        handler: function () {
            var data = GetGridSelectedData('grid-tradelist');
            var id = data.Id;
            ExtAjaxRequest('DelTrade', { Id: id }, function () {
                RemoveGridSelectedRow('grid-tradelist');
            });
        }
    });

    var grid2 = CreateStoreAndGrid('grid-tradelist', null, 'GetTradeList', columnArray2, btns2);

    grid2.on('rowdblclick', CreateEditTradeForm);

    grid2.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('EditTradeBtn'), sm);
        UpdateButtonState(Ext.getCmp('DelTradeBtn'), sm);
    });

    var pp = new Ext.Panel({
        layout: 'anchor',
        items: [{
            anchor: 'right 50%',
            layout: 'fit',
            items:[grid]
        }, {
            id: 'TradeListPanel',
            anchor: 'right 50%',
            layout: 'fit',
            title: '菜单',
            items: [grid2]//html: '<div>请在上面网格中选择一行数据</div>'
        }]
    });

    return pp;
}

function CreateEditTradeForm() {
    var items = [{
        id: 'Id',
        name: 'Id',
        xtype: 'hidden'
    }, {
        id: 'Shopid',
        name: 'Shopid',
        xtype: 'hidden'
    }, {
        fieldLabel: '菜单名称',
        id: 'Tradename',
        name: 'Tradename',
        emptyText: '请输入菜单名称..',
        allowBlank: false,
        selectOnFocus: true,
        blankText: '菜单名称不能为空',
        maxLength: 10,
        minLength: 1,
        maxLengthText: '菜单名称允许的最大长度为: 10',
        minLengthText: '菜单名称允许的最小长度为: 1'
    }, {
        fieldLabel: '金　　额',
        xtype: 'numberfield',
        id: 'Tradevalue',
        name: 'Tradevalue',
        emptyText: '请输入金额..',
        allowBlank: false,
        blankText: '金额不能为空!'
    }];

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-edittrade', 'ext-edittrade-win', undefined, undefined, function () {
                RefreshGrid('grid-tradelist');
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-edittrade', 'EditTrade', items, buttons);
    FocusFormItem(formpanel, 'Tradename');
    CreateWin([formpanel], 'ext-edittrade-win', '修改菜单', 325, 150, true, true);

    var rd = Ext.getCmp('grid-tradelist').getSelectionModel().getSelected();
    var data = GetGridSelectedData('grid-tradelist');
    data.Tradename = data.Tradename.trim();
    formpanel.getForm().loadRecord(rd);
}

function CreateAddTradeForm() {
    var data = GetGridSelectedData('grid-shoplist');
    var shopid = data.Id;
    var items = [{
        id: 'Shopid',
        name: 'Shopid',
        xtype: 'hidden',
        value: shopid
    }, {
        fieldLabel: '菜单名称',
        id: 'Tradename',
        name: 'Tradename',
        emptyText: '请输入菜单名称..',
        allowBlank: false,
        selectOnFocus: true,
        blankText: '菜单名称不能为空',
        maxLength: 10,
        minLength: 1,
        maxLengthText: '菜单名称允许的最大长度为: 10',
        minLengthText: '菜单名称允许的最小长度为: 1'
    }, {
        fieldLabel: '金　　额',
        xtype: 'numberfield',
        id: 'Tradevalue',
        name: 'Tradevalue',
        emptyText: '请输入金额..',
        allowBlank: false,
        blankText: '金额不能为空!'
    }];

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-addtrade', 'ext-addtrade-win', undefined, undefined, function () {
                var d = GetGridSelectedData('grid-shoplist');
                var store = GetGridStore('grid-tradelist');
                store.load({ params: { Id: d.Id} });
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-addtrade', 'AddTrade', items, buttons);
    FocusFormItem(formpanel, 'Tradename');
    CreateWin([formpanel], 'ext-addtrade-win', '新增菜单', 325, 150, true, true);
}

function CreateEditShopForm(){
    var items = [{
        id: 'Id',
        name: 'Id',
        xtype: 'hidden'
    }, {
        fieldLabel: '店铺名称',
        id: 'Shopname',
        name: 'Shopname',
        emptyText: '请输入店铺名称..',
        allowBlank: false,
        selectOnFocus: true,
        blankText: '店铺名称不能为空',
        maxLength: 10,
        minLength: 1,
        maxLengthText: '店铺名称允许的最大长度为: 10',
        minLengthText: '店铺名称允许的最小长度为: 1'
    }, {
        fieldLabel: '店铺电话',
        id: 'Phone',
        name: 'Phone',
        allowBlank: false,
        selectOnFocus: true,
        blankText: '店铺电话不能为空!',
        maxLength: 20,
        minLength: 1,
        maxLengthText: '店铺电话允许的最大长度为: 20',
        minLengthText: '店铺电话允许的最小长度为: 1'
    }];

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-editshop', 'ext-editshop-win', undefined, undefined, function () {
                RefreshGrid('grid-shoplist');
                var store = GetGridStore('grid-tradelist');
                store.load({ params: { Id: 0} });
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-editshop', 'EditShop', items, buttons);
    FocusFormItem(formpanel, 'Shopname');
    CreateWin([formpanel], 'ext-editshop-win', '修改店铺', 325, 150, true, true);

    var rd = Ext.getCmp('grid-shoplist').getSelectionModel().getSelected();
    var data = GetGridSelectedData('grid-shoplist');
    data.Shopname = data.Shopname.trim();
    data.Phone = data.Phone.trim();
    formpanel.getForm().loadRecord(rd);
}

function CreateAddShopForm() {
    var items = [{
        fieldLabel: '店铺名称',
        id: 'Shopname',
        name: 'Shopname',
        emptyText: '请输入店铺名称..',
        allowBlank: false,
        selectOnFocus: true,
        blankText: '店铺名称不能为空',
        maxLength: 10,
        minLength: 1,
        maxLengthText: '店铺名称允许的最大长度为: 10',
        minLengthText: '店铺名称允许的最小长度为: 1'
    }, {
        fieldLabel: '店铺电话',
        id: 'Phone',
        name: 'Phone',
        allowBlank: false,
        selectOnFocus: true,
        blankText: '店铺电话不能为空!',
        maxLength: 20,
        minLength: 1,
        maxLengthText: '店铺电话允许的最大长度为: 20',
        minLengthText: '店铺电话允许的最小长度为: 1'
    }];

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-addshop', 'ext-addshop-win', undefined, undefined, function () {
                RefreshGrid('grid-shoplist');
                var store = GetGridStore('grid-tradelist');
                store.load({ params: { Id: 0} });
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-addshop', 'AddShop', items, buttons);
    FocusFormItem(formpanel, 'Shopname');
    CreateWin([formpanel], 'ext-addshop-win', '新增店铺', 325, 150, true, true);
}

function CreateBalanceGrid() {
    var columnArray = [
        CreateStoreAndGridItem('Id', 'int', 'Id', '记录ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Btime', 'date', 'Btime', '充值时间', 80, 'center', true),
        CreateStoreAndGridItem('Balances', 'float', 'Balances', '充值金额', 100, 'left', true),
        CreateStoreAndGridItem('Remarks', 'string', 'Remarks', '备注', 300, 'left', false)
    ];

    columnArray[1].renderer = Ext.util.Format.dateRenderer('Y-m-d');
    //columnArray[1].renderer = Ext.util.Format.dateRenderer('Y-m-d H:i:s');

    var btns = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-balancelist');
        }
    }, '-'];

    var combo = CreateComboBox('GetUserList', ['Realname', 'Uid'], 'cb-allusers', ['Realname', 'Uid'], function (sender, record, index) {
        var store = GetGridStore('grid-balancelist');
        var sid = sender.getValue();
        if (sid == '' || sid == '0') sid = 0;
        store.load({ params: { Uid: sid } });
    });

    btns.push(combo);

    var grid = CreateStoreAndGrid('grid-balancelist', null, 'GetBalanceList', columnArray, btns);
    return grid;
}

//用户列表
function CreateUserGrid() {
    var columnArray = [
        CreateStoreAndGridItem('Uid', 'int', 'Uid', '用户ID', 80, 'center', true, true),
        CreateStoreAndGridItem('Account', 'string', 'Account', '用户账号', 100, 'left', true),
        CreateStoreAndGridItem('Realname', 'string', 'Realname', '用户姓名', 100, 'left', true),
        CreateStoreAndGridItem('Balance', 'float', 'Balance', '账户余额', 100, 'left', true)
    ];
    var enabledColumn = CreateStoreAndGridItem('Enabled', 'bool', 'Enabled', '状态', 30, 'center', true, false);
    enabledColumn.xtype = 'booleancolumn';
    enabledColumn.trueText = '启用';
    enabledColumn.falseText = '禁用';
    columnArray.unshift(enabledColumn);

    var btnList = [{
        text: '刷新',
        handler: function () {
            RefreshGrid('grid-userlist');
        }
    }];

    btnList.push('-');

    btnList.push({
        text: '新增用户',
        handler: CreateAddUserForm
    });

    btnList.push({
        id: 'EnableUserBtn',
        text: '启用用户',
        disabled: true,
        handler: function () {
            ShowMsg(false, '确定禁要用 ' + GetGridSelectedData('grid-userlist').Realname + ' 这个用户吗?', true, function (rlt) {
                if (rlt.trim() == "yes") {
                    var id = GetGridSelectedData('grid-userlist').Uid;
                    ExtAjaxRequest('EnableUser', { Uid: id }, function () {
                        RefreshGrid('grid-userlist');
                    });
                }
            });
        }
    });

    btnList.push({
        id: 'DisableUserBtn',
        text: '禁用用户',
        disabled: true,
        handler: function () {
            ShowMsg(false, '确定要禁用 ' + GetGridSelectedData('grid-userlist').Realname + ' 这个用户吗?', true, function (rlt) {
                if (rlt.trim() == "yes") {
                    var id = GetGridSelectedData('grid-userlist').Uid;
                    ExtAjaxRequest('DisableUser', { Uid: id }, function () {
                        RefreshGrid('grid-userlist');
                    });
                }
            });
        }
    });

    btnList.push({
        id: 'DelUserBtn',
        text: '删除用户',
        disabled: true,
        handler: function () {
            ShowMsg(false, '确定要删除 ' + GetGridSelectedData('grid-userlist').Realname + ' 这个用户吗?', true, function (rlt) {
                if (rlt.trim() == "yes") {
                    var id = GetGridSelectedData('grid-userlist').Uid;
                    ExtAjaxRequest('DelUser', { Uid: id }, function () {
                        RemoveGridSelectedRow('grid-userlist');
                    });
                }
            });
        }
    });

    btnList.push({
        id: 'ResetPasswdBtn',
        text: '重置密码',
        disabled: true,
        handler: CreateResetPasswdForm
    });

    btnList.push({
        id: 'UserBalanceBtn',
        text: '用户充值',
        disabled: true,
        handler: CreateBalanceForm
    });

    btnList.push({
        id: 'DeductionBtn',
        text: '手动扣款',
        disabled: true,
        handler: CreateDeductionForm
    });

    btnList.push({
        id: 'ReturnCashBtn',
        text: '返还现金',
        disabled: true,
        handler: function () {
            ShowMsg(false, '返还现金后帐户余额将清零!是否继续返还现金?', true, function (rlt) {
                if (rlt.trim() == "yes") {
                    var d = GetGridSelectedData('grid-userlist');
                    ExtAjaxRequest('ReturnCash', { Uid: d.Uid }, function (rlt) {
                        var dd = GetGridSelectedData('grid-userlist');
                        if (dd) {
                            dd.Balance = 0;
                            RefreshGridView('grid-userlist');
                        }
                    });
                }
            });
        }
    });

    btnList.push({
        id: 'SetAdminBtn',
        text: '设为管理员',
        disabled: true,
        handler: function () {
            ShowMsg(false, '确定将 ' + GetGridSelectedData('grid-userlist').Realname + ' 设置成管理员吗？', true, function (rlt) {
                if (rlt.trim() == "yes") {
                    var id = GetGridSelectedData('grid-userlist').Uid;
                    ExtAjaxRequest('SetAdmin', { Uid: id });
                }
            });
        }
    });

    btnList.push({
        id: 'SetNormalBtn',
        text: '设为普通用户',
        disabled: true,
        handler: function () {
            ShowMsg(false, '确定将 ' + GetGridSelectedData('grid-userlist').Realname + ' 设置成管理员吗？', true, function (rlt) {
                if (rlt.trim() == "yes") {
                    var id = GetGridSelectedData('grid-userlist').Uid;
                    ExtAjaxRequest('SetNormal', { Uid: id });
                }
            });
        }
    });

    var grid = CreateStoreAndGrid('grid-userlist', null, 'GetUserList', columnArray, btnList);

    grid.getSelectionModel().on('selectionchange', function (sm) {
        UpdateButtonState(Ext.getCmp('EnableUserBtn'), sm);
        UpdateButtonState(Ext.getCmp('DisableUserBtn'), sm);
        UpdateButtonState(Ext.getCmp('DelUserBtn'), sm);
        UpdateButtonState(Ext.getCmp('ResetPasswdBtn'), sm);
        UpdateButtonState(Ext.getCmp('UserBalanceBtn'), sm);
        UpdateButtonState(Ext.getCmp('ReturnCashBtn'), sm);
        UpdateButtonState(Ext.getCmp('SetAdminBtn'), sm);
        UpdateButtonState(Ext.getCmp('SetNormalBtn'), sm);
        UpdateButtonState(Ext.getCmp('DeductionBtn'), sm);
    });

    return grid;
}

function CreateDeductionForm() {
    var selectedData = GetGridSelectedData('grid-userlist');
    var items = [];
    var item;
    item = CreateFormItem('用户ID', 'Uid', undefined, undefined, undefined, undefined, undefined, undefined, undefined, selectedData.Uid);
    item.xtype = 'hidden';
    items.push(item);
    item = CreateFormItem('用户姓名', 'Realname', undefined, undefined, undefined, undefined, undefined, undefined, undefined, selectedData.Realname);
    item.readOnly = true;
    item.disabled = true;
    items.push(item);
    item = CreateFormItem('扣款项目', 'Deductionname', '请输入扣款项目名称..', false, '扣款项目不能为空!', 60, 1, '扣款项目允许的最大长度为: 60', '扣款项目允许的最小长度为: 1');
    items.push(item);
    item = CreateFormItem('扣款金额', 'Deductionvalue', undefined, false, undefined, undefined, undefined, undefined, undefined, 0);
    item.xtype = 'numberfield';
    items.push(item);
    item = CreateFormItem('备注', 'Remarks', undefined, true, undefined, 60, undefined, '扣款项目允许的最大长度为: 60', undefined);
    items.push(item);

    var buttons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-deduction', 'ext-deduction-win', null, null, function (sender, response) {
                RefreshGrid('grid-userlist');
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-deduction', 'Deduction', items, buttons);

    CreateWin([formpanel], 'ext-deduction-win', '扣款', 325, 200, true, true);
}

function CreateResetPasswdForm() {
    var data = GetGridSelectedData('grid-userlist');
    var uid = data.Uid;
    var rname = data.Realname;
    rname = rname.trim();

    var items = [];
    items.push({
        id: 'Uid',
        name: 'Uid',
        xtype: 'hidden',
        value: uid,
        readOnly: true
    });
    items.push({
        fieldLabel: '用户姓名',
        id: 'Realname',
        name: 'Realname',
        value: rname,
        readOnly: true
    });
    items.push({
        fieldLabel: '新 密 码',
        id: 'NewPasswd',
        name: 'NewPasswd',
        inputType: 'password',
        allowBlank: false,
        blankText: PASSWD_BLANK_TEXT,
        maxLength: PASSWD_MAX_LENGTH,
        minLength: PASSWD_MIN_LENGTH,
        maxLengthText: PASSWD_MAX_TEXT + PASSWD_MAX_LENGTH,
        minLengthText: PASSWD_MIN_TEXT + PASSWD_MIN_LENGTH
    });
    items.push({
        fieldLabel: RE_PASSWD_LABEL,
        id: 'ReNewPasswd',
        name: 'ReNewPasswd',
        inputType: 'password',
        vtype: 'password',
        initialPassField: 'NewPasswd',
        allowBlank: false,
        blankText: '两次输入的密码不一致!'
    });

    var bottons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-resetpasswd', 'ext-resetpasswd-win');
        }
    }];

    var formpanel = CreateFormPanel('ext-resetpasswd', 'ResetPasswd', items, bottons);
    FocusFormItem(formpanel, 'NewPasswd');
    CreateWin([formpanel], 'ext-resetpasswd-win', '重置用户密码', 325, 180, true, true);
}

function CreateBalanceForm() {
    var data = GetGridSelectedData('grid-userlist');
    var uid = data.Uid;
    var rname = data.Realname;
    rname = rname.trim();

    var items = [{
        id: 'Uid',
        name: 'Uid',
        xtype: 'hidden',
        value: uid,
        readOnly: true
    }, {
        fieldLabel: '用户姓名',
        id: 'Realname',
        name: 'Realname',
        value: rname,
        readOnly: true
    }, {
        fieldLabel: '充值金额',
        xtype: 'numberfield',
        id: 'Balancemoney',
        name: 'Balancemoney',
        emptyText: '请输入金额..',
        allowBlank: false,
        blankText: '金额不能为空'
    }, {
        fieldLabel: '备注',
        id: 'Remarks',
        name: 'Remarks'
    }];

    var bottons = [{
        text: SUBMIT_TEXT,
        handler: function () {
            SubmitForm('ext-balance', 'ext-balance-win', undefined, undefined, function () {
                RefreshGrid('grid-userlist');
            });
        }
    }];

    var formpanel = CreateFormPanel('ext-balance', 'UserBalance', items, bottons);
    FocusFormItem(formpanel, 'Balancemoney');
    CreateWin([formpanel], 'ext-balance-win', '用户充值', 325, 170, true, true);
}

function CreateLoginForm(closeable) {
    var items = [{
        fieldLabel: USERNAME_LABEL,
        id: 'Account',
        name: 'Account',
        emptyText: USERNAME_EMPTY_TIP,
        allowBlank: false,
        blankText: USERNAME_BLANK_TEXT,
        maxLength: USERNAME_MAX_LENGTH,
        minLength: USERNAME_MIN_LENGTH,
        maxLengthText: USERNAME_MAX_TEXT + USERNAME_MAX_LENGTH,
        minLengthText: USERNAME_MIN_TEXT + USERNAME_MIN_LENGTH
    }, {
        fieldLabel: PASSWD_LABEL,
        id: 'Passwd',
        name: 'Passwd',
        inputType: 'password',
        allowBlank: false,
        blankText: PASSWD_BLANK_TEXT,
        maxLength: PASSWD_MAX_LENGTH,
        minLength: PASSWD_MIN_LENGTH,
        maxLengthText: PASSWD_MAX_TEXT + PASSWD_MAX_LENGTH,
        minLengthText: PASSWD_MIN_TEXT + PASSWD_MIN_LENGTH
    }];
    var buttons = [{
        text: LOGINBTN_TEXT,
        handler: function () {
            SubmitForm('ext-login', 'ext-login-win', true, function (rlt) { Reload(); });
        }
    }];

    var formpanel = CreateFormPanel('ext-login', 'Login', items, buttons);

    FocusFormItem(formpanel, 'Account');

    CreateWin([formpanel], 'ext-login-win', LOGINWIN_TITLE, 325, 150, closeable, true);
}

function CreateAddUserForm() {
    var items = [{
        fieldLabel: USERNAME_LABEL,
        id: 'Account',
        name: 'Account',
        emptyText: USERNAME_EMPTY_TIP,
        allowBlank: false,
        selectOnFocus: true,
        blankText: USERNAME_BLANK_TEXT,
        maxLength: USERNAME_MAX_LENGTH,
        minLength: USERNAME_MIN_LENGTH,
        maxLengthText: USERNAME_MAX_TEXT + USERNAME_MAX_LENGTH,
        minLengthText: USERNAME_MIN_TEXT + USERNAME_MIN_LENGTH
    }, {
        fieldLabel: PASSWD_LABEL,
        id: 'Passwd',
        name: 'Passwd',
        inputType: 'password',
        allowBlank: false,
        selectOnFocus: true,
        blankText: PASSWD_BLANK_TEXT,
        maxLength: PASSWD_MAX_LENGTH,
        minLength: PASSWD_MIN_LENGTH,
        maxLengthText: PASSWD_MAX_TEXT + PASSWD_MAX_LENGTH,
        minLengthText: PASSWD_MIN_TEXT + PASSWD_MIN_LENGTH
    }, {
        fieldLabel: RE_PASSWD_LABEL,
        id: 'RePasswd',
        name: 'RePasswd',
        inputType: 'password',
        vtype: 'password',
        initialPassField: 'Passwd',
        allowBlank: false,
        selectOnFocus: true
    }, {
        fieldLabel: RNAME_LABEL,
        id: 'Realname',
        name: 'Realname',
        allowBlank: false,
        selectOnFocus: true,
        blankText: RNAME_BLANK_TEXT,
        maxLength: RNAME_MAX_LENGTH,
        minLength: RNAME_MIN_LENGTH,
        maxLengthText: RNAME_MAX_TEXT + RNAME_MAX_LENGTH,
        minLengthText: RNAME_MIN_TEXT + RNAME_MIN_LENGTH
    }, {
        fieldLabel: '',
        id: 'IsAdmin',
        name: 'IsAdmin',
        xtype: 'checkbox',
        boxLabel: '管 理 员'
    }];

    var buttons = [{
        text: REGISTER_TEXT,
        handler: function () {
            SubmitForm('ext-adduser', 'ext-adduser-win', undefined, undefined, function () {
                RefreshGrid('grid-userlist');
            });
        }
    }];
    var formpanel = CreateFormPanel('ext-adduser', 'AddUser', items, buttons);
    FocusFormItem(formpanel, 'Account');
    CreateWin([formpanel], 'ext-adduser-win', '新增用户', 325, 220, true, true);
}