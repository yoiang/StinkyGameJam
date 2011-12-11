package StinkyGameJam
{
	import flash.geom.Vector3D;
	
	import net.flashpunk.FP;

	public class LevelObjectsChunk extends LevelChunk
	{
		protected var playerStart : XML;
		protected var coins : XMLList;
		public function LevelObjectsChunk(xml:Class)
		{
			super( xml );
		}
		
		override protected function handleXmlData(xml:XML):void
		{
			var playerStarts : XMLList = xml.objects.playerStart;
			playerStart = xml.objects.playerStart[ 0 ];
			
			coins = xml.objects.coin;
		}
		
		public function getPlayerStart() : Vector3D
		{
			return new Vector3D( playerStart.@x, playerStart.@y );
		}
		
		public function createObjects( addTo : Vector.< WorldObject >, offsetX : Number ) : void
		{
			for each( var xml : XML in coins )
			{
				var coin : Coin = new Coin( int( xml.@x ) + offsetX, int( xml.@y ) );
				FP.world.add( coin );
				addTo.push( coin );
			}
		}
	}
}