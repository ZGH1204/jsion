package dataType
{
	import flash.events.Event;
	import flash.filesystem.*;
	
	import mx.events.FileEvent;
	
	public class TextFile extends SimpleFile
	{
		public static const NO_EXISTS:String = "fileNoExists";
		
		protected var _arString:Array;
		protected var _currentRow:int;
		protected var _currentColumn:int;
		
		protected var _callback:Function;
		
		public function get CurrentRow():int
		{
			return _currentRow + 1;
		}
		
		public function get IsLineEOF():Boolean
		{
			if(_arString == null)
				return true;
			return (_currentRow == _arString.length);
		}
		
		public function get IsColumnEOF():Boolean
		{
			if(_arString == null)
				return true;
			var str:String = _arString[_currentRow];
			
			return (_currentColumn == str.length);
		}
		
		public function get LineCount():int
		{
			return _arString.length;
		}
		
		public function TextFile(path:String = null)
		{
			super(path);
		}
		
		protected function getFileContentText(async:Boolean):void
		{
			if(exists == false)
			{
				dispatchEvent(new FileEvent(NO_EXISTS));
				return;
			}
			
			var fs:FileStream = new FileStream();
			
			if(async)
			{
				fs.addEventListener(Event.COMPLETE, __openCompleteHandler);
				fs.openAsync(this,FileMode.READ);
			}
			else
			{
				fs.open(this,FileMode.READ);
				readFileStreamAndCallback(fs);
			}
		}
		
		private function __openCompleteHandler(e:Event):void
		{
			var fs:FileStream = e.target as FileStream;
			
			readFileStreamAndCallback(fs);
		}
		
		private function readFileStreamAndCallback(fs:FileStream):void
		{
			if(fs == null)
				return;
			
			var txt:String = fs.readUTFBytes(fs.bytesAvailable);
			
			fs.close();
			
			_arString = txt.split("\r\n");
			
			_currentRow = 0;
			_currentColumn = 0;
			
			if(_callback != null)
				_callback(this);
			_callback = null;
		}
		
		public function loadText(callback:Function = null):void
		{
			if(_arString != null)
				return;
			_callback = callback;
			getFileContentText(false);
		}
		
		public function readLoadText(callback:Function = null):void
		{
			_callback = callback;
			getFileContentText(false);
		}
		
		public function loadTextAsync(callback:Function = null):void
		{
			if(_arString != null)
				return;
			_callback = callback;
			getFileContentText(true);
		}
		
		public function reloadTextAsync(callback:Function = null):void
		{
			_callback = callback;
			getFileContentText(true);
		}
		
		public function read():String
		{
			if(IsColumnEOF && IsLineEOF)
				return null;
			var returnStr:String;
			var str:String = _arString[_currentRow];
			
			if(str.length > _currentColumn)
			{
				returnStr = str.charAt(_currentColumn);
				_currentColumn++;
			}
			else
			{
				_currentRow++;
				_currentColumn = 0;
				returnStr = read();
			}
			
			return returnStr;
		}
		
		public function readLine():String
		{
			if(IsLineEOF)
				return null;
			
			var returnStr:String = _arString[_currentRow];
			_currentColumn = 0;
			_currentRow++;
			
			return returnStr;
		}
		
		public function readToEnd():String
		{
			if(IsLineEOF)
				return null;
			
			var returnStr:String;
			for(; _currentRow < _arString.length; _currentRow++)
			{
				returnStr += _arString[_currentRow] + "\r\n";
			}
//			_currentRow = _arString.length;
			
			return returnStr;
		}
		
		public function write(str:String):void
		{
			if(_arString == null)
				return;
			_arString[_arString.length - 1] += str;
		}
		
		public function writeLine(str:String):void
		{
			if(_arString == null)
				return;
			_arString.push(str);
		}
		
		public function saveToFile():void
		{
			var fs:FileStream = new FileStream();
			
			fs.open(this,FileMode.WRITE);
			
			for each(var str:String in _arString)
			{
				fs.writeUTFBytes(str + "\r\n");
			}
			
			fs.close();
		}
	}
}