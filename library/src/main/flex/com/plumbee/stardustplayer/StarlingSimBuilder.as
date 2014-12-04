package com.plumbee.stardustplayer
{
import com.plumbee.stardustplayer.emitter.EmitterBuilder;
import com.plumbee.stardustplayer.emitter.EmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.utils.ByteArray;

import starling.textures.TextureAtlas;

public class StarlingSimBuilder
{
	private var _project : ProjectValueObject;

	public function StarlingSimBuilder()
	{
		_project = new ProjectValueObject();
	}

	public function withEmitter(emitterID : uint, emitterBA : ByteArray) : StarlingSimBuilder
	{
		var emitterXml : XML = new XML(emitterBA.readUTFBytes(emitterBA.length));
		var emitterVO : EmitterValueObject = new EmitterValueObject(emitterID, EmitterBuilder.buildEmitter(emitterXml));

		_project.emitters[emitterID] = emitterVO;

		return this;
	}

	public function withTextures(emitterID : uint, prefix : String, textureAtlas : TextureAtlas) : StarlingSimBuilder
	{

		if (_project.emitters[emitterID])
		{
			_project.emitters[emitterID].prepareForStarling(textureAtlas.getTextures(prefix));
		} else {
			throw new Error("There is no emitter with emitterID: " + emitterID );
		}

		return this;
	}

	public function build() : ProjectValueObject
	{
		return _project;
	}

}
}
