package jsion.comps
{
	import jsion.HashMap;
	import jsion.events.DisplayEvent;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	/**
	 * 所有组件的基类
	 * @author Jsion
	 */	
	public class Component extends JsionSprite
	{
		/**
		 * 宽度属性改变标识
		 */		
		public static const WIDTH:String = "width";
		
		/**
		 * 宽度属性改变标识
		 */		
		public static const HEIGHT:String = "height";
		
		private var m_changeNum:int;
		
		/** @private */
		protected var m_changeProperties:HashMap;
		
		/** @private */
		protected var m_width:int;
		
		/** @private */
		protected var m_height:int;
		
		public function Component()
		{
			super();
			
			m_changeProperties = new HashMap();
			
			initialize();
		}
		
		/**
		 * 重写宽度属性
		 */		
		override public function get width():Number
		{
			return m_width;
		}
		
		/** @private */
		override public function set width(value:Number):void
		{
			if(m_width != value)
			{
				m_width = value;
				
				onPropertiesChanged(WIDTH);
			}
		}
		
		/**
		 * 重写高度属性
		 */		
		override public function get height():Number
		{
			return m_height;
		}
		
		/** @private */
		override public function set height(value:Number):void
		{
			if(m_height != value)
			{
				m_height = value;
				
				onPropertiesChanged(HEIGHT);
			}
		}
		
		protected function initialize():void
		{
		}
		
		/**
		 * 开始批量变更
		 */		
		public function beginChanges():void
		{
			m_changeNum++;
		}
		
		/**
		 * 提交批量变更
		 */		
		public function commitChanges():void
		{
			m_changeNum--;
			
			invalidate();
		}
		
		/**
		 * 验证
		 */		
		protected function invalidate():void
		{
			if(m_changeNum <= 0)
			{
				m_changeNum = 0;
				
				apply();
			}
		}
		
		/**
		 * 应用变更
		 */		
		protected function apply():void
		{
			onProppertiesUpdate();
			
			addChildren();
			
			dispatchEvent(new DisplayEvent(DisplayEvent.PROPERTIES_CHANGED, m_changeProperties));
			
			m_changeProperties.removeAll();
		}
		
		/**
		 * 属性变更时调用
		 */		
		protected function onPropertiesChanged(propName:String = null):void
		{
//			if(StringUtil.isNullOrEmpty(propName) == false)
//			{
//				m_changeProperties.put(propName, true);
//			}
			
			m_changeProperties.put(propName, true);
			
			invalidate();
		}
		
		/**
		 * 应用属性变更
		 */		
		protected function onProppertiesUpdate():void
		{
		}
		
		/**
		 * 添加子对象
		 */		
		protected function addChildren():void
		{
		}
		
		/**
		 * 释放资源
		 */		
		override public function dispose():void
		{
			super.dispose();
			
			DisposeUtil.free(m_changeProperties);
			m_changeProperties = null;
		}
	}
}