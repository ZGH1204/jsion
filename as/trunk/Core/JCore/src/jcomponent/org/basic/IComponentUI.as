package jcomponent.org.basic
{
	public interface IComponentUI
	{
		function install(component:Component):void;
		
		function uninstall(component:Component):void;
		
		function update(component:Component):void;
	}
}