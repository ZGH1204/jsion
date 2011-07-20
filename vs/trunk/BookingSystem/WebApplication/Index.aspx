<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebApplication.Index" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title></title>

    <!-- Ext includes -->
    <link rel="stylesheet" type="text/css" href="Ext4/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="Styles/desktop.css" />
    <script type="text/javascript" src="Ext4/ext-all.js" />
    <script type="text/javascript" src="Ext4/builds/ext-core.js"></script>
    <!-- End Ext includes -->


    <script type="text/javascript">
        var windowIndex = 0;
        Ext.Loader.setConfig('enabled', true);

        Ext.Loader.setPath({
            'Ext.ux.booking': 'Scripts4/booking',
            'Ext.ux.desktop': 'Scripts4/desktop',
            'MyDesktop': 'Scripts4'
        });

        Ext.require('MyDesktop.App');

        var myDesktopApp;
        Ext.onReady(function () {
            myDesktopApp = new MyDesktop.App();
        });
    </script>

</head>
<body>
<a href="http://www.sencha.com" target="_blank" alt="Powered by Ext JS"
       id="poweredby"><div></div></a>
</body>
</html>
