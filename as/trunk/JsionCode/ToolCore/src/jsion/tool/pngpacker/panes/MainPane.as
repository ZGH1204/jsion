package jsion.tool.pngpacker.panes
{
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	
	public class MainPane extends Container
	{
		protected var m_bottomPanel:BottomPane;
		protected var m_renderPanel:RenderPane;
		
		public function MainPane(renderPane:RenderPane, bottomPane:BottomPane)
		{
			m_renderPanel = renderPane;
			m_bottomPanel = bottomPane;
			
			super();
			
			setLayout(new BorderLayout(1,1));
			
			append(m_bottomPanel, BorderLayout.SOUTH);
			
			append(m_renderPanel, BorderLayout.CENTER);
		}
	}
}