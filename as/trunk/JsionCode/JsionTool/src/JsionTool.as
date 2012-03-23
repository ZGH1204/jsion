
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import jsion.JsionCoreSetup;
import jsion.tool.MainWindow;
import jsion.tool.ToolGlobal;

import mx.events.FlexEvent;
import mx.events.ResizeEvent;

import org.aswing.AsWingManager;

protected var m_mainWindow:MainWindow;

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
	
	var configXml:XML = new XML(bytes);
	
	JsionCoreSetup(this.stage, configXml);
	
	AsWingManager.initAsStandard(this.stage);
	
	ToolGlobal.setup(this.stage, this, this.width, this.height);
}

private function resizeHandler(event:ResizeEvent):void
{
	ToolGlobal.resize(this.width, this.height);
}