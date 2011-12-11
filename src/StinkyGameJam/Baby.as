package StinkyGameJam
{
	import flash.geom.Vector3D;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Baby extends Entity
	{
		[ Embed( source = 'resources/player1.png' ) ] private const AssetPlayer1 : Class;
		[ Embed( source = 'resources/player2.png' ) ] private const AssetPlayer2 : Class;
		
		[ Embed( source = 'resources/jump.mp3' ) ] private const AssetJump : Class;
		
		protected var jumping : Boolean;
		protected var jumpSound : Sfx;
		protected var velocity : Vector3D;
		protected var acceleration : Vector3D;
		
		public var coins : int;
		
		public function Baby( startPosition : Vector3D )
		{
			var graphic : Graphic = null;
			if ( Math.random() < 0.5 )
			{
				graphic = new Image( AssetPlayer1 );
			} else
			{
				graphic = new Image( AssetPlayer2 );
			}
			super( startPosition.x, startPosition.y, graphic, null );
				
			type = "player";
			
			width = 50;
			height = 50;
			setHitbox( 50, 50 );		
			
			jumpSound = new Sfx( AssetJump );
			jumpSound.pan = -0.5;
			
			Input.define( "Jump", Key.ANY );
			
			velocity = new Vector3D( 0, 0 );
			acceleration = new Vector3D( 0, 1000 );
			
			coins = 0;
		}
		
		override public function update():void
		{
			super.update();
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
				//stopJumping();
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
			jumpSound.play();
			jumping = true;
		}
		
		public function stopJumping() : void
		{
			jumping = false;
		}
		
		protected function checkCollision() : void
		{
			var worldObject : WorldObject = collide( "WorldObject", x, y ) as WorldObject;
			if ( worldObject )			
			{
				worldObject.affectBaby( this );
			}

			if ( y < 0 )
			{
				y = 0;
				velocity.y = 0;
			}
			if ( y + height > FP.screen.height - 10 )
			{
				y = FP.screen.height - height - 10;
				velocity.y = -velocity.y * 0.5;
			}
		}
		
		public function give( item : WorldObject ) : void
		{
			item.destroy();
		}
	}
}