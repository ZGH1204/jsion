package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class CursorMgr
	{
		public static var m_stage:Stage;
		
		public static var m_enabled:Boolean;
		
		private static var m_normalCursor:DisplayObject;
		
		private static var m_overCursor:DisplayObject;
		
		private static var m_currentCursor:DisplayObject;
		
		public function CursorMgr()
		{
		}
		
		public static function setup(stage:Stage):void
		{
			if(m_stage) return;
			
			m_stage = stage;
		}
		
		public static function setNormalCursor(cursor:DisplayObject):void
		{
			m_normalCursor = cursor;
		}
		
		public static function setOverCursor(cursor:DisplayObject):void
		{
			m_overCursor = cursor;
		}
		
		public static function enabled():void
		{
			if(m_normalCursor == null)
			{
				throw new Error("请先使用 setNormalCursor(DisplayObject) 方法设置鼠标光标显示对象。");
				return;
			}
			
			if(m_stage == null)
			{
				throw new Error("请先使用 setup(Stage) 方法设置舞台对象。");
				return;
			}
			
			if(m_enabled == false)
			{
				m_enabled = true;
				
				normal();
				
				Mouse.hide();
				
				m_stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
				m_stage.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
				m_stage.addEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
				m_stage.addEventListener(Event.ACTIVATE, __activateHandler);
				m_stage.addEventListener(Event.DEACTIVATE, __deactivateHandler);
			}
		}
		
		private static function __mouseMoveHandler(e:MouseEvent):void
		{
			m_currentCursor.x = m_stage.mouseX;
			m_currentCursor.y = m_stage.mouseY;
		}
		
		private static function __mouseOverHandler(e:MouseEvent):void
		{
			m_currentCursor.visible = true;
		}
		
		private static function __mouseOutHandler(e:MouseEvent):void
		{
			m_currentCursor.visible = false;
		}
		
		private static function __activateHandler(e:Event):void
		{
			m_currentCursor.visible = false;
			__mouseMoveHandler(null);
		}
		
		private static function __deactivateHandler(e:Event):void
		{
			m_currentCursor.visible = false;
		}
		
		public static function disabled():void
		{
			if(m_enabled)
			{
				m_enabled = false;
				if(m_normalCursor && m_normalCursor.parent) m_normalCursor.parent.removeChild(m_normalCursor);
				if(m_overCursor && m_overCursor.parent) m_overCursor.parent.removeChild(m_overCursor);
				Mouse.show();
				m_stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
				m_stage.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
				m_stage.removeEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
				m_stage.removeEventListener(Event.ACTIVATE, __activateHandler);
				m_stage.removeEventListener(Event.DEACTIVATE, __deactivateHandler);
			}
		}
		
		public static function normal():void
		{
			setCursor(m_normalCursor);
		}
		
		public static function over():void
		{
			setCursor(m_overCursor);
		}
		
		private static function setCursor(cursor:DisplayObject):void
		{
			if(cursor == null || m_currentCursor == cursor) return;
			
			if(m_currentCursor && m_currentCursor.parent)
			{
				m_currentCursor.parent.removeChild(m_currentCursor);
			}
			
			cursor.visible = true;
			m_currentCursor = cursor;
			m_stage.addChild(cursor);
			__mouseMoveHandler(null);
		}
	}
}