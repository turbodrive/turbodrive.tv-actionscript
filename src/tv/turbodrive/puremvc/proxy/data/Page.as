package tv.turbodrive.puremvc.proxy.data
{
	import tv.turbodrive.loader.AssetsManager;
	
	public class Page
	{
		static public var DEFAULT:String = ""
		
		public var isFolder:Boolean = false;
		private var _id:String;
		private var _address:String;
		private var _children:Vector.<String>;
		private var _childrenPages:Vector.<Page> = new Vector.<Page>();
		private var _parent:String = null;
		private var _parentPage:Page = null;
		private var _wholeAddress:String;
		
		private var environnement:String;
		private var _envProps:Object;
		private var _defaultChildPage:Page;
		private var _name:String = "TURBODRIVE -";
		private var _tag:String = ""
		private var _dbleClick:String ="";
		private var _cuepoint:Number;
		private var _project:Project = null;
		private var _endTime:Number = 0
		
		public var rangeTimeButton:Array;
		public var enabled:Boolean;
		
		private var _assetsId:Array = []
			
		public var nextPage:Page
		public var previousPage:Page
		public var num:int
		public var gmd:Boolean = true
		
		public function Page(id:String, name:String = "", address:String = "", project:Project = null)
		{
			_project = project
			//_name += " " + name;
			_name = name
			//_tag = name
			_children = new Vector.<String>()
			_address = "/"+address;
			_id = id;
		}		
		
		public function isProject():Boolean
		{
			return project != null			
		}
		
		public function get project():Project
		{
			return _project		
		}
		
		/**
		 * ASSET MANAGING 
		 **/
		public function addAssetId(assetId:String):void
		{
			_assetsId.push(assetId)
		}
		
		public function assetsAreLoaded():Boolean
		{
			if(_assetsId.length == 0) return true
			
				
			for(var i:int = 0; i< _assetsId.length ;i++){
				if(!Asset(AssetsManager.instance.getAssets(_assetsId[i])).isLoaded) return false
			}
			
			return true
		}
		
		public function get assetsId():Array
		{
			return _assetsId
		}		
		
		/**
		 * SIBLING
		 **/	
		
		public function setParent(parentPage:Page):void {
			_parentPage = parentPage;
			_parent = parentPage.id;
		}
		
		public function get parentId():String {
			return _parent
		}	
		
		public function get parentPage():Page {
			return _parentPage;
		}
		
		public function get topParentPage():Page {
			if (_parentPage && _parentPage.parentPage) 	return _parentPage.parentPage;
			else if (_parentPage)						return _parentPage;
			else 										return this;
		}		
		
		public function addChild(childPage:Page):void {
			_children.push(childPage.id)
			_childrenPages.push(childPage)
		}	
		
		public function get environment():String
		{
			return topParentPage.id
		}		
		
		public function get category():String {
			if(topParentPage.id == parentId) return id
			return parentId
		}
		
		public function get id():String
		{
			return _id
		}
		
		public function get address():String
		{
			return _address
		}
		
		public function get childrenId():Vector.<String>
		{
			return _children
		}
				
		public function get childrenPages():Vector.<Page>
		{
			return _childrenPages
		}
		
		public function toString():String
		{
			return "Page [id : " + id + " | address : "+ _wholeAddress +" ]"
		}
		
		public function setWholeAddress(wholeAddress:String):void 
		{
			_wholeAddress = wholeAddress;
		}
		
		public function getWholeAddress():String
		{
			return _wholeAddress
		}
		
		public function get name():String
		{
			return _name
		}
		
		public function get rangeTime():Array
		{
			return [_cuepoint,_endTime]
		}
		
		public function set endTime(value:Number):void
		{
			_endTime = value
		}
		
		public function get cuepoint():Number
		{
			return _cuepoint
		}
		
		public function set cuepoint(value:Number):void
		{
			_id = PagesName.REEL_PROJECTS_PREFIX + _id
			_cuepoint = value
		}		
		
		public function get tag():String
		{
			return _tag
		}		
		
		public function set tag(value:String):void
		{
			_tag = value
		}
		
		public function get dbleClick():String
		{
			return _dbleClick
		}
		
		public function set dbleClick(value:String):void
		{
			_dbleClick = value
		}
		
		public function get env():String
		{
			return environnement
		}
		
		public function get envProps():Object
		{
			return _envProps
		}		
		
		public function setDefaultPage(defaultChildPage:Page):void 
		{
			_defaultChildPage = defaultChildPage;		
		}
		
		public function getDefaultPage():Page 
		{
			return _defaultChildPage;		
		}
	
	}
}