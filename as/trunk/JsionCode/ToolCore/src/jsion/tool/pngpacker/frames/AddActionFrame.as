package jsion.tool.pngpacker.frames
{
	import flash.events.Event;
	
	import jsion.Global;
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.pngpacker.PackerFrame;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.tool.pngpacker.data.PackerModel;
	import jsion.utils.ArrayUtil;
	
	import org.aswing.JComboBox;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.event.AWEvent;
	import org.aswing.ext.Form;
	import org.aswing.tree.TreePath;
	
	public class AddActionFrame extends BaseFrame
	{
		private var actionCombo:JComboBox;
		private var directionCombo:JComboBox;
		
		private var frame:PackerFrame;
		
		public function AddActionFrame(f:PackerFrame)
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
			
			actionCombo = new JComboBox(ArrayUtil.clone(Global.ActionNames));
			actionCombo.setEditable(false);
			actionCombo.setPreferredWidth(200);
			m_box.addRow(new JLabel("动作："), actionCombo);
			
			actionCombo.addActionListener(actionChangeHandler);
			
			directionCombo = new JComboBox(ArrayUtil.clone(Global.DirNames));
			directionCombo.setEditable(false);
			directionCombo.setPreferredWidth(200);
			m_box.addRow(new JLabel("朝向："), directionCombo);
			
			buildFormButton();
			
			m_cancleBtn.setText("保存并新建");
		}
		
		protected function actionChangeHandler(e:AWEvent):void
		{
			if(directionCombo) directionCombo.setSelectedIndex(0);
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
			directionCombo.setSelectedIndex(directionCombo.getSelectedIndex() + 1);
		}
		
		private function saveAction():void
		{
			var data:PackerModel = frame.packerData;
			
			var actionID:int = actionCombo.getSelectedIndex() + 1;
			//var actionName:String = actionCombo.getSelectedItem();
			
			var dirID:int = directionCombo.getSelectedIndex() + 1;
			//var dirName:String = directionCombo.getSelectedItem();
			
			var dirInfo:DirectionInfo = data.addAction(actionID, dirID);
			
			frame.setSelected(dirInfo);
		}
		
		override public function closeReleased():void
		{
			if(actionCombo) actionCombo.removeActionListener(actionChangeHandler);
			
			super.closeReleased();
		}
	}
}