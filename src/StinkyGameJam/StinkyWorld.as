package StinkyGameJam
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	public class StinkyWorld extends World
	{
		protected var _level : Level;
		protected var _baby : Baby;
		protected var _coinsText : Text;
		
		public function StinkyWorld()
		{
			super();		
		}
		
		override public function begin() : void
		{
			_level = new Level();
			_baby = new Baby( _level.getPlayerStart() );
			add( _baby );
			add( _level );

			addGraphic( new Text( "Stinky World" ) );
			addGraphic( new Text( "Coins:", 500, 10 ) );
			_coinsText = new Text( "0", 550, 10, 200 );
			addGraphic( _coinsText );
		}

		override public function update():void
		{
			super.update();
			_coinsText.text = _baby.coins.toString();	
		}	
		
		override public function remove(e:Entity):Entity
		{
			var worldObject : WorldObject = e as WorldObject;
			if ( worldObject )
			{
				_level.objectDestroyed( worldObject );
			}
			return super.remove( e );
		}
	}
}