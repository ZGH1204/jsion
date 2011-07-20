package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.describeType;
	
	import utils.ArrayUtil;
	import utils.MD5;
	
	[SWF(width=1000,height=600,framerate=25)]
	public class UtilsDemo extends Sprite
	{
		public function UtilsDemo()
		{
			var reg:RegExp = new RegExp("\".*[\u4e00-\u9fa5]+.*\"","ig");
			
			var str:String = "alksdjfljasdfljaf\"哥斯达黎加哩困国\"sadfasd\"苏金水\"";
			
			var test:Boolean = reg.test(str);
			var obj:Object = reg.exec(str);
			
			trace(MD5.hash("jsion"));
			
			var array:Array = [];
			
			array.push("as");
			array.push("sdf");
			array.push(obj);
			
			var exist:Boolean = ArrayUtil.containts(array,obj);
			
			
			var xml:XML = describeType(new TestCls());
			
			trace(xml);
			
			
			var angle:int = 45;
			
			trace("角度余弦值：" + Math.cos(angle));
			trace("弧度余弦值： " + Math.cos(Number(angle / 180 * Math.PI)));
			
			var s1:MovieClip = new MovieClip();
			
			stage.addChild(s1);
			
			s1.graphics.beginFill(0xFF0000);
			s1.graphics.drawRect(0,0,100,200);
			s1.graphics.endFill();
			
			var s2:MovieClip = new MovieClip();
			s1.addChild(s2);
			
			s2.graphics.beginFill(0x0000FF);
			s2.graphics.drawRect(0,0,200,400);
			s2.graphics.endFill();
			
			s2.width = 200;
			s2.height = 400;
			
			s1.width = 100;
			s1.height = 200;
			
			trace(s1.width);
			
			//匹配注释块
			var pattern:RegExp = new RegExp("\\/\\*(.|\\W*)*?\\*\\/","ig");//(\\w*|\\W*)
			var str:String="一天快乐/**#@一<font color='#00FF00'>天快乐</font>*/asd5f46asd54f65a4sdf654asdf/*lakjsdf   l快jsad		lf54*/ //asdf63快45654654654";
			var arr:Array = str.match(pattern);
			
			trace(str, " is valid:", pattern.test(str));
			
			var pat:RegExp = new RegExp("\\\".*[\\\u4e00-\\\u9fa5]+.*\\\"");
			
			str = "   a65sd4f 65as4df5  \"<font color='#FF0000'>中国人</font>\"  sadfasdfgadf54s65f";
			
			var b:Boolean = pat.test(str)//str.match(pat);
			
			
			
			var cls:Cls3 = new Cls3("sjscan");
			cls.ID = 10;
			
			var xml:XML = describeType(cls);
			
			trace(xml.toString());
			trace(xml.toXMLString());
			xml = describeType(Cls3);
			trace(xml.toString());
			trace(xml.toXMLString());
			
			trace(Cls3.prototype.constructor as Class);
			
			var i:int = int("null");
		}
	}
	
}
