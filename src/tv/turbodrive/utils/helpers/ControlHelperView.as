package tv.turbodrive.utils.helpers
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import away3d.core.base.Object3D;
	
	import tv.turbodrive.away3d.core.NavCamera;
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.events.ObjectEvent;

	public class ControlHelperView extends ControlHelper
	{
		public static const UPDATED_TRANSFORM:String = "updatedTransform"
		
		private var _currentObject:NavCamera
		
		private var _rX:ValueComp;
		private var _rY:ValueComp;
		private var _rZ:ValueComp;
		private var _pX:ValueComp;
		private var _pY:ValueComp;
		private var _pZ:ValueComp;
		private var _rX2:ValueComp;
		private var _rY2:ValueComp;
		private var _rZ2:ValueComp;
		
		public function ControlHelperView()
		{
			init()
		}
		
		private function init():void
		{
			_rX = new ValueComp(this.rotX, 0 ,0.1)
			_rY = new ValueComp(this.rotY, 0 ,0.1)
			_rZ = new ValueComp(this.rotZ, 0 ,0.1)
			_pX = new ValueComp(this.posX,0,10)
			_pY = new ValueComp(this.posY,0,10)
			_pZ = new ValueComp(this.posZ,0,10)
			_rX.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_rY.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_rZ.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_pX.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_pY.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_pZ.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
				
			_rX2 = new ValueComp(this.rotX2, 0 ,0.5)
			_rY2 = new ValueComp(this.rotY2, 0 ,0.5)
			_rZ2 = new ValueComp(this.rotZ2, 0 ,0.5)
			_rX2.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_rY2.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
			_rZ2.addEventListener(ValueComp.VALUE_CHANGE, valueChangeHandler)
				
			updateMc.addEventListener(MouseEvent.CLICK, updateInfos)
			updateMc.buttonMode = true
		}
		
		protected function updateInfos(event:MouseEvent):void
		{
			update()
		}
		
		private function update():void
		{			
			_pX.value = _currentObject.x
			_pY.value = _currentObject.y
			_pZ.value = _currentObject.z			
			_rX.value = _currentObject.rotationX
			_rY.value = _currentObject.rotationY
			_rZ.value = _currentObject.rotationZ
		}
		
		protected function valueChangeHandler(event:Event):void
		{
			_currentObject.position = new Vector3D(_pX.value, _pY.value, _pZ.value)
			_currentObject.rotationX = _rX.value
			_currentObject.rotationY = _rY.value
			_currentObject.rotationZ = _rZ.value
			dispatchEvent(new ObjectEvent(UPDATED_TRANSFORM, this, new Vector3D(_rX2.value, _rY2.value, _rZ2.value)))
		}
		
		public function setObject(obj:NavCamera):void
		{
			if(!obj) return
			_currentObject = obj
			update()
		}
	}
}