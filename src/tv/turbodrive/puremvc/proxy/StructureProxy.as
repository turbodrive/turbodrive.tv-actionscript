package tv.turbodrive.puremvc.proxy
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import tv.turbodrive.Main;
	import tv.turbodrive.loader.AssetsManager;
	import tv.turbodrive.puremvc.proxy.data.Asset;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.Project;
	import tv.turbodrive.utils.Config;
	import tv.turbodrive.utils.Path;
	
	public class StructureProxy extends Proxy implements IProxy 
	{
		
		public static const NAME:String = "StructureProxy";
		
		private var projectDictionary:Dictionary = new Dictionary()
		private static var pageDictionary:Dictionary = new Dictionary()
		private var addressDictionnary:Dictionary = new Dictionary()
		
		public var onComplete:Function;
		public var _xmlLoader:URLLoader		
		private var _xmlContent:XML;
		
		/**
		 * Default constructor
		 * @param data Initial data to store in the proxy
		 */
		public function StructureProxy( data:Object = null ) 
		{
			super ( NAME, new Vector.<Page> );
		}
		
		override public function onRegister():void
		{
			var _xmlLoader:URLLoader = new URLLoader()				
				
			try {
				_xmlLoader.load(new URLRequest(Path.XML_FILE));
			}
			catch (error:SecurityError)
			{
				trace("A SecurityError has occurred." + error.message);
			}
				
			_xmlLoader.addEventListener(Event.COMPLETE, completeHander)
			/*_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler)
			_xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, secuHandler)
			_xmlLoader.addEventListener(Event.OPEN, openHandler)*/
		}
		
		/*protected function openHandler(event:Event):void
		{
			Main.trc("Event OPEN")
		}
		
		protected function secuHandler(event:SecurityErrorEvent):void
		{
			Main.trc("SecurityErrorEvent " + event.text)
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			Main.trc("IOErrorEvent " + event.text)
		}*/
		
		protected function completeHander(event:Event):void
		{	
			parseXmlContent(XML(URLLoader(event.currentTarget).data))
		}
		
		public function getXmlContent():XMLList
		{
			return _xmlContent.content[0].part
		}
		
		private function addProjects(list:XMLList, isSecondaryProject:Boolean):void
		{
			for(var i:int = 0; i<list.length(); i++){				
				var project:Project = new Project(list[i].@id, list[i].@name, list[i].@address, list[i].@client )
				if(list[i].htmlName[0]){
					project.htmlName =  list[i].htmlName[0]
				}else{
					project.htmlName = project.name
				}
				if(list[i].props[0]){
					project.set3dProps(list[i].props[0].@x,list[i].props[0].@y,list[i].props[0].@z,list[i].props[0].@rotationX,list[i].props[0].@rotationY,list[i].props[0].@rotationZ)
				}			
				if(list[i].htmlClient[0]){
					project.htmlClient =  list[i].htmlClient[0]
				}else{
					project.htmlClient = project.client
				}
				if(String(list[i].@caseVimeo).length > 2){
					project.caseVimeo = list[i].@caseVimeo
				}
				
				project.videoCapture = Path.VIDEO_REEL_SERVER_EXTEND+list[i].videoCapture[0].@url
				project.isSecondaryProject = isSecondaryProject
				
				projectDictionary[project.id] = project	
			}
		}
		
		public function parseXmlContent(xmlContent:XML):void
		{	
			_xmlContent = xmlContent
			
			// Assets
			var assets:XMLList = xmlContent.assets[0].asset
			for(var i:int = 0; i<assets.length(); i++){				
				var asset:Asset = new Asset(assets[i].@id, assets[i].@file, assets[i].@type, assets[i].@priority, assets[i].@mainAsset == "true", assets[i].@required == "true", assets[i].@json)
				if(String(assets[i].@blendMode).length > 0) asset.blendMode = assets[i].@blendMode
				AssetsManager.instance.addAsset(asset)
			}	
			
			// Projets
			var projects:XMLList = xmlContent.mainProjects[0].project
			addProjects(projects,false)
			projects = xmlContent.secondaryProjects[0].project
			addProjects(projects,true)
			
			// Structure des pages			
			var structure:XMLList = xmlContent.structure[0].page
			var xmlPage:XML;
			for (i = 0; i < structure.length() ; i++ )
			{
				xmlPage = structure[i];
				
				var page:Page = addNewPage(xmlPage)
				var children:XMLList = xmlPage.page
				if (children.length() > 0)
				{
					var firstChildPage:Page;
					var firstChildChildPage:Page;
					for (var j:int = 0; j < children.length() ; j++ )
					{
						var xmlChildPage:XML = children[j];
						var childPage:Page = addNewPage(xmlChildPage);
						if (xmlChildPage.@deflt == "true")
						{
							page.setDefaultPage(childPage);
						}
						childPage.setParent(page);
						page.addChild(childPage);
						
						// 3ème niveau :						
						if (xmlChildPage.page.length() > 0)
						{
							for (var l:int = 0; l < xmlChildPage.page.length() ; l++ )
							{
								var xmlChildChildPage:XML = xmlChildPage.page[l];
								var childChildPage:Page = addNewPage(xmlChildChildPage);
								if (!l) firstChildChildPage = childChildPage;
							
									if (xmlChildChildPage.@deflt == "true")
									{
										childPage.setDefaultPage(childChildPage);
									}
									
								childChildPage.setParent(childPage);
								childPage.addChild(childChildPage);
							}
						}
					}
				}
			}
			
			trace("structure is loaded & parsed")
			
			createWholeIdAddress()
			createSiblings();
			onComplete();
		}	
		
		private function addNewPage(xmlPage:XML):Page
		{
			var idPage:String = xmlPage.@id
			var newPage:Page
			if(projectDictionary[idPage] && projectDictionary[idPage] != "" ){
				var project:Project = projectDictionary[idPage]
				newPage = new Page(project.id, project.name, project.address, project)
			}else{
				newPage = new Page(xmlPage.@id, xmlPage.name[0], xmlPage.@address)
			}
			newPage.enabled = xmlPage.@enabled == "false" ? false : true;
			newPage.gmd = xmlPage.@gmd == "false" ? false : true;
			newPage.num = String(xmlPage.@num != "") ? xmlPage.@num : NaN;
			
				
			if(xmlPage.asset.length() > 0){
				for(var j:int = 0; j< xmlPage.asset.length() ;j++){
					newPage.addAssetId(xmlPage.asset[j].@id)
				}				
			}
			
			// si la page a des cuepoints, alors elle fait partie du showreel, on corrige son ID pour la différencier de la partie portfolio
			if(String(xmlPage.@cuepoint) != ""){
				newPage.cuepoint = int(xmlPage.@cuepoint);
			}
			if(PagesName.DEFAULT == ""){
				if(!Config.IS_ONLINE){
					if(String(xmlPage.@homepage) == "true") PagesName.DEFAULT = newPage.id
				}else{
					PagesName.DEFAULT = PagesName.REEL
				}
			}
			
			newPage.isFolder = (xmlPage.@folder == "true")	
			pageList.push(newPage);
			pageDictionary[newPage.id] = newPage
			
			return newPage
		}		
		
		public function getTopParent(_page:Page):Page
		{
			var section:Page = _page;
			if (_page.parentPage) 									section = _page.parentPage;
			if (_page.parentPage && _page.parentPage.parentPage) 	section = _page.parentPage.parentPage;
			
			return section;
		}
		
		public static function getPage(id:String):Page
		{
			return pageDictionary[id]
		}
		
		public function getRealPage(id:String):Page
		{
			var page:Page = getPage(id);
			
			if (page.isFolder) {
				if(page.getDefaultPage())
					return page.getDefaultPage();
				else if (page.childrenId.length) {
					var childPage:Page;
					for (var j:int = 0; j < page.childrenId.length; j++) 
					{
						childPage = getPage(page.childrenId[j]);
						if (childPage.getDefaultPage())
							return childPage.getDefaultPage();
					}
				}
			}			
			return page;
		}
		
		/*public function getRealName(name:String):String
		{
			return getRealPage(name).name
		}*/
		
		public function getPageChildren(parent:Object):Vector.<Page>
		{
			var parentPage:Page
			if (parent is Page) {
				parentPage = parent as Page
			}else {
				parentPage = getPage(parent as String)
			}			
			
			var childrenList:Vector.<Page> = new Vector.<Page>()
			var idChildrenList:Vector.<String> = parentPage.childrenId
			for (var i:int = 0 ; i < idChildrenList.length ; i++ ) {
				childrenList.push(Page(getPage(String(idChildrenList[i]))))
			}
			return childrenList;
		}
		
		private function createWholeIdAddress():void 
		{
			var page:Page;
			var wholeAddress:String;
			
			for (var i:int = 0; i < pageList.length ; i++ ) {
				page = pageList[i] as Page
				wholeAddress = getCompleteAddress(page);
				page.setWholeAddress(wholeAddress);
				
				if (page.getDefaultPage()) {
					if (page.getDefaultPage().getDefaultPage())
						addressDictionnary[wholeAddress] = page.getDefaultPage().getDefaultPage();
					else
						addressDictionnary[wholeAddress] = page.getDefaultPage();
				}else if (page.childrenId.length) {
					var childPage:Page;
					for (var j:int = 0; j < page.childrenId.length; j++) 
					{
						childPage = getPage(page.childrenId[j]);
						if (childPage.getDefaultPage()){
							addressDictionnary[wholeAddress] = childPage.getDefaultPage();
							break;
						}
					}
					
					if (!addressDictionnary[wholeAddress]) 
						addressDictionnary[wholeAddress] = page;
					
				}else
					addressDictionnary[wholeAddress] = page
				
			}		
		}
		
		public function getPageByNum(num:int):Page
		{
			for (var i:int = 0; i < pageList.length ; i++ ) {
				if(pageList[i].num == num) return Page(pageList[i])
			}
			
			return null
		}
		
		private function createSiblings():void 
		{
			var page:Page;
			var wholeAddress:String;			
			
			for (var i:int = 0; i < pageList.length ; i++ ) {
				page = pageList[i] as Page
				if(page.num && page.num > 0){
					page.nextPage = getPageByNum(page.num+1)
					page.previousPage = getPageByNum(page.num-1)
				}
				
			}		
		}
		
		public function getCompleteAddress(page:*):String
		{
			var currentPage:Page = (page is Page)? page as Page : getPage(page as String);
			var address:String = currentPage.address;
			
			while (currentPage.parentId){
				currentPage = getPage(currentPage.parentId);
				address = currentPage.address + address;
			}
			
			return address;
		}
		
		public function getPageFromWholeAddress(wholeAddress:String):Page
		{
			return addressDictionnary[wholeAddress] as Page
		}			
		
		public function get pageList():Vector.<Page>
		{
			return data as Vector.<Page>
		}
		
	}
}