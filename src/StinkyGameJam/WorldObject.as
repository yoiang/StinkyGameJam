package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	public class WorldObject extends Entity
	{
		protected var _removeIfOffscreen : Boolean;
		
		public function WorldObject( x : uint, y : uint, setWidth : Number, setHeight : Number, setGraphic : Graphic, setLayer : uint = 0 )
		{
			super( x, y, setGraphic );
			type = "WorldObject";
			
			width = setWidth;
			height = setHeight;
			setHitbox( width, height );
			
			layer = setLayer;
			
			_removeIfOffscreen = true;
		}
		
		override public function update():void
		{
			super.update();
			
			if ( _removeIfOffscreen )
			{
				// TODO: query level for speed, don't store?
				x += -Config.levelScrollSpeed * FP.elapsed;
				if ( x + width < 0 )
				{
					destroy();
				}				
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