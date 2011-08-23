package jui.org.errors
{
	public class ImpMissError extends Error
	{
		public function ImpMissError()
		{
			super("Subclass should override this method to do implementation!!");
		}
	}
}