package render.core.copies.ext
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import render.core.copies.BaseGame;
	import render.core.copies.GameObject;
	import render.core.copies.Render;

	public class TestGame extends BaseGame
	{
		[Embed("/assets/00000.png")]
		private var m_bmd0:Class;
		
		[Embed("/assets/00001.png")]
		private var m_bmd1:Class;
		
		[Embed("/assets/00002.png")]
		private var m_bmd2:Class;
		
		[Embed("/assets/00003.png")]
		private var m_bmd3:Class;
		
		[Embed("/assets/00004.png")]
		private var m_bmd4:Class;
		
		[Embed("/assets/00005.png")]
		private var m_bmd5:Class;
		
		[Embed("/assets/00006.png")]
		private var m_bmd6:Class;
		
		[Embed("/assets/00007.png")]
		private var m_bmd7:Class;
		
		[Embed("/assets/00008.png")]
		private var m_bmd8:Class;
		
		private var m_render:Render;
		
		private var m_render2:Render;
		
		private var m_list:Array;
		
		public function TestGame()
		{
			super(1250, 650);
			
			m_render = new TestRender();
			
			m_render2 = new TestRender2();
			
			m_list = [];
			
			m_list.push(Bitmap(new m_bmd0()).bitmapData);
			m_list.push(Bitmap(new m_bmd1()).bitmapData);
			m_list.push(Bitmap(new m_bmd2()).bitmapData);
			m_list.push(Bitmap(new m_bmd3()).bitmapData);
			m_list.push(Bitmap(new m_bmd4()).bitmapData);
			m_list.push(Bitmap(new m_bmd5()).bitmapData);
			m_list.push(Bitmap(new m_bmd6()).bitmapData);
			m_list.push(Bitmap(new m_bmd7()).bitmapData);
			m_list.push(Bitmap(new m_bmd8()).bitmapData);
		}
		
		public function create():void
		{
			var obj:GameObject = new GameObject();
			
			obj.renderObj = m_render;
			obj.bmdList = m_list;
			
			obj.pos.x = int(Math.random() * 1000);
			obj.pos.y = int(Math.random() * 550);
			
			obj.renderRect.width = BitmapData(m_list[0]).width;
			obj.renderRect.height = BitmapData(m_list[0]).height;
			
			obj.fps = int(Math.random() * 6);
			
			addObject(obj);
		}
		
		public function create2(sprite:Sprite):void
		{
			var obj:GameObject = new GameObject();
			
			obj.bmp = new Bitmap();
			sprite.addChild(obj.bmp);
			
			obj.renderObj = m_render2;
			obj.bmdList = m_list;
			
			obj.bmp.x = int(Math.random() * 1000);
			obj.bmp.y = int(Math.random() * 550);
			
			obj.fps = int(Math.random() * 6);
			
			addObject(obj);
		}
	}
}