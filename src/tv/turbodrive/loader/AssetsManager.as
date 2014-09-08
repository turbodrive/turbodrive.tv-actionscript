package tv.turbodrive.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import away3d.arcane;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.ParserEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.misc.ResourceDependency;
	import away3d.loaders.misc.SingleFileLoader;
	import away3d.loaders.parsers.AWD2Parser;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.BinaryItem;
	
	import tv.turbodrive.Main;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.textures.ASyncBitmapTexture;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	import tv.turbodrive.puremvc.proxy.data.Asset;
	import tv.turbodrive.puremvc.proxy.data.AssetType;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.Path;
	import tv.turbodrive.zoe.SpriteSheetData;
	import tv.turbodrive.zoe.TextureType;
	
	use namespace arcane
	
	public class AssetsManager extends EventDispatcher 
	{
		static public const SPLASH_READY:String = "splashReady";
		static public const PROGRESS:String = "progressLoad";
		static public const JPEG_COMPLETE:String = "jpegComplete";
		static public const AWD2_COMPLETE:String = "Awd2Complete";
		
		static public var FONTS:String = "key_Font"
		static public var SOUNDS:String = "key_Sounds"
		static public var CSS:String = "key_CSS"	
		static public var CONFIG_XML:String = "key_ConfigXML"
		static public var HEXAMENU_AWD:String = "key_hexaMenu"
		
		static private var _assetsLoader:BulkLoader
		static private var _instance:AssetsManager
		static private var _requiredAssetsComplete:Boolean = false
			
		private var _jpegsProjectsLoaded:Dictionary = new Dictionary();
		private var _currentJpegGroup:String = ""
		
		private var _atfFilesList:Array;
		private var _numJpegs:int = 6;
		private var _awd2Complete:Boolean = false;
		
		private var _assetsList:Vector.<Asset> = new Vector.<Asset>
		private var _currentLoadingAssetsList:Vector.<Asset>
		private var _currentPage:Page
		
		private var _awd2Parser:AWD2Parser
		private var _waitAwdParsing:Boolean = false
		
		private var _awdToParse:Vector.<Asset>;
		private var _parsingAwd:int = 0
			
		private var _texturesToUpload:int = 0
		
		private var _loadingDependency:ResourceDependency;

		private var _dependencies:Vector.<ResourceDependency>;
		private var _parsingDependency:int = 0;
		public function AssetsManager(requires:SingletonEnforcer)
		{
			if (!requires) throw new Error("AssetsManager is a singleton, use static instance.");
			
			BulkLoader.registerNewType("awd", "AWD", BinaryItem);
			BulkLoader.registerNewType("atf", "ATF", BinaryItem);
			var _atmMaterialInit:MaterialLibrary = new MaterialLibrary() // INITIALIZE ATMATERIALLIST STATIC CONTENT
		}
		
		static public function get instance():AssetsManager 
		{
			if (!_instance) _instance = new AssetsManager(new SingletonEnforcer());
			return _instance;
		}
		
		/*** LOADING ***/
		
		public function load(newPage:Page = null):void
		{			
			/*Main(Main.INSTANCE).animloader.visible = true
			Main(Main.INSTANCE).animloader.play()*/
			
			_assetsLoader = new BulkLoader(BulkLoader.getUniqueName());
			_assetsLoader.addEventListener(BulkLoader.COMPLETE, completeLoadedAssetsHandler, false, 0, true);
			_assetsLoader.addEventListener(BulkLoader.ERROR, failHandler, false, 0, true);			
			_assetsLoader.addEventListener(BulkLoader.PROGRESS, progressLoadHandler, false, 0, true);			
			
			_currentLoadingAssetsList = new Vector.<Asset>
			
			addRequiredAssets()
			addPageAssets(newPage)		
			_assetsLoader.start()
			trace("Start LOAD ASSETS")
		}
		
		private function addRequiredAssets():void
		{
			if(_requiredAssetsComplete) return
			
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain)
			//_assetsLoader.add(Path.VIDEOS_XML, {id:VIDEOS_XML, weight:30} )
			_assetsLoader.add(Path.CSS_FILE, {id:CSS} )
			_assetsLoader.add(Path.FONTS_FILE, { id:FONTS, context: context })
			//_assetsLoader.add(Path.SOUNDS_FILE, {id:SOUNDS, context: context, weight:1291})
			
			
			for(var i:int = 0; i<_assetsList.length ;i++){
				var asset:Asset = _assetsList[i]
				if(asset.isRequired) addAssetToLoadingQueue(_assetsList[i])	
			}	
		}
		
		private function addPageAssets(newPage:Page = null):void
		{
			if(newPage){
				_currentPage = newPage
				// load needed assets for the new page
				for(var i:int = 0;i<newPage.assetsId.length ;i++){
					addAssetToLoadingQueue(getAssets(newPage.assetsId[i]))	
				}
			}else{
				_currentPage = null
			}
		}
		
		private function addAssetToLoadingQueue(asset:Asset):void
		{
			if(asset.isLoaded || asset.isLoading) return
			
			asset.isLoading = true
				
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain)
			//context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD
			_assetsLoader.add(asset.file, {id: asset.id, context: context})
			_currentLoadingAssetsList.push(asset)
				
			if(asset.jsonFile){
				var request:URLRequest = new URLRequest(asset.jsonFile);
				request.requestHeaders = [new URLRequestHeader("Content-Type", "application/json")];			
				request.method = URLRequestMethod.GET;							
				_assetsLoader.add(request, {id: asset.jsonFile})
			}
		}

		private function progressLoadHandler(e:Event):void 
		{
			_instance.dispatchEvent(new NumberEvent(PROGRESS,this,_assetsLoader.weightPercent));
		}
		
		private function completeLoadedAssetsHandler(e:Event):void 
		{			
			_assetsLoader.removeEventListener(BulkLoader.COMPLETE, completeLoadedAssetsHandler);
			_assetsLoader.removeEventListener(BulkLoader.ERROR, failHandler);
			_assetsLoader.removeEventListener(BulkLoader.PROGRESS, progressLoadHandler);			
			_currentPage = null
			
			processLoadedAssets()			
		}
		
		/*** PROCESSING ***/
		
		private function processLoadedAssets():void
		{
			var infosLoad:String = "Loaded Assets : ";
			
			_waitAwdParsing = false			
			_awdToParse = new Vector.<Asset>();
			_texturesToUpload = 0
				
			for(var i:int = 0; i< _currentLoadingAssetsList.length ;i++){
				var loadedAssetId:String = Asset(_currentLoadingAssetsList[i]).id
				for(var j:int = 0; j < _assetsList.length ; j++){
					var asset:Asset = Asset(_assetsList[j])
					if(loadedAssetId == asset.id){
						asset.isLoaded = true
						asset.isLoading = false
						infosLoad += "["+asset.id +"]  "
						
						// images & Spritesheet
						if(asset.type == AssetType.SPRITESHEET){
							// Create SpriteSheet or directly Material, uploadTexture
							
							var material:ATMaterial 
							if(asset.jsonFile){
								// create SpriteSheetData & ATMaterial
								var ssData:SpriteSheetData = new SpriteSheetData(getContent(asset.id),getContent(asset.jsonFile as String));
								material = ssData.createATMaterial();
								
								//trace("Material created from '" + asset.id + "' with json spritsheet")
							}else{
								material = SpriteSheetData.createATMat2(getContent(asset.id))
								//trace("Material created from '" + asset.id + "' without json spritsheet")
							}
							material.name = Asset(_assetsList[j]).id
							material.blendMode = Asset(_assetsList[j]).blendMode
							MaterialLibrary.addAndpopulate(Asset(_assetsList[j]).id,material);
							uploadAsyncTexture(material)
						}
						if(Asset(_assetsList[j]).type == AssetType.AWD && !Asset(_assetsList[j]).parsed){
							_waitAwdParsing = true
							_awdToParse.push(Asset(_assetsList[j]));					
						}
						
						if(Asset(_assetsList[j]).type == AssetType.RAW_BITMAP){
							// nothing to do
						}
					}
				}
			}			
			trace("## " + infosLoad)
			if(_waitAwdParsing){
				parseAwd(0);				
			}else{
				dispatchComplete();
			}			
		}
		
		/*** ASYNCHRONOUS MIPMAP GENERATION & TEXTURE UPLOAD ***/
		
		private function uploadAsyncTexture(material:ATMaterial):void
		{			
			if(material.texture is ASyncBitmapTexture){
				var asyncTex:ASyncBitmapTexture = material.texture as ASyncBitmapTexture
				asyncTex.name = material.name
				if(!asyncTex.hasUploadedMipMap()){
					_texturesToUpload ++
					asyncTex.addEventListener(ASyncBitmapTexture.MIPMAP_UPLOADED, mipmapUploadedHandler)
					asyncTex.uploadAsynchTexture(Stage3DView.S3D_PROXY_WORLD)
				}					
			}
		}
		
		protected function mipmapUploadedHandler(event:Event):void
		{
			//trace("mipmap complete - " + ASyncBitmapTexture(event.currentTarget).name)
			ASyncBitmapTexture(event.currentTarget).removeEventListener(ASyncBitmapTexture.MIPMAP_UPLOADED,mipmapUploadedHandler);
			_texturesToUpload --
			if(_texturesToUpload == 0) dispatchComplete()
		}
		
		/*** AWD PARSING & DEPENDENCIES PARSING ***/
		
		private function parseAwd(idAsset:int):void
		{
			_parsingAwd = idAsset
			_awd2Parser = new AWD2Parser();				
			_awd2Parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetParseComplete);
			_awd2Parser.addEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete);
			_awd2Parser.addEventListener(ParserEvent.READY_FOR_DEPENDENCIES, readyForDependenciesHandler);
			
			_awd2Parser.parseAsync(getContent(Asset(_awdToParse[_parsingAwd]).id));
		}
		
		protected function readyForDependenciesHandler(event:ParserEvent):void
		{
			_dependencies = _awd2Parser.dependencies
			resolveDependency(0);			
		}
		
		private function resolveDependency(id:int):void
		{
			_parsingDependency = id
			if(_parsingDependency >= _dependencies.length){
				resumeParser();
			}else{		
				
				_loadingDependency = ResourceDependency(_dependencies[_parsingDependency])					
				if(_loadingDependency.success){
					resolveDependency(_parsingDependency+1);
				}else{					
					var sfl:SingleFileLoader = new SingleFileLoader();
					sfl.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE, dependencyCompleteHandler)
					sfl.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler)
					sfl.parseData(_loadingDependency.data);
				}				
			}
		}
		
		protected function assetCompleteHandler(event:AssetEvent):void
		{
			_loadingDependency.assets.push(event.asset)
		}
		
		protected function dependencyCompleteHandler(event:LoaderEvent):void
		{			
			var loader : SingleFileLoader = SingleFileLoader(event.target);
			loader.removeEventListener(LoaderEvent.DEPENDENCY_COMPLETE,dependencyCompleteHandler);
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler)
			_loadingDependency.success = true;
			_loadingDependency.resolve()
			
			// next dependency
			resolveDependency(_parsingDependency+1);
		}
		
		private function resumeParser():void
		{
			if(_awd2Parser.parsingPaused){
				_awd2Parser.resumeParsingAfterDependencies();
			}
		}
		
		protected function onParseComplete(event:Event):void
		{	
			trace("[" + Asset(_awdToParse[_parsingAwd]).id + "] parsed")
			Asset(_awdToParse[_parsingAwd]).parsed = true		
			_awd2Parser.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetParseComplete);
			_awd2Parser.removeEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete);
			_awd2Parser.removeEventListener(ParserEvent.READY_FOR_DEPENDENCIES, readyForDependenciesHandler);
			_awd2Parser = null
				
			if(_parsingAwd+1 >= _awdToParse.length){
				_waitAwdParsing = false
				dispatchComplete();
			}else{
				parseAwd(_parsingAwd+1)
			}
		}
		
		protected function onAssetParseComplete(event:AssetEvent):void
		{		
			AssetLibrary.addAsset(event.asset)
				
		}		
		
		private function dispatchComplete():void
		{	
			if(!_waitAwdParsing && _texturesToUpload == 0) {			
				_requiredAssetsComplete = true
				_currentLoadingAssetsList = new Vector.<Asset>
				//trace(" ## load & parse Complete")
				_instance.dispatchEvent(new PageEvent(Event.COMPLETE,_currentPage));
				
				//Main(Main.INSTANCE).animloader.visible = false
				//Main(Main.INSTANCE).animloader.stop()
				
				// Main(Main.INSTANCE).dispatchMainReady()
				
			}
		}
		
		/**** OLD STUFFS ****/
		
		/*public function isJpegsProjectLoaded(name:String):Boolean
		{
			return _jpegsProjectsLoaded[name]
		}
		
		public function loadJpegsProject(name:String, num:int = 6):void
		{
			_currentJpegGroup = name
			_numJpegs = num
			
			for(var i:int = 1; i<num+1; i++){
				var url:String = Path.JPEG_DIRECTORY +name+"/00"+i+".jpg"
				var id:String = name+"_img_"+i
				_assetsLoader.add(url,{id:id})
			}
			_assetsLoader.addEventListener(BulkProgressEvent.COMPLETE, completeJPEGHandler)
			_assetsLoader.start();	
		}
		
		protected function completeJPEGHandler(event:Event):void
		{
			_jpegsProjectsLoaded[_currentJpegGroup] = true
				
			for(var i:int = 1; i<_numJpegs+1;i++){
				var bitmapTexture:BitmapTexture = new BitmapTexture(_assetsLoader.getBitmapData(_currentJpegGroup+"_img_"+i))
				var material:ATMaterial = new ATMaterial(bitmapTexture) as ATMaterial;
				ATMaterialList.addJpegProjectBitmap(_currentJpegGroup,material);
			}				
			
			_assetsLoader.removeEventListener(BulkProgressEvent.COMPLETE, completeJPEGHandler)
			_instance.dispatchEvent(new Event(AssetsManager.JPEG_COMPLETE));
		}*/
		
		public function get requiredAssetsComplete():Boolean
		{
			return _requiredAssetsComplete
		}
				
		static public function getBinary(id:String):ByteArray
		{
			return _assetsLoader.getBinary(id);
		}
		
		static public function getContent(id:String, clearMemory:Boolean = false):*
		{
			return _assetsLoader.getContent(id, true);
		}
		
		static private function failHandler(e:Event):void 
		{
			
		}
				
		/**
		 * Page's Assets
		 **/
		
		public function addAsset(asset:Asset):void
		{
			_assetsList.push(asset)
		}
		
		public function getAssets(id:String):Asset
		{
			for(var i:int = 0; i<_assetsList.length; i++){
				var asset:Asset = _assetsList[i]
				if(asset.id == id) return asset
			}
			
			return null
		}
	}
}

class SingletonEnforcer {}