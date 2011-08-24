package jui.org
{
	public interface IButtonModel
	{
		function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeStateListener(listener:Function):void;
		
		function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeActionListener(listener:Function):void;
		
		function addSelectionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeSelectionListener(listener:Function):void;
		
		function isEnabled():Boolean;
		
		function isRollOver():Boolean;
		
		function isArmed():Boolean;
		
		function isPressed():Boolean;
		
		function isSelected():Boolean;
		
		function setEnabled(b:Boolean):void;
		
		function setRollOver(b:Boolean):void;
		
		function setArmed(b:Boolean):void;
		
		function setPressed(b:Boolean):void;
		
		function setSelected(b:Boolean):void;
		
		function getGroup():ButtonGroup;
		
		function setGroup(group:ButtonGroup):void;	
	}
}