package tv.turbodrive.away3d.utils
{
	
	import flash.geom.Vector3D;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.math.Matrix3DUtils;

	public class Tools3d
	{
		public static const DISTANCE_Z_1280:Number = -995.557721587763
		
		public function Tools3d()
		{
		}
		
		public static function generatePath(a:Array):Vector.<Vector3D>
		{
			var vectorPath:Vector.<Vector3D> = new Vector.<Vector3D>();
			for(var i:int = 0; i< a.length; i+=3){
				var v:Vector3D = new Vector3D(a[i],a[i+1],a[i+2]);
				vectorPath.push(v);
			}
			return vectorPath
		}
		
		public static function pxPerfectCamera():void
		{
			/*var h:Number = _view.height;
			var fovy:Number = (_view.camera.lens as PerspectiveLens).fieldOfView*Math.PI/180;
			_view.camera.z = -(h/2) / Math.tan(fovy/2);*/
		}
		
		
		public static function pixelPerfectCameraValue(camera:Camera3D,h:Number):Number
		{			
			var fovy:Number = (camera.lens as PerspectiveLens).fieldOfView*Math.PI/180;
			return  -(h/2) / Math.tan(fovy/2);
		} 
		
		public static function pxPerfectPosition(cameraContainer:ObjectContainer3D, view:View3D):Vector3D			
		{			
			
			var cam:Camera3D = cameraContainer.getChildAt(0) as Camera3D;
			var positionCamera:Vector3D = Matrix3DUtils.getForward(cameraContainer.transform);
			var pxPerfectCam:Number = pixelPerfectCameraValue(cam, view.height)
			//trace("pixelPerfectCameraValue >> " + pxPerfectCam)
				
			var newPos:Vector3D = new Vector3D(	cameraContainer.position.x + positionCamera.x * -pxPerfectCam, 
				cameraContainer.position.y + positionCamera.y * -pxPerfectCam, 
				cameraContainer.position.z + positionCamera.z * -pxPerfectCam);
			
			return newPos
		}
		
		public static function getCamPositionFromTarget(target3D:Object3D):Vector3D
		{
			var tmpObj:Object3D = new Object3D();
			tmpObj.transform = target3D.transform.clone();
			tmpObj.moveForward(DISTANCE_Z_1280)
			
			return tmpObj.position
		}
		
		public static function getTargetPositionFromCamera(camera:Object3D):Vector3D
		{
			var tmpObj:Object3D = new Object3D();
			tmpObj.transform = camera.transform.clone();
			tmpObj.moveBackward(DISTANCE_Z_1280)
			
			return tmpObj.position
		}
	}
}