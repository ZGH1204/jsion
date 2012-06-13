package jsion
{
	import flash.display.Stage;
	
	import jsion.core.ddrop.DDropMgr;
	import jsion.core.modules.ModuleMgr;
	import jsion.utils.BrowserUtil;

	/**
	 * JsionCore类库的初始化函数  <br />
	 * config 格式如下： <br />
	 * &lt;root&gt; <br />
	 * 　　&lt;Policys&gt; <br />
	 * 　　　　&lt;policy file="crossdomain.xml" /&gt; <br />
	 * 　　&lt;/Policys&gt; <br />
	 * 　　&lt;version from="0" to="1"&gt; <br />
	 * 　　　　&lt;file value="*.png" /&gt; <br />
	 * 　　&lt;/version&gt; <br />
	 * 　　&lt;Startup id="JsionCore" cls="jsion.core.JsionCoreModule" url="..\..\JsionCore\bin\JsionCore.swc" crypted="false" /&gt; <br />
	 * 　　&lt;Modules&gt; <br />
	 * 　　　　&lt;Module id="JsionSocket" cls="jsion.core.JsionCoreModule" url="..\..\JsionSocket\bin\JsionSocket.swc" autoLoad="false" crypted="false" target="_self" /&gt; <br />
	 * 　　&lt;/Modules&gt; <br />
	 * &lt;/root&gt;
	 */	
	public function JsionCoreSetup(stage:Stage, config:XML):void
	{
		StageRef.setup(stage);
		
		DDropMgr.setup(stage);
		
		BrowserUtil.setup(stage);
		
		Policy.loadPolicyFile(config.Policys..policy);
		
		Cache.setup(config);
		
		//ModuleMgr.setup(config);
	}
}