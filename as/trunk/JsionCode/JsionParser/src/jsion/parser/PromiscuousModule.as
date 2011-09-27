package jsion.parser
{
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import jsion.core.messages.Msg;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	import jsion.core.zip.ZipEntry;
	import jsion.core.zip.ZipFile;
	import jsion.parser.swf.SwfReader;
	import jsion.parser.swf.Tag;
	import jsion.parser.swf.TagTypes;
	
	public class PromiscuousModule extends BaseModule
	{
		public function PromiscuousModule(moduleInfo:ModuleInfo)
		{
			super(moduleInfo);
		}
		
		override public function startup():void
		{
			registeHandler(PromiscuousMessage.PROMISC_SWF, promiscSwfCodeHandler);
			registeHandler(PromiscuousMessage.PROMISC_SWC, promiscSwcCodeHandler);
		}
		
		override public function stop():void
		{
			removeHandler(PromiscuousMessage.PROMISC_SWF);
			removeHandler(PromiscuousMessage.PROMISC_SWC);
		}
		
		protected function promiscSwfCodeHandler(msg:Msg):Object
		{
			swfParser(msg.wParam as ByteArray);
			
			return null;
		}
		
		protected function promiscSwcCodeHandler(msg:Msg):Object
		{
			var bytes:ByteArray = msg.wParam as ByteArray;
			
			var zip:ZipFile = new ZipFile(bytes);
			
			var entity:ZipEntry = zip.getEntry("library.swf");
			
			var swfBytes:ByteArray = zip.getInput(entity);
			
			var m:Msg = new Msg();
			
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