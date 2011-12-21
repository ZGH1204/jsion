package jsion.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;

	public class CompResources implements IDispose
	{
		private var m_pool:HashMap;
		private var m_freeBMD:HashMap;
		
		public function CompResources()
		{
			m_pool = new HashMap();
			m_freeBMD = new HashMap();
		}
		
		public function setStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_pool.put(key, value);
			m_freeBMD.put(key, freeBMD);
		}
		
		public function getBoolean(key:String):Boolean
		{
			return m_pool.get(key) as Boolean;
		}
		
		public function getNumber(key:String):Number
		{
			if(m_pool.containsKey(key))
				return m_pool.get(key) as Number;
			
			return 0;
		}
		
		public function getInt(key:String):int
		{
			return m_pool.get(key) as int;
		}
		
		public function getUint(key:String):uint
		{
			return m_pool.get(key) as uint;
		}
		
		public function getString(key:String):String
		{
			return m_pool.get(key) as String;
		}
		
		public function getArray(key:String):Array
		{
			return m_pool.get(key) as Array;
		}
		
		public function getFont(key:String):ASFont
		{
			return m_pool.get(key) as ASFont;
		}
		
		public function getColor(key:String):ASColor
		{
			return m_pool.get(key) as ASColor;
		}
		
		public function getDisplayObject(key:String):DisplayObject
		{
			if(m_pool.containsKey(key))
			{
				var tmp:Object = m_pool.get(key);
				
				if(tmp is BitmapData)
				{
					var bmp:Bitmap = new Bitmap(tmp as BitmapData);
					
					m_pool.put(key, bmp);
					
					return bmp;
				}
				
				return tmp as DisplayObject;
			}
			
			return null;
		}
		
		public function dispose():void
		{
			if(m_pool)
			{
				var kList:Array = m_pool.getKeys();
				var vList:Array = m_pool.getValues();
				
				m_pool.removeAll();
				
				for(var i:int = 0; i < vList.length; i++)
				{
					DisposeUtil.free(vList[i], m_freeBMD.get(kList[i]) as Boolean);
				}
				
				DisposeUtil.free(m_pool);
				m_pool = null;
				
				DisposeUtil.free(m_freeBMD);
				m_freeBMD = null;
			}
		}
	}
}