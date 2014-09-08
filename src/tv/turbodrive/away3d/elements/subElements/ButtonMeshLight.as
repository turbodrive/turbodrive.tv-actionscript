package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import away3d.bounds.BoundingSphere;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.events.Object3DEvent;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import tv.turbodrive.away3d.elements.entities.PerspScaleMesh;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	
	public class ButtonMeshLight extends EventDispatcher
	{
		private var _sourceMesh:Mesh;
		
		private var _lightPicker:StaticLightPicker
		private var _light:PointLight
		public var name:String = "";
		
		private var _alpha:Number = 0
		private var _enabled:Boolean = false;
		
		//private var _alpha:Number = 1;
		//private var alphaBlendAlpha:Boolean = false;
		
		public function ButtonMeshLight(sourceMesh:Mesh, debug:Boolean = false)
		{
			_sourceMesh = sourceMesh			
			var clonedMaterial:TextureMaterial = MaterialHelper.cloneTextureMaterial(_sourceMesh.material as TextureMaterial, _sourceMesh.name)
			clonedMaterial.alphaPremultiplied = false
			_sourceMesh.material = clonedMaterial
			
							
			_light = new PointLight();			
			_light.radius = 300
			_light.fallOff = 300	
			if(debug){
				_light.bounds = new BoundingSphere();
				_light.showBounds = true
			}
			_light.diffuse = 0
			_light.specular = 0
			_light.ambient = 1
			_lightPicker = new StaticLightPicker([_light])
			_sourceMesh.material.lightPicker = _lightPicker	
				
			if(_sourceMesh.parent){
				onAddedToSceneHandler()
			}else{
				_sourceMesh.addEventListener(Object3DEvent.SCENE_CHANGED, onAddedToSceneHandler)
			}
			
			alpha = 1
			//enabled = true
		}
		
		
		
		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			//if(_alpha == value) return
			_alpha = value;
			TextureMaterial(_sourceMesh.material).alpha = _alpha
			
			if(_alpha < 1){
				enabled = false
				if(!TextureMaterial(_sourceMesh.material).alphaBlending){
					TextureMaterial(_sourceMesh.material).alphaBlending = true
					//TextureMaterial(_sourceMesh.material).colorTransform = new ColorTransform(2,2,2,2,0,0,0,0)
				}
			}else{
				enabled = true
				if(TextureMaterial(_sourceMesh.material).alphaBlending){
					TextureMaterial(_sourceMesh.material).alphaBlending = false
					//TextureMaterial(_sourceMesh.material).colorTransform = new ColorTransform()
				}
			}
		}

		protected function onAddedToSceneHandler(event:Object3DEvent = null):void
		{
			_sourceMesh.removeEventListener(Object3DEvent.SCENE_CHANGED, onAddedToSceneHandler)
			updateLightPosition();
		}
		
		public function updateLightPosition():void
		{
			if(_sourceMesh is PerspScaleMesh){
				_light.position = PerspScaleMesh(_sourceMesh).initPosition.clone();
			}else{
				_light.position = _sourceMesh.position.clone();
			}
			//_light.y += 20
			_light.moveBackward(250)
			_sourceMesh.parent.addChild(_light)
		}
		
		public function set enabled(value:Boolean):void
		{
			//if(value == _enabled) return
			_enabled = value
			_sourceMesh.mouseEnabled = _enabled
			
			if(_enabled){				
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_UP, mouseUpHandler);
				_sourceMesh.addEventListener(MouseEvent3D.CLICK, mouseClickHandler);
			}else{
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_UP, mouseUpHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.CLICK, mouseClickHandler);
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled
		}
		
		protected function mouseClickHandler(event:MouseEvent3D):void
		{
			
			TweenMax.to(_light, 1/10, {startAt:{diffuse:1}, diffuse:0, repeat:1, onComplete:dispatchCLick, onCompleteParams:[event]})
		}
		
		protected function dispatchCLick(e:Event):void
		{
			dispatchEvent(e)
		}
		
		protected function mouseUpHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
			dispatchEvent(event)			
		}
		
		protected function mouseDownHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
			//TweenMax.to(_light, 0.3, {diffuse:0,ease:Quart.easeOut})
			_light.diffuse = 0
			dispatchEvent(event)
		}	
		
		protected function mouseOutHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.AUTO
			TweenMax.to(_light, 0.5, {diffuse:0,ease:Quart.easeOut})
			dispatchEvent(event)
		}
		
		protected function mouseOverHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
			TweenMax.to(_light, 0.3, {diffuse:1,ease:Quart.easeOut})
			dispatchEvent(event)
		}
		
		
	}
}