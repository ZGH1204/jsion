package jsion.display
{
	import flash.display.DisplayObject;
	
	import jsion.comps.CompUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	public class IconToggleButton extends ToggleButton
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = ToggleButton.WIDTH;
		
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = ToggleButton.HEIGHT;
		
		/**
		 * 状态显示对象资源变更
		 */		
		public static const STATEIMAGE:String = ToggleButton.STATEIMAGE;
		/**
		 * 状态显示对象滤镜变更
		 */		
		public static const STATEFILTERS:String = ToggleButton.STATEFILTERS;
		
		/**
		 * 状态显示对象偏移变量
		 */		
		public static const OFFSET:String = ToggleButton.OFFSET;
		
		/**
		 * 水平左边对齐，用于 hAlign、iconDir 属性。
		 * @see jsion.comps.CompGlobal#LEFT
		 */		
		public static const LEFT:String = ToggleButton.LEFT;
		
		/**
		 * 水平右边对齐，用于 hAlign、iconDir 属性。
		 * @see jsion.comps.CompGlobal#RIGHT
		 */		
		public static const RIGHT:String = ToggleButton.RIGHT;
		
		/**
		 * 水平居中对齐，用于 hAlign 属性。
		 * @see jsion.comps.CompGlobal#CENTER
		 */		
		public static const CENTER:String = ToggleButton.CENTER;
		
		/**
		 * 垂直顶边对齐，用于 vAlign、iconDir 属性。
		 * @see jsion.comps.CompGlobal#TOP
		 */		
		public static const TOP:String = ToggleButton.TOP;
		
		/**
		 * 垂直底边对齐，用于 vAlign、iconDir 属性。
		 * @see jsion.comps.CompGlobal#BOTTOM
		 */		
		public static const BOTTOM:String = ToggleButton.BOTTOM;
		
		/**
		 * 垂直居中对齐，用于 vAlign 属性。
		 * @see jsion.comps.CompGlobal#MIDDLE
		 */		
		public static const MIDDLE:String = ToggleButton.MIDDLE;
		
		/**
		 * 文本对齐方式变更
		 */		
		public static const LABELALIGN:String = ToggleButton.LABELALIGN;
		
		/**
		 * 文本滤镜变更
		 */		
		public static const LABELFILTERS:String = ToggleButton.LABELFILTERS;
		
		/**
		 * 图标所在方位变更
		 */		
		public static const ICONDIR:String = "iconDir";
		
		/**
		 * 图标与文本间隔变更
		 */		
		public static const ICONGAP:String = "iconGap";
		
		/**
		 * 图标显示对象资源变更
		 */		
		public static const ICONIMAGE:String = "iconImage";
		
		/**
		 * 图标显示对象滤镜变更
		 */		
		public static const ICONFILTERS:String = "iconFilters";
		
		
		/** @private */
		protected var m_iconGap:int;
		
		/** @private */
		protected var m_iconWidth:int;
		/** @private */
		protected var m_iconHeight:int;
		
		
		/** @private */
		protected var m_iconUpImage:DisplayObject;
		/** @private */
		protected var m_iconOverImage:DisplayObject;
		/** @private */
		protected var m_iconDownImage:DisplayObject;
		/** @private */
		protected var m_iconDisableImage:DisplayObject;
		
		
		
		
		protected var m_selectedIconUpImage:DisplayObject;
		protected var m_selectedIconOverImage:DisplayObject;
		protected var m_selectedIconDownImage:DisplayObject;
		protected var m_selectedIconDisableImage:DisplayObject;
		
		
		
		
		
		/** @private */
		protected var m_iconUpFilters:Array;
		/** @private */
		protected var m_iconOverFilters:Array;
		/** @private */
		protected var m_iconDownFilters:Array;
		/** @private */
		protected var m_iconDisableFilters:Array;
		
		
		
		protected var m_selectedIconUpFilters:Array;
		protected var m_selectedIconOverFilters:Array;
		protected var m_selectedIconDownFilters:Array;
		protected var m_selectedIconDisableFilters:Array;
		
		
		/** @private */
		protected var m_iconDir:String;
		
		
		
		/** @private */
		protected var m_iconCurFilters:Array;
		/** @private */
		protected var m_curIconImage:DisplayObject;
		
		
		
		
		public function IconToggleButton()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_iconDir = LEFT;
			
			m_iconOverFilters = OVERFILTERS;
			m_iconDisableFilters = DISABLEDFILTERS;
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			if(m_curIconImage) addChild(m_curIconImage);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function updateLabel():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.updateLabel();
			
			updateCurrentIconStateImage();
			
			updateCurrentIconStateFilters();
			
			super.onProppertiesUpdate();
		}
		
		/**
		 * 更新当前状态的显示对象和图标显示对象
		 */		
		protected function updateCurrentIconStateImage():void
		{
			if(isChanged(ICONIMAGE) || m_stateChange)
			{
				var image:DisplayObject;
				
				var tmpImage:DisplayObject;
				
				if(model.selected)
				{
					image = m_selectedIconUpImage;
					
					if(model.enabled == false)
					{
						tmpImage = m_selectedIconDisableImage;
					}
					else if(model.pressed)
					{
						tmpImage = m_selectedIconDownImage;
					}
					else if(model.rollOver)
					{
						tmpImage = m_selectedIconOverImage;
					}
				}
				else
				{
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
			}
		}
		
		/**
		 * 更新当前状态和图标的滤镜对象
		 */		
		protected function updateCurrentIconStateFilters():void
		{
			if((isChanged(ICONFILTERS) || m_stateChange) && m_curIconImage)
			{
				var filterlist:Array;
				var tmpFilters:Array;
				
				if(model.selected)
				{
					filterlist = m_selectedIconUpFilters;
					
					if(model.enabled == false)
					{
						tmpFilters = m_selectedIconDisableFilters;
					}
					else if(model.pressed)
					{
						tmpFilters = m_selectedIconDownFilters;
					}
					else if(model.rollOver)
					{
						tmpFilters = m_selectedIconOverFilters;
					}
				}
				else
				{
					filterlist = m_iconUpFilters;
					
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
				}
				
				if(tmpFilters != null)
				{
					filterlist = tmpFilters;
				}
				
				if(filterlist != m_iconCurFilters)
				{
					m_iconCurFilters = filterlist;
				}
				
				m_curIconImage.filters = m_iconCurFilters;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function validateSize():void
		{
			if(StringUtil.isNotNullOrEmpty(m_text) || m_labelChange || isChanged(ICONIMAGE) || isChanged(ICONGAP))
			{
				var tempWidth:int, tempHeight:int;
				
				if(m_iconDir == LEFT || m_iconDir == RIGHT)
				{
					tempWidth = m_label.width + m_iconWidth + m_iconGap;
					tempHeight = Math.max(m_label.height, m_iconHeight);
					
					if(m_width < tempWidth)
					{
						m_width = tempWidth;
						
						m_changeProperties.put(WIDTH, true);
					}
					
					if(m_height < tempHeight)
					{
						m_height = tempHeight;
						
						m_changeProperties.put(HEIGHT, true);
					}
				}
				else if(m_iconDir == TOP || m_iconDir == BOTTOM)
				{
					tempWidth = Math.max(m_label.width, m_iconWidth);
					tempHeight = m_label.height + m_iconHeight + m_iconGap;
					
					if(m_width < tempWidth)
					{
						m_width = tempWidth;
						
						m_changeProperties.put(WIDTH, true);
					}
					
					if(m_height < tempHeight)
					{
						m_height = tempHeight;
						
						m_changeProperties.put(HEIGHT, true);
					}
				}
				
				checkSizeWidthMinSize();
			}
		}
		
		
		
		/**
		 * 更新图标和文本位置
		 */		
		override protected function updateLabelPos():void
		{
			if(m_labelChange || m_stateChange || 
				isChanged(LABELALIGN) || 
				isChanged(ICONIMAGE) || 
				isChanged(ICONGAP) || 
				isChanged(ICONDIR) || 
				isChanged(WIDTH) || 
				isChanged(HEIGHT) || 
				isChanged(OFFSET))
			{
				m_label.x = m_label.y = 0;
				
				if(m_curIconImage)
				{
					m_curIconImage.x = m_curIconImage.y = 0;
					
					if(m_iconDir == LEFT || m_iconDir == RIGHT)
					{
						m_rect.width = m_label.width + m_iconWidth + m_iconGap;
						m_rect.height = Math.max(m_label.height, m_iconHeight);
						
						CompUtil.layoutPosition(width, height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
						
						refreshStateRectWidthOffset(m_rect);
						
						if(m_iconDir == LEFT)
						{
							m_curIconImage.x = m_rect.x;
							m_curIconImage.y = m_rect.y + (m_rect.height - m_iconHeight) / 2;
							
							m_label.x = m_rect.x + m_iconWidth + m_iconGap;
							m_label.y = m_rect.y + (m_rect.height - m_label.height) / 2;
						}
						else
						{
							m_label.x = m_rect.x;
							m_label.y = m_rect.y + (m_rect.height - m_label.height) / 2;
							
							m_curIconImage.x = m_rect.x + m_label.width + m_iconGap;
							m_curIconImage.y = m_rect.y + (m_rect.height - m_iconHeight) / 2;
						}
					}
					else if(m_iconDir == TOP || m_iconDir == BOTTOM)
					{
						m_rect.width = Math.max(m_label.width, m_iconWidth);
						m_rect.height = m_label.height + m_iconHeight + m_iconGap;
						
						CompUtil.layoutPosition(width, height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
						
						refreshStateRectWidthOffset(m_rect);
						
						if(m_iconDir == TOP)
						{
							m_curIconImage.x = m_rect.x + (m_rect.width - m_iconWidth) / 2;
							m_curIconImage.y = m_rect.y;
							
							m_label.x = m_rect.x + (m_rect.width - m_label.width) / 2;
							m_label.y = m_rect.y + m_iconHeight + m_iconGap;
						}
						else
						{
							m_label.x = m_rect.x + (m_rect.width - m_label.width) / 2;
							m_label.y = m_rect.y;
							
							m_curIconImage.x = m_rect.x + (m_rect.width - m_iconWidth) / 2;
							m_curIconImage.y = m_rect.y + m_label.height + m_iconGap;
						}
					}
				}
				else
				{
					m_rect.width = m_label.width;
					m_rect.height = m_label.height;
					
					CompUtil.layoutPosition(width, height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
					
					refreshStateRectWidthOffset(m_rect);
					
					m_label.x = m_rect.x;
					m_label.y = m_rect.y;
				}
			}
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
			
			
			
			DisposeUtil.free(m_selectedIconUpImage, m_freeBMD);
			m_selectedIconUpImage = null;
			
			DisposeUtil.free(m_selectedIconOverImage, m_freeBMD);
			m_selectedIconOverImage = null;
			
			DisposeUtil.free(m_selectedIconDownImage, m_freeBMD);
			m_selectedIconDownImage = null;
			
			DisposeUtil.free(m_selectedIconDisableImage, m_freeBMD);
			m_selectedIconDisableImage = null;
			
			
			
			
			m_iconUpFilters = null;
			m_iconOverFilters = null;
			m_iconDownFilters = null;
			m_iconDisableFilters = null;
			
			
			m_selectedIconUpFilters = null;
			m_selectedIconOverFilters = null;
			m_selectedIconDownFilters = null;
			m_selectedIconDisableFilters = null;
			
			
			m_curIconImage = null;
			m_iconCurFilters = null;
			
			super.dispose();
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
				
				if(m_iconUpImage)
				{
					m_iconWidth = m_iconUpImage.width;
					m_iconHeight = m_iconUpImage.height;
					
					if(m_upImage == null)
					{
						if(manualWidth == false) m_width = m_iconUpImage.width;
						if(manualHeight == false) m_height = m_iconUpImage.height;
					}
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
		
		/**
		 * 图标与文本的相对位置
		 */		
		public function get iconDir():String
		{
			return m_iconDir;
		}
		
		/** @private */
		public function set iconDir(value:String):void
		{
			if(m_iconDir != value && (value == LEFT || value == RIGHT || value == TOP || value == BOTTOM))
			{
				m_iconDir = value;
				
				onPropertiesChanged(ICONDIR);
			}
		}
		
		/**
		 * 图标与文本的间隔
		 */		
		public function get iconGap():int
		{
			return m_iconGap;
		}
		
		/** @private */
		public function set iconGap(value:int):void
		{
			if(m_iconGap != value)
			{
				m_iconGap = value;
				
				onPropertiesChanged(ICONGAP);
			}
		}

		/**
		 * 图标选中状态下鼠标弹起时的显示对象
		 */		
		public function get selectedIconUpImage():DisplayObject
		{
			return m_selectedIconUpImage;
		}
		
		/** @private */
		public function set selectedIconUpImage(value:DisplayObject):void
		{
			if(m_selectedIconUpImage != value)
			{
				DisposeUtil.free(m_selectedIconUpImage, m_freeBMD);
				
				m_selectedIconUpImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标选中状态下鼠标经过时的显示对象
		 */		
		public function get selectedIconOverImage():DisplayObject
		{
			return m_selectedIconOverImage;
		}
		
		/** @private */
		public function set selectedIconOverImage(value:DisplayObject):void
		{
			if(m_selectedIconOverImage != value)
			{
				DisposeUtil.free(m_selectedIconOverImage, m_freeBMD);
				
				m_selectedIconOverImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标选中状态下鼠标按下时的显示对象
		 */		
		public function get selectedIconDownImage():DisplayObject
		{
			return m_selectedIconDownImage;
		}
		
		/** @private */
		public function set selectedIconDownImage(value:DisplayObject):void
		{
			if(m_selectedIconDownImage != value)
			{
				DisposeUtil.free(m_selectedIconDownImage, m_freeBMD);
				
				m_selectedIconDownImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标选中状态下禁用时的显示对象
		 */		
		public function get selectedIconDisableImage():DisplayObject
		{
			return m_selectedIconDisableImage;
		}
		
		/** @private */
		public function set selectedIconDisableImage(value:DisplayObject):void
		{
			if(m_selectedIconDisableImage != value)
			{
				DisposeUtil.free(m_selectedIconDisableImage, m_freeBMD);
				
				m_selectedIconDisableImage = value;
				
				onPropertiesChanged(ICONIMAGE);
			}
		}
		
		/**
		 * 图标选中状态下鼠标弹起时的滤镜资源
		 */		
		public function get selectedIconUpFilters():Array
		{
			return m_selectedIconUpFilters;
		}
		
		/** @private */
		public function set selectedIconUpFilters(value:Array):void
		{
			if(m_selectedIconUpFilters != value)
			{
				m_selectedIconUpFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		/**
		 * 图标选中状态下鼠标经过时的滤镜资源
		 */		
		public function get selectedIconOverFilters():Array
		{
			return m_selectedIconOverFilters;
		}
		
		/** @private */
		public function set selectedIconOverFilters(value:Array):void
		{
			if(m_selectedIconOverFilters != value)
			{
				m_selectedIconOverFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		/**
		 * 图标选中状态下鼠标按下时的滤镜资源
		 */		
		public function get selectedIconDownFilters():Array
		{
			return m_selectedIconDownFilters;
		}
		
		/** @private */
		public function set selectedIconDownFilters(value:Array):void
		{
			if(m_selectedIconDownFilters != value)
			{
				m_selectedIconDownFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
		
		/**
		 * 图标选中状态下禁用时的滤镜资源
		 */		
		public function get selectedIconDisableFilters():Array
		{
			return m_selectedIconDisableFilters;
		}
		
		/** @private */
		public function set selectedIconDisableFilters(value:Array):void
		{
			if(m_selectedIconDisableFilters != value)
			{
				m_selectedIconDisableFilters = value;
				
				onPropertiesChanged(ICONFILTERS);
			}
		}
	}
}