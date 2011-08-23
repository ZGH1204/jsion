package jui.org
{
	import jui.org.errors.ImpMissError;

	public class ResourceProvider implements IDispose
	{
		public function getDefaults():UIDefaults
		{
			throw new ImpMissError();
			return null;
		}
		
		public function dispose():void
		{
			
		}
	}
}