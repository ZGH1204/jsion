package jui.org
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sampler.getSize;
	import flash.utils.getTimer;
	
	import jui.org.brushs.TransparentBrush;
	import jui.org.events.ClickCountEvent;
	import jui.org.events.JEvent;
	import jui.org.events.MovedEvent;
	import jui.org.events.ResizedEvent;
	
	import jutils.org.util.AppDomainUtil;
	import jutils.org.util.InstanceUtil;
	import jutils.org.util.NameUtil;
	import jutils.org.util.ReflectionUtil;
	import jutils.org.util.StringUtil;
	
	[Event(name="resized", type="org.aswing.event.ResizedEvent")]
	
	[Event(name="moved", type="jui.org.events.MovedEvent")]
	
	[Event(name="clickCount", type="jui.org.events.ClickCountEvent")]
	
	[Event(name="shown", type="jui.org.events.JEvent")]
	
	[Event(name="hidden", type="jui.org.events.JEvent")]
	
	public class Component extends JSprite
	{
		protected var ui:IComponentUI;
		
		protected var foregroundProvider:ICanUpdateProvider;
		protected var backgroundProvider:ICanUpdateProvider;
		
		protected var bounds:IntRectangle;
		
		public function Component()
		{
			super();
			
			setName("Component");
			
			ui = null;
			
			bounds = new IntRectangle();
			
			font = DefaultResource.DEFAULT_FONT;
			background = DefaultResource.DEFAULT_BACKGROUND_COLOR;
			foreground = DefaultResource.DEFAULT_FOREGROUND_COLOR;
			mideground = DefaultResource.DEFAULT_MIDEGROUND_COLOR;
			
			styleTune = DefaultResource.DEFAULT_STYLE_TUNE;
			
			addEventListener(MouseEvent.CLICK, __mouseClickHandler);
		}
		
		
		
		
		
		//=======================================
		/*
		* Causes this component to be sized to fit the preferred size.
		*/
		//=======================================
		
		public function pack():void
		{
			setSize(getPreferredSize());
		}
		
		
		
		//=======================================
		/*
		* Causes this component to be sized to fit the preferred size.
		*/
		//=======================================
		
		public function getName():String
		{
			return name;
		}
		
		public function setName(value:String):void
		{
			name = value;
		}
		
		
		
		//=======================================
		/*
		* Create component's UIColorAdjuster.
		*/
		//=======================================
		
		protected var styleTune:StyleTune;
		
		public function getStyleTune():StyleTune
		{
			if(styleTune != null && styleTune != DefaultResource.NULL_STYLE_TUNE)
			{
				return styleTune;
			}
			else if(getStyleProxy() != null)
			{
				return getStyleProxy().getStyleTune();
			}
			else
			{
				return DefaultResource.NULL_STYLE_TUNE;
			}
		}
		
		public function setStyleTune(c:StyleTune):void
		{
			if(styleTune != c)
			{
				styleTune = c;
				repaint();
			}
		}
		
		
		
		
		
		//=======================================
		/*
		* Gound colors.
		*/
		//=======================================
		
		private var foreground:JColor;
		private var mideground:JColor;
		private var background:JColor;
		
		public function getForeground():JColor
		{
			if(foreground != null && foreground != DefaultResource.NULL_COLOR)
			{
				return foreground;
			}
			else if(getStyleProxy() != null)
			{
				return getStyleProxy().getForeground();
			}
			else
			{
				return DefaultResource.NULL_COLOR;
			}
		}
		
		public function setForeground(c:JColor):void
		{
			if(foreground != c)
			{
				foreground = c;
				repaint();
			}
		}
		
		public function getBackground():JColor
		{
			if(background != null && background != DefaultResource.NULL_COLOR)
			{
				return background;
			}
			else if(getStyleProxy() != null)
			{
				return getStyleProxy().getBackground();
			}
			else
			{
				return DefaultResource.NULL_COLOR;
			}
		}
		
		public function setBackground(c:JColor):void
		{
			if(background != c)
			{
				background = c;
				repaint();
			}
		}
		
		public function getMideground():JColor
		{
			if(mideground != null && mideground != DefaultResource.NULL_COLOR)
			{
				return mideground;
			}
			else if(getStyleProxy() != null)
			{
				return getStyleProxy().getMideground();
			}
			else
			{
				return DefaultResource.NULL_COLOR;
			}
		}
		
		public function setMideground(c:JColor):void
		{
			if(mideground != c)
			{
				mideground = c;
				repaint();
			}
		}
		
		
		
		
		//=======================================
		/*
		* Component's font property.
		*/
		//=======================================
		
		protected var font:JFont;
		
		protected var fontValidated:Boolean;
		
		public function setFont(newFont:JFont):void
		{
			if(font != newFont)
			{
				font = newFont;
				
				if(font != null && !font.isFullFeatured())
				{
					throw new Error("Cannot set a non-full-featured font, try supplyFont() instead.");
				}
				
				setFontValidated(false);
				
				repaint();
				
				revalidate();
			}
		}
		
		public function supplyFont(newFont:JFont):void
		{
			if(null == newFont)
			{
				return;
			}
			
			if(font != newFont)
			{
				setFont(newFont.takeover(font));
			}
		}
		
		public function isFontValidated():Boolean
		{
			return fontValidated;
		}
		
		public function setFontValidated(b:Boolean):void
		{
			fontValidated = b;
		}
		
		public function getFont():JFont
		{
			if (font != null && font != DefaultResource.NULL_FONT)
			{
				return font;
			}
			else if(getStyleProxy() != null)
			{
				return getStyleProxy().getFont();
			}
			else
			{
				return DefaultResource.NULL_FONT;
			}
		}
		
		
		
		
		
		
		
		//=======================================
		/*
		* The font、background、mideground、foreground proxy for this component.
		*/
		//=======================================
		
		protected var styleProxy:Component;
		
		public function getStyleProxy():Component
		{
			if(styleProxy != null)
			{
				return styleProxy;
			}
			else if(getParent() != null)
			{
				return getParent();
			}
			else if(parent is Component)
			{
				return Component(parent);
			}
			else
			{
				return null;
			}
		}
		
		public function setStyleProxy(proxy:Component):void
		{
			styleProxy = proxy;
		}
		
		
		
		
		
		
		
		//=======================================
		/*
		* Change component's foreground and background provider.
		*/
		//=======================================
		
		protected var uiClassID:String;
		
		public function getUI():IComponentUI
		{
			return ui;
		}
		
		public function setUI(newUI:IComponentUI):void
		{
			if (ui != null)
			{
				ui.uninstallUI(this);
			}
			
			ui = newUI;
			
			if (ui != null)
			{
				ui.installUI(this);
			}
			
			revalidate();
			
			repaint();
		}
		
		public function getUIClassID():String
		{
			if(StringUtil.isNotNullOrEmpty(uiClassID)) return uiClassID;
			
			return getDefaultUIClassID();
		}
		
		public function setUIClassID(id:String):void
		{
			if(id != getUIClassID())
			{
				uiClassID = id;
				updateUI();
			}
		}
		
		public function getDefaultBasicUIClass():Class
		{
			return null;
		}
		
		protected function updateUI():void
		{
			
		}
		
		protected function getDefaultUIClassID():String
		{
			return null;
		}
		
		
		
		
		
		
		//=======================================
		/*
		* Change component's foreground and background provider.
		*/
		//=======================================
		
		public function setForegroundProvider(fg:ICanUpdateProvider):void
		{
			if(fg != foregroundProvider)
			{
				var old:* = foregroundProvider;
				
				foregroundProvider = fg;
				
				if(fg != null)
				{
					setForegroundChild(fg.getDisplay(this));
				}
				else
				{
					setForegroundChild(null);
				}
			}
		}
		
		public function setBackgroundProvider(bg:ICanUpdateProvider):void
		{
			if(bg != backgroundProvider)
			{
				var old:* = backgroundProvider;
				backgroundProvider = bg;
				if(bg != null)
				{
					setBackgroundChild(bg.getDisplay(this));
				}
				else
				{
					setBackgroundChild(null);
				}
			}
		}
		
		
		
		
		
		
		
		//=======================================
		/*
		* Component validate operations.
		*/
		//=======================================
		
		protected var validated:Boolean;
		
		public function isValidated():Boolean
		{
			return validated;
		}
		
		public function revalidate():void
		{
			invalidate();
			RepaintMgr.Instance.addValidate(this);
		}
		
		internal function validate():void
		{
			if(!validated)
			{
				validated = true;
			}
		}
		
		protected function invalidate():void
		{
			validated = false;
			invalidateParent();
		}
		
		protected function invalidateParent():void
		{
			var p:Container = getParent();
			if(p != null && p.isValidated()) p.invalidate();
		}
		
		
		
		
		
		
		//=======================================
		/*
		* Component's repaint.
		*/
		//=======================================
		
		protected var readyToPaint:Boolean;
		
		public function isReadyToPaint():Boolean
		{
			return readyToPaint;
		}
		
		public function repaint():void
		{
			if(isVisible() && isReadyToPaint())
			{
				RepaintMgr.Instance.addRepaint(this);
			}
		}
		
		internal function paintComponent():void
		{
			if(isVisible() && isReadyToPaint())
			{
				paint(bounds);
			}
		}
		
		protected function paint(bound:IntRectangle):void
		{
			var g:Graphics2D = new Graphics2D(graphics);
			
			paintTransparentTrigger(bound, g);
			
			if(backgroundProvider)
			{
				backgroundProvider.update(this, g, bound.clone());
			}
			
			if(ui != null)
			{
				ui.paint(this, g, bound.clone());
			}
			
			if(foregroundProvider)
			{
				foregroundProvider.update(this, g, bound.clone());
			}
		}
		
		
		
		
		
		
		//=======================================
		/*
		* Component's transparent trigger draw operation.
		*/
		//=======================================
		
		private static const Default_Trigger_Brush:IBrush = new TransparentBrush();
		private var transparentTriggerDrawn:Boolean = false;
		private var drawTransparentTrigger:Boolean = true;
		
		internal function checkDrawTransparentTrigger():void
		{
			var need:Boolean = isNeedDrawTransparentTrigger();
			if(need != transparentTriggerDrawn)
			{
				repaint();
			}
		}
		
		protected function paintTransparentTrigger(bound:IntRectangle, g:Graphics2D):void
		{
			g.clear();
			
			if(isNeedDrawTransparentTrigger())
			{
				g.fillRect(Default_Trigger_Brush, bound.x, bound.y, bound.width, bound.height);
				transparentTriggerDrawn = true;
			}
			else
			{
				transparentTriggerDrawn = false;
			}
		}
		
		protected function isNeedDrawTransparentTrigger():Boolean
		{
			if(!isEnabled() || !drawTransparentTrigger) return false;
			
			return true;
		}
		
		
		
		//=======================================
		/*
		* Component's container.
		*/
		//=======================================
		
		internal var container:Container;
		
		public function getParent():Container
		{
			return container;
		}
		
		internal function getParentRoot():Component
		{
			var r:Component = null;
			var i:Component;
			
			for(i = this; i != null; i = i.getParent())
			{
				if(i.container == null && stage != null)
				{
					r = i;
					break;
				}
			}
			
			return r;
		}
		
		
		
		//=======================================
		/*
		* Set component's enabled property.
		*/
		//=======================================
		
		protected var enabled:Boolean;
		
		public function setEnabled(b:Boolean):void
		{
			if(enabled != b)
			{
				enabled = b;
				mouseEnabled = b;
				repaint();
			}
		}
		
		public function isEnabled():Boolean
		{
			return enabled;
		}
		
		
		
		//=======================================
		/*
		* Set component's bound operation.
		*/
		//=======================================
		
		public function setBounds(b:IntRectangle):void
		{
			setLocationXY(b.x, b.y);
			setSizeWH(b.width, b.height);
		}
		
		
		
		
		
		
		//=======================================
		/*
		* Get and change component's position operation.
		*/
		//=======================================
		
		override public function get x():Number
		{
			return getX();
		}
		
		override public function set x(value:Number):void
		{
			setX(value);
		}
		
		override public function get y():Number
		{
			return getY();
		}
		
		override public function set y(value:Number):void
		{
			setY(value);
		}
		
		public function getX():int
		{
			return bounds.x;
		}
		
		public function setX(value:int):void
		{
			setLocationXY(value, getY());
		}
		
		public function getY():int
		{
			return bounds.y;
		}
		
		public function setY(value:int):void
		{
			setLocationXY(getX(), value);
		}
		
		public function setLocationXY(x:int, y:int):void
		{
			setLocation(new IntPoint(x, y));
		}
		
		public function setLocation(newPos:IntPoint):void
		{
			var oldPos:IntPoint = bounds.getLocation();
			if(!newPos.equals(oldPos))
			{
				bounds.setLocation(newPos);
				locate();
				dispatchEvent(new MovedEvent(MovedEvent.MOVED, oldPos, newPos));
			}
		}
		
		public function setGlobalLocation(gp:IntPoint):void
		{
			var newPos:Point = parent.globalToLocal(new Point(gp.x, gp.y));
			
			setLocationXY(newPos.x, newPos.y);
		}
		
		public function setGlobalLocationXY(x:int, y:int):void
		{
			setGlobalLocation(new IntPoint(x, y));
		}
		
		protected function locate():void
		{
			var _x:int = getX();
			var _y:int = getY();
			
			d_x = _x;
			d_y = _y;
		}
		
		protected function set d_x(value:Number):void
		{
			super.x = value;
		}
		
		protected function set d_y(value:Number):void
		{
			super.y = value;
		}
		
		
		
		
		
		
		
		
		//=======================================
		/*
		* Get and change component's size operation.
		*/
		//=======================================
		
		override public function get width():Number
		{
			return getWidth();
		}
		
		override public function set width(value:Number):void
		{
			setWidth(value);
		}
		
		override public function get height():Number
		{
			return getHeight();
		}
		
		override public function set height(value:Number):void
		{
			setHeight(value);
		}
		
		public function getWidth():int
		{
			return bounds.width;
		}
		
		public function setWidth(value:int):void
		{
			setSizeWH(value, getHeight());
		}
		
		public function getHeight():int
		{
			return bounds.height;
		}
		
		public function setHeight(value:int):void
		{
			setSizeWH(getWidth(), value);
		}
		
		public function setSizeWH(w:int, h:int):void
		{
			setSize(new IntDimension(w, h));
		}
		
		public function getSize(rv:IntDimension = null):IntDimension
		{
			if(rv != null)
			{
				rv.setSizeWH(bounds.width, bounds.height);
				return rv;
			}
			else
			{
				return new IntDimension(bounds.width, bounds.height);
			}
		}
		
		public function setSize(newSize:IntDimension):void
		{
			newSize.width = Math.max(0, newSize.width);
			newSize.height = Math.max(0, newSize.height);
			
			var oldSize:IntDimension = new IntDimension(bounds.width, bounds.height);
			
			if(!newSize.equals(oldSize))
			{
				bounds.setSize(newSize);
				size();
				dispatchEvent(new ResizedEvent(ResizedEvent.RESIZED, oldSize, newSize));
			}
		}
		
		protected function size():void
		{
			readyToPaint = true;
			revalidate();
			repaint();
		}
		
		
		
		
		
		
		
		
		//=======================================
		/*
		* Component's preferr-size operation.
		*/
		//=======================================
		
		protected var cachePreferSizes:Boolean;
		
		protected var preferredSize:IntDimension;
		protected var cachedPreferredSize:IntDimension;
		
		public function getPreferredSize():IntDimension
		{
			if(isDirectReturnSize(preferredSize))
			{
				return preferredSize.clone();
			}
			else if(isCachePreferSizes() && cachedPreferredSize != null)
			{
				return cachedPreferredSize.clone();
			}
			else
			{
				var tempSize:IntDimension = fixSetSize(countPreferredSize(), preferredSize);
				
				if(isCachePreferSizes())
				{
					cachedPreferredSize = tempSize.clone();
					return cachedPreferredSize.clone();
				}
				else
				{
					return tempSize;
				}
			}
		}
		
		private function fixSetSize(counted:IntDimension, setted:IntDimension):IntDimension
		{
			if(setted != null)
			{
				if(setted.width > 0)
				{
					counted.width = setted.width;
				}
				else if(setted.height > 0)
				{
					counted.height = setted.height;
				}
			}
			
			return counted;
		}
		
		public function isCachePreferSizes():Boolean
		{
			return cachePreferSizes;
		}
		
		public function setCachePreferSizes(value:Boolean):void
		{
			cachePreferSizes = value;
			if(!value) clearCacheSize();
		}
		
		protected function clearCacheSize():void
		{
			cachedPreferredSize = null;
		}
		
		private function isDirectReturnSize(s:IntDimension):Boolean
		{
			return s != null && (s.width > 0 && s.height > 0);
		}
		
		protected function countPreferredSize():IntDimension
		{
			if(ui != null) return ui.getPreferredSize();
			else return getSize();
		}
		
		public function setPreferredSize(preferredSize:IntDimension):void
		{
			if(preferredSize == null)
			{
				this.preferredSize = null;
			}
			else
			{
				this.preferredSize = preferredSize.clone();
			}
		}
		
		public function getPreferredWidth():int
		{
			return getPreferredSize().width;
		}
		
		public function setPreferredWidth(preferredWidth:int):void
		{
			if(preferredSize == null)
			{
				preferredSize = new IntDimension(-1, -1);
			}
			preferredSize.width = preferredWidth;
		}
		
		public function getPreferredHeight():int
		{
			return getPreferredSize().height;
		}
		
		public function setPreferredHeight(preferredHeight:int):void
		{
			if(preferredSize == null)
			{
				preferredSize = new IntDimension(-1, -1);
			}
			preferredSize.width = preferredHeight;
		}
		
		
		
		
		
		
		
		//=======================================
		/*
		* Get mouse position by type of IntPoint.
		*/
		//=======================================
		
		public function getMousePosition():IntPoint
		{
			return new IntPoint(mouseX, mouseY);
		}
		
		
		
		
		
		//=======================================
		/*
		* Get and change alpha method.
		*/
		//=======================================
		
		public function setAlpha(alpha:Number):void
		{
			this.alpha = alpha;
		}
		
		public function getAlpha():Number
		{
			return alpha;
		}
		
		
		
		
		
		
		//=======================================
		/*
		* dispatch JEvent.SHOWN | JEvent.HIDDEN event.
		*/
		//=======================================
		
		protected function set d_visible(value:Boolean):void
		{
			super.visible = value;
		}
		
		protected function get d_visible():Boolean
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			setVisible(value);
		}
		
		public function setVisible(v:Boolean):void
		{
			if(v != d_visible)
			{
				d_visible = v;
				
				if(v)
				{
					dispatchEvent(new JEvent(JEvent.SHOWN));
				}
				else
				{
					dispatchEvent(new JEvent(JEvent.HIDDEN));
				}
			}
		}
		
		public function isVisible():Boolean
		{
			return visible;
		}
		
		
		
		
		
		//=======================================
		/*
		 * dispatch ClickCountEvent event.
		*/
		//=======================================
		
		public static const MAX_CLICK_INTERVAL:int = 400;
		
		private var lastClickTime:int;
		private var _lastClickPoint:IntPoint;
		private var clickCount:int;
		protected function __mouseClickHandler(e:MouseEvent):void
		{
			var time:int = getTimer();
			
			var mousePoint:IntPoint = new IntPoint(StageRef.mouseX, StageRef.mouseY);
			
			if(mousePoint.equals(_lastClickPoint) && ((time - lastClickTime) < MAX_CLICK_INTERVAL))
			{
				clickCount++;
			}
			else
			{
				clickCount = 1;
			}
			
			lastClickTime = time;
			dispatchEvent(new ClickCountEvent(ClickCountEvent.CLICK_COUNT, clickCount));
			_lastClickPoint = mousePoint;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeEventListener(MouseEvent.CLICK, __mouseClickHandler);
		}
		
		override public function toString():String
		{
			return typeof(this) + "[asset:" + super.toString() + "]";
		}
	}
}