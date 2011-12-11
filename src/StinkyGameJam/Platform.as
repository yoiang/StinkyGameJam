package StinkyGameJam
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Platform extends WorldObject
	{
		[ Embed( source = 'resources/levelEditor/coin.png' ) ] private const AssetImage : Class;
		public function Platform( x : Number, y : Number, speed : Number)
		{
			super( x, y, speed, new Image( AssetImage ) );
		}
		
		override public function affectBaby( baby : Baby ) : void
		{		
			// TODO: decide which direction approached from, push back
			baby.x += height;
		}
	}
}