package jui.org
{
	public interface IDefaultsProvider
	{
		function getDefaultsOwner(component:Component):IComponentUI;
		
		function setDefaultsOwner(owner:IComponentUI):void;
	}
}