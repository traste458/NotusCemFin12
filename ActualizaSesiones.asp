<%

	if Request.QueryString("s001")<>"" then
		session("usxp001") = request.QueryString("s001")
		session("usxp002") = request.QueryString("s002")
		session("usxp003") = request.QueryString("s003")
		session("usxp004") = request.QueryString("s004")
		session("usxp005") = request.QueryString("s005")
		session("usxp006") = request.QueryString("s006")
		session("usxp007") = request.QueryString("s007")
		session("usxp008") = request.QueryString("s008")
		session("usxp009") = request.QueryString("s009")
		session("usxp010") = request.QueryString("s010")
		session("usxp011") = request.QueryString("s011")
		session("usxp012") = request.QueryString("s012")
		session("usxp013") = request.QueryString("s013")

		if not IsNull(request.QueryString("redirectTo")) then
			direccionar = request.QueryString("redirectTo")

			response.redirect direccionar
		end if
	else
		if IsNull(session("usxp001")) or session("usxp001") = "" then
			session("usxp001") = request.form("s001")
			session("usxp002") = request.form("s002")
			session("usxp003") = request.form("s003")
			session("usxp004") = request.form("s004")
			session("usxp005") = request.form("s005")
			session("usxp006") = request.form("s006")
			session("usxp007") = request.form("s007")
			session("usxp008") = request.form("s008")
			session("usxp009") = request.form("s009")
			session("usxp010") = request.form("s010")
			session("usxp011") = request.form("s011")
			session("usxp012") = request.form("s012")
			session("usxp013") = request.form("s013")
		end if
	end if
    
%>