package editor
{
	import org.aswing.ASColor;
	import org.aswing.JLabel;
	import editor.forms.BaseEditorForm;

	public class MsgBox extends BaseEditorForm
	{
		private var label:JLabel;
		
		private var msgText:String;
		
		private var tColor:uint;
		
		public function MsgBox(owner:JsionMapEditor, text:String, textColor:uint = 0xFF0000, t:String = "提示")
		{
			mytitle = t;
			msgText = text;
			tColor = textColor;
			super(owner, true);
		}
		
		override protected function init():void
		{
			initMain();
			
			label = new JLabel(msgText);
			label.setForeground(new ASColor(tColor));
			label.pack();
			
			var rltWidth:int;
			var rltHeight:int;
			
			if(label.width <= 250)
			{
				rltWidth = 250;
			}
			else
			{
				rltWidth = label.width + 40;
			}
			
			if(label.height + 75 <= 100)
			{
				rltHeight = 100;
			}
			else
			{
				rltHeight = label.height + 75;
			}
			
			label.setPreferredWidth(rltWidth);
			
			box.addRow(label);
			
			WinWidth = rltWidth;
			WinHeight = rltHeight;
			
			super.init();
		}
		
		public static function msg(owner:JsionMapEditor, text:String, textColor:uint = 0xFF0000, t:String = "提示"):void
		{
			new MsgBox(owner, text, textColor, t).show();
		}
	}
}