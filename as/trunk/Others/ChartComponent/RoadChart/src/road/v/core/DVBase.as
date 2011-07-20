package road.v.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DVBase extends Sprite
	{
		protected var _styles:Object;
		protected var _invalidHash:Object;
		protected var _data:Object;
		protected var _height:Number = 1;
		protected var _width:Number = 1;
		protected var _listeningForRender:Boolean = false;
		protected var _invalid:Boolean = false;
		
		public static const INVALID_TYPE_STYLE:String = "style";
        public static const INVALID_TYPE_DATA:String = "data";
        public static const INVALID_TYPE_SIZE:String = "size";
        
		public function DVBase()
		{
			_styles = {};
			_invalidHash = {};
			initStyle();
		}
		
		//===================================子类中可使用，覆盖重写===================================
		protected function initStyle():void
		{
			
		}
		
		protected function invalidate(type:String):void
		{
			_invalidHash[type] = true;
			_invalid = true;
			if(_listeningForRender)
			{
				return;
			}
			
			if(stage)
			{
				stage.addEventListener(Event.RENDER, validateAll);
                stage.invalidate();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, doAddedToStage);
			}
			_listeningForRender = true;
		}
		
		protected function validateAll(e:Event = null):void
		{
			if(_listeningForRender)
			{
				try
				{
					
				}
				catch(er:Error)
				{
					
				}
				
				_listeningForRender = false;
			}
			
			if(_invalid)
			{
				applyChanges();
				resetInvalidHash();
			}
		}
		
		protected function doAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, doAddedToStage);
			if (_invalid)
            {
                stage.addEventListener(Event.RENDER, validateAll);
                stage.invalidate();
            }
		}
		
		protected function applyChanges():void
		{
			
		}
		
		protected function resetInvalidHash(type:String = null):void
		{
			var resetFlag:Boolean;
			if(type == null)
			{
				_invalid = false;
				for(type in _invalidHash)
				{
					if(_invalidHash[type] == true)
					{
						_invalidHash[type] = false;
					}
				}
			}
			else
			{
				_invalidHash[type] = false;
				
				resetFlag = true;
				
				for(var str:String in _invalidHash)
				{
					if(_invalidHash[str] == true)
					{
						resetFlag = false;
						break;
					}
				}
				
				if(resetFlag)
				{
					_invalid = false;
				}
			}
		}
		
		protected function isInvalid(key:String):Boolean
		{
			if(_invalidHash[key] == true)
			{
				return true;
			}
			return false;
		}
		
		protected function isInvalidOnly(key:String):Boolean
		{
			if(_invalidHash[key] == true)
			{
				for(var str:String in _invalidHash)
				{
					if(str == key)
						continue;
					if(_invalidHash[key] == true)
						return false;
				}
				return true;
			}
			else
			{
				return false;
			}
		}
		//===================================子类中可使用，覆盖重写===================================
		
		//===================================公开方法===================================
		public function validateNow():void
		{
			validateAll();
		}
		
		public function setStyle(key:String, obj:*):void
		{
			if(_styles[key] == obj) return;
			
			_styles[key] = obj;
			invalidate(INVALID_TYPE_STYLE);
		}
		
		public function setStyles(o:Object):void
		{
			if(o == null)
			{
				initStyle();
				invalidate(INVALID_TYPE_STYLE);
				return;
			}
			
			for(var key:String in o)
			{
				setStyle(key, o[key]);
			}
		}
		
		public function getStyle(key:String):*
		{
			return _styles[key];
		}
		//===================================公开方法===================================
		
		//===================================属性===================================
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(o:*):void
		{
			_data = o;
			invalidate(INVALID_TYPE_DATA);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if(isNaN(value) || _width == value) return;
			_width = value;
			invalidate(INVALID_TYPE_SIZE);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if(isNaN(value) || _height == value) return;
			
			_height = value;
			invalidate(INVALID_TYPE_SIZE);
		}
		//===================================属性===================================
	}
}