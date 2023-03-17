<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>
<%
	String strDocId = "";
	String clm_report_id		 = "";
	String clm_report_name		 = "";
	String clm_contents_info	 = "";
	// String clm_comment			 = "";
	String clm_report_type		 = "";
	String[] arrCurrentReportName = (request.getServletPath()).split("/");
	String strCurrentReportId = arrCurrentReportName[arrCurrentReportName.length-1].split("\\.")[0];
	String strCurrentReportName = "";
	String strOrderId = "";

	String _clm_product_id      = "";
	String _clm_model_id        = "";
	String _clm_product_name    = "";
	String _clm_model_name      = "";
	String _clm_product_type_id = "";

	String _clm_user_id            = "";
	String _clm_user_password      = "";
	String _clm_user_name          = "";
	String _clm_user_department_id = "";

	String _clm_comment              = "";
	String _clm_reg_datetime         = "";
	String _clm_reg_user             = "";
	String _clm_update_datetime      = "";
	String _clm_update_user          = "";
	String _clm_use_yn               = "";


	String _clm_code_id         = "";
	String _clm_code_sub_id     = "";
	String _clm_code_name       = "";
	String _clm_code_sub_name   = "";
	String _clm_code_value      = "";

	String _clm_modal_code_id        = "";
	String _clm_modal_code_sub_id    = "";

	String _clm_approval_01_stamp = "";
	String _clm_approval_02_stamp = "";
	String _clm_approval_03_stamp = "";
	
	String _test = "";

	java.util.Date dtNow = new java.util.Date();
	SimpleDateFormat sdfFormatter = new SimpleDateFormat("yyyy-MM-dd");
	String strFormatedNow = sdfFormatter.format(dtNow);
%>