package jsion
{
	import flash.display.Stage;
	
	/**
	 * <p>JsionCore类库的初始化函数(仅初始化缓存)</p>
	 * <p>缓存 config 格式如下：</p>
	 * <p>&lt;Root&gt;</p>
	 * <p>　　&lt;version from="0" to="1"&gt;</p>
	 * <p>　　　　&lt;file value="*.png" /&gt;</p>
	 * <p>　　&lt;/version&gt;</p>
	 * <p>&lt;/Root&gt;</p>
	 */	
	public function JsionCoreSetup(config:XML):void
	{
		Cache.setup(config);
	}
}