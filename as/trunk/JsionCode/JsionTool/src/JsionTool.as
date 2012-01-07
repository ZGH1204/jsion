
import flash.display.Bitmap;
import flash.display.BitmapData;
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
import jsion.core.serialize.res.ResPacker;
import jsion.core.serialize.res.ResUnpacker;
import jsion.tool.MainWindow;
import jsion.tool.ToolGlobal;

import mx.events.FlexEvent;
import mx.events.ResizeEvent;
import mx.states.AddChild;

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
	
	ToolGlobal.setup(this.stage, this.width, this.height);
	
	//packPng();
	//unpackPng();
}

private var m_unpacker:ResUnpacker;

private function unpackPng():void
{
	var f:File = new File(File.applicationDirectory.resolvePath("test.hy").nativePath);
	
	var fs:FileStream = new FileStream();
	
	var bytes:ByteArray = new ByteArray();
	
	fs.open(f, FileMode.READ);
	fs.readBytes(bytes);
	fs.close();
	
	m_unpacker = new ResUnpacker(bytes);
	
	var bmd:BitmapData = m_unpacker.getBitmapData(1, 1, 0);
	
	this.image1.addChild(new Bitmap(bmd));
	
	
	
	
	var files:File = new File(File.applicationDirectory.resolvePath("1.png").nativePath);
	var bytess:ByteArray = new ByteArray();
	var fss:FileStream = new FileStream();
	fss.open(files, FileMode.READ);
	fss.readBytes(bytess);
	fss.close();
	
	m_loader = new Loader();
	m_loader.loadBytes(bytess);
	this.image2.addChild(m_loader);
}

private var m_packer:ResPacker;
private var m_loader:Loader;

private function packPng():void
{
	m_packer = new ResPacker();
	
	var files:File = new File(File.applicationDirectory.resolvePath("1.png").nativePath);
	var bytess:ByteArray = new ByteArray();
	var fss:FileStream = new FileStream();
	fss.open(files, FileMode.READ);
	fss.readBytes(bytess);
	fss.close();
	
	m_loader = new Loader();
	m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler);
	m_loader.loadBytes(bytess);
}

private function __completeHandler(e:Event):void
{
	var bmd:BitmapData = Bitmap(m_loader.content).bitmapData.clone();
	
	m_packer.addImage(bmd, 1, 1);
	
	var bytes:ByteArray = m_packer.pack();
	
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