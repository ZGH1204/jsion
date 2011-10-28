package editor.forms
{
	import editor.forms.movieparts.MovieInfoForm;
	import editor.forms.movieparts.RendererForm;
	import editor.rightviews.ResourcePreviewer;
	import editor.rightviews.ResourceTabbed;
	
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	import org.aswing.ext.Form;

	public class MovieEditorForm extends BaseEditorForm
	{
		protected var c:Container;
		
		protected var leftContainer:JPanel;
		
		protected var mainContainer:JPanel;
		
		protected var previewer:ResourcePreviewer;
		
		protected var resourceTabbed:ResourceTabbed;
		
		protected var movieInfoForm:MovieInfoForm;
		
		protected var rendererForm:RendererForm;
		
		public function MovieEditorForm(owner:JsionMapEditor)
		{
			mytitle = "序列图配置器";
			WinWidth = 680;
			WinHeight = 470;
			super(owner, true);
		}
		
		override protected function init():void
		{
			c = new Container();
			c.setOpaque(true);
			c.setLayout(new BorderLayout(2, 2));
			
			setResizable(false);
			
			c.setSizeWH(WinWidth, WinHeight);
			
			
			var w:Number = c.width;// + Padding * 2;
			var h:Number = c.height;// + Padding * 2;
			
			setLocationXY((mapEditor.Window.width - w) / 2, (mapEditor.Window.height - h) / 2);
			
			setSizeWH(w, h);
			
			getContentPane().append(c);
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			leftContainer = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, Padding));
			leftContainer.setPreferredWidth(170);
			c.append(leftContainer, BorderLayout.WEST);
			
			
			mainContainer = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, Padding));
			c.append(mainContainer, BorderLayout.CENTER);
			
			
			
			previewer = new ResourcePreviewer(170);
			leftContainer.append(previewer);
			
			resourceTabbed = new ResourceTabbed(mapEditor, previewer);
			leftContainer.append(resourceTabbed);
			
			
			
			
			
			
			
			
			
			
			
			
			rendererForm = new RendererForm(this, 380, 288);
			mainContainer.append(rendererForm);
			
			movieInfoForm = new MovieInfoForm(this);
			mainContainer.append(movieInfoForm);
		}
	}
}