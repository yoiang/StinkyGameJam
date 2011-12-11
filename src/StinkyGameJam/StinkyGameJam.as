package StinkyGameJam
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class StinkyGameJam extends Engine
	{
		public function StinkyGameJam()
		{
			super( 1280, 512 );
			FP.screen.scale = 1;
			FP.console.enable();
		}
		
		override public function init() : void
		{
			FP.world = new StinkyWorld();
			trace( "init" );
		}
	}
}
