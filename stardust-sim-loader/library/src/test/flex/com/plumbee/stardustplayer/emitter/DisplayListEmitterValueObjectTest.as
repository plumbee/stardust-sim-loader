package com.plumbee.stardustplayer.emitter
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectHandler;

import org.hamcrest.assertThat;
import org.hamcrest.object.strictlyEqualTo;

public class DisplayListEmitterValueObjectTest
{
	[Test]
	public function updatecanvas_setsEmitterParticleHandlerContainer() : void
	{
		var targetCanvas : DisplayObjectContainer = new Sprite();
		var handler : DisplayObjectHandler = new DisplayObjectHandler();
		var emitter : Emitter2D = new Emitter2D(null, handler);
		var vo : DisplayListEmitterValueObject = new DisplayListEmitterValueObject(0, emitter);
		vo.updateHandlerCanvas(targetCanvas);
		assertThat(handler.container, strictlyEqualTo(targetCanvas));
	}
}
}