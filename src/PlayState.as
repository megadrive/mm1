package
{
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var megaman:Megaman = new Megaman();
		
		public var megaRoomX:int = 0;
		public var megaRoomY:int = 0;

		public var cameraEventualX:int = 0;
		public var cameraEventualY:int = 0;
		
		public var cameraRoomX:int = 0;
		public var cameraRoomY:int = 0;
		
		public var cameraTransition:Boolean = false;
		public var cameraScrollSpeed:int = 2;
		
		public var map:Map = new Map();
		
		private var text:FlxText = new FlxText(2, 2, FlxG.width - 2);

		override public function create():void
		{
			super.create();
			
			map.loadLevel(Game.LVL_CUTMAN, Game.GFX_CUTMAN);
			add(map);
			add(megaman);
			
			megaman.x = map.playerStart.x;
			megaman.y = map.playerStart.y - 64;
			megaman.mapRef = map;
			
			FlxG.bgColor = 0xFF7DA0FF;
			
			/* debug */
			FlxG.watch(megaman, '_jumpHeight');
			FlxG.watch(megaman, '_maxJumpHeight');
			
			/* debug */
			text.scrollFactor.make(0, 0);
			add(text);
		}

		override public function update():void
		{
			super.update();
			
			FlxG.collide(megaman, map.collision);
			
			if ( FlxG.keys.justPressed('R') )
			{
				megaman.x = map.playerStart.x;
				megaman.y = map.playerStart.y - 64;
			}
			
			updateCamera();
			updateMegamanRoomCoords();
		}

		/**
		 * Set the next camera coords to the top left of the next room.
		 * @param	x
		 * @param	y
		 */
		protected function setCameraRoom(x:int, y:int, forceTransition:Boolean = true, snapTo:Boolean = false):void
		{
			if ( x < 0 || y < 0 )
			{
				cameraTransition = false;
				return;
			}
			
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
			if( megaRoomX + 16 < FlxG.camera.bounds.width && megaRoomY + 16 < FlxG.camera.bounds.height )
			{
				if ( !cameraTransition )
				{
					megaman.active = true;
					if( megaRoomX + megaman.width / 2 > Game.WINDOW_WIDTH )
					{
						setCameraRoom(cameraRoomX + 1, cameraRoomY);
					}
					if( megaRoomX + megaman.width / 2 < 0 )
					{
						setCameraRoom(cameraRoomX - 1, cameraRoomY);
					}
					if( megaRoomY + megaman.health / 2 > Game.WINDOW_HEIGHT )
					{
						setCameraRoom(cameraRoomX, cameraRoomY + 1);
					}
					if( megaRoomY + megaman.health / 2 < 0 )
					{
						setCameraRoom(cameraRoomX, cameraRoomY - 1);
					}
				}
				else
				{
					megaman.active = false;
					megaman.velocity.y = 0;
					
					if(cameraEventualX != FlxG.camera.scroll.x || cameraEventualY != FlxG.camera.scroll.y)
					{
						var diffX:int = cameraEventualX - FlxG.camera.scroll.x;
						var diffY:int = cameraEventualY - FlxG.camera.scroll.y;
						
						var mag:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
						
						var unitX:Number = 0;
						var unitY:Number = 0;
						if ( mag > 0 ) // should be greater unless x/y are both 0.
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
			}
			
			FlxG.camera.update();
			
			// update world bounds so collisions only happen on this screen
			FlxG.worldBounds.x = FlxG.camera.scroll.x;
			FlxG.worldBounds.y = FlxG.camera.scroll.y;
			FlxG.worldBounds.width = FlxG.camera.scroll.x + FlxG.width;
			FlxG.worldBounds.height = FlxG.camera.scroll.y + FlxG.height;
		}
	}
}
