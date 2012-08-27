package jsion.comps
{
	import jsion.HashMap;
	import jsion.events.DisplayEvent;
	import jsion.utils.DisposeUtil;

	/**
	 * 所有组件的基类，覆盖了 width 和 height 属性。
	 * 子类继承后需要在适当的时候更新这两个属性的真实值。
	 * @author Jsion
	 */	
	public class Component extends CompSprite
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = "width";
		
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = "height";
		
		private var m_changeNum:int;
		
		/** @private */
		protected var m_changeProperties:HashMap;
		
		/** @private */
		protected var m_manualWidth:Boolean;
		
		/** @private */
		protected var m_width:int;
		
		/** @private */
		protected var m_manualHeight:Boolean;
		
		/** @private */
		protected var m_height:int;
		
		public function Component()
		{
			super();
			
			m_changeProperties = new HashMap();
			
			initialize();
			initEvents();
			configUI();
		}
		
		/**
		 * 重写 x 属性，舍去小数部分。
		 */		
		override public function set x(value:Number):void
		{
			super.x = int(value);
		}
		
		/**
		 * 重写 y 属性，舍去小数部分。
		 */		
		override public function set y(value:Number):void
		{
			super.y = int(value);
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
			
			m_manualWidth = true;
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
			
			m_manualHeight = true;
		}
		
		/**
		 * 指示当前对象是否手动指定了宽度
		 */		
		public function get manualWidth():Boolean
		{
			return m_manualWidth;
		}
		
		/**
		 * 指示当前对象是否手动指定了高度
		 */		
		public function get manualHeight():Boolean
		{
			return m_manualHeight;
		}
		
		/**
		 * 指示是否在显示列表上呈现
		 */		
		public function get isOnStage():Boolean
		{
			return parent != null;
		}
		
		
		/**
		 * 初始化组件
		 */		
		protected function initialize():void
		{
		}
		
		/**
		 * 初始化事件监听
		 */		
		protected function initEvents():void
		{
		}
		
		/**
		 * 初始化后预留接口，供开发者开发UI界面。
		 */		
		protected function configUI():void
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
		 * 指示指定属性是否变更
		 */		
		protected function isChanged(propName:String):Boolean
		{
			return m_changeProperties.containsKey(propName);
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
			redrawBitmapHit();
		}
		
		/**
		 * 添加子对象
		 */		
		protected function addChildren():void
		{
		}
		
		/**
		 * @inheritDOC
		 */		
		override public function dispose():void
		{
			super.dispose();
			
			DisposeUtil.free(m_changeProperties);
			m_changeProperties = null;
		}
	}
}