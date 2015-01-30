package com.plumbee.stardustplayer.emitter
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectHandler;

import org.flexunit.asserts.assertTrue;
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


	[Test(description="removeRendererSpecificInitializers removes each renderer specific initializer from emitter")]
	public function canRemoveRendererSpecificInitializers() : void
	{
		var emitter : Emitter2DSpy = new Emitter2DSpy();
		var vo : DisplayListEmitterValueObject = new DisplayListEmitterValueObject(0, emitter);
		vo.removeRendererSpecificInitializers();
		for each (var clazz : Class in RendererSpecificInitializers.getList())
		{
			assertTrue(emitter.wasEmitterClassRemoved(clazz));
		}
	}

}
}

import flash.utils.Dictionary;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

class Emitter2DSpy extends Emitter2D
{
	private var removedClasses : Dictionary = new Dictionary();

	override public function removeInitializersByClass(classToRemove : Class) : void
	{
		removedClasses[classToRemove] = true;
	}

	public function wasEmitterClassRemoved(clazz : Class) : Boolean
	{
		return removedClasses[clazz] == true;
	}
}