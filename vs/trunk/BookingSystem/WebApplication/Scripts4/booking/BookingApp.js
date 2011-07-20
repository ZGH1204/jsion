Ext.define('Ext.ux.booking.BookingApp', {
    extend: 'Ext.ux.desktop.Module',
    requires: [
        'Ext.ux.booking.BookingConfig'
    ],
    id: 'booking-win',
    init: function () {
        this.launcher = {
            text: 'Booking Window',
            iconCls: 'icon-grid',
            handler: this.createWindow,
            scope: this
        };
    },
    createWindow: function () {
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('booking-win');
        if (!win) {
            var itms = this.getMenus();
            win = desktop.createWindow({
                id: 'booking-win',
                title: '点餐系统',
                width: 740,
                height: 480,
                iconCls: 'icon-grid',
                animCollapse: false,
                constrainHeader: true,
                layout: {
                    type: 'hbox',
                    align: 'stretch'
                },
                items: [{
                    xtype: 'panel',
                    title: '分类菜单',
                    flex: 1,
                    split: true,
                    collapsible: true,
                    collapseDirection: 'left',
                    layout: 'accordion',
                    items: itms
                }, {
                    xtype: 'splitter',
                    width: 3,
                    disabled: true
                }, this.getContainer()]
            });
        }
        win.show();
        return win;
    },
    getMenus: function () {
        var list = [];

        var item = new Ext.Panel({
            title: '&nbsp;&nbsp;&nbsp;&nbsp;用户菜单',
            cls: 'empty'
        });
        item.on('render', this.setUserNavigationItems);
        list.push(item);

        item = new Ext.Panel({
            title: '&nbsp;&nbsp;&nbsp;&nbsp;系统设置',
            cls: 'empty'
        });
        item.on('render', this.setAllGlobalItems);
        list.push(item);

        return list;
    },
    getContainer: function () {
        return new Ext.TabPanel({
            id: 'allTabsPanel',
            autoScroll: true,
            flex: 3,
            items: [{
                title: '欢迎',
                autoScroll: true,
                items: [{
                    xtype: 'panel',
                    layout: {
                        type: 'vbox',
                        align: 'stretch'
                    },
                    html: '<div style=\"text-align: center; padding-top: 10px; height: 30px;\"><b>欢迎使用本系统</b></div>'
                }]
            }]
        });
    },
    setAllGlobalItems: function (panelContaint) {
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
    },
    setUserNavigationItems: function (panelContaint) {
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
});