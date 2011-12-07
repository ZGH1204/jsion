
import flash.system.Capabilities;

import jsion.tool.MainWindow;
import jsion.tool.ToolGlobal;

import mx.events.FlexEvent;
import mx.events.ResizeEvent;

protected var m_mainWindow:MainWindow;

private function init(e:FlexEvent):void
{
	this.statusBar.visible = false;
	
	this.nativeWindow.x = (Capabilities.screenResolutionX - this.nativeWindow.width) / 2;
	this.nativeWindow.y = (Capabilities.screenResolutionY - this.nativeWindow.height) / 2;
	
	ToolGlobal.setup(this.stage);
}

private function resizeHandler(event:ResizeEvent):void
{
	ToolGlobal.resize(this.width, this.height);
}