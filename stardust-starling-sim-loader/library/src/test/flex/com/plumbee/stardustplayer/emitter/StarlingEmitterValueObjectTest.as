package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.object.strictlyEqualTo;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

use namespace sd;

public class StarlingEmitterValueObjectTest
{
	private var _starlingEmitterValueObject : StarlingEmitterValueObjectShunt;

	[Before]
	public function setUp() : void
	{
		_starlingEmitterValueObject = new StarlingEmitterValueObjectShunt(0, new Emitter2D());
	}

	[Test]
	public function canAddStarlingInitializers() : void
	{
		_starlingEmitterValueObject.addStarlingInitializers(null);

		assertTrue(_starlingEmitterValueObject.calledAddPooledStarlingDisplayObjectClass);
		assertTrue(_starlingEmitterValueObject.emitter.particleHandler is StarlingHandler);
	}

	[Test]
	public function prepareForStarling_callsRelevantFunctions() : void
	{
		_starlingEmitterValueObject.prepareForStarling(null);
		assertTrue(_starlingEmitterValueObject.calledAddPooledStarlingDisplayObjectClass);
	}


	[Test]
	public function updatecanvas_setsEmitterParticleHandlerContainer() : void
	{
		var targetCanvas : DisplayObjectContainer = new Sprite();
		var handler : StarlingHandler = new StarlingHandler();
		var emitter : Emitter2D = new Emitter2D(null, handler);
		var vo : StarlingEmitterValueObject = new StarlingEmitterValueObject(0, emitter);
		vo.updateHandlerCanvas(targetCanvas);
		assertThat(handler.container, strictlyEqualTo(targetCanvas));
	}
}
}

import com.plumbee.stardustplayer.emitter.StarlingEmitterValueObject;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

import starling.textures.Texture;

class StarlingEmitterValueObjectShunt extends StarlingEmitterValueObject
{

	public var calledAddPooledStarlingDisplayObjectClass : Boolean;
	public var calledAddStarlingInitializers : Boolean;

	function StarlingEmitterValueObjectShunt(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);

		calledAddPooledStarlingDisplayObjectClass = false;
		calledAddStarlingInitializers = false;
	}

	override protected function addPooledStarlingDisplayObjectClass(textures : Vector.<Texture>) : void
	{
		calledAddPooledStarlingDisplayObjectClass = true;
	}

	override public function addStarlingInitializers(textures : Vector.<Texture>) : void
	{
		super.addStarlingInitializers(textures);
		calledAddStarlingInitializers = true;
	}
}
