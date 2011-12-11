package StinkyGameJam
{
	import flash.system.Capabilities;

	public class Utility extends Object
	{
		public static function Trace( message : String ) : void
		{
			trace( message );
		}
		
		public static function DTrace( message : String ) : void
		{
			if ( Capabilities.isDebugger )
			{
				Utility.Trace( "Debug: " + message );
			}
		}
	}
}