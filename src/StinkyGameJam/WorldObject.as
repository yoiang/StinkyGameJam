package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	public class WorldObject extends Entity
	{
		protected var _speed : Number;
		
		public function WorldObject( x : Number, y : Number, speed : Number, setGraphic : Graphic )
		{
			super( x, y, setGraphic );
			type = "WorldObject";
			
			_speed = speed;
		}
		
		override public function update():void
		{
			super.update();
			
			// TODO: query level for speed, don't store?
			x -= _speed * FP.elapsed;
			if ( x + width < 0 )
			{
				destroy();
			}
		}
		
		public function affectBaby( baby : Baby ) : void
		{		
		}
		
		public function destroy() : void
		{
			FP.world.remove( this );
		}
	}
}