<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Install.aspx.cs" Inherits="WebApplication.Install" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>初始化订餐系统</title>
    <link rel="stylesheet" type="text/css" href="/Ext/resources/css/ext-all.css" />
    <!-- GC -->
    <!-- LIBS -->
    <script type="text/javascript" src="/Ext/adapter/ext/ext-base.js"></script>
    <!-- ENDLIBS -->
    <script type="text/javascript" src="/Ext/ext-all.js"></script>
    <script type="text/javascript" src="/Scripts/common-text.js"></script>
    <script type="text/javascript" src="/Scripts/common-int.js"></script>
    <script type="text/javascript" src="/Scripts/utils.js"></script>
    <script type="text/javascript" src="/Scripts/validate-ext.js"></script>
    <script type="text/javascript">
        Ext.onReady(function () {
            Ext.QuickTips.init();
            Ext.BLANK_IMAGE_URL = '/Ext/resources/images/default/s.gif';
            
        <%
            if (IsInstall)
            {
        %>
            ShowMsg(true, '订餐系统已经初始化!');
        <%
            }
            else
            {
        %>
            CreateInstallForm();
        <%
            }
        %>
        });
        
        <%
            if (IsInstall == false)
            {
        %>
            function CreateInstallForm() {
                var items = [];
                items.push({
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
                });
                items.push({
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
                });
                items.push({
                    fieldLabel: RE_PASSWD_LABEL,
                    id: 'RePasswd',
                    name: 'RePasswd',
                    inputType: 'password',
                    vtype: 'password',
                    initialPassField: 'Passwd',
                    allowBlank: false,
                    selectOnFocus: true
                });
                items.push({
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
                });

                var buttons = [{
                    text: SUBMIT_TEXT,
                    handler: function () {
                        SubmitForm('ext-install', 'ext-install-win', true, function (rlt) { location = '/'; });
                    }
                }];

                buttons.unshift({
                    text: '转首页',
                    handler: function () {
                        location = '/';
                    }
                });

                var formpanel = CreateFormPanel('ext-install', 'InstallSys', items, buttons);
                FocusFormItem(formpanel, 'Account');
                CreateWin([formpanel], 'ext-install-win', '初始化', 325, 180, false, true);
            }
        <%
            }
        %>
    </script>
</head>
<body>
</body>
</html>
