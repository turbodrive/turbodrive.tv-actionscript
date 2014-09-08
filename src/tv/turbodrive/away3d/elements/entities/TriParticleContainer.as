package tv.turbodrive.away3d.elements.entities
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	import away3d.entities.Mesh;
	import away3d.events.AnimatorEvent;
	import away3d.materials.ColorMaterial;
	
	import tv.turbodrive.away3d.elements.meshes.TriParticle;

	public class TriParticleContainer extends PerspScaleContainer
	{
		
		private var _mainMesh:Mesh;
		private var _triParticle:TriParticle;
		private var _mainMat:ColorMaterial;
		private var _delayFade:Number;
		
		public function TriParticleContainer(mainMesh:Mesh, triParticle:TriParticle, delayFade:Number = 0.8)
		{
			_delayFade = delayFade
			
			_mainMesh = mainMesh
			this.transform = _mainMesh.transform.clone()		
			_mainMesh.transform = new Matrix3D();
			addChild(_mainMesh)
			_mainMesh.scaleZ = 0.25
						
			_triParticle = triParticle
			_triParticle.z = 5
			addChild(_triParticle);
			
			_mainMat = _mainMesh.material as ColorMaterial
			reset()
		}
		
		public function start():void
		{
			if(!this.contains(_triParticle)) return
			_triParticle.addEventListener(AnimatorEvent.CYCLE_COMPLETE, animationComplete)
			_triParticle.startAnimation();
			TweenMax.to(_mainMat,0.8,{delay:_triParticle.duration-2.6, alpha:1})
		}
		
		protected function animationComplete(event:Event):void
		{
			_triParticle.removeEventListener(AnimatorEvent.CYCLE_COMPLETE, animationComplete)
				
			if(contains(_triParticle)) removeChild(_triParticle)
		}
		
		public function reset():void
		{
			_triParticle.stopAnimation()
			_mainMat.alpha = 0
		}
	}
}