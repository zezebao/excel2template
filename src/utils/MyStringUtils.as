package utils
{
	import flash.filesystem.File;

	public class MyStringUtils
	{
		
		public static function removeNewLine(str:String):String
		{
			var result:String = str;
			
			while(result.indexOf("\n") != -1)
			{
				result = result.replace("\n",";");
			}
			
			return result;
		}
	}
}