package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.addons.editors.tiled.TiledObject;
import states.PlayState;

class Door extends FlxSprite {
	public var door:TiledObject;
	public function new(doorObj:TiledObject) {
		door = doorObj;
		super(door.x, door.y - 32);

		loadGraphic(AssetPaths.tinytiles__png, true, 32, 32);
		animation.add("closed", [182], 12);
		animation.play("closed");
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function interact(player:Player, state:PlayState) {
		var newLevel = door.properties.get('new_area');

		state.playLevel('level1');
	}
}