
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import jsion.JsionCoreSetup;
import jsion.StageRef;
import jsion.core.compress.PNGCompress;
import jsion.core.compress.PNGData;
import jsion.core.compress.PNGUncompress;
import jsion.tool.MainWindow;
import jsion.tool.ToolGlobal;

import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.states.AddChild;

import org.aswing.AsWingManager;

protected var m_mainWindow:MainWindow;

private var m_compress:PNGCompress;
private var m_loader:Loader;

private var m_uncompress:PNGUncompress;

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
	
	//ToolGlobal.setup(this.stage, this.width, this.height);
	
//	m_compress = new PNGCompress();
//	
	var files:File = new File(File.applicationDirectory.resolvePath("1.png").nativePath);
	var bytess:ByteArray = new ByteArray();
	var fss:FileStream = new FileStream();
	fss.open(files, FileMode.READ);
	fss.readBytes(bytess);
	fss.close();
	
	m_loader = new Loader();
	m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler);
	m_loader.loadBytes(bytess);
	//AddChild(m_loader);
	
	
	var filess:File = new File(File.applicationDirectory.resolvePath("test.hy").nativePath);
	var bytesss:ByteArray = new ByteArray();
	var fsss:FileStream = new FileStream();
	fsss.open(filess, FileMode.READ);
	fsss.readBytes(bytesss);
	fsss.close();
	
	m_uncompress = new PNGUncompress(bytesss);
	
	image1.addChild(new Bitmap(m_uncompress.getBmd(1, 0, 0)));
}

private function __completeHandler(e:Event):void
{
	var data:PNGData = new PNGData();
	
	data.bitmapData = Bitmap(m_loader.content).bitmapData.clone();
	data.action = 1;
	
	this.image2.addChild(new Bitmap(data.bitmapData));
	
	return;
	
	m_compress.addPNG(data);
	
	var bytes:ByteArray = m_compress.compress();
	
	var f:File = new File(File.applicationDirectory.resolvePath("test.hy").nativePath);
	
	if(f.exists) f.deleteFile();
	
	var fs:FileStream = new FileStream();
	
	fs.open(f, FileMode.WRITE);
	fs.writeBytes(bytes);
	fs.close();
}

private function resizeHandler(event:ResizeEvent):void
{
	ToolGlobal.resize(this.width, this.height);
}