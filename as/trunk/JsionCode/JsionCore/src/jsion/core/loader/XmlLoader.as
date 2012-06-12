package jsion.core.loader
{
	public class XmlLoader extends TextLoader
	{
		public function XmlLoader(file:String, root:String="", managed:Boolean=true)
		{
			super(file, root, managed);
		}
		
		override protected function onCompleted():void
		{
			m_data = new XML(m_urlLoader.data);
			
			super.onCompleted();
		}
	}
}