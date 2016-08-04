package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;

class HUD extends FlxSpriteGroup {
	private var _playerHealth:FlxBar;
	private var _rootTime:FlxBar;
	private var _debug:FlxText;
	static inline var OFFSET:Int = 4;

	public function new() {
		super();

		//_playerHealth = new FlxText(OFFSET, OFFSET, 0);
		_playerHealth = new FlxBar(OFFSET, OFFSET, LEFT_TO_RIGHT, Reg.health, 6, Reg, 'health');
		add(_playerHealth);

		//_rootTime = new FlxText(FlxG.width * 0.33, OFFSET, 0);
		_rootTime = new FlxBar(OFFSET, OFFSET*3, LEFT_TO_RIGHT, Reg.rootTime, 6, Reg, 'rootTime');
		add(_rootTime);

		_debug = new FlxText(FlxG.width * 0.5, FlxG.height * 0.8, 0);
		add(_debug);

		_playerHealth.scrollFactor = FlxPoint.get(0, 0);
		_rootTime.scrollFactor = FlxPoint.get(0, 0);
		_debug.scrollFactor = FlxPoint.get(0, 0);
	}

	override public function update(elapsed:Float) {
		//_playerHealth.text = "HEALTH\n" + Reg.health;
		//_rootTime.text = "ROOT TIME\n" + Reg.rootTime;
		_debug.text = Reg.log;
		super.update(elapsed);
	}
}