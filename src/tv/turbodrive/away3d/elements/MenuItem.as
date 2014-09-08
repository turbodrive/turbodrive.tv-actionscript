package tv.turbodrive.away3d.elements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.loaders.AssetLoader;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.ColorTransformMethod;
	import away3d.textures.BitmapTexture;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.loader.AssetsManager;
	import tv.turbodrive.puremvc.proxy.data.Asset;

	public class MenuItem extends EventDispatcher
	{
		public static const BLINK_COMPLETE:String = "BlinkComplete"
		
		private var _name:String		
		private var _mesh:Mesh;
		
		private static var commonDiffuseTexture:BitmapTexture
		private static var commonAmbientTexture:BitmapTexture
		
		private var _lightpicker:StaticLightPicker
		private var _light:PointLight
		private var _material:TextureMaterial
		
		private var buildLight:Boolean;

		private var _twDiffuse:TweenMax;

		private var cT:ColorTransform;

		private var tweenCT:TweenMax;
		public function MenuItem(mesh:Mesh, buildLight:Boolean = true)
		{
			this.buildLight = buildLight;
			_mesh = mesh
			_name = mesh.name.split("Button")[0];
			if(!commonDiffuseTexture){
				var mat:TextureMaterial = _mesh.material as TextureMaterial					
				commonDiffuseTexture = ATMaterial(MaterialLibrary.getMaterial(MaterialName.MENU_TEXTURE)).texture as BitmapTexture
				commonAmbientTexture = ATMaterial(MaterialLibrary.getMaterial(MaterialName.MENUOVER_TEXTURE)).texture as BitmapTexture
			}
			
			buildLightAndMaterial();
		}
		
		private function buildLightAndMaterial():void
		{
			MeshHelper.recenter(_mesh)
			
			if(buildLight){
				_material = new TextureMaterial(commonDiffuseTexture,true,true,true);
				_material.ambientTexture = commonAmbientTexture
			}else{
				_material = new TextureMaterial(commonAmbientTexture,true,true,true);
			}
			var colorTransformMethod:ColorTransformMethod = new ColorTransformMethod()
			cT = new ColorTransform()
			colorTransformMethod.colorTransform = cT;
			_material.addMethod(colorTransformMethod);
			//_mesh.bounds = new BoundingSphere();
			_material.alphaBlending = true
			_material.alphaPremultiplied = false
			_material.specular = 0
			_material.alpha = 0
			if(buildLight){
				_light = new PointLight()
				_light.radius = 150
				_light.fallOff = _light.radius+5
				_mesh.parent.addChild(_light)
				_light.position = _mesh.position.clone();
				_light.y += 20
				_light.moveBackward(75)
				//_light.bounds = new BoundingSphere();
				//_light.showBounds = true
				_light.diffuse = 0		
					
				_lightpicker = new StaticLightPicker([_light])
				_material.lightPicker = _lightpicker
			}
			
			_mesh.material = _material
			/*_material.animateUVs = true
				
			SubMesh(_mesh.subMeshes[0]).scaleU = 0.8 
			SubMesh(_mesh.subMeshes[0]).scaleV = 0.8*/
		}
		
		public function get name():String
		{
			return _name
		}
		
		public function hide(delay:Number = 0):void
		{
			if(_material.alpha == 0) return
			TweenMax.to(_material, 0.3, {delay:delay, alpha:0})
		}
		
		public function show(delay:Number = 0):void
		{
			if(_material.alpha == 1) return
			//_material.alpha = 1
			//_light.z = -20
			//_light.radius = 10000
			//TweenMax.to(_material, 0.3, {startAt:{alpha:1, specular:3}, delay:delay, specular:0})
			TweenMax.to(_material, 0.3, {delay:delay, alpha:1})
		}
		
		public function over():void
		{
			if(_light.diffuse == 0) {
				//_light.diffuse = 0
				_light.z = 220
				_light.radius = 80
				_light.fallOff = _light.radius+5
			}
			
			TweenMax.to(_light, 0.2, {z:-20, radius:350, fallOff:360, ease:Expo.easeOut})
				
			if(_twDiffuse) _twDiffuse.pause()
			_twDiffuse = TweenMax.to(_light, 0.3, {diffuse:1, overwrite:false, ease:Expo.easeOut})
			
			nonOut();
				
			/*_light.diffuse = 1
			_light.z = -20
			_light.radius = 350
			_light.fallOff = _light.radius+10*/
		}
		
		public function out():void
		{
			/*_light.diffuse = 0
			_light.z = 220
			_light.radius = 80
			_light.fallOff = _light.radius+5*/
			//TweenMax.to(_light, 0.5, {diffuse:0.5, z:250, radius:100, fallOff:105})
			if(_twDiffuse) _twDiffuse.pause()
			_twDiffuse = TweenMax.to(_light, 0.8, {diffuse:0, overwrite:false})
		}
		
		public function blink():void
		{		
			_light.z = -20
			_light.radius = 350
			_light.fallOff = _light.radius+5
			
			TweenMax.to(_light, 1/10, {startAt:{diffuse:1}, diffuse:0, repeat:1, onComplete:completeBlink})
		}
		
		private function completeBlink():void
		{
			dispatchEvent(new StringEvent(MenuItem.BLINK_COMPLETE, this, name))
		}
		
		public function nonOver():void
		{
			
			if(cT){
				if(tweenCT ) tweenCT.pause();
				tweenCT = TweenMax.to(cT, 0.8, {blueMultiplier:0.7, redMultiplier:0.7, greenMultiplier:0.7})
			}
		}
		
		public function nonOut():void
		{
			if(cT){
				if(tweenCT) tweenCT.pause();
				tweenCT = TweenMax.to(cT, 0.3, {delay:0.1, blueMultiplier:1, redMultiplier:1, greenMultiplier:1})
			}
		}
	}
}