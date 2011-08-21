package jui.org.defres
{
	import jui.org.IUIResource;
	import jui.org.StyleTune;
	
	public class UIStyleTune extends StyleTune implements IUIResource
	{
		public function UIStyleTune(cg:Number=0.2, bo:Number=0.15, bg:Number=0.35, sa:Number=0.2, r:Number=0, ma:StyleTune=null)
		{
			super(cg, bo, bg, sa, r, ma);
		}
	}
}