package editor.forms.movieparts
{
	import editor.aswings.PreviewBackground;
	import editor.forms.MovieEditorForm;
	import editor.forms.renders.Render;
	import editor.forms.renders.RenderInfo;
	import editor.forms.renders.Renderer;
	
	import flash.geom.Rectangle;
	
	import org.aswing.JPanel;
	import org.aswing.border.TitledBorder;
	import org.aswing.geom.IntDimension;

	public class RendererForm extends JPanel
	{
		protected var movieEditorForm:MovieEditorForm;
		
		protected var m_renderer:Renderer;
		
		protected var m_render:Render;
		
		protected var m_fWidth:int;
		
		protected var m_fHeight:int;
		
		public function RendererForm(form:MovieEditorForm, w:int, h:int)
		{
			movieEditorForm = form;
			
			super();
			
			setBorder(new TitledBorder(null, '序列图配置信息', TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_fWidth = w;
			m_fHeight = h;
			
			setPreferredWidth(w);
			setPreferredHeight(h);
			
			initialize();
		}
		
		protected function initialize():void
		{
			var insideSize:org.aswing.geom.IntDimension = getInsets().getInsideSize();
			
			m_renderer = new Renderer(m_fWidth - getInsets().left - getInsets().right, m_fHeight - getInsets().top - getInsets().bottom - 1);
			
			m_render = new Render();
			
			m_renderer.addRender(m_render);
			
			setBackgroundDecorator(new PreviewBackground(m_renderer));
		}
		
		public function setRenderInfo(renderInfo:RenderInfo):void
		{
			m_render.renderInfo = renderInfo;
		}
	}
}