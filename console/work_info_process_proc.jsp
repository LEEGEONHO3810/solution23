<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>

<%@ page import="java.awt.image.BufferedImage" %>

<%@ page import="java.io.*, java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%@ page import="java.awt.image.BufferedImage" %>

<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>

<%
	try {
		request.setCharacterEncoding("UTF-8");

		File file ;
		int maxFileSize = 100 * 1024 * 1024;
		int maxMemSize = 100 * 1024 * 1024;
		// String filePath = "C:/Program Files/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/TPAServer/PTA_PACKAGE_SCANNER/images/";
		String filePath = "C:/Program Files (x86)/Apache Software Foundation/Tomcat 9.0/webapps/ROOT/test_img/";
		// String filePath = "/Users/namseokpark/Documents/workspace-sts-3.9.10.RELEASE/PTAReportAgentServer/WebContent/data/report_img/";
		// System.out.println("+ UpdateMaterialLInfo.start!!! ");

		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;
		// System.out.println("+ UpdateMaterialLInfo.contentType " + contentType);

		String _order_id_ = request.getParameter("_order_id_");
		String _work_process_ = request.getParameter("_work_process_");

		System.out.println("> _order_id_ " + _order_id_);
		System.out.println("> _work_process_ " + _work_process_);


		java.util.Date today = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("YYYY/MM/dd");
		String current_date = df.format(today);
		System.out.println("> " + strCurrentReportId + ".current_date " + current_date);

		String query  = "";

		stmt = conn.createStatement();

		String strCondition = "";
		// if(!_work_process_.equals("01")) {
			strCondition += "clm_work_state='" + _work_process_ + "' ";
		// }

		query = "";
		query += "update tbl_work_info set " + strCondition + " where clm_order_id='" + _order_id_ + "';";
		System.out.println("> " + strCurrentReportId + ".update_work_info " + query);
		stmt.execute(query);

		strCondition = "";
		// if(!_work_process_.equals("01")) {
			strCondition += "clm_work_process_" + _work_process_ + "='Y',  clm_work_process_" + _work_process_ + "_date='" + current_date + "'";
		// }

		query = "";
		query += "update tbl_work_progress_info set " + strCondition + " where clm_order_id='" + _order_id_ + "';";
		System.out.println("> " + strCurrentReportId + ".update_work_process_info " + query);
		stmt.execute(query);

		JSONObject jsonMain = new JSONObject();
		JSONArray jArray = new JSONArray();
		JSONObject jObject = null;

		jObject = new JSONObject();
		jObject.put("work_date", current_date);
		jArray.add(0, jObject);
		jsonMain.put("order_data", jArray);

		response.setContentType("application/x-json; charset=UTF-8");
		response.getWriter().print(jsonMain);
		// response.getWriter().print(jsonMain.toJSONString());
		System.out.println(jsonMain.toJSONString());
	}
	catch(Exception e) {
		System.out.println("> " + strCurrentReportId + " e : " + e.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>