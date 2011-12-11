package StinkyGameJam
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Platform extends WorldObject
	{
		[ Embed( source = 'resources/level/platform.png' ) ] private const AssetImage : Class;
		public function Platform( x : Number, y : Number )
		{
			super( x, y, 256, 32, new Image( AssetImage ), 2 );			
		}
		
		override public function affectBaby( baby : Baby ) : void
		{		
			// TODO: decide which direction approached from, push back
			baby.x += height;
		}
	}
}