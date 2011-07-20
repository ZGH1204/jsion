<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication.Default" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>


    <style type="text/css">
    .x-panel-header-text{
        font-size: 12px;
    }
    .details p
    {
        height: 25px;
    }
    </style>
    <link rel="stylesheet" type="text/css" href="/Ext/resources/css/ext-all.css" />
    <!-- GC -->
    <!-- LIBS -->
    <script type="text/javascript" src="/Ext/adapter/ext/ext-base.js"></script>
    <!-- ENDLIBS -->
    <script type="text/javascript" src="/Ext/ext-all.js"></script>


    <script type="text/javascript">
    <%
        if (Sjs.Common.PageUtils.IsLogined)
        {
    %>
        var isLogin = true;
    <%
        if (SJSCAN.Entity.User.IsAdministrator(Sjs.Common.PageUtils.Utype))
        {
    %>
        var isAdmin = true;
    <%
        }
        else
        {
    %>
        var isAdmin = false;
    <%
        }
        }
        else
        {
    %>
        var isLogin = false;
        var isAdmin = false;
    <%
        }
    %>
    </script>
    <link rel="Stylesheet" type="text/css" href="/Styles/AccountMain.css" />
    
    <script type="text/javascript" src="/Scripts/common-text.js"></script>
    <script type="text/javascript" src="/Scripts/common-int.js"></script>
    <script type="text/javascript" src="/Scripts/utils.js"></script>
    <script type="text/javascript" src="/Scripts/validate-ext.js"></script>

    <script type="text/javascript" src="/Scripts/default.js"></script>


    <script type="text/javascript" src="/Scripts/sys.js"></script>


    <script type="text/javascript">
        function Reload() {
            location.reload();
        }
        Ext.onReady(function () {
            Ext.QuickTips.init();
            Ext.BLANK_IMAGE_URL = '/Ext/resources/images/default/s.gif';
            if (document.all && document.getElementById) {
                document.title = "点餐系统 - " + COMPANY;
            }

            var globarbtns = [];

            if (isLogin){
                globarbtns.push({
                    text: RELOGIN_LABEL,
                    handler: function () { CreateLoginForm(true); }
                });

                globarbtns.push('-');

                globarbtns.push({
                    text: '注销登陆',
                    handler: function() {
                        ExtAjaxRequest('Logout', {}, Reload, Reload);
                    }
                });
            }

            CreateMainView(globarbtns);

    <%
        if (IsLogined == false)
        {
    %>
            CreateLoginForm(false);
    <%
        }
    %>
        });
    </script>


</head>
<body>
    <div id="authersummary" class="x-hide-display">
        <!--<p style="text-align: center; padding-top: 10px; padding-bottom: 15px;"><b>XX有限公司</b></p>-->
        <%--<p style="text-align: center; font-size: 14px;">本管理后台采用先进的ExtJs组件进行编写,以更简洁美观、方便易用性为主要特点,使您在维护管理企业网站时更快、更好、更准确!</p>
        <p style="text-align: center; font-size: 14px;">显示网站信息(语言版本,信息数等)</p>--%>
    </div>
    <div id="southcopyright" class="x-hide-display">
        <script type="text/javascript">      document.write(COPYRIGHT);</script>
    </div>
</body>
</html>
