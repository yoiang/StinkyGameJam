package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	public class WorldObject extends Entity
	{
		public function WorldObject( x : Number, y : Number, setGraphic : Graphic )
		{
			super( x, y, setGraphic );
			layer = 5;
			
			type = "WorldObject";
		}
		
		override public function update():void
		{
			super.update();
			
			// TODO: query level for speed, don't store?
			x += -Config.levelScrollSpeed * FP.elapsed;
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