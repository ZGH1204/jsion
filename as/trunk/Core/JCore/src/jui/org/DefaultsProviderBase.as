package jui.org
{
	
	public class DefaultsProviderBase implements IDefaultsProvider
	{
		protected var defaultsOwner:IComponentUI;
		
		public function DefaultsProviderBase()
		{
		}
		
		public function getDefaultsOwner(component:Component):IComponentUI
		{
			if(defaultsOwner)
			{
				return defaultsOwner;
			}
			else
			{
				return component.getUI();
			}
		}
		
		public function setDefaultsOwner(owner:IComponentUI):void
		{
			defaultsOwner = owner;
		}
	}
}