package jsion.core.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	
	public class SoundLoader extends JLoader
	{
		protected var _sound:Sound;
		
		public function SoundLoader(url:String, cfg:Object=null)
		{
			super(url, cfg);
		}
		
		override protected function configLoader():void
		{
			super.configLoader();
			
			_sound = new Sound();
		}
		
		override public function get isSound():Boolean
		{
			return true;
		}
		
		override public function get isStreamable():Boolean
		{
			return true;
		}
		
		override protected function load():void
		{
			if(_isComplete || _isLoading) return;
			
			super.load();
			
			if(_isLoading == false || _isComplete) return;
			
			addLoadEvent(_sound);
			
			try
			{
				_sound.load(_request);
			}
			catch(err:Error)
			{
				removeLoadEvent(_sound);
				removeBytesTotalEvent(_sound);
				throw err;
			}
		}
		
		override public function stop():void
		{
			super.stop();
			
			if(_isLoading) return;
			
			try
			{
				removeLoadEvent(_sound);
				removeBytesTotalEvent(_sound);
				_sound.close();
			}
			catch(e:Error){}
		}
		
		override public function getBytesTotal():void
		{
			super.getBytesTotal();
			addBytesTotalEvent(_sound);
			
			try
			{
				_sound.load(_request);
			}
			catch(err:Error)
			{
				removeLoadEvent(_sound);
				removeBytesTotalEvent(_sound);
				throw err;
			}
		}
		
//		override protected function addLoadEvent(ed:EventDispatcher):void
//		{
//			if(ed == null) return;
//			ed.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
//			ed.addEventListener(Event.COMPLETE, onCompleteHandler);
//			ed.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
//			ed.addEventListener(Event.OPEN, onOpenHandler);
//			ed.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);
//		}
//		
//		override protected function removeLoadEvent(ed:EventDispatcher):void
//		{
//			if(ed == null) return;
//			ed.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
//			ed.removeEventListener(Event.COMPLETE, onCompleteHandler);
//			ed.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
//			ed.removeEventListener(Event.OPEN, onOpenHandler);
//			ed.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);
//		}
		
		override protected function onOpenHandler(e:Event):void
		{
			_content = _sound;
			super.onOpenHandler(e);
		}
		
		override protected function onCompleteHandler(e:Event):void
		{
			_content = _sound;
			super.onCompleteHandler(e);
		}
		
		override public function dispose():void
		{
			removeLoadEvent(_sound);
			removeBytesTotalEvent(_sound);
			_sound = null;
			super.dispose();
		}
	}
}