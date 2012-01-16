package jsion.tool.pngpacker.frames
{
	import flash.events.Event;
	
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.pngpacker.PNGPackerFrame;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.tool.pngpacker.data.PackerModel;
	
	import org.aswing.JComboBox;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.ext.Form;
	import org.aswing.tree.TreePath;
	
	public class AddActionFrame extends BaseFrame
	{
		private var actionCombo:JComboBox;
		private var directionCombo:JComboBox;
		
		private var frame:PNGPackerFrame;
		
		public function AddActionFrame(f:PNGPackerFrame)
		{
			m_title = "新建动作";
			
			frame = f;
			
			super(ToolGlobal.window, true);
			
			setResizable(false);
			
			setSizeWH(260, 150);
			
			configUI();
		}
		
		private function configUI():void
		{
			buildForm();
			
			actionCombo = new JComboBox(["待机动作", "行走动作", "奔跑动作", "攻击动作", "防御动作", "受伤动作", "技能动作", "死亡动作"]);
			actionCombo.setEditable(false);
			actionCombo.setPreferredWidth(200);
			box.addRow(new JLabel("动作："), actionCombo);
			
			directionCombo = new JComboBox(["上", "下", "左", "右", "左上", "右上", "左下", "右下"]);
			directionCombo.setEditable(false);
			directionCombo.setPreferredWidth(200);
			box.addRow(new JLabel("朝向："), directionCombo);
			
			buildFormButton();
			
			bt_cancle.setText("保存并新建");
		}
		
		override protected function onSubmit(e:Event):void
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return;
			
			saveAction();
			
			super.onSubmit(e);
		}
		
		override protected function onCancle(e:Event):void
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return;
			
			saveAction();
		}
		
		private function saveAction():void
		{
			var data:PackerModel = frame.packerData;
			
			var actionID:int = actionCombo.getSelectedIndex() + 1;
			var actionName:String = actionCombo.getSelectedItem();
			
			var dirID:int = directionCombo.getSelectedIndex() + 1;
			var dirName:String = directionCombo.getSelectedItem();
			
			var dirInfo:DirectionInfo = data.addAction(actionName, actionID, dirName, dirID);
			
			frame.setSelected(data.getAction(actionID), dirInfo);
		}
	}
}