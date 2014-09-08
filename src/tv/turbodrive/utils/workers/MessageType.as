package tv.turbodrive.utils.workers
{
	public class MessageType
	{
		public static const START_FRAME_SPRITESHEET:String = "startFrameSpriteSheet"
		public static const COMPLETE_FRAME_SPRITESHEET:String = "completeFrameSpriteSheet"
		public static const INIT_STARTED:String = "initStarted"
		public static const PROCESS_MIPMAPPING:String = "processMimMapping";
		public static const BYTE_MIPMAPPING:String = "byteMimMapping";
		public static const COMPLETE_MIPMAPPING:String = "completeMimMapping";
		public static const MIPMAP_LEVEL_COMPLETE:String = "mipmapLevelComplete";
		public static const BYTES_LOADED:String = "BytesLoaded";
	}
}