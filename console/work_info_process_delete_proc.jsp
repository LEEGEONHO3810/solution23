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
		
		String _order_id_			 = request.getParameter("order_id");
		String _process_id_			 = request.getParameter("process_id");
		String _process_date_		 = request.getParameter("process_date");

		String query  = "";

		stmt = conn.createStatement();
		query  = "";
		query += "update tbl_work_progress_info set ";
		if(_process_id_.equals("01")){
			query += "  clm_work_process_01_date = '',  clm_work_process_01 = 'N'  ";
		}else if(_process_id_.equals("02")){
			query += "  clm_work_process_02_date = '',  clm_work_process_02 = 'N'  ";
		}else if(_process_id_.equals("03")){
			query += "  clm_work_process_03_date = '',  clm_work_process_03 = 'N'  ";
		}else if(_process_id_.equals("04")){
			query += "  clm_work_process_04_date = '',  clm_work_process_04 = 'N'  ";
		}else if(_process_id_.equals("05")){
			query += "  clm_work_process_05_date = '',  clm_work_process_05 = 'N'  ";
		}else if(_process_id_.equals("06")){
			query += "  clm_work_process_06_date = '',  clm_work_process_06 = 'N'  ";
		}else if(_process_id_.equals("07")){
			query += "  clm_work_process_07_date = '',  clm_work_process_07 = 'N'  ";
		}else if(_process_id_.equals("08")){
			query += "  clm_work_process_08_date = '',  clm_work_process_08 = 'N'  ";
		}else if(_process_id_.equals("09")){
			query += "  clm_work_process_09_date = '',  clm_work_process_09 = 'N'  ";
		}else if(_process_id_.equals("10")){
			query += "  clm_work_process_10_date = '',  clm_work_process_10 = 'N'  ";
		}else if(_process_id_.equals("11")){
			query += "  clm_work_process_11_date = '',  clm_work_process_11 = 'N'  ";
		}else if(_process_id_.equals("12")){
			query += "  clm_work_process_12_date = '',  clm_work_process_12 = 'N'  ";
		}else if(_process_id_.equals("13")){
			query += "  clm_work_process_13_date = '',  clm_work_process_13 = 'N'  ";
		}else if(_process_id_.equals("14")){
			query += "  clm_work_process_14_date = '',  clm_work_process_14 = 'N'  ";
		}else if(_process_id_.equals("15")){
			query += "  clm_work_process_15_date = '',  clm_work_process_15 = 'N'  ";
		}else if(_process_id_.equals("16")){
			query += "  clm_work_process_16_date = '',  clm_work_process_16 = 'N'  ";
		}else if(_process_id_.equals("17")){
			query += "  clm_work_process_17_date = '',  clm_work_process_17 = 'N'  ";
		}else if(_process_id_.equals("18")){
			query += "  clm_work_process_18_date = '',  clm_work_process_18 = 'N'  ";
		}else if(_process_id_.equals("19")){
			query += "  clm_work_process_19_date = '',  clm_work_process_19 = 'N'  ";
		}else if(_process_id_.equals("20")){
			query += "  clm_work_process_20_date = '',  clm_work_process_20 = 'N'  ";
		}else if(_process_id_.equals("21")){
			query += "  clm_work_process_21_date = '',  clm_work_process_21 = 'N'  ";
		}else if(_process_id_.equals("22")){
			query += "  clm_work_process_22_date = '',  clm_work_process_22 = 'N'  ";
		}
		query += " where clm_order_id = '" + _order_id_ + "';";
		stmt.execute(query);

		JSONObject jsonMain = new JSONObject();
		JSONArray jArray = new JSONArray();
		JSONObject jObject = null;

		jObject = new JSONObject();
		jObject.put("order_id", _order_id_);
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