package jsion.tool
{
	import flash.events.Event;
	
	import org.aswing.Container;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.JWindow;
	import org.aswing.event.ResizedEvent;
	import org.aswing.ext.Form;
	import org.aswing.geom.IntRectangle;
	
	public class BaseFrame extends JFrame
	{
		protected var m_win:JWindow;
		
		protected var m_title:String;
		
		protected var m_content:Container;
		
		protected var box:Form;
		
		protected var bt_ok:JButton;
		protected var bt_cancle:JButton;
		
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
			box = new Form();
			m_content.append(box);
			
			box.append(new JPanel());
		}
		
		protected function buildFormButton():void
		{
			bt_ok = new JButton('确认');
			bt_ok.setPreferredWidth(80);
			bt_cancle = new JButton('取消');
			bt_cancle.setPreferredWidth(80);
			
			bt_cancle.addActionListener(onCancle);
			bt_ok.addActionListener(onSubmit);
			
			var jpanle:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 16, 5));
			jpanle.appendAll(bt_ok, bt_cancle);
			box.append(jpanle);
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
			
			if(m_content)
			{
				m_content.removeEventListener(ResizedEvent.RESIZED, __contentResizeHandler);
			}
			m_content = null;
			
			super.dispose();
		}
	}
}