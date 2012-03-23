package jsion.tool.pngpacker
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import jsion.tool.pngpacker.frames.AddActionFrame;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.LoadIcon;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class ToolBox extends JPanel
	{
		private var m_frame:PackerFrame;
		
		private var m_newActionBtn:JButton;
		private var m_delActionBtn:JButton;
		
		private var m_savePackBtn:JButton;
		private var m_openPackBtn:JButton;
		
		private var m_saveFile:File;
		private var m_openFile:File;
		private var m_browsing:Boolean;
		
		public function ToolBox(frame:PackerFrame)
		{
			m_frame = frame;
			
			super(new FlowLayout(FlowLayout.LEFT, 3, 3));
			
			m_newActionBtn = new JButton("添加", new LoadIcon("assets/NewPackage.png"));
			m_newActionBtn.addActionListener(onNewAction);
			m_newActionBtn.setToolTipText("添加一个动作的方向");
			append(m_newActionBtn);
			
			m_delActionBtn = new JButton("删除", new LoadIcon("assets/NewPackage.png"));
			m_delActionBtn.addActionListener(onDelAction);
			m_delActionBtn.setToolTipText("删除一个动作的方向");
			m_delActionBtn.setEnabled(false);
			append(m_delActionBtn);
			
			m_savePackBtn = new JButton("保存", new LoadIcon("assets/NewPackage.png"));
			m_savePackBtn.addActionListener(onSaveAction);
			m_savePackBtn.setToolTipText("压缩保存所有动作资源");
			append(m_savePackBtn);
			
			m_openPackBtn = new JButton("打开", new LoadIcon("assets/NewPackage.png"));
			m_openPackBtn.addActionListener(onOpenAction);
			m_openPackBtn.setToolTipText("打开一个压缩的动作资源");
			append(m_openPackBtn);
			
			m_browsing = false;
			
			m_saveFile = new File();
			m_saveFile.addEventListener(Event.SELECT, __saveSelectHandler);
			
			m_openFile = new File();
			m_openFile.addEventListener(Event.SELECT, __openSelectHandler);
		}
		
		private function onNewAction(e:AWEvent):void
		{
			var frame:AddActionFrame = new AddActionFrame(m_frame);
			
			frame.show();
		}
		
		private function onDelAction(e:AWEvent):void
		{
			m_frame.delSelected();
		}
		
		private function onSaveAction(e:AWEvent):void
		{
			if(m_browsing == false)
			{
				m_browsing = true;
				m_saveFile.browseForSave("保存到");
			}
		}
		
		private function onOpenAction(e:AWEvent):void
		{
			if(m_browsing == false)
			{
				m_browsing = true;
				m_openFile.browseForOpen("选择一个动作资源", [new FileFilter("动作资源", "*.hy")]);
			}
		}
		
		private function __saveSelectHandler(e:Event):void
		{
			m_browsing = false;
			
			var f:File = File(e.target);
			
			m_frame.packerData.save(f.nativePath);
		}
		
		private function __openSelectHandler(e:Event):void
		{
			m_browsing = false;
			
			m_openPackBtn.setEnabled(false);
			
			var f:File = File(e.target);
			
			m_frame.read(f);
		}
		
		public function setDelBtnEnabled(b:Boolean):void
		{
			m_delActionBtn.setEnabled(b);
		}
	}
}