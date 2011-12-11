package StinkyGameJam
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Coin extends WorldObject
	{
		[ Embed( source = 'resources/level/coin.png' ) ] private const AssetImage : Class;
		public function Coin( x : Number, y : Number )
		{
			super( x, y, new Image( AssetImage ) );
						
			setHitbox( 64, 64 ); // lame, width and height aren't set yet
		}
		
		override public function affectBaby( baby : Baby ) : void
		{		
			baby.coins += 1;
			destroy();
		}
	}
}