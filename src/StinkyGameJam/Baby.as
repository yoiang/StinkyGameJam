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
	
	public class Baby extends Entity
	{
		[ Embed( source = 'resources/baby.png' ) ] private const AssetPlayer1 : Class;
		protected var _sprAssetPlayer1:Spritemap = new Spritemap(AssetPlayer1, 96, 135);
		
		[ Embed( source = 'resources/jump.mp3' ) ] private const AssetJump : Class;
		
		protected var _jumping : Boolean;
		protected var _jumpSound : Sfx;
		protected var _velocity : Vector3D;
		protected var _acceleration : Vector3D;
		
		public var coins : int;
		
		protected var _explosionEmitter:Emitter;
		protected const EXPLOSION_SIZE:uint = 100;
		
		public function Baby( startPosition : Vector3D )
		{
			_sprAssetPlayer1.add("stand", [0, 1], 3, true);
			_sprAssetPlayer1.add("jump", [2, 3], 3, true);
			_sprAssetPlayer1.play("stand");
			
			_explosionEmitter = Baby.createExplosionEmitter();
			
			var graphicList : Graphiclist = new Graphiclist( _sprAssetPlayer1, _explosionEmitter );
			super( startPosition.x, startPosition.y, graphicList, null );
				
			type = "player";
			layer = 0;
			
			width = 96;
			height = 135;
			setHitbox( 96, 135 );		
			
			_jumpSound = new Sfx( AssetJump );
			_jumpSound.pan = -0.5;
			
			Input.define( "Jump", Key.ANY );
			
			_velocity = new Vector3D( 0, 0 );
			_acceleration = new Vector3D( 0, Config.fallingAcceleration );
			
			coins = 0;
		}
		
		protected static function createExplosionEmitter() : Emitter
		{
			var explosionEmitter : Emitter = new Emitter(new BitmapData(1,1),1,1);
			// Define our particles
			explosionEmitter.newType("explode",[0]);
			explosionEmitter.setAlpha("explode",1,0);
			explosionEmitter.setMotion("explode", 0, 50, 2, 360, -40, -0.5, Ease.quadOut);
			
			explosionEmitter.relative = false;
			return explosionEmitter;
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
				// toggle flag off
				//stopJumping();
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
			_sprAssetPlayer1.play("jump");
			for (var i:uint = 0; i < EXPLOSION_SIZE; i++)
			{
				_explosionEmitter.emit("explode",x, y);
			}
			_jumpSound.play();
			_jumping = true;
		}
		
		public function stopJumping() : void
		{
			_jumping = false;
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
				_velocity.y = 0;
			}
			if ( y + height > FP.screen.height )
			{
				y = FP.screen.height - height;
				bounce();
			}
		}
		
		public function bounce() : void
		{
			_sprAssetPlayer1.play("stand");
			_velocity.y = -_velocity.y * Config.bounceRate;			
		}
		
		public function give( item : WorldObject ) : void
		{
			item.destroy();
		}
	}
}
