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
		private var m_selectedUpImage:DisplayObject;
		private var m_selectedOverImage:DisplayObject;
		private var m_selectedDownImage:DisplayObject;
		private var m_selectedDisableImage:DisplayObject;
		
		
		private var m_selectedOffsetX:Number = 0;
		private var m_selectedOffsetY:Number = 0;
		private var m_selectedOverOffsetX:Number = 0;
		private var m_selectedOverOffsetY:Number = 0;
		private var m_selectedDownOffsetX:Number = 0;
		private var m_selectedDownOffsetY:Number = 0;
		
		
		private var m_selectedUpFilters:Array;
		private var m_selectedOverFilters:Array;
		private var m_selectedDownFilters:Array;
		private var m_selectedDisableFilters:Array;
		
		
		
//		private var m_selectedLabelOffsetX:Number = 0;
//		private var m_selectedLabelOffsetY:Number = 0;
//		private var m_selectedLabelOverOffsetX:Number = 0;
//		private var m_selectedLabelOverOffsetY:Number = 0;
//		private var m_selectedLabelDownOffsetX:Number = 0;
//		private var m_selectedLabelDownOffsetY:Number = 0;
		
		
		private var m_selectedLabelUpFilters:Array;
		private var m_selectedLabelOverFilters:Array;
		private var m_selectedLabelDownFilters:Array;
		private var m_selectedLabelDisableFilters:Array;
		
		
		private var m_selectedText:String;
		private var m_selectedTextColor:uint;
		
		
		private var m_group:ToggleGroup;
		
		
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
					m_curImage.width = m_width;
					m_curImage.height = m_height;
					
					m_imageLayer.addChild(m_curImage);
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
		
		/**
		 * @inheritDoc
		 */
		override protected function updateLabelPos():void
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
		
		/**
		 * @inheritDoc
		 */
		override protected function updateImagePos():void
		{
			if(model.selected)
			{
				m_curImage.x = 0;
				m_curImage.y = 0;
				
				if(model.pressed)
				{
					m_curImage.x += m_selectedDownOffsetX;
					m_curImage.y += m_selectedDownOffsetY;
				}
				else if(model.rollOver)
				{
					m_curImage.x += m_selectedOverOffsetX;
					m_curImage.y += m_selectedOverOffsetY;
				}
				else
				{
					m_curImage.x += m_selectedOffsetX;
					m_curImage.y += m_selectedOffsetY;
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
		public function get selectedOffsetX():Number
		{
			return m_selectedOffsetX;
		}
		
		/** @private */
		public function set selectedOffsetX(value:Number):void
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
		public function get selectedOffsetY():Number
		{
			return m_selectedOffsetY;
		}
		
		/** @private */
		public function set selectedOffsetY(value:Number):void
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
		public function get selectedOverOffsetX():Number
		{
			return m_selectedOverOffsetX;
		}
		
		/** @private */
		public function set selectedOverOffsetX(value:Number):void
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
		public function get selectedOverOffsetY():Number
		{
			return m_selectedOverOffsetY;
		}
		
		/** @private */
		public function set selectedOverOffsetY(value:Number):void
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
		public function get selectedDownOffsetX():Number
		{
			return m_selectedDownOffsetX;
		}
		
		/** @private */
		public function set selectedDownOffsetX(value:Number):void
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
		public function get selectedDownOffsetY():Number
		{
			return m_selectedDownOffsetY;
		}
		
		/** @private */
		public function set selectedDownOffsetY(value:Number):void
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
//		public function get selectedLabelOffsetX():Number
//		{
//			return m_selectedLabelOffsetX;
//		}
//		
//		/** @private */
//		public function set selectedLabelOffsetX(value:Number):void
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
//		public function get selectedLabelOffsetY():Number
//		{
//			return m_selectedLabelOffsetY;
//		}
//		
//		/** @private */
//		public function set selectedLabelOffsetY(value:Number):void
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
//		public function get selectedLabelOverOffsetX():Number
//		{
//			return m_selectedLabelOverOffsetX;
//		}
//		
//		/** @private */
//		public function set selectedLabelOverOffsetX(value:Number):void
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
//		public function get selectedLabelOverOffsetY():Number
//		{
//			return m_selectedLabelOverOffsetY;
//		}
//		
//		/** @private */
//		public function set selectedLabelOverOffsetY(value:Number):void
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
//		public function get selectedLabelDownOffsetX():Number
//		{
//			return m_selectedLabelDownOffsetX;
//		}
//		
//		/** @private */
//		public function set selectedLabelDownOffsetX(value:Number):void
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
//		public function get selectedLabelDownOffsetY():Number
//		{
//			return m_selectedLabelDownOffsetY;
//		}
//		
//		/** @private */
//		public function set selectedLabelDownOffsetY(value:Number):void
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