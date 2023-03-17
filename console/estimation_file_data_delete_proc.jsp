<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
	import="java.awt.image.BufferedImage"
	import="java.io.*, java.util.*, javax.servlet.*"
	import="javax.servlet.http.*"
	import="org.apache.commons.fileupload.*"
	import="org.apache.commons.fileupload.disk.*"
	import="org.apache.commons.fileupload.servlet.*"
	import="org.apache.commons.io.output.*"
	import="java.awt.image.BufferedImage"
	import="java.sql.DriverManager"
	import="java.sql.*"
	import="javax.imageio.ImageIO"
	import="java.util.Date"
	import="java.text.SimpleDateFormat"
%>
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%
	try {
		request.setCharacterEncoding("UTF-8");

		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;
		String _order_id_ = (request.getParameter("_order_id_") == null)?"":request.getParameter("_order_id_");
		String _file_seq_ = (request.getParameter("_file_seq_") == null)?"":request.getParameter("_file_seq_");
		//System.out.println("> _order_id_ " + _order_id_);
		//System.out.println("> _file_seq_ " + _file_seq_);

		String query  = "";
		
		if(!_order_id_.equals("") && !_file_seq_.equals("")){
			stmt = conn.createStatement();

			query = "";
			query += "update tbl_order_file set clm_del_yn='Y' where clm_order_id='" + _order_id_ + "' and clm_order_file_seq='" + _file_seq_ + "';";
			System.out.println("> " + strCurrentReportId + ".delete_work_file_info " + query);
			stmt.execute(query);
		}
	}
	catch(Exception e) {
		System.out.println("> " + strCurrentReportId + " e : " + e.toString());
	}
%>
<%@ include file="include/conn_close_info.jsp" %>