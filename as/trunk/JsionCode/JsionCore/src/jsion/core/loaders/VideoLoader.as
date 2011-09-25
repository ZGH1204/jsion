package jsion.core.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getTimer;
	
	import jsion.core.events.*;
	import jsion.utils.JUtil;

	public class VideoLoader extends JLoader
	{
		protected var nc:NetConnection;
		
		protected var stream:NetStream;
		
		protected var _metaData : Object;
		
		protected var _canBeginStreaming:Boolean;
		
		public function VideoLoader(url:String, cfg:Object=null)
		{
			super(url, cfg);
		}
		
		override public function get isVideo():Boolean
		{
			return true;
		}
		
		override public function get isStreamable():Boolean
		{
			return true;
		}
		
		override protected function configLoader():void
		{
			nc = new NetConnection();
			nc.connect(null);
			stream = new NetStream(nc);
			
			JUtil.addEnterFrame(createNetStreamEvent);
		}
		
		override protected function load():void
		{
			super.load();
			
			if(_isLoading == false || _isComplete) return;
			
			stream.client = this;
			addLoadEvent(stream);
			
			try
			{
				stream.play(_request.url, _checkPolicyFile);
			}
			catch( e : SecurityError)
			{
				removeLoadEvent(stream);
				removeBytesTotalEvent(stream);
				onSecurityErrorHandler(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, e.message));
			}
			catch(err:Error)
			{
				removeLoadEvent(stream);
				removeBytesTotalEvent(stream);
				onErrorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, err.message));
			}
		}
		
		override protected function addLoadEvent(ed:EventDispatcher):void
		{
			if(ed == null) return;
			ed.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			ed.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		override protected function removeLoadEvent(ed:EventDispatcher):void
		{
			if(ed == null) return;
			ed.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			ed.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		protected function onNetStatus(e:NetStatusEvent):void
		{
			if(!stream) return;
			
			stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
			
			if(e.info.code == "NetStream.Play.Start")
			{
				_content = stream;
				if(_startTime <= 0) onOpenHandler(new Event(Event.OPEN));
			}
			else if(e.info.code == "NetStream.Play.StreamNotFound")
			{
				onErrorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "NetStream not found at " + _request.url));
			}
		}
		
		protected function createNetStreamEvent(e:Event):void
		{
			if(_bytesLoaded == _bytesTotal && _bytesTotal > 8)
			{
				JUtil.removeEnterFrame(createNetStreamEvent);
				fireCanBeginStreamingEvent();
				onCompleteHandler(new Event(Event.COMPLETE));
			}
			else if(_bytesTotal == 0 && stream && stream.bytesTotal > 4)
			{
				if(_startTime <= 0) onOpenHandler(new Event(Event.OPEN));
				_bytesLoaded = stream.bytesLoaded;
				_bytesTotal = stream.bytesTotal;
			}
			else if (stream)
			{
				if(isVideo && _metaData && !_canBeginStreaming)
				{
					var timeElapsed : int = getTimer() - _startTime;
					
					if (timeElapsed > 100)
					{
						var currentSpeed : Number = _bytesLoaded / (timeElapsed/1000);
						var estimatedTimeRemaining : Number = _bytesRemaining / (currentSpeed * 0.8);
						var videoTimeToDownload : Number = _metaData.duration - stream.bufferLength;
						if (videoTimeToDownload > estimatedTimeRemaining)
						{
							fireCanBeginStreamingEvent();
						}
					}
				}
				
				onProgressHandler(new ProgressEvent(ProgressEvent.PROGRESS, false, false, stream.bytesLoaded, stream.bytesTotal));
			}
		}
		
		override protected function onOpenHandler(e:Event):void
		{
			_content = stream;
			
			if(_status == LoaderGlobal.StatusGetBytesTotal)
			{
				stream.pause();
				stream.seek(0);
			}
			else if(_pausedAtStart && stream)
			{
				stream.pause();
				stream.seek(0);
			}
			
			super.onOpenHandler(e);
		}
		
		override protected function onCompleteHandler(e:Event):void
		{
			_content = stream;
			super.onCompleteHandler(e);
		}
		
		override public function stop():void
		{
			super.stop();
			
			if(_isLoading) return;
			
			try
			{
				_startTime = 0;
				_bytesLoaded = 0;
				removeLoadEvent(stream);
				removeBytesTotalEvent(stream);
				stream.close();
			}
			catch(e:Error){}
		}
		
		override public function getBytesTotal():void
		{
			super.getBytesTotal();
			
			stream.client = this;
			addBytesTotalEvent(stream);
			
			try
			{
				stream.play(_request.url, _checkPolicyFile);
			}
			catch(err:Error)
			{
				removeLoadEvent(stream);
				removeBytesTotalEvent(stream);
				throw err;
			}
		}
		
		protected function fireCanBeginStreamingEvent() : void
		{
			if(_canBeginStreaming) return;
			
			_canBeginStreaming = true;
			var evt : Event = new Event(JLoaderEvent.CanBeginPlaying);
			dispatchEvent(evt);
		}
		
		public function onCuePoint(...args):void
		{
			
		}
		
		public function onMetaData(e:Object):void
		{
			_metaData = e;
		}
		
		public function onPlayStatus(...args):void
		{
			
		}
		
		override public function dispose():void
		{
			removeLoadEvent(stream);
			removeBytesTotalEvent(stream);
			JUtil.removeEnterFrame(createNetStreamEvent);
			nc = null;
			stream = null;
			_metaData = null;
			
			super.dispose();
		}
	}
}