<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>

<%@ include file="conn_info.jsp" %>
<%
	String[] arrCurrentReportName = (request.getServletPath()).split("/");
	String strCurrentReportId = arrCurrentReportName[arrCurrentReportName.length-1].split("\\.")[0];

	String strCondition = "";
	String strQueryPart = "";
	String strQueryString = "";

	String ___proc_id___ = (request.getParameter("___proc_id___")==null)?"":request.getParameter("___proc_id___");
	String ___doc_id___ = (request.getParameter("___doc_id___")==null)?"":request.getParameter("___doc_id___");
	String ___report_id___ = (request.getParameter("___report_id___")==null)?"":request.getParameter("___report_id___");

	if(___proc_id___.equals("issue_001")) {
		String ___write_date___ = (request.getParameter("___write_date___")==null)?"":request.getParameter("___write_date___");
		String ___write_time___ = (request.getParameter("___write_time___")==null)?"":request.getParameter("___write_time___");
		String ___product_id___ = (request.getParameter("___product_id___")==null)?"":request.getParameter("___product_id___");
		String ___issue_id___ = (request.getParameter("___issue_id___")==null)?"":request.getParameter("___issue_id___");
		String ___manager_id___ = (request.getParameter("___manager_id___")==null)?"":request.getParameter("___manager_id___");

		stmt = conn.createStatement();
		strQueryString = "insert into _tbl_report_" + ___doc_id___ + "_slave_issue(clm_report_id, clm_write_date, clm_write_time, clm_product_id, clm_issue_seq, clm_issue_datetime, clm_response_id, clm_response_datetime, clm_approval_01_id, clm_approval_01_datetime, clm_comment, clm_manager_id, clm_issue_id) values('" + ___report_id___ + "', '" + ___write_date___ + "', '" + ___write_time___ + "', '" + ___product_id___ + "', ((select count(*) from fn_ccp_01_02_issue_info('" + ___report_id___ + "', '" + ___write_date___ + "', '" + ___write_time___ + "') y)+1), to_char(now(), 'YYYYMMDDHHMISSMS'::text)::character varying, '', '', '', '', '', '" + ___manager_id___ + "', '" + ___issue_id___ + "');";
		// strQueryString = "update _tbl_report_ccp_01_03_slave_issue set " + strQueryPart + " where 1=1 " + strCondition;
		System.out.println("> " + strCurrentReportId + " strQueryString : " + strQueryString);
		rs = stmt.executeQuery(strQueryString);
	}
	/*
	else if(___proc_id___.equals("002")) {
		// ___report_id___ : report_id,
		// ___write_time___ : write_time,
		// ___manager_id___ : manager_id,
		// ___session_user_id___ : session_user_id

		String ___write_time___ = (request.getParameter("___write_time___")==null)?"":request.getParameter("___write_time___");
		String ___manager_id___ = (request.getParameter("___manager_id___")==null)?"":request.getParameter("___manager_id___");
		String ___session_user_id___ = (request.getParameter("___session_user_id___")==null)?"":request.getParameter("___session_user_id___");

		stmt = conn.createStatement();
		strCondition  = "";
		strCondition += "and clm_report_id='" + ___report_id___ + "' ";
		strCondition += "and clm_write_time='" + ___write_time___ + "';";

		strQueryPart = "clm_confirm_user_id='" + ___session_user_id___ + "', clm_confirm_datetime=(to_char(now(), 'YYYYMMDDHHMISSMS'::text)::character varying)";

		strQueryString = "update _tbl_report_ccp_01_03_slave_data set " + strQueryPart + " where 1=1 " + strCondition;
		System.out.println("> " + strCurrentReportId + " strQueryString : " + strQueryString);
		rs = stmt.executeQuery(strQueryString);
	}
	*/
%>
<%@ include file="conn_close_info.jsp" %>