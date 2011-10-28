package editor.forms.movieparts
{
	import editor.forms.MovieEditorForm;
	
	import org.aswing.JPanel;
	import org.aswing.border.TitledBorder;

	public class RendererForm extends JPanel
	{
		protected var movieEditorForm:MovieEditorForm;
		
		public function RendererForm(form:MovieEditorForm, w:int, h:int)
		{
			movieEditorForm = form;
			
			super();
			
			initialize();
			
			setBorder(new TitledBorder(null, '序列图配置信息', TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			setPreferredWidth(w);
			setPreferredHeight(h);
		}
		
		protected function initialize():void
		{
		}
	}
}