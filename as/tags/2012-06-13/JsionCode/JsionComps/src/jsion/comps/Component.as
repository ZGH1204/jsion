package jsion.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.comps.events.ReleaseEvent;
	import jsion.comps.events.UIEvent;
	import jsion.utils.DisposeUtil;
	
	[Event(name="dataChanged", type="jsion.comps.events.UIEvent")]
	public class Component extends ComSprite implements ITip
	{
		public static const FONT:String = CompGlobal.FONT;
		
		public static const COLOR:String = CompGlobal.COLOR;
		
		private var m_mousePoint:Point = new Point();
		
		private var m_bitmapForHit:Bitmap;
		
		private var m_enterFraming:Boolean;
		
		private var m_hited:Boolean;
		
		private var m_threshold:int = 128;
		
		private var m_model:StateModel;
		
		private var m_rolloverEnabled:Boolean;
		
		private var m_ignoreTransparents:Boolean;
		
		private var m_resources:CompResources;
		
		private var m_data:Object = null;
		
//		private var m_font:ASFont;
//		
//		private var m_color:ASColor;
		
		public function Component(container:DisplayObjectContainer = null, xPos:Number = 0, yPos:Number = 0)
		{
			super();
			
			m_rolloverEnabled = true;
			
			m_model = new StateModel();
			
			m_resources = new CompResources();
			
			move(xPos, yPos);
			
			addEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			
			initialize();
			
			initResources();
			
			initEvents();
			
			//pack();
			
			if(container) container.addChild(this);
		}
		
		protected function initResources():void
		{
		}
		
		protected function initialize():void
		{
			addChildren();
			invalidate();
		}
		
		protected function initEvents():void
		{
		}
		
		protected function addChildren():void
		{
		}
		
		
		
		public function setStyle(key:String, value:*, freeBMD:Boolean = true):Object
		{
			invalidate();
			return m_resources.setStyle(key, value, freeBMD);
		}
		
		public function getBoolean(key:String):Boolean
		{
			return m_resources.getBoolean(key);
		}
		
		public function getNumber(key:String):Number
		{
			return m_resources.getNumber(key);
		}
		
		public function getInt(key:String):int
		{
			return m_resources.getInt(key);
		}
		
		public function getUint(key:String):uint
		{
			return m_resources.getUint(key);
		}
		
		public function getString(key:String):String
		{
			return m_resources.getString(key);
		}
		
		public function getArray(key:String):Array
		{
			return m_resources.getArray(key);
		}
		
		public function getFont(key:String):ASFont
		{
			return m_resources.getFont(key);
		}
		
		public function getColor(key:String):ASColor
		{
			return m_resources.getColor(key);
		}
		
		public function getDisplayObject(key:String):DisplayObject
		{
			return m_resources.getDisplayObject(key);
		}
		
		
		protected function safeDrawAtOnceByDisplay(display:DisplayObject):void
		{
			if(display != null && display is Component)
			{
				Component(display).drawAtOnce();
			}
		}
		
		
		
		
		public function getData():*
		{
			return m_data;
		}
		
		public function setData(data:*):void
		{
			if(m_data != data)
			{
				m_data = data;
				
				dispatchEvent(new UIEvent(UIEvent.DATA_CHANGED));
			}
		}
		
//		public function get font():ASFont
//		{
//			return m_font;
//		}
//		
//		public function set font(value:ASFont):void
//		{
//			m_font = value;
//			invalidate();
//		}
//		
//		public function get color():ASColor
//		{
//			return m_color;
//		}
//		
//		public function set color(value:ASColor):void
//		{
//			m_color = value;
//			invalidate();
//		}
		
		public function get model():StateModel
		{
			return m_model;
		}
		
		public function set model(value:StateModel):void
		{
			m_model = value;
		}
		
		public function get threshold():int
		{
			return m_threshold;
		}
		
		public function set threshold(value:int):void
		{
			m_threshold = Math.min(value, 255);
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if(m_model.rollOver && value == false)
			{
				m_model.rollOver = false;
			}
			
			m_model.enabled = value;
		}
		
		public function get rolloverEnabled():Boolean
		{
			return m_rolloverEnabled;
		}
		
		public function set rolloverEnabled(value:Boolean):void
		{
			m_rolloverEnabled = value;
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
		
		public function get realWidth():Number
		{
			return width > 0 ? width : originalWidth;
		}
		
		public function get realHeight():Number
		{
			return height > 0 ? height : originalHeight;
		}
		
		public function hitTestMouse():Boolean
		{
			if(stage)
				return hitTestPoint(stage.mouseX, stage.mouseY);
			
			return false;
		}
		
		//==================================================		update state model			==================================================
		
		private function __rollOverHandler(e:MouseEvent):void
		{
			if(rolloverEnabled)
			{
				if(m_model.pressed || !e.buttonDown)
				{
					m_model.rollOver = true;
				}
			}
			
			if(m_model.pressed) m_model.armed = true;
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			if(rolloverEnabled && hitTestMouse())
			{
				m_model.rollOver = true;
			}
		}
		
		private function __rollOutHandler(e:MouseEvent):void
		{
			if(rolloverEnabled)
			{
				if(m_model.pressed == false)
				{
					m_model.rollOver = false;
				}
			}
			
			m_model.armed = false;
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			m_model.armed = true;
			m_model.pressed = true;
		}
		
		private function __releaseHandler(e:ReleaseEvent):void
		{
			m_model.pressed = false;
			m_model.armed = false;
			
			if(rolloverEnabled && !hitTestMouse())
			{
				m_model.rollOver = false;
			}
		}
		
		//==================================================		update state model			==================================================
		
		
		//==============================================		忽略透明像素			==============================================
		
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
			if(m_model && m_model.rollOver == false && bitmapHitTest())
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
					
					if(m_model.rollOver == false)
					{
						dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
						dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
					}
				}
				else
				{
					mouseEnabled = false;
					
					buttonMode = false;
					
					if(m_model.rollOver)
					{
						dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
						dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
					}
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
			
			return m_bitmapForHit.bitmapData.hitTest(CompGlobal.ZeroPoint, m_threshold, m_mousePoint);
		}
		
		protected function reDrawBitmapHit():void
		{
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			if(m_ignoreTransparents) drawBitmapHit();
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
		
		//==============================================		忽略透明像素			==============================================
		
		
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
			removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
			
			deactivateMouseTrap();
			
			DisposeUtil.free(m_model);
			m_model = null;
			
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			DisposeUtil.free(m_resources);
			m_resources = null;
			
			m_mousePoint = null;
			
			m_data = null;
			
//			m_font = null;
//			
//			m_color = null;
			
			super.dispose();
		}
	}
}

