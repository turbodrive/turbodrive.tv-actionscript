package tv.turbodrive.away3d.elements.entities
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.IViewRender3D;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	
	public class PerspScaleContainer extends ObjectContainer3D
	{
		public var pixelPerfectScale:Boolean = true
		
		private var _positionDirty:Boolean = true;
		private var _scaleDirty:Boolean = true;
		
		private var _extraScale:Number = 1;
		protected var _scale:Number = 1;
		private var _initX:Number = 0;
		private var _initY:Number = 0;
		protected var _scX:Number = 1;
		protected var _scZ:Number = 1;
		protected var _viewRenderer:IViewRender3D;
		
		public function PerspScaleContainer(view:IViewRender3D = null)
		{
			super();
			_viewRenderer = view ? view : Stage3DView.instance
			_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)
		}
		
		public function updatePosition():void
		{
			if(z == 0 || !pixelPerfectScale){
				super.x = int(_initX)
				super.y = int(_initY)
				return
			}			
			_scale = (_viewRenderer.pxPerfectDistance - z)/_viewRenderer.pxPerfectDistance;
			updateScale()
			super.x = int(_initX)*_scale
			super.y = int(_initY)*_scale
		}
		
		protected function updateScale():void
		{
			scaleY = _scale*_extraScale
			scaleX = scaleY*_scX
			scaleZ = scaleY*_scZ
		}		
		
		public function set extraScale(value:Number):void
		{
			_extraScale = value
			_scaleDirty = true
		}
		
		public function get extraScale():Number
		{
			return _extraScale
		}
		
		override public function set z(value:Number):void
		{
			super.z = value
			_positionDirty = true
		}			
		
		override public function get x():Number
		{
			return _initX
		}
		
		override public function set x(val:Number):void
		{
			_initX = val
			_positionDirty = true
		}		
		
		override public function get y():Number
		{
			return _initY
		}
		
		override public  function set y(val:Number):void
		{
			_initY = val
			_positionDirty = true
		}				
		
		override public function set position(value:Vector3D):void
		{
			_initX = value.x
			_initY = value.y
			super.z = value.z
			_positionDirty = true
		}
		
		protected function onRender(e:Event):void
		{					
			if(_positionDirty){
				updatePosition();
			}else if(_scaleDirty){
				updateScale()
			}
			
			_positionDirty = _scaleDirty = false
		}
	}
}