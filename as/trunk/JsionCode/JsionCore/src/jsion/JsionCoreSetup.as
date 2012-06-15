package jsion
{
	import flash.display.Stage;
	
	/**
	 * JsionCore类库的初始化函数(仅初始化缓存)<br />
	 * 缓存 config 格式如下： <br />
	 * &lt;Root&gt; <br />
	 * 　　&lt;version from="0" to="1"&gt; <br />
	 * 　　　　&lt;file value="*.png" /&gt; <br />
	 * 　　&lt;/version&gt; <br />
	 * &lt;/Root&gt;
	 */	
	public function JsionCoreSetup(config:XML):void
	{
		Cache.setup(config);
	}
}