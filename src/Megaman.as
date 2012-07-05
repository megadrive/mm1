package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Andrew Simeon
	 */
	public class Megaman extends FlxSprite
	{		
		public var roomPosX:int = 0;
		public var roomPosY:int = 0;
		
		public function Megaman()
		{
			loadGraphic(Game.SPRITE_MEGAMAN, false, false, 24, 24, true);
			width = 16; height = 16;
			
			this.offset = new FlxPoint(5, 8);
		}
		
		override public function update():void
		{
			if( FlxG.keys.pressed('UP') )
			{
				y += -1;
			}
			if( FlxG.keys.pressed('LEFT') )
			{
				x += -1;
			}
			if( FlxG.keys.pressed('DOWN') )
			{
				y += 1;
			}
			if( FlxG.keys.pressed('RIGHT') )
			{
				x += 1;
			}
		}
	}
}