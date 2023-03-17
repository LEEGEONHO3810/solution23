<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.Date"
	import="java.util.Calendar"
	import="java.util.Locale"
	import="java.util.GregorianCalendar"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"%>
<%
	request.setCharacterEncoding("UTF-8");
	if(session==null || !request.isRequestedSessionIdValid() || ((String)session.getAttribute("user_authority") == null) || ((String)session.getAttribute("user_home") == null) || ((String)session.getAttribute("user_authority_screen") == null)) {
%>
	<script>
		alert('정상적이지 않은 로그인 상태 이므로 다시 로그인 해주시기 바랍니다.');
		self.close();
	</script>
<%
	}
%>