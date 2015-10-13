package export
{
	import com.childoftv.xlsxreader.Worksheet;
	import com.childoftv.xlsxreader.XLSXLoader;
	
	import data.Config;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import utils.DateUtil;
	import utils.MyLog;

	public class Export
	{
		protected var excel_loader:XLSXLoader=new XLSXLoader();
		protected var _file:File;
		
		/**文件名字*/		
		protected var _fileName:String;
		/**文件名小写*/
		protected var _fileNameLower:String;
		/**服务器表名*/
		protected var _tabelName:String;
		/**列标记*/		
		protected const COLS:Array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
		
		public function Export(path:String)
		{
			_file = new File(path);
			if(!_file.exists)
			{
				MyLog.RecordError("路径不存在：" + path);
				return;
			}
			_fileName = _file.name.replace("Template.xlsx","");
			_fileNameLower = _fileName.toLocaleLowerCase();
			_tabelName = "template_" + _fileNameLower;
			
			excel_loader.addEventListener(Event.COMPLETE,loadingComplete);
			var fs:FileStream = new FileStream();
			fs.open(_file,FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes,0,fs.bytesAvailable);
			fs.close();
			excel_loader.loadFromByteArray(bytes);
		}
		
		private function loadingComplete(e:Event):void
		{
			var sheet_1:Worksheet=excel_loader.worksheet("Sheet1");
			if(sheet_1 != null)export(sheet_1);
		}
		
		protected function export(sheet:Worksheet):void
		{
			if(!check(sheet))return;
			saveBinary(sheet);
			if(Config.IS_EXPORT_CLASS)
			{
				saveClass(sheet);
			}
			saveSQL(sheet);
			MyLog.Record(_fileName + "发布成功," + DateUtil.getDateString(new Date()));
		}
		
		/**
		 * 保存二进制文件 
		 */
		protected function saveBinary(sheet:Worksheet):void
		{
			var bytes:ByteArray = new ByteArray();
			
			var start:int = 5;
			var arr2:XMLList = sheet.getRows("B",start);
			var rowList:Vector.<int> = new Vector.<int>();
			var i:int = 0;
			for (i = 0; i < arr2.length(); i++) 
			{
				if(String(arr2[i]) == "")
					continue;
				var row:int = parseInt(String(arr2[i].@r).substr(1));
				rowList.push(row);
			}
			
			bytes.writeInt(rowList.length);
			for (i = 0; i < rowList.length; i++) 
			{
				for (var j:int = 1; j < COLS.length; j++) 
				{
					var value:String = sheet.getCellValue(COLS[j] + rowList[i]);
					var id:String = sheet.getCellValue(COLS[j] + "2");
					var excelTypeStr:String = sheet.getCellValue(COLS[j] + "3");
					
					if(id == "")break;
					switch(excelTypeStr)
					{
						case "byte":
							bytes.writeByte(parseInt(value));
							break;
						case "short":
							bytes.writeShort(parseInt(value));
							break;
						case "int":
							bytes.writeInt(parseInt(value));
							break;
						case "long":
							bytes.writeInt(parseInt(value));
							break;
						case "float":
							bytes.writeFloat(parseFloat(value));
							break;
						case "boolean":
							bytes.writeBoolean((value == "true" || value == "1"));
							break;
						case "string":
						case "array":
						case "intArray":
							//							bytes.writeUTFBytes(value); //这个方法，目前c#还没有写对应的解析，暂时没有发现问题
							bytes.writeUTF(value);
							break;
					}
				}
			}
			
			var newFile:File = new File(Config.TEMPLATE_BINARY_PATH + "/" + _fileName + ".bytes");
			var newFs:FileStream = new FileStream();
			newFs.open(newFile,FileMode.WRITE);
			newFs.writeInt(bytes.length);
			if(Config.IS_ZLIB)
			{
				bytes.compress();
			}
			newFs.writeBytes(bytes);
			newFs.close();
		}
		
		/**
		 * 保存类模板 
		 * @param sheet
		 */		
		protected function saveClass(sheet:Worksheet):void
		{
			
		}
		
		/**
		 * 保存SQL模板 
		 * @param sheet
		 */		
		protected function saveSQL(sheet:Worksheet):void
		{
			
		}
		
		/**
		 * 检查数据有效性 
		 * @param sheet
		 * @return 
		 */		
		protected function check(sheet:Worksheet):Boolean
		{
			var i:int = 0;
			//判断有没有字段没有定义
			for (i = 1; i < COLS.length; i++) 
			{
				var value:String = sheet.getCellValue(COLS[i] + "2");
				var excelTypeStr:String = sheet.getCellValue(COLS[i] + "3");
				
				if(value != "")
				{
					if(excelTypeStr == "")
					{
						MyLog.Record(_fileName + "文件里面的字段" + value + "没有定义类型");
						return false;
					}
				}
			}
			//判断是否有无效值
			var start:int = 5;
			var arr2:XMLList = sheet.getRows("B",start);
			var rowList:Vector.<int> = new Vector.<int>(); //存储当前拥有合法ID的行数
			var tmpList:Vector.<int> = new Vector.<int>(); //用来判断是否有重复ID
			for (i = 0; i < arr2.length(); i++) 
			{
				if(String(arr2[i]) == "")
					continue;
				var row:int = parseInt(String(arr2[i].@r).substr(1));
				var id:int = parseInt(arr2[i].children()[0]);
				rowList.push(row);
				if(tmpList.indexOf(id) != -1)
				{
					MyLog.RecordError(_fileName + "有重复id：" + id);
					return false;
				}
				tmpList.push(id);
			}
			for (i = 0; i < rowList.length; i++) 
			{
				for (var j:int = 1; j < COLS.length; j++) 
				{
					var value:String = sheet.getCellValue(COLS[j] + rowList[i]);
					var typeStr:String = sheet.getCellValue(COLS[j] + "3");
					if(typeStr == "")break;
					if(value == "" && !isStringType(typeStr))
					{
						MyLog.RecordError(_fileName + "有未填写的内容,id：" + id + "，行列：" + COLS[j] + rowList[i]);
						return false;
					}
				}
			}
			return true;
		}
		
		private function isStringType(typeStr:String):Boolean
		{
			return typeStr == "string" || typeStr == "intArray" || typeStr == "array";
		}
	}
}