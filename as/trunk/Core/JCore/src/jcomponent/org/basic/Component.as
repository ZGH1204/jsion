package jcomponent.org.basic
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import jcomponent.org.basic.borders.IBorder;
	import jcomponent.org.basic.graphics.Graphics2D;
	import jcomponent.org.basic.graphics.SolidBrush;
	import jcomponent.org.mgrs.ComponentMgr;
	import jcomponent.org.mgrs.UIMgr;
	
	import jutils.org.util.DepthUtil;
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.NameUtil;
	import jutils.org.util.StringUtil;
	
	public class Component extends JSprite
	{

		private static const bg_trigger_brush:SolidBrush = new SolidBrush(new ASColor(0, 0));

		public function Component(prefix:String = null, id:String = null)
		{
			JUtil.checkAbstract(this);
			
			this.id = id;
			
			initialize();
		}
		
		protected var m_prefix:String;
		
		protected var m_content:Sprite;

		private var m_backcolor:ASColor;

		internal var m_background:DisplayObject;

		private var m_backgroundDecorator:IGroundDecorator;

		private var m_border:IBorder;

		private var m_bounds:IntRectangle;

		private var m_enabled:Boolean;

		private var m_font:ASFont;

		private var m_forecolor:ASColor;

		private var m_foreground:DisplayObject;

		private var m_foregroundDecorator:IGroundDecorator;
		
		private var m_styleTune:StyleTune;

		private var m_id:String;

		private var m_mask:Shape;

		private var m_needDrawTransparentTrigger:Boolean;

		private var m_opaque:Boolean;

		private var m_ui:IComponentUI;

		private var m_uiClassID:String;
		
		private var m_readyToInvalidate:Boolean;
		
		
		private var m_preferredSize:IntDimension;
		private var m_cachePreferredSize:Boolean;
		private var m_cachedPreferredSize:IntDimension;
		
		private var m_minimumSize:IntDimension;
		private var m_cacheMinimumSize:Boolean;
		private var m_cachedMinimumSize:IntDimension;
		
		private var m_maximumSize:IntDimension;
		private var m_cacheMaximumSize:Boolean;
		private var m_cachedMaximumSize:IntDimension;
		
		
		internal var container:Container;
		
		
		public function get content():Sprite
		{
			return m_content;
		}

		public function get UI():IComponentUI
		{
			return m_ui;
		}

		public function set UI(value:IComponentUI):void
		{
			if(m_ui != value)
			{
				if(m_ui) m_ui.uninstall(this);

				m_ui = value;

				if(m_ui) m_ui.install(this);

				invalidate();
			}
		}

		public function get UIClassID():String
		{
			if(StringUtil.isNullOrEmpty(m_uiClassID))
				return getUIDefaultClassID();

			return m_uiClassID;
		}

		public function set UIClassID(value:String):void
		{
			if(value != UIClassID)
			{
				m_uiClassID = value;
				updateUI();
			}
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;

			var c:DisplayObject = m_content.addChild(child);

			DepthUtil.bringToTop(m_foreground);

			return c;
		}
		
		override public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean
		{
			return m_mask.hitTestPoint(x, y, shapeFlag);
		}
		
		public function hitTestMouse():Boolean
		{
			if(isOnStage())
				return hitTestPoint(StageRef.mouseX, StageRef.mouseY);
			
			return false;
		}

		public function get backcolor():ASColor
		{
			return m_backcolor;
		}

		public function set backcolor(value:ASColor):void
		{
			if(m_backcolor != value)
			{
				m_backcolor = value;

				invalidate();
			}
		}

		public function get backgroundDecorator():IGroundDecorator
		{
			return m_backgroundDecorator;
		}

		public function set backgroundDecorator(value:IGroundDecorator):void
		{
			if(m_backgroundDecorator != value)
			{
				DisposeUtil.free(m_backgroundDecorator);

				m_backgroundDecorator = value;

				if(m_backgroundDecorator)
				{
					//m_backgroundDecorator.setup(this, UI);
					
					setBackground(m_backgroundDecorator.getDisplay(this));
					return;
				}

				setBackground(null);
			}
		}

		public function get border():IBorder
		{
			return m_border;
		}

		public function set border(value:IBorder):void
		{
			if(m_border != value)
			{
				if(m_border != null) DisposeUtil.free(m_border);

				m_border = value;

				if(m_border != null && m_border.getDisplay(this) != null)
				{
					addChildAt(m_border.getDisplay(this), getLowestIndexAboveBackground());
				}

				invalidate();
			}
		}

		public function get bounds():IntRectangle
		{
			return m_bounds;
		}

		public function set bounds(value:IntRectangle):void
		{
			if(m_bounds != value && value != null && !value.equals(m_bounds))
			{
				setLocationXY(value.x, value.y);

				setSizeWH(value.width, value.height);
			}
		}

		public function setBoundsXYWH(x:int, y:int, w:int, h:int):void
		{
			setLocationXY(x, y);
			
			setSizeWH(width, height);
		}

		override public function dispose():void
		{
			m_backcolor = null;
			m_forecolor = null;

			DisposeUtil.free(m_background);
			m_background = null;

			DisposeUtil.free(m_foreground);
			m_foreground = null;

			DisposeUtil.free(m_backgroundDecorator);
			m_backgroundDecorator = null;

			DisposeUtil.free(m_foregroundDecorator);
			m_foregroundDecorator = null;

			DisposeUtil.free(m_border);
			m_border = null;

			DisposeUtil.free(m_font);
			m_font = null;

			DisposeUtil.free(m_mask);
			m_mask = null;

			if(m_ui) m_ui.uninstall(this);
			DisposeUtil.free(m_ui);
			m_ui = null;
			
			DisposeUtil.free(m_content);
			m_content = null;
			
			
			m_preferredSize = null;
			m_cachedPreferredSize = null;
			
			m_minimumSize = null;
			m_cachedMinimumSize = null;
			
			m_maximumSize = null;
			m_cachedMaximumSize = null;;
			
			
			container = null;
			
			m_bounds = null;

			ComponentMgr.Instance.unregiste(m_id);
			
			super.dispose();
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			m_enabled = value;
			tabEnabled = value;
			mouseEnabled = value;
			mouseChildren = value;

			invalidate();
		}

		public function get font():ASFont
		{
			return m_font;
		}

		public function set font(value:ASFont):void
		{
			if(m_font != value)
			{
				m_font = value;

				if(m_font != null && !m_font.isFullFeatured())
				{
					throw new Error("Cannot set a non-full-featured font, try supplyFont() instead.");
					return;
				}

				invalidate();
			}
		}

		public function get forecolor():ASColor
		{
			return m_forecolor;
		}

		public function set forecolor(value:ASColor):void
		{
			if(m_forecolor != value)
			{
				m_forecolor = value;

				invalidate();
			}
		}

		public function get foregroundDecorator():IGroundDecorator
		{
			return m_foregroundDecorator;
		}

		public function set foregroundDecorator(value:IGroundDecorator):void
		{
			if(m_foregroundDecorator != value)
			{
				DisposeUtil.free(m_foregroundDecorator);

				m_foregroundDecorator = value;

				if(m_foregroundDecorator)
				{
					setForeground(m_foregroundDecorator.getDisplay(this));
					return;
				}

				setForeground(null);
			}
		}
		
		public function get styleTune():StyleTune
		{
			return m_styleTune;
		}
		
		public function set styleTune(value:StyleTune):void
		{
			if(m_styleTune != value)
			{
				m_styleTune = value;
				
				invalidate();
			}
		}
		
		public function pack():void
		{
			setSize(getPreferredSize());
		}
		
		public function bringToTopBelowForeground(child:DisplayObject):void
		{
			DepthUtil.bringToTop(child);
			DepthUtil.bringToTop(m_foreground);
		}

		public function getHighestIndexBelowForeground():int
		{
			if(m_foreground)
			{
				return numChildren - 1;
			}

			return numChildren;
		}

		public function getLowestIndexAboveBackground():int
		{
			if(m_background)
			{
				return 1;
			}

			return 0;
		}

		public function getUIDefaultBasicClass():Class
		{
			return null;
		}

		override public function get height():Number
		{
			return bounds.height;
		}

		override public function set height(value:Number):void
		{
			setSizeWH(width, value);
		}

		public function get id():String
		{
			return m_id;
		}

		public function set id(value:String):void
		{
			if(StringUtil.isNullOrEmpty(value) && StringUtil.isNotNullOrEmpty(m_id)) return;

			if(StringUtil.isNullOrEmpty(value)) value = NameUtil.createUniqueName(this);

			if(StringUtil.isNotNullOrEmpty(m_id))
			{
				ComponentMgr.Instance.unregiste(m_id);
			}

			m_id = value;

			ComponentMgr.Instance.registe(this);
		}

		public function invalidate():void
		{
			if(m_readyToInvalidate)
			{
				ComponentMgr.Instance.addInvalidate(this);
			}
		}

		public function get needDrawTransparentTrigger():Boolean
		{
			return m_needDrawTransparentTrigger;
		}

		public function set needDrawTransparentTrigger(value:Boolean):void
		{
			m_needDrawTransparentTrigger = value;
		}

		public function get opaque():Boolean
		{
			return m_opaque;
		}

		public function set opaque(value:Boolean):void
		{
			if(m_opaque != value)
			{
				m_opaque = value;

				invalidate();
			}
		}
		
		public function get prefix():String
		{
			return m_prefix;
		}

		public function setLocation(pos:IntPoint):void
		{
			setLocationXY(pos.x, pos.y);
		}

		public function setLocationXY(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function getSize(s:IntDimension = null):IntDimension
		{
			var ss:IntDimension = bounds.getSize();
			if(s) s.setSize(ss);
			return ss;
		}

		public function setSize(size:IntDimension):void
		{
			setSizeWH(size.width, size.height);
		}

		public function setSizeWH(w:int, h:int):void
		{
			if(w != bounds.width || h != bounds.height)
			{
				m_readyToInvalidate = true;
				
				bounds.width = w;
				bounds.height = h;

				invalidate();
			}
		}

		/**
		 * 类似于setTextFormat()方法，newFont参数中的null值不会被应用。<br />
		 * 该方法将旧的font对象与newFont参数合并生成一个新的对象进行设置。<br />
		 * 建议使用该方法，不推荐使用font属性。
		 * @param newFont
		 *
		 */		
		public function supplyFont(newFont:ASFont):void
		{
			if(newFont == null) return;

			if(font != newFont) font = newFont.takeover(font);
		}

		public function updateUI():void
		{
			UI = UIMgr.getUI(this);
		}

		override public function get width():Number
		{
			return bounds.width;
		}

		override public function set width(value:Number):void
		{
			setSizeWH(value, height);
		}

		override public function get x():Number
		{
			return bounds.x;
		}

		override public function set x(value:Number):void
		{
			bounds.x = value;
			xPos = value;
		}

		override public function get y():Number
		{
			return bounds.y;
		}

		override public function set y(value:Number):void
		{
			bounds.y;
			yPos = value;
		}
		
		override public function get numChildren():int
		{
			return m_content.numChildren;
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			return m_content.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			return m_content.swapChildrenAt(index1, index2);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return m_content.getChildIndex(child);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			return m_content.setChildIndex(child, index);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return m_content.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return m_content.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return m_content.removeChildAt(index);
		}
		
		public function get preferredSize():IntDimension
		{
			return m_preferredSize;
		}
		
		public function set preferredSize(value:IntDimension):void
		{
			if(value) m_preferredSize = value.clone();
		}
		
		public function get preferredWidth():int
		{
			if(m_preferredSize) return m_preferredSize.width;
			
			return 0;
		}
		
		public function set preferredWidth(value:int):void
		{
			if(m_preferredSize == null) m_preferredSize = new IntDimension(-1, -1);
			
			m_preferredSize.width = value;
		}
		
		public function get preferredHeight():int
		{
			if(m_preferredSize) return m_preferredSize.height;
			
			return 0;
		}
		
		public function set preferredHeight(value:int):void
		{
			if(m_preferredSize == null) m_preferredSize = new IntDimension(-1, -1);
			
			m_preferredSize.height = value;
		}
		
		public function get cachePreferredSize():Boolean
		{
			return m_cachePreferredSize;
		}
		
		public function set cachePreferredSize(value:Boolean):void
		{
			m_cachePreferredSize = value;
		}
		
		public function getPreferredSize():IntDimension
		{
			if(isDirectReturnSize(m_preferredSize))
			{
				return m_preferredSize.clone();
			}
			else if(m_cachePreferredSize && m_cachedPreferredSize != null)
			{
				return m_cachedPreferredSize.clone();
			}
			else
			{
				var tempSize:IntDimension = mixSetSize(countPreferredSize(), m_preferredSize);
				
				if(m_cachePreferredSize) m_cachedPreferredSize = tempSize;
				
				return tempSize.clone();
			}
		}
		
		private function mixSetSize(counted:IntDimension, setted:IntDimension):IntDimension
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
		
		protected function countPreferredSize():IntDimension
		{
			if(m_ui != null)
			{
				return m_ui.getPreferredSize(this);
			}
			else
			{
				return getSize();
			}
		}
		
		public function get minimumSize():IntDimension
		{
			return m_minimumSize;
		}
		
		public function set minimumSize(value:IntDimension):void
		{
			if(value == null) return;
			m_minimumSize = value.clone();
		}
		
		public function get minimumWidth():int
		{
			if(m_minimumSize) return m_minimumSize.width;
			
			return 0;
		}
		
		public function set minimumWidth(value:int):void
		{
			if(m_minimumSize == null) m_minimumSize = new IntDimension(-1, -1);
			
			m_minimumSize.width = value;
		}
		
		public function get minimumHeight():int
		{
			if(m_minimumSize) return m_minimumSize.height;
			
			return 0;
		}
		
		public function set minimumHeight(value:int):void
		{
			if(m_minimumSize == null) m_minimumSize = new IntDimension(-1, -1);
			
			m_minimumSize.height = value;
		}
		
		public function get cacheMinimumSize():Boolean
		{
			return m_cacheMinimumSize;
		}
		
		public function set cacheMinimumSize(value:Boolean):void
		{
			m_cacheMinimumSize = value;
		}
		
		public function getMinimumSize():IntDimension
		{
			if(isDirectReturnSize(m_minimumSize))
			{
				return m_minimumSize.clone();
			}
			else if(m_cacheMinimumSize && m_cachedMinimumSize != null)
			{
				return m_cachedMinimumSize.clone();
			}
			else
			{
				var tempSize:IntDimension = mixSetSize(countMinimumSize(), m_minimumSize);
				
				if(m_cacheMinimumSize) m_cachedMinimumSize = tempSize;
				
				return tempSize.clone();
			}
		}
		
		public function getInsets():Insets
		{
			if(border == null)
			{
				return new Insets();
			}
			else
			{
				return border.getBorderInsets(this, getSize().getBounds());
			}
		}
		
		protected function countMinimumSize():IntDimension
		{
			if(m_ui != null)
			{
				return m_ui.getMinimumSize(this);
			}
			else
			{
				return getInsets().getOutsideSize(new IntDimension(0, 0));
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function get maximumSize():IntDimension
		{
			return m_maximumSize;
		}
		
		public function set maximumSize(value:IntDimension):void
		{
			if(value == null) return;
			m_maximumSize = value.clone();
		}
		
		public function get maximumWidth():int
		{
			if(m_maximumSize) return m_maximumSize.width;
			
			return 0;
		}
		
		public function set maximumWidth(value:int):void
		{
			if(m_maximumSize == null) m_maximumSize = new IntDimension(-1, -1);
			
			m_maximumSize.width = value;
		}
		
		public function get maximumHeight():int
		{
			if(m_maximumSize) return m_maximumSize.height;
			
			return 0;
		}
		
		public function set maximumHeight(value:int):void
		{
			if(m_maximumSize == null) m_maximumSize = new IntDimension(-1, -1);
			
			m_maximumSize.height = value;
		}
		
		public function get cacheMaximumSize():Boolean
		{
			return m_cacheMaximumSize;
		}
		
		public function set cacheMaximumSize(value:Boolean):void
		{
			m_cacheMaximumSize = value;
		}
		
		
		
		public function getMaximumSize():IntDimension
		{
			if(isDirectReturnSize(m_maximumSize))
			{
				return m_maximumSize.clone();
			}
			else if(m_cacheMaximumSize && m_cachedMaximumSize != null)
			{
				return m_cachedMaximumSize.clone();
			}
			else
			{
				var tempSize:IntDimension = mixSetSize(countMaximumSize(), m_maximumSize);
				
				if(m_cacheMaximumSize) m_cachedMaximumSize = tempSize;
				
				return tempSize.clone();
			}
		}
		
		public function clearSizeCaches():void
		{
			m_cachedMaximumSize = null;
			m_cachedMinimumSize = null;
			m_cachedPreferredSize = null;
			
			var par:Container = getContainer();
			if(par != null){
				par.clearSizeCaches();
			}
		}
		
		public function getContainer():Container
		{
			return container;
		}
		
		protected function countMaximumSize():IntDimension
		{
			if(m_ui != null)
			{
				return m_ui.getMaximumSize(this);
			}
			else
			{
				return IntDimension.createBigDimension();
			}
		}
		
		private function isDirectReturnSize(s:IntDimension):Boolean
		{
			if(s == null || s.width <= 0 || s.height <= 0) return false;
			
			return true;
		}

		protected function getUIDefaultClassID():String
		{
			return null;
		}

		public function paint():void
		{
			setMaskSize(bounds.getSize());
			
			graphics.clear();
			if(m_needDrawTransparentTrigger && m_enabled) paintTrigger();

			if(m_backgroundDecorator) m_backgroundDecorator.updateDecorator(this, bounds);

			if(m_ui) m_ui.paint(this, bounds);

			if(m_foregroundDecorator) m_foregroundDecorator.updateDecorator(this, bounds);
		}
		
		private function setMaskSize(s:IntDimension):void
		{
			if(m_mask)
			{
				m_mask.width = s.width;
				m_mask.height = s.height;
			}
		}
		
		protected function paintTrigger():void
		{
			var g:Graphics2D = new Graphics2D(graphics);
			g.fillRectangle(bg_trigger_brush, bounds.x, bounds.y, bounds.width, bounds.height);
		}

		private function initialize():void
		{
			m_content = new Sprite();
			
			super.addChild(m_content);
			
			m_enabled = true;
			m_needDrawTransparentTrigger = true;
			
			m_bounds = new IntRectangle();
			m_font = DefaultRes.DEFAULT_FONT;
			m_backcolor = DefaultRes.DEFAULT_BACKGROUND_COLOR;
			m_forecolor = DefaultRes.DEFAULT_FOREGROUND_COLOR;
			m_border = DefaultRes.DEFAULT_BORDER;

			m_mask = new Shape();
			m_mask.graphics.beginFill(0);
			m_mask.graphics.drawRect(0, 0, 1, 1);
			m_mask.graphics.endFill();

			addChild(m_mask);
			mask = m_mask;
			
			updateUI();

			invalidate();
		}

		private function setBackground(child:DisplayObject = null):void
		{
			if(child != m_background)
			{
				DisposeUtil.free(m_background);

				m_background = child;

				addChild(m_background);
				
				DepthUtil.bringToBottom(m_background);
			}
		}

		private function setForeground(child:DisplayObject = null):void
		{
			if(child != m_foreground)
			{
				DisposeUtil.free(m_foreground);

				m_foreground = child;

				addChild(m_foreground);
			}
		}

		private function get xPos():Number
		{
			return super.x;
		}

		private function set xPos(value:Number):void
		{
			super.x = value;
		}

		private function get yPos():Number
		{
			return super.y;
		}

		private function set yPos(value:Number):void
		{
			super.y = value;
		}

	}
}

