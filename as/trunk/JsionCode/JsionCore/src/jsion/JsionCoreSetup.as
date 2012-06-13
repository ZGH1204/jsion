package jsion
{
	import flash.display.Stage;
	
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
	 * &lt;/root&gt;
	 */	
	public function JsionCoreSetup(stage:Stage, config:XML):void
	{
		StageRef.setup(stage);
		
		BrowserUtil.setup(stage);
		
		Policy.loadPolicyFile(config.Policys..policy);
		
		Cache.setup(config);
	}
}