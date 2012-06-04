package jsion.tool.mapeditor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.IDispose;
	
	public class MapDragger extends Sprite implements IDispose
	{
		private var m_mapShower:MapShower;
		
		private var m_tempPoint:Point;
		
		private var m_startPoint:Point;
		
		private var m_startGlobalPoint:Point;
		
		public function MapDragger(mapShower:MapShower)
		{
			m_mapShower = mapShower;
			
			m_tempPoint = new Point();
			
			m_startPoint = new Point();
			
			m_startGlobalPoint = new Point();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			m_startPoint.x = m_mapShower.game.centerPoint.x;
			m_startPoint.y = m_mapShower.game.centerPoint.y;
			m_startGlobalPoint.x = stage.mouseX;
			m_startGlobalPoint.y = stage.mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, __mouseLeaveHandler);
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			m_tempPoint.x = m_startPoint.x - (stage.mouseX - m_startGlobalPoint.x);
			m_tempPoint.y = m_startPoint.y - (stage.mouseY - m_startGlobalPoint.y);
			
			m_mapShower.game.centerPoint = m_tempPoint;
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, __mouseLeaveHandler);
		}
		
		private function __mouseLeaveHandler(e:MouseEvent):void
		{
			__mouseUpHandler(null);
		}
		
		public function drawRect(w:int, h:int):void
		{
			graphics.clear();
			graphics.beginFill(0x0, 0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
		public function dispose():void
		{
		}
	}
}