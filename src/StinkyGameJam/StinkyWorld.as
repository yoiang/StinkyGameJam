package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	public class StinkyWorld extends World
	{
		protected var level : Level;
		protected var baby : Baby;
		protected var coinsText : Text;
		
		public function StinkyWorld()
		{
			super();		
		}
		
		override public function begin() : void
		{
			level = new Level();
			baby = new Baby( level.getPlayerStart() );
			add( baby );
			add( level );

			addGraphic( new Text( "Stinky World" ) );
			addGraphic( new Text( "Coins:", 500, 10 ) );
			coinsText = new Text( "0", 550, 10 );
			addGraphic( coinsText );
		}

		override public function update():void
		{
			super.update();
			coinsText.text = baby.coins.toString();	
		}	
		
		override public function remove(e:Entity):Entity
		{
			var worldObject : WorldObject = e as WorldObject;
			if ( worldObject )
			{
				level.objectDestroyed( worldObject );
			}
			return super.remove( e );
		}
	}
}