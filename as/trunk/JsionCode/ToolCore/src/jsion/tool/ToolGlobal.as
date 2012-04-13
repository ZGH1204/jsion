package jsion.tool
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	
	import jsion.tool.compresses.CompressPane;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.aswing.AsWingManager;
	import org.aswing.UIManager;
	
	import spark.components.WindowedApplication;

	public class ToolGlobal
	{
		public static var dragDropCompress:IFlexDisplayObject;
		
		public static var xmlFormater:IFlexDisplayObject;
		
		private static var m_dispatcher:EventDispatcher = new EventDispatcher();
		
		private static var m_stage:Stage;
		private static var m_window:MainWindow;
		private static var m_app:WindowedApplication;
		
		private static var m_container:UIComponent;
		
		public static function get window():MainWindow
		{
			return m_window;
		}
		
		public static function get stage():Stage
		{
			return m_stage;
		}
		
		public static function get windowedApp():WindowedApplication
		{
			return m_app;
		}
		
		public static function get container():UIComponent
		{
			return m_container;
		}
		
		public static function setup(stage:Stage, app:WindowedApplication, root:UIComponent, w:int, h:int):void
		{
			if(m_window) return;
			
			m_stage = stage;
			
			m_app = app;
			
			m_container = root;
			
			AsWingManager.initAsStandard(root, true, true);
			UIManager.setLookAndFeel(new ToolLookAndFeel());
			
			m_window = new MainWindow();
			m_window.setSizeWH(w, h);
			m_window.show();
		}
		
		public static function resize(w:int, h:int):void
		{
			if(m_window) m_window.setSizeWH(w, h);
		}
		
		public static function fireNativeDragEnter(event:NativeDragEvent):void
		{
			dispatchEvent(event);
		}
		
		public static function fireNativeDragDrop(event:NativeDragEvent):void
		{
			dispatchEvent(event);
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			m_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			m_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return m_dispatcher.dispatchEvent(event);
		}
		
		public static function hasEventListener(type:String):Boolean
		{
			return m_dispatcher.hasEventListener(type);
		}
		
		public static function willTrigger(type:String):Boolean
		{
			return m_dispatcher.willTrigger(type);
		}
	}
}