package jsion.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.utils.DisposeUtil;

	/**
	 * 复选框。支持滤镜。不支持九宫格。
	 * @author Jsion
	 * 
	 */	
	public class CheckBox extends ToggleButton
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
		 * 水平左边对齐，用于 hAlign、imageDir、imageAlign 属性。
		 */		
		public static const LEFT:String = ToggleButton.LEFT;
		
		/**
		 * 水平右边对齐，用于 hAlign、imageDir、imageAlign 属性。
		 */		
		public static const RIGHT:String = ToggleButton.RIGHT;
		
		/**
		 * 水平居中对齐，用于 hAlign、imageAlign 属性。
		 */		
		public static const CENTER:String = ToggleButton.CENTER;
		
		/**
		 * 垂直顶边对齐，用于 vAlign、imageAlign 属性。
		 */		
		public static const TOP:String = ToggleButton.TOP;
		
		/**
		 * 垂直底边对齐，用于 vAlign、imageAlign 属性。
		 */		
		public static const BOTTOM:String = ToggleButton.BOTTOM;
		
		/**
		 * 垂直居中对齐，用于 vAlign、imageAlign 属性。
		 */		
		public static const MIDDLE:String = ToggleButton.MIDDLE;
		
		/**
		 * 上方向，用于 imageDir 属性。
		 */		
		public static const UP:String = CompGlobal.UP;
		
		/**
		 * 下方向，用于 imageDir 属性。
		 */		
		public static const DOWN:String = CompGlobal.DOWN;
		
		/**
		 * 文本对齐方式变更
		 */		
		public static const LABELALIGN:String = ToggleButton.LABELALIGN;
		
		/**
		 * 文本滤镜变更
		 */		
		public static const LABELFILTERS:String = ToggleButton.LABELFILTERS;
		
		/**
		 * 状态显示对象方位、对齐方式、偏移变更
		 */		
		public static const IMAGEDIRANDALIGN:String = "imageDirAndAlign";
		
		
		private var m_imageWidth:int;
		private var m_imageHeight:int;
		
		private var m_imageDir:String;
		private var m_imageAlign:String;
		private var m_imageOffsetX:int;
		private var m_imageOffsetY:int;
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_imageDir = LEFT;
			m_imageAlign = MIDDLE;
		}
		
		/**
		 * @private
		 */		
		override public function set upImage(value:DisplayObject):void
		{
			if(m_upImage != value)
			{
				DisposeUtil.free(m_upImage, m_freeBMD);
				
				m_upImage = value;
				
				if(m_upImage)
				{
					m_imageWidth = m_upImage.width;
					m_imageHeight = m_upImage.height;
				}
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function updateCurrentStateImage():void
		{
			//super.updateCurrentStateImage();
			
			if(isChanged(STATEIMAGE) || m_stateChange)
			{
				var image:DisplayObject;
				
				var tmpImage:DisplayObject;
				
				if(model.selected)
				{
					image = m_selectedUpImage;
					
					if(model.enabled == false)
					{
						tmpImage = m_selectedDisableImage;
					}
					else if(model.pressed)
					{
						tmpImage = m_selectedDownImage;
					}
					else if(model.rollOver)
					{
						tmpImage = m_selectedOverImage;
					}
				}
				else
				{
					image = m_upImage;
					
					if(model.enabled == false)
					{
						tmpImage = m_disableImage;
					}
					else if(model.pressed)
					{
						tmpImage = m_downImage;
					}
					else if(model.rollOver)
					{
						tmpImage = m_overImage;
					}
				}
				
				if(tmpImage != null)
				{
					image = tmpImage;
				}
				
				if(image != m_curImage)
				{
					if(m_curImage && m_curImage.parent)
					{
						m_curImage.parent.removeChild(m_curImage);
					}
					
					m_curImage = image;
				}
				
				if(m_curImage)
				{
					m_imageLayer.addChild(m_curImage);
				}
			}
		}
		
		/**
		 * 不更新状态显示对象的大小
		 */		
		override protected function updateImageSize():void { }
		
		/**
		 * @inheritDoc
		 */		
		override protected function updateImagePos():void
		{
			//super.updateImagePos();
			
			refreshSize();
			
			if(m_stateChange || m_labelChange || 
				isChanged(IMAGEDIRANDALIGN) || 
				isChanged(STATEIMAGE) || 
				isChanged(WIDTH) || 
				isChanged(HEIGHT) || 
				isChanged(OFFSET))
			{
				m_rect.width = m_imageWidth;
				m_rect.height = m_imageHeight;
				
				if(m_imageDir == LEFT || m_imageDir == RIGHT)
				{
					CompUtil.layoutPosition(m_width, m_height, m_imageDir, m_imageOffsetX, m_imageAlign, m_imageOffsetY, m_rect);
				}
				else
				{
					CompUtil.layoutPosition(m_width, m_height, m_imageAlign, m_imageOffsetX, m_imageDir, m_imageOffsetY, m_rect);
				}
				
				m_imageLayer.x = m_rect.x;
				m_imageLayer.y = m_rect.y;
				
				if(model.selected)
				{
					if(model.pressed)
					{
						m_imageLayer.x += m_selectedDownOffsetX;
						m_imageLayer.y += m_selectedDownOffsetY;
					}
					else if(model.rollOver)
					{
						m_imageLayer.x += m_selectedOverOffsetX;
						m_imageLayer.y += m_selectedOverOffsetY;
					}
					else
					{
						m_imageLayer.x += m_selectedOffsetX;
						m_imageLayer.y += m_selectedOffsetY;
					}
				}
				else
				{
					if(model.pressed)
					{
						m_imageLayer.x += m_downOffsetX;
						m_imageLayer.y += m_downOffsetY;
					}
					else if(model.rollOver)
					{
						m_imageLayer.x += m_overOffsetX;
						m_imageLayer.y += m_overOffsetY;
					}
					else
					{
						m_imageLayer.x += m_offsetX;
						m_imageLayer.y += m_offsetY;
					}
				}
			}
		}
		
		/**
		 * 不需要检查并更新按钮文本是否大于按钮本身，此函数置空。
		 */		
		override protected function validateSize():void { }
		
		/**
		 * @inheritDoc
		 */		
		override protected function updateLabelPos():void
		{
			//super.updateLabelPos();
			
			refreshSize();
			
			if(m_labelChange || m_stateChange || 
				isChanged(LABELALIGN) || 
				isChanged(WIDTH) || 
				isChanged(HEIGHT) || 
				isChanged(OFFSET) ||
				isChanged(IMAGEDIRANDALIGN))
			{
				m_rect.width = m_label.width;
				m_rect.height = m_label.height;
				
				if(m_imageDir == LEFT)
				{
					CompUtil.layoutPosition(m_width - m_imageWidth, m_height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
					
					m_rect.x += m_imageWidth;
				}
				else if(m_imageDir == RIGHT)
				{
					CompUtil.layoutPosition(m_width - m_imageWidth, m_height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
				}
				else if(m_imageDir == UP)
				{
					CompUtil.layoutPosition(m_width, m_height - m_imageHeight, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
					
					m_rect.y += m_imageHeight;
				}
				else if(m_imageDir == DOWN)
				{
					CompUtil.layoutPosition(m_width, m_height - m_imageHeight, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
				}
				
				if(model.selected)
				{
					if(model.pressed)
					{
						m_rect.x += m_selectedDownOffsetX;
						m_rect.y += m_selectedDownOffsetY;
					}
					else if(model.rollOver)
					{
						m_rect.x += m_selectedOverOffsetX;
						m_rect.y += m_selectedOverOffsetY;
					}
					else
					{
						m_rect.x += m_selectedOffsetX;
						m_rect.y += m_selectedOffsetY;
					}
				}
				else
				{
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
				}
				
				m_label.x = m_rect.x;
				m_label.y = m_rect.y;
			}
		}
		
		/**
		 * 更新宽度和高度值
		 */		
		protected function refreshSize():void
		{
			if(m_imageDir == LEFT || m_imageDir == RIGHT)
			{
				if(manualWidth == false)
				{
					m_width = m_imageWidth + m_label.width;
				}
				
				if(manualHeight == false)
				{
					m_height = Math.max(m_imageHeight, m_label.height);
				}
			}
			else
			{
				if(manualWidth == false)
				{
					m_width = Math.max(m_imageWidth, m_label.width);
				}
				
				if(manualHeight == false)
				{
					m_height = m_imageHeight + m_label.height;
				}
			}
		}
		
		
		/**
		 * 获取或设置状态显示对象的显示方位
		 * 可能的值有：
		 * <ul>
		 * 	<li>CheckBox.LEFT</li>
		 * 	<li>CheckBox.RIGHT</li>
		 * 	<li>CheckBox.TOP</li>
		 * 	<li>CheckBox.BOTTOM</li>
		 * </ul>
		 * 
		 * <p>当此属性的值设置为 CheckBox.LEFT 或 CheckBox.RIGHT 并且 imageAlign 属性的值不是 CheckBox.TOP、CheckBox.BOTTOM 或 CheckBox.MIDDLE 中的任一个时, 会将 imageAlign 属性设置为 CheckBox.MIDDLE。</p>
		 * <p>当此属性的值设置为 CheckBox.TOP 或 CheckBox.BOTTOM 并且 imageAlign 属性的值不是 CheckBox.LEFT、CheckBox.RIGHT 或 CheckBox.CENTER 中的任一个时, 会将 imageAlign 属性设置为 CheckBox.CENTER。</p>
		 */
		public function get imageDir():String
		{
			return m_imageDir;
		}
		
		/** @private */
		public function set imageDir(value:String):void
		{
			if(m_imageDir != value && (value == LEFT || value == RIGHT || value == UP || value == DOWN))
			{
				m_imageDir = value;
				
				if(m_imageDir == LEFT || m_imageDir == RIGHT)
				{
					if(m_imageAlign != TOP && m_imageAlign != BOTTOM && m_imageAlign != MIDDLE)
					{
						m_imageAlign = MIDDLE;
					}
				}
				else
				{
					if(m_imageAlign != LEFT && m_imageAlign != RIGHT && m_imageAlign != CENTER)
					{
						m_imageAlign = CENTER;
					}
				}
				
				onPropertiesChanged(IMAGEDIRANDALIGN);
			}
		}
		
		/**
		 * 状态显示对象的对齐方式,其值取决于 imageDir 属性,会被 imageDir 属性重置。
		 * 可能的值为：
		 * <ul>
		 * 	<li>CheckBox.LEFT</li>
		 * 	<li>CheckBox.RIGHT</li>
		 * 	<li>CheckBox.CENTER</li>
		 * 	<li>CheckBox.TOP</li>
		 * 	<li>CheckBox.BOTTOM</li>
		 * 	<li>CheckBox.MIDDLE</li>
		 * </ul>
		 */		
		public function get imageAlign():String
		{
			return m_imageAlign;
		}
		
		/** @private */
		public function set imageAlign(value:String):void
		{
			if(m_imageAlign != value)
			{
				if((m_imageDir == UP || m_imageDir == DOWN) && (value == LEFT || value == RIGHT || value == CENTER))
				{
					m_imageAlign = value;
					
					onPropertiesChanged(IMAGEDIRANDALIGN);
				}
				else if((m_imageDir == LEFT || m_imageDir == RIGHT) && (value == TOP || value == BOTTOM || value == MIDDLE))
				{
					m_imageAlign = value;
					
					onPropertiesChanged(IMAGEDIRANDALIGN);
				}
				else
				{
					throw new Error("状态显示对象的对齐方式设置错误。");
				}
			}
		}
		
		/**
		 * 状态显示对象 x 坐标偏移量
		 */		
		public function get imageOffsetX():int
		{
			return m_imageOffsetX;
		}
		
		/** @private */
		public function set imageOffsetX(value:int):void
		{
			if(m_imageOffsetX != value)
			{
				m_imageOffsetX = value;
				
				onPropertiesChanged(IMAGEDIRANDALIGN);
			}
		}
		
		/**
		 * 状态显示对象 y 坐标偏移量
		 */		
		public function get imageOffsetY():int
		{
			return m_imageOffsetY;
		}
		
		/** @private */
		public function set imageOffsetY(value:int):void
		{
			if(m_imageOffsetY != value)
			{
				m_imageOffsetY = value;
				
				onPropertiesChanged(IMAGEDIRANDALIGN);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}