package knightage.core
{
	import flash.display.Sprite;
	
	import jsion.StageRef;
	import jsion.core.Global;
	import jsion.core.loaders.BinaryLoader;
	import jsion.core.loaders.ILoaders;
	import jsion.core.loaders.LoaderGlobal;
	import jsion.core.modules.ModuleMgr;
	import jsion.core.reflection.Assembly;
	import jsion.core.scenes.SceneMgr;
	import jsion.utils.BrowserUtil;
	import jsion.utils.StringUtil;
	
	import knightage.core.mgrs.TemplatesMgr;
	import knightage.core.net.PacketHandlers;
	import knightage.core.net.KPacket;
	import knightage.core.net.SocketProxy;
	import knightage.core.scenes.KSceneType;
	import knightage.core.scenes.SceneCreator;

	public function StartGame(loaders:ILoaders):void
	{
		Config.setup(Global.ConfigXml);
		
		LoaderGlobal.registeNewType("hy", LoaderGlobal.TYPE_BINARY, BinaryLoader);
		
		SocketProxy.setPacketClass(KPacket);
		
		TemplatesMgr.setup(loaders.getXml(Files.TemplatesFile));
		
		var ass:Assembly = ModuleMgr.getAssembly(ModuleType.K_CORE);
		
		PacketHandlers.setup(ass);
		
		var controller:ModuleLoadingViewController = new ModuleLoadingViewController();
		
		ModuleMgr.setLoadingViewController(controller);
		
		var container:Sprite = new Sprite();
		
		StageRef.addChild(container);
		
		SceneMgr.setup(container, new SceneCreator());
		
//		if(Config.config.Debug)
//		{
//			var ip:String = BrowserUtil.getVal("ip") as String;
//			var port:int = int(BrowserUtil.getVal("port"));
//			
//			if(StringUtil.isNotNullOrEmpty(ip) && port > 0)
//			{
//				SocketProxy.connect(ip, port);
//				return;
//			}
//		}
//		
//		SocketProxy.connect(Config.config.SrvIP, Config.config.SrvPort);
		
		MsgProxy.createAndPostMsg(MsgFlag.StartGame);
		//SceneMgr.setScene(KSceneType.CITY);
	}
}