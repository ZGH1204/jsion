package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.ddrop.DDropMgr;
	import jsion.ddrop.IDragDrop;
	
	/**
	 * 窗体拖动辅助类
	 * @author Jsion
	 * 
	 */	
	internal class TitleDragger extends Sprite implements IDragDrop, IDispose
	{
		private var m_window:Window;
		
		public function TitleDragger(window:Window)
		{
			m_window = window;
			
			DDropMgr.registeDrag(this);
		}
		
		/**
		 * 是否为鼠标点击时拖动,false表示鼠标按下时拖动.
		 */		
		public function get isClickDrag():Boolean
		{
			return false;
		}
		
		/**
		 * 是否锁定到中心位置
		 */		
		public function get lockCenter():Boolean
		{
			return false;
		}
		
		public function set lockCenter(value:Boolean):void
		{
		}
		
		/**
		 * 拖动时传递的数据
		 */		
		public function get transData():*
		{
			return null;
		}
		
		/**
		 * 当鼠标移出屏幕释放时是否修正拖动时的显示对象鼠标下的坐标到舞台内
		 * 以便下次可以拖动
		 */		
		public function get reviseInStage():Boolean
		{
			return true;
		}
		
		/**
		 * 是否对拖动时的显示对象进行内存释放
		 */		
		public function get freeDragingIcon():Boolean
		{
			return false;
		}
		
		/**
		 * 拖动时的显示对象
		 */		
		public function get dragingIcon():DisplayObject
		{
			return m_window;
		}
		
		/**
		 * 组内除正在拖动对象外的所有对象在拖动对象释放后的回调
		 * @param dragger 拖动对象
		 * @param data 传递数据
		 */		
		public function groupDragCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		/**
		 * 组内除正在拖动对象外的所有对象在拖动对象开始拖动时的回调
		 * @param dragger 拖动对象
		 * @param data 传递数据
		 */		
		public function groupDropCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		/**
		 * 开始拖动时的回调
		 */		
		public function startDragCallback():void
		{
		}
		
		/**
		 * 拖动时的回调
		 */		
		public function dragingCallback():void
		{
		}
		
		/**
		 * 释放后的回调
		 */		
		public function dropCallback():void
		{
		}
		
		/**
		 * 拖动释放后被碰撞时的回调
		 * @param dragger 拖动对象
		 * @param data 传递数据
		 */		
		public function dropHitCallback(dragger:IDragDrop, data:*):void
		{
		}
		
		/**
		 * 画出鼠标事件触发区域。
		 * @param xPos 触发区域起始x坐标
		 * @param yPos 触发区域起始y坐标
		 * @param w 触发区域宽度
		 * @param h 触发区域高度
		 */		
		public function drawTrigger(xPos:Number, yPos:Number, w:Number, h:Number):void
		{
			graphics.clear();
			graphics.beginFill(0x0, 0);
			graphics.drawRect(xPos, yPos, w, h);
			graphics.endFill();
		}
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			graphics.clear();
			
			DDropMgr.unregisteDrag(this);
			
			m_window = null;
		}
	}
}