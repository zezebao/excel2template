package utils
{
	import flash.filesystem.File;
	import flash.net.dns.AAAARecord;
	
	import spark.components.TextArea;

	public class MyLog
	{
		public static var textarea:TextArea;
		
		private static var _index:int;
		private static var _logs:Vector.<String> = new Vector.<String>();
		
		public static function Save():void
		{
			if(_logs.length <= 0)return;
			
//			var file:File = new File(
			for (var i:int = 0; i < _logs.length; i++) 
			{
				
			}
			
			_logs = new Vector.<String>();
		}
		
		public static function Record(content:String,...args):void
		{
			_index ++;
			content = _index + ".[log]:" + content;
			if(args.length > 0)
			{
				for (var i:int = 0; i < args.length; i++) 
				{
					content += "," + args[i];
				}
			}
			trace(content);
			textarea.appendText(content + "\n");
		}
		
		public static function RecordError(content:String,...args):void
		{
			_index ++;
			content = _index + ".[error]:" + content;
			if(args.length > 0)
			{
				for (var i:int = 0; i < args.length; i++) 
				{
					content += "," + args[i];
				}
			}
			trace(content);
			textarea.appendText(content + "\n");
		}
	}
}