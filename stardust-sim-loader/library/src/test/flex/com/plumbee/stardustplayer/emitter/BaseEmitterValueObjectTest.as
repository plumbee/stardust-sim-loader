package com.plumbee.stardustplayer.emitter
{
import org.flexunit.asserts.assertTrue;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class BaseEmitterValueObjectTest
{
	[Test]
	public function resetEmitter_willResetEmitter() : void
	{
		var spy : Emitter2DSpy = new Emitter2DSpy();
		var emitter : BaseEmitterValueObject = new BaseEmitterValueObject(0, spy);
		emitter.resetEmitter();
		assertThat(spy.getResetCount(), equalTo(1));
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
	private var count : uint = 0;

	override public function reset() : void
	{
		++count;
	}

	public function getResetCount() : uint
	{
		return count;
	}

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