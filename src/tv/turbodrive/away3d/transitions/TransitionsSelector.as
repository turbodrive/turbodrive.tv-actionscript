package tv.turbodrive.away3d.transitions
{
	
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;

	public class TransitionsSelector
	{
		
		public static function getTransition(previous:Page, next:Page, isSimple:Boolean = false, waitloading:Boolean = false) : String
		{
			
			if(previous && previous.name == next.name && previous.environment == next.environment){
				isSimple = true
				return TransitionsName.INTERNAL
			}			
			
			if(isSimple){
				// direct transition
				if(previous.category == PagesName.MORE_PROJECTS) return TransitionsName.MORE_PROJECTS_SIMPLE
				//if(previous.category == PagesName.SELECTED_CASES) return TransitionsName.SELECTED_CASES_SIMPLE
				if(previous.category == PagesName.SELECTED_CASES && next.category == PagesName.SELECTED_CASES) return TransitionsName.SC_TO_SC
			}else{
				// Level 1 [intro]
				if(!previous) return TransitionsName.INTRO_FOLIO
				// Level 2 [environment]
				if(previous.environment == PagesName.REEL && next.environment == PagesName.FOLIO){
					if(next.category == PagesName.ABOUT) return TransitionsName.REEL_TO_ABOUT
					if(next.category == PagesName.MORE_PROJECTS) return TransitionsName.REEL_TO_MP
					return TransitionsName.REEL_TO_SC					
				}
				if(previous.environment == PagesName.FOLIO && next.environment == PagesName.REEL){
					if(previous.category == PagesName.ABOUT) return TransitionsName.ABOUT_TO_REEL
					if(previous.category == PagesName.MORE_PROJECTS) return TransitionsName.MP_TO_REEL
					return TransitionsName.SC_TO_REEL
				}
				// Level 3 [category]
				
				if(previous.category != next.category){
					if(previous.category == PagesName.SELECTED_CASES && next.category == PagesName.ABOUT) return TransitionsName.SC_TO_ABOUT // to about
					if(previous.category == PagesName.ABOUT && next.category == PagesName.SELECTED_CASES) return TransitionsName.ABOUT_TO_SELECTED_CASES
						
					if(previous.category == PagesName.SELECTED_CASES && next.category == PagesName.MORE_PROJECTS) return TransitionsName.SC_TO_MP
					if(previous.category == PagesName.ABOUT && next.category == PagesName.MORE_PROJECTS) return TransitionsName.ABOUT_TO_MP
						
					if(previous.category == PagesName.MORE_PROJECTS && next.category == PagesName.SELECTED_CASES) return TransitionsName.MP_TO_SC
					if(previous.category == PagesName.MORE_PROJECTS && next.category == PagesName.ABOUT) return TransitionsName.MP_TO_ABOUT
						
					//return TransitionsName.CHANGE_CATEGORY // (from about or SC <> MP)
				}
				// Level 4 [selected cases]
				if(previous.category == PagesName.SELECTED_CASES && next.category == PagesName.SELECTED_CASES){
					if(waitloading) return TransitionsName.SC_INTERNAL_LOADER
					return TransitionsName.SC_TO_SC
				}
				if(previous.category == PagesName.MORE_PROJECTS && next.category == PagesName.MORE_PROJECTS) return TransitionsName.SC_TO_SC
			}
			
			return null
		}
		
		public static function getLoop(transition:String) : String
		{
			if(transition == TransitionsName.SC_INTERNAL_LOADER) return TransitionsName.LOOP_GRID
			return TransitionsName.LOOP_HYPERDRIVE
		}
		
		/*public static function getWaitLoading(transition:String) : Boolean
		{
			if(transition == TransitionsName.SC_TO_SC) return true
			return false
		}*/
	}
}