package editor.forms.movieparts
{
	import editor.forms.MovieEditorForm;
	
	import org.aswing.FlowLayout;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.aswing.border.TitledBorder;
	import org.aswing.ext.Form;
	
	public class MovieInfoForm extends Form
	{
		protected var m_resourcePathTxt:JTextField;
		
		protected var m_frameWidthTxt:JTextField;
		
		protected var m_frameHeightTxt:JTextField;
		
		protected var m_frameOffsetXTxt:JTextField;
		
		protected var m_frameOffsetYTxt:JTextField;
		
		protected var m_frameTotalTxt:JTextField;
		
		public function MovieInfoForm(form:MovieEditorForm)
		{
			super();
			
			initialize();
			
			setBorder(new TitledBorder(null, '序列图配置信息', TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
		protected function initialize():void
		{
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 0));
			
			m_resourcePathTxt = new JTextField("", 24);
			jpanle.append(new JLabel("资源路径： "));
			jpanle.append(m_resourcePathTxt);
			append(jpanle);
			
			m_frameWidthTxt = new JTextField("0", 8);
			
			m_frameHeightTxt = new JTextField("0", 8);
			addRow(new JLabel("每帧宽度："), m_frameWidthTxt, new JLabel("每帧高度："), m_frameHeightTxt);
			
			m_frameOffsetXTxt = new JTextField("0", 8);
			
			m_frameOffsetYTxt = new JTextField("0", 8);
			addRow(new JLabel("横轴偏移："), m_frameOffsetXTxt, new JLabel("纵轴偏移："), m_frameOffsetYTxt);
			
			jpanle = new JPanel(new FlowLayout(FlowLayout.LEFT, 0));
			m_frameTotalTxt = new JTextField("1", 24);
			jpanle.append(new JLabel("帧总数量： "));
			jpanle.append(m_frameTotalTxt);
			append(jpanle);
		}
	}
}