package jsion
{
	import flash.display.Stage;
	
	import jsion.comps.CursorMgr;
	import jsion.comps.UIMgr;
	import jsion.ddrop.DDropMgr;

	public function SetupComps(stage:Stage):void
	{
		DDropMgr.setup(stage);
		
		UIMgr.setup(stage);
//		
//		CursorMgr.setup(stage);
	}
}