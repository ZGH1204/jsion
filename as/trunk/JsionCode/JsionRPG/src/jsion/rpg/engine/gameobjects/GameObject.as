package jsion.rpg.engine.gameobjects
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.games.BaseGame;
	import jsion.rpg.engine.renders.Render;

	public class GameObject implements IDispose
	{
		public static const RENDER_LEFT_TOP:int = 1;
		
		public static const RENDER_CENTER:int = 2;
		
		public static const RENDER_BOTTOM_CENTER:int = 3;
		
		public var game:BaseGame;
		
		public var zorder:int;
		
		public var render:Render;
		
		protected var m_graphics:GraphicResources;
		
		protected var m_pos:Point;
		
		protected var m_renderPoint:Point;
		
		protected var m_renderType:int;
		
		protected var m_zOrderFloat:int;
		
		
		protected var m_direction:int;
		
		protected var m_tempRect:Rectangle;
		
		public function GameObject()
		{
			m_pos = new Point();
			m_renderPoint = new Point();
			m_renderType = RENDER_LEFT_TOP;
			
			m_tempRect = new Rectangle();
		}
		
		public function clearMe():void
		{
			if(render != null)
			{
				render.renderClear(this);
			}
		}
		
		public function renderMe():void
		{
			//TODO:计算判断是否完全超出屏幕
			if(render != null)
			{
				render.renderClear(this);
			}
		}
		
		public function setPos(x:int, y:int):void
		{
			m_pos.x = x;
			m_pos.y = y;
			zorder = y;
		}
		
		public function get zOrderFloat():int
		{
			return m_zOrderFloat;
		}
		
		public function set zOrderFloat(value:int):void
		{
			m_zOrderFloat = value;
		}
		
		public function get zOrder():int
		{
			return zorder + m_zOrderFloat;
		}
		
		public function get graphics():GraphicResources
		{
			return m_graphics;
		}
		
		public function set graphics(value:GraphicResources):void
		{
			m_graphics = value;
		}
		
		public function get pos():Point
		{
			return m_pos;
		}
		
		public function get renderPoint():Point
		{
			return m_renderPoint;
		}
		
		public function get renderType():int
		{
			return m_renderType;
		}
		
		public function get direction():int
		{
			return m_direction;
		}
		
		public function set direction(value:int):void
		{
			m_direction = value;
		}
		
		public function get renderRect():Rectangle
		{
			m_tempRect.x = 0;
			m_tempRect.y = 0;
			m_tempRect.width = m_graphics.frameWidth;
			m_tempRect.height = m_graphics.frameHeight;
			
			return m_tempRect;
		}
		
		public function dispose():void
		{
			
		}
	}
}