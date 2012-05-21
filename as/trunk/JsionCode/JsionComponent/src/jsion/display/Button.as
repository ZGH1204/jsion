package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.comps.Component;
	import jsion.events.StateEvent;
	import jsion.utils.DisposeUtil;
	
	public class Button extends Component
	{
		public static const STATEIMAGE:String = "stateImage";
		public static const STATEFILTER:String = "stateFilter";
		
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
		
		public function get upImage():DisplayObject
		{
			return m_upImage;
		}

		public function set upImage(value:DisplayObject):void
		{
			if(m_upImage != value)
			{
				DisposeUtil.free(m_upImage, m_freeBMD);
				
				m_upImage = value;
				
				if(m_upImage)
				{
					if(m_width <= 0) m_width = m_upImage.width;
					if(m_height <= 0) m_height = m_upImage.height;
				}
				
				onPropertiesChanged(STATEIMAGE);
			}
		}

		public function get overImage():DisplayObject
		{
			return m_overImage;
		}

		public function set overImage(value:DisplayObject):void
		{
			if(m_overImage != value)
			{
				DisposeUtil.free(m_overImage, m_freeBMD);
				
				m_overImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}

		public function get downImage():DisplayObject
		{
			return m_downImage;
		}

		public function set downImage(value:DisplayObject):void
		{
			if(m_downImage != value)
			{
				DisposeUtil.free(m_downImage, m_freeBMD);
				
				m_downImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}

		public function get disableImage():DisplayObject
		{
			return m_disableImage;
		}

		public function set disableImage(value:DisplayObject):void
		{
			if(m_disableImage != value)
			{
				DisposeUtil.free(m_disableImage, m_freeBMD);
				
				m_disableImage = value;
				
				onPropertiesChanged(STATEIMAGE);
			}
		}

		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}

		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			if(m_changeProperties.containsKey(STATEIMAGE) || m_stateChange)
			{
				updateCurrentStateImage();
			}
			
			if(m_changeProperties.containsKey(STATEFILTER) || m_stateChange)
			{
				updateCurrentStateFilters();
				
				m_stateChange = false;
			}
		}
		
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
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_imageLayer);
		}

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