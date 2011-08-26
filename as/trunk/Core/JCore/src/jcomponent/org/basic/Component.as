package jcomponent.org.basic
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import jcomponent.org.basic.borders.IBorder;
	import jcomponent.org.basic.graphics.Graphics2D;
	import jcomponent.org.basic.graphics.SolidBrush;
	import jutils.org.util.DepthUtil;
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.NameUtil;
	import jutils.org.util.StringUtil;
	public class Component extends Sprite implements IDispose
	{

		private static const bg_trigger_brush:SolidBrush = new SolidBrush(new ASColor(0, 0));

		public function Component(id:String = null)
		{
			this.id = id;

			if(isOnStage())
			{
				initialize();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			}
		}

		private var m_backcolor:ASColor;

		private var m_background:DisplayObject;

		private var m_backgroundDecorator:IGroundDecorator;

		private var m_border:IBorder;

		private var m_bounds:IntRectangle;

		private var m_enabled:Boolean;

		private var m_font:ASFont;

		private var m_forecolor:ASColor;

		private var m_foreground:DisplayObject;

		private var m_foregroundDecorator:IGroundDecorator;

		private var m_id:String;

		private var m_mask:Shape;

		private var m_needDrawTransparentTrigger:Boolean;

		private var m_opaque:Boolean;

		private var m_ui:IComponentUI;

		private var m_uiClassID:String;

		private var m_waiteRender:Boolean;

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

			var c:DisplayObject = super.addChild(child);

			DepthUtil.bringToTop(m_foreground);

			return c;
		}

		public function get backcolor():ASColor
		{
			return backcolor;
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
				m_bounds = value;

				setLocationXY(m_bounds.x, m_bounds.y);

				setSizeWH(m_bounds.width, m_bounds.height);
			}
		}



		public function dispose():void
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

			m_bounds = null;

			DisposeUtil.free(m_font);
			m_font = null;

			DisposeUtil.free(m_mask);
			m_mask = null;

			if(m_ui) m_ui.uninstall(this);
			DisposeUtil.free(m_ui);
			m_ui = null;

			ComponentMgr.Instance.unregiste(m_id);
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
			if(stage && m_waiteRender)
			{
				stage.addEventListener(Event.RENDER, __renderHandler);
				stage.invalidate();
				m_waiteRender = true;
			}
		}

		public function isOnStage():Boolean
		{
			return stage != null;
		}

		public function isShowing():Boolean
		{
			return isOnStage() && visible;
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

		public function setLocation(pos:IntPoint):void
		{
			setLocationXY(pos.x, pos.y);
		}

		public function setLocationXY(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			bounds.x = x;
			bounds.y = y;
		}

		public function setSize(size:IntDimension):void
		{
			setSizeWH(size.width, size.height);
		}

		public function setSizeWH(w:int, h:int):void
		{
			if(w != bounds.width || h != bounds.height)
			{
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

		protected function getUIDefaultClassID():String
		{
			return null;
		}

		protected function paint():void
		{
			graphics.clear();

			if(m_needDrawTransparentTrigger && m_enabled)
			{
				paintTrigger();
			}

			if(m_backgroundDecorator) m_backgroundDecorator.updateDecorator(this, m_ui, bounds);

			if(m_ui) m_ui.paint(this, bounds);

			if(m_foregroundDecorator) m_foregroundDecorator.updateDecorator(this, m_ui, bounds);
		}
		
		protected function paintTrigger():void
		{
			var g:Graphics2D = new Graphics2D(graphics);
			g.fillRectangle(bg_trigger_brush, bounds.x, bounds.y, bounds.width, bounds.height);
		}

		private function __addToStageHandler(e:Event):void
		{
			initialize();
		}

		private function __renderHandler(e:Event):void
		{
			stage.removeEventListener(Event.RENDER, __renderHandler);
			m_waiteRender = false;

			paint();
		}

		private function initialize():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);

			enabled = true;
			m_bounds = new IntRectangle();
			m_font = DefaultRes.DEFAULT_FONT;
			m_backcolor = DefaultRes.DEFAULT_BACKGROUND_COLOR;
			m_forecolor = DefaultRes.DEFAULT_FOREGROUND_COLOR;
			m_border = DefaultRes.DEFAULT_BORDER;
			m_needDrawTransparentTrigger = true;

			m_mask = new Shape();
			m_mask.graphics.beginFill(0);
			m_mask.graphics.drawRect(0, 0, 1, 1);
			m_mask.graphics.endFill();

			addChild(m_mask);
			mask = m_mask;

			invalidate();
		}

		private function setBackground(child:DisplayObject = null):void
		{
			if(child != m_background)
			{
				DisposeUtil.free(m_background);

				m_background = child;

				addChild(m_background);
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

