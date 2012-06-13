package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * UI管理器。
	 * 分为三个UI层级：
	 * 最下层为普通UI层；
	 * 中间层为提示框层；
	 * 最上层为消息提示层。
	 * @author Jsion
	 * 
	 */	
	public class UIMgr
	{
		private static var m_root:Sprite;
		private static var m_uiLayer:Sprite;
		private static var m_uiAlert:Sprite;
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
			
			m_root = new Sprite();
			m_uiLayer = new Sprite();
			m_uiAlert = new Sprite();
			m_uiMessageTip = new Sprite();
			
			m_root.addChild(m_uiLayer);
			m_root.addChild(m_uiAlert);
			m_root.addChild(m_uiMessageTip);
			
			parent.addChild(m_root);
		}
		
		/**
		 * 将UI添加到UI显示层上。
		 * @param child UI显示对象
		 * @param center 是否舞台居中
		 * 
		 */		
		public static function addUI(child:DisplayObject, center:Boolean = true):void
		{
			if(child == null) return;
			
			m_uiLayer.addChild(child);
			
			if(center == false) return;
			
			child.x = (m_root.stage.stageWidth - child.width) / 2;
			child.y = (m_root.stage.stageHeight - child.height) / 2;
		}
		
		/**
		 * 将显示对象添加到消息确认框层上。
		 * @param child 消息框显示对象
		 * 
		 */		
		public static function addAlert(child:DisplayObject):void
		{
			if(child == null) return;
			
			m_uiLayer.addChild(child);
			
			child.x = (m_root.stage.stageWidth - child.width) / 2;
			child.y = (m_root.stage.stageHeight - child.height) / 2;
		}
		
		/**
		 * 将显示对象添加到消息提示层上。
		 * @param child 消息提示对象
		 * 
		 */		
		public static function addMsgTip(child:DisplayObject):void
		{
			if(child == null) return;
			
			m_uiLayer.addChild(child);
			
			child.x = (m_root.stage.stageWidth - child.width) / 2;
			child.y = (m_root.stage.stageHeight - child.height) / 2;
		}
	}
}