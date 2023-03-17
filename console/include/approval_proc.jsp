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

	boolean blnResult = false;

	if(___proc_id___.equals("001")) {
		String ___approval_level_id___ = (request.getParameter("___approval_level_id___")==null)?"":request.getParameter("___approval_level_id___");
		String ___approval_user_id___ = (request.getParameter("___approval_user_id___")==null)?"":request.getParameter("___approval_user_id___");

		stmt = conn.createStatement();
		strCondition  = "";
		strCondition += "and clm_report_id='" + ___report_id___ + "'";
		if(___approval_level_id___.equals("01")) {
			strQueryPart = "clm_approval_01_id='" + ___approval_user_id___ + "', clm_approval_01_datetime=(to_char(now(), 'YYYYMMDDHHMISSMS'::text)::character varying)";
		}
		else if(___approval_level_id___.equals("02")) {
			strQueryPart = "clm_approval_02_id='" + ___approval_user_id___ + "', clm_approval_02_datetime=(to_char(now(), 'YYYYMMDDHHMISSMS'::text)::character varying)";
		}
		else if(___approval_level_id___.equals("03")) {
			strQueryPart = "clm_approval_03_id='" + ___approval_user_id___ + "', clm_approval_03_datetime=(to_char(now(), 'YYYYMMDDHHMISSMS'::text)::character varying)";
		}
		strQueryString = "update _tbl_report_" + ___doc_id___ + "_master_data set " + strQueryPart + " where 1=1 " + strCondition;
		System.out.println("> " + strCurrentReportId + " strQueryString : " + strQueryString);
		blnResult = stmt.execute(strQueryString);

		out.print("{\"level\":\"" + ___approval_level_id___ + "\"}");
	}
	else if(___proc_id___.equals("002")) {
		String ___write_time___ = (request.getParameter("___write_time___")==null)?"":request.getParameter("___write_time___");
		String ___manager_id___ = (request.getParameter("___manager_id___")==null)?"":request.getParameter("___manager_id___");
		String ___session_user_id___ = (request.getParameter("___session_user_id___")==null)?"":request.getParameter("___session_user_id___");

		stmt = conn.createStatement();
		strCondition  = "";
		strCondition += "and clm_report_id='" + ___report_id___ + "' ";
		strCondition += "and clm_write_time='" + ___write_time___ + "';";

		strQueryPart = "clm_confirm_user_id='" + ___session_user_id___ + "', clm_confirm_datetime=(to_char(now(), 'YYYYMMDDHHMISSMS'::text)::character varying)";

		strQueryString = "update _tbl_report_" + ___doc_id___ + "_slave_data set " + strQueryPart + " where 1=1 " + strCondition;
		System.out.println("> " + strCurrentReportId + " strQueryString : " + strQueryString);
		blnResult = stmt.execute(strQueryString);

		out.print("[{'report_id':'" + ___report_id___ + "', 'write_time':'" + ___write_time___ + "'}]");
	}
%>
<%@ include file="conn_close_info.jsp" %>