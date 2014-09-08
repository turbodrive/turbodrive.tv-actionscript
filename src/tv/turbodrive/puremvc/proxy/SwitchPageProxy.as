package tv.turbodrive.puremvc.proxy
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import tv.turbodrive.Main;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.controller.LoadAssetsCommand;
	import tv.turbodrive.puremvc.mediator.Stage3DMediator;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	
	public class SwitchPageProxy extends Proxy implements IProxy
	{
		private var _reelInitialized:Boolean = false
		private var _folioInitialized:Boolean = false
		
		static public const NAME:String = "SwitcPageProxy";
		static public const INIT_FOOTER:String = NAME+"initFooter";
		static public const END_SWITCH:String = NAME+"transitionComplete";
		public static const START_SWITCH:String = NAME+"startSwitch";
		public static const MULTIPART_RESUME_SWITCH:String = "multiPartResumeSwitch";
			
		static public const LIGHT_HEADER:String = NAME+"lightHeader";
		static public const LIGHT_TIMELINE:String = NAME+"lightTimeline";
		static public const GMD_APPEARING:String = NAME + "getMoreDetails_Appearing"
		static public const GMD_RESUME:String = NAME + "getMoreDetails_Resume"
		static public const GMD_PAUSE:String = NAME + "getMoreDetails_Pause"
		static public const GMD_HIDE:String = NAME + "getMoreDetails_Hide"
		
		public var currentEnvType:String = "";
		public var _currentPage:Page = null;
		public var _tmpPage:Page = null;
		public var lastChapter:Page;
			
		private var _reelVideoPlayer:ReelVideoPlayer;
		
		private var _waitAssets:Boolean = false;		
		private var _waitNetStream:Boolean = false;
		private var _inProgress:Boolean = false;

		private var _transitionPageData:TransitionPageData;

		private var _loadAssetsWhenLoopStart:Boolean;
		private var _debugTrace:Boolean = false
		
		public function SwitchPageProxy()
		{			
			super(NAME,null)
		}
		
		override public function onRegister():void
		{
			_reelVideoPlayer = ReelVideoPlayer.instance
			_reelVideoPlayer.init(StructureProxy(facade.retrieveProxy(StructureProxy.NAME)).getPageChildren(PagesName.REEL));
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.STREAM_READY_FOR_NEXT_PAGE, streamReadyForNextPage)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.CHANGE_PAGE_PLAYING, changePagePlaying)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.LIGHT_HEADER, lightHeaderHandler)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.LIGHT_TIMELINE, lightTimelineHandler)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.LIGHT_TIMELINE2, lightTimelineHandler2)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.GMD_APPEARING, gmdAppearingHandler)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.GMD_PAUSE, gmdPauseHandler)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.GMD_RESUME, gmdResumeHandler)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.GMD_HIDE, gmdHideHandler)
			_reelVideoPlayer.addEventListener(ReelVideoPlayer.END_OF_VIDEO, endOfVideoHandler)
		}
		
		protected function endOfVideoHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.CHANGE_PAGE, PagesName.ABOUT);
		}
		
		protected function gmdHideHandler(event:Event):void
		{
			sendNotification(GMD_HIDE)
		}
		
		protected function gmdPauseHandler(event:Event):void
		{
			sendNotification(GMD_PAUSE)
		}
		
		protected function gmdResumeHandler(event:Event):void
		{
			sendNotification(GMD_RESUME)
		}
		
		protected function gmdAppearingHandler(event:NumberEvent):void
		{
			sendNotification(GMD_APPEARING, event.getNumber() )
		}
		
		protected function lightHeaderHandler(event:Event):void
		{
			sendNotification(LIGHT_HEADER)
		}
		
		protected function lightTimelineHandler(event:Event):void
		{
			sendNotification(LIGHT_TIMELINE, true)
		}
		
		protected function lightTimelineHandler2(event:Event):void
		{
			sendNotification(LIGHT_TIMELINE, false)
		}
		
		protected function streamReadyForNextPage(event:Event):void
		{
			if(_debugTrace) trace("streamReadyForNextPage !")
			
			// Stream ready to play for requested page.			
			if(isReelIntro(_tmpPage)){
				// cas particulier, 1ère page c'est le reel, on passe directement en resume + dispatch onComplete				
				onTransitionComplete()				
				setTimeout(reelIntroStep2,500)
			}else if(isReelSeekSwitch(_tmpPage)){
				// REEL CHAPTER TO REEL CHAPTER
				onTransitionComplete()
			}else{
				process(_tmpPage, false, true)
			}
		}
		
		private function changePagePlaying(e:PageEvent):void
		{
			sendNotification(ApplicationFacade.CHANGE_PAGE,e.page);
		}
		
		private function reelIntroStep2():void
		{
			_reelVideoPlayer.resume(true);
			dispatchBackgroundLoadAsset();
			//sendNotification(SHOW_2D_VIDEO)
		}
		
		public function process(requestedPage:Page, preintro:Boolean = false, unpause:Boolean = false):void
		{
			if(_inProgress) //if(_debugTrace) trace("-------- Warning, process in progress... ! ----------")
			
			if(_tmpPage){
				// il y a une page temporaire, donc on est dans une transition ou bien en attente du chargement des assets pour terminer la transitions
				if(requestedPage.id != _tmpPage.id){
					// demande d'une page différente de celle en attente, on annule donc la demande de la page temporaire
					_tmpPage = null
				}else{
					// on demande la même page que celle en cours...
					if(_waitAssets || _waitNetStream){
						// des assets sont en cours de chargement
						if(unpause){
							// c'est une demande normale interne, les assets demandés sont chargés, on passe à la suite (lancement de la transition)
						}else{							
							// c'est une demande de l'internaute, comme les assets ne sont pas prêts, on arrête la demande
							return
						}
					}else{
						// il y a une page temporaire et un pas de _waitAssets... on est donc en cours de transition
						// pour le moment, pas de start/complete transition implémentés, donc pas vraiment possible de tomber dans ce cas
						throw new Error("Erreur de transition : page temporaire dans le TransitionProxy et pas de _waitAssets")
					}
				}
			}
			
			if(_debugTrace) trace("SwitchPageProxy processPage >> " + requestedPage.id)
			
			//required page type >> REEL or FOLIO
			var envType:String = requestedPage.environment
			_tmpPage = requestedPage			
			sendNotification(INIT_FOOTER, requestedPage)
			_transitionPageData = new TransitionPageData(_currentPage, requestedPage)
			
			if(isReelIntro(requestedPage)){
				// INTRO REEL (first page is REEL)
				_inProgress = _reelVideoPlayer.switchInProgress = _waitNetStream = true				
				_reelVideoPlayer.movePlayHead(preintro ? 0 : requestedPage.cuepoint)
			}else if(isReelSeekSwitch(requestedPage)){
				// REEL CHAPTER TO REEL CHAPTER
				_inProgress = _reelVideoPlayer.switchInProgress = _waitNetStream = true
				if(_reelVideoPlayer.seek(requestedPage)){
					onTransitionComplete();
				}
			}else if(isSimpleSwitch(requestedPage)){
				// SIMPLE CAM TRANSITION (More Projects to More Projects or Selected cases to Selected Cases if the assets are already loaded)
				if(_debugTrace) trace("[Switch Page Proxy] START_SIMPLE_SWITCH")
				_inProgress = _reelVideoPlayer.switchInProgress = true
				_transitionPageData = new TransitionPageData(_currentPage, requestedPage, true)
				sendNotification(START_SWITCH, _transitionPageData);
			}else {				
				// 2 conditions : transition is in progress (loop) and required assets are loaded
				if(_debugTrace) trace("@@@@@@@ requestedPage.assetsAreLoaded() ? "+ requestedPage.assetsAreLoaded())
				if(((requestedPage.environment == PagesName.FOLIO && requestedPage.assetsAreLoaded()) || (requestedPage.environment == PagesName.REEL && _reelVideoPlayer.isReadyToResumeForNextPage()))){
					if(_inProgress){
						if(_debugTrace) trace("[Switch Page Proxy] MULTIPART_RESUME_SWITCH")						
						sendNotification(MULTIPART_RESUME_SWITCH, _transitionPageData);	
						//_inProgress = false
					}else{
						if(_debugTrace) trace("[Switch Page Proxy] MULTIPART_DIRECT_SWITCH")
						_inProgress = _reelVideoPlayer.switchInProgress = true;
						sendNotification(START_SWITCH, _transitionPageData);
					}
				}else{
					if(_inProgress){
						if(_debugTrace) trace(" !! Implements shifting page during load progress")
					}else{
						if(_debugTrace) trace("[Switch Page Proxy] MULTIPART_LOAD_SWITCH")
						_transitionPageData.waitLoading = true;
						_reelVideoPlayer.switchInProgress = true;
						if(_debugTrace) trace("Assets Are LOADED > " + requestedPage.assetsAreLoaded());
						//if(!_transitionPageData.waitLoadedAssetBeforeStart){
							_inProgress = true;
							sendNotification(START_SWITCH, _transitionPageData);
						if(requestedPage.environment == PagesName.FOLIO){
							if(_debugTrace) trace("[Switch Page Proxy]  -dispatchLoad Assets");
							_waitAssets = true
							//dispatchLoadAssets(requestedPage);
						}else{
							_waitNetStream = true;
							_reelVideoPlayer.movePlayHead(requestedPage.cuepoint-0.5);
							if(_debugTrace) trace("WAIT NET STREAM >> From Folio to Reel")
						}
					}					
				}							
			}					
		}
		
		public function switchInProgress():Boolean
		{
			return _inProgress
		}
		
		/** TESTS SPLIT **/
		
		private function isReelSeekSwitch(requestedPage:Page):Boolean
		{
			if(!_currentPage) return false
			return (_currentPage.environment == PagesName.REEL && requestedPage.environment == PagesName.REEL)
		}
		
		private function isReelIntro(requestedPage:Page):Boolean
		{
			return (!_currentPage && requestedPage.environment == PagesName.REEL)
		}
		
		private function isSimpleSwitch(requestedPage:Page):Boolean
		{
			if(_inProgress) return false			
			if(!_currentPage || _currentPage.environment != PagesName.FOLIO) return false
			if(_currentPage.category == PagesName.MORE_PROJECTS && requestedPage.category == PagesName.MORE_PROJECTS) return true
			if(_currentPage.category == PagesName.SELECTED_CASES && requestedPage.category == PagesName.SELECTED_CASES && requestedPage.assetsAreLoaded()) return true
			return false
		}
				
		
		/** ----------------**/
		
		private function dispatchBackgroundLoadAsset():void
		{
			//if(_debugTrace) trace("load required Assets + Assets from " + page.id)
			sendNotification(ApplicationFacade.LOAD_ASSETS);
			_waitAssets = false
		}
		
		private function dispatchLoadAssets(page:Page):void
		{
			//if(_debugTrace) trace("load required Assets + Assets from " + page.id)
			sendNotification(ApplicationFacade.LOAD_ASSETS, page);
			_waitAssets = true
		}
		
		private function registerReelPlayerProxy(startCuePoint:Number, waitNs:Boolean):void
		{
			if(_reelInitialized) return
			_waitNetStream = waitNs
			//_reelPlayerProxy = new ReelPlayerProxy(currentEnvType == "", startCuePoint)
			//facade.registerProxy(_reelPlayerProxy)
			_reelInitialized = true
		}
		
		public function onTransitionComplete():void
		{
			if(_debugTrace) trace("01 [Switch Page Proxy]  transition complete >> Page : " + _currentPage)
			
			_inProgress = _reelVideoPlayer.switchInProgress = false
			_waitAssets = _waitNetStream = false
			// normalement à changer à la fin de la transition
			_currentPage = _tmpPage
			if(_currentPage.environment == PagesName.FOLIO) _reelVideoPlayer.resetFlags();
			_tmpPage = null
			currentEnvType = _currentPage.environment
			sendNotification(END_SWITCH,_transitionPageData);
			_transitionPageData = null
			if(_debugTrace) trace("02 [Switch Page Proxy]  transition complete >> Page : " + _currentPage)
			
			Main(Main.INSTANCE).dispatchMainReady()
		}		
		
		public function getCurrentPage():Page
		{
			return _currentPage	
		}				
		
		public function resumeProcessing(key:String):void
		{
			if(_debugTrace) trace("[Switch Page Proxy]  resumeProcessing - " + key)
			
			if((_waitAssets && (key == Stage3DMediator.NAME || key == LoadAssetsCommand.NAME))/* || (_waitNetStream && key == ReelPlayerProxy.NAME)*/){
				process(_tmpPage,false,true);
			}
		}		
		
		public function currentTransitionComplete(pageTarget:Page):void
		{			
			if(!_inProgress){
				if(_debugTrace) trace("Attention - Fin de transition et pas de transition en cours  >> Retour sur le chapitre de la vidéo en pause ?")
				return
			}
			
			if(pageTarget.id == _tmpPage.id){
				onTransitionComplete()				
			}else{
				throw new Error("Erreur : page cible de transition et page temporaire différentes");
			}
		}
	
	}
}