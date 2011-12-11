package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	public class LevelBackgroundChunk extends LevelChunk
	{
		protected var _tiles : Tilemap;
		
		[ Embed( source = 'resources/level/tileSet.png' ) ] private const AssetTileSet : Class;
		public function LevelBackgroundChunk( xml : Class )
		{
			super( xml );			
		}
		
		override protected function handleXmlData(xml:XML):void
		{
			_tiles = new Tilemap( AssetTileSet, _width, _height, 128, 128 );
			
			var dataList : XMLList = xml.background.tile;
			var dataElement : XML;
			for each ( dataElement in dataList )
			{
				_tiles.setTile( 
					int( dataElement.@x ) / _tiles.tileWidth, 
					int( dataElement.@y ) / _tiles.tileHeight, 
					int( dataElement.@tx ) / _tiles.tileWidth 
				);
			}			
		}
	}
}