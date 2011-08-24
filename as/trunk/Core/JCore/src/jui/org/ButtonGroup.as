package jui.org
{
	import jui.org.coms.buttons.AbstractButton;
	
	import jutils.org.util.ArrayUtil;

	public class ButtonGroup
	{
		// the list of buttons participating in this group
		protected var buttons:Array;
		
		private var allowUncheck : Boolean;
		
		private var selection:IButtonModel = null;
		
		public function ButtonGroup()
		{
			buttons = [];
		}
		
		public static function groupButtons(...buttons):ButtonGroup
		{
			var g:ButtonGroup = new ButtonGroup();
			
			for each(var i:AbstractButton in buttons)
			{
				g.append(i);
			}
			
			return g;
		}
		
		public function append(b:AbstractButton):void
		{
			if(b == null)
			{
				return;
			}
			
			buttons.push(b);
			
			if (b.isSelected())
			{
				if (selection == null)
				{
					selection = b.getModel();
				}
				else
				{
					b.setSelected(false);
				}
			}
			
			b.getModel().setGroup(this);
		}
		
		public function appendAll(...buttons):void
		{
			for each(var i:AbstractButton in buttons)
			{
				append(i);
			}
		}
		
		public function remove(b:AbstractButton):void
		{
			if(b == null)
			{
				return;
			}
			
			ArrayUtil.remove(buttons, b);
			
			if(b.getModel() == selection)
			{
				selection = null;
			}
			
			b.getModel().setGroup(null);
		}
		
		public function contains(b:AbstractButton):Boolean
		{
			for(var i:Number=0; i<buttons.length; i++)
			{
				if(buttons[i] == b)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getElements():Array
		{
			return ArrayUtil.clone(buttons);
		}
		
		public function getSelection():IButtonModel
		{
			return selection;
		}
		
		public function getSelectedIndex():int
		{
			for (var i : int = 0; i < buttons.length; i++) 
			{
				if(AbstractButton(buttons[i]).isSelected())
					return i;
			}
			
			return -1;
		}
		
		public function getSelectedButton():AbstractButton
		{
			for each(var b:AbstractButton in buttons)
			{
				if(b.isSelected())
				{
					return b;
				}
			}
			
			return null;
		}
		
		public function isSelected(m:IButtonModel):Boolean
		{
			return (m == selection);
		}
		
		public function setSelected(m:IButtonModel, b:Boolean):void
		{
			if (b && m != null && m != selection)
			{
				var oldSelection:IButtonModel = selection;
				
				selection = m;
				
				if (oldSelection != null)
				{
					oldSelection.setSelected(false);
				}
				
				m.setSelected(true);
			}
			else if(!b && m != null && allowUncheck)
			{
				selection = null;
				//m.setSelected(false);
			}
		}
	}
}