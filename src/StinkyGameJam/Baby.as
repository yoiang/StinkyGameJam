package StinkyGameJam
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import flash.sensors.Accelerometer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.*;
	
	public class Baby extends WorldObject
	{
		[ Embed( source = 'resources/baby.png' ) ] private static const AssetPlayer1 : Class;
		protected var _sprAssetPlayer1:Spritemap;
				
		protected var _jumping : Boolean;
		protected var _numberOfJumpsLeft : uint;
		protected var _jumpAmountLeft : Number;
		[ Embed( source = 'resources/jump2.mp3' ) ] private const AssetJump : Class;
		protected var _jumpSound : Sfx;
		
		protected var _velocity : Vector3D;
		protected var _acceleration : Vector3D;
		
		public var coins : int;
		
		protected var _explosionEmitter:Emitter;
		protected const EXPLOSION_SIZE:uint = 6;
		
		public function Baby( startPosition : Vector3D )
		{
			_sprAssetPlayer1 = Baby.createSpriteSheet();
			_explosionEmitter = Baby.createExplosionEmitter();
			
			super( startPosition.x, startPosition.y, 96, 135, new Graphiclist( _sprAssetPlayer1, _explosionEmitter ), 0 );
			type = "player";
			
			setupMovement();
			
			_removeIfOffscreen = false;
			
			coins = 0;
		}
		
		protected static function createSpriteSheet() : Spritemap
		{
			var spritesheet : Spritemap = new Spritemap( AssetPlayer1, 96, 135 );
			spritesheet.add("stand", [0, 1], 3, true);
			spritesheet.add("jump", [2, 3], 3, true);
			spritesheet.play("stand");
			return spritesheet;
		}
		
		protected static function createExplosionEmitter() : Emitter
		{
			var explosionEmitter : Emitter = new Emitter(new BitmapData(10,10),10,10);
			// Define our particles
			explosionEmitter.newType("explode",[0]);
			explosionEmitter.setAlpha("explode",1,0);
			explosionEmitter.x = 40;
			explosionEmitter.y = 80;
			explosionEmitter.setMotion("explode", 190, 150, 1, 40, -40, -0.5, Ease.quadOut);
			
			explosionEmitter.relative = false;
			return explosionEmitter;
		}
		
		protected function setupMovement() : void
		{
			_jumpSound = new Sfx( AssetJump );
			_jumpSound.pan = -0.5;
			
			Input.define( "Jump", Key.ANY );
			
			_velocity = new Vector3D( 0, 0 );
			_acceleration = new Vector3D( 0, Config.fallingAcceleration );
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
			_velocity.x += _acceleration.x * FP.elapsed;
			_velocity.y += _acceleration.y * FP.elapsed;
			if ( _jumping )
			{
				_velocity.y = -Config.jumpingSpeed * FP.elapsed;
				stopJumping();
/*				_jumpAmountLeft -= Config.jumpingSpeed * FP.elapsed;
				if ( _jumpAmountLeft <= 0 )
				{
					stopJumping();
				}*/
			}

			x += _velocity.x * FP.elapsed;
			y += _velocity.y * FP.elapsed;
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
			if ( _numberOfJumpsLeft  > 0 )
			{
				_numberOfJumpsLeft --;
				//_jumpAmountLeft = Config.jumpAmount;
				
				_sprAssetPlayer1.play("jump");
				for (var i:uint = 0; i < EXPLOSION_SIZE; i++)
				{
					_explosionEmitter.emit("explode",x, y);
				}
				_jumpSound.play();
				_jumping = true;
			}
		}
		
		public function stopJumping() : void
		{
			_jumping = false;
		}
		
		public function landed() : void
		{
			_numberOfJumpsLeft = Config.numberOfJumps;
		}
		
		protected function checkCollision() : void
		{
			var worldObject : WorldObject = collide( "WorldObject", x, y ) as WorldObject;
			if ( worldObject )			
			{
				worldObject.affectBaby( this );
			}

/*
			if ( y < 0 )
			{
				y = 0;
				_velocity.y = 0;
			}
*/
			if ( y + height > FP.screen.height )
			{
				// TODO: kill
				y = FP.screen.height - height;
				bounce();
			}
		}
		
		public function bounce() : void
		{
			_sprAssetPlayer1.play("stand");
			_velocity.y = -_velocity.y * Config.bounceRate;	
			landed();
		}
	}
}
