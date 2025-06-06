-- This file is part of SA MoonLoader package.
-- Licensed under the MIT License.
-- Copyright (c) 2016, BlastHack Team <blast.hk>


-- Message Prefix Types
TAG = {
	TYPE_INFO = 1,
	TYPE_DEBUG = 2,
	TYPE_ERROR = 3,
	TYPE_WARN = 4,
	TYPE_SYSTEM = 5,
	TYPE_FATAL = 6,
	TYPE_EXCEPTION = 7
}

local download_status = {
	STATUS_FINDINGRESOURCE = 1,
	STATUS_CONNECTING = 2,
	STATUS_REDIRECTING = 3,
	STATUS_BEGINDOWNLOADDATA = 4,
	STATUS_DOWNLOADINGDATA = 5,
	STATUS_ENDDOWNLOADDATA = 6,
	STATUS_BEGINDOWNLOADCOMPONENTS = 7,
	STATUS_INSTALLINGCOMPONENTS = 8,
	STATUS_ENDDOWNLOADCOMPONENTS = 9,
	STATUS_USINGCACHEDCOPY = 10,
	STATUS_SENDINGREQUEST = 11,
	STATUS_CLASSIDAVAILABLE = 12,
	STATUS_MIMETYPEAVAILABLE = 13,
	STATUS_CACHEFILENAMEAVAILABLE = 14,
	STATUS_BEGINSYNCOPERATION = 15,
	STATUS_ENDSYNCOPERATION = 16,
	STATUS_BEGINUPLOADDATA = 17,
	STATUS_UPLOADINGDATA = 18,
	STATUS_ENDUPLOADDATA = 19,
	STATUS_PROTOCOLCLASSID = 20,
	STATUS_ENCODING = 21,
	STATUS_VERIFIEDMIMETYPEAVAILABLE = 22,
	STATUS_CLASSINSTALLLOCATION = 23,
	STATUS_DECODING = 24,
	STATUS_LOADINGMIMEHANDLER = 25,
	STATUS_CONTENTDISPOSITIONATTACH = 26,
	STATUS_FILTERREPORTMIMETYPE = 27,
	STATUS_CLSIDCANINSTANTIATE = 28,
	STATUS_IUNKNOWNAVAILABLE = 29,
	STATUS_DIRECTBIND = 30,
	STATUS_RAWMIMETYPE = 31,
	STATUS_PROXYDETECTING = 32,
	STATUS_ACCEPTRANGES = 33,
	STATUS_COOKIE_SENT = 34,
	STATUS_COMPACT_POLICY_RECEIVED = 35,
	STATUS_COOKIE_SUPPRESSED = 36,
	STATUS_COOKIE_STATE_UNKNOWN = 37,
	STATUS_COOKIE_STATE_ACCEPT = 38,
	STATUS_COOKIE_STATE_REJECT = 39,
	STATUS_COOKIE_STATE_PROMPT = 40,
	STATUS_COOKIE_STATE_LEASH = 41,
	STATUS_COOKIE_STATE_DOWNGRADE = 42,
	STATUS_POLICY_HREF = 43,
	STATUS_P3P_HEADER = 44,
	STATUS_SESSION_COOKIE_RECEIVED = 45,
	STATUS_PERSISTENT_COOKIE_RECEIVED = 46,
	STATUS_SESSION_COOKIES_ALLOWED = 47,
	STATUS_CACHECONTROL = 48,
	STATUS_CONTENTDISPOSITIONFILENAME = 49,
	STATUS_MIMETEXTPLAINMISMATCH = 50,
	STATUS_PUBLISHERAVAILABLE = 51,
	STATUS_DISPLAYNAMEAVAILABLE = 52,
	STATUS_SSLUX_NAVBLOCKED = 53,
	STATUS_SERVER_MIMETYPEAVAILABLE = 54,
	STATUS_SNIFFED_CLASSIDAVAILABLE = 55,
	STATUS_64BIT_PROGRESS = 56,
	STATUSEX_STARTBINDING = 57,
	STATUSEX_ENDDOWNLOAD = 58,
	STATUSEX_LOWRESOURCE = 59,
	STATUSEX_DATAAVAILABLE = 60,
}

local font_flags = {
	NONE      = 0x0,
	BOLD      = 0x1,
	ITALICS   = 0x2,
	BORDER    = 0x4,
	SHADOW    = 0x8,
	UNDERLINE = 0x10,
	STRIKEOUT = 0x20
}

local d3d_prim_type = {
	POINTLIST     = 1,
	LINELIST      = 2,
	LINESTRIP     = 3,
	TRIANGLELIST  = 4,
	TRIANGLESTRIP = 5,
	TRIANGLEFAN   = 6
}

local audiostream_state = {
	STOP   = 0,
	PLAY   = 1,
	PAUSE  = 2,
	RESUME = 3
}

local audiostream_status = {
	STOPPED = -1,
	PLAYING =  1,
	PAUSED  =  2
}

return {
	message_prefix = TAG,
	download_status = download_status,
	font_flag = font_flags,
	d3d_prim_type = d3d_prim_type,
	audiostream_state = audiostream_state,
	audiostream_status = audiostream_status,
}
