<%@ page language="java" pageEncoding="UTF-8" %>
<%
	String ss_user_id			 = (String)session.getAttribute("user_id");
	String ss_user_name			 = (String)session.getAttribute("user_name");
	String ss_department_id		 = "003";
	String ss_department_name	 = "관리부서";
	String ss_auth_level		 = "003";
	String ss_user_stamp		 = "_stamp_user003.png";

	System.out.println("> session " + session);
	System.out.println("> request.isRequestedSessionIdValid() " + request.isRequestedSessionIdValid());
	System.out.println("> user_id " + (String)session.getAttribute("user_id"));
	System.out.println("> user_name " + (String)session.getAttribute("user_name"));

	
	String header_color = (session.getAttribute("header_color").equals(""))?"":(String)session.getAttribute("header_color");
	String user_img = (session.getAttribute("user_img").equals(""))?"themes/images/user-icon.png":(String)session.getAttribute("user_img");
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");
	String SessionUserID = (String)session.getAttribute("clm_user_id");
	
	ArrayList<String> authorityScreen = (ArrayList)session.getAttribute("screen_arr");

	System.out.println("> 권한 ===================================================== " + authorityScreen);

	if(session==null || !request.isRequestedSessionIdValid() || ((String)session.getAttribute("user_id") == null) || ((String)session.getAttribute("user_name") == null) || ((String)session.getAttribute("mes_name") != "CHEONGJU_SOLUTION_2023")) {
%>
	<script>
		alert('정상적이지 않은 로그인 상태 이므로 다시 로그인 해주시기 바랍니다.');
		location.href="../UserLogin.jsp";
	</script>
<%
	}
%>