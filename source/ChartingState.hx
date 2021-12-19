package;

import openfl.media.SoundChannel;
import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

using StringTools;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	var UI_box:FlxUITabMenu;

	/**
	 * Array of notes showing when each section STARTS in STEPS
	 * Usually rounded up??
	 */
	var curSection:Int = 0;

	var timeOld:Float = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var player1DropDown:FlxUIDropDownMenu;
	var player2DropDown:FlxUIDropDownMenu;
	var gfDropDown:FlxUIDropDownMenu;
	var stageDropDown:FlxUIDropDownMenu;
	var diffList:Array<String> = ["-easy", "", "-hard"];
	var diffDropFinal:String = "";
	var bfClick:FlxUICheckBox;
	var opClick:FlxUICheckBox;
	var gotoSectionStepper:FlxUINumericStepper;
	//var halfSpeedCheck:FlxUICheckBox;

	var strumLine:FlxSprite;
	var curSong:String = 'Dadbattle';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;

	var strumColors:Array<FlxColor> = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F, 0xFFCCCCCC, 0xFFFFFF00, 0xFF8B4AFF, 0xFFFF0000, 0xFF0033FF];

	var highlight:FlxSprite;

	var GRID_SIZE:Int = 40;
	//var TRIPLE_GRID_SIZE:Float = 40 * 4/3;

	var dummyArrow:FlxSprite;
	var holding:Bool;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;
	var gridBG2:FlxSprite;
	var gridBGTriple:FlxSprite;
	var gridBGOverlay:FlxSprite;

	var gridBlackLine:FlxSprite;

	var _song:SwagSong;

	var typingShit:FlxInputText;
	/*
	 * WILL BE THE CURRENT / LAST PLACED NOTE
	**/
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Float = 0;

	var vocals:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;
	var keyAmmo:Array<Int> = [4, 6, 9, 7];

	var leftIconBack:FlxSprite;
	var rightIconBack:FlxSprite;
	
	var justChanged:Bool;

	override function create()
	{

		openfl.Lib.current.stage.frameRate = 120;

		var controlInfo = new FlxText(10, 30, 0, "LEFT CLICK - Place Notes\nRIGHT CLICK - Delete Notes\nMIDDLE CLICK - Reselect a note.\n\nSHIFT - Unlock cursor from grid\nALT - Triplets\nCONTROL - 1/32 Notes\nSHIFT + CONTROL - 1/64 Notes\n\nTAB - Place notes on both sides\nHJKL - Place notes during\n                       playback\n\nR - Top of section\nSHIFT + R - Song start\n\nENTER - Test chart.\nCTRL + ENTER - Test chart from\n                         current section.\nPERIOD to zoom in\n COMMA to zoom out", 12);
		controlInfo.scrollFactor.set();
		add(controlInfo);

		lastSection = 0;

		var gridBG2Length = 4;

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);

		gridBGTriple = FlxGridOverlay.create(GRID_SIZE, Std.int(GRID_SIZE * 4/3), GRID_SIZE * 8, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
		gridBGTriple.visible = false;

		gridBG2 = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16 * gridBG2Length, true, 0xFF515151, 0xFF3D3D3D);

		gridBGOverlay = FlxGridOverlay.create(GRID_SIZE * 4, GRID_SIZE * 4, GRID_SIZE * 8, GRID_SIZE * 16 * gridBG2Length, true, 0xFFFFFFFF, 0xFFB5A5CE);
		gridBGOverlay.blend = "multiply";

		add(gridBG2);
		add(gridBG);
		add(gridBGTriple);
		add(gridBGOverlay);
		

		leftIcon = new HealthIcon('bf');
		rightIcon = new HealthIcon('dad');

		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.iconScale = 0.5;
		rightIcon.iconScale = 0.5;

		leftIcon.setPosition((gridBG.width / 4) - (leftIcon.width / 4), -75);
		rightIcon.setPosition((gridBG.width / 4) * 3 - (rightIcon.width / 4), -75);

		leftIconBack = new FlxSprite(leftIcon.x - 2.5, leftIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
		rightIconBack = new FlxSprite(rightIcon.x - 2.5, rightIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
		
		add(leftIconBack);
		add(rightIconBack);
		add(leftIcon);
		add(rightIcon);

		gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG2.height), FlxColor.BLACK);
		add(gridBlackLine);

		for(i in 1...gridBG2Length){

			var gridSectionLine:FlxSprite = new FlxSprite(gridBG.x, gridBG.y + (gridBG.height * i)).makeGraphic(Std.int(gridBG2.width), 2, FlxColor.BLACK);
			add(gridSectionLine);

		}

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null)
			_song = PlayState.SONG;
		else
		{
			_song = {
				song: 'Test',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				stage: 'stage',
				gf: 'gf',
				speed: 1,
				validScore: false,
				mania: 0
			};
		}

		for(x in _song.notes){
			if(!x.changeBPM)
				x.bpm = 0;
		}

		FlxG.mouse.visible = true;
		FlxG.save.bind(_song.song.replace(" ", "-"), "Chart Editor Autosaves");

		tempBpm = _song.bpm;

		addSection();

		// sections = _song.notes;

		updateGrid();

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		strumLine = new FlxSprite(0, 100).makeGraphic(Std.int(FlxG.width / 2), 4, 0xFF0000FF);
		add(strumLine);

		var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'},
			{name: "Tools", label: 'Tools'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);

		addSongUI();
		addSectionUI();
		addNoteUI();
		addToolsUI();
		updateHeads();

		add(curRenderedNotes);
		add(curRenderedSustains);

		for(i in 0..._song.notes.length){
			removeDuplicates(i);
		}

		super.create();
	}

	function addSongUI():Void
	{
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var saveButton:FlxButton = new FlxButton(110, 8, "Save", function()
		{
			saveLevel();
		});

		var saveGenericButton:FlxButton = new FlxButton(110, saveButton.y + 30, "Save Generic", function()
		{
			saveGenericLevel();
		});

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function()
		{
			loadSong(_song.song);
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function()
		{
			loadJson(_song.song.toLowerCase());
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);

		var fullreset:FlxButton = new FlxButton(10, 150, "Full Blank", function()
		{
			var song_name = _song.song;

			PlayState.SONG = {
				song: song_name,
				notes: [],
				bpm: 120.0,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				stage: 'stage',
				gf: 'gf',
				speed: 1,
				validScore: false,
				mania: 0
			};

			FlxG.resetState();
		});

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 70, 0.1, 1, 0.1, 25, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 50, 1, 1, 1, 999, 2);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.text("characterList"));
		var gfs:Array<String> = CoolUtil.coolTextFile(Paths.text("gfList"));
		var stages:Array<String> = CoolUtil.coolTextFile(Paths.text("stageList"));

		player1DropDown = new FlxUIDropDownMenu(10, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player1 = characters[Std.parseInt(character)];
			updateHeads();
		});
		player1DropDown.selectedLabel = _song.player1;

		player2DropDown = new FlxUIDropDownMenu(140, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
			updateHeads();
		});

		player2DropDown.selectedLabel = _song.player2;

		var diffDrop:FlxUIDropDownMenu = new FlxUIDropDownMenu(10, 160, FlxUIDropDownMenu.makeStrIdLabelArray(["Easy", "Normal", "Hard"], true), function(diff:String)
		{
			trace(diff);
			diffDropFinal = diffList[Std.parseInt(diff)];
			
		});

		gfDropDown = new FlxUIDropDownMenu(10, 130, FlxUIDropDownMenu.makeStrIdLabelArray(gfs, true), function(gf:String)
			{
				_song.gf = gfs[Std.parseInt(gf)];
			});
		gfDropDown.selectedLabel = _song.gf;
		
		stageDropDown = new FlxUIDropDownMenu(140, 130, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(selStage:String)
			{
				_song.stage = stages[Std.parseInt(selStage)];
			});
		stageDropDown.selectedLabel = _song.stage;
		
		diffDrop.selectedLabel = "Normal";

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";

		tab_group_song.add(UI_songTitle);
		tab_group_song.add(saveButton);
		tab_group_song.add(saveGenericButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(diffDrop);
		tab_group_song.add(gfDropDown);
		tab_group_song.add(stageDropDown);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(player2DropDown);
		

		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();

		FlxG.camera.follow(strumLine);
	}

	function addToolsUI():Void
		{
			gotoSectionStepper = new FlxUINumericStepper(10, 400, 1, 0, 0, 999, 0);
			gotoSectionStepper.name = 'gotoSection';
	
			var gotoSectionButton:FlxButton = new FlxButton(gotoSectionStepper.x, gotoSectionStepper.y + 20, "Go to Section", function()
			{
				changeSection(Std.int(gotoSectionStepper.value), true);
				gotoSectionStepper.value = 0;
			});
	
			var check_mute_inst = new FlxUICheckBox(10, 10, null, null, "Mute Instrumental (in editor)", 100);
			check_mute_inst.checked = false;
			check_mute_inst.callback = function()
			{
				var vol:Float = 1;
	
				if (check_mute_inst.checked)
					vol = 0;
	
				FlxG.sound.music.volume = vol;
			};
	
			bfClick = new FlxUICheckBox(10, 30, null, null, "BF Note Click", 100);
			bfClick.checked = false;

			opClick = new FlxUICheckBox(10, 50, null, null, "Opp Note Click", 100);
			opClick.checked = false;
	
			//halfSpeedCheck = new FlxUICheckBox(10, 170, null, null, "Half Speed", 100);
			//halfSpeedCheck.checked = false;
	
			var tab_group_tools = new FlxUI(null, UI_box);
			tab_group_tools.name = "Tools";
	
			tab_group_tools.add(gotoSectionStepper);
			tab_group_tools.add(gotoSectionButton);
			tab_group_tools.add(check_mute_inst);
			tab_group_tools.add(bfClick);
			tab_group_tools.add(opClick);
			
	
			UI_box.addGroup(tab_group_tools);
			UI_box.scrollFactor.set();
	
			FlxG.camera.follow(strumLine);
		}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";

		stepperSectionBPM = new FlxUINumericStepper(10, 80, 1, 0, 0, 999, 0);
		stepperSectionBPM.value = _song.notes[0].bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 130, 1, 1, -999, 999, 0);

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last section", function()
		{
			copySection(Std.int(stepperCopy.value));
		});

		var clearSectionButton:FlxButton = new FlxButton(10, 150, "Clear", clearSection);
		
		var clearSectionOppButton:FlxButton = new FlxButton(110, 150, "Clear Opp", clearSectionOpp);

		var clearSectionBFButton:FlxButton = new FlxButton(210, 150, "Clear BF", clearSectionBF);

		var swapSection:FlxButton = new FlxButton(10, 170, "Swap section", swapSections);

		var blankButton:FlxButton = new FlxButton(10, 300, "Full Clear", function()
		{

			for(x in 0..._song.notes.length){
				_song.notes[x].sectionNotes = [];
			}
			
			updateGrid();
		});

		//Flips BF Notes
		var bSideButton:FlxButton = new FlxButton(10, 200, "Flip BF Notes", function()
		{
			var flipTable:Array<Int> = [3, 2, 1, 0, 7, 6, 5, 4];

			//[noteStrum, noteData, noteSus]
			for(x in _song.notes[curSection].sectionNotes){
				if(_song.notes[curSection].mustHitSection){
					if(x[1] < 4)
						x[1] = flipTable[x[1]];
				}
				else{
					if(x[1] > 3)
						x[1] = flipTable[x[1]];
				}
			}
			
			updateGrid();
		});
		
		//Flips Opponent Notes
		var bSideButton2:FlxButton = new FlxButton(10, 220, "Flip Opp Notes", function()
		{
			var flipTable:Array<Int> = [3, 2, 1, 0, 7, 6, 5, 4];

			//[noteStrum, noteData, noteSus]
			for(x in _song.notes[curSection].sectionNotes){
				if(_song.notes[curSection].mustHitSection){
					if(x[1] > 3)
						x[1] = flipTable[x[1]];
				}
				else{
					if(x[1] < 4)
						x[1] = flipTable[x[1]];
				}
			}
			
			updateGrid();
		});

		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Must hit section", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = _song.notes[0].mustHitSection;
		// _song.needsVoices = check_mustHit.checked;

		check_altAnim = new FlxUICheckBox(10, 400, null, null, "Alt Animation", 100);
		check_altAnim.name = 'check_altAnim';

		check_changeBPM = new FlxUICheckBox(10, 60, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		//tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(clearSectionOppButton);
		tab_group_section.add(clearSectionBFButton);
		tab_group_section.add(swapSection);
		tab_group_section.add(blankButton);
		tab_group_section.add(bSideButton);
		tab_group_section.add(bSideButton2);

		UI_box.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;

	function addNoteUI():Void
	{
		var tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16 * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var applyLength:FlxButton = new FlxButton(100, 10, 'Apply');
		var ammolabel = new FlxText(10,35,64,'Amount of Keys');

		var m_check = new FlxButton(10, 85,"6",function()
		{
			_song.mania = 1;
			updateGrid();
			trace('6 Keys pog');
		});
		var m_check2 = new FlxButton(10, 125,"9",function()
		{
			_song.mania = 2;
			updateGrid();
			trace('9 Keys pog');
		});
		var m_check3 = new FlxButton(10, 105,"7",function()
		{
			_song.mania = 3;
			updateGrid();
			trace('7 Keys pog');
		});		
		var m_check0 = new FlxButton(10, 65,"4", function()
		{
			_song.mania = 0;
			updateGrid();
			trace('4 keys cringe');
		});

		tab_group_note.add(stepperSusLength);
		tab_group_note.add(applyLength);
		tab_group_note.add(ammolabel);
		tab_group_note.add(m_check0);
		tab_group_note.add(m_check);
		tab_group_note.add(m_check3);
		tab_group_note.add(m_check2);

		UI_box.addGroup(tab_group_note);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			// vocals.stop();
		}

		FlxG.sound.playMusic(Paths.music(daSong + "_Inst"), 0.6);

		// WONT WORK FOR TUTORIAL OR TEST SONG!!! REDO LATER
		vocals = new FlxSound().loadEmbedded(Paths.music(daSong + "_Voices"));
		FlxG.sound.list.add(vocals);

		FlxG.sound.music.pause();
		vocals.play();
		vocals.pause();
		vocals.time = FlxG.sound.music.time;

		FlxG.sound.music.onComplete = function()
		{
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
		{
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		// general shit
		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
		/* 
			var loopCheck = new FlxUICheckBox(UI_box.x + 10, UI_box.y + 50, null, null, "Loops", 100, ['loop check']);
			loopCheck.checked = curNoteSelected.doesLoop;
			tooltips.add(loopCheck, {title: 'Section looping', body: "Whether or not it's a simon says style section", style: tooltipType});
			bullshitUI.add(loopCheck);
		 */
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Must hit section':
					
					_song.notes[curSection].mustHitSection = check.checked;
					updateHeads();
					swapSections();

				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alt Animation":
					_song.notes[curSection].altAnim = check.checked;
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			if (wname == 'section_length')
			{
				_song.notes[curSection].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				tempBpm = nums.value;
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(nums.value);
			}
			else if (wname == 'note_susLength')
			{
				curSelectedNote[2] = nums.value;
				updateGrid();
				autosaveSong();
			}
			else if (wname == 'section_bpm')
			{
				Conductor.mapBPMChanges(_song);
				_song.notes[curSection].bpm = nums.value;
				updateGrid();
				autosaveSong();
			}
			else if (wname == 'check_changeBPM')
			{
				Conductor.mapBPMChanges(_song);
				_song.notes[curSection].bpm = nums.value;
				updateGrid();
				autosaveSong();
			}
		}
	}

	var updatedSection:Bool = false;

	/* this function got owned LOL
		function lengthBpmBullshit():Float
		{
			if (_song.notes[curSection].changeBPM)
				return _song.notes[curSection].lengthInSteps * (_song.notes[curSection].bpm / _song.bpm);
			else
				return _song.notes[curSection].lengthInSteps;
	}*/
	function sectionStartTime():Float
	{
		var daBPM:Float = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection)
		{
			if (_song.notes[i].changeBPM)
			{
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	override function update(elapsed:Float)
	{
		if (_song.mania == 0 && gridBG.width != GRID_SIZE * 8)
		{
			remove(leftIconBack);
			remove(rightIconBack);
			remove(leftIcon);
			remove(rightIcon);
			remove(gridBG2);
			remove(gridBG);
			remove(gridBGTriple);
			remove(gridBGOverlay);
			remove(gridBlackLine);
			var gridBG2Length = 4;

			gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
	
			gridBGTriple = FlxGridOverlay.create(GRID_SIZE, Std.int(GRID_SIZE * 4/3), GRID_SIZE * 8, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
			gridBGTriple.visible = false;
	
			gridBG2 = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16 * gridBG2Length, true, 0xFF515151, 0xFF3D3D3D);
	
			gridBGOverlay = FlxGridOverlay.create(GRID_SIZE * 4, GRID_SIZE * 4, GRID_SIZE * 8, GRID_SIZE * 16 * gridBG2Length, true, 0xFFFFFFFF, 0xFFB5A5CE);
			gridBGOverlay.blend = "multiply";

			leftIcon = new HealthIcon('bf');
			rightIcon = new HealthIcon('dad');
	
			leftIcon.scrollFactor.set(1, 1);
			rightIcon.scrollFactor.set(1, 1);
	
			leftIcon.iconScale = 0.5;
			rightIcon.iconScale = 0.5;
	
			leftIcon.setPosition((gridBG.width / 4) - (leftIcon.width / 4), -75);
			rightIcon.setPosition((gridBG.width / 4) * 3 - (rightIcon.width / 4), -75);
	
			leftIconBack = new FlxSprite(leftIcon.x - 2.5, leftIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
			rightIconBack = new FlxSprite(rightIcon.x - 2.5, rightIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
			
			gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG2.height), FlxColor.BLACK);
			add(leftIconBack);
			add(rightIconBack);
			add(leftIcon);
			add(rightIcon);
			add(gridBG2);
			add(gridBG);
			add(gridBGTriple);
			add(gridBGOverlay);
			updateGrid();
			updateSectionUI();
			add(gridBlackLine);
			UI_box.x = FlxG.width / 2;// + 160 * _song.mania;
			UI_box.y = 20;
		}
		if (_song.mania == 1 && gridBG.width != GRID_SIZE * 12)
			{
				remove(leftIconBack);
				remove(rightIconBack);
				remove(leftIcon);
				remove(rightIcon);
				remove(gridBG2);
				remove(gridBG);
				remove(gridBGTriple);
				remove(gridBGOverlay);
				remove(gridBlackLine);
				var gridBG2Length = 4;
	
				gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 12, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
		
				gridBGTriple = FlxGridOverlay.create(GRID_SIZE, Std.int(GRID_SIZE * 4/3), GRID_SIZE * 12, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
				gridBGTriple.visible = false;
		
				gridBG2 = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 12, GRID_SIZE * 16 * gridBG2Length, true, 0xFF515151, 0xFF3D3D3D);
		
				gridBGOverlay = FlxGridOverlay.create(GRID_SIZE * 6, GRID_SIZE * 6, GRID_SIZE * 12, GRID_SIZE * 16 * gridBG2Length, true, 0xFFFFFFFF, 0xFFB5A5CE);
				gridBGOverlay.blend = "multiply";
		

				leftIcon = new HealthIcon('bf');
				rightIcon = new HealthIcon('dad');
		
				leftIcon.scrollFactor.set(1, 1);
				rightIcon.scrollFactor.set(1, 1);
		
				leftIcon.iconScale = 0.5;
				rightIcon.iconScale = 0.5;
		
				leftIcon.setPosition((gridBG.width / 4) - (leftIcon.width / 4), -75);
				rightIcon.setPosition((gridBG.width / 4) * 3 - (rightIcon.width / 4), -75);
		
				leftIconBack = new FlxSprite(leftIcon.x - 2.5, leftIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
				rightIconBack = new FlxSprite(rightIcon.x - 2.5, rightIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);

				gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG2.height), FlxColor.BLACK);
				add(leftIconBack);
				add(rightIconBack);
				add(leftIcon);
				add(rightIcon);
				add(gridBG2);
				add(gridBG);
				add(gridBGTriple);
				add(gridBGOverlay);
				updateGrid();
				updateSectionUI();
				add(gridBlackLine);
				UI_box.x = FlxG.width / 2 + 160;// + 160 * _song.mania;
				UI_box.y = 100;
			}
		if (_song.mania == 2 && gridBG.width != GRID_SIZE * 18)
			{
				remove(leftIconBack);
				remove(rightIconBack);
				remove(leftIcon);
				remove(rightIcon);
				remove(gridBG2);
				remove(gridBG);
				remove(gridBGTriple);
				remove(gridBGOverlay);
				remove(gridBlackLine);
				var gridBG2Length = 4;
	
				gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 18, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
		
				gridBGTriple = FlxGridOverlay.create(GRID_SIZE, Std.int(GRID_SIZE * 4/3), GRID_SIZE * 18, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
				gridBGTriple.visible = false;
		
				gridBG2 = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 18, GRID_SIZE * 18 * gridBG2Length, true, 0xFF515151, 0xFF3D3D3D);
		
				gridBGOverlay = FlxGridOverlay.create(GRID_SIZE * 9, GRID_SIZE * 9, GRID_SIZE * 18, GRID_SIZE * 16 * gridBG2Length, true, 0xFFFFFFFF, 0xFFB5A5CE);
				gridBGOverlay.blend = "multiply";
		

				leftIcon = new HealthIcon('bf');
				rightIcon = new HealthIcon('dad');
		
				leftIcon.scrollFactor.set(1, 1);
				rightIcon.scrollFactor.set(1, 1);
		
				leftIcon.iconScale = 0.5;
				rightIcon.iconScale = 0.5;
		
				leftIcon.setPosition((gridBG.width / 4) - (leftIcon.width / 4), -75);
				rightIcon.setPosition((gridBG.width / 4) * 3 - (rightIcon.width / 4), -75);
		
				leftIconBack = new FlxSprite(leftIcon.x - 2.5, leftIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
				rightIconBack = new FlxSprite(rightIcon.x - 2.5, rightIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);

				gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG2.height), FlxColor.BLACK);
				add(leftIconBack);
				add(rightIconBack);
				add(leftIcon);
				add(rightIcon);
				add(gridBG2);
				add(gridBG);
				add(gridBGTriple);
				add(gridBGOverlay);
				updateGrid();
				updateSectionUI();
				add(gridBlackLine);
				UI_box.x = FlxG.width / 2 + 340;
				UI_box.y = 230;
			}
		if (_song.mania == 3 && gridBG.width != GRID_SIZE * 14)
			{
				remove(leftIconBack);
				remove(rightIconBack);
				remove(leftIcon);
				remove(rightIcon);
				remove(gridBG2);
				remove(gridBG);
				remove(gridBGTriple);
				remove(gridBGOverlay);
				remove(gridBlackLine);
				var gridBG2Length = 4;
	
				gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 14, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
		
				gridBGTriple = FlxGridOverlay.create(GRID_SIZE, Std.int(GRID_SIZE * 4/3), GRID_SIZE * 14, GRID_SIZE * 16, true, 0xFFE7E7E7, 0xFFC5C5C5);
				gridBGTriple.visible = false;
		
				gridBG2 = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 14, GRID_SIZE * 14 * gridBG2Length, true, 0xFF515151, 0xFF3D3D3D);
		
				gridBGOverlay = FlxGridOverlay.create(GRID_SIZE * 7, GRID_SIZE * 7, GRID_SIZE * 14, GRID_SIZE * 16 * gridBG2Length, true, 0xFFFFFFFF, 0xFFB5A5CE);
				gridBGOverlay.blend = "multiply";
		

				leftIcon = new HealthIcon('bf');
				rightIcon = new HealthIcon('dad');
		
				leftIcon.scrollFactor.set(1, 1);
				rightIcon.scrollFactor.set(1, 1);
		
				leftIcon.iconScale = 0.5;
				rightIcon.iconScale = 0.5;
		
				leftIcon.setPosition((gridBG.width / 4) - (leftIcon.width / 4), -75);
				rightIcon.setPosition((gridBG.width / 4) * 3 - (rightIcon.width / 4), -75);
		
				leftIconBack = new FlxSprite(leftIcon.x - 2.5, leftIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);
				rightIconBack = new FlxSprite(rightIcon.x - 2.5, rightIcon.y - 2.5).makeGraphic(75, 75, 0xFF00AAFF);

				gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG2.height), FlxColor.BLACK);
				add(leftIconBack);
				add(rightIconBack);
				add(leftIcon);
				add(rightIcon);
				add(gridBG2);
				add(gridBG);
				add(gridBGTriple);
				add(gridBGOverlay);
				updateGrid();
				updateSectionUI();
				add(gridBlackLine);
				UI_box.x = FlxG.width / 2 + 220;// + 160 * _song.mania;
				UI_box.y = 100;
			}																		

			// UI_box.x = FlxG.width / 2 + 160;// + 160 * _song.mania;
			// UI_box.y = 100;
			gridBG2.y = gridBG.y - gridBG.height;
			gridBGTriple.y = gridBG.y + gridBG.height;
			gridBG2.alpha = 0.7;
			gridBGTriple.alpha = 0.7;			
		curStep = recalculateSteps();

		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingShit.text;

		strumLine.y = getYfromStrum(Conductor.songPosition - sectionStartTime());

		if (curStep >= 16 * (curSection + 1) && FlxG.sound.music.playing)
		{
			trace(curStep);
			trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSection + 1] == null)
			{
				addSection();
			}

			changeSection(curSection + 1, false);
		}

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);

		if (FlxG.keys.justPressed.PERIOD)
			{
				GRID_SIZE += 5;
			}
	
			if (FlxG.keys.justPressed.COMMA)
			{
				GRID_SIZE -= 5;
			}

		if (FlxG.mouse.justPressed)
		{

			if (FlxG.mouse.x > gridBG.x
				&& FlxG.mouse.x < gridBG.x + gridBG.width
				&& FlxG.mouse.y > gridBG.y
				&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
			{
				FlxG.log.add('added note');
				addNote(getStrumTime(dummyArrow.y) + sectionStartTime(), Math.floor(FlxG.mouse.x / GRID_SIZE));
				holding = true;

			}

		}

		if (FlxG.mouse.justPressedRight)
		{

			if (FlxG.mouse.overlaps(curRenderedNotes))
			{

				trace("Overlapping Notes");

				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note))
					{
						deleteNote(note);
					}
				});
			}
		}

		if (FlxG.mouse.justPressedMiddle)
		{

			if (FlxG.mouse.overlaps(curRenderedNotes))
			{

				trace("Overlapping Notes");

				var selected:Bool = false;

				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note) && !selected)
					{
						selectNote(note);
						selected = true;

					}
				});
			}
		}

		if(holding && FlxG.mouse.pressed){

			setNoteSustain((getStrumTime(dummyArrow.y) + sectionStartTime()) - curSelectedNote[0]);

		}
		else{

			holding = false;

		}

		if(curSection * 16 != curStep && curStep % 16 == 0 && FlxG.sound.music.playing){

			if(curSection * 16 > curStep){
				changeSection(curSection - 1, false);
			}
			else if(curSection * 16 < curStep){
				changeSection(curSection + 1, false);
			}
		}

		if(FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.Z){

		}

		if (FlxG.mouse.x > gridBG.x
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;

			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT)
				dummyArrow.y = Math.floor(FlxG.mouse.y / (GRID_SIZE / 4)) * (GRID_SIZE / 4);
			else if (FlxG.keys.pressed.SHIFT)
				dummyArrow.y = FlxG.mouse.y;
			else if (FlxG.keys.pressed.ALT)
				dummyArrow.y = Math.floor(FlxG.mouse.y / (GRID_SIZE * 4/3)) * (GRID_SIZE * 4/3);
			else if (FlxG.keys.pressed.CONTROL)
				dummyArrow.y = Math.floor(FlxG.mouse.y / (GRID_SIZE / 2)) * (GRID_SIZE / 2);
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			PlayState.SONG = _song;
			FlxG.sound.music.stop();
			vocals.stop();

			FlxG.save.bind('data');

			PlayState.sectionStart = false;
			if(FlxG.keys.pressed.CONTROL && curSection > 0){
				PlayState.sectionStart = true;
				changeSection(curSection, true);
				PlayState.sectionStartPoint = curSection;
				PlayState.sectionStartTime = FlxG.sound.music.time - (sectionHasBfNotes(curSection) ? Conductor.crochet : 0);
			}

			switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.E)
		{
			changeNoteSustain(Conductor.stepCrochet);
		}
		if (FlxG.keys.justPressed.Q)
		{
			changeNoteSustain(-Conductor.stepCrochet);
		}

		/*if (FlxG.keys.justPressed.TAB)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				UI_box.selected_tab -= 1;
				if (UI_box.selected_tab < 0)
					UI_box.selected_tab = 2;
			}
			else
			{
				UI_box.selected_tab += 1;
				if (UI_box.selected_tab >= 3)
					UI_box.selected_tab = 0;
			}
		}*/

		if (!typingShit.hasFocus)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.pause();
					vocals.pause();
				}
				else
				{
					vocals.play();
					FlxG.sound.music.play();
				}
			}

			if (FlxG.keys.justPressed.R)
			{
				if (FlxG.keys.pressed.SHIFT)
					resetSection(true);
				else
					resetSection();
			}

			if (FlxG.mouse.wheel != 0)
			{
				// && strumLine.y > gridBG.y)
				var wheelSpin = FlxG.mouse.wheel;

				FlxG.sound.music.pause();
				vocals.pause();

				if(wheelSpin > 0 && strumLine.y < gridBG.y)
					wheelSpin = 0;

				if(wheelSpin < 0 && strumLine.y > gridBG2.y + gridBG2.height)
					wheelSpin = 0;
					

				FlxG.sound.music.time -= (wheelSpin * Conductor.stepCrochet * 0.4);

				/*while(strumLine.y < gridBG.y){
					FlxG.sound.music.time += 1;
					Conductor.songPosition = FlxG.sound.music.time;
					strumLine.y = getYfromStrum(Conductor.songPosition - sectionStartTime());
				}
				while(strumLine.y > gridBG2.y + gridBG2.height){
					FlxG.sound.music.time -= 1;
					Conductor.songPosition = FlxG.sound.music.time;
					strumLine.y = getYfromStrum(Conductor.songPosition - sectionStartTime());
				}*/

				vocals.time = FlxG.sound.music.time;
				
			}

			if (!FlxG.keys.pressed.SHIFT)
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S || FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = 1000 * FlxG.elapsed;

					if ((FlxG.keys.pressed.W || FlxG.keys.pressed.UP) && strumLine.y > gridBG.y)
					{
						FlxG.sound.music.time -= daTime;
					}
					else if (strumLine.y < gridBG2.y + gridBG2.height)
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
			else
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S || FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = 2500 * FlxG.elapsed;

					if ((FlxG.keys.pressed.W || FlxG.keys.pressed.UP) && strumLine.y > gridBG.y)
					{
						FlxG.sound.music.time -= daTime;
					}
					else if (strumLine.y < gridBG2.y + gridBG2.height)
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
		}

		_song.bpm = tempBpm;

		var shiftThing:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftThing = 4;
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
			changeSection(curSection + shiftThing);
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
			changeSection(curSection - shiftThing);

		bpmTxt.text = bpmTxt.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition, 0))
			+ "\t/ " + Std.string(FlxMath.roundDecimal(FlxG.sound.music.length, 0))
			+ "\n" + Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ "\t/ " + Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\nSection: " + curSection
			+ "\ncurBeat: " + curBeat
			+ "\ncurStep: " + curStep;

// || FlxG.keys.justPressed.X  || FlxG.keys.justPressed.C || FlxG.keys.justPressed.V
		if(FlxG.sound.music.playing){

			if(FlxG.keys.justPressed.H)
				addNote(getStrumTime(Math.floor((strumLine.y + strumLine.height) / GRID_SIZE) * GRID_SIZE) + sectionStartTime(), 0 + (_song.notes[curSection].mustHitSection ? 4 : 0));

			if(FlxG.keys.justPressed.J)
				addNote(getStrumTime(Math.floor((strumLine.y + strumLine.height) / GRID_SIZE) * GRID_SIZE) + sectionStartTime(), 1 + (_song.notes[curSection].mustHitSection ? 4 : 0));

			if(FlxG.keys.justPressed.K)
				addNote(getStrumTime(Math.floor((strumLine.y + strumLine.height) / GRID_SIZE) * GRID_SIZE) + sectionStartTime(), 2 + (_song.notes[curSection].mustHitSection ? 4 : 0));

			if(FlxG.keys.justPressed.L)
				addNote(getStrumTime(Math.floor((strumLine.y + strumLine.height) / GRID_SIZE) * GRID_SIZE) + sectionStartTime(), 3 + (_song.notes[curSection].mustHitSection ? 4 : 0));

		}

		if((bfClick.checked || opClick.checked) && !justChanged){
			curRenderedNotes.forEach(function(x:Note) {

				if(x.absoluteNumber < 4 && _song.notes[curSection].mustHitSection){
					x.editorBFNote = true;
				}
				else if(x.absoluteNumber > 3 && !_song.notes[curSection].mustHitSection){
					x.editorBFNote = true;
				}
				
				if(x.y < strumLine.y && !x.playedEditorClick && FlxG.sound.music.playing){
					if(x.editorBFNote && bfClick.checked)
						FlxG.sound.play(Paths.sound("tick"), 0.6);
					else if(!x.editorBFNote && opClick.checked)
						FlxG.sound.play(Paths.sound("tick"), 0.6);
				}

				if(x.y > strumLine.y && x.alpha != 0.4){
					x.playedEditorClick = false;
				}

				if(x.y < strumLine.y && x.alpha != 0.4){
					x.playedEditorClick = true;
				}

			});
		}

		justChanged = false;

		super.update(elapsed);

		/*if(halfSpeedCheck.checked){
			if(FlxG.sound.music.playing){
				FlxG.sound.music.time -= (FlxG.sound.music.time - timeOld) / 2;
				vocals.time = FlxG.sound.music.time;
			}
		timeOld = FlxG.sound.music.time;
		}*/

		

	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	function setNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] = value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		// Basically old shit from changeSection???
		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSection = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateCurStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		justChanged = true;

		trace('changing section' + sec);

		if (_song.notes[sec] != null)
		{
			curSection = sec;

			updateGrid();

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				/*var daNum:Int = 0;
					var daLength:Float = 0;
					while (daNum <= sec)
					{
						daLength += lengthBpmBullshit();
						daNum++;
				}*/

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateCurStep();
			}

			//removeDuplicates(curSection);

			updateGrid();
			updateSectionUI();
		}
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		removeDuplicates(curSection);

		updateGrid();
	}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSection];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;

		updateHeads();
	}

	function updateHeads():Void
	{
		leftIcon.animation.play(player2DropDown.selectedLabel);
		rightIcon.animation.play(player1DropDown.selectedLabel);

		if (_song.notes[curSection].mustHitSection)
		{
			leftIconBack.alpha = 0;
			rightIconBack.alpha = 1;
		}
		else
		{
			leftIconBack.alpha = 1;
			rightIconBack.alpha = 0;
		}
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null)
			stepperSusLength.value = curSelectedNote[2];
	}

	function updateGrid():Void
	{
		while (curRenderedNotes.members.length > 0)
		{
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0)
		{
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}
				
		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSection].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
		{
			// get last bpm
			var daBPM:Float = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		/* // PORT BULLSHIT, INCASE THERE'S NO SUSTAIN DATA FOR A NOTE
			for (sec in 0..._song.notes.length)
			{
				for (notesse in 0..._song.notes[sec].sectionNotes.length)
				{
					if (_song.notes[sec].sectionNotes[notesse][2] == null)
					{
						trace('SUS NULL');
						_song.notes[sec].sectionNotes[notesse][2] = 0;
					}
				}
			}
		 */

		for(i in 0...9){

			//trace(_song.notes[curSection + i] != null);

			if(_song.notes[curSection + i] != null)
				addNotesToRender(curSection, i);

		}
	}

	private function addNotesToRender(curSec:Int, ?secOffset:Int = 0){

		var section:Array<Dynamic> = _song.notes[curSec + secOffset].sectionNotes;
		var noteAdjust:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7];
		switch (_song.mania)
		{
			case 0:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7];
			case 1:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
			case 2:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
			case 3:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
		}

		if(_song.notes[curSec + secOffset].mustHitSection){
			switch (_song.mania)
			{
				case 0:
					noteAdjust = [4, 5, 6, 7, 0, 1, 2, 3];
				case 1:
					noteAdjust = [6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5];
				case 2:
					noteAdjust = [9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 3, 4, 5, 6, 7, 8];
				case 3:
					noteAdjust = [7, 8, 9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6];
			}
		}

		if (_song.mania == 0)
		{
			strumColors = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];
		}
		if (_song.mania == 1)
		{
			strumColors = [0xFFC24B99, 0xFF12FA05, 0xFFF9393F, 0xFFFFFF00, 0xFF00FFFF, 0xFF0033FF];
		}
		if (_song.mania == 2)
		{
			strumColors = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F, 0xFFCCCCCC, 0xFFFFFF00, 0xFF8B4AFF, 0xFFFF0000, 0xFF0033FF];
		}
		if (_song.mania == 3)
		{
			strumColors = [0xFFC24B99, 0xFF12FA05, 0xFFF9393F, 0xFFCCCCCC, 0xFFFFFF00, 0xFF00FFFF, 0xFF0033FF];
		}

		for (i in section)
			{
				var daNoteInfo = i[1];
				var daStrumTime = i[0];
				var daSus = i[2];
	
				var note:Note = new Note(daStrumTime, daNoteInfo % keyAmmo[_song.mania], true);

				note.absoluteNumber = daNoteInfo;
				note.sustainLength = daSus;
				note.setGraphicSize(GRID_SIZE, GRID_SIZE);
				note.updateHitbox();
				
				note.x = Math.floor(noteAdjust[daNoteInfo] * GRID_SIZE);

				note.y = (getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));
				note.y += GRID_SIZE * 16 * secOffset;

				if(secOffset != 0)
					note.alpha = 0.4;

				if(curSelectedNote != null){
					if(daStrumTime 	== curSelectedNote[0] &&
					daNoteInfo 	== curSelectedNote[1] &&
					daSus 		== curSelectedNote[2]){
						note.glow();
					}
				}
	
				curRenderedNotes.add(note);
	
				if (daSus > 1)
				{
					var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2) - 4,
						note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)), strumColors[daNoteInfo % keyAmmo[_song.mania]]);
					if(secOffset != 0)
						sustainVis.alpha = 0.4;
					curRenderedSustains.add(sustainVis);
				}
			}

	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false
		};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{

		for(x in _song.notes[curSection].sectionNotes){

			if(approxEqual(x[0], note.strumTime, (keyAmmo[_song.mania]- 1)) && x[1] == note.absoluteNumber && approxEqual(x[2], note.sustainLength, (keyAmmo[_song.mania]- 1))){

				curSelectedNote = x;
				break;

			}

		}

		//curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void{

		//trace('Trying: ' + note.strumTime);

		for (i in _song.notes[curSection].sectionNotes)
		{
			//trace("Testing: " + i[0]);
			if (approxEqual(i[0], note.strumTime, (keyAmmo[_song.mania] - 1)) && i[1] == note.absoluteNumber)
			{
				//trace('FOUND EVIL NUMBER');
				_song.notes[curSection].sectionNotes.remove(i);
			}

		}

		updateGrid();
	}

	function clearSection():Void
	{
		_song.notes[curSection].sectionNotes = [];

		updateGrid();
	}

	function clearSectionBF():Void
	{

		var newSectionNotes:Array<Dynamic> = [];

		if(_song.notes[curSection].mustHitSection){
			for(x in _song.notes[curSection].sectionNotes){
				if(x[1] > 3)
					newSectionNotes.push(x);
			}
		}
		else{
			for(x in _song.notes[curSection].sectionNotes){
				if(x[1] < 4)
					newSectionNotes.push(x);
			}
		}


		_song.notes[curSection].sectionNotes = newSectionNotes;

		updateGrid();
	}

	function clearSectionOpp():Void
		{
	
			var newSectionNotes:Array<Dynamic> = [];
	
			if(_song.notes[curSection].mustHitSection){
				for(x in _song.notes[curSection].sectionNotes){
					if(x[1] < 4)
						newSectionNotes.push(x);
				}
			}
			else{
				for(x in _song.notes[curSection].sectionNotes){
					if(x[1] > 3)
						newSectionNotes.push(x);
				}
			}
	
	
			_song.notes[curSection].sectionNotes = newSectionNotes;
	
			updateGrid();
		}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
		{
			_song.notes[daSection].sectionNotes = [];
		}

		updateGrid();
	}

	private function addNote(_noteStrum:Float, _noteData:Int, ?skipSectionCheck:Bool = false, ?n:Note):Void
	{
		var noteAdjust:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7];
		switch (_song.mania)
		{
			case 0:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7];
			case 1:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
			case 2:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
			case 3:
				noteAdjust = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
		}

		if(_song.notes[curSection].mustHitSection){
			switch (_song.mania)
			{
				case 0:
					noteAdjust = [4, 5, 6, 7, 0, 1, 2, 3];
				case 1:
					noteAdjust = [6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5];
				case 2:
					noteAdjust = [9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 3, 4, 5, 6, 7, 8];
				case 3:
					noteAdjust = [7, 8, 9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6];
			}
		}

		var noteData = noteAdjust[_noteData];
		var noteStrum = _noteStrum;
		var noteSus = 0;

		if(!skipSectionCheck){
			while(noteStrum < sectionStartTime()){
				noteStrum++;
			}
		}

		_song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus]);

		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		if (FlxG.keys.pressed.TAB)
		{
			_song.notes[curSection].sectionNotes.push([noteStrum, (noteData + keyAmmo[_song.mania]) % (keyAmmo[_song.mania] * 2), noteSus]);
		}

		removeDuplicates(curSection, curSelectedNote);

		trace(noteStrum);
		trace(curSection);

		updateGrid();
		updateNoteUI();

		autosaveSong();
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	/*
		function calculateSectionLengths(?sec:SwagSection):Int
		{
			var daLength:Int = 0;
			for (i in _song.notes)
			{
				var swagLength = i.lengthInSteps;
				if (i.typeOfSection == Section.COPYCAT)
					swagLength * 2;
				daLength += swagLength;
				if (sec != null && sec == i)
				{
					trace('swag loop??');
					break;
				}
			}
			return daLength;
	}*/
	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes)
		{
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	function loadJson(song:String):Void
	{
		PlayState.SONG = Song.loadFromJson(song.toLowerCase() + diffDropFinal, song.toLowerCase());
		FlxG.resetState();
	}

	function loadAutosave():Void
	{
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		FlxG.resetState();
	}

	function autosaveSong():Void
	{
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});
		FlxG.save.flush();
	}

	private function saveLevel()
	{
		var json = {
			"song": _song
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + diffDropFinal + ".json");
		}
	}
	
	private function saveGenericLevel()
	{
		var genericSong =
		{
			song: _song.song,
			notes: _song.notes,
			bpm: _song.bpm,
			needsVoices: _song.needsVoices,
			speed: _song.speed,
			player1: _song.player1,
			player2: _song.player2,
			validScore: _song.validScore,
			mania: _song.mania
		};

		var json = {
			"song": genericSong
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + diffDropFinal + ".json");
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}

	function swapSections()
	{
		for (i in 0..._song.notes[curSection].sectionNotes.length)
		{
			var note = _song.notes[curSection].sectionNotes[i];
			note[1] = (note[1] + keyAmmo[_song.mania]) % (keyAmmo[_song.mania] * 2);
			_song.notes[curSection].sectionNotes[i] = note;
			updateGrid();
		}
	}

	function sectionHasBfNotes(section:Int):Bool{
		var notes = _song.notes[section].sectionNotes;
		var mustHit = _song.notes[section].mustHitSection;

		for(x in notes){
			if(mustHit) { if(x[1] < 4) { return true; } }
			else { if(x[1] > 3) { return true; } }
		}

		return false;

	}

	function removeDuplicates(section:Int, ?forceNote:Array<Dynamic> = null){

		var newNotes:Array<Dynamic> = [];

		if(forceNote != null){
			newNotes.push(forceNote);
		}

		for(x in _song.notes[section].sectionNotes){

			var add = true;

			for(y in newNotes){

				if(newNotes.length > 0){
					if(approxEqual(x[0], y[0], 6) && x[1] == y[1]){
						add = false;
					}
				}

			}

			if(add)
				newNotes.push(x);

		}

		_song.notes[section].sectionNotes = newNotes;

	}

	function approxEqual(x:Dynamic, y:Dynamic, tolerance:Float){

		return x <= y + tolerance && x >= y - tolerance;

	}

	override function beatHit()
	{
		super.beatHit();
	}
	
}