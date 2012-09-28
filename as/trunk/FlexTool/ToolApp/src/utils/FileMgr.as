package utils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;

	public class FileMgr
	{
		private static var m_callbackMap:HashMap = new HashMap();
		private static var m_cancelCallbackMap:HashMap = new HashMap();
		
		public function FileMgr()
		{
		}
		
		/**
		 * 获取目录下的所有子目录，递归所有子目录。
		 * @param dir 目录对象
		 * @param result 结果集列表
		 */		
		public static function getAllChildDirs(dir:File, result:Array = null):Array
		{
			if(dir.isDirectory == false) return [];
			
			result ||= [];
			
			var list:Array = dir.getDirectoryListing();
			
			for each(var file:File in list)
			{
				if(file.isDirectory)
				{
					result.push(file);
					getAllChildDirs(file, result);
				}
			}
			
			return result;
		}
		
		/**
		 * 获取目录下的所有文件，不包括目录，递归所有子目录下的文件。
		 * @param dir 目录对象
		 * @param result 结果集列表
		 */		
		public static function getAllChildFiles(dir:File, result:Array = null):Array
		{
			if(dir.isDirectory == false) return [];
			
			result ||= [];
			
			var list:Array = dir.getDirectoryListing();
			
			for each(var file:File in list)
			{
				if(file.isDirectory)
				{
					getAllChildFiles(file, result);
				}
				else
				{
					result.push(file);
				}
			}
			
			return result;
		}
		
		/**
		 * 浏览选择要打开的文件
		 * @param callback 将所选文件的 File 对象作为参数回调此方法
		 * @param typeFilter 过滤显示文件的FileFilter数组对象
		 */		
		public static function openBrowse(callback:Function, cancelCallback:Function = null, typeFilter:Array = null):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, __openHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.browseForOpen("打开文件", typeFilter);
		}
		
		/**
		 * 浏览选择多个要打开的文件
		 * @param callback 将所选文件的数组作为参数回调此方法
		 * @param typeFilter 过滤显示文件的FileFilter数组对象
		 */		
		public static function openMultiBrowse(callback:Function, cancelCallback:Function = null, typeFilter:Array = null):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, __openMultiHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.browseForOpenMultiple("打开多个文件", typeFilter);
		}
		
		/**
		 * 浏览选择要保存的文件
		 * @param callback 将所选保存目标的 File 对象作为参数回调此方法
		 */		
		public static function saveBrowse(callback:Function, cancelCallback:Function = null):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, __saveHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.browseForSave("保存文件");
		}
		
		/**
		 * 浏览选择目录位置
		 * @param callback 将所选目录的 File 对象作为参数回调此方法
		 */		
		public static function directoryBrowse(callback:Function, cancelCallback:Function = null):void
		{
			if(callback == null) return;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, __directoryHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			m_callbackMap.put(file, callback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.browseForDirectory("选择目录");
		}
		
		/**
		 * 将源文件复制到目标文件
		 * @param source 源文件
		 * @param target 目录文件
		 */		
		public static function copy2Target(source:File, target:File):void
		{
			if(source == null || target == null || 
			    source.isDirectory || target.isDirectory) return;
			
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			
			fs.open(source, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			fs.open(target, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		
		
		
		private static function __openHandler(e:Event):void
		{
			var file:File = e.currentTarget as File;
			
			m_cancelCallbackMap.remove(file);
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
			
			m_cancelCallbackMap.remove(file);
			var callback:Function = m_callbackMap.remove(file);
			
			try
			{
				callback(e.files);
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
			
			m_cancelCallbackMap.remove(file);
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
			
			m_cancelCallbackMap.remove(file);
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
			var callback:Function = m_cancelCallbackMap.remove(file);
			
			try
			{
				callback();
			}
			catch(err:Error)
			{
				trace(err.getStackTrace());
			}
			
			file.removeEventListener(Event.SELECT, 					__openHandler);
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, __openMultiHandler);
			file.removeEventListener(Event.SELECT, 					__saveHandler);
			file.removeEventListener(Event.SELECT, 					__directoryHandler);
			file.removeEventListener(Event.CANCEL, 					__cancelHandler);
		}
	}
}