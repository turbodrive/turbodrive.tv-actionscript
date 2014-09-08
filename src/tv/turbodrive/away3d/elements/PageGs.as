package tv.turbodrive.away3d.elements
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import away3d.core.math.MathConsts;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class PageGs extends LeftContentGp3D
	{	
		private static var _redlineOffsetY:Number		
		private static var _firstLaunch:Boolean = true
			
				
		public function PageGs(page:Page)
		{
			
			super(page);
			_hasAwardBlock = false
			//_portalIn = new Gp3DVO({x:-10000,y:0,z:0, rotationX:0, rotationY:90, rotationZ:0, rigDistance:Tools3d.DISTANCE_Z_1280})
		}
		
		override protected function initMaterial():void
		{	
			if(_materialInitialized) return
			_addMainMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TOTGSTLBORGIA_ADD_TEXTURE) as ATMaterial)		
			super.initMaterial();		
		}

		
		override protected function createLocalScene():void
		{	
			super.createLocalScene();
			
			_extraContentY = 50 // (+ bas >> contenu qui monte)
			
			if(isNaN(_redlineOffsetY)) _redlineOffsetY = redLine.y + 40
			redLine.y = _redlineOffsetY
			_extraContainer.x = _extraContentX+1000
			_extraContainer.y = _extraContentY
			
			//if(_awardsBlock) _awardsBlock.extraScale = 1.2
			_workBlock.extraScale = 1.03
			_extraBlock.extraScale = 0.8
			_gs3dWork.setSource(_workBlock,600,720);
			//if(_awardsBlock) _gs3dAwards.setSource(_awardsBlock,530,375);			
			_gs3dExtra.setSource(_extraBlock,1000,500);	
			//_extraContainer.addChild(_gs3dAwards);
			_extraContainer.addChild(_gs3dWork);
			_extraContainer.addChild(_gs3dExtra);
			
			planText.z = -200
			planPlayer.z = -450
			clientName.z = -250		
			
		}		
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			super.startTransition(timelineDuration, transitionInfo);
			if(_firstLaunch){
				_firstLaunch = false
				_autoPlayTimer = new Timer(TIME_AUTOPLAY_VIDEO,1);
				_autoPlayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoPlayVideo);
				_autoPlayTimer.start();
			}
		}
		
		override public function hideTransition(subTransitionName:String = null):void
		{
			if(_autoPlayTimer) _autoPlayTimer.stop()
			super.hideTransition(subTransitionName);
		}
		
		private function autoPlayVideo(e:TimerEvent):void
		{
			_autoPlayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, autoPlayVideo);
			_autoPlayTimer.stop()
			_autoPlayTimer = null
			playVideoClickHandler();
		}
		
		override public function dispose():void{
			if(_autoPlayTimer){
				_autoPlayTimer.stop()
				_autoPlayTimer = null
			}
			super.dispose();
		}
		override public function resume():void{
			if(_autoPlayTimer) _autoPlayTimer.start()
			super.pause();
		}
		
		override public function pause():void{
			if(_autoPlayTimer) _autoPlayTimer.stop()
			super.pause();
		}
		
		override protected function getTriPosSprite3DList(subPageName:String):Vector.<TriPosSprite3D>
		{
			var tpss3d:Vector.<TriPosSprite3D>
			if(subPageName == SubPageNames.MAIN){
				tpss3d  = new <TriPosSprite3D>[_gs3dMain];					
			}else if(subPageName == SubPageNames.EXTRACONTENT){
				tpss3d= new <TriPosSprite3D>[_gs3dTitleExtra, _gs3dWork, _gs3dExtra];
			}else if(subPageName == SubPageNames.VIDEOPLAYER){
				tpss3d = new <TriPosSprite3D>[_gs3dMain, _gs3dPlayer];
			}
			
			if(!tpss3d) return null
			return tpss3d
		}
		
		/** LAYOUT X/Y **/		
		override protected function replaceContent():void
		{	
				
			_workBlock.x = _rX*120
			_workBlock.y = 60+(_sH/4) //60+(_sH/4)
			_gs3dWork.update()
			
			_extraBlock.x = _rX*-100 - 40
			_extraBlock.y = 0
			_gs3dExtra.update()
				
			if(_ratioPan){
				_visuelContainer.scaleX = _visuelContainer.scaleY = _scaleVisuel 
				_visuelContainer.x = -(_layoutRatioX*200)
			}else{
				_visuelContainer.scaleX = _visuelContainer.scaleY = _rX*1.28
				_visuelContainer.x = -(_layoutRatioY*180)
				_visuelContainer.y = -(_layoutRatioY*50)
			}
			
			redLine.z = planText.z -20
			redLine.y = 150
				
			//var offsetTitleExtra:Point = new Point(1300,105);
			var offsetTitleExtra:Point = new Point(632,60); // (y haut, décallé vers le haut de la ligne rouge)
			titleName2.position = redLine.position.clone();
			titleName2.x += offsetTitleExtra.x
			titleName2.y += offsetTitleExtra.y	
			clientName2.position = titleName2.position.clone();
			clientName2.y = titleName2.y + ((clientName2.height + titleName2.height) / 2) - 10
			clientName2.x = titleName2.x - (titleName2.width /2) + (clientName2.width/2)
				
			
			planPlayer.x =  (_rX * 640) + 220 - (_layoutRatioX*120)
			planText.x = _rX * -600 + (_layoutRatioX*120)			
			var oX:Number = 180 + (-640*_rX) + (_layoutRatioX*120)
			var oY:Number = 40 +( Math.sin(3*MathConsts.DEGREES_TO_RADIANS)*oX) ;
			var titlePosition:Vector3D = new Vector3D(redLine.x+oX,redLine.y+oY,-350);
			
			titleName.position = titlePosition			
			clientName.y = titlePosition .y + ((clientName.height + titleName.height) / 2) - 10
			var df:Number = titlePosition .y - clientName.y
			clientName.x = titlePosition .x - (titleName.width /2) + (clientName.width/2)

			super.replaceContent();
		}	
	}
}