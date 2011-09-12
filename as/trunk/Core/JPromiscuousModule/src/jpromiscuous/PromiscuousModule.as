package jpromiscuous
{
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import jcore.org.message.Message;
	import jcore.org.moduls.DefaultModule;
	import jcore.org.moduls.ModuleInfo;
	
	import jpromiscuous.vo.RectRecord;
	import jpromiscuous.vo.SwfReader;
	import jpromiscuous.vo.Tag;
	import jpromiscuous.vo.TagTypes;
	
	import jutils.org.zip.ZipEntry;
	import jutils.org.zip.ZipFile;
	
	public class PromiscuousModule extends DefaultModule
	{
		public function PromiscuousModule(moduleInfo:ModuleInfo)
		{
			super(moduleInfo);
		}
		
		override protected function install(msg:Message):Object
		{
			registeMsgHandleFn(PromiscuousMessage.PROMISC_SWF, promiscSwfCodeHandler);
			registeMsgHandleFn(PromiscuousMessage.PROMISC_SWC, promiscSwcCodeHandler);
			
			return super.install(msg);
		}
		
		override protected function uninstall(msg:Message):Object
		{
			removeMsgHandleFn(PromiscuousMessage.PROMISC_SWF);
			removeMsgHandleFn(PromiscuousMessage.PROMISC_SWC);
			
			return super.uninstall(msg);
		}
		
		protected function promiscSwfCodeHandler(msg:Message):Object
		{
			swfParser(msg.wParam as ByteArray);
			
			return null;
		}
		
		protected function promiscSwcCodeHandler(msg:Message):Object
		{
			var bytes:ByteArray = msg.wParam as ByteArray;
			
			var zip:ZipFile = new ZipFile(bytes);
			
			var entity:ZipEntry = zip.getEntry("library.swf");
			
			var swfBytes:ByteArray = zip.getInput(entity);
			
			var m:Message = new Message();
			
			m.msg = 0;
			m.wParam = swfBytes;
			
			return promiscSwfCodeHandler(m);
		}
		
		private function swfParser(bytes:ByteArray):void
		{
			var reader:SwfReader = new SwfReader(bytes);
			
			reader.readHeader();
			var start:int = getTimer();
			var list:Array = reader.readTags();
			trace(getTimer() - start + " 毫秒");
			var abcList:Array = [];
			
			for each(var tag:Tag in list)
			{
				if(tag.tagType == TagTypes.TAG_DOABC2) abcList.push(tag);
			}
			
			//trace(abcList.length);
			
			//reader.toBinary();
			
//			trace("SWF文件大小：" + reader.length);
//			trace(String.fromCharCode(reader.readByte()));
//			trace(String.fromCharCode(reader.readByte()));
//			trace(String.fromCharCode(reader.readByte()));
//			trace("Version: " + reader.readByte());
//			trace("File length: " + reader.readUnsignedInt());
//			trace("FrameSize: " + reader.readUnsignedInt());
//			var rect:RectRecord = reader.readRECT();
		}
	}
}