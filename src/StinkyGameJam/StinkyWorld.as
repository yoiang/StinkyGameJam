package StinkyGameJam
{
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	public class StinkyWorld extends World
	{
		public function StinkyWorld()
		{
			super();
			
			add( new Baby( 75, 10 ) );
		}
		
		override public function begin() : void
		{
			addGraphic( new Text( "Stinky World" ) );
		}
	}
}