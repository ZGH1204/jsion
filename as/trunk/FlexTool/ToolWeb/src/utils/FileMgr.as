package utils
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import jsion.HashMap;
	import jsion.utils.ArrayUtil;
	
	import mx.controls.Alert;

	public class FileMgr
	{
		private static var m_fileRef:HashMap = new HashMap();
		private static var m_callbackMap:HashMap = new HashMap();
		private static var m_errorCallbackMap:HashMap = new HashMap();
		private static var m_cancelCallbackMap:HashMap = new HashMap();
		
		private static var m_fileListRef:HashMap = new HashMap();
		
		public function FileMgr()
		{
		}
		
		/**
		 * 打开单个文件
		 * @param callback 加载后的回调，需要一个参数: FileReference。
		 * @param cancelCallback 取消后的回调，无参数。
		 * @param typeFilter 文件过滤
		 * 
		 */		
		public static function openFile(callback:Function, cancelCallback:Function = null, typeFilter:Array = null):void
		{
			var file:FileReference = new FileReference();
			
			m_fileRef.put(file, true);
			m_callbackMap.put(file, callback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.addEventListener(Event.SELECT, __selectedHandler);
			file.addEventListener(Event.CANCEL, __cancelHandler);
			
			file.browse(typeFilter);
		}
		
		private static function __selectedHandler(e:Event):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			file.addEventListener(Event.COMPLETE, __completeHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
			
			file.load();
		}
		
		private static function __cancelHandler(e:Event):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			if(m_cancelCallbackMap.containsKey(file))
			{
				var fn:Function = m_cancelCallbackMap.get(file);
				
				if(fn != null) fn.apply();
			}
			
			disposeFileReference(file);
		}
		
		private static function __completeHandler(e:Event):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			if(m_callbackMap.containsKey(file))
			{
				var fn:Function = m_callbackMap.get(file);
				
				if(fn != null) fn.apply(null, [file]);
			}
			
			disposeFileReference(file);
		}
		
		private static function __errorHandler(e:ErrorEvent):void
		{
			Alert.show(e.text, "文件打开失败");
			
			var file:FileReference = e.currentTarget as FileReference;
			disposeFileReference(file);
		}
		
		private static function disposeFileReference(file:FileReference):void
		{
			if(file)
			{
				file.removeEventListener(Event.SELECT, __selectedHandler);
				file.removeEventListener(Event.CANCEL, __cancelHandler);
				file.removeEventListener(Event.COMPLETE, __completeHandler);
				file.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
				file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
				
				m_fileRef.remove(file);
				m_callbackMap.remove(file);
				m_cancelCallbackMap.remove(file);
			}
		}
		
		
		
		
		
		/**
		 * 打开多个文件
		 * @param callback 需要三个参数: FileReference数组，是否有加载错误，加载错误的FileReference数组。
		 * @param cancelCallback 无参数
		 * @param typeFilter
		 * 
		 */		
		public static function openMultiFiles(callback:Function, cancelCallback:Function = null, typeFilter:Array = null):void
		{
			var file:FileReferenceList = new FileReferenceList();
			
			m_fileRef.put(file, true);
			m_callbackMap.put(file, callback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.addEventListener(Event.SELECT, __selectedMultiHandler);
			file.addEventListener(Event.CANCEL, __cancelMultiHandler);
			
			file.browse(typeFilter);
		}
		
		private static function __selectedMultiHandler(e:Event):void
		{
			var files:FileReferenceList = e.currentTarget as FileReferenceList;
			
			var list:Array = ArrayUtil.clone(files.fileList);
			
			for each(var file:FileReference in list)
			{
				m_fileRef.put(file, list);
				m_fileListRef.put(file, files);
			}
			
			tryLoadNext(list);
		}
		
		private static function tryLoadNext(list:Array):void
		{
			var file:FileReference = list.shift() as FileReference;
			
			file.addEventListener(Event.COMPLETE, __multiCompleteHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, __multiErrorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __multiErrorHandler);
			
			file.load();
		}
		
		private static function __multiCompleteHandler(e:Event):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			var list:Array = m_fileRef.get(file);
			
			if(list.length > 0)
			{
				tryLoadNext(list);
			}
			else
			{
				listComplete(file);
			}
		}
		
		private static function __multiErrorHandler(e:ErrorEvent):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			var list:Array = m_fileRef.get(file);
			
			if(list.length > 0)
			{
				tryLoadNext(list);
			}
			else
			{
				listComplete(file);
			}
		}
		
		private static function listComplete(file:FileReference):void
		{
			var files:FileReferenceList = m_fileListRef.get(file) as FileReferenceList;
			
			var hasLoadError:Boolean = false;
			var errorList:Array = [];
			
			for each(var f:FileReference in files.fileList)
			{
				if(f.data == null)
				{
					hasLoadError = true;
					errorList.push(f);
				}
			}
			
			if(m_callbackMap.containsKey(files))
			{
				var fn:Function = m_callbackMap.get(files);
				
				if(fn != null) fn.apply(null, [ArrayUtil.clone(files.fileList), hasLoadError, errorList]);
			}
			
			disposeFileReferenceList(files);
		}
		
		private static function __cancelMultiHandler(e:Event):void
		{
			var files:FileReferenceList = e.currentTarget as FileReferenceList;
			
			if(m_cancelCallbackMap.containsKey(files))
			{
				var fn:Function = m_cancelCallbackMap.get(files);
				
				if(fn != null) fn.apply();
			}
			
			disposeFileReferenceList(files);
		}
		
		private static function disposeFileReferenceList(files:FileReferenceList):void
		{
			if(files)
			{
				files.removeEventListener(Event.SELECT, __selectedMultiHandler);
				files.removeEventListener(Event.CANCEL, __cancelMultiHandler);
				
				for each(var file:FileReference in files.fileList)
				{
					file.removeEventListener(Event.COMPLETE, __multiCompleteHandler);
					file.removeEventListener(IOErrorEvent.IO_ERROR, __multiErrorHandler);
					file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __multiErrorHandler);
					
					m_fileRef.remove(file);
					m_fileListRef.remove(file);
				}
				
				m_fileRef.remove(files);
				m_callbackMap.remove(files);
				m_cancelCallbackMap.remove(files);
			}
		}
		
		
		
		
		
		
		/**
		 * 保存数据到本地
		 * @param data
		 * @param defaultFileName
		 * @param callback 保存后的回调，需要一个参数: FileReference。
		 * @param cancelCallback 取消的回调，需要两个参数: FileReference。
		 * @param errorCallback 保存出错的回调，需要两个参数: FileReference，出错信息字符串。
		 * @param typeFilter
		 * 
		 */		
		public static function save(data:*, defaultFileName:String = null, callback:Function = null, cancelCallback:Function = null, errorCallback:Function = null, typeFilter:Array = null):void
		{
			var file:FileReference = new FileReference();
			
			m_fileRef.put(file, true);
			m_callbackMap.put(file, callback);
			m_errorCallbackMap.put(file, errorCallback);
			m_cancelCallbackMap.put(file, cancelCallback);
			
			file.addEventListener(Event.COMPLETE, __saveCompleteHandler);
			file.addEventListener(Event.CANCEL, __saveCancelHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, __saveErrorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __saveErrorHandler);
			
			file.save(data, defaultFileName);
		}
		
		private static function __saveCompleteHandler(e:Event):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			if(m_callbackMap.containsKey(file))
			{
				var fn:Function = m_callbackMap.get(file);
				
				if(fn != null) fn.apply(null, [file]);
			}
			
			disposeSaveFileRef(file);
		}
		
		private static function __saveCancelHandler(e:Event):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			if(m_cancelCallbackMap.containsKey(file))
			{
				var fn:Function = m_cancelCallbackMap.get(file);
				
				if(fn != null) fn.apply(null, [file]);
			}
			
			disposeSaveFileRef(file);
		}
		
		private static function __saveErrorHandler(e:ErrorEvent):void
		{
			var file:FileReference = e.currentTarget as FileReference;
			
			if(m_errorCallbackMap.containsKey(file))
			{
				var fn:Function = m_errorCallbackMap.get(file);
				
				if(fn != null) fn.apply(null, [file, e.text]);
			}
			
			disposeSaveFileRef(file);
		}
		
		private static function disposeSaveFileRef(file:FileReference):void
		{
			if(file)
			{
				file.removeEventListener(Event.COMPLETE, __saveCompleteHandler);
				file.removeEventListener(Event.CANCEL, __saveCancelHandler);
				file.removeEventListener(IOErrorEvent.IO_ERROR, __saveErrorHandler);
				file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __saveErrorHandler);
				
				m_fileRef.remove(file);
				m_callbackMap.remove(file);
				m_errorCallbackMap.remove(file);
				m_cancelCallbackMap.remove(file);
			}
		}
	}
}