package
{
	import org.flixel.*;
	
	[SWF(width="512", height="480", backgroundColor="#555599")]
	[Frame(factoryClass="Preloader")]
	
	public class Main extends FlxGame
	{
		public function Main()
		{
			super(256, 240, PlayState, 2);
			useSystemCursor = true;
			showPause = true;
		}
	}
}