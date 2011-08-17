package jpromiscuous.vo
{
	import jpromiscuous.vo.tags.*;

	public class TagTypes
	{
		// Flash 1 tags
		public static const TAG_END:uint = 0;
		public static const TAG_SHOWFRAME:uint = 1;
		public static const TAG_DEFINESHAPE:uint = 2;
		public static const TAG_FREECHARACTER:uint = 3;
		public static const TAG_PLACEOBJECT:uint = 4;
		public static const TAG_REMOVEOBJECT:uint = 5;
		public static const TAG_DEFINEBITS:uint = 6;
		public static const TAG_DEFINEBUTTON:uint = 7;
		public static const TAG_JPEGTABLES:uint = 8;
		public static const TAG_SETBACKGROUNDCOLOR:uint = 9;
		public static const TAG_DEFINEFONT:uint = 10;
		public static const TAG_DEFINETEXT:uint = 11;
		public static const TAG_DOACTION:uint = 12;
		public static const TAG_DEFINEFONTINFO:uint = 13;
		public static const TAG_DEFINESOUND:uint = 14;
		public static const TAG_STARTSOUND:uint = 15;
		public static const TAG_STOPSOUND:uint = 16;
		public static const TAG_DEFINEBUTTONSOUND:uint = 17;
		public static const TAG_SOUNDSTREAMHEAD:uint = 18;
		public static const TAG_SOUNDSTREAMBLOCK:uint = 19;
		// Flash 2 tags
		public static const TAG_DEFINEBITSLOSSLESS:uint = 20;
		public static const TAG_DEFINEBITSJPEG2:uint = 21;
		public static const TAG_DEFINESHAPE2:uint = 22;
		public static const TAG_DEFINEBUTTONCXFORM:uint = 23;
		public static const TAG_PROTECT:uint = 24;
		public static const TAG_PATHSAREPOSTSCRIPT:uint = 25;
		// Flash 3 tags
		public static const TAG_PLACEOBJECT2:uint = 26;
		
		public static const TAG_REMOVEOBJECT2:uint = 28;
		public static const TAG_SYNCFRAME:uint = 29;
		
		public static const TAG_FREEALL:uint = 31;
		public static const TAG_DEFINESHAPE3:uint = 32;
		public static const TAG_DEFINETEXT2:uint = 33;
		public static const TAG_DEFINEBUTTON2:uint = 34;
		public static const TAG_DEFINEBITSJPEG3:uint = 35;
		public static const TAG_DEFINEBITSLOSSLESS2:uint = 36;
		// Flash 4 tags
		public static const TAG_DEFINEEDITTEXT:uint = 37;
		public static const TAG_DEFINEVIDEO:uint = 38;
		public static const TAG_DEFINESPRITE:uint = 39;
		public static const TAG_NAMECHARACTER:uint = 40;
		public static const TAG_PRODUCTINFO:uint = 41;
		public static const TAG_DEFINETEXTFORMAT:uint = 42;
		public static const TAG_FRAMELABEL:uint = 43;
		// Flash 5 tags
		public static const TAG_DEFINEBEHAVIOR:uint = 44;
		public static const TAG_SOUNDSTREAMHEAD2:uint = 45;
		public static const TAG_DEFINEMORPHSHAPE:uint = 46;
		public static const TAG_FRAMETAG:uint = 47;
		public static const TAG_DEFINEFONT2:uint = 48;
		public static const TAG_GENCOMMAND:uint = 49;
		public static const TAG_DEFINECOMMANDOBJ:uint = 50;
		public static const TAG_CHARACTERSET:uint = 51;
		public static const TAG_FONTREF:uint = 52;
		public static const TAG_DEFINEFUNCTION:uint = 53;
		public static const TAG_PLACEFUNCTION:uint = 54;
		public static const TAG_GENTAGOBJECT:uint = 55;
		public static const TAG_EXPORTASSETS:uint = 56;
		public static const TAG_IMPORTASSETS:uint = 57;
		public static const TAG_ENABLEDEBUGGER:uint = 58;
		// Flash 6 tags
		public static const TAG_DOINITACTION:uint = 59;
		public static const TAG_DEFINEVIDEOSTREAM:uint = 60;
		public static const TAG_VIDEOFRAME:uint = 61;
		public static const TAG_DEFINEFONTINFO2:uint = 62;
		public static const TAG_DEBUGID:uint = 63;
		public static const TAG_ENABLEDEBUGGER2:uint = 64;
		public static const TAG_SCRIPTLIMITS:uint = 65;
		// Flash 7 tags
		public static const TAG_SETTABINDEX:uint = 66;
		// Flash 8 tags
		
		
		public static const TAG_FILEATTRIBUTES:uint = 69;
		public static const TAG_PLACEOBJECT3:uint = 70;
		public static const TAG_IMPORTASSETS2:uint = 71;
		public static const TAG_DOABC:uint = 72;
		public static const TAG_DEFINEFONTALIGNZONES:uint = 73;
		public static const TAG_CSMTEXTSETTINGS:uint = 74;
		public static const TAG_DEFINEFONT3:uint = 75;
		public static const TAG_SYMBOLCLASS:uint = 76;
		public static const TAG_METADATA:uint = 77;
		public static const TAG_SCALINGGRID:uint = 78;
		
		
		
		public static const TAG_DOABC2:uint = 82;
		public static const TAG_DEFINESHAPE4:uint = 83;
		public static const TAG_DEFINEMORPHSHAPE2:uint = 84;
		
		// Flash 9 tags
		public static const TAG_DEFINESCENEANDFRAMELABELDATA:uint = 86;
		public static const TAG_DEFINEBINARYDATA:uint = 87;
		public static const TAG_DEFINEFONTNAME:uint = 88;
		public static const TAG_STARTSOUND2:uint = 89;
		public static const TAG_DEFINEBITSJPEG4:uint = 90;
		// Flash 10 tags
		public static const TAG_DEFINEFONT4:uint = 91;
		
		
		/**
		 * tagType => tag 名称 
		 */     
		private static const TAG_NAMES:Array =["End","ShowFrame","DefineShape","FreeCharacter","PlaceObject","RemoveObject","DefineBits","DefineButton","JPEGTables","SetBackgroundColor","DefineFont","DefineText","DoAction","DefineFontInfo","DefineSound","StartSound","StopSound","DefineButtonSound","SoundStreamHead","SoundStreamBlock","DefineBitsLossless","DefineBitsJPEG2","DefineShape2","DefineButtonCxform","Protect","PathsArePostScript","PlaceObject2","27 (invalid)","RemoveObject2","SyncFrame","30 (invalid)","FreeAll","DefineShape3","DefineText2","DefineButton2","DefineBitsJPEG3","DefineBitsLossless2","DefineEditText","DefineVideo","DefineSprite","NameCharacter","ProductInfo","DefineTextFormat","FrameLabel","DefineBehavior","SoundStreamHead2","DefineMorphShape","FrameTag","DefineFont2","GenCommand","DefineCommandObj","CharacterSet","FontRef","DefineFunction","PlaceFunction","GenTagObject","ExportAssets","ImportAssets","EnableDebugger","DoInitAction","DefineVideoStream","VideoFrame","DefineFontInfo2","DebugID","EnableDebugger2","ScriptLimits","SetTabIndex","67 (invalid)","68 (invalid)","FileAttributes","PlaceObject3","ImportAssets2","DoABC","DefineFontAlignZones","CSMTextSettings","DefineFont3","SymbolClass","Metadata","ScalingGrid","79 (invalid)","80 (invalid)","81 (invalid)","DoABC2","DefineShape4","DefineMorphShape2","85 (invalid)","DefineSceneAndFrameLabelData","DefineBinaryData","DefineFontName","StartSound2","DefineBitsJPEG4","DefineFont4"];
		
		/**
		 * tagType => tag class
		 */     
		private static const TAG_CLASS:Array = [
			EndTag,
			ShowFrameTag,
			DefineShapeTag,
			FreeCharacterTag,
			PlaceObjectTag,
			RemoveObjectTag,
			DefineBitsTag,
			DefineButtonTag,
			JPEGTablesTag,
			SetBackgroundColorTag,
			DefineFontTag,
			DefineTextTag,
			DoActionTag,
			DefineFontInfoTag,
			DefineSoundTag,
			StartSoundTag,
			StopSoundTag,
			DefineButtonSoundTag,
			SoundStreamHeadTag,
			SoundStreamBlockTag,
			DefineBitsLosslessTag,
			DefineBitsJPEG2Tag,
			DefineShape2Tag,
			DefineButtonCxformTag,
			ProtectTag,
			PathsArePostScriptTag,
			PlaceObject2Tag,
			null,
			RemoveObject2Tag,
			SyncFrameTag,
			null,
			FreeAllTag,
			DefineShape3Tag,
			DefineText2Tag,
			DefineButton2Tag,
			DefineBitsJPEG3Tag,
			DefineBitsLossless2Tag,
			DefineEditTextTag,
			DefineVideoTag,
			DefineSpriteTag,
			NameCharacterTag,
			ProductInfoTag,
			DefineTextFormatTag,
			FrameLabelTag,
			DefineBehaviorTag,
			SoundStreamHead2Tag,
			DefineMorphShapeTag,
			FrameTagTag,
			DefineFont2Tag,
			GenCommandTag,
			DefineCommandObjTag,
			CharacterSetTag,
			FontRefTag,
			DefineFunctionTag,
			PlaceFunctionTag,
			GenTagObjectTag,
			ExportAssetsTag,
			ImportAssetsTag,
			EnableDebuggerTag,
			DoInitActionTag,
			DefineVideoStreamTag,
			VideoFrameTag,
			DefineFontInfo2Tag,
			DebugIDTag,
			EnableDebugger2Tag,
			ScriptLimitsTag,
			SetTabIndexTag,
			null,
			null,
			FileAttributesTag,
			PlaceObject3Tag,
			ImportAssets2Tag,
			DoABCTag,
			DefineFontAlignZonesTag,
			CSMTextSettingsTag,
			DefineFont3Tag,
			SymbolClassTag,
			MetadataTag,
			ScalingGridTag,
			null,
			null,
			null,
			DoABCTag,
			DefineShape4Tag,
			DefineMorphShape2Tag,
			null,
			DefineSceneAndFrameLabelDataTag,
			DefineBinaryDataTag,
			DefineFontNameTag,
			StartSound2Tag,
			DefineBitsJPEG4Tag,
			DefineFont4Tag
		];
		
		
		/**
		 * 根据编号获取tag名称 
		 * @param tagType
		 * @return 
		 * 
		 */     
		public static function getTagNameByTagType(tagType:int):String
		{
			return TAG_NAMES[tagType] || null;
		}
		
		/**
		 * 根据变化获取tag class 
		 * @param tagType
		 * @return 
		 * 
		 */     
		public static function getTagClassByTagType(tagType:int):Class
		{
			return TAG_CLASS[tagType] || null;
		}
		

	}
}