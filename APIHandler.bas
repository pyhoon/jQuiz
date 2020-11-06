B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Dim Request As ServletRequest
	Dim Response As ServletResponse
	Dim pool As ConnectionPool
End Sub

Public Sub Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	Request = req
	Response = resp
	Dim elements() As String = Regex.Split("/", req.RequestURI)
	If elements.Length = 0 Then
		Utility.ReturnConnect(Response)
		Return
	'Else If elements.Length > Main.MAX_ELEMENTS Then
	'	Response.SendError(500, "Unknown action")
	'	Return
	End If
	
	Dim ActionList As List
	ActionList.Initialize2(Array As String("register", "login", "results", "answers", "topics", "questions", "question"))
	
	If ActionList.IndexOf(elements(Main.ELEMENT_ACTION)) > -1 Then
		OpenConnection
	End If
	
	Select elements(Main.ELEMENT_ACTION)
		Case "connect"
			Utility.ReturnConnect(Response)
		Case "register"
			Register
		Case "login"
			Login
		Case "results"
			GetResults
		Case "answers"
			PutAnswers
		Case "topics"
			GetTopics
		Case "questions"
			If elements.Length < Main.MAX_ELEMENTS Then Return
			GetQuestions(elements(Main.ELEMENT_ID))
		Case "question"
			If elements.Length < Main.MAX_ELEMENTS Then Return
			GetQuestion(elements(Main.ELEMENT_ID))
		Case Else
			Response.SendError(500, "Unknown action")
			Return
	End Select
	
	If ActionList.IndexOf(elements(Main.ELEMENT_ACTION)) > -1 Then
		CloseConnection
	End If
End Sub

Sub OpenConnection
	Try
		Dim MaxPoolSize As Int
		Dim config As Map = Utility.LoadConfigMap
		pool.Initialize(config.Get("DriverClass"), _
		config.Get("JdbcUrl"), _
		config.Get("User"), _
		config.Get("Password"))		
		MaxPoolSize = config.Get("MaxPoolSize")
		' change pool size...
		' Credit to Harris
		' https://www.b4x.com/android/forum/threads/poolconnection-problem-connection-has-timed-out.95067/post-600974
		Dim jo As JavaObject = pool
		jo.RunMethod("setMaxPoolSize", Array(MaxPoolSize))
	Catch
		Log(LastException.Message)
	End Try
End Sub

Sub CloseConnection
	If pool.IsInitialized Then pool.ClosePool ' Release connection to pool?	
End Sub

Sub Request2Map As Map
	Try
		Dim data As Map
		Dim ins As InputStream = Request.InputStream
		If ins.BytesAvailable = 0 Then
			Return Null
		End If
		Dim tr As TextReader
		tr.Initialize(ins)
		Dim json As JSONParser
		json.Initialize(tr.ReadAll)
		data = json.NextObject
	Catch
		Log("[Request2Map] " & LastException)
	End Try
	Return data
End Sub

Sub Register
	Dim con As SQL = pool.GetConnection
	Dim res As ResultSet
	Dim strSQL As String	
	Try
		Dim Map1 As Map = Request2Map
		If Map1 = Null Or Map1.IsInitialized = False Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		
		Dim uid As String = Map1.Get("uid")
		Dim pwd As String = Map1.Get("pwd")			
		If uid = "" Or pwd = "" Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
				
		strSQL = "SELECT"
		strSQL = strSQL & " id"
		strSQL = strSQL & " FROM users"
		strSQL = strSQL & " WHERE name = ?"		
		res = con.ExecQuery2(strSQL, Array As String(uid))
		If res.NextRow Then
			Utility.ReturnError("Error-User-Exist", Response)
			con.Close
			Return
		Else			
			strSQL = "INSERT INTO users"
			strSQL = strSQL & " (name,"
			strSQL = strSQL & " password)"
			strSQL = strSQL & " VALUES (?, md5(?))"
			con.ExecNonQuery2(strSQL, Array As String(uid, pwd))
			Dim Map2 As Map = CreateMap("register": 1)
			Utility.ReturnSuccess(Map2, Response)
			con.Close
			Return
		End If
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub

Sub Login
	Dim con As SQL = pool.GetConnection
	Dim res As ResultSet
	Dim strSQL As String
	Try
		Dim Map1 As Map = Request2Map
		If Map1 = Null Or Map1.IsInitialized = False Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		Dim uid As String = Map1.Get("uid")
		Dim pwd As String = Map1.Get("pwd")				
		If uid = "" Or pwd = "" Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		
		strSQL = "SELECT"
		strSQL = strSQL & " id AS `result`,"
		strSQL = strSQL & " 'success' AS `message`,"
		strSQL = strSQL & " name"
		strSQL = strSQL & " FROM users"
		strSQL = strSQL & " WHERE name = ?"
		strSQL = strSQL & " AND password = md5(?)"	
		res = con.ExecQuery2(strSQL, Array As String(uid, pwd))
		If res.NextRow Then		
			Dim Map2 As Map = CreateMap("login": 1)			
			Utility.ReturnSuccess(Map2, Response)
		Else
			Utility.ReturnError("Error-User-Denied", Response)
		End If
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub

Sub GetTopics
	Dim con As SQL = pool.GetConnection
	Dim res As ResultSet
	Dim strSQL As String
	Try
		strSQL = "SELECT"
		strSQL = strSQL & " id,"
		strSQL = strSQL & " topic"
		strSQL = strSQL & " FROM topics"	
		strSQL = strSQL & " WHERE enabled = 1"
		strSQL = strSQL & " ORDER BY id"
		res = con.ExecQuery(strSQL)
		Dim List2 As List
		List2.Initialize
		Do While res.NextRow
			List2.Add(CreateMap("id": res.GetInt("id"), "topic": res.GetString("topic")))
		Loop
		Utility.ReturnSuccess2(List2, Response)
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub

Sub GetResults
	Dim con As SQL = pool.GetConnection	
	Dim strSQL As String
	Try
		Dim Map1 As Map = Request2Map
		If Map1 = Null Or Map1.IsInitialized = False Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		Dim uid As String = Map1.Get("uid")
		Dim pwd As String = Map1.Get("pwd")
		Dim topic As String = Map1.Get("topic")
		If uid = "" Or pwd = "" Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If		
		strSQL = "SELECT"
		strSQL = strSQL & " t.id,"
		strSQL = strSQL & " t.topic,"
		strSQL = strSQL & " t.shortdesc,"
		strSQL = strSQL & " IFNULL(r.score, '') AS score"
		strSQL = strSQL & " FROM results r"
		strSQL = strSQL & " JOIN users u"
		strSQL = strSQL & " ON r.user = u.id"
		strSQL = strSQL & " AND u.name = ?"
		strSQL = strSQL & " AND u.password = md5(?)"
		strSQL = strSQL & " RIGHT JOIN topics t"
		strSQL = strSQL & " ON t.id = r.topic"
		If topic = "" Or topic = "null" Then
			strSQL = strSQL & " WHERE t.enabled = 1"
			strSQL = strSQL & " ORDER BY t.id"
			Dim res As ResultSet = con.ExecQuery2(strSQL, Array As String(uid, pwd))
		Else
			strSQL = strSQL & " WHERE t.id = ?"
			Dim res As ResultSet = con.ExecQuery2(strSQL, Array As String(uid, pwd, topic))
		End If
		Dim List2 As List
		List2.Initialize
		Do While res.NextRow
			List2.Add(CreateMap("id": res.GetInt("id"), _
			"topic": res.GetString("topic"), _
			"shortdesc": res.GetString("shortdesc"), _
			"score": res.GetString("score")))
		Loop
		Utility.ReturnSuccess2(List2, Response)
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub

Sub GetQuestion(id As String)
	Dim con As SQL = pool.GetConnection	
	Dim strSQL As String
	Try
		Dim qid As Int
		Dim question As String
		Dim correct As Int
		Dim Answers As List
		Dim Questions As List
		Answers.Initialize
		Questions.Initialize		
		strSQL = "SELECT"
		strSQL = strSQL & " q.id AS qid,"
		strSQL = strSQL & " q.question,"
		strSQL = strSQL & " q.answer AS correct,"
		strSQL = strSQL & " a.id AS aid,"
		strSQL = strSQL & " a.answer"
		strSQL = strSQL & " FROM questions q"
		strSQL = strSQL & " LEFT JOIN answers a"
		strSQL = strSQL & " ON q.id = a.question"
		strSQL = strSQL & " AND a.enabled = 1"
		strSQL = strSQL & " WHERE q.enabled = 1"
		strSQL = strSQL & " AND q.id = ?"
		strSQL = strSQL & " ORDER BY a.id"
		Dim res As ResultSet = con.ExecQuery2(strSQL, Array As String(id))
		Do While res.NextRow
			Dim ans As Map
			ans.Initialize
			For i = 0 To res.ColumnCount - 1
				Select res.GetColumnName(i)
					Case "qid"
						qid = res.GetInt2(i)
					Case "question"
						question = res.GetString2(i)
					Case "correct"
						correct = res.GetInt2(i)
					Case "aid"
						ans.Put(res.GetColumnName(i), res.GetInt2(i))
					Case "answer"
						ans.Put(res.GetColumnName(i), res.GetString2(i))
				End Select
			Next
			Answers.Add(ans)
		Loop
		If qid > 0 Then
			Questions.Add(CreateMap("qid": qid, "question": question, "correct": correct, "answers": Answers))
			Utility.ReturnSuccess2(Questions, Response)
		Else
			Utility.ReturnError("Error-No-Result", Response)
		End If
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub

Sub GetQuestions(topic As String)
	Dim con As SQL = pool.GetConnection	
	Dim strSQL As String
	Try
		Dim qid As Int
		Dim List1 As List
		Dim Answers As List
		Dim Questions As List
		List1.Initialize
		Answers.Initialize
		Questions.Initialize		
		
		strSQL = "SELECT"
		strSQL = strSQL & " q.id AS qid,"
		strSQL = strSQL & " q.question,"
		strSQL = strSQL & " q.answer AS correct,"
		strSQL = strSQL & " a.id AS aid,"
		strSQL = strSQL & " a.answer"
		strSQL = strSQL & " FROM questions q"
		strSQL = strSQL & " LEFT JOIN answers a"
		strSQL = strSQL & " ON q.id = a.question"
		strSQL = strSQL & " AND a.enabled = 1"
		strSQL = strSQL & " WHERE q.enabled = 1"
		strSQL = strSQL & " AND q.topic = ?"
		strSQL = strSQL & " GROUP BY q.id, a.id"
		strSQL = strSQL & " ORDER BY q.id, a.id"
		Dim res As ResultSet = con.ExecQuery2(strSQL, Array As String(topic))
		Do While res.NextRow
			If qid <> res.GetInt("qid") Then
				Questions.Add(CreateMap("qid": res.GetInt("qid"), "question": res.GetString("question"), "correct": res.GetInt("correct")))
				qid = res.GetInt("qid")
			End If
			Answers.Add(CreateMap("qid": res.GetInt("qid"), "aid": res.GetInt("aid"), "answer": res.GetString("answer")))
		Loop
		res.Close		
		If Questions.Size > 0 Then
			For Each que As Map In Questions
				Dim List2 As List
				List2.Initialize
				For Each ans As Map In Answers
					If que.Get("qid") = ans.Get("qid") Then
						List2.Add(CreateMap("aid": ans.Get("aid"), "answer": ans.Get("answer")))
					End If
				Next
				List1.Add(CreateMap("qid": que.Get("qid"), "question": que.Get("question"), "correct": que.Get("correct"), "answers": List2))
			Next			
		End If
		Utility.ReturnSuccess2(List1, Response)
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub

Sub PutAnswers
	Dim con As SQL = pool.GetConnection	
	Dim strSQL As String
	Try
		Dim Map1 As Map = Request2Map
		Log(Map1)
		If Map1 = Null Or Map1.IsInitialized = False Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		If Map1.ContainsKey("uid") = False Or _
			Map1.ContainsKey("pwd") = False Or _
			Map1.ContainsKey("topic") = False Or _
			Map1.ContainsKey("submitted") = False Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		
		Dim uid As String = Map1.Get("uid")
		Dim pwd As String = Map1.Get("pwd")
		Dim topic As String = Map1.Get("topic")
		Dim submitted As Map = Map1.Get("submitted")
		If uid = "" Or pwd = "" Or topic = "" Then
			Utility.ReturnError("Error-No-Value", Response)
			con.Close
			Return
		End If
		'Log(submitted)
		' Marking answers
		Dim score As Int
		Dim total As Int
		For i = 0 To submitted.Size - 1
			strSQL = "SELECT"
			strSQL = strSQL & " answer"
			strSQL = strSQL & " FROM questions"
			strSQL = strSQL & " WHERE topic = ?"
			strSQL = strSQL & " AND id = ?"
			Dim row As ResultSet = con.ExecQuery2(strSQL, Array As String(topic, submitted.GetKeyAt(i)))
			Do While row.NextRow
				If row.GetInt2(0) = submitted.GetValueAt(i) Then
					score = score + 1
				End If
			Loop
			row.Close
			total = total + 1
		Next
		
		strSQL = "SELECT"
		strSQL = strSQL & " id"
		strSQL = strSQL & " FROM users"
		strSQL = strSQL & " WHERE name = ?"
		strSQL = strSQL & " AND password = md5(?)"
		Dim usr As ResultSet = con.ExecQuery2(strSQL, Array As String(uid, pwd))
		If usr.NextRow Then
			' Find existing record and Insert/Update
			strSQL = "SELECT"
			strSQL = strSQL & " id"
			strSQL = strSQL & " FROM results"
			strSQL = strSQL & " WHERE topic = ?"
			strSQL = strSQL & " AND user = ?"
			Dim res As ResultSet = con.ExecQuery2(strSQL, Array As String(topic, usr.GetInt("id")))
			If res.NextRow Then
				strSQL = "UPDATE results"
				strSQL = strSQL & " SET score = ?,"
				strSQL = strSQL & " modified_date = now()"
				strSQL = strSQL & " WHERE topic = ?"
				strSQL = strSQL & " AND user = ?"
				strSQL = strSQL & " AND id = ?"
				con.ExecNonQuery2(strSQL, Array As String(score & "/" & total, topic, usr.GetInt("id"), res.GetInt("id")))
				Utility.ReturnSuccess2(Null, Response)
			Else
				strSQL = "INSERT INTO results"
				strSQL = strSQL & " (user, topic, score) VALUES"
				strSQL = strSQL & " (?, ?, ?)"
				con.ExecNonQuery2(strSQL, Array As String(usr.GetInt("id"), topic, score & "/" & total))
				Utility.ReturnSuccess2(Null, Response)
			End If
			res.Close
		Else
			Utility.ReturnError("Error-User-Denied", Response)
		End If
		usr.Close
	Catch
		Log(LastException)
		Utility.ReturnError("Error-Execute-Query", Response)
	End Try
	If con <> Null And con.IsInitialized Then con.Close
End Sub