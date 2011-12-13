package StinkyGameJam
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	
	public class Coin extends WorldObject
	{
		[ Embed( source = 'resources/level/coin.png' ) ] private const AssetImage : Class;
		[ Embed( source = 'resources/coin.mp3' ) ] private const AssetCollectSound : Class;
		
		protected var _collectSound : Sfx;
		
		public function Coin( x : uint, y : uint )
		{
			super( x, y, 64, 64, new Image( AssetImage ), 1 );
			
			_collectSound = new Sfx( AssetCollectSound );
			_collectSound.pan = 0.5;
		}
		
		override public function affectBaby( baby : Baby ) : void
		{		
			_collectSound.play();
			baby.coins += 1;
			if (Config.levelScrollSpeed < Config.levelScrollMaxSpeed)
			{
				Config.levelScrollSpeed += Config.levelScrollAcceleration;
				baby.x += 50;
			}
			destroy();
		}
	}
}