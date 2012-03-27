package jsion.tool.mgrs
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	
	import jsion.HashMap;

	public class FileMgr
	{
		private static var m_callbackMap:HashMap = new HashMap();
		
		public function FileMgr()
		{
		}
		
		/**
		 * 浏览选择要打开的文件
		 * @param callback 将所选文件的 File 对象作为参数回调此方法
		 * @param typeFilter 过滤显示文件的FileFilter数组对象
		 */		
		public static function openBrowse(callback:Function, typeFilter:Array = null):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, __openHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			
			file.browseForOpen("打开文件", typeFilter);
		}
		
		/**
		 * 浏览选择多个要打开的文件
		 * @param callback 将所选文件的数组作为参数回调此方法
		 * @param typeFilter 过滤显示文件的FileFilter数组对象
		 */		
		public static function openMultiBrowse(callback:Function, typeFilter:Array = null):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, __openMultiHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			
			file.browseForOpenMultiple("打开多个文件", typeFilter);
		}
		
		/**
		 * 浏览选择要保存的文件
		 * @param callback 将所选保存目标的 File 对象作为参数回调此方法
		 */		
		public static function saveBrowse(callback:Function):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, __saveHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			
			file.browseForSave("保存文件");
		}
		
		/**
		 * 浏览选择目录位置
		 * @param callback 将所选目录的 File 对象作为参数回调此方法
		 */		
		public static function directoryBrowse(callback:Function):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, __directoryHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			
			file.browseForDirectory("选择目录");
		}
		
		
		
		
		private static function __openHandler(e:Event):void
		{
			var file:File = e.currentTarget as File;
			
			var callback:Function = m_callbackMap.remove(file);
			
			try
			{
				callback(e.target);
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
			}
			
			file.removeEventListener(Event.SELECT, __openHandler);
			file.removeEventListener(Event.CANCEL, __cancelHandler);
		}
		
		private static function __openMultiHandler(e:FileListEvent):void
		{
			var file:File = e.currentTarget as File;
			
			var callback:Function = m_callbackMap.remove(file);
			
			try
			{
				callback(e.target);
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
			}
			
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, __openMultiHandler);
			file.removeEventListener(Event.CANCEL, __cancelHandler);
		}
		
		private static function __saveHandler(e:Event):void
		{
			var file:File = e.currentTarget as File;
			
			var callback:Function = m_callbackMap.remove(file);
			
			try
			{
				callback(e.target);
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
			}
			
			file.removeEventListener(Event.SELECT, __saveHandler);
			file.removeEventListener(Event.CANCEL, __cancelHandler);
		}
		
		private static function __directoryHandler(e:Event):void
		{
			var file:File = e.currentTarget as File;
			
			var callback:Function = m_callbackMap.remove(file);
			
			try
			{
				callback(e.target);
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
			}
			
			file.removeEventListener(Event.SELECT, __directoryHandler);
			file.removeEventListener(Event.CANCEL, __cancelHandler);
		}
		
		
		
		
		private static function __cancelHandler(e:Event):void
		{
			var file:File = e.currentTarget as File;
			
			m_callbackMap.remove(file);
			
			file.removeEventListener(Event.SELECT, 					__openHandler);
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, __openMultiHandler);
			file.removeEventListener(Event.SELECT, 					__saveHandler);
			file.removeEventListener(Event.SELECT, 					__directoryHandler);
			file.removeEventListener(Event.CANCEL, 					__cancelHandler);
		}
	}
}