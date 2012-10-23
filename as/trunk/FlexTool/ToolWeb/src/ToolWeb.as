// ActionScript file

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import jsion.GameCoreSetup;
import jsion.JsionCoreSetup;

import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.events.ResizeEvent;
import mx.managers.PopUpManager;

import tool.pngcuter.PNGCuterWindow;
import tool.pngpacker.PNGPackerWindow;
import tool.renamer.FileRenamerWindow;
import tool.unicode.TransfWindow;
import tool.waiting.Waiting;
import tool.xmlformats.XmlFormatWindow;
import tool.zlibcompress.ZlibCompressWindow;

protected var m_configLoader:URLLoader;

protected function application1_preinitializeHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	trace("preinitialize");
}

protected function application1_contentCreationCompleteHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	trace("contentCreationComplete");
}

protected function application1_initializeHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	trace("initialized");
}

protected function application1_resizeHandler(event:ResizeEvent):void
{
	// TODO Auto-generated method stub
	trace("resize");
}


protected function application1_creationCompleteHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	trace("creation");
}

protected function application1_addedToStageHandler(event:Event):void
{
	// TODO Auto-generated method stub
	trace("addedToStage");
}

protected function application1_applicationCompleteHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	trace("applicationComplete");
	
	GameCoreSetup(this.stage);
	
	ToolGlobal.setup(this);
	
	m_configLoader = new URLLoader();
	m_configLoader.addEventListener(Event.COMPLETE, __configLoadCompleteHandler);
	m_configLoader.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
	m_configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
	m_configLoader.load(new URLRequest("config.xml"));
	
	this.stage.addEventListener(Event.RESIZE, __stageResizeHandler);
	
	Waiting.show("正在初始化...");
}

protected function __stageResizeHandler(e:Event):void
{
	//trace("StageResized");
	this.width = this.stage.stageWidth;
	this.height = this.stage.stageHeight;
}

protected function __configLoadCompleteHandler(e:Event):void
{
	//trace("configLoadComplete");
	
	var configXml:XML = new XML(m_configLoader.data);
	
	Config.setup(configXml);
	
	JsionCoreSetup(configXml);
	
	m_configLoader.removeEventListener(Event.COMPLETE, __configLoadCompleteHandler);
	m_configLoader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
	m_configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
	m_configLoader = null;
	
	Waiting.hide();
}

protected function __errorHandler(e:ErrorEvent):void
{
	Waiting.show("初化失败!\r\n" + e.text);
	//Alert.show(e.text, "配置文件加载失败!");
	
	m_configLoader.removeEventListener(Event.COMPLETE, __configLoadCompleteHandler);
	m_configLoader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
	m_configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
	m_configLoader = null;
}






protected function menuBar_itemClickHandler(event:MenuEvent):void
{
	var menuItem:XML = XML(event.item);
	
	switch(String(menuItem.@label))
	{
		case "Unicode字符":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, TransfWindow));
			break;
		case "zlib压缩/解压":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, ZlibCompressWindow));
			break;
		case "XML格式化对齐":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, XmlFormatWindow));
			break;
		case "序列帧图片打包":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, PNGPackerWindow));
			break;
		case "批量重命名":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, FileRenamerWindow));
			break;
		case "批量图片裁剪":
			PopUpManager.centerPopUp(PopUpManager.createPopUp(ToolGlobal.windows, PNGCuterWindow));
			break;
	}
}