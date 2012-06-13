package editor.rightviews
{
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.border.TitledBorder;
	import org.aswing.ext.Form;
	
	public class CoordViewer extends JPanel
	{
		protected var box:Form;
		
		protected var worldPos:JLabel;
		protected var tilePos:JLabel;
		protected var scenePos:JLabel;
		
		public function CoordViewer()
		{
			super();
			
			initialize();
		}
		
		protected function initialize():void
		{
			box = new Form();
			append(box);
			
			worldPos = new JLabel("0,0", null, JLabel.LEFT);
			worldPos.setPreferredWidth(80);
			
			tilePos = new JLabel("0,0", null, JLabel.LEFT);
			
			scenePos = new JLabel("0,0", null, JLabel.LEFT);
			
			box.addRow(new JLabel("世界坐标："), worldPos);
			box.addRow(new JLabel("区域坐标："), tilePos);
			box.addRow(new JLabel("屏幕坐标："), scenePos);
			
			setPreferredHeight(100);
			
			setBorder(new TitledBorder(null, '坐标信息', TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		public function setWorldPos(x:int, y:int):void
		{
			worldPos.setText(x + "," + y);
		}
		
		public function setTilePos(x:int, y:int):void
		{
			tilePos.setText(x + "," + y);
		}
		
		public function setScreenPos(x:int, y:int):void
		{
			scenePos.setText(x + "," + y);
		}
	}
}