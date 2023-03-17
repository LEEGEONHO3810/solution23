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

		System.out.println("> _order_id_ " + _order_id_);

		String query  = "";

		stmt = conn.createStatement();

		query = "";
		query += "update tbl_order_info set clm_del_yn='Y' where clm_order_id='" + _order_id_ + "';";
		System.out.println("> " + strCurrentReportId + ".delete_order_info " + query);
		stmt.execute(query);
	}
	catch(Exception e) {
		System.out.println("> " + strCurrentReportId + " e : " + e.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>