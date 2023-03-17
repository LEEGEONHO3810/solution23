<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<%@ page import="java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>
<%@ page import="org.apache.poi.hssf.record.*" %>
<%@ page import="org.apache.poi.hssf.model.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@include file="./PopupJava.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");

	String clm_machine_id = request.getParameter("clm_machine_id") == null? "" : request.getParameter("clm_machine_id");
	String machine_name = request.getParameter("machine_name") == null? "" : request.getParameter("machine_name");
	String machine_type_name = request.getParameter("machine_type_name") == null? "" : request.getParameter("machine_type_name");
	String machine_sub_id  = request.getParameter("machine_sub_id") == null? "" : request.getParameter("machine_sub_id");
	String ta_comment  = request.getParameter("ta_comment") == null? "" : request.getParameter("ta_comment");
	String user_id = session.getAttribute("user_id").toString();	

	System.out.println("> machine_save_proc.clm_machine_id : " + clm_machine_id);
	System.out.println("> machine_save_proc.machine_name : " + machine_name);
	System.out.println("> machine_save_proc.machine_type_name : " + machine_type_name);
	System.out.println("> machine_save_proc.machine_sub_id : " + machine_sub_id);
	System.out.println("> machine_save_proc.clm_machine_id : " + clm_machine_id);


	try {
		String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/"+(String)session.getAttribute("mes_name");
		String usr = "postgres";
		String pwd = "postgres";
		Class.forName("org.postgresql.Driver");
		String query = "";
		int iRowCount = 0;
		int numRowsUpdated = 0;
		ResultSet rs = null;

		Connection conn = DriverManager.getConnection(url, usr, pwd);
		Statement stmt = null;
		PreparedStatement ps = null;

		try {
			if(clm_machine_id.equals("")) {
				stmt = conn.createStatement();
				query = " insert into tbl_machine_info ";
				query += " (clm_company_key,clm_machine_name, clm_machine_type, clm_comment, clm_reg_user, clm_reg_datetime, clm_update_user, clm_update_datetime) ";
				query += " values ";
				query += " ('" + SessionCompanyKey + "','" + machine_name + "','" + machine_sub_id + "','" + ta_comment + "','" + user_id + "',to_char(now(), 'YYYYMMDDHH24MISSMS'::text),'', '') ";
				
				System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();
			
			} else if(!clm_machine_id.equals("")) {
				stmt = conn.createStatement();
				query = " update tbl_machine_info ";
				query += " set clm_company_key = '" + SessionCompanyKey + "', clm_machine_name = '" + machine_name + "', clm_machine_type = '" + machine_sub_id + "', clm_comment = '" + ta_comment + "', clm_update_user = '" + user_id + "' ";
				query += " , clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ";
				
				System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();
			}
		}
		catch(Exception e) {
			System.out.println("Error reading JSON string: " + e.toString());
		}
		
		conn.close();
	}
	catch (Exception e2) {
			System.out.println("> e2 : " + e2);
	   e2.printStackTrace();
	}
%>
