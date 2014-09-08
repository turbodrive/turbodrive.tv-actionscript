package tv.turbodrive.away3d.core
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	
	public class RiggedCamera extends RiggedCameraBehaviour
	{
		private var _camera:Camera3D
		private var _lens:PerspectiveLens	
		
		
		public function RiggedCamera(camera:Camera3D)
		{
			super();
			_camera = camera
			_lens = new PerspectiveLens();
			_lens.far = 70000;
			_lens.near = 1;
			_camera.lens = _lens

			_mainContainer.addChild(camera)
		}	
		
		
		public function setOffsetZCamera(offsetZ:Number):void
		{
			_camera.z = offsetZ
		}	
		
		
		public function setFieldOfView(fov:Number):void
		{
			_lens.fieldOfView = fov
		}
		public function reset(worldCamCoord:Gp3DVO):void
		{
			position = worldCamCoord.position
				
			/*if(worldCamCoord.target){
				// targetCam
				isTargetCamera = true
				lookAt(worldCamCoord.target.position);
				localRz = worldCamCoord.localRz
				
				//trace("reset With TargetCam")
			}else{*/
				isTargetCamera = false
				//localRz = 0
				rotationX = worldCamCoord.rotationX
				rotationY = worldCamCoord.rotationY
				rotationZ = worldCamCoord.rotationZ
				rigDistance = worldCamCoord.rigDistance
				/*trace("reset With RiggedCam")
				
				trace("--- " + this.position)
				trace(rotationX, rotationY, rotationZ, rigDistance)*/
			//}
		}
		
		public function get pxRigDistance():Number
		{
			return (Stage3DView.PX_PERFECT_DISTANCE-Tools3d.DISTANCE_Z_1280)
		}		
		
	}
}