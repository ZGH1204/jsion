package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.comps.Component;
	import jsion.events.StateEvent;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 图片按钮。此类为按钮基类,不支持显示文字;
	 * 需要显示文字可以使用 jsion.display.LabelButton 类。
	 * 使用 jsion.display.Image  可支持九宫格缩放。
	 * 支持滤镜。
	 * @see jsion.display.Image
	 * @author Jsion
	 * 
	 */	
	public class Button extends Component
	{
		/**
		 * 状态显示对象资源变更
		 */		
		public static const STATEIMAGE:String = "stateImage";
		/**
		 * 状态显示对象滤镜变更
		 */		
		public static const STATEFILTERS:String = "stateFilters";
		
		private var m_imageLayer:Sprite;
		
		private var m_curImage:DisplayObject;
		private var m_curFilters:Array;
		
		private var m_upImage:DisplayObject;
		private var m_overImage:DisplayObject;
		private var m_downImage:DisplayObject;
		private var m_disableImage:DisplayObject;
		
		private var m_upFilters:Array;
		private var m_overFilters:Array;
		private var m_downFilters:Array;
		private var m_disableFilters:Array;
		
		private var m_freeBMD:Boolean;
		
		protected var m_stateChange:Boolean;
		
		public function Button()
		{
			super();
			
			m_freeBMD = false;
			m_stateChange = false;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_imageLayer = new Sprite();
			m_imageLayer.mouseEnabled = false;
			m_imageLayer.mouseChildren = false;
		}
		
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
				}
				
				onPropertiesChanged(STATEIMAGE);
			}
		}
		
		/**
		 * 按钮经过时的显示对象资源
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
			
			if(m_changeProperties.containsKey(STATEIMAGE) || m_stateChange)
			{
				updateCurrentStateImage();
			}
			
			if(m_changeProperties.containsKey(STATEFILTERS) || m_stateChange)
			{
				updateCurrentStateFilters();
				
				m_stateChange = false;
			}
			
			if((m_changeProperties.containsKey(WIDTH) || m_changeProperties.containsKey(HEIGHT)) && m_curImage)
			{
				m_curImage.width = m_width;
				m_curImage.height = m_height;
			}
		}
		
		/**
		 * 更新当前状态的显示对象
		 */		
		protected function updateCurrentStateImage():void
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
				m_curImage.width = m_width;
				m_curImage.height = m_height;
				
				m_imageLayer.addChild(m_curImage);
			}
		}
		
		/**
		 * 更新当前状态的滤镜对象
		 */		
		protected function updateCurrentStateFilters():void
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
			
			super.dispose();
		}
	}
}