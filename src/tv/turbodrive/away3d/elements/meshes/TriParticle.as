package tv.turbodrive.away3d.elements.meshes
{
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.ParticleColorNode;
	import away3d.animators.nodes.ParticlePositionNode;
	import away3d.animators.nodes.ParticleSpriteSheetNode;
	import away3d.core.base.Geometry;
	import away3d.core.base.ParticleGeometry;
	import away3d.entities.Mesh;
	import away3d.events.AnimatorEvent;
	import away3d.materials.TextureMaterial;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.tools.ParticleGeometryHelper;

	public class TriParticle extends Mesh
	{
		private var _dataParticles:Array;		
		private var _animatedColorTransform:Boolean = false;
		
		private static var mainBitmapData:BitmapData
		private static var mainBytesArray:ByteArray
		
		private var _started:Boolean = false
		private var _particleDuration:Number = 2.56
		private var _totalDuration:Number = 0;
		
		private var _materialTexture:TextureMaterial;
		private var durationFade:Number = 1;

		private var _fadeTween:TweenMax;
		public function TriParticle(dataParticles:Array, animatedColorTransform:Boolean = false)
		{
			_dataParticles = dataParticles
			_animatedColorTransform = animatedColorTransform
			super(null, null);
			build()
		}
		
		public function get duration():Number
		{
			return _totalDuration
		}
		
		private function build():void
		{
			var vec:Vector.<Number> = new <Number>[17.95,62.8,0,
				65.3, -52.85, 0,
				-70.6, -52.85, 0]
			var indices:Vector.<uint> = new <uint>[0,1,2]
			var defaultUVS:Vector.<Number> = Vector.<Number>([0.65, 0, 1, .849, 0, .849]);
			var buildedMesh:Mesh = MeshHelper.build(vec,indices,defaultUVS);
			//buildedMesh.material = new ColorMaterial(0xCC5500);
			var copyReverted:Mesh = MeshHelper.clone(buildedMesh,"reverted");
			MeshHelper.applyScales(copyReverted,-0.95,-0.95,1);
			MeshHelper.applyScales(buildedMesh,0.95,0.95,1);
			
			var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
			var i:int
			var leastDuration:Number = 0
			for(i= 0; i< _dataParticles.length; i++){
				if(_dataParticles[i].startTime > leastDuration) leastDuration = _dataParticles[i].startTime
				if(_dataParticles[i].reverted){
					geometrySet.push(copyReverted.geometry);
				}else{
					geometrySet.push(buildedMesh.geometry);
				}
			}
			
			_totalDuration = _particleDuration + leastDuration
			
			var particleGeometry:ParticleGeometry = ParticleGeometryHelper.generateGeometry(geometrySet);
			var animationSet:ParticleAnimationSet = new ParticleAnimationSet(false, false, false);
			animationSet.initParticleFunc = initParticleParam;
			animationSet.addAnimation(new ParticlePositionNode(ParticlePropertiesMode.LOCAL_STATIC));
			animationSet.addAnimation(new ParticleSpriteSheetNode(ParticlePropertiesMode.GLOBAL,false,false,8,8,2.56,0,64));
			//if(_animatedColorTransform) animationSet.addAnimation(new ParticleColorNode(ParticlePropertiesMode.LOCAL_STATIC,true,false));
			var _initMat:ATMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TRIPARTICLE))
			_materialTexture = new TextureMaterial(_initMat.texture,true,false,true);
			
			_materialTexture.bothSides = true	
			_materialTexture.alphaBlending = true
				
			this.geometry = particleGeometry
			this.material = _materialTexture
				
			animator = new ParticleAnimator(animationSet);			
			visible = true		
		}
		
		private function get particleAnimator():ParticleAnimator
		{
			return animator as ParticleAnimator
		}		
		
		private function initParticleParam(prop:ParticleProperties):void
		{			
			prop.startTime = _dataParticles[prop.index].startTime
			prop.duration = _particleDuration			
			prop[ParticlePositionNode.POSITION_VECTOR3D] = _dataParticles[prop.index].position
				
			if(_animatedColorTransform){
				prop[ParticleColorNode.COLOR_START_COLORTRANSFORM] = _dataParticles[prop.index].colorTransform
				prop[ParticleColorNode.COLOR_END_COLORTRANSFORM] = _dataParticles[prop.index].colorTransform;
			}
		}
		
		public function startAnimation():void
		{
			_started = true
			particleAnimator.start();				
			_fadeTween = TweenMax.to(_materialTexture, durationFade, {delay:_totalDuration-durationFade, alpha:0, onComplete:completeAnimation});
		}
		
		private function completeAnimation():void
		{
			visible = false
			stopAnimation()
			dispatchEvent(new AnimatorEvent(AnimatorEvent.CYCLE_COMPLETE,particleAnimator));
		}
		
		public function stopAnimation():void
		{
			if(!_started) return
			if(_fadeTween) _fadeTween.paused();
			particleAnimator.stop();
		}
	}
}