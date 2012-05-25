package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.comps.Component;
	import jsion.events.StateEvent;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 图片按钮。支持滤镜。此类为按钮基类,不支持显示文字;
	 * 需要显示文字可以使用 jsion.display.LabelButton 类。
	 * 使用 jsion.display.Image 可支持九宫格缩放。
	 * @see jsion.display.Image
	 * @author Jsion
	 * 
	 */	
	public class Button extends Component
	{
		/**
		 * @copy jsion.comps.Component#WIDTH
		 */		
		public static const WIDTH:String = Component.WIDTH;
		
		/**
		 * @copy jsion.comps.Component#HEIGHT
		 */		
		public static const HEIGHT:String = Component.HEIGHT;
		
		/**
		 * 状态显示对象资源变更
		 */		
		public static const STATEIMAGE:String = "stateImage";
		/**
		 * 状态显示对象滤镜变更
		 */		
		public static const STATEFILTERS:String = "stateFilters";
		
		/**
		 * 状态显示对象偏移变量
		 */		
		public static const OFFSET:String = "offset";
		
		/** @private */
		protected var m_imageLayer:Sprite;
		
		/** @private */
		protected var m_curImage:DisplayObject;
		
		/** @private */
		protected var m_curFilters:Array;
		
		
		/** @private */
		protected var m_upImage:DisplayObject;
		/** @private */
		protected var m_overImage:DisplayObject;
		/** @private */
		protected var m_downImage:DisplayObject;
		/** @private */
		protected var m_disableImage:DisplayObject;
		
		/** @private */
		protected var m_minWidth:int;
		/** @private */
		protected var m_minHeight:int;
		
		/** @private */
		protected var m_offsetX:int = 0;
		/** @private */
		protected var m_offsetY:int = 0;
		/** @private */
		protected var m_overOffsetX:int = 0;
		/** @private */
		protected var m_overOffsetY:int = 0;
		/** @private */
		protected var m_downOffsetX:int = 0;
		/** @private */
		protected var m_downOffsetY:int = 0;
		
		
		/** @private */
		protected var m_upFilters:Array;
		/** @private */
		protected var m_overFilters:Array;
		/** @private */
		protected var m_downFilters:Array;
		/** @private */
		protected var m_disableFilters:Array;
		
		
		/** @private */
		protected var m_freeBMD:Boolean;
		
		/** @private */
		protected var m_stateChange:Boolean;
		
		public function Button()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			buttonMode = true;
			
			m_freeBMD = false;
			m_stateChange = false;
			
			m_imageLayer = new Sprite();
			m_imageLayer.mouseEnabled = false;
			m_imageLayer.mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_imageLayer);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initEvents():void
		{
			super.initEvents();
			
			model.addEventListener(StateEvent.STATE_CHANGED, __stateChangeHandler);
		}
		
		private function __stateChangeHandler(e:StateEvent):void
		{
			m_stateChange = true;
			
			invalidate();
		}
		
		/**
		 * 最小宽度
		 */		
		public function get minWidth():int
		{
			return m_minWidth;
		}
		
		/**
		 * 最小高度
		 */		
		public function get minHeight():int
		{
			return m_minHeight;
		}
		
		/**
		 * 按钮弹起时的显示对象资源
		 * 如果宽度和高度未设置时会根据此显示对象的宽高来设置对应的值
		 */		
		public function get upImage():DisplayObject
		{
			return m_upImage;
		}

		/** @private */
		public function set upImage(value:DisplayObject):void
		{
			if(m_upImage != value)
			{
				DisposeUtil.free(m_upImage, m_freeBMD);
				
				m_upImage = value;
				
				if(m_upImage)
				{
					if(manualWidth == false) m_width = m_upImage.width;
					if(manualHeight == false) m_height = m_upImage.height;
					
					if(m_upImage is Image)
					{
						m_minWidth = Image(m_upImage).minWidth;
						m_minHeight = Image(m_upImage).minHeight;
					}
					else
					{
						m_minWidth = 0;
						m_minHeight = 0;
					}
				}
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 按钮鼠标经过时的显示对象资源
		 */		
		public function get overImage():DisplayObject
		{
			return m_overImage;
		}
		
		/** @private */
		public function set overImage(value:DisplayObject):void
		{
			if(m_overImage != value)
			{
				DisposeUtil.free(m_overImage, m_freeBMD);
				
				m_overImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 按钮按下时的显示对象资源
		 */		
		public function get downImage():DisplayObject
		{
			return m_downImage;
		}
		
		/** @private */
		public function set downImage(value:DisplayObject):void
		{
			if(m_downImage != value)
			{
				DisposeUtil.free(m_downImage, m_freeBMD);
				
				m_downImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 按钮禁用时的显示对象资源
		 */		
		public function get disableImage():DisplayObject
		{
			return m_disableImage;
		}
		
		/** @private */
		public function set disableImage(value:DisplayObject):void
		{
			if(m_disableImage != value)
			{
				DisposeUtil.free(m_disableImage, m_freeBMD);
				
				m_disableImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 按钮弹起时的滤镜对象
		 */		
		public function get upFilters():Array
		{
			return m_upFilters;
		}
		
		/** @private */
		public function set upFilters(value:Array):void
		{
			if(m_upFilters != value)
			{
				m_upFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 按钮鼠标经过时的滤镜对象
		 */		
		public function get overFilters():Array
		{
			return m_overFilters;
		}
		
		/** @private */
		public function set overFilters(value:Array):void
		{
			if(m_overFilters != value)
			{
				m_overFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 按钮按下时的滤镜对象
		 */		
		public function get downFilters():Array
		{
			return m_downFilters;
		}
		
		/** @private */
		public function set downFilters(value:Array):void
		{
			if(m_downFilters != value)
			{
				m_downFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 按钮禁用时的滤镜对象
		 */		
		public function get disableFilters():Array
		{
			return m_disableFilters;
		}
		
		/** @private */
		public function set disableFilters(value:Array):void
		{
			if(m_disableFilters != value)
			{
				m_disableFilters = value;
				
				onPropertiesChanged(STATEFILTERS);
			}
		}
		
		/**
		 * 按钮状态显示对象x坐标偏移量
		 */
		public function get offsetX():int
		{
			return m_offsetX;
		}
		
		/** @private */
		public function set offsetX(value:int):void
		{
			if(m_offsetX != value)
			{
				m_offsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 按钮状态显示对象y坐标偏移量
		 */
		public function get offsetY():int
		{
			return m_offsetY;
		}
		
		/** @private */
		public function set offsetY(value:int):void
		{
			if(m_offsetY != value)
			{
				m_offsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象x坐标偏移量
		 */
		public function get overOffsetX():int
		{
			return m_overOffsetX;
		}
		
		/** @private */
		public function set overOffsetX(value:int):void
		{
			if(m_overOffsetX != value)
			{
				m_overOffsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象y坐标偏移量
		 */
		public function get overOffsetY():int
		{
			return m_overOffsetY;
		}
		
		/** @private */
		public function set overOffsetY(value:int):void
		{
			if(m_overOffsetY != value)
			{
				m_overOffsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象x坐标偏移量
		 */
		public function get downOffsetX():int
		{
			return m_downOffsetX;
		}
		
		/** @private */
		public function set downOffsetX(value:int):void
		{
			if(m_downOffsetX != value)
			{
				m_downOffsetX = value;
				
				onPropertiesChanged(OFFSET);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象y坐标偏移量
		 */
		public function get downOffsetY():int
		{
			return m_downOffsetY;
		}
		
		/** @private */
		public function set downOffsetY(value:int):void
		{
			if(m_downOffsetY != value)
			{
				m_downOffsetY = value;
				
				onPropertiesChanged(OFFSET);
			}
		}

		/**
		 * 指示如果按钮状态显示对象为Bitmap,被释放时是否释放 bitmapData 对象。
		 */		
		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}
		
		/** @private */
		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateCurrentStateImage();
			
			updateCurrentStateFilters();
			
			updateImageSize();
			
			updateImagePos();
			
			m_stateChange = false;
		}
		
		/**
		 * 更新当前状态的显示对象
		 */		
		protected function updateCurrentStateImage():void
		{
			if(isChanged(STATEIMAGE) || m_stateChange)
			{
				var image:DisplayObject;
				
				var tmpImage:DisplayObject;
				
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
		
		/**
		 * 更新当前状态的滤镜对象
		 */		
		protected function updateCurrentStateFilters():void
		{
			if(isChanged(STATEFILTERS) || m_stateChange)
			{
				var filters:Array;
				var tmpFilters:Array;
				
				filters = m_upFilters;
				
				if(model.enabled == false)
				{
					tmpFilters = m_disableFilters;
				}
				else if(model.pressed)
				{
					tmpFilters = m_downFilters;
				}
				else if(model.rollOver)
				{
					tmpFilters = m_overFilters;
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
		
		/**
		 * 更新当前状态显示对象的大小
		 */		
		protected function updateImageSize():void
		{
			if((m_stateChange || 
				isChanged(STATEIMAGE) || 
				isChanged(WIDTH) || 
				isChanged(HEIGHT)) && m_curImage)
			{
				m_curImage.width = m_width;
				m_curImage.height = m_height;
			}
		}
		
		/**
		 * 更新当前状态显示对象的位置
		 */		
		protected function updateImagePos():void
		{
			if(m_stateChange)
			{
				m_imageLayer.x = 0;
				m_imageLayer.y = 0;
				
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
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			DisposeUtil.free(m_upImage);
			m_upImage = null;
			
			DisposeUtil.free(m_downImage);
			m_downImage = null;
			
			DisposeUtil.free(m_overImage);
			m_overImage = null;
			
			DisposeUtil.free(m_disableImage);
			m_disableImage = null;
			
			m_curImage = null;
			m_imageLayer = null;
			m_curFilters = null;
			m_upFilters = null;
			m_overFilters = null;
			m_downFilters = null;
			m_disableFilters = null;
			
			super.dispose();
		}
	}
}