package jsion.rpg.engine.objects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.IDispose;
	import jsion.rpg.engine.RPGGame;
	import jsion.rpg.engine.renders.Render2D;
	
	public class RPGObject implements IDispose
	{
		/**
		 * 游戏对象
		 */		
		public var game:RPGGame;
		
		/**
		 * 渲染器
		 */		
		public var render:Render2D;
		
		/**
		 * 游戏世界坐标
		 */		
		protected var m_pos:Point;
		
		/**
		 * 宽度 设置bitmapData时更新为图片宽度
		 */		
		protected var m_width:int;
		
		/**
		 * 高度 设置bitmapData时更新为图片高度
		 */		
		protected var m_height:int;
		
		/**
		 * 上一次渲染宽度 设置bitmapData时更新为width的值
		 */		
		protected var m_lastRenderWidth:int;
		
		/**
		 * 上一次渲染高度 设置bitmapData时更新为height的值
		 */		
		protected var m_lastRenderHeight:int;
		
		/**
		 * 上一次屏幕渲染坐标(动态不断变化的)
		 */		
		protected var m_lastRenderPoint:Point;
		
		/**
		 * 浮动排序值
		 */		
		protected var m_zIndex:int;
		
		/**
		 * 临时范围
		 */		
		protected var m_tempRect:Rectangle;
		
		
		/**
		 * 要显示的对象
		 */		
		private var m_bitmapData:BitmapData;
		
		public function RPGObject()
		{
			m_pos = new Point();
			
			m_lastRenderPoint = new Point();
			
			m_tempRect = new Rectangle();
		}
		
		/**
		 * 游戏世界x坐标
		 */		
		public function get x():int
		{
			return m_pos.x;
		}
		
		/**
		 * 游戏世界y坐标
		 */		
		public function get y():int
		{
			return m_pos.y;
		}
		
		/**
		 * 获取或设置显示图片数据
		 */		
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}
		
		/** @private */
		public function set bitmapData(value:BitmapData):void
		{
			m_bitmapData = value;
			
			if(m_bitmapData)
			{
				m_lastRenderWidth = m_width;
				m_lastRenderHeight = m_height;
				m_width = m_bitmapData.width;
				m_height = m_bitmapData.height;
			}
		}
		
		/**
		 * 获取显示bitmapData的范围 默认为整张bitmapData数据
		 */		
		public function get bmdRect():Rectangle
		{
			m_tempRect.x = 0;
			m_tempRect.y = 0;
			m_tempRect.width = m_width;
			m_tempRect.height = m_height;
			
			return m_tempRect;
		}
		
		/**
		 * 宽度 设置bitmapData时更新为图片宽度
		 */		
		public function get width():int
		{
			return m_width;
		}
		
		/**
		 * 高度 设置bitmapData时更新为图片高度
		 */		
		public function get height():int
		{
			return m_height;
		} 
		
		/**
		 * 获取上一次屏幕渲染坐标(动态不断变化的) 请使用setLastRenderXY方法 不要直接给x、y属性赋值
		 */		
		public function get lastRenderPoint():Point
		{
			return m_lastRenderPoint;
		}
		
		/**
		 * 获取上一次渲染在屏幕上的位置和范围 请不要直接给x、y、width、height属性赋值
		 */		
		public function get lastRenderRect():Rectangle
		{
			m_tempRect.x = m_lastRenderPoint.x;
			m_tempRect.y = m_lastRenderPoint.y;
			m_tempRect.width = m_lastRenderWidth;
			m_tempRect.height = m_lastRenderHeight;
			
			return m_tempRect;
		}
		
		/**
		 * 浮动排序值
		 */		
		public function get zIndex():int
		{
			return m_zIndex;
		}
		
		/** @private */
		public function set zIndex(value:int):void
		{
			m_zIndex = value;
		}
		
		/**
		 * 排序序号 y坐标值加上zIndex浮动排序值
		 */		
		public function get zOrder():int
		{
			return m_pos.y + m_zIndex;
		}
		
		/**
		 * 设置世界坐标位置
		 */		
		public function setXY(posX:int, posY:int):void
		{
			m_pos.x = posX;
			m_pos.y = posY;
		}
		
		/**
		 * 设置上一次渲染的屏幕位置
		 */		
		public function setLastRenderXY(posX:int, posY:int):void
		{
			m_lastRenderPoint.x = posX;
			m_lastRenderPoint.y = posY;
		}
		
		/**
		 * 根据渲染位置计算渲染坐标 默认渲染位置为底边中点
		 * @param pos 渲染坐标点
		 * @param screenPos 世界坐标转换后相对于屏幕的坐标点
		 */		
		public function updateRenderPoint(pos:Point, screenPos:Point):void
		{
			pos.x = screenPos.x - width / 2;
			pos.y = screenPos.y - height;
		}
		
		/**
		 * 从屏幕上擦除自己
		 */		
		public function clearMe():void
		{
			render.clearMe(this);
		}
		
		/**
		 * 把自己渲染到屏幕上
		 */		
		public function renderMe():void
		{
			render.renderMe(this);
		}
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			game = null;
			render = null;
			m_pos = null;
			m_lastRenderPoint = null;
			m_tempRect = null;
			m_bitmapData = null;
		}
	}
}