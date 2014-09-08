package tv.turbodrive.away3d.transitions
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.ParticleColorNode;
	import away3d.animators.nodes.ParticlePositionNode;
	import away3d.animators.nodes.ParticleVelocityNode;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ParticleGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.ParticleGeometryHelper;

	public class HyperDrive extends ObjectContainer3D
	{
		private var splitWidth:Number = 200;
		private var splitHeight:Number = 200;

		private var _mainAnimator:ParticleAnimator;
		private var meshHyperDrive:Mesh;
		private var materialMain:ColorMaterial;		
		private var zBase:int = 12000		
		private var _prtclVelocityNode:ParticleVelocityNode;
		private var _tTime:Number;
		public var timeSpeed:Number = 0.5
		
		public function HyperDrive()
		{
			super();				
			init();
		}
		
		private function init():void
		{
			var helper:Mesh = new Mesh(new PlaneGeometry(1280,720,1,1,false, true), new ColorMaterial(0xCCDDFF,0.2));
			//addChild(helper);
			
			var material:ColorMaterial = new ColorMaterial(0x99BFBF89)
			//var materialMain:ColorMaterial = new ColorMaterial(0xEECCBFBF89)
			materialMain = new ColorMaterial(0xBFBF89,0.8)
			//material.blendMode = BlendMode.ADD;
			materialMain.blendMode = BlendMode.ADD;
			
			//var cube:CubeGeometry = new CubeGeometry(8, 8, 10, 1, 1, 1, false);			
			/*var sample:ParticleSample = new ParticleSample(cube.subGeometries[0], material);
			var generater:SingleGenerater = new SingleGenerater(sample, 1000);			
			_particlesIntro = new ParticlesContainer();*/
			//_view.scene.addChild(_particlesIntro);
			
			// 9 - 9 -3000/400
			var cubeMain:CubeGeometry = new CubeGeometry(7, 6, 500, 1, 1, 1, false);
			var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
			var i:int
			for(i= 0; i< 3000; i++){
				geometrySet.push(cubeMain)
			}			
			
			var particleGeometry:ParticleGeometry = ParticleGeometryHelper.generateGeometry(geometrySet);
			var animationSet:ParticleAnimationSet = new ParticleAnimationSet(true, true, false);
			animationSet.initParticleFunc = initParticleParam;
			animationSet.addAnimation(new ParticlePositionNode(ParticlePropertiesMode.LOCAL_STATIC));
			animationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.GLOBAL, new Vector3D(0,0,-15000)));
			//_prtclVelocityNode = new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_DYNAMIC, new Vector3D(0,0,-15000))
			//animationSet.addAnimation(_prtclVelocityNode);	
			animationSet.addAnimation(new ParticleColorNode(ParticlePropertiesMode.LOCAL_STATIC));	
			
			
			meshHyperDrive = new Mesh(particleGeometry, materialMain);
			
			_mainAnimator = new ParticleAnimator(animationSet);
			//_mainAnimator.autoUpdate = false
			meshHyperDrive.animator = _mainAnimator
			meshHyperDrive.bounds.fromExtremes(-10000,-8000,-200,30000,8000,200);
			meshHyperDrive.z = zBase
			
			addChild(meshHyperDrive);			
		}
		
		public function initParticleParam(param:ParticleProperties):void
		{
			
			var rangeWidth:Number = 4000;
			var rangeHeight:Number = 2500;
			
			param.startTime = Math.random()*5;
			param.duration = 3;
			var randX:Number = Math.random() * rangeWidth - (rangeWidth>>1);
		
			
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
			param[ParticlePositionNode.POSITION_VECTOR3D] = new Vector3D(randX, randY, -(Math.random() * 1000) );
			var col:ColorTransform = getColor();
			param[ParticleColorNode.COLOR_START_COLORTRANSFORM] = col
			param[ParticleColorNode.COLOR_END_COLORTRANSFORM] = col;
			//var scale:Number = 0.5 + Math.random();
			//param["RandomScaleLocal"] = new Vector3D(scale, scale, scale);
		}
		
		private function getColor():ColorTransform
		{
			var ct:ColorTransform
			var chx:int = Math.random()*4
			
			// rouge-violet
			/*if(chx == 0) ct = new ColorTransform(1,0,0);
			if(chx == 1) ct = new ColorTransform(0.8,0.1,0);
			if(chx == 2) ct = new ColorTransform(0.5,0,0.3);
			if(chx == 3) ct = new ColorTransform(1,1,1);*/
			
			// alpha
			if(chx == 0) ct = new ColorTransform(1,1,1,1);
			if(chx == 1) ct = new ColorTransform(1,1,1,0.4);
			if(chx >= 2) ct = new ColorTransform(1,1,1,0.1);
			//ct = new ColorTransform(1,1,1,1);
			//if(chx == 3) ct = new ColorTransform(1,1,1,0.1);
			
			/*if(chx == 0) ct = new ColorTransform(1,1,1);
			if(chx == 1) ct = new ColorTransform(1,1,2,1,3);
			if(chx == 2) ct = new ColorTransform(0.5,0.9,0.8);*/
			
			return ct
		}
		
		public function reset():void
		{
			meshHyperDrive.z = zBase
			materialMain.alpha = 0
		}
		
		public function start():void
		{
			_mainAnimator.update(0);
			timeSpeed = 0.5
			//materialMain.alpha = 0.2
			
			_mainAnimator.playbackSpeed = 0.5
			_mainAnimator.start();
			
			//_tTime  = setInterval(updateTime,1000/25);
		}
		
		public function show():void
		{
			materialMain.alphaBlending = true
			materialMain.alphaPremultiplied = false
			TweenMax.to(materialMain,1.5,{alpha:1, ease:Quad.easeIn, delay:0.15})
		}
		
		public function increaseSpeed(time:Number = 1, delay:Number = 0):void
		{
			TweenMax.to(_mainAnimator,time, {delay:delay, playbackSpeed:1, ease:Quart.easeOut});
		}
		
		private function updateTime():void
		{
		 	//trace("absoluteTime = " + _mainAnimator.absoluteTime)
		 	/*trace("time = " + _mainAnimator.time)
			var timePlus:Number = (1000/25)*timeSpeed
			_mainAnimator.update( _mainAnimator.time + timePlus)*/
		}
		
		public function hideAndStop():void
		{
			clearInterval(_tTime)
			TweenMax.to(materialMain,1,{alpha:0, onComplete:stopAnimator})
		}
		
		public function stop():void
		{
			clearInterval(_tTime)
			TweenMax.to(meshHyperDrive,1,{z:-2000, ease:Quad.easeIn, onComplete:stopAnimator})
			TweenMax.to(materialMain,1,{alpha:0, ease:Quad.easeIn})
		}
		
		private function stopAnimator():void
		{
			clearInterval(_tTime)
			_mainAnimator.stop()
			reset();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
	}
}