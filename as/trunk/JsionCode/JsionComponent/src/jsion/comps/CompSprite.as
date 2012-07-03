package jsion.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;

	/**
	 * UI框架组件的基础显示对象，实现了忽略透明像素以及对 StateModel 的状态支持。
	 * @author Jsion
	 * 
	 */	
	public class CompSprite extends JsionSprite
	{
		//========	update state model	========
		
		private var m_model:StateModel;
		
		private var m_rolloverEnabled:Boolean;
		
		//========	update state model	========
		
		
		
		
		//============  忽略透明像素  ============
		
		private var m_mousePoint:Point;
		
		private var m_bitmapForHit:Bitmap;
		
		private var m_enterFraming:Boolean;
		
		private var m_hited:Boolean;
		
		private var m_threshold:int = 128;
		
		private var m_ignoreTransparents:Boolean;
		
		//============  忽略透明像素  ============
		
		
		public function CompSprite()
		{
			super();
			
			
			m_rolloverEnabled = true;
			
			m_mousePoint = new Point();
			
			m_model = new StateModel();
			
			
			addEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
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
		
		
		
		//==================================================		update state model			==================================================
		
		/**
		 * 状态
		 */		
		public function get model():StateModel
		{
			return m_model;
		}
		
		/** @private */		
		public function set model(value:StateModel):void
		{
			m_model = value;
		}
		
		/**
		 * 是否允许鼠标经过状态
		 */		
		public function get rolloverEnabled():Boolean
		{
			return m_rolloverEnabled;
		}
		
		/** @private */
		public function set rolloverEnabled(value:Boolean):void
		{
			m_rolloverEnabled = value;
		}
		
		/**
		 * 检测鼠标是否碰撞到本对象
		 */		
		public function hitTestMouse():Boolean
		{
			if(stage)
				return hitTestPoint(stage.mouseX, stage.mouseY);
			
			return false;
		}
		
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
		
		/**
		 * 是否启用忽略透明像素碰撞
		 */		
		public function get ignoreTransparents():Boolean
		{
			return m_ignoreTransparents;
		}
		
		/** @private */
		public function set ignoreTransparents(value:Boolean):void
		{
			if(m_ignoreTransparents != value)
			{
				m_ignoreTransparents = value;
				
				redrawBitmapHit();
				
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
		
		/**
		 * 忽略透明像素阀值(0-255)
		 */		
		public function get threshold():int
		{
			return m_threshold;
		}
		
		/** @private */
		public function set threshold(value:int):void
		{
			m_threshold = Math.min(value, 255);
		}
		
		private function activateMouseTrap():void
		{
			addEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent, false, int.MAX_VALUE);
		}
		
		private function deactivateMouseTrap():void
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
		
		private function bitmapHitTest():Boolean
		{
			if(m_bitmapForHit == null) drawBitmapHit();
			
			m_mousePoint.x = m_bitmapForHit.mouseX;
			m_mousePoint.y = m_bitmapForHit.mouseY;
			
			return m_bitmapForHit.bitmapData.hitTest(CompGlobal.ZeroPoint, m_threshold, m_mousePoint);
		}
		
		private function drawBitmapHit():void
		{
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			var b:Rectangle = new Rectangle(0, 0, width, height);
			
			if(b.width <= 0 || b.height <= 0) return;
			
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
		
		protected function redrawBitmapHit():void
		{
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			if(m_ignoreTransparents) drawBitmapHit();
		}
		
		//==============================================		忽略透明像素			==============================================
		
		override public function dispose():void
		{
			DisposeUtil.free(m_model);
			m_model = null;
			
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			m_mousePoint = null;
			
			super.dispose();
		}
	}
}