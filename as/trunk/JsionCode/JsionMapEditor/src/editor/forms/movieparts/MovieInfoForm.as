package editor.forms.movieparts
{
	import editor.forms.MovieEditorForm;
	import editor.forms.renders.RenderInfo;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import jsion.utils.ObjectUtil;
	import jsion.utils.PathUtil;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.AWEvent;
	import org.aswing.ext.Form;
	
	public class MovieInfoForm extends Form
	{
		protected var movieEditorForm:MovieEditorForm;
		
		protected var m_frameWidthTxt:JTextField;
		
		protected var m_frameHeightTxt:JTextField;
		
		protected var m_frameOffsetXTxt:JTextField;
		
		protected var m_frameOffsetYTxt:JTextField;
		
		protected var m_frameTotalTxt:JTextField;
		
		protected var m_frameRateTxt:JTextField;
		
		protected var m_resourcePathTxt:JTextField;
		
		protected var m_filename:String;
		
		protected var m_applyBtn:JButton;
		
		protected var m_delBtn:JButton;
		
		protected var m_applyAllNPCBtn:JButton;
		
		public function MovieInfoForm(form:MovieEditorForm)
		{
			movieEditorForm = form;
			
			super();
			
			initialize();
			
			setBorder(new TitledBorder(null, "序列图配置信息", TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		protected function initialize():void
		{
			m_frameWidthTxt = new JTextField("0", 15);
			m_frameHeightTxt = new JTextField("0", 15);
			addRow(new JLabel("每帧宽度："), m_frameWidthTxt, new JLabel("每帧高度："), m_frameHeightTxt);
			
			m_frameOffsetXTxt = new JTextField("0", 15);
			m_frameOffsetYTxt = new JTextField("0", 15);
			addRow(new JLabel("横轴偏移："), m_frameOffsetXTxt, new JLabel("纵轴偏移："), m_frameOffsetYTxt);
			
			m_frameTotalTxt = new JTextField("1", 15);
			m_frameRateTxt = new JTextField("30");
			addRow(new JLabel("帧总数量："), m_frameTotalTxt, new JLabel("帧　　率："), m_frameRateTxt);
			
			
			
			
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 0));
			
			
			
			
			m_resourcePathTxt = new JTextField("", 10);
			m_resourcePathTxt.setEditable(false);
			m_applyBtn = new JButton("更新");
			m_applyBtn.setEnabled(false);
			m_applyBtn.addActionListener(__applyClickHandler);
			m_applyAllNPCBtn = new JButton("批量更新NPC");
			m_applyAllNPCBtn.setEnabled(false);
			m_applyAllNPCBtn.setToolTipText("使用以上配置信息批量更新所有NPC资源配置");
			m_applyAllNPCBtn.addActionListener(__applyAllNPCClickHandler);
			
			m_delBtn = new JButton("删除");
			m_delBtn.setEnabled(false);
			m_delBtn.addActionListener(__delClickHandler);
			
			jpanle.append(new JLabel("资源路径： "));
			jpanle.append(m_resourcePathTxt);
			jpanle.append(m_applyBtn);
			jpanle.append(m_delBtn);
			jpanle.append(m_applyAllNPCBtn);
			append(jpanle);
		}
		
		private function __applyClickHandler(e:AWEvent):void
		{
			var ri:RenderInfo;
			
			if(movieEditorForm.renderInfos.containsKey(m_filename))
			{
				ri = movieEditorForm.renderInfos.get(m_filename);
				getFormInfo(ri);
			}
			else
			{
				ri = getFormInfo();
				movieEditorForm.renderInfos.put(ri.filename, ri);
			}
			
			movieEditorForm.rendererForm.setRenderInfo(ri);
		}
		
		private function __delClickHandler(e:AWEvent):void
		{
			movieEditorForm.renderInfos.remove(m_filename);
		}
		
		private function getFormInfo(ri:RenderInfo = null):RenderInfo
		{
			if(ri == null) ri = new RenderInfo();
			
			ri.frameWidth = int(m_frameWidthTxt.getText());
			ri.frameHeight = int(m_frameHeightTxt.getText());
			ri.offsetX = int(m_frameOffsetXTxt.getText());
			ri.offsetY = int(m_frameOffsetYTxt.getText());
			ri.frameTotal = int(m_frameTotalTxt.getText());
			ri.fps = int(m_frameRateTxt.getText());
			ri.path = m_resourcePathTxt.getText();
			ri.filename = m_filename;
			
			return ri;
		}
		
		private function __applyAllNPCClickHandler(e:AWEvent):void
		{
			applyAllByForm(JsionEditor.npcRenderInfo, JsionEditor.getNPCsRoot());
		}
		
		private function applyAllByForm(hashMap:HashMap, dir:String):void
		{
			hashMap.removeAll();
			
			var file:File = new File(dir);
			
			if(file.exists == false)
			{
				return;
			}
			
			var ri:RenderInfo = getFormInfo();
			
			var fileList:Array = file.getDirectoryListing();
			
			for(var i:int = 0; i < fileList.length; i++)
			{
				var f:File = fileList[i] as File;
				
				if(f.isDirectory)
				{
					i--;
					fileList.splice(i, 1);
					continue;
				}
				
				var tmp:RenderInfo = new RenderInfo();
				ObjectUtil.copyToTarget(ri, tmp);
				
				tmp.filename = f.name;
				tmp.path = PathUtil.combinPath(JsionEditor.MAP_NPCS_DIR, tmp.filename);
				hashMap.put(tmp.filename, tmp);
			}
		}
		
		public function updateInfo(path:String, filename:String, bmd:BitmapData):void
		{
			if(movieEditorForm.renderInfos.containsKey(filename))
			{
				var ri:RenderInfo = movieEditorForm.renderInfos.get(filename);
				
				m_resourcePathTxt.setText(ri.path);
				
				m_frameWidthTxt.setText(ri.frameWidth.toString());
				m_frameHeightTxt.setText(ri.frameHeight.toString());
				
				m_frameOffsetXTxt.setText(ri.offsetX.toString());
				m_frameOffsetYTxt.setText(ri.offsetY.toString());
				
				m_frameTotalTxt.setText(ri.frameTotal.toString());
				
				m_frameRateTxt.setText(ri.fps.toString());
			}
			else
			{
				m_resourcePathTxt.setText(path);
				
				m_frameWidthTxt.setText(bmd.width.toString());
				m_frameHeightTxt.setText(bmd.height.toString());
				
				m_frameOffsetXTxt.setText("0");
				m_frameOffsetYTxt.setText("0");
				
				m_frameTotalTxt.setText("1");
				
				m_frameRateTxt.setText("30");
			}
			
			m_filename = filename;
			
			m_delBtn.setEnabled(true);
			m_applyBtn.setEnabled(true);
			m_applyAllNPCBtn.setEnabled(true);
			
			__applyClickHandler(null);
		}
	}
}