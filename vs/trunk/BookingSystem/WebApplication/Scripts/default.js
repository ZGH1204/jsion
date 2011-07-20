///<reference path="/Scripts/vswd-ext_2.0.2.js" />
var globalSettingItem;
var tabs;
var viewport;

function CreateMainView(tb) {
    tabs = new Ext.TabPanel({
        id: 'center-region-container',
        region: 'center',
        deferredRender: false,
        autoScroll: true,
        margins: '0 5 0 0',
        activeTab: 0,
        tbar: tb,
        items: [{
            contentEl: 'authersummary',
            title: COMPANY,
            autoScroll: true
        }]
    });

    var navList = [];
    if (isLogin) {
        userNavigationItem = new Ext.Panel({
            title: '用户导航',
            cls: 'empty'
        });
        userNavigationItem.on('render', setUserNavigationItems);
        navList.push(userNavigationItem);

        globalSettingItem = new Ext.Panel({
            title: GLOBAL_SETTING_TITLE,
            cls: 'empty'
        });
        globalSettingItem.on('render', setAllGlobalItems);

        if (isAdmin) {
            navList.unshift(globalSettingItem);
        }
    }

    viewport = new Ext.Viewport({
        layout: 'border',
        resize: false,
        items: [new Ext.BoxComponent({
            region: 'north',
            autoEl: {
                tag: 'div',
                html: '<div style="padding: 10px; margin-top: 10px; height: 30px; text-align: center; font-size: 20px;font-weight: bold;">欢迎使用' + COMPANY + '点餐系统</div>'
            }
        }), {
            region: 'south',
            contentEl: 'southcopyright',
            collapsible: true,
            collapsed: true,
            split: true,
            height: 100,
            minSize: 100,
            maxSize: 100,
            collapsible: true,
            title: COPYRIGHT_TITLE,
            margins: '0 5 0 5'
        }, {
            region: 'west',
            id: 'west-panel',
            title: NAVIGATE_TITLE,
            split: true,
            width: 250,
            minSize: 250,
            maxSize: 250,
            collapsible: true,
            margins: '0 0 0 5',
            layout: 'accordion',
            items: navList
        }, {
            region: 'east',
            title: CONTACT_US_TITLE,
            collapsible: true,
            collapsed: false,
            split: true,
            width: 250,
            minSize: 250,
            maxSize: 250,
            margins: '0 5 0 0',
            layout: 'fit',
            items: new Ext.TabPanel({
                border: false,
                activeTab: 0,
                tabPosition: 'top',
                items: [
                //		        {
                //		            html: '<p>A TabPanel component can be a region.</p>',
                //		            title: COMPANY_SHORTHAND,
                //		            autoScroll: true,
                //		            closable: true
                //		        },

                new Ext.Panel({
                    title: '今日预订',
                    layout: 'anchor',
                    items: [{
                        anchor: 'right 70%',
                        layout: 'fit',
                        items: [CreateCurrentBookingedListGrid()]
                    }, {
                        anchor: 'right 30%',
                        layout: 'fit',
                        items: [new Ext.grid.PropertyGrid({
                            monitorResize: true,
                            title: '用户信息', //COMPANY_SHORTHAND,
                            id: 'PropGrid',
                            closable: false,
                            disabled: false,
                            source: {}
                        })]
                    }]
                })]
            })
        }, tabs]
    });
    RefreshUserInfoPropGrid();
    //setTimeout(RefreshUserInfoPropGrid, 1000);
}