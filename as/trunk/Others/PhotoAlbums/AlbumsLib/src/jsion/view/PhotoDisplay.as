package jsion.view
{
	import com.interfaces.IDispose;
	
	import flash.display.Sprite;
	
	import jsion.controls.Button;
	import jsion.data.PhotoPage;
	
	public class PhotoDisplay extends Sprite implements IDispose
	{
		public function PhotoDisplay()
		{
			super();
		}
		
		public var photoPage:PhotoPage;
		
		public function setCloseBtn(btn:Button):void
		{
			if(btn == null || photoPage == null) return;
			btn.x -= photoPage.closeBtnPaddingX;
			btn.y += photoPage.closeBtnPaddingY;
			addChild(btn);
		}
		
		public function dispose():void
		{
			photoPage = null;
			if(parent) parent.removeChild(this);
		}
	}
}