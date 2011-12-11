package StinkyGameJam
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class StinkyGameJam extends Engine
	{
		public function StinkyGameJam()
		{
			super( 320, 240 );
			FP.screen.scale = 2;
		}
		
		override public function init() : void
		{
			FP.world = new StinkyWorld();
			trace( "init" );
		}
	}
}