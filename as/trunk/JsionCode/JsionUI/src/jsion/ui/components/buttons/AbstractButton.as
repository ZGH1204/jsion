package jsion.ui.components.buttons
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.ui.Component;
	import jsion.ui.IComponentUI;
	import jsion.ui.IICON;
	import jsion.ui.UIConstants;
	import jsion.ui.events.ButtonEvent;
	import jsion.ui.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;
	
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
			mouseChildren = false;
			
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
		
		override public function get stopPropagation():Boolean
		{
			return true;
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
			addEventListener(MouseEvent.CLICK, __clickHandler);
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
		private function __clickHandler(e:MouseEvent):void
		{
			if(stopPropagation)
			{
				e.stopPropagation();
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
		
		
		
		
		
		
		
		
		
		
		protected function activateMouseTrap():void
		{
			addEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent, false, int.MAX_VALUE);
		}
		
		protected function deactivateMouseTrap():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent);
			removeEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent);
		}
		
		private var m_mousePoint:Point = new Point();
		
		private var m_bitmapForHit:Bitmap;
		
		private var m_enterFraming:Boolean;
		
		private var m_hited:Boolean;
		
		private var m_threshold:int = 128;
		
		private var m_ignoreTransparents:Boolean;
		
		override public function set UI(value:IComponentUI):void
		{
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			super.UI = value;
		}
		
		public function get alphaTolerance():uint
		{
			return m_threshold;
		}
		
		public function set alphaTolerance(value:uint):void
		{
			m_threshold = Math.min(255, value);
		}
		
		public function get ignoreTransparents():Boolean
		{
			return m_ignoreTransparents;
		}
		
		public function set ignoreTransparents(value:Boolean):void
		{
			if(m_ignoreTransparents != value)
			{
				m_ignoreTransparents = value;
				
				DisposeUtil.free(m_bitmapForHit);
				m_bitmapForHit = null;
				
				if(m_ignoreTransparents)
				{
					m_hited = false;
					m_enterFraming = false;
					mouseEnabled = true;
					
					buttonMode = false;
					
					activateMouseTrap();
				}
				else
				{
					deactivateMouseTrap();
					removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
					removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				}
			}
		}
		
		private function __captureMouseEvent(e:MouseEvent):void
		{
			if(m_enterFraming == false && (e.type == MouseEvent.MOUSE_OVER || e.type == MouseEvent.ROLL_OVER))
			{
				m_enterFraming = true;
				mouseEnabled = false;
				addEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				__trackMouseWhileInBounds();
				addEventListener(MouseEvent.MOUSE_UP, __upHandler);
			}
			
			if(!m_hited)
			{
				//trace("stopImmediatePropagation", e.type);
				e.stopImmediatePropagation();
			}
		}
		
		private function __upHandler(e:MouseEvent):void
		{
			if(model && model.rollOver == false && bitmapHitTest())
			{
				m_hited = true;
				buttonMode = true;
				mouseEnabled = true;
				deactivateMouseTrap();
				dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
			}
		}
		
		private function __trackMouseWhileInBounds(e:Event = null):void
		{
			if(bitmapHitTest() != m_hited)
			{
				m_hited = !m_hited;
				
				if(m_hited)
				{
					buttonMode = true;
					mouseEnabled = true;
					deactivateMouseTrap();
				}
				else
				{
					mouseEnabled = false;
					
					buttonMode = false;
				}
			}
			
			var globalPoint:Point = m_bitmapForHit.localToGlobal(m_mousePoint);
			if(hitTestPoint(globalPoint.x, globalPoint.y) == false)
			{
				removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
				removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				m_enterFraming = false;
				mouseEnabled = true;
				activateMouseTrap();
			}
		}
		
		protected function bitmapHitTest():Boolean
		{
			if(m_bitmapForHit == null) drawBitmapHit();
			
			m_mousePoint.x = m_bitmapForHit.mouseX;
			m_mousePoint.y = m_bitmapForHit.mouseY;
			
			return m_bitmapForHit.bitmapData.hitTest(Constant.ZeroPoint, m_threshold, m_mousePoint);
		}
		
		protected function drawBitmapHit():void
		{
			if(m_bitmapForHit)
			{
				DisposeUtil.free(m_bitmapForHit);
			}
			
			var b:Rectangle = getBounds(this);
			
			var bmd:BitmapData = new BitmapData(b.width, b.height, true, 0);
			var mx:Matrix = new Matrix();
			mx.translate(-b.left, -b.top);
			bmd.draw(this);
			
			m_bitmapForHit = new Bitmap(bmd);
			m_bitmapForHit.visible = false;
			addChild(m_bitmapForHit);
			m_bitmapForHit.x = b.left;
			m_bitmapForHit.y = b.top;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		override public function dispose():void
		{
			deactivateMouseTrap();
			
			removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
			removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
			
			removeEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			m_mousePoint = null;
			
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