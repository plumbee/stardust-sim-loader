package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertTrue;
import org.flexunit.async.Async;
import org.hamcrest.core.isA;
import org.hamcrest.object.strictlyEqualTo;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.Texture;

use namespace sd;

public class StarlingEmitterValueObjectTest
{
	private var _starlingEmitterValueObject : StarlingEmitterValueObject;


	[Before(async, timeout=1000)]
	public function setUp() : void
	{
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();
		_starlingEmitterValueObject = new StarlingEmitterValueObject(0, new Emitter2D());
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

	[Test]
	public function prepareForStarling_addsStarlingHandler() : void
	{
		var emitter : Emitter2D = new Emitter2D();
		var vo : StarlingEmitterValueObject = new StarlingEmitterValueObject(0, emitter);
		vo.prepareForStarling(createTextures());
		assertThat(emitter.particleHandler, isA(StarlingHandler));
	}

	private function createTextures() : Vector.<Texture>
	{
		return Vector.<Texture>([Texture.fromColor(1,1,0xFF00FF)]);
	}

	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
	}
}
}
