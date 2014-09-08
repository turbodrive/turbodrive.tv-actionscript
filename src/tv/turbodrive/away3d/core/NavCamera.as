package tv.turbodrive.away3d.core
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	import away3d.cameras.Camera3D;
	import away3d.entities.Sprite3D;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	
	public class NavCamera extends RiggedCamera
	{
		//public var frontBgMaterial:ATMaterial;

		private var constantBg:Sprite3D;
		//private var frontBg:Sprite3D;
		private var violetBgMat:ATMaterial;
		//private var colorTransformMethod:ColorTransformMethod;
		private var cT:ColorTransform;
		private var _initScaleSprite:int = 65
			
		private var _resizedBg:Boolean = false
		
		public function NavCamera(camera:Camera3D)
		{	
			super(camera);

		}
		
		public function initExternalGraphics():void
		{	
			violetBgMat = MaterialLibrary.getMaterial(MaterialName.VIOLETBG)
			/*colorTransformMethod = new ColorTransformMethod()*/
			cT = new ColorTransform()
			//colorTransformMethod.colorTransform = cT;
			violetBgMat.colorTransform = cT
			constantBg = new Sprite3D(violetBgMat,1280,720)
			constantBg.subGeometry.scaleUV(1,((720/(1280/1024))/1024));
			//ATMaterial(constantBg.material).alphaBlending = false
			constantBg.scale(_initScaleSprite);
			_mainContainer.addChild(constantBg)
			constantBg.position = new Vector3D(0,0,65000);
		}
		
		public function get hasBeenResized():Boolean
		{
			return _resizedBg
		}
		
		public function fadeBgFromBlack():void
		{
			violetBgMat.colorTransform = new ColorTransform(0,0,0,1,0,0,0,0);			
			TweenMax.to(violetBgMat.colorTransform, 0.5, {delay:1, redMultiplier:1, greenMultiplier:1, blueMultiplier:1, redOffset:0, greenOffset:0, blueOffset:0, ease:Quad.easeOut})
		}
		
		public function updateViewPort(sw:Number, sh:Number):void
		{
			if(!constantBg) return
			var ratioInit:Number = 1280/720
			var currentRatio:Number = sw/sh
			var div:Number = ratioInit/currentRatio
				
			if(currentRatio > ratioInit){
				constantBg.scaleX = constantBg.scaleY =  (currentRatio/ratioInit)*_initScaleSprite
			}else{
				constantBg.scaleX = constantBg.scaleY = (ratioInit/currentRatio)*_initScaleSprite
			}
			
			_resizedBg = true
		}
	}
}