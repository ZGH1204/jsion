package jsion
{
	import flash.display.Stage;
	
	import jsion.core.modules.ModuleMgr;
	import jsion.utils.BrowserUtil;

	/**
	 * JsionCore类库的初始化函数  <br />
	 * config 格式如下： <br />
	 * &lt;root&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;Policys&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;policy file="crossdomain.xml" /&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;/Policys&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;version from="0" to="1"&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;file value="*.png" /&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;/version&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;Startup id="JsionCore" cls="jsion.core.JsionCoreModule" url="..\..\JsionCore\bin\JsionCore.swc" crypted="false" /&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;Modules&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;Module id="JsionSocket" cls="jsion.core.JsionCoreModule" url="..\..\JsionSocket\bin\JsionSocket.swc" autoLoad="false" crypted="false" target="_self" /&gt; <br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;/Modules&gt; <br />
	 * &lt;/root&gt;
	 */	
	public function JsionCoreSetup(stage:Stage, config:XML):void
	{
		Policy.loadPolicyFile(config.Policys..policy);
		
		StageRef.setup(stage);
		
		Cache.setup(config);
		
		BrowserUtil.setup(stage.root);
		
		ModuleMgr.setup(config);
	}
}