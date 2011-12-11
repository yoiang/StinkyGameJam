package StinkyGameJam
{
	import flash.utils.ByteArray;
	
	public class LevelChunk extends Object
	{
		protected var _width : int;
		protected var _height : int;
		
		public function LevelChunk( xml : Class )
		{
			super();
			
			loadChunk( xml );
		}
		
		public function loadChunk( xml : Class ) : void
		{
			var rawData : ByteArray = new xml;
			var dataString : String = rawData.readUTFBytes( rawData.length );
			
			var xmlData : XML = new XML( dataString );
			_width = int( xmlData.width[ 0 ] );
			_height = int( xmlData.height[ 0 ] );
			handleXmlData( xmlData );			
		}
		
		protected function handleXmlData( xml : XML ) : void
		{
		}
		
		public function get width() : int
		{
			return _width;
		}
		
		public function get height() : int
		{
			return _height;
		}
	}
}