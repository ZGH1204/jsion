package jsion.rpg.engine.games
{
	import flash.geom.Point;
	
	import jsion.rpg.engine.renders.Render;

	public class GameObject
	{
		public static const RENDER_LEFT_TOP:int = 1;
		
		public static const RENDER_CENTER:int = 2;
		
		public static const RENDER_BOTTOM_CENTER:int = 3;
		
		public var zOrder:int;
		
		public var render:Render;
		
		public var game:BaseGame;
		
		protected var m_pos:Point;
		
		protected var m_renderPoint:Point;
		
		protected var m_renderType:int;
		
		public function GameObject()
		{
			m_pos = new Point();
			m_renderType = RENDER_LEFT_TOP;
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
	}
}