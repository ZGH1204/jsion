// ActionScript file

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import jsion.GameCoreSetup;
import jsion.JsionCoreSetup;

import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;

import tool.compress.CompressPane;
import tool.pngpacker.PNGPackerPane;
import tool.unicode.TransfPane;
import tool.xmlformats.XmlFormatPane;

protected function __applicationCompleteHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	
	this.title = "开发工具集合";
	
	this.nativeWindow.x = (Capabilities.screenResolutionX - this.nativeWindow.width) / 2;
	this.nativeWindow.y = (Capabilities.screenResolutionY - this.nativeWindow.height) / 2;
	
	var bytes:ByteArray = new ByteArray();
	
	var file:File = new File(File.applicationDirectory.resolvePath("config.xml").nativePath);
	
	var fs:FileStream = new FileStream();
	fs.open(file, FileMode.READ);
	fs.readBytes(bytes);
	fs.close();
	
	var configXml:XML = new XML(bytes);
	
	Config.setup(configXml);
	
	JsionCoreSetup(configXml);
	
	GameCoreSetup(this.stage);
	
	ToolGlobal.setup(this);
	
	//初始化调试控制台
//	DEBUG.setup(stage, 250);
//	var cssPath:String = PathUtil.combinPath(Config.ResRoot, Config.DebugCSS);
//	DEBUG.loadCSS(cssPath);
//	DEBUG.showBar(DEBUG.TOP);
}



protected function menuBar_itemClickHandler(event:MenuEvent):void
{
	// TODO Auto-generated method stub
	
	var menuItem:XML = XML(event.item);
	
	switch(String(menuItem.@label))
	{
		case "Unicode字符":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, TransfPane));
			break;
		case "zlib压缩/解压":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, CompressPane));
			break;
		case "XML格式化对齐":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, XmlFormatPane));
			break;
		case "新建压缩包":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, PNGPackerPane));
			break;
	}
}








