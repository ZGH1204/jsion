package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import jsion.utils.DisposeUtil;

	/**
	 * UI管理器。
	 * 按以下顺序一层一层重叠上来
	 * 分为以下几个UI层级：
	 * <ul>
	 * 	<li>FixUI</li>
	 * 	<li>UI</li>
	 * 	<li>Alert</li>
	 * 	<li>Wait</li>
	 * 	<li>MsgTip(本层为鼠标穿透层)</li>
	 * </ul>
	 * @author Jsion
	 * 
	 */	
	public class UIMgr
	{
		private static var m_root:DisplayObjectContainer;
		private static var m_fixLayer:Sprite;
		private static var m_uiLayer:Sprite;
		private static var m_uiAlert:Sprite;
		private static var m_waitLayer:Sprite;
		private static var m_uiMessageTip:Sprite;
		
		public function UIMgr()
		{
		}
		
		/**
		 * 初始化UI层
		 * @param parent 放置UI层的显示对象容器
		 * 
		 */		
		public static function setup(parent:DisplayObjectContainer):void
		{
			if(m_root || parent == null) return;
			
			m_root = parent;
			m_fixLayer = new Sprite();
			m_uiLayer = new Sprite();
			m_uiAlert = new Sprite();
			m_waitLayer = new Sprite();
			m_uiMessageTip = new Sprite();
			
			m_root.addChild(m_fixLayer);
			m_root.addChild(m_uiLayer);
			m_root.addChild(m_uiAlert);
			m_root.addChild(m_waitLayer);
			m_root.addChild(m_uiMessageTip);
			
			m_uiMessageTip.mouseEnabled = false;
			m_uiMessageTip.mouseChildren = false;
		}
		
		/**
		 * 将固定UI显示对象添加到固定UI显示层上
		 * @param child UI显示对象
		 */		
		public static function addFixUI(child:DisplayObject):void
		{
			if(child == null) return;
			
			m_fixLayer.addChild(child);
		}
		
		/**
		 * 将UI添加到UI显示层上。
		 * @param child UI显示对象
		 * @param center 是否舞台居中
		 * 
		 */		
		public static function addUI(child:DisplayObject, offsetX:int = 0, offsetY:int = 0, center:Boolean = true):void
		{
			if(child == null) return;
			
			m_uiLayer.addChild(child);
			
			if(center)
			{
				child.x = (m_root.stage.stageWidth - child.width) / 2;
				child.y = (m_root.stage.stageHeight - child.height) / 2;
			}
			else
			{
				child.x = 0;
				child.y = 0;
			}
			
			child.x += offsetX;
			child.y += offsetY;
		}
		
		/**
		 * 将UI显示层上的所有UI清除并释放
		 */		
		public static function clearUI():void
		{
			while(m_uiLayer.numChildren > 0)
			{
				DisposeUtil.free(m_uiLayer.getChildAt(m_uiLayer.numChildren - 1));
			}
		}
		
		/**
		 * 将显示对象添加到消息确认框层上。
		 * @param child 消息框显示对象
		 * 
		 */		
		public static function addAlert(child:DisplayObject, offsetX:int = 0, offsetY:int = 0, center:Boolean = true):void
		{
			if(child == null) return;
			
			m_uiAlert.addChild(child);
			
			if(center)
			{
				child.x = (m_root.stage.stageWidth - child.width) / 2;
				child.y = (m_root.stage.stageHeight - child.height) / 2;
			}
			else
			{
				child.x = 0;
				child.y = 0;
			}
			
			child.x += offsetX;
			child.y += offsetY;
		}
		
		/**
		 * 将确认框层上的所有显示对象清除并释放
		 */		
		public static function clearAlert():void
		{
			while(m_uiAlert.numChildren > 0)
			{
				DisposeUtil.free(m_uiAlert.getChildAt(m_uiAlert.numChildren - 1));
			}
		}
		
		/**
		 * 将显示对象添加到加载等待层上
		 * @param child 显示对象
		 * @param offsetX x坐标偏移
		 * @param offsetY y坐标偏移
		 * @param center 是否居中
		 * 
		 */		
		public static function addWait(child:DisplayObject, offsetX:int = 0, offsetY:int = 0, center:Boolean = true):void
		{
			if(child == null) return;
			
			m_waitLayer.addChild(child);
			
			if(center)
			{
				child.x = (m_root.stage.stageWidth - child.width) / 2;
				child.y = (m_root.stage.stageHeight - child.height) / 2;
			}
			else
			{
				child.x = 0;
				child.y = 0;
			}
			
			child.x += offsetX;
			child.y += offsetY;
		}
		
		/**
		 * 清除并释放加载等待层上所有的显示对象
		 */		
		public static function clearWait():void
		{
			while(m_waitLayer.numChildren > 0)
			{
				DisposeUtil.free(m_waitLayer.getChildAt(m_waitLayer.numChildren - 1));
			}
		}
		
		/**
		 * 将显示对象添加到消息提示层上。
		 * @param child 消息提示对象
		 * 
		 */		
		public static function addMsgTip(child:DisplayObject, offsetX:int = 0, offsetY:int = 0, center:Boolean = true):void
		{
			if(child == null) return;
			
			m_uiMessageTip.addChild(child);
			
			if(center)
			{
				child.x = (m_root.stage.stageWidth - child.width) / 2;
				child.y = (m_root.stage.stageHeight - child.height) / 2;
			}
			else
			{
				child.x = 0;
				child.y = 0;
			}
			
			child.x += offsetX;
			child.y += offsetY;
		}
	}
}