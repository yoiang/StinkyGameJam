package StinkyGameJam
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	
	public class Coin extends WorldObject
	{
		[ Embed( source = 'resources/level/coin.png' ) ] private const AssetImage : Class;
		[ Embed( source = 'resources/coinCollect.mp3' ) ] private const AssetCollectSound : Class;
		
		protected var collectSound : Sfx;
		
		public function Coin( x : uint, y : uint )
		{
			super( x, y, new Image( AssetImage ) );
			layer = 1;
						
			setHitbox( 64, 64 ); // lame, width and height aren't set yet
			
			collectSound = new Sfx( AssetCollectSound );
			collectSound.pan = 0.5;
		}
		
		override public function affectBaby( baby : Baby ) : void
		{		
//			collectSound.play();
			baby.coins += 1;
			destroy();
		}
	}
}