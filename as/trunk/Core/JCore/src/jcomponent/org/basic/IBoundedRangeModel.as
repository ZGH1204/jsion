package jcomponent.org.basic
{
	public interface IBoundedRangeModel
	{
		function getMinimum():int;
		
		function setMinimum(value:int):void;
		
		function getMaximum():int;
		
		function setMaximum(value:int):void;
		
		function getValue():Number;
		
		function setValue(value:Number):void;
		
		function addStateListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false):void;
		
		function removeStateListener(listener:Function):void;
	}
}