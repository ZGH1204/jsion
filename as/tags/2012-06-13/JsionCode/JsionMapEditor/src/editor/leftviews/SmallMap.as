package editor.leftviews
{
	import editor.aswings.PreviewBackground;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.IDispose;
	import jsion.core.loaders.ImageLoader;
	import jsion.utils.DisposeUtil;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	
	public class SmallMap extends JPanel implements IDispose
	{
		public static const Padding:int = 2;
		
		protected var m_bmp:Bitmap;
		protected var m_bmd:BitmapData;
		protected var m_mapEditor:JsionMapEditor;
		
		protected var m_areaContainer:Sprite;
		protected var m_displayArea:Sprite;
		
		protected var m_areaWidth:int;
		protected var m_areaHeight:int;
		
		public function SmallMap(mapEditor:JsionMapEditor, layout:LayoutManager=null)
		{
			m_mapEditor = mapEditor;
			
			super(layout);
			
			initialize();
		}
		
		protected function initialize():void
		{
			m_areaContainer = new Sprite();
			
			addChild(m_areaContainer);
			
			m_bmp = new Bitmap();
			
			setBackgroundDecorator(new PreviewBackground(m_bmp, m_areaContainer));
			
			m_displayArea = new Sprite();
			m_displayArea.buttonMode = true;
			m_areaContainer.addChild(m_displayArea);
			
			loadSmallMap();
			
			setBorder(new TitledBorder(null, "", TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			//setPreferredHeight(JsionEditor.mapConfig.MapHeight * (JsionEditor.mapConfig.SmallMapWidth / JsionEditor.mapConfig.MapWidth) + getInsets().top + getInsets().bottom + Padding);
		}
		
		private var m_draging:Boolean;
		private var m_tempRect:Rectangle = new Rectangle();
		private var m_limitRect:Rectangle;
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			m_tempRect.x = m_displayArea.x;
			m_tempRect.y = m_displayArea.y;
			m_tempRect.width = m_displayArea.width;
			m_tempRect.height = m_displayArea.height;
			
			if(m_tempRect.contains(e.localX + m_displayArea.x, e.localY + m_displayArea.y))
			{
				m_draging = true;
				m_limitRect = new Rectangle(0, 0, m_bmd.width - m_tempRect.width, m_bmd.height - m_tempRect.height);
				m_displayArea.startDrag(false, m_limitRect);
			}
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			if(m_draging)
			{
				m_draging = false;
				m_displayArea.stopDrag();
			}
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			if(m_draging && e.type == MouseEvent.MOUSE_MOVE)
			{
				var point:Point = new Point(m_displayArea.x + m_displayArea.width / 2, m_displayArea.y + m_displayArea.height / 2);
				
				var scale:Number = JsionEditor.mapConfig.MapWidth / m_bmd.width;
				point.x = scale * point.x;
				point.y = scale * point.y;
				
				m_mapEditor.gameMap.game.worldMap.center = point;
			}
		}
		
		public function updateDisplayRect($x:int, $y:int):void
		{
			if(m_bmd == null) return;
			
			var scale:Number = m_bmd.width / JsionEditor.mapConfig.MapWidth;
			
			var rltX:Number = $x * scale;
			var rltY:Number = $y * scale;
			
			m_displayArea.x = rltX - m_displayArea.width / 2;
			m_displayArea.y = rltY - m_displayArea.height / 2;
		}
		
		public function redrawDisplayArea():void
		{
			if(m_bmd == null) return;
			
			m_areaWidth = m_mapEditor.gameMap.gameWidth / JsionEditor.mapConfig.MapWidth * m_bmd.width;
			m_areaHeight = m_mapEditor.gameMap.gameHeight / JsionEditor.mapConfig.MapHeight * m_bmd.height;
			
			m_areaWidth = Math.min(m_areaWidth, m_bmd.width);
			m_areaHeight = Math.min(m_areaHeight, m_bmd.height);
			
			m_displayArea.graphics.clear();
			m_displayArea.graphics.lineStyle(1,0xFFFFFF);
			m_displayArea.graphics.beginFill(0, 0);
			m_displayArea.graphics.drawRect(0, 0, m_areaWidth, m_areaHeight);
			m_displayArea.graphics.endFill();
		}
		
		public function loadSmallMap():void
		{
			var smallPic:String = JsionEditor.getSmallMapPicPath();
			
			new ImageLoader(smallPic).loadAsync(smallMapLoadCallback);
		}
		
		protected function smallMapLoadCallback(loader:ImageLoader):void
		{
			if(loader.isComplete == false)
			{
				m_mapEditor.msg("缩略图加载失败");
				DisposeUtil.free(loader);
				return;
			}
			
			if(m_bmd) m_bmd.dispose();
			
			m_bmd = Bitmap(loader.content).bitmapData.clone();
			
			m_bmp.bitmapData = m_bmd;
			
			DisposeUtil.free(loader);
			
			redrawDisplayArea();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			m_mapEditor.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		public function dispose():void
		{
			
		}
	}
}