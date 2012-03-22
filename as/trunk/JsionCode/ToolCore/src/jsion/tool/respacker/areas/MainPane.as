package jsion.tool.respacker.areas
{
	import jsion.IDispose;
	
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	
	public class MainPane extends Container implements IDispose
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
		
		public function dispose():void
		{
		}
	}
}