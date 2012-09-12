package jsion.tool.pngpacker.panes
{
	import flash.display.BitmapData;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import jsion.tool.WaiteFrame;
	import jsion.tool.mgrs.FileMgr;
	import jsion.tool.pngpacker.PackerFrame;
	import jsion.tool.pngpacker.QueueLoader;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.tool.pngpacker.panes.parts.FrameItem;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DelayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	import org.aswing.AbstractButton;
	import org.aswing.ButtonGroup;
	import org.aswing.DefaultButtonModel;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.SoftBoxLayout;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.AWEvent;
	import org.aswing.event.InteractiveEvent;
	
	public class BottomPane extends JPanel
	{
		private var m_frame:PackerFrame;
		
		private var m_info:DirectionInfo;
		
		private var m_upPane:JPanel;
		private var m_downPane:JScrollPane;
		
		private var m_addPicBtn:JButton;
		private var m_delPicBtn:JButton;
		private var m_prePicBtn:JButton;
		private var m_nxtPicBtn:JButton;
		private var m_hBox:JPanel;
		
		private var m_group:ButtonGroup;
		private var m_itemList:Array;
		
		private var m_queue:QueueLoader;
		
		private var m_loading:Boolean;
		
		public function BottomPane(frame:PackerFrame)
		{
			m_frame = frame;
			
			m_itemList = [];
			
			m_group = new ButtonGroup();
			m_group
			
			super(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			
			setPreferredHeight(170);
			
			setBorderTitle();
			
			m_upPane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
//			m_upPane.setBorder(new TitledBorder(null, "", TitledBorder.TOP, TitledBorder.LEFT, 1));
			append(m_upPane);
			
			m_downPane = new JScrollPane();
//			m_downPane.setBorder(new TitledBorder(null, "帧", TitledBorder.TOP, TitledBorder.LEFT, 1));
//			m_downPane.setBackground(new ASColor(0x336699));
//			m_downPane.setOpaque(true);
			m_downPane.setPreferredHeight(120);
			
			m_hBox = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 3, SoftBoxLayout.LEFT));
//			m_hBox.setBackground(new ASColor(0x336699));
//			m_hBox.setOpaque(true);
			m_downPane.append(m_hBox);
			
			append(m_downPane);
			
			m_addPicBtn = new JButton("添加帧");
			m_addPicBtn.setEnabled(false);
			m_addPicBtn.addActionListener(__addActionHandler);
			m_upPane.append(m_addPicBtn);
			
			m_delPicBtn = new JButton("删除帧");
			m_delPicBtn.setEnabled(false);
			m_delPicBtn.addActionListener(__delActionHandler);
			m_upPane.append(m_delPicBtn);
			
			m_prePicBtn = new JButton("向前移");
			m_prePicBtn.setEnabled(false);
			m_prePicBtn.addActionListener(__preActionHandler);
			m_upPane.append(m_prePicBtn);
			
			m_nxtPicBtn = new JButton("向后移");
			m_nxtPicBtn.setEnabled(false);
			m_nxtPicBtn.addActionListener(__nxtActionHandler);
			m_upPane.append(m_nxtPicBtn);
		}
		
		private function __addActionHandler(e:AWEvent):void
		{
			if(m_loading) return;
			
			FileMgr.openMultiBrowse(selectMultiCallback, [new FileFilter("帧图片", "*.png")]);
		}
		
		private function __selectMultiHandler(e:FileListEvent):void
		{
			m_loading = true;
			
			DisposeUtil.free(m_queue);
			m_queue = new QueueLoader();
			
			var list:Array = e.files;
			
			for each(var f:File in list)
			{
				m_queue.add(f);
			}
			
			m_queue.start(loadCallback);
			
			WaiteFrame.show("正在加载图片...");
		}
		
		private function selectMultiCallback(list:Array):void
		{
			m_loading = true;
			
			DisposeUtil.free(m_queue);
			m_queue = new QueueLoader();
			
			for each(var f:File in list)
			{
				m_queue.add(f);
			}
			
			m_queue.start(loadCallback);
			
			WaiteFrame.show("正在加载图片...");
		}
		
		private function loadCallback(list:Array):void
		{
			m_loading = false;
			
			for each(var bmd:BitmapData in list)
			{
				m_info.addBitmapData(bmd);
				
				createItem(bmd);
			}
			
			
			DelayUtil.setDelayApply(closeWaitFrame, 1);
			//WaiteFrame.close();
		}
		
		private function closeWaitFrame():void
		{
			WaiteFrame.close();
		}
		
		private function __delActionHandler(e:AWEvent):void
		{
			var btn:FrameItem = m_group.getSelectedButton() as FrameItem;
			
			if(btn)
			{
				deleteItem(btn);
			}
		}
		
		private function __preActionHandler(e:AWEvent):void
		{
			var btn:FrameItem = m_group.getSelectedButton() as FrameItem;
			
			var index:int = m_itemList.indexOf(btn);
			
			if(btn && index > 0)
			{
				index--;
				
				moveItem(btn, index);
			}
		}
		
		private function __nxtActionHandler(e:AWEvent):void
		{
			var btn:FrameItem = m_group.getSelectedButton() as FrameItem;
			
			var index:int = m_itemList.indexOf(btn);
			
			var maxIndex:int = m_itemList.length - 1;
			
			if(btn && index < maxIndex)
			{
				index++;
				
				moveItem(btn, index);
			}
		}
		
		private function createItem(bmd:BitmapData):void
		{
			if(bmd == null) return;
			
			var item:FrameItem = new FrameItem(bmd);
			//item.setText((m_itemList.length + 1).toString());
			
			item.getModel().addSelectionListener(__selectionHandler);
			
			m_group.append(item);
			m_hBox.append(item);
			m_itemList.push(item);
		}
		
		private function deleteItem(item:FrameItem):void
		{
			if(item == null) return;
			
			m_info.removeBitmapData(item.bmd);
			m_group.remove(item);
			m_hBox.remove(item);
			ArrayUtil.remove(m_itemList, item);
			item.setSelected(false);
			item.getModel().removeSelectionListener(__selectionHandler);
			DisposeUtil.free(item);
		}
		
		private function moveItem(item:FrameItem, index:int):void
		{
			if(item == null) return;
			
			m_info.removeBitmapData(item.bmd);
			m_info.insertBitmapData(item.bmd, index);
			m_hBox.insert(index, item);
			ArrayUtil.remove(m_itemList, item);
			ArrayUtil.insert(m_itemList, item, index);
			
			updateBtnEnabled();
		}
		
		private function __selectionHandler(e:InteractiveEvent):void
		{
			var mode:DefaultButtonModel = DefaultButtonModel(e.currentTarget);
			
			if(mode.isSelected() == false)
			{
				m_delPicBtn.setEnabled(false);
				m_prePicBtn.setEnabled(false);
				m_nxtPicBtn.setEnabled(false);
				
				return;
			}
			
			updateBtnEnabled();
		}
		
		private function updateBtnEnabled():void
		{
			var btn:AbstractButton = m_group.getSelectedButton();
			var index:int = m_itemList.indexOf(btn);
			var maxIndex:int = m_itemList.length - 1;
			
			if(m_info) m_addPicBtn.setEnabled(true);
			else m_addPicBtn.setEnabled(false);
			
			if(btn)
			{
				m_delPicBtn.setEnabled(true);
				
				if(index > 0) m_prePicBtn.setEnabled(true);
				else m_prePicBtn.setEnabled(false);
				
				if(index < maxIndex)m_nxtPicBtn.setEnabled(true);
				else m_nxtPicBtn.setEnabled(false);
			}
			else
			{
				m_delPicBtn.setEnabled(false);
				m_prePicBtn.setEnabled(false);
				m_nxtPicBtn.setEnabled(false);
			}
		}
		
		private function setBorderTitle(actionName:String = null, dirName:String = null):void
		{
			if(StringUtil.isNullOrEmpty(actionName) || StringUtil.isNullOrEmpty(dirName))
			{
				setBorder(new TitledBorder(null, "帧列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			}
			else
			{
				setBorder(new TitledBorder(null, "帧列表：" + actionName + "-" + dirName, TitledBorder.TOP, TitledBorder.LEFT, 10));
			}
		}
		
		private function clear():void
		{
			if(m_info == null) return;
			
			ArrayUtil.removeAll(m_itemList);
			m_hBox.removeAll();
			var list:Array = m_group.getElements();
			
			for each(var btn:AbstractButton in list)
			{
				m_group.remove(btn);
				DisposeUtil.free(btn);
			}
			
			updateBtnEnabled();
		}
		
		public function setDirInfo(dir:DirectionInfo = null):void
		{
			if(m_info != dir)
			{
				clear();
				
				m_info = dir;
				
				if(m_info)
				{
					setBorderTitle(m_info.action.name, m_info.name);
					
					var list:Array = m_info.getList();
					
					for each(var bmd:BitmapData in list)
					{
						createItem(bmd);
					}
					
					updateBtnEnabled();
				}
				else
				{
					setBorderTitle();
					
					updateBtnEnabled();
				}
			}
		}
	}
}