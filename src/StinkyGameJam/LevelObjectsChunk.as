package StinkyGameJam
{
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	
	import net.flashpunk.FP;

	public class LevelObjectsChunk extends LevelChunk
	{
		protected var _playerStart : XML;
		protected var _objects : XMLList;
		
		public function LevelObjectsChunk(xml:Class)
		{
			super( xml );
		}
		
		override protected function handleXmlData(xml:XML):void
		{
			_playerStart = xml.objects.playerStart[ 0 ];
			
			_objects = xml.objects.*;
		}
		
		public function getPlayerStart() : Vector3D
		{
			return new Vector3D( _playerStart.@x, _playerStart.@y );
		}
		
		public function createObjects( addTo : Vector.< WorldObject >, offsetX : Number ) : void
		{
			for each( var xml : XML in _objects )
			{
				var newObject : WorldObject = LevelObjectsChunk.createWorldObject( xml, offsetX );
				if ( newObject )
				{
					Utility.DTrace( "Creating new " + newObject.toString() + " at ( " + newObject.x + ", " + newObject.y + " )" );
					FP.world.add( newObject );
					addTo.push( newObject );
				}
			}
		}
		
		public static function createWorldObject( xml : XML, offsetX : Number ) : WorldObject
		{
			switch( xml.localName() )
			{
				case "coin":
					return new Coin( int( xml.@x ) + offsetX, int( xml.@y ) );
				break;
				
				case "girl":
					return new Girl( int( xml.@x ) + offsetX, int( xml.@y ) );
				break;

				case "platform":
					return new Platform( int( xml.@x ) + offsetX, int( xml.@y ) );
				break;
			}
			
			return null;
		}
	}
}