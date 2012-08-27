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
			
			dispatchEvent(new DisplayEvent(DisplayEvent.SELECT_CHANGED, m_group.selected));
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
			
			if(parent) parent.addChild(m_listView);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			m_listView.x = x;
			m_listView.y = y + height;
			
			//m_listView.x = 0;
			//m_listView.y = m_height;
			
			if(m_listWidth > 0) m_listView.width = m_listWidth;
			else m_listView.width = m_width;
			
			if(m_listHeight > 0) m_listView.height = m_listHeight;
			else m_listView.height = 170;
		}
		
		
		
		/**
		 * 添加下拉列表显示项
		 * @param child 要加入下拉列表的子显示对象
		 */		
		public function addItem(item:ToggleButton):void
		{
			m_listView.addItem(item);
			m_group.addItem(item);
		}
		
		/**
		 * 添加下拉列表显示项到指定索引位置
		 * @param child 要加入下拉列表的子显示对象
		 * @param index 要加入的子显示对象的索引位置
		 */		
		public function addItemAt(item:ToggleButton, index:int):void
		{
			m_listView.addItemAt(item, index);
		}
		
		/**
		 * 移除下拉列表显示项
		 * @param child 要移除的子显示对象
		 */		
		public function removeItem(item:ToggleButton):void
		{
			m_listView.removeItem(item);
		}
		
		/**
		 * 移除指定索引位置的下拉列表显示项
		 * @param index 要移除的下拉列表显示项的索引位置
		 */		
		public function removeItemAt(index:int):ToggleButton
		{
			return m_listView.removeItemAt(index) as ToggleButton;
		}
		
		/**
		 * 移除所有的显示列表项，不对列表项进行释放操作。
		 */		
		public function removeAll():Array
		{
			return m_listView.removeAll();
		}
		
		/**
		 * 移除所有的显示列表项，并对列表项进行释放。
		 */		
		public function clear():void
		{
			m_listView.clear();
		}
		
		
		
		/**
		 * 获取或设置子显示对象的对齐方式。
		 * 可能的值为：ComboBox.LEFT、ComboBox.CENTER、ComboBox.RIGHT；
		 */		
		public function get listItemAlign():String
		{
			return m_listView.align;
		}
		
		/** @private */		
		public function set listItemAlign(value:String):void
		{
			if(m_listView.align != value)
			{
				m_listView.align = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * 列表项之间的间隔
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
		 * 列表项的x坐标偏移量
		 */		
		public function get listItemOffsetX():int
		{
			return m_listView.itemOffsetX;
		}
		
		/** @private */
		public function set listItemOffsetX(value:int):void
		{
			if(m_listView.itemOffsetX != value)
			{
				m_listView.itemOffsetX = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		/**
		 * 列表项的y坐标偏移量
		 */		
		public function get listItemOffsetY():int
		{
			return m_listView.itemOffsetY;
		}
		
		/** @private */
		public function set listItemOffsetY(value:int):void
		{
			if(m_listView.itemOffsetY != value)
			{
				m_listView.itemOffsetY = value;
				
				onPropertiesChanged(LISTVIEW);
			}
		}
		
		
		/**
		 * 滚动条背景图片的 BitmapData 对象
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
		 * 向上或向左按钮弹起时的显示对象资源
		 * @see jsion.display.Button#upImage
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
		 * 向上或向左按钮鼠标经过时的显示对象资源
		 * @see jsion.display.Button#overImage
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
		 * 向上或向左按钮鼠标按下时的显示对象资源
		 * @see jsion.display.Button#downImage
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
		 * 向上或向左按钮禁用时的显示对象资源
		 * @see jsion.display.Button#disableImage
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
		 * 向上或向左按钮弹起时的显示对象滤镜
		 * @see jsion.display.Button#upFilters
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
		 * 向上或向左按钮鼠标经过时的显示对象滤镜
		 * @see jsion.display.Button#overFilters
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
		 * 向上或向左按钮鼠标按下时的显示对象滤镜
		 * @see jsion.display.Button#downFilters
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
		 * 向上或向左按钮禁用时的显示对象滤镜
		 * @see jsion.display.Button#disableFilters
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
		 * 向上或向左按钮弹起时的显示对象x坐标偏移量
		 * @see jsion.display.Button#offsetX
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
		 * 向上或向左按钮弹起时的显示对象y坐标偏移量
		 * @see jsion.display.Button#offsetY
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
		 * 向上或向左按钮鼠标经过时的显示对象x坐标偏移量
		 * @see jsion.display.Button#overOffsetX
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
		 * 向上或向左按钮鼠标经过时的显示对象y坐标偏移量
		 * @see jsion.display.Button#overOffsetY
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
		 * 向上或向左按钮鼠标按下时的显示对象x坐标偏移量
		 * @see jsion.display.Button#downOffsetX
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
		 * 向上或向左按钮鼠标按下时的显示对象y坐标偏移量
		 * @see jsion.display.Button#downOffsetY
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
		 * 向下或向右按钮弹起时的显示对象资源
		 * @see jsion.display.Button#upImage
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
		 * 向下或向右按钮鼠标经过时的显示对象资源
		 * @see jsion.display.Button#overImage
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
		 * 向下或向右按钮鼠标按下时的显示对象资源
		 * @see jsion.display.Button#downImage
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
		 * 向下或向右按钮禁用时的显示对象资源
		 * @see jsion.display.Button#disableImage
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
		 * 向下或向右按钮弹起时的显示对象滤镜
		 * @see jsion.display.Button#upFilters
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
		 * 向下或向右按钮鼠标经过时的显示对象滤镜
		 * @see jsion.display.Button#overFilters
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
		 * 向下或向右按钮鼠标按下时的显示对象滤镜
		 * @see jsion.display.Button#downFilters
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
		 * 向下或向右按钮禁用时的显示对象滤镜
		 * @see jsion.display.Button#disableFilters
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
		 * 向下或向右按钮弹起时的显示对象x坐标偏移量
		 * @see jsion.display.Button#offsetX
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
		 * 向下或向右按钮弹起时的显示对象y坐标偏移量
		 * @see jsion.display.Button#offsetY
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
		 * 向下或向右按钮鼠标经过时的显示对象x坐标偏移量
		 * @see jsion.display.Button#overOffsetX
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
		 * 向下或向右按钮鼠标经过时的显示对象y坐标偏移量
		 * @see jsion.display.Button#overOffsetY
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
		 * 向下或向右按钮鼠标按下时的显示对象x坐标偏移量
		 * @see jsion.display.Button#downOffsetX
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
		 * 向下或向右按钮鼠标按下时的显示对象y坐标偏移量
		 * @see jsion.display.Button#downOffsetY
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
		 * 拖动条弹起时的显示对象资源
		 * @see jsion.display.Button#upImage
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
		 * 拖动条鼠标经过时的显示对象资源
		 * @see jsion.display.Button#overImage
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
		 * 拖动条鼠标按下时的显示对象资源
		 * @see jsion.display.Button#downImage
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
		 * 拖动条禁用时的显示对象资源
		 * @see jsion.display.Button#disableImage
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
		 * 拖动条弹起时的显示对象滤镜
		 * @see jsion.display.Button#upFilters
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
		 * 拖动条鼠标经过时的显示对象滤镜
		 * @see jsion.display.Button#overFilters
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
		 * 拖动条鼠标按下时的显示对象滤镜
		 * @see jsion.display.Button#downFilters
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
		 * 拖动条禁用时的显示对象滤镜
		 * @see jsion.display.Button#disableFilters
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
		 * 拖动条弹起时的显示对象x坐标偏移量
		 * @see jsion.display.Button#offsetX
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
		 * 拖动条弹起时的显示对象y坐标偏移量
		 * @see jsion.display.Button#offsetY
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
		 * 拖动条鼠标经过时的显示对象x坐标偏移量
		 * @see jsion.display.Button#overOffsetX
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
		 * 拖动条鼠标经过时的显示对象y坐标偏移量
		 * @see jsion.display.Button#overOffsetY
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
		 * 拖动条鼠标按下时的显示对象x坐标偏移量
		 * @see jsion.display.Button#downOffsetX
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
		 * 拖动条鼠标按下时的显示对象y坐标偏移量
		 * @see jsion.display.Button#downOffsetY
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
		 * 拖动条中间的修饰的显示对象
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
		 * 滚动值
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
		 * 要滚动的全长度
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
		 * 滚动值的最终偏移量
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
		 * 每次鼠标滚轮滚动的滚动值
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
		 * 点击按钮时的滚动值
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
		 * 长按按钮的延迟帧数 超过延迟帧时以 scrollStep 的值不停更新滚动值 scrollValue。
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
		 * 根据滚动条类型获取或设置按钮与四边的间隙
		 * <ul>
		 * 	<li>水平滚动条时，获取或设置按钮与左、右两边的间隙</li>
		 * 	<li>垂直滚动条时，获取或设置按钮与上、下两边的间隙</li>
		 * </ul>
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
			if(stage) stage.removeEventListener(MouseEvent.CLICK, __stageClickHandler);
			
			DisposeUtil.free(m_group);
			m_group = null;
			
			DisposeUtil.free(m_listView);
			m_listView = null;
			
			super.dispose();
		}
		
		/**
		 * 获取或设置是否自动选中
		 */		
		public function get autoSelected():Boolean
		{
			return m_group.autoSelected;
		}
		
		/**
		 * @private
		 */		
		public function set autoSelected(value:Boolean):void
		{
			m_group.autoSelected = value;
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