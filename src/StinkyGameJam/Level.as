package StinkyGameJam
{
	import flash.geom.Vector3D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	
	public class Level extends Entity
	{
		[ Embed( source="resources/level/LevelBackground1.oel", mimeType="application/octet-stream" ) ] private static const AssetBackground1 : Class;		
		[ Embed( source="resources/level/LevelObjects1.oel", mimeType="application/octet-stream" ) ]    private static const AssetObjects1 : Class;		
		
		protected var _objectsBackgroundAssets : Vector.<LevelBackgroundChunk>;
		
		protected var _objectsChunkAssets : Vector.<LevelObjectsChunk>;
		
		protected var _scrollSpeed : Number;
		
		protected var _objects : Vector.< WorldObject >;
		protected var _currentObjectChunkIndices : Vector.< int >;
		protected var _currentScrollDistance : Number;
		
		public function Level()
		{
			super( x, y );
			type = "level";
					
			_objectsBackgroundAssets = new Vector.<LevelBackgroundChunk>();
			_objectsBackgroundAssets.push( new LevelBackgroundChunk( AssetBackground1 ) );
			_objectsChunkAssets = new Vector.<LevelObjectsChunk>();
			_objectsChunkAssets.push( new LevelObjectsChunk( AssetObjects1 ) );
			
			_objects = new Vector.<WorldObject>();
			_currentObjectChunkIndices = new Vector.<int>();
			_currentScrollDistance = 0;
			fillObjectChunkIndices();			
		}
		
		protected function fillObjectChunkIndices() : void
		{
			var currentCoverage : Number = -_currentScrollDistance;
			for each( var chunkIndex : int in _currentObjectChunkIndices )
			{
				currentCoverage += ( _objectsChunkAssets[ chunkIndex ] as LevelObjectsChunk ).width;
			}
			
			var screenWidth : Number = FP.screen.width;
			while ( currentCoverage < screenWidth )
			{
				chunkIndex = int( Math.floor( Math.random() * _objectsChunkAssets.length ) );
				_currentObjectChunkIndices.push( chunkIndex );
				( _objectsChunkAssets[ chunkIndex ] as LevelObjectsChunk ).createObjects( _objects, currentCoverage );
				
				currentCoverage += ( _objectsChunkAssets[ chunkIndex ] as LevelObjectsChunk ).width;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			_currentScrollDistance += Config.levelScrollSpeed * FP.elapsed;
			if ( _currentScrollDistance > ( _objectsChunkAssets[ 0 ] as LevelObjectsChunk ).width )
			{
				_currentScrollDistance -= ( _objectsChunkAssets[ 0 ] as LevelObjectsChunk ).width;
				_currentObjectChunkIndices.shift();
			}
			
			fillObjectChunkIndices();
		}
		
		public function getPlayerStart() : Vector3D
		{
			// TODO: only allow spawning when chunk is lined up?
			return ( _objectsChunkAssets[ 0 ] as LevelObjectsChunk ).getPlayerStart();
		}
		
		public function objectDestroyed( object : WorldObject ) : void
		{
			var index : int = _objects.indexOf( object );
			if ( index != -1 )
			{
				_objects.splice( index, 1 );
			}
		}
	}
}