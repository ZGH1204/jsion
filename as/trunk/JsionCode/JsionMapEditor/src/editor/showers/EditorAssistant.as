package editor.showers
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.games.BaseMap;
	import jsion.rpg.engine.games.WorldMap;
	
	public class EditorAssistant extends Sprite
	{
		protected var shower:MapShower;
		
		protected var map:BaseMap;
		
		protected var tileShower:TileShower;
		
		protected var wayTileShower:AlphaShower;
		
		protected var wayTileEditing:Boolean;
		
		protected var wayTileSprite:Sprite;
		
		
		protected var draging:Boolean;
		protected var dragHelper:Sprite;
		
		protected var dragStartPoint:Point;
		
		public function EditorAssistant(shower:MapShower)
		{
			super();
			
			this.shower = shower;
			
			map = shower.game.worldMap;
			
			initialize();
			
			initEvents();
		}
		
		private function initialize():void
		{
			buttonMode = true;
			
			dragHelper = new Sprite();
			dragHelper.graphics.clear();
			dragHelper.graphics.beginFill(0, 0);
			dragHelper.graphics.drawRect(0, 0, 10, 10);
			dragHelper.graphics.endFill();
			addChild(dragHelper);
			
			tileShower = new TileShower(shower);
			addChild(tileShower.tileGrid);
			
			wayTileShower = new AlphaShower(shower);
			addChild(wayTileShower.tileGrid);
			
			wayTileSprite = new Sprite();
			wayTileSprite.mouseEnabled = false;
			wayTileSprite.mouseChildren = false;
			addChild(wayTileSprite);
			
			updateRect();
			updateTileGrid();
		}
		
		public function updateRect():void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, shower.gameWidth, shower.gameHeight);
			graphics.endFill();
			scrollRect = new Rectangle(0, 0, shower.gameWidth, shower.gameHeight);
			
			dragHelper.x = scrollRect.width / 2;
			dragHelper.y = scrollRect.height / 2;
		}
		
		public function setTileGridVisible(value:Boolean):void
		{
			tileShower.setVisible(value);
			
			updateTileGrid();
		}
		
		public function setWayTileGridVisible(value:Boolean):void
		{
			wayTileShower.setVisible(value);
			
			updateWayTileGrid();
		}
		
		public function setWayTileGridEditable(value:Boolean):void
		{
			if(value && wayTileEditing == false)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownEditHandler);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownEditHandler);
			}
			
			wayTileEditing = value;
		}
		
		public function updateTileGrid():void
		{
			tileShower.update();
		}
		
		public function updateWayTileGrid():void
		{
			wayTileShower.update();
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		}
		
		private var mouseDownTileX:int = -1;
		private var mouseDownTileY:int = -1;
		
		private var mouseDownStartX:Number = 0;
		private var mouseDownStartY:Number = 0;
		
		private function __mouseDownEditHandler(e:MouseEvent):void
		{
			if(wayTileEditing == false) return;
			
			mouseDownStartX = e.localX;
			mouseDownStartY = e.localY;
			
			var point:Point = map.screenToWayTile(e.localX, e.localY);
			
			mouseDownTileX = point.x;
			mouseDownTileY = point.y;
			
			addEventListener(MouseEvent.MOUSE_UP, __mouseUpEditHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveEditHandler);
			addEventListener(MouseEvent.MOUSE_OUT, __mouseOutEditHandler);
		}
		
		private function __mouseUpEditHandler(e:MouseEvent):void
		{
			if(wayTileEditing == false) return;
			
			wayTileSprite.graphics.clear();
			
			removeEventListener(MouseEvent.MOUSE_UP, __mouseUpEditHandler);
			removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveEditHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, __mouseOutEditHandler);
			
			var point:Point = map.screenToWayTile(e.localX, e.localY);
			
			wayTileShower.setTilesCross(mouseDownTileX, mouseDownTileY, point.x, point.y);
			
			mouseDownTileX = mouseDownTileY = -1;
		}
		
		private function __mouseMoveEditHandler(e:MouseEvent):void
		{
			wayTileSprite.graphics.clear();
			wayTileSprite.graphics.lineStyle(1, 0xCCCCCC);
			wayTileSprite.graphics.beginFill(0x336699, 0.5);
			wayTileSprite.graphics.drawRect(mouseDownStartX, mouseDownStartY, e.localX - mouseDownStartX, e.localY - mouseDownStartY);
			wayTileSprite.graphics.endFill();
		}
		
		private function __mouseOutEditHandler(e:MouseEvent):void
		{
			wayTileSprite.graphics.clear();
			
			removeEventListener(MouseEvent.MOUSE_UP, __mouseUpEditHandler);
			removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveEditHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, __mouseOutEditHandler);
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			if(draging || wayTileEditing) return;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			dragStartPoint = map.center.clone();
			
			draging = true;
			dragHelper.startDrag();
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			if(draging == false) return;
			
			draging = false;
			dragHelper.stopDrag();
			
			__mouseMoveHandler(null);
			
			dragHelper.x = scrollRect.width / 2;
			dragHelper.y = scrollRect.height / 2;
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			var temp:Point = new Point();
			
			temp.x = dragStartPoint.x - (dragHelper.x - scrollRect.width / 2);
			temp.y = dragStartPoint.y - (dragHelper.y - scrollRect.height / 2);
			
			map.center = temp;
		}
	}
}