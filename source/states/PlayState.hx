package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import states.HUD;
import objects.Player;
import objects.Enemy;
import objects.Door;
import objects.HiddenSpike;
import objects.FallingBlock;
import utils.LevelLoader;

class PlayState extends FlxState
{
	private var _hud:HUD;

	public var map:FlxTilemap;
	public var player:Player;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	public var spikes(default, null):FlxTypedGroup<HiddenSpike>;
	public var blocks(default, null):FlxTypedGroup<FallingBlock>;
	public var fallingBlocks(default, null):FlxTypedGroup<FallingBlock>;
	public var doors(default, null):FlxTypedGroup<Door>;

	public var currentLevel:String;
	override public function create():Void
	{
		super.create();
		playLevel('main');
	}

	public function playLevel(levelName:String):Void {
		_hud = new HUD();

		player = new Player();
		enemies = new FlxTypedGroup<Enemy>();
		doors = new FlxTypedGroup<Door>();
		spikes = new FlxTypedGroup<HiddenSpike>();
		blocks = new FlxTypedGroup<FallingBlock>();

		LevelLoader.load(this, levelName);
		currentLevel = levelName;

		add(enemies);
		add(spikes);
		add(blocks);
		add(player);
		add(doors);

		add(_hud);

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
	}

	override public function update(elapsed:Float):Void
	{
		player.noRoot = false;
		FlxG.collide(map, player);
		FlxG.overlap(enemies, player, collideEnemies);
		FlxG.overlap(doors, player, collideDoors);
		FlxG.overlap(spikes, player, collideSpikes);
		FlxG.overlap(blocks, player, collideBlock);

		FlxG.collide(map, enemies);

		if (player.alive == false) {
			playLevel(currentLevel);
		}

		super.update(elapsed);
	}

	function collideEnemies(enemy:Enemy, player:Player):Void {
		enemy.interact(player);
	}

	function collideDoors(door:Door, player:Player):Void {
		door.interact(player, this);
	}

	function collideSpikes(spike:HiddenSpike, player:Player):Void {
		spike.interact(player);
	}

	function collideBlock(block:FallingBlock, player:Player):Void {
		block.interact(player);
	}
}
