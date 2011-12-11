package StinkyGameJam
{
	import flash.geom.Vector3D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Tilemap;
	
	public class Level extends Entity
	{
		[ Embed( source="resources/level/LevelBackground1.oel", mimeType="application/octet-stream" ) ] private static const AssetBackground1 : Class;
		[ Embed( source="resources/level/LevelBackground2.oel", mimeType="application/octet-stream" ) ] private static const AssetBackground2 : Class;		
		[ Embed( source="resources/level/LevelObjects1.oel", mimeType="application/octet-stream" ) ]    private static const AssetObjects1 : Class;
		[ Embed( source="resources/level/LevelObjects2.oel", mimeType="application/octet-stream" ) ]    private static const AssetObjects2 : Class;		
		[ Embed( source="resources/level/LevelObjects3.oel", mimeType="application/octet-stream" ) ]    private static const AssetObjects3 : Class;		
		
		protected var _backgroundChunkAssets : Vector.<LevelBackgroundChunk>;
		protected var _currentBackgroundChunkIndices : Vector.< int >;
		protected var _currentBackgroundScrollDistance : Number;
				
		protected var _scrollSpeed : Number;
	
		protected var _objectsChunkAssets : Vector.<LevelObjectsChunk>;
		protected var _currentObjectChunkIndices : Vector.< int >;
		protected var _currentObjectScrollDistance : Number;

		protected var _worldObjects : Vector.< WorldObject >;

		public function Level()
		{
			super( x, y );
			type = "level";
					
			_backgroundChunkAssets = new Vector.<LevelBackgroundChunk>();
			_backgroundChunkAssets.push( new LevelBackgroundChunk( AssetBackground1 ) );
			_backgroundChunkAssets.push( new LevelBackgroundChunk( AssetBackground2 ) );
			_currentBackgroundChunkIndices = new Vector.<int>();
			_currentBackgroundScrollDistance = 0;
			
			_objectsChunkAssets = new Vector.<LevelObjectsChunk>();
			_objectsChunkAssets.push( new LevelObjectsChunk( AssetObjects1 ) );
			_objectsChunkAssets.push( new LevelObjectsChunk( AssetObjects2 ) );			
			_objectsChunkAssets.push( new LevelObjectsChunk( AssetObjects3 ) );			
			_currentObjectChunkIndices = new Vector.<int>();
			_currentObjectScrollDistance = 0;

			_worldObjects = new Vector.<WorldObject>();

			fillChunkIndices();			
		}
		
		protected function fillChunkIndices() : void
		{
			var screenWidth : Number = FP.screen.width;
			
			var currentCoverage : Number = -_currentBackgroundScrollDistance;
			for each( var chunkIndex : int in _currentBackgroundChunkIndices )
			{
				currentCoverage += ( _backgroundChunkAssets[ chunkIndex ] as LevelChunk ).width;
			}

			while ( currentCoverage < screenWidth )
			{
				
				chunkIndex = int( Math.floor( Math.random() * _backgroundChunkAssets.length ) );
				_currentBackgroundChunkIndices.push( chunkIndex );
				( _backgroundChunkAssets[ chunkIndex ] as LevelBackgroundChunk ).createTilemap( _worldObjects, currentCoverage );
				
				currentCoverage += ( _backgroundChunkAssets[ chunkIndex ] as LevelChunk ).width;
			}
			
			currentCoverage = -_currentObjectScrollDistance;
			for each( chunkIndex in _currentObjectChunkIndices )
			{
				currentCoverage += ( _objectsChunkAssets[ chunkIndex ] as LevelChunk ).width;
			}
			
			while ( currentCoverage < screenWidth )
			{
				chunkIndex = int( Math.floor( Math.random() * _objectsChunkAssets.length ) );
				_currentObjectChunkIndices.push( chunkIndex );
				( _objectsChunkAssets[ chunkIndex ] as LevelObjectsChunk ).createObjects( _worldObjects, currentCoverage );
				
				currentCoverage += ( _objectsChunkAssets[ chunkIndex ] as LevelChunk ).width;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			_currentBackgroundScrollDistance += Config.levelScrollSpeed * FP.elapsed;
			if ( _currentBackgroundScrollDistance > ( _backgroundChunkAssets[ 0 ] as LevelChunk ).width )
			{
				_currentBackgroundScrollDistance -= ( _backgroundChunkAssets[ 0 ] as LevelChunk ).width;
				_currentBackgroundChunkIndices.shift();
			}
			
			_currentObjectScrollDistance += Config.levelScrollSpeed * FP.elapsed;
			if ( _currentObjectScrollDistance > ( _objectsChunkAssets[ 0 ] as LevelChunk ).width )
			{
				_currentObjectScrollDistance -= ( _objectsChunkAssets[ 0 ] as LevelChunk ).width;
				_currentObjectChunkIndices.shift();
			}
			
			fillChunkIndices();
		}
		
		public function getPlayerStart() : Vector3D
		{
			// TODO: only allow spawning when chunk is lined up?
			return ( _objectsChunkAssets[ 0 ] as LevelObjectsChunk ).getPlayerStart();
		}
		
		public function objectDestroyed( object : WorldObject ) : void
		{
			var index : int = _worldObjects.indexOf( object );
			if ( index != -1 )
			{
				_worldObjects.splice( index, 1 );
			}
		}
	}
}