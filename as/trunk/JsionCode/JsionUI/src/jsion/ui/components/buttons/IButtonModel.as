package jsion.ui.components.buttons
{
	public interface IButtonModel
	{
		function get enabled():Boolean;
		
		function set enabled(value:Boolean):void;
		
		function get rollOver():Boolean;
		
		function set rollOver(value:Boolean):void;
		
		function get armed():Boolean;
		
		function set armed(value:Boolean):void;
		
		function get pressed():Boolean;
		
		function set pressed(value:Boolean):void;
		
		function get selected():Boolean;
		
		function set selected(value:Boolean):void;
		
		function get group():ButtonGroup;
		
		function set group(value:ButtonGroup):void;
		
		function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeActionListener(listener:Function):void;
		
		function addSelectionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeSelectionListener(listener:Function):void;
		
		function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeStateListener(listener:Function):void;
	}
}