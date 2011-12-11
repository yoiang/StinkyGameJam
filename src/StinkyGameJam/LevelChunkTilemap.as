package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	
	public class LevelChunkTilemap extends WorldObject
	{
		public function LevelChunkTilemap( x : uint, y : uint, tileset:*, setWidth:uint, height:uint, tileWidth:uint, tileHeight:uint, tileList : XMLList )
		{
			super( x, y, LevelChunkTilemap.createTilemap( tileset, setWidth, height, tileWidth, tileHeight, tileList ) );
			layer = 10;
			
			width = setWidth
		}
		
		protected static function createTilemap( asset : *, width : Number, height : Number, tileWidth : Number, tileHeight : Number, tileList : XMLList ) : Tilemap
		{
			var result : Tilemap = new Tilemap( asset, width, height, tileWidth, tileHeight );
			var tileElement : XML;
			
			for each ( tileElement in tileList )
			{
				result.setTile( 
					int( tileElement.@x ) / result.tileWidth, 
					int( tileElement.@y ) / result.tileHeight, 
					int( tileElement.@tx ) / result.tileWidth 
				);
			}
			return result;
		}
	}
}