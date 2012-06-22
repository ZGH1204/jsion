package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import jsion.comps.Component;
	import jsion.events.ReleaseEvent;
	import jsion.events.StateEvent;
	import jsion.sounds.SoundMgr;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	/**
	 * 图片按钮。此类为按钮基类,不支持显示文字。支持滤镜、音效。
	 * 播放音效时需要使用 SoundMgr.registeSound(id:String, sound:Sound) 方法注册对应音效资源。
	 * 需要显示文字可以使用 jsion.display.LabelButton 类。
	 * 使用 jsion.display.Image 可支持九宫格缩放。
	 * @see jsion.display.Image
	 * @author Jsion
	 * 
	 */	
	public class Button extends Component
	{
		/**
		 * 鼠标经过按钮时默认的高亮滤镜
		 */		
		public static const OVERFILTERS:Array = [new ColorMatrixFilter([1, 0, 0, 0, 25,   0, 1, 0, 0, 25,   0, 0, 1, 0, 25,   0, 0, 0, 1, 0])];
		
		/**
		 * 禁用按钮时默认的灰显滤镜
		 */		
		public static const DISABLEDFILTERS:Array = [new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0,  0.3, 0.59, 0.11, 0, 0,  0.3, 0.59, 0.11, 0, 0,  0, 0, 0, 1, 0])];
		
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Component.WIDTH;
		
		/**
		 * 高度属性变更
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
		protected var m_stateChange:Boolean;
		
		
		
		/** @private */
		protected var m_mouseDowned:Boolean;
		
		/** @private */
		protected var m_autoMouseDown:Boolean;
		
		/** @private */
		protected var m_mouseDownCurFrame:int;
		
		/** @private */
		protected var m_mouseDownDelayFrame:int;
		
		/** @private */
		protected var m_mouseDownIntFrame:int;
		
		/** @private */
		protected var m_mouseDownIntervalFrame:int;
		
		
		
		
		/** @private */
		protected var m_frozen:Boolean;
		
		/** @private */
		protected var m_frozenFrames:int;
		
		/** @private */
		protected var m_frozenCurFrame:int;
		
		
		/** @private */
		protected var m_overSoundID:String;
		
		/** @private */
		protected var m_downSoundID:String;
		
		/** @private */
		protected var m_clickSoundID:String;
		
		/** @private */
		protected var m_doubleClickSoundID:String;
		
		
		
		public function Button()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			buttonMode = true;
			
			m_mouseDowned = false;
			m_autoMouseDown = false;
			m_mouseDownDelayFrame = 30;
			m_mouseDownIntervalFrame = 3;
			
			m_frozen = false;
			m_frozenFrames = 90;
			m_frozenCurFrame = 0;
			
			m_freeBMD = false;
			m_stateChange = false;
			
			m_imageLayer = new Sprite();
			m_imageLayer.mouseEnabled = false;
			m_imageLayer.mouseChildren = false;
			
			m_overFilters = OVERFILTERS;
			m_disableFilters = DISABLEDFILTERS;
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
			
			addEventListener(MouseEvent.MOUSE_OVER, __overSoundHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __downSoundHandler);
			addEventListener(MouseEvent.CLICK, __clickSoundHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, __doubleClickHandler);
			
			model.addEventListener(StateEvent.STATE_CHANGED, __stateChangeHandler);
		}
		
		private function __overSoundHandler(e:MouseEvent):void
		{
			if(StringUtil.isNotNullOrEmpty(m_overSoundID))
			{
				SoundMgr.play(m_overSoundID);
			}
		}
		
		private function __downSoundHandler(e:MouseEvent):void
		{
			if(StringUtil.isNotNullOrEmpty(m_downSoundID))
			{
				SoundMgr.play(m_downSoundID);
			}
		}
		
		private function __clickSoundHandler(e:MouseEvent):void
		{
			if(StringUtil.isNotNullOrEmpty(m_clickSoundID))
			{
				SoundMgr.play(m_clickSoundID);
			}
		}
		
		private function __doubleClickHandler(e:MouseEvent):void
		{
			if(StringUtil.isNotNullOrEmpty(m_doubleClickSoundID))
			{
				SoundMgr.play(m_doubleClickSoundID);
			}
		}
		
		private function __stateChangeHandler(e:StateEvent):void
		{
			m_stateChange = true;
			
//			if(model.rollOver)
//			{
//				CursorMgr.over();
//			}
//			else
//			{
//				CursorMgr.normal();
//			}
			
			invalidate();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set width(value:Number):void
		{
			if(value < m_minWidth)
			{
				throw new Error("参数值小于允许的最小宽度值");
				return;
			}
			
			super.width = value;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set height(value:Number):void
		{
			if(value < m_minHeight)
			{
				throw new Error("参数值小于允许的最小高度值");
				return;
			}
			
			super.height = value;
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
						
						checkSizeWidthMinSize();
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
		 * 指示如果按钮状态显示对象为Bitmap,被释放时是否释放 bitmapData 对象。默认为 false 。
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
		 * 是否允许自动触发 MouseDown 事件
		 */		
		public function get autoMouseDown():Boolean
		{
			return m_autoMouseDown;
		}
		
		/** @private */
		public function set autoMouseDown(value:Boolean):void
		{
			if(m_autoMouseDown != value)
			{
				m_autoMouseDown = value;
				
				if(m_autoMouseDown)
				{
					addEventListener(MouseEvent.MOUSE_DOWN, __autoMouseDownHandler);
					addEventListener(ReleaseEvent.RELEASE, __autoMouseDownReleaseHandler);
				}
				else
				{
					m_mouseDowned = false;
					m_mouseDownCurFrame = 0;
					
					removeEventListener(MouseEvent.MOUSE_DOWN, __autoMouseDownHandler);
					removeEventListener(ReleaseEvent.RELEASE, __autoMouseDownReleaseHandler);
					removeEventListener(Event.ENTER_FRAME, __autoMouseDownEnterFrameHandler);
				}
			}
		}
		
		/**
		 * 当允许自动触发 MouseDown 事件时，触发的延迟帧数。
		 */		
		public function get mouseDownDelayFrame():int
		{
			return m_mouseDownDelayFrame;
		}
		
		/** @private */
		public function set mouseDownDelayFrame(value:int):void
		{
			m_mouseDownDelayFrame = value;
		}
		
		/**
		 * 当允许自动触发 MouseDown 事件时，触发的间隔帧数。
		 */		
		public function get mouseDownIntervalFrame():int
		{
			return m_mouseDownIntervalFrame;
		}
		
		/** @private */
		public function set mouseDownIntervalFrame(value:int):void
		{
			m_mouseDownIntervalFrame = value;
		}
		
		
		/**
		 * 是否启用点击冻结按钮，并在延迟帧数达到后释放冻结。
		 */		
		public function get frozen():Boolean
		{
			return m_frozen;
		}
		
		/** @private */
		public function set frozen(value:Boolean):void
		{
			if(m_frozen != value)
			{
				m_frozen = value;
				
				if(m_frozen)
				{
					addEventListener(MouseEvent.CLICK, __frozenClickHandler);
				}
				else
				{
					
					enabled = true;
					
					m_frozenCurFrame = 0;
					
					removeEventListener(MouseEvent.CLICK, __frozenClickHandler);
					
					removeEventListener(Event.ENTER_FRAME, __frozenEnterFrameHandler);
				}
			}
		}
		
		/**
		 * 当启用点击冻结时，冻结的延迟帧数。
		 */		
		public function get frozenFrames():int
		{
			return m_frozenFrames;
		}
		
		/** @private */
		public function set frozenFrames(value:int):void
		{
			m_frozenFrames = value;
		}
		
		/**
		 * 鼠标经过时播放的音效ID，此音效ID必需为 SoundMgr 中已注册的ID，否则无音效播放。
		 */		
		public function get overSoundID():String
		{
			return m_overSoundID;
		}
		
		/** @private */
		public function set overSoundID(value:String):void
		{
			m_overSoundID = value;
		}
		
		/**
		 * 鼠标按下时播放的音效ID，此音效ID必需为 SoundMgr 中已注册的ID，否则无音效播放。
		 */		
		public function get downSoundID():String
		{
			return m_downSoundID;
		}
		
		/** @private */
		public function set downSoundID(value:String):void
		{
			m_downSoundID = value;
		}
		
		/**
		 * 鼠标单击时播放的音效ID，此音效ID必需为 SoundMgr 中已注册的ID，否则无音效播放。
		 */		
		public function get clickSoundID():String
		{
			return m_clickSoundID;
		}
		
		/** @private */
		public function set clickSoundID(value:String):void
		{
			m_clickSoundID = value;
		}
		
		/**
		 * 鼠标双击时播放的音效ID，此音效ID必需为 SoundMgr 中已注册的ID，否则无音效播放。
		 */		
		public function get doubleClickSoundID():String
		{
			return m_doubleClickSoundID;
		}
		
		/** @private */
		public function set doubleClickSoundID(value:String):void
		{
			m_doubleClickSoundID = value;
		}
		
		
		
		
		
		
		
		
		
		private function __autoMouseDownHandler(e:MouseEvent):void
		{
			if(m_mouseDowned) return;
			
			m_mouseDowned = true;
			
			m_mouseDownCurFrame = 0;
			
			addEventListener(Event.ENTER_FRAME, __autoMouseDownEnterFrameHandler);
		}
		
		private function __autoMouseDownReleaseHandler(e:MouseEvent):void
		{
			m_mouseDowned = false;
			
			m_mouseDownCurFrame = 0;
			
			removeEventListener(Event.ENTER_FRAME, __autoMouseDownEnterFrameHandler);
		}
		
		private function __autoMouseDownEnterFrameHandler(e:Event):void
		{
			if(m_mouseDownCurFrame < m_mouseDownDelayFrame)
			{
				m_mouseDownCurFrame++;
				return;
			}
			
			if(m_mouseDownIntFrame < m_mouseDownIntervalFrame)
			{
				m_mouseDownIntFrame++;
				return;
			}
			
			m_mouseDownIntFrame = 0;
			
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, mouseX, mouseY));
		}
		
		private function __frozenClickHandler(e:MouseEvent):void
		{
			enabled = false;
			
			m_frozenCurFrame = 0;
			
			addEventListener(Event.ENTER_FRAME, __frozenEnterFrameHandler);
		}
		
		private function __frozenEnterFrameHandler(e:Event):void
		{
			if(m_frozenCurFrame < m_frozenFrames)
			{
				m_frozenCurFrame++;
				
				return;
			}
			
			enabled = true;
			
			m_frozenCurFrame = 0;
			
			removeEventListener(Event.ENTER_FRAME, __frozenEnterFrameHandler);
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
		 * 检查是否小于允许的最小 Size ，如果小于则重置为最小的 Size。
		 */		
		protected function checkSizeWidthMinSize():void
		{
			m_width = Math.max(m_width, m_minWidth);
			m_height = Math.max(m_height, m_minHeight);
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
				
				//updateImageSize();
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
				
//				m_width = m_curImage.width;
//				m_height = m_curImage.height;
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
			DisposeUtil.free(m_upImage, m_freeBMD);
			m_upImage = null;
			
			DisposeUtil.free(m_downImage, m_freeBMD);
			m_downImage = null;
			
			DisposeUtil.free(m_overImage, m_freeBMD);
			m_overImage = null;
			
			DisposeUtil.free(m_disableImage, m_freeBMD);
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