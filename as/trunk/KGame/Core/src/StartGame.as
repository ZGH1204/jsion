package
{
	import core.events.StartEvent;
	import core.loading.LibMgr;
	import core.net.GamePacket;
	import core.net.PacketHandlers;
	import core.net.SocketProxy;
	import core.scene.SceneCreator;
	import core.start.StartMgr;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.media.Sound;
	
	import jsion.GameCoreSetup;
	import jsion.SetupComps;
	import jsion.comps.UIMgr;
	import jsion.debug.DEBUG;
	import jsion.lang.Local;
	import jsion.loaders.LoaderQueue;
	import jsion.reflection.Assembly;
	import jsion.scenes.SceneMgr;
	import jsion.sounds.SoundMgr;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.PathUtil;
	import jsion.utils.StringUtil;
	
	import knightage.display.Alert;

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
		
		//安装加载库列表
		LibMgr.setup(config);
		
		//安装配置信息
		Config.setup(config);
		
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
		
		//解析模板文件
		file = LibMgr.getLibPath(LibMgr.TEMPLATE);
		
		if(StringUtil.isNullOrEmpty(file))
		{
			throw new Error("模板文件路径未配置。");
			return;
		}
		//TODO: 解析模板文件
		
		
		//解析声音、音效
		file = LibMgr.getLibPath(LibMgr.SOUND);
		
		if(StringUtil.isNullOrEmpty(file))
		{
			throw new Error("音效类库文件路径未配置。");
			return;
		}
		
		var soundClsList:Array = queue.getArray(file);
		
		for each(var cls:String in soundClsList)
		{
			var sound:Sound = AppDomainUtil.create(cls) as Sound;
			
			if(sound) SoundMgr.registeSound(cls.replace("Sound", ""), sound);
		}
		
		
		//初始化场景管理
		var sceneContainer:Sprite = new Sprite();
		stage.addChild(sceneContainer);
		SceneMgr.setup(sceneContainer, new SceneCreator());
		
		
		//初始化UI层级管理
		var uiLayer:Sprite = new Sprite();
		stage.addChild(uiLayer);
		UIMgr.setup(uiLayer);
		
		
		//初始化调试控制台
		DEBUG.setup(stage, 250);
		var cssPath:String = PathUtil.combinPath(String(config.@LibRoot), String(config.@DebugCSS));
		DEBUG.loadCSS(cssPath);
		
		//初始化完成后触发事件
		StartMgr.dispatchEvent(new StartEvent(StartEvent.INITIALIZED));
	}
}