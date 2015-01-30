package com.plumbee.stardustplayer.emitter
{
import starling.display.DisplayObjectContainer;
import starling.textures.Texture;

public interface IStarlingEmitter extends IBaseEmitter
{
	function addStarlingInitializers(textures : Vector.<Texture>) : void;
	function updateHandlerCanvas(target : DisplayObjectContainer) : void;
}
}
