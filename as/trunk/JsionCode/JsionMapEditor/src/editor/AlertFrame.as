package editor
{
	import org.aswing.ASColor;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	import org.aswing.ext.Form;

	public class AlertFrame extends JsionEditorWin
	{
		private var label:JLabel;
		
		private var msgText:String;
		
		public function AlertFrame(owner:JsionMapEditor, text:String, t:String = "提示")
		{
			mytitle = t;
			msgText = text;
			super(owner, true);
		}
		
		override protected function init():void
		{
			main = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, padding));
			
			box = new Form();
			
			label = new JLabel(msgText);
			label.setForeground(new ASColor(0xFF0000));
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
			
			main.append(new JPanel());
			main.append(box);
			
			main.setSizeWH(rltWidth, rltHeight);
			
			//main.setSizeWH(300, 200);
			
			super.init();
		}
		
		public static function msg(owner:JsionMapEditor, text:String, t:String = "提示"):void
		{
			new AlertFrame(owner, text, t).show();
		}
	}
}