package code
{
	import dataType.TextFile;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import utils.StringHelper;

	public class CodeFileDirectory extends TextFile
	{
		[Bindable]
		public var arCodeFile:ArrayCollection;
		
		public function CodeFileDirectory(path:String=null)
		{
			super(path);
		}
		
		public var fileList:Array = [];
		public var _projectPath:String = "";
		
		public function loadAllFiles():void
		{
			if(this.exists == false || this.isDirectory == false)
				return;
			_projectPath = this.nativePath;
			getAllFilesByRecursive(this, fileList);
		}
		
		private function getAllFilesByRecursive(file:TextFile,filesList:Array):void
		{
			var childList:Array = file.getDirectoryListing();
			
			for each(var f:File in childList)
			{
				var tf:TextFile = new TextFile(f.nativePath);
				if(tf.isDirectory)
				{
					getAllFilesByRecursive(tf, filesList);
				}
				else
				{
					if(tf.extension && tf.extension.toLowerCase() == "as")
					{
						var cfm:CodeFileModel = readFileContent(tf);
						if(cfm)
							filesList.push(cfm);
					}
				}
			}
		}
		
		private function readFileContent(file:TextFile):CodeFileModel
		{
			if(file.exists == false)
				return null;
			
			var result:CodeFileModel = new CodeFileModel();
			
			file.loadText();
			
			while(file.IsLineEOF == false)
			{
				var lineModel:CodeFileLineModel = new CodeFileLineModel();
				lineModel.LineText = file.readLine();
				
				lineModel.IsNotes = checkIsNotes(lineModel.LineText);
				lineModel.IsImport = checkIsImport(lineModel.LineText);
				
				result.linesList.push(lineModel);
			}
			
			result.nativePath = file.nativePath;//原始路径
			result.relativePath = result.nativePath.replace(_projectPath,"");//项目相对路径
			result.fileName = result.nativePath.substr(result.nativePath.lastIndexOf("\\") + 1);//文件名.as
			
			return result;
		}
		
		private var _isLongNotes:Boolean = false;
		private function checkIsNotes(str:String):Boolean
		{
			var tmp:String = StringHelper.trim(str).toLocaleLowerCase();
			
			var result:Boolean = false;
			
			if(StringHelper.startWith(tmp, "/*"))
			{
				_isLongNotes = true;
				result = true;
			}
			
			if(StringHelper.endWith(tmp, "*/"))
			{
				_isLongNotes = false;
				result = true;
			}
			
			if(StringHelper.startWith(tmp, "//"))
			{
				result = true;
			}
			
			result = (_isLongNotes || result)
			
			return result;
		}
		
		private function checkIsImport(str:String):Boolean
		{
			var tmp:String = StringHelper.trim(str).toLocaleLowerCase();
			
			if(StringHelper.startWith(tmp, "import "))
				return true;
			else if(StringHelper.startWith(tmp, "using ") && StringHelper.endWith(tmp, ";"))
				return true;
			return false;
		}
		
		public function generateFindZh_CnResult():void
		{
			var array:Array = [];
			
			for each(var cfm:CodeFileModel in fileList)
			{
				for each(var cflm:CodeFileLineModel in cfm.linesList)
				{
					var cfbm:CodeFileBindModel = getCodeFileBindModel(cflm,cfm);
					if(cfbm)
						array.push(cfbm);
				}
				cfm.linesList = [];
			}
			fileList = [];
			
			arCodeFile = new ArrayCollection(array);
		}
		
		private function getCodeFileBindModel(cflm:CodeFileLineModel,cfm:CodeFileModel):CodeFileBindModel
		{
			var result:CodeFileBindModel = new CodeFileBindModel();
			
			var lineText:String = StringHelper.trim(cflm.LineText);
			
			if(cflm.IsImport || cflm.IsNotes || lineText == "")
				return null;
			
			//移除掉语句中的注释内容
			lineText = removeNotes(lineText);
			
			//检查语句中是否存在中文字符串
			if(checkZh_Cn(lineText))
			{
				result.fileName = cfm.fileName;
				result.nativePath = cfm.nativePath;
				result.relativePath = cfm.relativePath;
				result.LineNumber = cfm.linesList.indexOf(cflm) + 1;
				result.LineText = cflm.LineText;
			}
			else
			{
				return null;
			}
				
			return result;
		}
		
		private function checkZh_Cn(str:String):Boolean
		{
			var pattern:RegExp = new RegExp("\\\".*[\\\u4e00-\\\u9fa5]+.*\\\"");
			
			return pattern.test(str);
		}
		
		private function removeNotes(str:String):String
		{
			var pattern:RegExp = new RegExp("\\/\\*(.|\\W*)*?\\*\\/","ig");
			
			var result:String = str;
			var mr:Array = result.match(pattern);
			
			for each(var s:String in mr)
			{
				result = StringHelper.replace(result,s,"");
			}
			
			var hasLineNotes:Boolean = (result.indexOf("//") > -1);
			if(hasLineNotes)
				result = result.substring(0,result.indexOf("//"));
			
			return result;
		}
	}
}