package jsion.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.comps.ToggleGroup;
	import jsion.events.DisplayEvent;
	import jsion.utils.DisposeUtil;

	/**
	 * 下拉列表。需要设置下拉列表的样式。
	 * @author Jsion
	 * 
	 */	
	public class ComboBox extends LabelButton
	{
		public static const LISTVIEW:String = "listView";
		public static const LISTSIZE:String = "listSize";
		
		private var m_listView:List;
		private var m_group:ToggleGroup;
		
		private var m_listWidth:int;
		
		private var m_listHeight:int;
		
		public function ComboBox()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginChanges():void
		{
			m_listView.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function commitChanges():void
		{
			m_listView.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			m_listView = new List();
			m_listView.visible = false;
			m_listView.stopAllMouseEventPropagation();
			
			m_group = new ToggleGroup();
			
			html = true;
			
			stopClickPropagation();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initEvents():void
		{
			super.initEvents();
			
			addEventListener(MouseEvent.CLICK, __clickHandler);
			m_group.addEventListener(DisplayEvent.SELECT_CHANGED, __selectChangedHandler);
		}
		
		private function __selectChangedHandler(e:Event):void
		{
			// TODO Auto-generated method stub
			
			if(m_group.selected)
			{
				label = m_group.selected.label;
			}
			else
			{
				label = "";
			}
			
			m_listView.visible = false;
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			if(m_listView.visible)
			{
				m_listView.visible = false;
			}
			else
			{
				m_listView.visible = true;
				
//				var pos:Point = localToGlobal(new Point(x, y));
//				m_listView.x = pos.x;
//				m_listView.y = pos.y + m_height;
//				stage.addChild(m_listView);
				stage.addEventListener(MouseEvent.CLICK, __stageClickHandler);
			}
		}
		
		private function __stageClickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			m_listView.visible = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_listView);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			m_listView.x = 0;
			m_listView.y = m_height;
			
			if(m_listWidth > 0) m_listView.width = m_listWidth;
			else m_listView.width = m_width;
			
			if(m_listHeight > 0) m_listView.height = m_listHeight;
			else m_listView.height = 170;
		}
		
		
		
		/**
		 * @copy jsion.display.List#addItem()
		 */		
		public function addItem(item:ToggleButton):void
		{
			m_listView.addItem(item);
			m_group.addItem(item);
		}
		
		/**
		 * @copy jsion.display.List#addItemAt()
		 */		
		public function addItemAt(item:ToggleButton, index:int):void
		{
			m_listView.addItemAt(item, index);
		}
		
		/**
		 * @copy jsion.display.List#removeItem()
		 */		
		public function removeItem(item:ToggleButton):void
		{
			m_listView.removeItem(item);
		}
		
		/**
		 * @copy jsion.display.List#removeItemAt()
		 */		
		public function removeItemAt(index:int):ToggleButton
		{
			return m_listView.removeItemAt(index) as ToggleButton;
		}
		
		
		
		/**
		 * @copy jsion.display.List#itemGap
		 */		
		public function get listItemGap():int
		{
			return m_listView.itemGap;
		}
		
		/**
		 * @private
		 */		
		public function set listItemGap(value:int):void
		{
			if(m_listView.itemGap != value)
			{
				m_listView.itemGap = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		
		/**
		 * @copy jsion.display.List#scrollBarBackground
		 */		
		public function get scrollBarBackground():BitmapData
		{
			return m_listView.scrollBarBackground;
		}
		
		/** @private */
		public function set scrollBarBackground(value:BitmapData):void
		{
			if(m_listView.scrollBarBackground != value)
			{
				m_listView.scrollBarBackground = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnUpAsset
		 */		
		public function get UpOrLeftBtnUpAsset():DisplayObject
		{
			return m_listView.UpOrLeftBtnUpAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnUpAsset(value:DisplayObject):void
		{
			if(m_listView.UpOrLeftBtnUpAsset != value)
			{
				m_listView.UpOrLeftBtnUpAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnOverAsset
		 */		
		public function get UpOrLeftBtnOverAsset():DisplayObject
		{
			return m_listView.UpOrLeftBtnOverAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnOverAsset(value:DisplayObject):void
		{
			if(m_listView.UpOrLeftBtnOverAsset != value)
			{
				m_listView.UpOrLeftBtnOverAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnDownAsset
		 */		
		public function get UpOrLeftBtnDownAsset():DisplayObject
		{
			return m_listView.UpOrLeftBtnDownAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnDownAsset(value:DisplayObject):void
		{
			if(m_listView.UpOrLeftBtnDownAsset != value)
			{
				m_listView.UpOrLeftBtnDownAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnDisableAsset
		 */		
		public function get UpOrLeftBtnDisableAsset():DisplayObject
		{
			return m_listView.UpOrLeftBtnDisableAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnDisableAsset(value:DisplayObject):void
		{
			if(m_listView.UpOrLeftBtnDisableAsset != value)
			{
				m_listView.UpOrLeftBtnDisableAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnUpFilters
		 */		
		public function get UpOrLeftBtnUpFilters():Array
		{
			return m_listView.UpOrLeftBtnUpFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnUpFilters(value:Array):void
		{
			if(m_listView.UpOrLeftBtnUpFilters != value)
			{
				m_listView.UpOrLeftBtnUpFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnOverFilters
		 */		
		public function get UpOrLeftBtnOverFilters():Array
		{
			return m_listView.UpOrLeftBtnOverFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnOverFilters(value:Array):void
		{
			if(m_listView.UpOrLeftBtnOverFilters != value)
			{
				m_listView.UpOrLeftBtnOverFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnDownFilters
		 */		
		public function get UpOrLeftBtnDownFilters():Array
		{
			return m_listView.UpOrLeftBtnDownFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnDownFilters(value:Array):void
		{
			if(m_listView.UpOrLeftBtnDownFilters != value)
			{
				m_listView.UpOrLeftBtnDownFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnDisableFilters
		 */		
		public function get UpOrLeftBtnDisableFilters():Array
		{
			return m_listView.UpOrLeftBtnDisableFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnDisableFilters(value:Array):void
		{
			if(m_listView.UpOrLeftBtnDisableFilters != value)
			{
				m_listView.UpOrLeftBtnDisableFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnImageOffsetX
		 */		
		public function get UpOrLeftBtnImageOffsetX():int
		{
			return m_listView.UpOrLeftBtnImageOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOffsetX(value:int):void
		{
			if(m_listView.UpOrLeftBtnImageOffsetX != value)
			{
				m_listView.UpOrLeftBtnImageOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnImageOffsetY
		 */		
		public function get UpOrLeftBtnImageOffsetY():int
		{
			return m_listView.UpOrLeftBtnImageOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOffsetY(value:int):void
		{
			if(m_listView.UpOrLeftBtnImageOffsetY != value)
			{
				m_listView.UpOrLeftBtnImageOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnImageOverOffsetX
		 */		
		public function get UpOrLeftBtnImageOverOffsetX():int
		{
			return m_listView.UpOrLeftBtnImageOverOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOverOffsetX(value:int):void
		{
			if(m_listView.UpOrLeftBtnImageOverOffsetX != value)
			{
				m_listView.UpOrLeftBtnImageOverOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnImageOverOffsetY
		 */		
		public function get UpOrLeftBtnImageOverOffsetY():int
		{
			return m_listView.UpOrLeftBtnImageOverOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOverOffsetY(value:int):void
		{
			if(m_listView.UpOrLeftBtnImageOverOffsetY != value)
			{
				m_listView.UpOrLeftBtnImageOverOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnImageDownOffsetX
		 */		
		public function get UpOrLeftBtnImageDownOffsetX():int
		{
			return m_listView.UpOrLeftBtnImageDownOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageDownOffsetX(value:int):void
		{
			if(m_listView.UpOrLeftBtnImageDownOffsetX != value)
			{
				m_listView.UpOrLeftBtnImageDownOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#UpOrLeftBtnImageDownOffsetY
		 */		
		public function get UpOrLeftBtnImageDownOffsetY():int
		{
			return m_listView.UpOrLeftBtnImageDownOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageDownOffsetY(value:int):void
		{
			if(m_listView.UpOrLeftBtnImageDownOffsetY != value)
			{
				m_listView.UpOrLeftBtnImageDownOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnUpAsset
		 */		
		public function get DownOrRightBtnUpAsset():DisplayObject
		{
			return m_listView.DownOrRightBtnUpAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnUpAsset(value:DisplayObject):void
		{
			if(m_listView.DownOrRightBtnUpAsset != value)
			{
				m_listView.DownOrRightBtnUpAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnOverAsset
		 */		
		public function get DownOrRightBtnOverAsset():DisplayObject
		{
			return m_listView.DownOrRightBtnOverAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnOverAsset(value:DisplayObject):void
		{
			if(m_listView.DownOrRightBtnOverAsset != value)
			{
				m_listView.DownOrRightBtnOverAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnDownAsset
		 */		
		public function get DownOrRightBtnDownAsset():DisplayObject
		{
			return m_listView.DownOrRightBtnDownAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnDownAsset(value:DisplayObject):void
		{
			if(m_listView.DownOrRightBtnDownAsset != value)
			{
				m_listView.DownOrRightBtnDownAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnDisableAsset
		 */		
		public function get DownOrRightBtnDisableAsset():DisplayObject
		{
			return m_listView.DownOrRightBtnDisableAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnDisableAsset(value:DisplayObject):void
		{
			if(m_listView.DownOrRightBtnDisableAsset != value)
			{
				m_listView.DownOrRightBtnDisableAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnUpFilters
		 */		
		public function get DownOrRightBtnUpFilters():Array
		{
			return m_listView.DownOrRightBtnUpFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnUpFilters(value:Array):void
		{
			if(m_listView.DownOrRightBtnUpFilters != value)
			{
				m_listView.DownOrRightBtnUpFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnOverFilters
		 */		
		public function get DownOrRightBtnOverFilters():Array
		{
			return m_listView.DownOrRightBtnOverFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnOverFilters(value:Array):void
		{
			if(m_listView.DownOrRightBtnOverFilters != value)
			{
				m_listView.DownOrRightBtnOverFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnDownFilters
		 */		
		public function get DownOrRightBtnDownFilters():Array
		{
			return m_listView.DownOrRightBtnDownFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnDownFilters(value:Array):void
		{
			if(m_listView.DownOrRightBtnDownFilters != value)
			{
				m_listView.DownOrRightBtnDownFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnDisableFilters
		 */		
		public function get DownOrRightBtnDisableFilters():Array
		{
			return m_listView.DownOrRightBtnDisableFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnDisableFilters(value:Array):void
		{
			if(m_listView.DownOrRightBtnDisableFilters != value)
			{
				m_listView.DownOrRightBtnDisableFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnImageOffsetX
		 */		
		public function get DownOrRightBtnImageOffsetX():int
		{
			return m_listView.DownOrRightBtnImageOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOffsetX(value:int):void
		{
			if(m_listView.DownOrRightBtnImageOffsetX != value)
			{
				m_listView.DownOrRightBtnImageOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnImageOffsetY
		 */		
		public function get DownOrRightBtnImageOffsetY():int
		{
			return m_listView.DownOrRightBtnImageOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOffsetY(value:int):void
		{
			if(m_listView.DownOrRightBtnImageOffsetY != value)
			{
				m_listView.DownOrRightBtnImageOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnImageOverOffsetX
		 */		
		public function get DownOrRightBtnImageOverOffsetX():int
		{
			return m_listView.DownOrRightBtnImageOverOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOverOffsetX(value:int):void
		{
			if(m_listView.DownOrRightBtnImageOverOffsetX != value)
			{
				m_listView.DownOrRightBtnImageOverOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnImageOverOffsetY
		 */		
		public function get DownOrRightBtnImageOverOffsetY():int
		{
			return m_listView.DownOrRightBtnImageOverOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOverOffsetY(value:int):void
		{
			if(m_listView.DownOrRightBtnImageOverOffsetY != value)
			{
				m_listView.DownOrRightBtnImageOverOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnImageDownOffsetX
		 */		
		public function get DownOrRightBtnImageDownOffsetX():int
		{
			return m_listView.DownOrRightBtnImageDownOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageDownOffsetX(value:int):void
		{
			if(m_listView.DownOrRightBtnImageDownOffsetX != value)
			{
				m_listView.DownOrRightBtnImageDownOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#DownOrRightBtnImageDownOffsetY
		 */		
		public function get DownOrRightBtnImageDownOffsetY():int
		{
			return m_listView.DownOrRightBtnImageDownOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageDownOffsetY(value:int):void
		{
			if(m_listView.DownOrRightBtnImageDownOffsetY != value)
			{
				m_listView.DownOrRightBtnImageDownOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		/**
		 * @copy jsion.display.List#BarUpAsset
		 */		
		public function get BarUpAsset():DisplayObject
		{
			return m_listView.BarUpAsset;
		}
		
		/** @private */
		public function set BarUpAsset(value:DisplayObject):void
		{
			if(m_listView.BarUpAsset != value)
			{
				m_listView.BarUpAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#BarOverAsset
		 */		
		public function get BarOverAsset():DisplayObject
		{
			return m_listView.BarOverAsset;
		}
		
		/** @private */
		public function set BarOverAsset(value:DisplayObject):void
		{
			if(m_listView.BarOverAsset != value)
			{
				m_listView.BarOverAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#BarDownAsset
		 */		
		public function get BarDownAsset():DisplayObject
		{
			return m_listView.BarDownAsset;
		}
		
		/** @private */
		public function set BarDownAsset(value:DisplayObject):void
		{
			if(m_listView.BarDownAsset != value)
			{
				m_listView.BarDownAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#BarDisableAsset
		 */		
		public function get BarDisableAsset():DisplayObject
		{
			return m_listView.BarDisableAsset;
		}
		
		/** @private */
		public function set BarDisableAsset(value:DisplayObject):void
		{
			if(m_listView.BarDisableAsset != value)
			{
				m_listView.BarDisableAsset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#BarUpFilters
		 */		
		public function get BarUpFilters():Array
		{
			return m_listView.BarUpFilters;
		}
		
		/** @private */
		public function set BarUpFilters(value:Array):void
		{
			if(m_listView.BarUpFilters != value)
			{
				m_listView.BarUpFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarOverFilters
		 */		
		public function get BarOverFilters():Array
		{
			return m_listView.BarOverFilters;
		}
		
		/** @private */
		public function set BarOverFilters(value:Array):void
		{
			if(m_listView.BarOverFilters != value)
			{
				m_listView.BarOverFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarDownFilters
		 */		
		public function get BarDownFilters():Array
		{
			return m_listView.BarDownFilters;
		}
		
		/** @private */
		public function set BarDownFilters(value:Array):void
		{
			if(m_listView.BarDownFilters != value)
			{
				m_listView.BarDownFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarDisableFilters
		 */		
		public function get BarDisableFilters():Array
		{
			return m_listView.BarDisableFilters;
		}
		
		/** @private */
		public function set BarDisableFilters(value:Array):void
		{
			if(m_listView.BarDisableFilters != value)
			{
				m_listView.BarDisableFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarImageOffsetX
		 */		
		public function get BarImageOffsetX():int
		{
			return m_listView.BarImageOffsetX;
		}
		
		/** @private */
		public function set BarImageOffsetX(value:int):void
		{
			if(m_listView.BarImageOffsetX != value)
			{
				m_listView.BarImageOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarImageOffsetY
		 */		
		public function get BarImageOffsetY():int
		{
			return m_listView.BarImageOffsetY;
		}
		
		/** @private */
		public function set BarImageOffsetY(value:int):void
		{
			if(m_listView.BarImageOffsetY != value)
			{
				m_listView.BarImageOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarImageOverOffsetX
		 */		
		public function get BarImageOverOffsetX():int
		{
			return m_listView.BarImageOverOffsetX;
		}
		
		/** @private */
		public function set BarImageOverOffsetX(value:int):void
		{
			if(m_listView.BarImageOverOffsetX != value)
			{
				m_listView.BarImageOverOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarImageOverOffsetY
		 */		
		public function get BarImageOverOffsetY():int
		{
			return m_listView.BarImageOverOffsetY;
		}
		
		/** @private */
		public function set BarImageOverOffsetY(value:int):void
		{
			if(m_listView.BarImageOverOffsetY != value)
			{
				m_listView.BarImageOverOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarImageDownOffsetX
		 */		
		public function get BarImageDownOffsetX():int
		{
			return m_listView.BarImageDownOffsetX;
		}
		
		/** @private */
		public function set BarImageDownOffsetX(value:int):void
		{
			if(m_listView.BarImageDownOffsetX != value)
			{
				m_listView.BarImageDownOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.List#BarImageDownOffsetY
		 */		
		public function get BarImageDownOffsetY():int
		{
			return m_listView.BarImageDownOffsetY;
		}
		
		/** @private */
		public function set BarImageDownOffsetY(value:int):void
		{
			if(m_listView.BarImageDownOffsetY != value)
			{
				m_listView.BarImageDownOffsetY = value;
			}
		}
		
		
		
		
		
		/**
		 * @copy jsion.display.List#thumb
		 */		
		public function get thumb():DisplayObject
		{
			return m_listView.thumb;
		}
		
		/** @private */
		public function set thumb(value:DisplayObject):void
		{
			if(m_listView.thumb != value)
			{
				m_listView.thumb = value;
			}
		}
		
		/** @private */
		override public function set freeBMD(value:Boolean):void
		{
			super.freeBMD = value;
			
			m_listView.freeBMD = value;
		}
		
		/**
		 * @copy jsion.display.List#scrollValue
		 */		
		public function get scrollValue():int
		{
			return m_listView.scrollValue;
		}
		
		/** @private */
		public function set scrollValue(value:int):void
		{
			m_listView.scrollValue = value;
		}
		
		/**
		 * @copy jsion.display.List#viewSize
		 */		
		public function get viewSize():int
		{
			return m_listView.viewSize;
		}
		
		/** @private */
		public function set viewSize(value:int):void
		{
			if(m_listView.viewSize != value)
			{
				m_listView.viewSize = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#scrollValueOffset
		 */		
		public function get scrollValueOffset():int
		{
			return m_listView.scrollValueOffset;
		}
		
		/** @private */
		public function set scrollValueOffset(value:int):void
		{
			if(m_listView.scrollValueOffset != value)
			{
				m_listView.scrollValueOffset = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @copy jsion.display.List#wheelStep
		 */		
		public function get wheelStep():int
		{
			return m_listView.wheelStep;
		}
		
		/** @private */
		public function set wheelStep(value:int):void
		{
			m_listView.wheelStep = value;
		}
		
		/**
		 * @copy jsion.display.List#scrollStep
		 */		
		public function get scrollStep():int
		{
			return m_listView.scrollStep;;
		}
		
		/** @private */
		public function set scrollStep(value:int):void
		{
			m_listView.scrollStep = value;
		}
		
		/**
		 * @copy jsion.display.List#delayFrame
		 */		
		public function get delayFrame():int
		{
			return m_listView.delayFrame;
		}
		
		/** @private */
		public function set delayFrame(value:int):void
		{
			m_listView.delayFrame = value;
		}
		
		/**
		 * @copy jsion.display.List#btnGap
		 */		
		public function get btnGap():int
		{
			return m_listView.btnGap;
		}
		
		/** @private */
		public function set btnGap(value:int):void
		{
			if(m_listView.btnGap != value)
			{
				m_listView.btnGap = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(stage) stage.addEventListener(MouseEvent.CLICK, __stageClickHandler);
			
			DisposeUtil.free(m_group);
			m_group = null;
			
			DisposeUtil.free(m_listView);
			m_listView = null;
			
			super.dispose();
		}

		/**
		 * 下拉列表宽度
		 */		
		public function get listWidth():int
		{
			return m_listWidth;
		}
		
		/** @private */
		public function set listWidth(value:int):void
		{
			if(m_listWidth != value)
			{
				m_listWidth = value;
				
				onPropertiesChanged(LISTSIZE);
			}
		}

		/**
		 * 下拉列表高度
		 */		
		public function get listHeight():int
		{
			return m_listHeight;
		}
		
		/** @private */
		public function set listHeight(value:int):void
		{
			if(m_listHeight != value)
			{
				m_listHeight = value;
				
				onPropertiesChanged(LISTSIZE);
			}
		}
		
		
		
		/**
		 * 下拉列表背景显示对象
		 */		
		public function get listBackground():DisplayObject
		{
			return m_listView.background;
		}
		
		/** @private */
		public function set listBackground(value:DisplayObject):void
		{
			if(m_listView.background != value)
			{
				m_listView.background = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * 下拉列表背景显示对象横向间隙
		 */		
		public function get listBackgroundHGap():int
		{
			return m_listView.backgroundHGap;
		}
		
		/** @private */
		public function set listBackgroundHGap(value:int):void
		{
			if(m_listView.backgroundHGap != value)
			{
				m_listView.backgroundHGap = value;
				
				onPropertiesChanged(LISTSIZE);
			}
		}
		
		/**
		 * 下拉列表背景显示对象纵向间隙
		 */		
		public function get listBackgroundVGap():int
		{
			return m_listView.backgroundVGap;
		}
		
		/** @private */
		public function set listBackgroundVGap(value:int):void
		{
			if(m_listView.backgroundVGap != value)
			{
				m_listView.backgroundVGap = value;
				
				onPropertiesChanged(LISTSIZE);
			}
		}
		
		/**
		 * 当前选择的对象
		 */
		public function get selected():ToggleButton
		{
			return m_group.selected;
		}
		
		/** @private */
		public function set selected(value:ToggleButton):void
		{
			m_group.selected = value;
		}
		
		/**
		 * 获取或设置选中对象的子索引位置。
		 */		
		public function get selectedIndex():int
		{
			return m_group.selectedIndex;
		}
		
		/** @private */
		public function set selectedIndex(value:int):void
		{
			m_group.selectedIndex = value;
		}
	}
}