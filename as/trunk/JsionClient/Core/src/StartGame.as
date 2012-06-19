package
{
	import core.events.StartEvent;
	import core.loading.LibMgr;
	import core.net.GamePacket;
	import core.net.PacketHandlers;
	import core.net.SocketProxy;
	import core.start.StartMgr;
	
	import flash.display.Stage;
	
	import jsion.GameCoreSetup;
	import jsion.SetupComps;
	import jsion.debug.DEBUG;
	import jsion.lang.Local;
	import jsion.loaders.LoaderQueue;
	import jsion.reflection.Assembly;
	import jsion.utils.StringUtil;

	/**
	 * Loading模块加载游戏基础库完成后执行。
	 */	
	public function StartGame(stage:Stage, config:XML, queue:LoaderQueue):void
	{
		//设置数据包定义类
		SocketProxy.setPacketClass(GamePacket);
		
		//安装基础核心库
		GameCoreSetup(stage);
		
		//安装UI框架
		SetupComps(stage);
		
		LibMgr.setup(config);
		
		var file:String;
		
		//解析语言包文件
		file = LibMgr.getLibPath(LibMgr.LANGUAGE);
		
		if(StringUtil.isNullOrEmpty(file))
		{
			throw new Error("语言包文件路径未配置。");
			return;
		}
		
		var langStr:String = queue.getText(file);
		
		Local.setup(langStr);
		
		
		
		//解析数据包处理类
		file = LibMgr.getLibPath(LibMgr.CORE);
		
		if(StringUtil.isNullOrEmpty(file))
		{
			throw new Error("核心库路径未配置。");
			return;
		}
		
		var clsList:Array = queue.getArray(file);
		var ass:Assembly = new Assembly(clsList);
		PacketHandlers.setup(ass);
		
		
		//初始化调试控制台
		DEBUG.setup(stage, 200);
		
		//初始化完成后触发事件
		StartMgr.dispatchEvent(new StartEvent(StartEvent.INITIALIZED));
	}
}