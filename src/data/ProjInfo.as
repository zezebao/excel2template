package data
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	
	import mx.utils.StringUtil;

	/**
	 * 项目配置数据 
	 * @author Administrator
	 * 
	 */	
	public class ProjInfo
	{
		private var _projFilePath:String; //项目配置文件路径
		
		/**项目名字*/
		public var projName:String = "";
		/**是否输出class类文件*/
		private var _isExportClass:Boolean = true;
		private var _isZlib:Boolean = true; //是否zlib压缩
		private var _outType:int = 0; //输出类型
		
		private var _sourcePath:String = ""; //excel源文件路径
		private var _outPath1:String = ""; //类文件输出路径
		private var _outPath2:String = ""; //数据文件输出路径
				
		public function ProjInfo(projName_:String)
		{
			this.projName = projName_;
			_projFilePath = File.applicationDirectory.nativePath + "/projs/" + projName + ".conf";
			
			load();
		}
		
		public function get projFilePath():String
		{
			return _projFilePath;
		}

		/**是否输出类文件*/
		public function get isExportClass():Boolean
		{
			return _isExportClass;
		}

		/**
		 * @private
		 */
		public function set isExportClass(value:Boolean):void
		{
			_isExportClass = value;
			save();
		}

		/**是否zlib压缩*/
		public function get isZlib():Boolean
		{
			return _isZlib;
		}

		/**
		 * @private
		 */
		public function set isZlib(value:Boolean):void
		{
			_isZlib = value;
			save();
		}

		/**输出类型*/
		public function get outType():int
		{
			return _outType;
		}

		/**
		 * @private
		 */
		public function set outType(value:int):void
		{
			_outType = value;
			save();
		}

		/**源目录文件*/
		public function get sourcePath():String
		{
			return _sourcePath;
		}

		/**
		 * @private
		 */
		public function set sourcePath(value:String):void
		{
			_sourcePath = value;
			save();
		}

		/**输出类文件目录*/
		public function get outPath1():String
		{
			return _outPath1;
		}

		/**
		 * @private
		 */
		public function set outPath1(value:String):void
		{
			_outPath1 = value;
			save();
		}

		/**输出数据文件目录*/
		public function get outPath2():String
		{
			return _outPath2;
		}

		/**
		 * @private
		 */
		public function set outPath2(value:String):void
		{
			_outPath2 = value;
			save();
		}

		/**
		 * 从文件加载数据，初始化调用
		 */		
		public function load():void
		{
			var file:File = new File(_projFilePath);
			if(file.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var content:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				
				var obj:Object = JSON.parse(content);
				isExportClass = obj.isExportClass;
				isZlib = obj.isZlib;
				outType = obj.outType;
				sourcePath = obj.sourcePath;
				outPath1 = obj.outPath1;
				outPath2 = obj.outPath2;
			}else
			{
				save();
			}
		}
		
		/**
		 * 保存数据，数据改变，应调用保存来维护数据 
		 */		
		public function save():void
		{
			var obj:Object = {};
			obj.isExportClass  = isExportClass
			obj.isZlib  = isZlib;
			obj.outType  = outType;
			obj.sourcePath  = sourcePath;
			obj.outPath1  = outPath1;
			obj.outPath2  = outPath2;
			var content:String = JSON.stringify(obj);
			
			var file:File = new File(_projFilePath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(content);
			fs.close();
			
			updateConfig();
		}
		
		/**
		 * 更新配置文件，兼容以前的代码 
		 */		
		public function updateConfig():void
		{
			Config.IS_EXPORT_CLASS = isExportClass;
			Config.IS_ZLIB = isZlib;
			Config.OUT_TYPE = outType;
			Config.TEMPLATE_PATH = sourcePath;
			Config.TEMPLATE_CLASS_PATH = outPath1;
			Config.TEMPLATE_BINARY_PATH = outPath2;
		}
	}
}