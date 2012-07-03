package
{
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var megaman:Megaman = new Megaman();
		public var tileset:FlxSprite = new FlxSprite(0, 0, Game.GFX_DEBUG);
		
		public var megaRoomX:int = 0;
		public var megaRoomY:int = 0;

		public var cameraEventualX:int = 0;
		public var cameraEventualY:int = 0;
		
		public var cameraRoomX:int = 0;
		public var cameraRoomY:int = 0;
		
		public var cameraMoveDirection:int = FlxG
		
		public var cameraTransition:Boolean = false;

		override public function create():void
		{
			super.create();

			add(tileset);
			add(megaman);
			
			megaman.x = Game.WINDOW_WIDTH - 30;
			
			FlxG.watch(this, 'cameraEventualX', 'eventx');
			FlxG.watch(this, 'cameraEventualY', 'eventy');
			FlxG.watch(FlxG.camera, 'x', 'camx');
			FlxG.watch(FlxG.camera, 'y', 'camy');
			FlxG.watch(megaman, 'x');
			FlxG.watch(megaman, 'y');
		}

		override public function update():void
		{
			super.update();
			
			updateCamera();
			updateMegamanRoomCoords();
		}

		/**
		 * Set the next camera coords to the middle of the next room.
		 * @param	x
		 * @param	y
		 */
		protected function setCameraRoom(x:int, y:int):void
		{
			if ( x < 0 || y < 0 )
			{
				megaman.active = true;
				return;
			}
			
			var roomX:int = x * Game.WINDOW_WIDTH;
			var roomY:int = y * Game.WINDOW_HEIGHT;

			cameraRoomX = x;
			cameraRoomY = y;
			
			cameraEventualX = roomX;
			cameraEventualY = roomY;
		}
		
		/**
		 * Update megaman's coords within a room.
		 */
		protected function updateMegamanRoomCoords():void
		{
			megaRoomX = megaman.x - FlxG.camera.x;
			megaRoomY = megaman.y - FlxG.camera.y;
		}

		protected function updateCamera():void
		{
			if ( !cameraTransition )
			{
				if( megaRoomX > Game.WINDOW_WIDTH )
				{
					cameraTransition = true;
					setCameraRoom(cameraRoomX + 1, cameraRoomY);
				}
				if( megaRoomX < 0 )
				{
					cameraTransition = true;
					setCameraRoom(cameraRoomX - 1, cameraRoomY);
				}
				if( megaRoomY > Game.WINDOW_HEIGHT )
				{
					cameraTransition = true;
					setCameraRoom(cameraRoomX, cameraRoomY + 1);
				}
				if( megaRoomY < 0 )
				{
					cameraTransition = true;
					setCameraRoom(cameraRoomX, cameraRoomY - 1);
				}
			}
			else
			{
				megaman.active = false;
				
				if(cameraEventualX != Math.abs(FlxG.camera.x) || cameraEventualY != Math.abs(FlxG.camera.y))
				{
					var diffX:int = cameraEventualX - FlxG.camera.x;
					var diffY:int = cameraEventualY - FlxG.camera.y;
					
					var mag:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
					
					var unitX:Number = diffX / mag;
					var unitY:Number = diffY / mag;
					
					FlxG.camera.scroll.make(FlxG.camera.x - unitX, FlxG.camera.y - unitY);
					
					megaman.x -= unitX;
					megaman.y -= unitY;
				}
				else
				{
					megaman.active = true;
					cameraTransition = false;
				}
			}
			
			FlxG.camera.update();
		}
	}
}