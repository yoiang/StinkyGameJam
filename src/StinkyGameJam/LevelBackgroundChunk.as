package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	public class LevelBackgroundChunk extends LevelChunk
	{
		[ Embed( source = 'resources/level/tileSet.png' ) ] private const AssetTileSet : Class;
		
		protected var _tileList : XMLList;
		public function LevelBackgroundChunk( xml : Class )
		{
			super( xml );			
		}
		
		override protected function handleXmlData(xml:XML):void
		{
			_tileList = xml.background.tile;
		}
		
		public function createTilemap( addTo : Vector.< WorldObject >, offsetX : Number ) : void
		{
			var tilemap : LevelChunkTilemap = new LevelChunkTilemap( offsetX, 0, AssetTileSet, width, height, 128, 128, _tileList );
			FP.world.add( tilemap );
			addTo.push( tilemap );
		}
	}
}