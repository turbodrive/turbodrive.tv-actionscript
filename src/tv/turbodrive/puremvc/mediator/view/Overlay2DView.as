package tv.turbodrive.puremvc.mediator.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.away3d.elements.entities.GroupTps3D;
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3DName;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.AwardsContentView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.ExtraContentView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.MpContentView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.MpSkillsView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.OverlayGridView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.ScContentView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.SpriteDrivenBy3D;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.VideoPlayerView;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.WorkContentView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.utils.MathUtils;
	
	
	public class Overlay2DView extends Sprite
	{
		public static const NAVIGATE_TO_SUBPAGE:String = "navigateToSubPage"		
		
		private var _currentSubPageContent:String
		private var _oldSubPageContent:String
		
		public static const ANGLE_RIGHT:Number = 24.5
		public static const ANGLE_LEFT:Number = -47.5
		private var _currentSpritesList:Vector.<SpriteDrivenBy3D>  =  new Vector.<SpriteDrivenBy3D>();
		private var _oldSpritesList:Vector.<SpriteDrivenBy3D>  =  new Vector.<SpriteDrivenBy3D>();
		private var _dictionnarySprites:Dictionary
				
		public function Overlay2DView()
		{			
			MathUtils.ANGLE_SKEW_DEGREES = ANGLE_RIGHT
		}
		
		public function getSpriteForTps3d(tps3d:TriPosSprite3D = null, page:Page = null):SpriteDrivenBy3D
		{
			if(!tps3d) return null
			for(var i:int = 0; i<_currentSpritesList.length;i++){
				if(_currentSpritesList[i].name == tps3d.name) return _currentSpritesList[i]
			}	
			
			if(tps3d.name == TriPosSprite3DName.MAIN) return new ScContentView(this);
			if(tps3d.name == TriPosSprite3DName.MP_MAIN) return new MpContentView(this);
			if(tps3d.name == TriPosSprite3DName.MP_SKILLS) return new MpSkillsView(this);
			if(tps3d.name == TriPosSprite3DName.PLAYER) return new VideoPlayerView(this);
			//if(tps3d.name == TriPosSprite3DName.EXTRA) return new ExtraContentView(this);
			if(tps3d.name == TriPosSprite3DName.WORK) return new WorkContentView(this);
			if(tps3d.name == TriPosSprite3DName.TITLE_EXTRA) return new ExtraContentView(this);
			if(tps3d.name == TriPosSprite3DName.AWARDS) return new AwardsContentView(this);
			if(tps3d.name == TriPosSprite3DName.OVERLAY_GRID) return new OverlayGridView(this);
			
			return null
		}
		
		public function getTriPosSprite3d(name:String):TriPosSprite3D
		{
			return TriPosSprite3D(_dictionnarySprites[name])
		}
		
		public function openSubPage(gtps3d:GroupTps3D):void
		{
			//trace("OVERLAY_2D_VIEW >> OPENSUBPAGE" + gtps3d.page.id + " - " + gtps3d.subPageName + " - " + gtps3d.tps3D[0].name)
			
			var i:int
			var sprtDrv:SpriteDrivenBy3D
			if(_currentSpritesList){
				
				// on va comparer les 2 listes et ne supprimer que les gtps3d qui ne sont pas dans le nouveau
				for(var j:int = 0; j<_currentSpritesList.length; j++){
					var currentGtps3d:SpriteDrivenBy3D = _currentSpritesList[j] as SpriteDrivenBy3D
					currentGtps3d.toTmpDestroy()
				}			
			}
			
			var newSpriteList:Vector.<SpriteDrivenBy3D>  =  new Vector.<SpriteDrivenBy3D>();

			if(_currentSubPageContent){
				_oldSubPageContent = _currentSubPageContent
			}
			_currentSubPageContent = gtps3d.subPageName				
			_dictionnarySprites = new Dictionary();		
			
			for(i = 0; i< gtps3d.tps3D.length; i++){
				sprtDrv = getSpriteForTps3d(gtps3d.tps3D[i], gtps3d.page)
				
				if(sprtDrv){					
					if(sprtDrv.haveToDestroy()){
						sprtDrv.rehab()
					}else{						
						sprtDrv.name = gtps3d.tps3D[i].name
						sprtDrv.buildContent(gtps3d.page)
						sprtDrv.addEventListener(NAVIGATE_TO_SUBPAGE, navigateToSubPageHandler)						
						addChild(sprtDrv)						
						sprtDrv.updatePosition(gtps3d.rectangles[i], gtps3d.tps3D, gtps3d.page.category == PagesName.MORE_PROJECTS ? -8 : -3);	
					}
					newSpriteList.push(sprtDrv)
					
				}
				_dictionnarySprites[gtps3d.tps3D[i].name] = gtps3d.tps3D[i]
			}
			
			for(i = 0; i<_currentSpritesList.length;i++){
				if(_currentSpritesList[i].haveToDestroy()){
					_currentSpritesList[i].removeEventListener(NAVIGATE_TO_SUBPAGE, navigateToSubPageHandler)
					_currentSpritesList[i].hideAndRemove()
				}
			}
			
			_currentSpritesList = newSpriteList
		}
		
		protected function navigateToSubPageHandler(event:Event):void
		{
			dispatchEvent(event.clone())
		}
		
		public function updateTitlePosition(gtps3d:GroupTps3D):void
		{	
			if(gtps3d.rectangles.length < _currentSpritesList.length) return
			for(var i:int = 0; i< _currentSpritesList.length; i++){
				var sprtDrv:SpriteDrivenBy3D = _currentSpritesList[i]
				sprtDrv.updatePosition(gtps3d.rectangles[i], null, gtps3d.page.category == PagesName.MORE_PROJECTS ? -8 : -3)
			}
		}		
		
		public function closeSubPage():void
		{
			for(var i:int = 0; i< _currentSpritesList.length; i++){
				var sprtDrv:SpriteDrivenBy3D = _currentSpritesList[i]
				sprtDrv.removeEventListener(NAVIGATE_TO_SUBPAGE, navigateToSubPageHandler)
				var destroy:Boolean = sprtDrv.hideAndRemove();
				//_currentSpritesList.splice(i,1);
			}
			//spriteList
			_currentSpritesList =  new Vector.<SpriteDrivenBy3D>();
			_dictionnarySprites = new Dictionary();
		}
		
		public function destroy():void
		{		
			closeSubPage()
			for(var i:int = 0; i< _currentSpritesList.length; i++){
				var sprtDrv:SpriteDrivenBy3D = _currentSpritesList[i]
				sprtDrv.destroy();
			}
			
			_oldSpritesList = null
			_currentSpritesList = null
			_dictionnarySprites = null
		}		
		
		public function resumeContent():void
		{
			for(var i:int = 0; i< _currentSpritesList.length; i++){
				var sprtDrv:SpriteDrivenBy3D = _currentSpritesList[i]
				sprtDrv.resume()
			}
		}
		
		public function pauseContent():void
		{
			for(var i:int = 0; i< _currentSpritesList.length; i++){
				var sprtDrv:SpriteDrivenBy3D = _currentSpritesList[i]
				sprtDrv.pause()
			}
		}
	}
}