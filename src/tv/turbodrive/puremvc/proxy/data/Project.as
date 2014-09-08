package tv.turbodrive.puremvc.proxy.data
{
	import flash.geom.Vector3D;
	
	import away3d.core.base.Object3D;

	public class Project
	{
		private var _name:String;
		private var _id:String;
		private var _address:String;
		private var _client:String;
		public var htmlName:String
		public var htmlClient:String				
		public var caseVimeo:String;
		public var videoCapture:String
		public var transformClone:Object3D;		
		public var isSecondaryProject:Boolean = false
		
		public function Project(id:String, name:String, address:String, client:String)
		{
			_id = id
			_name = name
			_address = address
			_client = client;
		}
				
		public function get name():String
		{
			return _name
		}
		
		public function get id():String
		{
			return _id
		}
		
		public function get address():String
		{
			return _address
		}
		
		public function get client():String
		{
			return _client;
		}
		
		public function set3dProps(x:Number, y:Number, z:Number, rotationX:Number, rotationY:Number, rotationZ:Number):void
		{
			transformClone = new Object3D()
			transformClone.position = new Vector3D(x,-y,z);
			transformClone.rotateTo(-rotationX, rotationY, -rotationZ)
			/*transformClone.rotationX = -rotationX
			transformClone.rotationY = rotationY
			transformClone.rotationZ = -rotationZ*/
		}
		
	}
}