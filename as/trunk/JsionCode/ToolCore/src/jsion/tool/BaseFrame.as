package jsion.tool
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	import org.aswing.Container;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.JWindow;
	import org.aswing.event.ResizedEvent;
	import org.aswing.ext.Form;
	import org.aswing.geom.IntRectangle;
	
	public class BaseFrame extends JFrame implements IDispose
	{
		protected var m_win:JWindow;
		
		protected var m_title:String;
		
		protected var m_content:Container;
		
		protected var m_box:Form;
		
		protected var m_okBtn:JButton;
		
		protected var m_cancleBtn:JButton;
		
		public function BaseFrame(owner:* = null, modal:Boolean = false)
		{
			m_win = owner as JWindow;
			
			super(owner, m_title, modal);
			
			getTitleBar().getIconifiedButton().setEnabled(false);
			
			addEventListener(ResizedEvent.RESIZED, __resizeHandler);
			
			m_content = getContentPane();
			m_content.addEventListener(ResizedEvent.RESIZED, __contentResizeHandler);
		}
		
		private function __resizeHandler(e:ResizedEvent):void
		{
			if(state != MAXIMIZED)
			{
				setLocationXY((m_win.width - width) / 2, (m_win.height - height) / 2);
			}
		}
		
		private function __contentResizeHandler(e:ResizedEvent):void
		{
			onContentResized(m_content.width, m_content.height);
		}
		
		protected function onContentResized(w:int, h:int):void
		{
		}
		
		protected function buildForm():void
		{
			m_box = new Form();
			m_content.append(m_box);
			
			m_box.append(new JPanel());
		}
		
		protected function buildFormButton():void
		{
			m_okBtn = new JButton('确认');
			m_okBtn.setPreferredWidth(80);
			m_cancleBtn = new JButton('取消');
			m_cancleBtn.setPreferredWidth(80);
			
			m_okBtn.addActionListener(onSubmit);
			m_cancleBtn.addActionListener(onCancle);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, 5));
			jpanle.appendAll(m_okBtn, m_cancleBtn);
			m_box.append(jpanle);
		}
		
		protected function onCancle(e:Event):void
		{
			closeReleased();
		}
		
		protected function onSubmit(e:Event):void
		{
			closeReleased();
		}
		
		override public function getMaximizedBounds():IntRectangle
		{
			var r:IntRectangle = super.getMaximizedBounds();
			
			r.x += 1;
			r.width -= 1;
			r.y = 18;
			r.height -= r.y;
			
			return r;
		}
		
		override public function dispose():void
		{
			removeEventListener(ResizedEvent.RESIZED, __resizeHandler);
			
			if(m_okBtn) m_okBtn.removeActionListener(onSubmit);
			
			if(m_cancleBtn) m_cancleBtn.removeActionListener(onCancle);
			
			if(m_content) m_content.removeEventListener(ResizedEvent.RESIZED, __contentResizeHandler);
			
			m_okBtn = null;
			
			m_cancleBtn = null;
			
			m_box = null;
			
			m_content = null;
			
			m_win = null;
			
			super.dispose();
		}
	}
}