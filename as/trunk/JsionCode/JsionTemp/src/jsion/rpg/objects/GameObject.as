package jsion.rpg.objects
{
	import flash.geom.Point;
	
	import jsion.rpg.RenderTypes;
	import jsion.rpg.renders.Render2D;

	public class GameObject
	{
		protected var m_pos:Point;
		
		protected var m_renderType:int;
		
		protected var m_render:Render2D;
		
		public function GameObject()
		{
			m_pos = new Point();
			m_renderType = RenderTypes.LEFT_TOP;
		}
		
		public function setPos(posX:int, posY:int):void
		{
			m_pos.x = posX;
			m_pos.y = posY;
		}
		
		public function setRender(r:Render2D):void
		{
			if(m_render) m_render.clearMe(this);
			
			m_render = r;
		}
		
		public function get x():Number
		{
			return m_pos.x;
		}
		
		public function get y():Number
		{
			return m_pos.y;
		}
		
		public function get renderType():int
		{
			return m_renderType;
		}
		
		
		
		
		
		public function clearMe():void
		{
			m_render.clearMe(this);
		}
		
		public function renderMe():void
		{
			m_render.renderMe(this);
		}
	}
}