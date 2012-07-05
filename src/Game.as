package  
{
	/**
	 * Containts game constants as well as assets.
	 * @author Andrew Simeon
	 */
	public class Game
	{
		/**
		 * Cutman's stage.
		 */
		[Embed(source = "../assets/cutmanTileset.png")] static public const GFX_CUTMAN:Class;
		[Embed(source = "../assets/cutman.oel", mimeType = "application/octet-stream")] static public const LVL_CUTMAN:Class;
		
		/**
		 * Megaman's sprite.
		 */
		[Embed(source = "../assets/megaman.png")] static public const SPRITE_MEGAMAN:Class;
		
		/**
		 * Window width.
		 */
		public static const WINDOW_WIDTH:int = 256;
		
		/**
		 * Window height.
		 */
		public static const WINDOW_HEIGHT:int = 240;
		
		public static const NONE:int = 0;
		public static const UP:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 3;
		public static const DOWN:int = 4;
	}
}