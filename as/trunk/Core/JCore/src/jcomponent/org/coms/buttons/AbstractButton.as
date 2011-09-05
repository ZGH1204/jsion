package jcomponent.org.coms.buttons
{
	import flash.events.MouseEvent;
	
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IICON;
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.events.ButtonEvent;
	import jcomponent.org.events.ReleaseEvent;
	
	import jutils.org.util.DisposeUtil;
	
	public class AbstractButton extends Component
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		protected var m_model:IButtonModel;
		
		protected var m_text:String;
		
		protected var m_verticalTextAlginment:int;
		protected var m_horizontalTextAlginment:int;
		
		protected var m_rolloverEnabled:Boolean
		
		private var m_textFilters:Array;
		
		private var m_upFilters:Array;
		private var m_overFilters:Array;
		private var m_downFilters:Array;
		private var m_disabledFilters:Array;
		private var m_selectedFilters:Array;
		private var m_overSelectedFilters:Array;
		private var m_downSelectedFilters:Array;
		private var m_disabledSelectedFilters:Array;
		
		
		private var m_textHGap:int = 0;
		private var m_textVGap:int = 0;
		
		private var m_iconHGap:int = 0;
		private var m_iconVGap:int = 0;
		
		protected var m_iconDir:int;
		
		protected var m_icon:IICON;
		
		public function AbstractButton(text:String = null, prefix:String = null, id:String = null)
		{
			super(prefix, id);
			
			m_iconDir = LEFT;
			
			m_verticalTextAlginment = MIDDLE;
			m_horizontalTextAlginment = CENTER;
			
			m_text = text;
			if(m_text == null) m_text = "";
			
			buttonMode = true;
			
			m_rolloverEnabled = true;
			
			initSelfEvent();
		}
		
		public function get text():String
		{
			return m_text;
		}
		
		public function set text(value:String):void
		{
			if(m_text != value)
			{
				m_text = value;
				
				if(m_text == null) m_text = "";
				
				invalidate();
			}
		}
		
		public function get verticalTextAlginment():int
		{
			return m_verticalTextAlginment;
		}
		
		public function set verticalTextAlginment(value:int):void
		{
			if(m_verticalTextAlginment != value)
			{
				m_verticalTextAlginment = value;
				
				invalidate();
			}
		}
		
		public function get horizontalTextAlginment():int
		{
			return m_horizontalTextAlginment;
		}
		
		public function set horizontalTextAlginment(value:int):void
		{
			if(m_horizontalTextAlginment != value)
			{
				m_horizontalTextAlginment = value;
				
				invalidate();
			}
		}

		public function get model():IButtonModel
		{
			return m_model;
		}

		public function set model(value:IButtonModel):void
		{
			if(value == model) return;
			
			var old:IButtonModel = model;
			
			if(old)
			{
				old.removeActionListener(__modelActionHandler);
				old.removeSelectionListener(__modelSelectionHandler);
				old.removeStateListener(__modelStateHandler);
			}
			
			m_model = value;
			
			if(m_model)
			{
				m_model.addActionListener(__modelActionHandler);
				m_model.addSelectionListener(__modelSelectionHandler);
				m_model.addStateListener(__modelStateHandler);
			}
			
			invalidate();
		}
		
		override public function set enabled(value:Boolean):void
		{
			if(value == false && model.rollOver)
			{
				model.rollOver = false;
			}
			
			super.enabled = value;
			model.enabled = value;
		}
		
		public function get selected():Boolean
		{
			return model.selected;
		}
		
		public function set selected(value:Boolean):void
		{
			model.selected = value;
		}
		
		public function get rolloverEnabled():Boolean
		{
			return m_rolloverEnabled;
		}
		
		public function set rolloverEnabled(value:Boolean):void
		{
			m_rolloverEnabled = value;
		}
		
		public function get textFilters():Array
		{
			return m_textFilters;
		}
		
		public function set textFilters(value:Array):void
		{
			if(m_textFilters != value)
			{
				m_textFilters = value;
				
				invalidate();
			}
		}
		
		public function get upFilters():Array
		{
			return m_upFilters;
		}
		
		public function set upFilters(value:Array):void
		{
			if(m_upFilters != value)
			{
				m_upFilters = value;
				
				invalidate();
			}
		}
		
		public function get overFilters():Array
		{
			return m_overFilters;
		}
		
		public function set overFilters(value:Array):void
		{
			if(m_overFilters != value)
			{
				m_overFilters = value;
				
				invalidate();
			}
		}
		
		public function get downFilters():Array
		{
			return m_downFilters;
		}
		
		public function set downFilters(value:Array):void
		{
			if(m_downFilters != value)
			{
				m_downFilters = value;
				
				invalidate();
			}
		}
		
		public function get disabledFilters():Array
		{
			return m_disabledFilters;
		}
		
		public function set disabledFilters(value:Array):void
		{
			if(m_disabledFilters != value)
			{
				m_disabledFilters = value;
				
				invalidate();
			}
		}
		
		public function get selectedFilters():Array
		{
			return m_selectedFilters;
		}
		
		public function set selectedFilters(value:Array):void
		{
			if(m_selectedFilters != value)
			{
				m_selectedFilters = value;
				
				invalidate();
			}
		}
		
		public function get overSelectedFilters():Array
		{
			return m_overSelectedFilters;
		}
		
		public function set overSelectedFilters(value:Array):void
		{
			if(m_overSelectedFilters != value)
			{
				m_overSelectedFilters = value;
				
				invalidate();
			}
		}
		
		public function get downSelectedFilters():Array
		{
			return m_downSelectedFilters;
		}
		
		public function set downSelectedFilters(value:Array):void
		{
			if(m_downSelectedFilters != value)
			{
				m_downSelectedFilters = value;
				
				invalidate();
			}
		}
		
		public function get disabledSelectedFilters():Array
		{
			return m_disabledSelectedFilters;
		}
		
		public function set disabledSelectedFilters(value:Array):void
		{
			if(m_disabledSelectedFilters != value)
			{
				m_disabledSelectedFilters = value;
				
				invalidate();
			}
		}
		
		public function get textHGap():int
		{
			return m_textHGap;
		}
		
		public function set textHGap(value:int):void
		{
			if(m_textHGap != value)
			{
				m_textHGap = value;
				
				invalidate();
			}
		}
		
		public function get iconHGap():int
		{
			return m_iconHGap;
		}
		
		public function set iconHGap(value:int):void
		{
			if(m_iconHGap != value)
			{
				m_iconHGap = value;
				
				invalidate();
			}
		}
		
		public function get iconDir():int
		{
			return m_iconDir;
		}
		
		public function get textVGap():int
		{
			return m_textVGap;
		}
		
		public function set textVGap(value:int):void
		{
			m_textVGap = value;
		}
		
		public function get iconVGap():int
		{
			return m_iconVGap;
		}
		
		public function set iconVGap(value:int):void
		{
			m_iconVGap = value;
		}
		
		public function get icon():IICON
		{
			return m_icon;
		}
		
		public function set icon(value:IICON):void
		{
			if(m_icon != value)
			{
				uninstallIcon(m_icon);
				
				m_icon = value;
				
				installIcon(m_icon);
				
				invalidate();
			}
		}
		
		protected function installIcon(ic:IICON):void
		{
			if(ic && ic.getDisplay(this))
			{
				addChild(ic.getDisplay(this));
			}
		}
		
		protected function uninstallIcon(ic:IICON):void
		{
			DisposeUtil.free(ic);
		}
		
//		override public function setSizeWH(w:int, h:int):void
//		{
//			var min:IntDimension = getMinimumSize();
//			var max:IntDimension = getMaximumSize();
//			
//			if(w < min.width) w = min.width;
//			if(h < min.height) h = min.height;
//			
//			if(w > max.width) w = max.width;
//			if(h > max.height) h = max.height;
//			
//			super.setSizeWH(w, h);
//		}
		
		public function initSelfEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
		}
		
		private function __rollOverHandler(e:MouseEvent):void
		{
			var m:IButtonModel = model;
			
			if(rolloverEnabled)
			{
				if(m.pressed || !e.buttonDown)
				{
					m.rollOver = true;
				}
			}
			
			if(m.pressed) m.armed = true;
		}
		
		private function __rollOutHandler(e:MouseEvent):void
		{
			var m:IButtonModel = model;
			
			if(rolloverEnabled)
			{
				if(m.pressed == false)
				{
					m.rollOver = false;
				}
			}
			
			m.armed = false;
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			model.armed = true;
			model.pressed = true;
		}
		
		private function __releaseHandler(e:ReleaseEvent):void
		{
			model.pressed = false;
			model.armed = false;
			
			if(rolloverEnabled && !hitTestMouse())
			{
				model.rollOver = false;
			}
		}
		
		private function __modelActionHandler(e:ButtonEvent):void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.ACTION));
		}
		
		private function __modelStateHandler(e:ButtonEvent):void
		{
			invalidate();
			
			dispatchEvent(new ButtonEvent(ButtonEvent.STATE_CHANGED));
		}
		
		private function __modelSelectionHandler(e:ButtonEvent):void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.SELECTION_CHANGED));
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			
			DisposeUtil.free(m_icon);
			m_icon = null;
			
			if(m_model)
			{
				m_model.removeActionListener(__modelActionHandler);
				m_model.removeSelectionListener(__modelSelectionHandler);
				m_model.removeStateListener(__modelStateHandler);
			}
			DisposeUtil.free(m_model);
			m_model = null;
			
			m_text = null;
			m_textFilters = null;
			m_upFilters = null;
			m_overFilters = null;
			m_downFilters = null;
			m_disabledFilters = null;
			m_selectedFilters = null;
			m_overSelectedFilters = null;
			m_downSelectedFilters = null;
			m_disabledSelectedFilters = null;
			
			super.dispose();
		}

	}
}