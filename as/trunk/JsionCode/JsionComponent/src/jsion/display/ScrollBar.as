package jsion.display
{
	import flash.display.DisplayObject;
	
	import jsion.comps.Component;
	
	public class ScrollBar extends Component
	{
		public static const BACKGROUNDCHANGE:String = "backgroundChange";
		public static const UPORLEFTBTNCHANGE:String = "upOrLeftBtnChange";
		public static const DOWNORRIGHTBTNCHANGE:String = "downOrRightBtnChange";
		public static const BARCHANGE:String = "barChange";
		
		/**
		 * 水平滚动条
		 */		
		public static const HORIZONTAL:int = 1;
		
		/**
		 * 垂直滚动条
		 */		
		public static const VERTICAL:int = 2;
		
		private var m_background:Image;
		private var m_upOrLeftBtn:Button;
		private var m_downOrRightBtn:Button;
		private var m_bar:Button;
		private var m_thumb:DisplayObject;
		
		private var m_scrollType:int;
		
		private var m_maxSize:int;
		
		public function ScrollBar(type:int = VERTICAL)
		{
			super();
			
			m_scrollType = type;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function beginChanges():void
		{
			m_background.beginChanges();
			m_upOrLeftBtn.beginChanges();
			m_downOrRightBtn.beginChanges();
			m_bar.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function commitChanges():void
		{
			m_background.commitChanges();
			m_upOrLeftBtn.commitChanges();
			m_downOrRightBtn.commitChanges();
			m_bar.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_background = new Image();
			m_upOrLeftBtn = new Button();
			m_downOrRightBtn = new Button();
			m_bar = new Button();
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_background);
			addChild(m_upOrLeftBtn);
			addChild(m_downOrRightBtn);
			addChild(m_bar);
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateUIPos();
		}
		
		private function updateUIPos():void
		{
			if(isChanged(BACKGROUNDCHANGE) || 
			   isChanged(UPORLEFTBTNCHANGE) || 
			   isChanged(DOWNORRIGHTBTNCHANGE) || 
			   isChanged(BARCHANGE))
			{
				if(m_scrollType == VERTICAL)
				{
					m_maxSize = Math.max(m_background.width, m_upOrLeftBtn.width, m_downOrRightBtn.width, m_bar.width);
					
					m_background.x = (m_maxSize - m_background.width) / 2;
					m_background.y = 0;
				}
				else
				{
					m_maxSize = Math.max(m_background.height, m_upOrLeftBtn.height, m_downOrRightBtn.height, m_bar.height);
				}
				
				
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			super.dispose();
		}

		/**
		 * 滚动条类型。可能的值：
		 * <ul>
		 * 	<li>ScrollBar.HORIZONTAL 水平滚动条</li>
		 * 	<li>ScrollBar.VERTICAL   垂直滚动条</li>
		 * </ul>
		 */		
		public function get scrollType():int
		{
			return m_scrollType;
		}
	}
}