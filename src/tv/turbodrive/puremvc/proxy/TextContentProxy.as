package tv.turbodrive.puremvc.proxy
{
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import tv.turbodrive.text.XmlStringReader;
	
	public class TextContentProxy extends Proxy implements IProxy 
	{
		
		public static const NAME:String = "TextContentProxy";
		
		private var _xmlPart:XMLList;
		
		/**
		 * Default constructor
		 * @param data Initial data to store in the proxy
		 */
		public function TextContentProxy() 
		{			
			super ( NAME, new Dictionary() );
		}
		
		override public function onRegister():void
		{
			XmlStringReader.init(this);
		}
		
		public function parseXmlContent(xmlPartList:XMLList):void
		{
			_xmlPart = xmlPartList;
		}		
	
		public function getBlocLength(page:String,bloc:String):uint
		{
			var dicoPage:Dictionary = dictionaryContent[page] as Dictionary
			return dicoPage[bloc].length
		}		
				
		public function getXMLContent(page:String, key:String):XML
		{			
			return new XML(_xmlPart.(@name == page).child(key)); 
		}
				
		private function getString(pageName:String, key:String, bloc:String = null):String
		{
			var dicoPage:Dictionary = dictionaryContent[pageName] as Dictionary
			
			if (dicoPage && bloc)
				return dicoPage[bloc][key];
			else if (dicoPage && dicoPage.hasOwnProperty(key))
				return dicoPage[key];
			else 
				return ""; 
		}
		
		public function getStringContent(page:String, path:String, attribut:String=null):String
		{
			var xmlList:XMLList = _xmlPart.(@name == page);			
			var keyList:Array = path.split("/");
			
			for (var i:int = 0; i < keyList.length; i++) {
				xmlList = xmlList.child(keyList[i])
			}
			
			if (attribut) {				
				xmlList = xmlList.attribute(attribut);
			}
			return String(xmlList);
		}
		
		private function get dictionaryContent():Dictionary
		{
			return data as Dictionary
		}
		
	}
}