
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import jsion.GameCoreSetup;
import jsion.JsionCoreSetup;
import jsion.tool.MainWindow;
import jsion.tool.ToolGlobal;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;

protected var m_mainWindow:MainWindow;

protected var m_container:UIComponent;

private function init(e:FlexEvent):void
{
	this.statusBar.visible = false;
	
	this.nativeWindow.x = (Capabilities.screenResolutionX - this.nativeWindow.width) / 2;
	this.nativeWindow.y = (Capabilities.screenResolutionY - this.nativeWindow.height) / 2;
	
	var bytes:ByteArray = new ByteArray();
	
	var file:File = new File(File.applicationDirectory.resolvePath("config.xml").nativePath);
	
	var fs:FileStream = new FileStream();
	fs.open(file, FileMode.READ);
	fs.readBytes(bytes);
	fs.close();
	
	m_container = new UIComponent();
	
	this.addElement(m_container);
	
	var configXml:XML = new XML(bytes);
	
	JsionCoreSetup(configXml);
	
	GameCoreSetup(this.stage);
	
	ToolGlobal.setup(this.stage, this, m_container, this.width, this.height);
	
	//writeMapInfo();
}

private function writeMapInfo():void
{
	var bytes:ByteArray = new ByteArray();
	
	bytes.writeInt(1);
	bytes.writeUTF("测试地图");
	bytes.writeInt(2700);
	bytes.writeInt(1800);
	bytes.writeInt(100);
	bytes.writeInt(100);
	bytes.writeInt(1);
	bytes.writeInt(200);
	bytes.writeUTF(".jpg");
	bytes.compress();
	
	var file:File = File.desktopDirectory.resolvePath("1.map");
	var fs:FileStream = new FileStream();
	fs.open(file, FileMode.WRITE);
	fs.writeBytes(bytes);
	fs.close();
}

private function resizeHandler(event:ResizeEvent):void
{
	ToolGlobal.resize(this.width, this.height);
}