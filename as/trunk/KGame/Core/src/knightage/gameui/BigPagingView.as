package knightage.gameui
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.comps.JsionSprite;
	import jsion.debug.DEBUG;
	import jsion.display.IconLabelButton;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.UIEvent;
	
	public class BigPagingView extends JsionSprite
	{
		protected var m_preButton:IconLabelButton;
		
		protected var m_nextButton:IconLabelButton;
		
		protected var m_contentWidth:int;
		
		protected var m_contentHeight:int;
		
		
		private var m_pageSize:int;
		
		private var m_dataCount:int;
		
		
		private var m_startIndex:int;
		
		private var m_endIndex:int;
		
		
		private var m_pages:int;
		
		private var m_current:int;
		
		
		private var m_dataList:Array;
		
		private var m_currentList:Array;
		
		public function BigPagingView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			m_pages = 1;
			
			m_current = 1;
			
			m_pageSize = 1;
			
			m_dataCount = 1;
			
			m_preButton = new IconLabelButton();
			m_preButton.beginChanges();
			m_preButton.freeBMD = false;
			m_preButton.iconUpImage = new Bitmap(StaticRes.LeftArrowBMD);
			m_preButton.iconDir = IconLabelButton.LEFT;
			//m_preButton.label = "上一区域";
			//m_preButton.labelColor = StaticRes.WhiteColor;
			//m_preButton.textFormat = StaticRes.TextFormat18;
			//m_preButton.labelUpFilters = StaticRes.TextFilters4;
			//m_preButton.labelOverFilters = StaticRes.TextFilters4;
			//m_preButton.labelDownFilters = StaticRes.TextFilters4;
			m_preButton.commitChanges();
			addChild(m_preButton);
			
			
			
			m_nextButton = new IconLabelButton();
			m_nextButton.beginChanges();
			m_nextButton.freeBMD = false;
			m_nextButton.iconUpImage = new Bitmap(StaticRes.RightArrowBMD);
			m_nextButton.iconDir = IconLabelButton.RIGHT;
			//m_nextButton.label = "下一区域";
			//m_nextButton.labelColor = StaticRes.WhiteColor;
			//m_nextButton.textFormat = StaticRes.TextFormat18;
			//m_nextButton.labelUpFilters = StaticRes.TextFilters4;
			//m_nextButton.labelOverFilters = StaticRes.TextFilters4;
			//m_nextButton.labelDownFilters = StaticRes.TextFilters4;
			m_nextButton.commitChanges();
			addChild(m_nextButton);
			
			
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			m_preButton.addEventListener(MouseEvent.CLICK, __preClickHandler);
			m_nextButton.addEventListener(MouseEvent.CLICK, __nextClickHandler);
		}
		
		private function __addToStageHandler(e:Event):void
		{
			// TODO Auto-generated method stub
			
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			if(m_dataList && m_dataList.length != m_dataCount)
			{
				DEBUG.error("分页数据列表总数与设置的数据总数不一致!");
				
				throw new Error("分页数据列表总数与设置的数据总数不一致!");
			}
		}
		
		private function __preClickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(m_current <= 1) return;
			
			current = m_current - 1;
		}
		
		private function __nextClickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(m_current >= m_pages) return;
			
			current = m_current + 1;
		}
		
		public function get current():int
		{
			return m_current;
		}
		
		public function set current(value:int):void
		{
			if(m_current != value)
			{
				value = Math.max(value, 1);
				value = Math.min(value, m_pages);
				
				m_current = value;
			}
			
			if(m_dataList)
			{
				m_startIndex = (m_current - 1) * m_pageSize;
				
				m_endIndex = m_startIndex + m_pageSize;
				
				m_endIndex = Math.min(m_endIndex, m_dataList.length - 1);
				
				m_currentList = ArrayUtil.getRange(m_dataList, m_startIndex, m_endIndex);
			}
			
			dispatchEvent(new UIEvent(UIEvent.PAGE_CHANGED, m_current, m_startIndex, m_endIndex, m_currentList));
		}
		
		public function get currentList():Array
		{
			return m_currentList;
		}
		
		public function get startIndex():int
		{
			return m_startIndex;
		}
		
		public function get endIndex():int
		{
			return m_endIndex;
		}
		
		public function get pages():int
		{
			return m_pages;
		}
		
		public function setPagingData(pageSize:int, count:int):void
		{
			m_pageSize = pageSize;
			m_dataCount = count;
			
			m_pages = m_dataCount / m_pageSize;
			
			if((m_dataCount % m_pageSize) != 0)
			{
				m_pages += 1;
			}
			
			m_pages = Math.max(m_pages, 1);
			
			if(m_current > m_pages)
			{
				current = m_pages;
			}
			else
			{
				current = current;
			}
		}
		
		public function setDataList(list:Array):void
		{
			m_dataList = list;
		}
		
		public function setContentSize(w:int, h:int):void
		{
			m_contentWidth = w;
			m_contentHeight = h;
			
			m_preButton.x = 0;
			m_preButton.y = (m_contentHeight - m_preButton.height) / 2;
			
			
			m_nextButton.x = m_preButton.x + m_preButton.width + m_contentWidth;
			m_nextButton.y = (m_contentHeight - m_nextButton.height) / 2;
		}
		
		override public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			DisposeUtil.free(m_preButton);
			m_preButton = null;
			
			DisposeUtil.free(m_nextButton);
			m_nextButton = null;
			
			super.dispose();
		}
	}
}