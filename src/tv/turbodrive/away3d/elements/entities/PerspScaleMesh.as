package tv.turbodrive.away3d.elements.entities
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.IViewRender3D;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;

	public class PerspScaleMesh extends Mesh
	{
		public static const UPDATE_PERSP_SCALE:String = "updatePerspScale"
		
		public var pixelPerfectScale:Boolean = true		
		private var _positionDirty:Boolean = true;
		private var _scaleDirty:Boolean = true;
		
		private var _extraScale:Number = 1;
		protected var _scale:Number = 1;
		private var _initX:Number = 0;
		private var _initY:Number = 0;
		protected var _scX:Number = 1;
		protected var _scZ:Number = 1;
		
		protected var _externalUvOffset:Point = new Point(0,0);
		protected var _uvDirty:Boolean = false
		
		protected var _viewRenderer:IViewRender3D;
		
		public static function createFromMesh(mesh:Mesh = null, replaceSource:Boolean = false, view:IViewRender3D = null):PerspScaleMesh
		{
			if(!mesh) return null
			
			MeshHelper.recenter(mesh)			
			var psMesh:PerspScaleMesh = new PerspScaleMesh(mesh.geometry, mesh.material, view)
			psMesh.transform = mesh.transform
			if(replaceSource){
				if(mesh.parent){
					var newParent:ObjectContainer3D = mesh.parent
					newParent.removeChild(mesh);
					newParent.addChild(psMesh);
				}
			}
			return psMesh;
		}
		
		public function PerspScaleMesh(geometry:Geometry, material:MaterialBase=null, view:IViewRender3D = null)
		{
			super(geometry, material);
			_viewRenderer = view ? view : Stage3DView.instance
			_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)
			onRender(null)
		}
		
		/*******/
		
		public function adjustUVs(atlasArea:Rectangle = null, textureWidth:int = 512, textureHeight:int = 512, scaleTexX:int = 1, scaleTexY:int = 1):void{
			if(!atlasArea) atlasArea = new Rectangle(0,0,textureWidth,textureHeight)
			var subMesh:SubMesh = subMeshes[0] as SubMesh
			subMesh.scaleU = atlasArea.width / textureWidth * scaleTexX * _scX
			subMesh.scaleV = atlasArea.height / textureHeight * scaleTexY * _scZ
			subMesh.offsetU = (atlasArea.x+_externalUvOffset.x) / textureWidth
			subMesh.offsetV = (atlasArea.y+_externalUvOffset.y) / textureHeight
		}	
		
		public function set uvOffsetX(value:Number):void
		{
			_externalUvOffset.x = value
			_uvDirty = true
		}
		
		public function get uvOffsetX():Number
		{
			return _externalUvOffset.x
		}	
		
		public function set uvOffsetY(value:Number):void
		{
			_externalUvOffset.y = value
			_uvDirty = true
		}
		
		public function get uvOffsetY():Number
		{
			return _externalUvOffset.y
		}
		
		//********//
		
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
			dispatchEvent(new Event(UPDATE_PERSP_SCALE))
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
		
		public function get internalPerspScale():Number	
		{
			return _scale
		}
		
		public function get initPosition():Vector3D
		{
			
			var pos:Vector3D = new Vector3D(_initX*_scale, _initY*_scale, super.z)
			return pos
		}
		
		protected function onRender(e:Event):void
		{					
			if(_positionDirty){
				updatePosition();
				_positionDirty = false
			}
			if(_scaleDirty){
				updateScale()
				_scaleDirty = false
			}			
			if(_uvDirty){
				adjustUVs();
				_uvDirty = false
			}	
		}
	}
}