package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.addons.editors.tiled.TiledObject;

class Door extends FlxSprite {
	public var door:TiledObject;
	public function new(doorObj:TiledObject) {
		door = doorObj;
		super(door.x, door.y);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function interact(player:Player) {
		var newLevel = door.properties.get('new_area');

		Reg.log = newLevel;
	}
}