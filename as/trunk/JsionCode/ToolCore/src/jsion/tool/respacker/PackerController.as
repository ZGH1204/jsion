package jsion.tool.respacker
{
	import jsion.IDispose;
	import jsion.tool.respacker.events.PackerEvent;
	import jsion.tool.respacker.frames.AddActionFrame;
	
	import org.aswing.event.AWEvent;
	import org.aswing.event.FrameEvent;
	
	public class PackerController implements IDispose
	{
		protected var m_model:PackerModel;
		protected var m_viewr:PackerFrame;
		
		protected var m_toolBox:ToolBox;
		
		protected var m_addFrame:AddActionFrame;
		
		public function PackerController(view:PackerFrame)
		{
			m_viewr = view;
			
			initialize();
			
			initEvent();
		}
		
		private function initialize():void
		{
			m_model = new PackerModel();
			
			m_toolBox = new ToolBox();
			
			m_viewr.leftPane.setTreeModel(m_model.treeModel);
			
			m_viewr.topPane.append(m_toolBox);
		}
		
		private function initEvent():void
		{
			m_toolBox.newActionBtn.addActionListener(onAddActionBtnClickedHandler);
		}
		
		private function onAddActionBtnClickedHandler(e:AWEvent):void
		{
			if(m_addFrame) return;
			
			m_addFrame = new AddActionFrame();
			
			m_addFrame.addEventListener(PackerEvent.ADD_ACTION, onAddActionHandler);
			m_addFrame.addEventListener(FrameEvent.FRAME_CLOSING, onAddFrameClosingHandler);
			
			m_addFrame.show();
		}
		
		private function onAddActionHandler(e:PackerEvent):void
		{
			trace("Add action!", m_addFrame.selectedActionName, m_addFrame.selectedDirName);
			
			
		}
		
		private function onAddFrameClosingHandler(e:AWEvent):void
		{
			trace("Add action frame closing!");
			
			m_addFrame.removeEventListener(PackerEvent.ADD_ACTION, onAddActionHandler);
			m_addFrame.removeEventListener(FrameEvent.FRAME_CLOSING, onAddFrameClosingHandler);
			
			m_addFrame = null;
		}
		
		public function dispose():void
		{
		}
	}
}