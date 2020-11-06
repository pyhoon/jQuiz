B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.1
@EndOfDesignText@
Sub Process_Globals

End Sub

Sub LoadConfigMap As Map
	Return File.ReadMap(File.DirAssets, "config.properties")
End Sub

Sub Map2Json(M As Map) As String
	Dim gen As JSONGenerator
	gen.Initialize(M)
	Return gen.ToString
End Sub

Sub ReturnConnect(resp As ServletResponse)
	Dim Map1 As Map = CreateMap("Connected": 1)
	resp.ContentType = "application/json"
	resp.Write(Map2Json(Map1))
End Sub

Sub ReturnError(Message As String, resp As ServletResponse)
	If Message = "" Then Message = "unknown"
	Dim List1 As List
	List1.Initialize
	Dim Map1 As Map = CreateMap("s": "failed", "r": List1, "e": Message)
	resp.ContentType = "application/json"
	resp.Write(Map2Json(Map1))
End Sub

Sub ReturnSuccess(Map As Map, resp As ServletResponse)
	If Map.IsInitialized = False Then Map.Initialize
	Dim Result As List
	Result.Initialize
	Result.Add(Map)
	Dim Map1 As Map = CreateMap("s": "success", "r": Result, "e": Null)
	resp.ContentType = "application/json"
	resp.Write(Map2Json(Map1))
End Sub

Sub ReturnSuccess2(Result As List, resp As ServletResponse)
	If Result.IsInitialized = False Then Result.Initialize
	Dim Map1 As Map = CreateMap("s": "success", "r": Result, "e": Null)
	resp.ContentType = "application/json"
	resp.Write(Map2Json(Map1))
End Sub