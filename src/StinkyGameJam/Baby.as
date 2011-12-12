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
		[ Embed( source = 'resources/baby-spritesheet.png' ) ] private const AssetPlayer1 : Class;
		public var sprAssetPlayer1:Spritemap = new Spritemap(AssetPlayer1, 96, 135);
		
		[ Embed( source = 'resources/jump.mp3' ) ] private const AssetJump : Class;
		
		protected var jumping : Boolean;
		protected var jumpSound : Sfx;
		protected var velocity : Vector3D;
		protected var acceleration : Vector3D;
		
		public var coins : int;
		
		protected var explosionEmitter:Emitter;
		protected const EXPLOSION_SIZE:uint = 6;
		
		public function Baby( startPosition : Vector3D )
		{
			sprAssetPlayer1.add("stand", [0, 1], 3, true);
			sprAssetPlayer1.add("jump", [2, 3], 3, true);
			sprAssetPlayer1.play("stand");
			
			explosionEmitter = Baby.createExplosionEmitter();
			
			var graphicList : Graphiclist = new Graphiclist( sprAssetPlayer1, explosionEmitter );
			super( startPosition.x, startPosition.y, graphicList, null );
				
			type = "player";
			layer = 0;
			
			width = 96;
			height = 135;
			setHitbox( 96, 135 );		
			
			jumpSound = new Sfx( AssetJump );
			jumpSound.pan = -0.5;
			
			Input.define( "Jump", Key.ANY );
			
			velocity = new Vector3D( 0, 0 );
			acceleration = new Vector3D( 0, Config.fallingAcceleration );
			
			coins = 0;
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
				velocity.y = -Config.jumpingSpeed * FP.elapsed;
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
			sprAssetPlayer1.play("jump");
			for (var i:uint = 0; i < EXPLOSION_SIZE; i++)
			{
				explosionEmitter.emit("explode",x, y);
			}
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
			if ( y + height > FP.screen.height )
			{
				y = FP.screen.height - height;
				bounce();
			}
		}
		
		public function bounce() : void
		{
			sprAssetPlayer1.play("stand");
			velocity.y = -velocity.y * Config.bounceRate;			
		}
		
		public function give( item : WorldObject ) : void
		{
			item.destroy();
		}
	}
}
