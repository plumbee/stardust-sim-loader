package com.plumbee.stardustplayer.emitter
{
import flash.display.DisplayObjectContainer;

public interface IDisplayListEmitter extends IBaseEmitter
{
	function addDisplayListInitializers() : void;
	function updateHandlerCanvas(canvas:DisplayObjectContainer) : void;
}
}
