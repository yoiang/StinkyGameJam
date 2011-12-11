package StinkyGameJam
{
	import flash.geom.Vector3D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Baby extends Entity
	{
		[ Embed( source = 'resources/baby-spritesheet.png' ) ] private const AssetPlayer1 : Class;
		public var sprAssetPlayer1:Spritemap = new Spritemap(AssetPlayer1, 96, 135);
		
		[ Embed( source = 'resources/jump.mp3' ) ] private const AssetJump : Class;
		
		protected var jumping : Boolean;
		protected var jumpSound : Sfx;
		protected var velocity : Vector3D;
		protected var acceleration : Vector3D;
		
		public function Baby(x:Number=0, y:Number=0)
		{
			sprAssetPlayer1.add("stand", [0, 1], 3, true);
			sprAssetPlayer1.add("jump", [2, 3], 3, true);
			var graphic : Graphic = sprAssetPlayer1;
			sprAssetPlayer1.play("stand");
			super(x, y, graphic, null);
				
			type = "player";
			
			width = 96;
			height = 135;
			setHitbox( 96, 135 );		
			
			jumpSound = new Sfx( AssetJump );
			jumpSound.pan = -0.5;
			
			Input.define( "Jump", Key.ANY );
			
			velocity = new Vector3D( 0, 0 );
			acceleration = new Vector3D( 0, 1000 );
		}
		
		override public function update():void
		{
			checkInput();
			updateMovement();
			checkCollision();
		}
		
		protected function updateMovement() : void
		{
			velocity.x += acceleration.x * FP.elapsed;
			velocity.y += acceleration.y * FP.elapsed;
			if ( jumping )
			{
				velocity.y = -10000 * FP.elapsed;
				// toggle flag off
				stopJumping();
			}

			x += velocity.x * FP.elapsed;
			y += velocity.y * FP.elapsed;
		}
		
		protected function checkInput() : void
		{
			if ( Input.pressed( "Jump" ) )
			{
				startJumping();
			}
			if ( Input.released( "Jump" ) )
			{	
				stopJumping();
			}
		}

		public function startJumping() : void
		{
			sprAssetPlayer1.play("jump");
			jumpSound.play();
			jumping = true;
		}
		
		public function stopJumping() : void
		{
			jumping = false;
		}
		
		protected function checkCollision() : void
		{
			var platform : Platform = collide( "platform", x, y ) as Platform;
			if ( platform )			
			{
			}
			
			var item : Item = collide( "item", x, y ) as Item;
			if ( item )
			{
				give( item );
			}
			
			if ( y < 0 )
			{
				y = 0;
				velocity.y = 0;
			}
			if ( y + height > FP.screen.height - 10 )
			{
				sprAssetPlayer1.play("stand");
				y = FP.screen.height - height - 10;
				velocity.y = -velocity.y * 0.5;
			}
		}
		
		public function give( item : Item ) : void
		{
			item.destroy();
		}
	}
}