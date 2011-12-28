package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import jsion.IntRectangle;
	import jsion.comps.ASColor;
	import jsion.comps.ASFont;
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.comps.events.StateEvent;
	import jsion.utils.DisposeUtil;
	
	public class JButton extends Component
	{
		public static const UP_IMG:String = CompGlobal.UP_IMG;
		public static const OVER_IMG:String = CompGlobal.OVER_IMG;
		public static const DOWN_IMG:String = CompGlobal.DOWN_IMG;
		public static const DISABLED_IMG:String = CompGlobal.DISABLED_IMG;
		
		public static const UP_FILTERS:String = CompGlobal.UP_FILTERS;
		public static const OVER_FILTERS:String = CompGlobal.OVER_FILTERS;
		public static const DOWN_FILTERS:String = CompGlobal.DOWN_FILTERS;
		public static const DISABLED_FILTERS:String = CompGlobal.DISABLED_FILTERS;
		
		public static const LABEL_UP_FILTERS:String = CompGlobal.LABEL_UP_FILTERS;
		public static const LABEL_OVER_FILTERS:String = CompGlobal.LABEL_OVER_FILTERS;
		public static const LABEL_DOWN_FILTERS:String = CompGlobal.LABEL_DOWN_FILTERS;
		public static const LABEL_DISABLED_FILTERS:String = CompGlobal.LABEL_DISABLED_FILTERS;
		
		public static const HALIGN:String = CompGlobal.HALIGN;
		public static const LEFT:String = CompGlobal.LEFT;
		public static const RIGHT:String = CompGlobal.RIGHT;
		public static const CENTER:String = CompGlobal.CENTER;
		public static const HGAP:String = CompGlobal.HGAP;
		
		public static const VALIGN:String = CompGlobal.VALIGN;
		public static const TOP:String = CompGlobal.TOP;
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		public static const VGAP:String = CompGlobal.VGAP;
		
		
		private var m_text:String;
		
		private var m_label:JLabel;
		
		private var m_curImg:DisplayObject;
		
		private var m_curFilters:Array;
		
		private var m_curLabelFilters:Array;
		
		private var m_back:Sprite;
		
		private var m_labelRect:IntRectangle;
		
		public function JButton(label:String = "", container:DisplayObjectContainer = null, xPos:Number = 0, yPos:Number = 0)
		{
			m_text = label;
			
			m_labelRect = new IntRectangle();
			
			super(container, xPos, yPos);
		}
		
		override protected function initResources():void
		{
			setStyle(HALIGN, CompGlobal.CENTER);
			setStyle(VALIGN, CompGlobal.MIDDLE);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			buttonMode = true;
			useHandCursor = true;
		}
		
		override protected function initEvents():void
		{
			model.addEventListener(StateEvent.STATE_CHANGED, __stateChangedHandler);
		}
		
		private function __stateChangedHandler(e:StateEvent):void
		{
			invalidate();
		}
		
		public function setLabelStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			invalidate();
			return m_label.setStyle(key, value, freeBMD);
		}
		
		override protected function addChildren():void
		{
			m_back = new Sprite();
			addChild(m_back);
			
			m_label = new JLabel(m_text);
			addChild(m_label);
			
			//draw();
		}
		
		override public function draw():void
		{
			updateCurStateImage();
			updateCurStateFilters();
			updateLabelFilters();
			updateLabelAndPos();
			
			super.draw();
		}
		
		private function updateCurStateImage():void
		{
			var image:DisplayObject;
			
			var tmpImage:DisplayObject;
			
			image = getDisplayObject(UP_IMG);
			
			if(model.enabled == false)
			{
				tmpImage = getDisplayObject(DISABLED_IMG);
			}
			else if(model.pressed)
			{
				tmpImage = getDisplayObject(DOWN_IMG);
			}
			else if(model.rollOver)
			{
				tmpImage = getDisplayObject(OVER_IMG);
			}
			
			if(tmpImage != null)
			{
				image = tmpImage;
			}
			
			if(image != m_curImg)
			{
				if(m_curImg && m_curImg.parent)
					m_curImg.parent.removeChild(m_curImg);
				
				m_curImg = image;
			}
			
			if(m_curImg)
			{
				if(width > 0) m_curImg.width = width;
				if(height > 0) m_curImg.height = height;
				
				if(m_curImg is Component) Component(m_curImg).drawAtOnce();
				
				m_back.addChild(m_curImg);
			}
		}
		
		private function updateCurStateFilters():void
		{
			var filter:Array;
			var tmpFilter:Array;
			
			filter = getArray(UP_FILTERS);
			
			if(model.enabled == false)
			{
				tmpFilter = getArray(DISABLED_FILTERS);
			}
			else if(model.pressed)
			{
				tmpFilter = getArray(DOWN_FILTERS);
			}
			else if(model.rollOver)
			{
				tmpFilter = getArray(OVER_FILTERS);
			}
			
			if(tmpFilter != null)
			{
				filter = tmpFilter;
			}
			
			if(filter != m_curFilters)
			{
				if(filter == null) filter = [];
				
				m_curFilters = filter;
				
				m_back.filters = m_curFilters;
			}
		}
		
		private function updateLabelFilters():void
		{
			var filter:Array;
			var tmpFilter:Array;
			
			filter = getArray(LABEL_UP_FILTERS);
			
			if(model.enabled == false)
			{
				tmpFilter = getArray(LABEL_DISABLED_FILTERS);
			}
			else if(model.pressed)
			{
				tmpFilter = getArray(LABEL_DOWN_FILTERS);
			}
			else if(model.rollOver)
			{
				tmpFilter = getArray(LABEL_OVER_FILTERS);
			}
			
			if(tmpFilter != null)
			{
				filter = tmpFilter;
			}
			
			if(filter != m_curLabelFilters)
			{
				if(filter == null) filter = [];
				
				m_curLabelFilters = filter;
				
				m_label.textField.filters = m_curLabelFilters;
			}
		}
		
		private function updateLabelAndPos():void
		{
			m_label.text = m_text;
			m_label.drawAtOnce();

			m_labelRect.x = m_labelRect.y = 0;
			m_labelRect.width = m_label.width;
			m_labelRect.height = m_label.height;
			
			CompUtil.layoutPosition(originalWidth, originalHeight, getString(HALIGN), getInt(HGAP), getString(VALIGN), getInt(VGAP), m_labelRect);
			
			m_label.move(m_labelRect.x, m_labelRect.y);
		}
		
		public function get label():String
		{
			return m_text;
		}
		
		public function set label(value:String):void
		{
			if(m_text != value)
			{
				m_text = value;
				
				invalidate();
			}
		}
		
		override public function dispose():void
		{
			if(model) model.removeEventListener(StateEvent.STATE_CHANGED, __stateChangedHandler);
			
			DisposeUtil.free(m_back);
			m_back = null;
			
			DisposeUtil.free(m_label);
			m_label = null;
			
			m_curImg = null;
			m_curFilters = null;
			m_curLabelFilters = null;
			m_labelRect = null;
			
			super.dispose();
		}
	}
}