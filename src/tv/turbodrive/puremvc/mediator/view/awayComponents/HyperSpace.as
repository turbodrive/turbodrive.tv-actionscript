package tv.turbodrive.puremvc.mediator.view.awayComponents
{
	
	import a3dparticle.ParticlesContainer;
	import a3dparticle.animators.actions.color.RandomColorLocal;
	import a3dparticle.animators.actions.position.OffsetPositionLocal;
	import a3dparticle.animators.actions.scale.RandomScaleLocal;
	import a3dparticle.animators.actions.velocity.VelocityGlobal;
	import a3dparticle.generater.SingleGenerater;
	import a3dparticle.particle.ParticleColorMaterial;
	import a3dparticle.particle.ParticleParam;
	import a3dparticle.particle.ParticleSample;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;

	public class HyperSpace extends ObjectContainer3D
	{
		private var _particlesIntro:ParticlesContainer
		private var _particlesMain:ParticlesContainer
		
		private var splitWidth:Number = 200;
		private var splitHeight:Number = 200;
		
		public function HyperSpace()
		{
			build();
		}
		
		public function build():void
		{
			var material:ParticleColorMaterial = new ParticleColorMaterial(0x99BFBF89)
			var materiaMain:ParticleColorMaterial = new ParticleColorMaterial(0xEECCBFBF89)
			material.blendMode = BlendMode.ADD;
			materiaMain.blendMode = BlendMode.ADD;
			
			var cube:CubeGeometry = new CubeGeometry(8, 8, 10, 1, 1, 1, false);			
			var sample:ParticleSample = new ParticleSample(cube.subGeometries[0], material);
			var generater:SingleGenerater = new SingleGenerater(sample, 1000);			
			_particlesIntro = new ParticlesContainer();
			//_view.scene.addChild(_particlesIntro);
			
			// 9 - 9 -3000/400
			var cubeMain:CubeGeometry = new CubeGeometry(10, 10, 400, 1, 1, 1, false);			
			var sampleMain:ParticleSample = new ParticleSample(cubeMain.subGeometries[0], materiaMain);
			var genMain:SingleGenerater = new SingleGenerater(sampleMain, 2000);	
			_particlesMain = new ParticlesContainer();
			
			
			_particlesIntro.loop = false;
			_particlesMain.loop = true;
			
			// -10000/-15000
			_particlesMain.addAction(new VelocityGlobal(new Vector3D(0, 0, -15000)));
			_particlesIntro.addAction(new OffsetPositionLocal());
			_particlesIntro.addAction(new RandomColorLocal(null,true,false));
			_particlesIntro.addAction(new RandomScaleLocal());
			_particlesMain.addAction(new OffsetPositionLocal());
			var action4:RandomColorLocal = new RandomColorLocal(null,true,false);
			_particlesMain.addAction(action4);
			
			_particlesIntro.initParticleFun = initParticleParam;
			_particlesMain.initParticleFun = initParticleMain;
			_particlesIntro.generate(generater);
			_particlesMain.generate(genMain)
			_particlesIntro.start();
			_particlesIntro.z = 2000
			_particlesMain.z = 9000
			
			addChild(_particlesIntro);
			
		}
		
		private function initParticleParam(param:ParticleParam):void
		{
			var rangeWidth:Number = 8000;
			var rangeHeight:Number = 5000;
			param.startTime = 0//Math.random()*8;
			param.duringTime = 1//1.1;
			//param["VelocityLocal"] = new Vector3D(0, /*Math.random() * 50*/500, 0);
			var randX:Number = Math.random() * rangeWidth - (rangeWidth>>1);
			/*if(randX < splitWidth || randX > -splitWidth){
			if(randX > 0){
			randX += splitWidth
			}else{
			randX -= splitWidth
			}
			}*/
			
			var randY:Number = Math.random() * rangeHeight - (rangeHeight>>1);
			/*if(randY < splitWidth || randY > -splitWidth){
			if(randY > 0){
			randY += splitWidth
			}else{
			randY -= splitWidth
			}
			}*/
			param["OffsetPositionLocal"] = new Vector3D(randX, randY, 10/*Math.random() * 1000 - 500*/);
			var scale:Number = 0.5 + Math.random();
			param["RandomScaleLocal"] = new Vector3D(scale, scale, scale);
			param["RandomColorLocal"] = getColor();
		}
		
		private function initParticleMain(param:ParticleParam):void
		{
			var rangeWidth:Number = 4000;
			var rangeHeight:Number = 2500;
			
			param.startTime = Math.random()*5;
			param.duringTime = 2;
			var randX:Number = Math.random() * rangeWidth - (rangeWidth>>1);
			/*if(randX < splitWidth || randX > -splitWidth){
			if(randX > 0){
			randX += splitWidth
			}else{
			randX -= splitWidth
			}
			}*/
			
			var randY:Number = Math.random() * rangeHeight - (rangeHeight>>1);
			if(randY > -splitHeight && randY < splitHeight && randX > -splitWidth && randX < splitWidth){
				if(randY > -splitHeight && randY < splitHeight){
					if(randY > 0){
						randY += splitHeight
					}else{
						randY -= splitHeight
					}
				}
				if(randX > -splitWidth && randX < splitWidth){
					if(randX > 0){
						randX += splitWidth
					}else{
						randX -= splitWidth
					}
				}
			}
			//param["OffsetPositionLocal"] = new Vector3D(randX, randY, (Math.random() * 1000)+6000 );
			param["OffsetPositionLocal"] = new Vector3D(randX, randY, -(Math.random() * 1000) );
			param["RandomColorLocal"] = getColor();
			//var scale:Number = 0.5 + Math.random();
			//param["RandomScaleLocal"] = new Vector3D(scale, scale, scale);
		}
		
		private function getColor():ColorTransform
		{
			var ct:ColorTransform
			var chx:int = Math.random()*4
			
			// rouge-violet
			if(chx == 0) ct = new ColorTransform(1,0,0);
			if(chx == 1) ct = new ColorTransform(0.8,0.1,0);
			if(chx == 2) ct = new ColorTransform(0.5,0,0.3);
			if(chx == 3) ct = new ColorTransform(1,1,1);
			
			// alpha
			/*if(chx == 0) ct = new ColorTransform(1,1,1,1);
			if(chx == 1) ct = new ColorTransform(1,1,1,0.4);
			if(chx >= 2) ct = new ColorTransform(1,1,1,0.1);*/
			//if(chx == 3) ct = new ColorTransform(1,1,1,0.1);
			
			/*if(chx == 0) ct = new ColorTransform(1,1,1);
			if(chx == 1) ct = new ColorTransform(1,1,2,1,3);
			if(chx == 2) ct = new ColorTransform(0.5,0.9,0.8);*/
			
			return ct
		}
		
		public function startHyperSpace():void
		{
			_particlesMain.bounds.fromExtremes(-12000,-8000,-200,12000,8000,200);
			
			//addChild(_particleSquare);			
			addChild(_particlesMain);
			
			TweenMax.to(_particlesIntro,2,{scaleZ:250, ease:Quad.easeInOut })
			TweenMax.to(_particlesIntro,1.4,{delay:0.6, z:-7000, ease:Quad.easeIn, overwrite:false, onComplete:removeIntroParticles })
			setTimeout(startMain,800)
			//TweenMax.to(_camContainer,3,{delay:2, rotationZ:40, ease:Quad.easeInOut});
			
		}
		
		private function startMain():void
		{
			_particlesMain.start();
			//_particleSquare.start();
		}
		
		public function removeIntroParticles():void
		{
			_particlesIntro.stop();
			removeChild(_particlesIntro)
		}
	}
}