package com.plumbee.stardustplayer.project
{

import com.plumbee.stardustplayer.emitter.BaseEmitterValueObject;

import flash.display.DisplayObject;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class ProjectValueObject
{
	public var version : Number;
	public const emitters : Dictionary = new Dictionary(); // BaseEmitterValueObject
	public var backgroundColor : uint;
	public var hasBackground : Boolean;
	public var backgroundFileName : String;
	public var backgroundImage : DisplayObject;
	public var backgroundRawData : ByteArray;
	public var displayMode : String;

	public function ProjectValueObject(projectJSON : Object = null)
	{
		if (projectJSON != null)
		{
			version = projectJSON.version;

			hasBackground = (projectJSON.hasBackground == "true");

			if (projectJSON.backgroundFileName)
			{
				backgroundFileName = projectJSON.backgroundFileName;
			}

			if (projectJSON.displayMode)
			{
				displayMode = projectJSON.displayMode;
			}
			else
			{
				displayMode = DisplayModes.DISPLAY_LIST;
			}
		}

	}

	public function get numberOfEmitters() : int
	{
		var numEmitters : uint = 0;
		for each (var emitter : Object in emitters)
		{
			numEmitters++;
		}
		return numEmitters;
	}

	public function get numberOfParticles() : uint
	{
		var numParticles : uint = 0;
		for each (var emVO : BaseEmitterValueObject in emitters)
		{
			numParticles += emVO.emitter.numParticles;
		}
		return numParticles;
	}

	/** The simulation will be unusable after calling this method. */
	public function destroy() : void
	{
		for each (var emitterValueObject : BaseEmitterValueObject in emitters)
		{
			emitterValueObject.emitter.clearParticles();
			emitterValueObject.emitter.clearActions();
			emitterValueObject.emitter.clearInitializers();
			emitterValueObject.image = null;

			delete emitters[emitterValueObject.id];
		}
		backgroundImage = null;
	}

}
}
