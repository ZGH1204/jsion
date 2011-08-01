package jpromiscuous
{
	import flash.utils.ByteArray;
	
	import jcore.org.message.Message;
	import jcore.org.moduls.DefaultModule;
	import jcore.org.moduls.ModuleInfo;
	
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
			var bytes:ByteArray = msg.wParam as ByteArray;
			
			trace("SWF文件大小：" + bytes.length);
			
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
	}
}