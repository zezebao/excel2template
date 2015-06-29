package data
{
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayList;

	public class Config
	{
		public static const TYPE_CPP:int = 0;
		public static const TYPE_CS:int = 1;
		public static const TYPE_LUA:int = 2;
		public static const TYPE_AS:int = 3;
		
		public static var IS_EXPORT_CLASS:Boolean = true;
		public static var IS_ZLIB:Boolean = true;
		public static var OUT_TYPE:int = 0;
		
		public static var OUT_DATA:ArrayList;
		
		//--模版标签
		public static const START_TAG:String = "//startBuild"; //开始标签
		public static const END_TAG:String = "//endBuild"; //结束标签
		public static const LUA_START_TAG:String = "--startBuild"; //开始标签
		public static const LUA_END_TAG:String = "--endBuild"; //结束标签
		
		public static const RP_DES:String = "{@des}"; //描述标签
		public static const RP_TEMPLATE_NAME:String = "{@templateName}"; //模版表名
		public static const RP_TEMPLATE_NAME_FIRST_LOWER:String = "{@templateName_first_lower}"; //首字母小写
		public static const RP_ID:String = "{@id}"; //id字段名
		public static const RP_VAR:String = "{@startVar}"; //变量开始标记
		public static const RP_PARSE:String = "{@startParse}"; //解析开始标记
		
		
		public static const RE_DES:RegExp = /{@des}/g; //描述标签
		public static const RE_TEMPLATE_NAME:RegExp = /{@templateName}/g; //模版表名
		public static const RE_TEMPLATE_NAME_FIRST_LOWER:RegExp = /{@templateName_first_lower}/g; //首字母小写
		public static const RE_ID:RegExp = /{@id}/g; //id字段名
		public static const RE_VAR:RegExp = /{@startVar}/g; //变量开始标记
		public static const RE_PARSE:RegExp = /{@startParse}/g; //解析开始标记
		
		//---模版
		public static const TEMPPATH_CS:String = "templates/C#.temp"; //c#模版
		public static const TEMPPATH_CPP_H:String = "templates/Cpp_h.temp"; //c#模版
		public static const TEMPPATH_CPP:String = "templates/Cpp.temp"; //c#模版
		public static const TEMPPATH_LUA:String = "templates/Lua.temp"; //c#模版
		
		/**
		 * 输出模版表数据的位置 
		 */		
		public static var TEMPLATE_PATH:String = "";
		/**
		 * 输出模版表类的位置 
		 */		
		public static var TEMPLATE_CLASS_PATH:String = "";
		/**
		 * 输出二进制数据位置 
		 */		
		public static var TEMPLATE_BINARY_PATH:String = "";
		
		
		private static var _so:SharedObject;
		
		public static function setup():void
		{
			var arr:ArrayList = new ArrayList();
			arr.addItem({"label":"C++","value":TYPE_CPP});
			arr.addItem({"label":"C#","value":TYPE_CS});
			arr.addItem({"label":"Lua","value":TYPE_LUA});
			arr.addItem({"label":"AS3","value":TYPE_AS});
			OUT_DATA = arr;
			
			_so = SharedObject.getLocal("excel2temp__003_");
			if(_so.data.hasSave)
			{
				TEMPLATE_CLASS_PATH = _so.data.classPath;
				TEMPLATE_PATH = _so.data.path;
				TEMPLATE_BINARY_PATH = _so.data.binaryPath;
				
				IS_EXPORT_CLASS = _so.data.isExportClass;
				IS_ZLIB = _so.data.isZlib;
				OUT_TYPE = _so.data.outType;
			}else
			{
				TEMPLATE_CLASS_PATH = File.applicationDirectory.nativePath;
				TEMPLATE_PATH = File.applicationDirectory.nativePath;
				TEMPLATE_BINARY_PATH = File.applicationDirectory.nativePath;
			}
		}
		
		public static function savePath():void
		{
			_so.data.hasSave = true
			_so.data.classPath = TEMPLATE_CLASS_PATH;
			_so.data.path = TEMPLATE_PATH;
			_so.data.binaryPath = TEMPLATE_BINARY_PATH;
			_so.data.outType = OUT_TYPE;
			
			_so.data.isExportClass = IS_EXPORT_CLASS;
			_so.data.isZlib = IS_ZLIB;
			
			_so.flush();
		}
		
	}
}