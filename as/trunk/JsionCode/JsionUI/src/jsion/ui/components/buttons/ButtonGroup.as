package jsion.ui.components.buttons
{
	import jsion.*;
	import jsion.utils.ArrayUtil;

	public class ButtonGroup implements IDispose
	{
		protected var buttons:Array = [];
		
		protected var selection:IButtonModel = null;
		
		private var allowUncheck : Boolean;
		
		public function ButtonGroup()
		{
		}
		
		public function append(b:AbstractButton):void
		{
			if(b == null) return;
			
			buttons.push(b);
			
			if (b.selected)
			{
				if (selection == null)
				{
					selection = b.model;
				}
				else
				{
					b.selected = false;
				}
			}
			
			b.model.group = this;
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
			if(b == null) return;
			
			ArrayUtil.remove(buttons, b);
			
			if(b.model == selection)
			{
				selection = null;
			}
			
			b.model.group = null;
		}
		
		public function contains(b:AbstractButton):Boolean
		{
			return ArrayUtil.containsValue(buttons, b);
		}
		
		public function getElements():Array
		{
			return ArrayUtil.clone(buttons);
		}
		
		public function getSelection():IButtonModel
		{
			return selection;
		}
		
		public function getSelectedButton():AbstractButton
		{
			for each(var b:AbstractButton in buttons)
			{
				if(b.selected) return b;
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
				
				if (oldSelection != null) oldSelection.selected = false;
				
				m.selected = true;
			}
			else if(!b && m != null && allowUncheck)
			{
				selection = null;
			}
		}
		
		public function getButtonCount():Number
		{
			return buttons.length;
		}
		
		public function setAllowUncheck(allowUncheck : Boolean) : void
		{
			this.allowUncheck = allowUncheck;
		}
		
		public function dispose():void
		{
			
		}
	}
}