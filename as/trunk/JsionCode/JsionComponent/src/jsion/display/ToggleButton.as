package jsion.display
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompUtil;
	import jsion.comps.ToggleGroup;
	import jsion.events.StateEvent;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	/**
	 * 可选中按钮。支持滤镜。
	 * 使用 jsion.display.Image 可支持九宫格缩放。
	 * @see jsion.display.Image
	 * @author Jsion
	 * 
	 */	
	public class ToggleButton extends LabelButton
	{
		/**
		 * @copy jsion.display.LabelButton#WIDTH
		 */		
		public static const WIDTH:String = LabelButton.WIDTH;
		
		/**
		 * @copy jsion.display.LabelButton#HEIGHT
		 */		
		public static const HEIGHT:String = LabelButton.HEIGHT;
		
		/**
		 * @copy jsion.display.LabelButton#STATEIMAGE
		 */		
		public static const STATEIMAGE:String = LabelButton.STATEIMAGE;
		/**
		 * @copy jsion.display.LabelButton#STATEFILTERS
		 */		
		public static const STATEFILTERS:String = LabelButton.STATEFILTERS;
		
		/**
		 * @copy jsion.display.LabelButton#OFFSET
		 */		
		public static const OFFSET:String = LabelButton.OFFSET;
		
		/**
		 * @copy jsion.display.LabelButton#LEFT
		 */		
		public static const LEFT:String = LabelButton.LEFT;
		
		/**
		 * @copy jsion.display.LabelButton#RIGHT
		 */		
		public static const RIGHT:String = LabelButton.RIGHT;
		
		/**
		 * @copy jsion.display.LabelButton#CENTER
		 */		
		public static const CENTER:String = LabelButton.CENTER;
		
		/**
		 * @copy jsion.display.LabelButton#TOP
		 */		
		public static const TOP:String = LabelButton.TOP;
		
		/**
		 * @copy jsion.display.LabelButton#BOTTOM
		 */		
		public static const BOTTOM:String = LabelButton.BOTTOM;
		
		/**
		 * @copy jsion.display.LabelButton#MIDDLE
		 */		
		public static const MIDDLE:String = LabelButton.MIDDLE;
		
		/**
		 * @copy jsion.display.LabelButton#LABELALIGN
		 */		
		public static const LABELALIGN:String = LabelButton.LABELALIGN;
		
		/**
		 * @copy jsion.display.LabelButton#LABELFILTERS
		 */		
		public static const LABELFILTERS:String = LabelButton.LABELFILTERS;
		
		
		/** @private */
		protected var m_selectedUpImage:DisplayObject;
		/** @private */
		protected var m_selectedOverImage:DisplayObject;
		/** @private */
		protected var m_selectedDownImage:DisplayObject;
		/** @private */
		protected var m_selectedDisableImage:DisplayObject;
		
		
		/** @private */
		protected var m_selectedOffsetX:int = 0;
		/** @private */
		protected var m_selectedOffsetY:int = 0;
		/** @private */
		protected var m_selectedOverOffsetX:int = 0;
		/** @private */
		protected var m_selectedOverOffsetY:int = 0;
		/** @private */
		protected var m_selectedDownOffsetX:int = 0;
		/** @private */
		protected var m_selectedDownOffsetY:int = 0;
		
		
		/** @private */
		protected var m_selectedUpFilters:Array;
		/** @private */
		protected var m_selectedOverFilters:Array;
		/** @private */
		protected var m_selectedDownFilters:Array;
		/** @private */
		protected var m_selectedDisableFilters:Array;
		
		
		
//		private var m_selectedLabelOffsetX:int = 0;
//		private var m_selectedLabelOffsetY:int = 0;
//		private var m_selectedLabelOverOffsetX:int = 0;
//		private var m_selectedLabelOverOffsetY:int = 0;
//		private var m_selectedLabelDownOffsetX:int = 0;
//		private var m_selectedLabelDownOffsetY:int = 0;
		
		
		/** @private */
		protected var m_selectedLabelUpFilters:Array;
		/** @private */
		protected var m_selectedLabelOverFilters:Array;
		/** @private */
		protected var m_selectedLabelDownFilters:Array;
		/** @private */
		protected var m_selectedLabelDisableFilters:Array;
		
		
		/** @private */
		protected var m_selectedText:String;
		/** @private */
		protected var m_selectedTextColor:uint;
		
		
		/** @private */
		protected var m_group:ToggleGroup;
		
		
		public function ToggleButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initEvents():void
		{
			super.initEvents();
			
			addEventListener(MouseEvent.CLICK, __clickHandler);
			
			model.addEventListener(StateEvent.SELECTION_CHANGED, __selectionChangeHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(m_group)
			{
				m_group.selected = this;
			}
			else
			{
				if(selected) selected = false;
				else selected = true;
			}
		}
		
		private function __selectionChangeHandler(e:StateEvent):void
		{
			m_stateChange = true;
			
			invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateLabel():void
		{
			if(model.selected)
			{
				if(StringUtil.isNotNullOrEmpty(m_selectedText))
				{
					m_label.text = m_selectedText;
				}
				
				if(m_selectedTextColor != 0)
				{
					m_label.textColor = m_selectedTextColor;
				}
			}
			else
			{
				super.updateLabel();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateCurrentStateImage():void
		{
			if(model.selected)
			{
				if(m_changeProperties.containsKey(STATEIMAGE) || m_stateChange)
				{
					var image:DisplayObject;
					
					var tmpImage:DisplayObject;
					
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
					
					updateImageSize();
				}
			}
			else
			{
				super.updateCurrentStateImage();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateCurrentStateFilters():void
		{
			if(model.selected)
			{
				if(m_changeProperties.containsKey(STATEFILTERS) || m_stateChange)
				{
					var filters:Array;
					var tmpFilters:Array;
					
					filters = m_selectedUpFilters;
					
					if(model.enabled == false)
					{
						tmpFilters = m_selectedDisableFilters;
					}
					else if(model.pressed)
					{
						tmpFilters = m_selectedDownFilters;
					}
					else if(model.rollOver)
					{
						tmpFilters = m_selectedOverFilters;
					}
					
					if(tmpFilters != null)
					{
						filters = tmpFilters;
					}
					
					if(filters != m_curFilters)
					{
						m_curFilters = filters;
					}
					
					m_imageLayer.filters = m_curFilters;
				}
			}
			else
			{
				super.updateCurrentStateFilters();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateLabelFilters():void
		{
			if(m_changeProperties.containsKey(LABELFILTERS) || m_stateChange)
			{
				if(model.selected)
				{
					var filters:Array;
					var tmpFilters:Array;
					
					filters = m_selectedLabelUpFilters;
					
					if(model.enabled == false)
					{
						tmpFilters = m_selectedLabelDisableFilters;
					}
					else if(model.pressed)
					{
						tmpFilters = m_selectedLabelDownFilters;
					}
					else if(model.rollOver)
					{
						tmpFilters = m_selectedLabelOverFilters;
					}
					
					if(tmpFilters != null)
					{
						filters = tmpFilters;
					}
					
					if(filters != m_labelCurFilters)
					{
						m_labelCurFilters = filters;
					}
					
					m_label.filters = m_labelCurFilters;
				}
				else
				{
					super.updateLabelFilters();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateLabelPos():void
		{
			if(m_labelChange || m_stateChange || 
				m_changeProperties.containsKey(LABELALIGN) || 
				m_changeProperties.containsKey(WIDTH) || 
				m_changeProperties.containsKey(HEIGHT) || 
				m_changeProperties.containsKey(OFFSET))
			{
				if(model.selected)
				{
					m_label.x = m_label.y = 0;
					
					m_rect.width = m_label.width;
					m_rect.height = m_label.height;
					
					CompUtil.layoutPosition(width, height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_rect);
					
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
					
					m_label.x = m_rect.x;
					m_label.y = m_rect.y;
				}
				else
				{
					super.updateLabelPos();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateImagePos():void
		{
			if(model.selected)
			{
				if(m_stateChange)
				{
					m_imageLayer.x = 0;
					m_imageLayer.y = 0;
					
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
			}
			else
			{
				super.updateImagePos();
			}
		}
		
		
		
		
		/**
		 * ToggleButton的分组对象
		 * @throws Error 同一个 ToggleButton 对象不能在两个不同的分组中。 
		 */		
		public function get group():ToggleGroup
		{
			return m_group;
		}
		
		/** @private */
		public function set group(value:ToggleGroup):void
		{
			if(m_group != null)
			{
				throw new Error("同一个 ToggleButton 对象不能在两个不同的分组中。");
			}
			
			m_group = value;
		}

		/**
		 * 获取或设置选择中状态
		 */		
		public function get selected():Boolean
		{
			return model.selected;
		}
		
		/** @private */
		public function set selected(value:Boolean):void
		{
			if(model.selected != value)
			{
				model.selected = value;
			}
		}
		
		/**
		 * 设置选中状态时的文本颜色 CSS样式会覆盖此设置
		 */		
		public function get selectedLabelColor():uint
		{
			return m_selectedTextColor;
		}
		
		/** @private */
		public function set selectedLabelColor(value:uint):void
		{
			if(m_selectedTextColor != value)
			{
				m_selectedTextColor = value;
				
				m_labelChange = true;
				
				invalidate();
			}
		}

		/**
		 * 当按钮为选中状态，弹起时的显示对象资源。
		 */
		public function get selectedUpImage():DisplayObject
		{
			return m_selectedUpImage;
		}
		
		/** @private */
		public function set selectedUpImage(value:DisplayObject):void
		{
			if(m_selectedUpImage != value)
			{
				DisposeUtil.free(m_selectedUpImage, m_freeBMD);
				
				m_selectedUpImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标经过时的显示对象资源。
		 */
		public function get selectedOverImage():DisplayObject
		{
			return m_selectedOverImage;
		}
		
		/** @private */
		public function set selectedOverImage(value:DisplayObject):void
		{
			if(m_selectedOverImage != value)
			{
				DisposeUtil.free(m_selectedOverImage, m_freeBMD);
				
				m_selectedOverImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标按下时的显示对象资源。
		 */
		public function get selectedDownImage():DisplayObject
		{
			return m_selectedDownImage;
		}
		
		/** @private */
		public function set selectedDownImage(value:DisplayObject):void
		{
			if(m_selectedDownImage != value)
			{
				DisposeUtil.free(m_selectedDownImage, m_freeBMD);
				
				m_selectedDownImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 当按钮为选中状态，禁用时的显示对象资源。
		 */
		public function get selectedDisableImage():DisplayObject
		{
			return m_selectedDisableImage;
		}
		
		/** @private */
		public function set selectedDisableImage(value:DisplayObject):void
		{
			if(m_selectedDisableImage != value)
			{
				DisposeUtil.free(m_selectedDisableImage, m_freeBMD);
				
				m_selectedDisableImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		
		
		
		/**
		 * 当按钮为选中状态，按钮状态显示对象x坐标偏移量
		 */
		public function get selectedOffsetX():int
		{
			return m_selectedOffsetX;
		}
		
		/** @private */
		public function set selectedOffsetX(value:int):void
		{
			if(m_selectedOffsetX != value)
			{
				m_selectedOffsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 当按钮为选中状态，按钮状态显示对象y坐标偏移量
		 */
		public function get selectedOffsetY():int
		{
			return m_selectedOffsetY;
		}
		
		/** @private */
		public function set selectedOffsetY(value:int):void
		{
			if(m_selectedOffsetY != value)
			{
				m_selectedOffsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标经过状态显示对象x坐标偏移量
		 */
		public function get selectedOverOffsetX():int
		{
			return m_selectedOverOffsetX;
		}
		
		/** @private */
		public function set selectedOverOffsetX(value:int):void
		{
			if(m_selectedOverOffsetX != value)
			{
				m_selectedOverOffsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标经过状态显示对象y坐标偏移量
		 */
		public function get selectedOverOffsetY():int
		{
			return m_selectedOverOffsetY;
		}
		
		/** @private */
		public function set selectedOverOffsetY(value:int):void
		{
			if(m_selectedOverOffsetY != value)
			{
				m_selectedOverOffsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标按下状态显示对象x坐标偏移量
		 */
		public function get selectedDownOffsetX():int
		{
			return m_selectedDownOffsetX;
		}
		
		/** @private */
		public function set selectedDownOffsetX(value:int):void
		{
			if(m_selectedOverOffsetY != value)
			{
				m_selectedDownOffsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标按下状态显示对象y坐标偏移量
		 */
		public function get selectedDownOffsetY():int
		{
			return m_selectedDownOffsetY;
		}
		
		/** @private */
		public function set selectedDownOffsetY(value:int):void
		{
			if(m_selectedDownOffsetY != value)
			{
				m_selectedDownOffsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		
		
		
		
		
		
		/**
		 * 当按钮为选中状态，弹起时的滤镜对象
		 */
		public function get selectedUpFilters():Array
		{
			return m_selectedUpFilters;
		}
		
		/** @private */
		public function set selectedUpFilters(value:Array):void
		{
			if(m_selectedUpFilters != value)
			{
				m_selectedUpFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标经过时的滤镜对象
		 */
		public function get selectedOverFilters():Array
		{
			return m_selectedOverFilters;
		}
		
		/** @private */
		public function set selectedOverFilters(value:Array):void
		{
			if(m_selectedOverFilters != value)
			{
				m_selectedOverFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 当按钮为选中状态，按下时的滤镜对象
		 */
		public function get selectedDownFilters():Array
		{
			return m_selectedDownFilters;
		}
		
		/** @private */
		public function set selectedDownFilters(value:Array):void
		{
			if(m_selectedDownFilters != value)
			{
				m_selectedDownFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 当按钮为选中状态，禁用时的滤镜对象
		 */
		public function get selectedDisableFilters():Array
		{
			return m_selectedDisableFilters;
		}
		
		/** @private */
		public function set selectedDisableFilters(value:Array):void
		{
			if(m_selectedDisableFilters != value)
			{
				m_selectedDisableFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		
		
		
		
		
//		/**
//		 * 当按钮为选中状态，文本的x坐标偏移量
//		 */
//		public function get selectedLabelOffsetX():int
//		{
//			return m_selectedLabelOffsetX;
//		}
//		
//		/** @private */
//		public function set selectedLabelOffsetX(value:int):void
//		{
//			if(m_selectedLabelOffsetX != value)
//			{
//				m_selectedLabelOffsetX = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 当按钮为选中状态，文本的y坐标偏移量
//		 */
//		public function get selectedLabelOffsetY():int
//		{
//			return m_selectedLabelOffsetY;
//		}
//		
//		/** @private */
//		public function set selectedLabelOffsetY(value:int):void
//		{
//			if(m_selectedLabelOffsetY != value)
//			{
//				m_selectedLabelOffsetY = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 当按钮为选中状态，鼠标经过时文本的x坐标偏移量
//		 */
//		public function get selectedLabelOverOffsetX():int
//		{
//			return m_selectedLabelOverOffsetX;
//		}
//		
//		/** @private */
//		public function set selectedLabelOverOffsetX(value:int):void
//		{
//			if(m_selectedLabelOverOffsetX != value)
//			{
//				m_selectedLabelOverOffsetX = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 当按钮为选中状态，鼠标经过时文本的y坐标偏移量
//		 */
//		public function get selectedLabelOverOffsetY():int
//		{
//			return m_selectedLabelOverOffsetY;
//		}
//		
//		/** @private */
//		public function set selectedLabelOverOffsetY(value:int):void
//		{
//			if(m_selectedLabelOverOffsetY != value)
//			{
//				m_selectedLabelOverOffsetY = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 当按钮为选中状态，鼠标按下时文本的x坐标偏移量
//		 */
//		public function get selectedLabelDownOffsetX():int
//		{
//			return m_selectedLabelDownOffsetX;
//		}
//		
//		/** @private */
//		public function set selectedLabelDownOffsetX(value:int):void
//		{
//			if(m_selectedLabelDownOffsetX != value)
//			{
//				m_selectedLabelDownOffsetX = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
//		
//		/**
//		 * 当按钮为选中状态，鼠标经过时文本的y坐标偏移量
//		 */
//		public function get selectedLabelDownOffsetY():int
//		{
//			return m_selectedLabelDownOffsetY;
//		}
//		
//		/** @private */
//		public function set selectedLabelDownOffsetY(value:int):void
//		{
//			if(m_selectedLabelDownOffsetY != value)
//			{
//				m_selectedLabelDownOffsetY = value;
//				
//				onPropertiesChanged(LABELOFFSET);
//			}
//		}
		
		
		
		
		
		
		/**
		 * 当按钮为选中状态，弹起时 Label 对象的滤镜对象
		 */
		public function get selectedLabelUpFilters():Array
		{
			return m_selectedLabelUpFilters;
		}
		
		/** @private */
		public function set selectedLabelUpFilters(value:Array):void
		{
			if(m_selectedLabelUpFilters != value)
			{
				m_selectedLabelUpFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标经过时 Label 对象的滤镜对象
		 */
		public function get selectedLabelOverFilters():Array
		{
			return m_selectedLabelOverFilters;
		}
		
		/** @private */
		public function set selectedLabelOverFilters(value:Array):void
		{
			if(m_selectedLabelOverFilters != value)
			{
				m_selectedLabelOverFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
		/**
		 * 当按钮为选中状态，鼠标按下时 Label 对象的滤镜对象
		 */
		public function get selectedLabelDownFilters():Array
		{
			return m_selectedLabelDownFilters;
		}
		
		/** @private */
		public function set selectedLabelDownFilters(value:Array):void
		{
			if(m_selectedLabelDownFilters != value)
			{
				m_selectedLabelDownFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}
		
		/**
		 * 当按钮为选中状态，禁用时 Label 对象的滤镜对象
		 */
		public function get selectedLabelDisableFilters():Array
		{
			return m_selectedLabelDisableFilters;
		}
		
		/** @private */
		public function set selectedLabelDisableFilters(value:Array):void
		{
			if(m_selectedLabelDisableFilters != value)
			{
				m_selectedLabelDisableFilters = value;
				
				onPropertiesChanged(LABELFILTERS);
			}
		}

		/**
		 * 当按钮为选中状态 @copy jsion.display.Label#text
		 */		
		public function get selectedText():String
		{
			return m_selectedText;
		}
		
		/** @private */
		public function set selectedText(value:String):void
		{
			if(m_selectedText != value && StringUtil.isNotNullOrEmpty(value))
			{
				m_selectedText = value;
				
				m_labelChange = true;
				
				invalidate();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(m_group) m_group.remove(this);
			m_group = null;
			
			DisposeUtil.free(m_selectedUpImage);
			m_selectedUpImage = null;
			
			DisposeUtil.free(m_selectedOverImage);
			m_selectedOverImage = null;
			
			DisposeUtil.free(m_selectedDownImage);
			m_selectedDownImage = null;
			
			DisposeUtil.free(m_selectedDisableImage);
			m_selectedDisableImage = null;
			
			m_selectedUpFilters = null;
			m_selectedOverFilters = null;
			m_selectedDownFilters = null;
			m_selectedDisableFilters = null;
			
			m_selectedLabelUpFilters = null;
			m_selectedLabelOverFilters = null;
			m_selectedLabelDownFilters = null;
			m_selectedLabelDisableFilters = null;
			
			super.dispose();
		}
	}
}