package jsion.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.utils.DisposeUtil;

	/**
	 * 包含图标的按钮。
	 * @author Jsion
	 * 
	 */	
	public class IconButton extends Button
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Button.WIDTH;
		
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = Button.HEIGHT;
		
		/**
		 * 状态显示对象资源变更
		 */		
		public static const STATEIMAGE:String = Button.STATEIMAGE;
		/**
		 * 状态显示对象滤镜变更
		 */		
		public static const STATEFILTERS:String = Button.STATEFILTERS;
		
		/**
		 * 状态显示对象偏移变量
		 */		
		public static const OFFSET:String = Button.OFFSET;
		
		/**
		 * 水平左边对齐，用于 hAlign 属性。
		 * @see jsion.comps.CompGlobal#LEFT
		 */		
		public static const LEFT:String = CompGlobal.LEFT;
		
		/**
		 * 水平右边对齐，用于 hAlign 属性。
		 * @see jsion.comps.CompGlobal#RIGHT
		 */		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		/**
		 * 水平居中对齐，用于 hAlign 属性。
		 * @see jsion.comps.CompGlobal#CENTER
		 */		
		public static const CENTER:String = CompGlobal.CENTER;
		
		/**
		 * 垂直顶边对齐，用于 vAlign 属性。
		 * @see jsion.comps.CompGlobal#TOP
		 */		
		public static const TOP:String = CompGlobal.TOP;
		
		/**
		 * 垂直底边对齐，用于 vAlign 属性。
		 * @see jsion.comps.CompGlobal#BOTTOM
		 */		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		/**
		 * 垂直居中对齐，用于 vAlign 属性。
		 * @see jsion.comps.CompGlobal#MIDDLE
		 */		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		/**
		 * 图标显示对象资源变更
		 */		
		public static const ICONIMAGE:String = "iconImage";
		
		/**
		 * 图标显示对象对齐方式变更
		 */		
		public static const ICONALIGN:String = "iconAlign";
		
		/**
		 * 图标显示对象滤镜变更
		 */		
		public static const ICONFILTERS:String = "iconFilters";
		
		/** @private */
		protected var m_iconUpImage:DisplayObject;
		/** @private */
		protected var m_iconOverImage:DisplayObject;
		/** @private */
		protected var m_iconDownImage:DisplayObject;
		/** @private */
		protected var m_iconDisableImage:DisplayObject;
		
		
		/** @private */
		protected var m_iconUpFilters:Array;
		/** @private */
		protected var m_iconOverFilters:Array;
		/** @private */
		protected var m_iconDownFilters:Array;
		/** @private */
		protected var m_iconDisableFilters:Array;
		
		
		/** @private */
		protected var m_iconHAlign:String;
		/** @private */
		protected var m_iconHOffset:int;
		/** @private */
		protected var m_iconVAlign:String;
		/** @private */
		protected var m_iconVOffset:int;
		
		
		
		
		/** @private */
		protected var m_iconCurFilters:Array;
		/** @private */
		protected var m_curIconImage:DisplayObject;
		
		
		
		
		/** @private */
		protected var m_rect:Rectangle;
		
		public function IconButton()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_iconHAlign = CENTER;
			m_iconVAlign = MIDDLE;
		}
		
		/**
		 * 图标弹起时的显示对象资源
		 */		
		public function get iconUpImage():DisplayObject
		{
			return m_iconUpImage;
		}
		
		/** @private */
		public function set iconUpImage(value:DisplayObject):void
		{
			if(m_iconUpImage != value)
			{
				DisposeUtil.free(m_iconUpImage, m_freeBMD);
				
				m_iconUpImage = value;
				
				if(m_iconUpImage && m_upImage == null)
				{
					if(manualWidth == false) m_width = m_iconUpImage.width;
					if(manualHeight == false) m_height = m_iconUpImage.height;
				}
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标鼠标经过时的显示对象资源
		 */		
		public function get iconOverImage():DisplayObject
		{
			return m_iconOverImage;
		}
		
		/** @private */
		public function set iconOverImage(value:DisplayObject):void
		{
			if(m_iconOverImage != value)
			{
				DisposeUtil.free(m_iconOverImage, m_freeBMD);
				
				m_iconOverImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标鼠标按下时的显示对象资源
		 */		
		public function get iconDownImage():DisplayObject
		{
			return m_iconDownImage;
		}
		
		/** @private */
		public function set iconDownImage(value:DisplayObject):void
		{
			if(m_iconDownImage != value)
			{
				DisposeUtil.free(m_iconDownImage, m_freeBMD);
				
				m_iconDownImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标禁用时的显示对象资源
		 */		
		public function get iconDisableImage():DisplayObject
		{
			return m_iconDisableImage;
		}
		
		/** @private */
		public function set iconDisableImage(value:DisplayObject):void
		{
			if(m_iconDisableImage != value)
			{
				DisposeUtil.free(m_iconDisableImage, m_freeBMD);
				
				m_iconDisableImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标弹起时显示对象资源的滤镜
		 */		
		public function get iconUpFilters():Array
		{
			return m_iconUpFilters;
		}
		
		/** @private */
		public function set iconUpFilters(value:Array):void
		{
			if(m_iconUpFilters != value)
			{
				m_iconUpFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		/**
		 * 图标鼠标经过时显示对象资源的滤镜
		 */		
		public function get iconOverFilters():Array
		{
			return m_iconOverFilters;
		}
		
		/** @private */
		public function set iconOverFilters(value:Array):void
		{
			if(m_iconOverFilters != value)
			{
				m_iconOverFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		/**
		 * 图标鼠标按下时显示对象资源的滤镜
		 */		
		public function get iconDownFilters():Array
		{
			return m_iconDownFilters;
		}
		
		/** @private */
		public function set iconDownFilters(value:Array):void
		{
			if(m_iconDownFilters != value)
			{
				m_iconDownFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		/**
		 * 图标禁用时显示对象资源的滤镜
		 */		
		public function get iconDisableFilters():Array
		{
			return m_iconDisableFilters;
		}
		
		/** @private */
		public function set iconDisableFilters(value:Array):void
		{
			if(m_iconDisableFilters != value)
			{
				m_iconDisableFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		public function get iconHAlign():String
		{
			return m_iconHAlign;
		}
		
		/** @private */
		public function set iconHAlign(value:String):void
		{
			if(m_iconHAlign != value)
			{
				m_iconHAlign = value;
				
				onPropertiesChanged(ICONALIGN);
			}
		}
		
		public function get iconHOffset():int
		{
			return m_iconHOffset;
		}
		
		/** @private */
		public function set iconHOffset(value:int):void
		{
			if(m_iconHOffset != value)
			{
				m_iconHOffset = value;
				
				onPropertiesChanged(ICONALIGN);
			}
		}
		
		public function get iconVAlign():String
		{
			return m_iconVAlign;
		}
		
		/** @private */
		public function set iconVAlign(value:String):void
		{
			if(m_iconVAlign != value)
			{
				m_iconVAlign = value;
				
				onPropertiesChanged(ICONALIGN);
			}
		}
		
		public function get iconVOffset():int
		{
			return m_iconVOffset;
		}
		
		/** @private */
		public function set iconVOffset(value:int):void
		{
			if(m_iconVOffset != value)
			{
				m_iconVOffset = value;
				
				onPropertiesChanged(ICONALIGN);
			}
		}
		
		/**
		 * 更新当前状态和图标的显示对象
		 */		
		override protected function updateCurrentStateImage():void
		{
			super.updateCurrentStateImage();
			
			if(isChanged(ICONIMAGE) || m_stateChange)
			{
				var image:DisplayObject;
				
				var tmpImage:DisplayObject;
				
				image = m_iconUpImage;
				
				if(model.enabled == false)
				{
					tmpImage = m_iconDisableImage;
				}
				else if(model.pressed)
				{
					tmpImage = m_iconDownImage;
				}
				else if(model.rollOver)
				{
					tmpImage = m_iconOverImage;
				}
				
				if(tmpImage != null)
				{
					image = tmpImage;
				}
				
				if(image != m_curIconImage)
				{
					if(m_curIconImage && m_curIconImage.parent)
					{
						m_curIconImage.parent.removeChild(m_curImage);
					}
					
					m_curIconImage = image;
				}
				
				if(m_curIconImage)
				{
					addChild(m_curIconImage);
				}
			}
		}
		
		/**
		 * 更新当前状态和图标的滤镜对象
		 */		
		override protected function updateCurrentStateFilters():void
		{
			super.updateCurrentStateFilters();
			
			if((isChanged(ICONFILTERS) || m_stateChange) && m_curIconImage)
			{
				var filters:Array;
				var tmpFilters:Array;
				
				filters = m_iconUpFilters;
				
				if(model.enabled == false)
				{
					tmpFilters = m_iconDisableFilters;
				}
				else if(model.pressed)
				{
					tmpFilters = m_iconDownFilters;
				}
				else if(model.rollOver)
				{
					tmpFilters = m_iconOverFilters;
				}
				
				if(tmpFilters != null)
				{
					filters = tmpFilters;
				}
				
				if(filters != m_iconCurFilters)
				{
					m_iconCurFilters = filters;
				}
				
				m_curIconImage.filters = m_iconCurFilters;
			}
		}
		
		/**
		 * 更新当前状态显示对象和图标的位置
		 */		
		override protected function updateImagePos():void
		{
			if(m_curIconImage)
			{
				if(m_stateChange || 
					isChanged(ICONIMAGE) || 
					isChanged(ICONALIGN) || 
					isChanged(WIDTH) || 
					isChanged(HEIGHT) || 
					isChanged(OFFSET))
				{
				
					m_curIconImage.x = m_curIconImage.y = 0;
					
					m_rect.width = m_curIconImage.width;
					m_rect.height = m_curIconImage.height;
					
					CompUtil.layoutPosition(width, height, m_iconHAlign, m_iconHOffset, m_iconVAlign, m_iconVOffset, m_rect);
					
					if(model.pressed)
					{
						m_rect.x += m_downOffsetX;
						m_rect.y += m_downOffsetY;
					}
					else if(model.rollOver)
					{
						m_rect.x += m_overOffsetX;
						m_rect.y += m_overOffsetY;
					}
					else
					{
						m_rect.x += m_offsetX;
						m_rect.y += m_offsetY;
					}
					
					m_curIconImage.x = m_rect.x;
					m_curIconImage.y = m_rect.y;
				}
			}
			
			super.updateImagePos();
		}

		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			DisposeUtil.free(m_iconUpImage, m_freeBMD);
			m_iconUpImage = null;
			
			DisposeUtil.free(m_iconOverImage, m_freeBMD);
			m_iconOverImage = null;
			
			DisposeUtil.free(m_iconDownImage, m_freeBMD);
			m_iconDownImage = null;
			
			DisposeUtil.free(m_iconDisableImage, m_freeBMD);
			m_iconDisableImage = null;
			
			m_iconUpFilters = null;
			m_iconOverFilters = null;
			m_iconDownFilters = null;
			m_iconDisableFilters = null;
			
			m_curIconImage = null;
			m_iconCurFilters = null;
			
			m_rect = null;
			
			super.dispose();
		}
	}
}