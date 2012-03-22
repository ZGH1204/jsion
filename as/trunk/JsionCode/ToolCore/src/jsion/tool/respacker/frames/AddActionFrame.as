package jsion.tool.respacker.frames
{
	import flash.events.Event;
	
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.respacker.events.PackerEvent;
	
	import org.aswing.JComboBox;
	import org.aswing.JLabel;
	import org.aswing.event.AWEvent;
	
	public class AddActionFrame extends BaseFrame
	{
		private var actionCombo:JComboBox;
		private var directionCombo:JComboBox;
		
		public function AddActionFrame()
		{
			m_title = "新建动作";
			
			super(ToolGlobal.window, true);
			
			setResizable(false);
			
			setSizeWH(260, 150);
			
			buildForm();
			
			actionCombo = new JComboBox(["待机动作", "行走动作", "奔跑动作", "攻击动作", "防御动作", "受伤动作", "技能动作", "死亡动作"]);
			actionCombo.setEditable(false);
			actionCombo.setPreferredWidth(200);
			box.addRow(new JLabel("动作："), actionCombo);
			
			actionCombo.addActionListener(actionChangeHandler);
			
			directionCombo = new JComboBox(["上", "下", "左", "右", "左上", "右上", "左下", "右下"]);
			directionCombo.setEditable(false);
			directionCombo.setPreferredWidth(200);
			box.addRow(new JLabel("朝向："), directionCombo);
			
			buildFormButton();
			
			bt_cancle.setText("保存并新建");
		}
		
		public function get selectedActionID():int
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return -1;
			
			return actionCombo.getSelectedIndex() + 1;
		}
		
		public function get selectedActionName():String
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return null;
			
			return actionCombo.getSelectedItem();
		}
		
		public function get selectedDirID():int
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return -1;
			
			return directionCombo.getSelectedIndex() + 1;
		}
		
		public function get selectedDirName():String
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return null;
			
			return directionCombo.getSelectedItem();
		}
		
		protected function actionChangeHandler(e:AWEvent):void
		{
			if(directionCombo) directionCombo.setSelectedIndex(0);
		}
		
		override protected function onSubmit(e:Event):void
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return;
			
			fireAddEvent();
			
			super.onSubmit(e);
		}
		
		override protected function onCancle(e:Event):void
		{
			if(actionCombo.getSelectedIndex() < 0 || 
				directionCombo.getSelectedIndex() < 0) return;
			
			fireAddEvent();
			
			directionCombo.setSelectedIndex(directionCombo.getSelectedIndex() + 1);
		}
		
		protected function fireAddEvent():void
		{
			dispatchEvent(new PackerEvent(PackerEvent.ADD_ACTION));
		}
	}
}