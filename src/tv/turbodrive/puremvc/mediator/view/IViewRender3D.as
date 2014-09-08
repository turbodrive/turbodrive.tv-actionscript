package tv.turbodrive.puremvc.mediator.view
{
	import away3d.containers.Scene3D;
	import away3d.core.managers.Stage3DProxy;
	
	import tv.turbodrive.away3d.core.NavCamera;

	public interface IViewRender3D
	{
		function get s3dProxy():Stage3DProxy
		
		function get navCamera():NavCamera
		
		function get scene():Scene3D
		
		function get pxPerfectDistance():Number;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
	}	
	
}