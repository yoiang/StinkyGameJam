package StinkyGameJam
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	
	public class Girl extends WorldObject
	{
		[ Embed( source = 'resources/level/girl.png' ) ] private const AssetImage : Class;
		[ Embed( source = 'resources/girl.mp3' ) ] private const AssetCollectSound : Class;
		
		protected var _collectSound : Sfx;
		
		public function Girl( x : uint, y : uint )
		{
			super( x, y, 158, 136, new Image( AssetImage ), 1 );
			
			_collectSound = new Sfx( AssetCollectSound );
			_collectSound.pan = 0.5;
		}
		
		override public function affectBaby( baby : Baby ) : void
		{		
			_collectSound.play();
			if (Config.levelScrollSpeed > Config.levelScrollMinSpeed)
			{
				Config.levelScrollSpeed -= 2 * Config.levelScrollAcceleration;
				baby.x -= 100;
			}
			destroy();
		}
	}
}