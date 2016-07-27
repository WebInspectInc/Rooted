package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class HUD extends FlxSpriteGroup {
	private var _playerHealth:FlxText;
	static inline var OFFSET:Int = 4;

	public function new() {
		super();

		_playerHealth = new FlxText(OFFSET, OFFSET, 0);
		add(_playerHealth);

		_playerHealth.scrollFactor = FlxPoint.get(0, 0);
	}

	override public function update(elapsed:Float) {
		_playerHealth.text = "HEALTH\n" + Reg.health;
		super.update(elapsed);
	}
}