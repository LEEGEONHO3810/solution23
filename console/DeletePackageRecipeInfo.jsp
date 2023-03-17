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

	String material_income_id = request.getParameter("material_income_id") == null? "" : request.getParameter("material_income_id");
	String material_id = request.getParameter("material_id") == null? "" : request.getParameter("material_id");
	String incomeYn  = request.getParameter("incomeYn") == null? "" : request.getParameter("incomeYn");
	String clm_material_order_seq  = request.getParameter("clm_material_order_seq") == null? "" : request.getParameter("clm_material_order_seq");

	String user_id = session.getAttribute("user_id").toString();	

	System.out.println("> material_income_id: " + material_income_id);
	System.out.println("> material_id : " + material_id);
	System.out.println("> incomeYn : " + incomeYn);
	System.out.println("> clm_material_order_seq : " + clm_material_order_seq);


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
			if(!material_income_id.equals("")) {
				
				stmt = conn.createStatement();
				query = " delete from tbl_material_order_detail_info ";
				query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_id = '" + material_id + "'  ";
				query += " and clm_material_order_id = '" + material_income_id + "' and clm_material_order_seq = '"+ clm_material_order_seq +"'  ";
				
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
