package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;

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
	public function canRemoveDisplayListInitializers() : void
	{
		_starlingEmitterValueObject.emitter.addInitializer(new BitmapParticleInit());
		_starlingEmitterValueObject.emitter.addInitializer(new PooledDisplayObjectClass());

		_starlingEmitterValueObject.removeDisplayListInitializers();

		var found : uint = 0;
		for (var i : int = 0; i < _starlingEmitterValueObject.emitter.initializers.length; i++)
		{
			if (_starlingEmitterValueObject.emitter.initializers[i] is BitmapParticleInit || _starlingEmitterValueObject.emitter.initializers[i] is PooledDisplayObjectClass)
			{
				found++;
			}
		}

		assertEquals(0, found);
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
		assertTrue(_starlingEmitterValueObject.calledRemoveDisplayListInitializers);
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
	public var calledRemoveDisplayListInitializers : Boolean;

	function StarlingEmitterValueObjectShunt(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);

		calledAddPooledStarlingDisplayObjectClass = false;
		calledAddStarlingInitializers = false;
		calledRemoveDisplayListInitializers = false;
	}

	override protected function addPooledStarlingDisplayObjectClass(textures : Vector.<Texture>) : void
	{
		calledAddPooledStarlingDisplayObjectClass = true;
	}

	override public function removeDisplayListInitializers() : void
	{
		super.removeDisplayListInitializers();
		calledRemoveDisplayListInitializers = true;
	}

	override public function addStarlingInitializers(textures : Vector.<Texture>) : void
	{
		super.addStarlingInitializers(textures);
		calledAddStarlingInitializers = true;
	}
}
