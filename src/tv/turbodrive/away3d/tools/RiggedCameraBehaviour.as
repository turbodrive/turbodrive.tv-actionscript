package tv.turbodrive.away3d.tools
{
	import flash.geom.Matrix3D;
	
	import away3d.containers.ObjectContainer3D;

	public class RiggedCameraBehaviour extends ObjectContainer3D
	{
		protected var _rotY:ObjectContainer3D
		protected var _rotX:ObjectContainer3D = new ObjectContainer3D()
		protected var _mainContainer:ObjectContainer3D = new ObjectContainer3D()
		
		protected var _isTargetCamera:Boolean = false
		protected var _rigDistance:Number = 0
			
		private var _localRz:Number = 0;
		private var _rollZ:Number = 0;
		private var _rollX:Number = 0;
		
		public function RiggedCameraBehaviour()
		{
			_rotY = this
			_rotY.addChild(_rotX)
			_rotX.addChild(_mainContainer)
		}
		
		public function set isTargetCamera(value:Boolean):void
		{
			if(_isTargetCamera == value) return
			_isTargetCamera = value
			updateBehaviour();
		}
		
				
		private function updateBehaviour():void
		{
			if(_isTargetCamera){
				trace("••••• Camera is TargetCamera")
				_mainContainer.z = 0
				this.moveForward(_rigDistance)
				//localRz = 0
				rotationZ = 0
				super.rotationZ = 0
				rotationX = rotationY = 0
			}else{
				trace("•••••• Camera is RiggedCamera")
				this.transform = new Matrix3D();
				//lookAt(new Vector3D(0,0,Tools3d.DISTANCE_Z_1280));
				_mainContainer.z = _rigDistance
				this.moveBackward(_rigDistance);
				super.rotationZ = 0
				_mainContainer.rotationZ = 0
				//localRz = 0
				rotationX = rotationY = 0
				//trace("position >> " + position)
				//trace("_mainContainer.z >> " + _mainContainer.z)
			}
		}		
		
		public function get isTargetCamera():Boolean
		{
			return _isTargetCamera
		}
		
		public function set rigDistance(value:Number):void
		{
			//trace("set RigDistance >> " + value)
			if(value == _rigDistance) return
			
			
			_rigDistance = value
			if(!_isTargetCamera) _mainContainer.z = _rigDistance
		}
		
		public function get rigDistance():Number
		{
			return _mainContainer.z
		}
		
		public function get globalTransform():Matrix3D
		{
			return _mainContainer.sceneTransform
		}	
		
		public function get coreInverseSceneTransform():Matrix3D
		{
			return _mainContainer.inverseSceneTransform
		}
		
		override public function set rotationX(val:Number):void
		{
			if(_isTargetCamera){
				super.rotationX = val
			}else{
				_rotX.rotationX = val
			}			
		}
		
		override public function get rotationX():Number
		{
			if(_isTargetCamera){
				return super.rotationX
			}else{
				return _rotX.rotationX
			}			
		}
		
		override public function set rotationZ(val:Number):void
		{			
			/*if(_isTargetCamera){
				//return 
				super.rotationZ = val
			}else{*/
				super.rotationZ = 0
				_localRz = val
				updateRotationZ()
				
				
			//}
		}
				
		override public function get rotationZ():Number
		{
			/*if(_isTargetCamera){
				return super.rotationZ
			}else{*/
				return _localRz
			//}
		}
		
		private function updateRotationZ():void
		{
			_mainContainer.rotationZ = _localRz+_rollZ
		}
		
		public function set rollZ(value:Number):void
		{
			_rollZ = value
			updateRotationZ()
		}
		
		public function get rollZ():Number
		{
			return _rollZ
		}
		
		public function set rollX(value:Number):void
		{
			_rollX = value
			_mainContainer.rotationX = _rollX
		}
		
		public function get rollX():Number
		{
			return _rollX
		}
		
		/*private function set localRz(value:Number):void
		{
			_localRz = value
			_mainContainer.rotationZ = _localRz
		}*/
		
		/*public function get localRz():Number
		{
			return _localRz
		}*/
		
	}
}