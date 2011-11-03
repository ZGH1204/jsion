package jsion.rpg.engine.gameobjects
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.games.BaseGame;
	import jsion.rpg.engine.graphics.GraphicResource;
	import jsion.rpg.engine.renders.Render;

	/**
	 * 一切游戏对象的基类
	 * @author Jsion
	 * 
	 */	
	public class GameObject implements IDispose
	{
		public static const RENDER_LEFT_TOP:int = 1;
		
		public static const RENDER_CENTER:int = 2;
		
		public static const RENDER_BOTTOM_CENTER:int = 3;
		
		/**
		 * 游戏对象名称
		 */		
		public var name:String;
		
		/**
		 * 游戏数据引用
		 */		
		public var game:BaseGame;
		
		/**
		 * Y轴排序
		 */		
		public var zorder:int;
		
		/**
		 * 渲染器
		 */		
		public var render:Render;
		
		/**
		 * 图形资源
		 */		
		protected var m_graphicResource:GraphicResource;
		
		/**
		 * 游戏世界坐标
		 */		
		protected var m_pos:Point;
		
		/**
		 * 屏幕渲染坐标(动态不断变化的)
		 */		
		protected var m_renderPoint:Point;
		
		/**
		 * 标识渲染坐标相对于图形、动画的位置
		 */		
		protected var m_renderType:int;
		
		/**
		 * 浮动排序
		 */		
		protected var m_zOrderFloat:int;
		
		/**
		 * 方向
		 */		
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
			if(render == null) return;
			
			render.renderClear(this);
		}
		
		public function renderMe():void
		{
			//TODO:计算判断是否完全超出屏幕
			if(render == null || isOutScreen) return;
			
			render.render(this);
		}
		
		/**
		 * 设置世界坐标(获取世界坐标请直接使用x、y属性)
		 */		
		public function setPos(x:int, y:int):void
		{
			m_pos.x = x;
			m_pos.y = y;
			zorder = y;
		}
		
		/**
		 * 浮动排序值
		 */		
		public function get zOrderFloat():int
		{
			return m_zOrderFloat;
		}
		
		public function set zOrderFloat(value:int):void
		{
			m_zOrderFloat = value;
		}
		
		/**
		 * 排序字段
		 */		
		public function get zOrder():int
		{
			return zorder + m_zOrderFloat;
		}
		
		/**
		 * 世界坐标(要改变坐标请使用setPos方法)
		 */		
		public function get x():int
		{
			return m_pos.x;
		}
		
		/**
		 * 世界坐标(要改变坐标请使用setPos方法)
		 */		
		public function get y():int
		{
			return m_pos.y;
		}
		
		public function get screenPos():Point
		{
			return game.worldMap.worldToScreen(x, y);
		}
		
		/**
		 * 屏幕渲染坐标
		 */		
		public function get renderPoint():Point
		{
			return m_renderPoint;
		}
		
		/**
		 * 标识渲染坐标相对于图形、动画的位置
		 */		
		public function get renderType():int
		{
			return m_renderType;
		}
		
		/**
		 * 方向
		 */		
		public function get direction():int
		{
			return m_direction;
		}
		
		public function set direction(value:int):void
		{
			m_direction = value;
		}
		
		/**
		 * 图形资源
		 */		
		public function get graphicResource():GraphicResource
		{
			return m_graphicResource;
		}
		
		public function set graphicResource(value:GraphicResource):void
		{
			m_graphicResource = value;
		}
		
		public function get renderRect():Rectangle
		{
			m_tempRect.x = 0;
			m_tempRect.y = 0;
			
			m_tempRect.width = m_graphicResource.frameWidth;
			m_tempRect.height = m_graphicResource.frameHeight;
			
			return m_tempRect;
		}
		
		public function get isOutScreen():Boolean
		{
			var tmp:Point = game.worldMap.worldToScreen(x, y);
			
			if(tmp.x < 0 || tmp.y < 0 ||
				tmp.x > game.gameWidth ||
				tmp.y > game.gameHeight) return true;
			
			return false;
		}
		
		public function dispose():void
		{
			
		}
	}
}