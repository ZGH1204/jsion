package knightage.gameui
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.IDispose;
	import jsion.comps.JsionSprite;
	import jsion.debug.DEBUG;
	import jsion.display.Button;
	import jsion.display.Label;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.UIEvent;
	
	public class PagingView extends JsionSprite
	{
		private var m_pageSize:int;
		
		private var m_dataCount:int;
		
		
		private var m_startIndex:int;
		
		private var m_endIndex:int;
		
		
		private var m_pages:int;
		
		private var m_current:int;
		
		
		private var m_leftButton:Button;
		
		private var m_rightButton:Button;
		
		private var m_pageLabel:Label;
		
		private var m_dataList:Array;
		
		private var m_currentList:Array;
		
		
		public function PagingView()
		{
			super();
			
			initialized();
		}

		private function initialized():void
		{
			m_pages = 1;
			
			m_current = 1;
			
			m_pageSize = 1;
			
			m_dataCount = 1;
			
			var tempScale:Number = 0.8;
			
			var bmp:Bitmap;
			
			m_leftButton = new Button();
			m_leftButton.beginChanges();
			m_leftButton.freeBMD = false;
			bmp = new Bitmap(StaticRes.LeftArrowBMD, PixelSnapping.AUTO, true);
			bmp.scaleX = tempScale;
			bmp.scaleY = tempScale;
			m_leftButton.upImage = bmp;
			m_leftButton.commitChanges();
			addChild(m_leftButton);
			
			m_rightButton = new Button();
			m_rightButton.beginChanges();
			m_rightButton.freeBMD = false;
			bmp = new Bitmap(StaticRes.RightArrowBMD, PixelSnapping.AUTO, true);
			bmp.scaleX = tempScale;
			bmp.scaleY = tempScale;
			m_rightButton.upImage = bmp;
			m_rightButton.commitChanges();
			addChild(m_rightButton);
			
			
			m_pageLabel = new Label();
			m_pageLabel.beginChanges();
			m_pageLabel.embedFonts = true;
			m_pageLabel.textColor = StaticRes.WhiteColor;
			m_pageLabel.filters = StaticRes.TextFilters4;
			m_pageLabel.textFormat = StaticRes.HaiBaoEmbedTextFormat15;
			m_pageLabel.text = m_current + "/" + m_pages;
			m_pageLabel.commitChanges();
			addChild(m_pageLabel);
			
			var spacing:int = 100;
			
			m_leftButton.x = 0;
			m_rightButton.y = 0;
			
			m_rightButton.x = m_leftButton.x + m_leftButton.width + spacing;
			m_rightButton.y = m_rightButton.y;
			
			m_pageLabel.x = (spacing - m_pageLabel.width) / 2 + m_leftButton.x + m_leftButton.width;
			m_pageLabel.y = m_leftButton.y + (m_leftButton.height - m_pageLabel.height) / 2;
			
			
			
			
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			m_leftButton.addEventListener(MouseEvent.CLICK, __prePageClickHandler);
			m_rightButton.addEventListener(MouseEvent.CLICK, __nextPageClickHandler);
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
		
		private function __prePageClickHandler(e:MouseEvent):void
		{
			if(m_current <= 1) return;
			
			current = m_current - 1;
		}
		
		private function __nextPageClickHandler(e:MouseEvent):void
		{
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
			
			m_pageLabel.text = m_current + "/" + m_pages;
			
			if(m_dataList)
			{
				m_startIndex = (m_current - 1) * m_pageSize;
				
				m_endIndex = m_startIndex + m_pageSize - 1;
				
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
		
		override public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			
			DisposeUtil.free(m_leftButton);
			m_leftButton = null;
			
			DisposeUtil.free(m_rightButton);
			m_rightButton = null;
			
			DisposeUtil.free(m_pageLabel);
			m_pageLabel = null;
			
			super.dispose();
		}
	}
}