<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
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
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/session_info.jsp" %>

<%
	try {
		request.setCharacterEncoding("UTF-8");

		String _txt_process_type_	 = request.getParameter("txt_process_type");
		String _txt_order_id_		 = request.getParameter("txt_order_id");

		String query  = "";

		stmt = conn.createStatement();
		query  = "";
		query += "update tbl_order_info set clm_order_state_type='" + _txt_process_type_ + "' where clm_order_id='" + _txt_order_id_ + "';";
		stmt.execute(query);

		if(_txt_process_type_.equals("C")) {
			query  = "";
			query += "update tbl_work_progress_info set clm_work_process_01_schedule='', clm_work_process_02_schedule='', clm_work_process_03_schedule='', clm_work_process_04_schedule='', clm_work_process_05_schedule='', clm_work_process_06_schedule='', clm_work_process_07_schedule='', clm_work_process_08_schedule='', clm_work_process_09_schedule='', clm_work_process_10_schedule='', clm_work_process_11_schedule='', clm_work_process_12_schedule='', clm_work_process_13_schedule='', clm_work_process_14_schedule='', clm_work_process_15_schedule='', clm_work_process_16_schedule='', clm_work_process_17_schedule='', clm_work_process_18_schedule='', clm_work_process_19_schedule='', clm_work_process_20_schedule='', clm_work_process_21_schedule='', clm_work_process_22_schedule='' where clm_order_id='" + _txt_order_id_ + "';";
			// System.out.println("> " + strCurrentReportId + ".insert_work_progress_info " + query);
			stmt.execute(query);
		}

		JSONObject jsonMain = new JSONObject();
		JSONArray jArray = new JSONArray();
		JSONObject jObject = null;

		jObject = new JSONObject();
		jObject.put("order_id", _txt_order_id_);
		jObject.put("order_state", _txt_process_type_);
		jArray.add(0, jObject);
		jsonMain.put("order_data", jArray);

		response.setContentType("application/x-json; charset=UTF-8");
		response.getWriter().print(jsonMain);
		System.out.println(jsonMain.toJSONString());

	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>