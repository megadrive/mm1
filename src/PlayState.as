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
		
		public var cameraTransition:Boolean = false;
		public var cameraScrollSpeed:int = 2;

		override public function create():void
		{
			super.create();

			add(tileset);
			add(megaman);
			
			megaman.x = Game.WINDOW_WIDTH / 2;
			
			FlxG.camera.setBounds(0, 0, tileset.width, tileset.height);
			
			FlxG.watch(this, 'megaRoomX');
			FlxG.watch(this, 'megaRoomY');
			FlxG.watch(FlxG.camera.scroll, 'x', 'camX');
			FlxG.watch(FlxG.camera.scroll, 'y', 'camY');
			FlxG.watch(this, 'cameraRoomX');
			FlxG.watch(this, 'cameraRoomY');
		}

		override public function update():void
		{
			super.update();
			
			updateCamera();
			updateMegamanRoomCoords();
		}

		/**
		 * Set the next camera coords to the top left of the next room.
		 * @param	x
		 * @param	y
		 */
		protected function setCameraRoom(x:int, y:int, forceTransition:Boolean = true):void
		{
			if ( x < 0 || y < 0 )
			{
				cameraTransition = false;
				return;
			}
			
			trace(x, y);
			
			var roomX:int = x * Game.WINDOW_WIDTH;
			var roomY:int = y * Game.WINDOW_HEIGHT;

			cameraRoomX = x;
			cameraRoomY = y;
			
			cameraEventualX = roomX;
			cameraEventualY = roomY;
			
			if ( forceTransition )
			{
				cameraTransition = true;
			}
		}
		
		/**
		 * Update megaman's coords within a room.
		 */
		protected function updateMegamanRoomCoords():void
		{
			megaRoomX = megaman.x - FlxG.camera.scroll.x;
			megaRoomY = megaman.y - FlxG.camera.scroll.y;
		}

		protected function updateCamera():void
		{
			if ( !cameraTransition )
			{
				megaman.active = true;
				if( megaRoomX > Game.WINDOW_WIDTH )
				{
					setCameraRoom(cameraRoomX + 1, cameraRoomY);
				}
				if( megaRoomX < 0 )
				{
					setCameraRoom(cameraRoomX - 1, cameraRoomY);
				}
				if( megaRoomY > Game.WINDOW_HEIGHT )
				{
					setCameraRoom(cameraRoomX, cameraRoomY + 1);
				}
				if( megaRoomY < 0 )
				{
					setCameraRoom(cameraRoomX, cameraRoomY - 1);
				}
			}
			else
			{
				megaman.active = false;
				
				if(cameraEventualX != FlxG.camera.scroll.x || cameraEventualY != FlxG.camera.scroll.y)
				{
					var diffX:int = cameraEventualX - FlxG.camera.scroll.x;
					var diffY:int = cameraEventualY - FlxG.camera.scroll.y;
					
					var mag:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
					
					var unitX:Number = 0;
					var unitY:Number = 0;
					if ( mag > 0 )
					{
						unitX = diffX / mag;
						unitY = diffY / mag;
					}
					// add speed
					unitX = unitX * cameraScrollSpeed;
					unitY = unitY * cameraScrollSpeed;
					FlxG.camera.scroll.make(FlxG.camera.scroll.x + unitX, FlxG.camera.scroll.y + unitY);
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