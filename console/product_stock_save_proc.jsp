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
	String material_id = request.getParameter("material_id") == null? "" : request.getParameter("material_id");

	String product_id = request.getParameter("product_id") == null? "" : request.getParameter("product_id");
	String clm_product_code = request.getParameter("product_code") == null? "" : request.getParameter("product_code");
	String clm_product_name  = request.getParameter("product_name") == null? "" : request.getParameter("product_name");
	String clm_product_spec = request.getParameter("product_spec") == null? "" : request.getParameter("product_spec");
	String clm_product_main_type = request.getParameter("product_main_id") == null? "" : request.getParameter("product_main_id");
	String clm_product_sub_type = request.getParameter("product_sub_id") == null? "" : request.getParameter("product_sub_id");
	String clm_product_safety_stock = request.getParameter("product_safety_stock") == null? "" : request.getParameter("product_safety_stock");
	String clm_comment = request.getParameter("product_comment") == null? "" : request.getParameter("product_comment");
	
	String user_id = session.getAttribute("user_id").toString();	

	System.out.println("> ProductRegUpdate.product_id : " + product_id);
	System.out.println("> ProductRegUpdate.product_code : " + clm_product_code);
	System.out.println("> ProductRegUpdate.product_name : " + clm_product_name);
	System.out.println("> ProductRegUpdate.product_spec : " + clm_product_spec);
	System.out.println("> ProductRegUpdate.product_main_type : " + clm_product_main_type);
	System.out.println("> ProductRegUpdate.product_sub_type : " + clm_product_sub_type);
	System.out.println("> ProductRegUpdate.product_safety_stock : " + clm_product_safety_stock);
	System.out.println("> ProductRegUpdate.material_safety_stock : " + clm_comment);
	System.out.println("> ProductRegUpdate.user_id : " + user_id);

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
			if(product_id.equals("")) {
				stmt = conn.createStatement();
				query = " insert into tbl_product_info ";
				query += " (clm_company_key, clm_product_code, clm_product_name, clm_product_spec, clm_product_main_type, clm_product_sub_type,clm_product_safety_stock, clm_comment, clm_delete_yn, clm_reg_user, clm_reg_datetime, clm_update_user, clm_update_datetime) ";
				query += " values ";
				query += " ('" + SessionCompanyKey + "','" + clm_product_code + "','" + clm_product_name + "','" + clm_product_spec + "','" + clm_product_main_type + "','" + clm_product_sub_type + "','" + clm_product_safety_stock + "','" + clm_comment + "', 'N' ,'" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '', '') ";
				
				System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();

				//신규 데이터는 stock 데이터 생성
				stmt = conn.createStatement();
				query = " insert into tbl_product_stock ";
				query += " (clm_company_key, clm_product_id, clm_stock_count, clm_update_user, clm_update_datetime) ";
				query += " values ";
				query += " ('" + SessionCompanyKey + "', (select max(clm_product_id) from tbl_product_info where clm_company_key = '" + SessionCompanyKey + "'),'0', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
				
				System.out.println("> MaterialInfoRegUpdate.q.0.2 : " + query + "");
				 ps = conn.prepareStatement(query);
				 numRowsUpdated = ps.executeUpdate();
				 stmt.close();
			} else {
				
				stmt = conn.createStatement();
				query = " update tbl_product_info ";
				query += " set clm_product_name ='" + clm_product_name + "',clm_company_key = '" + SessionCompanyKey + "', clm_product_code = '" + clm_product_code + "', clm_product_spec = '" + clm_product_spec + "', clm_product_main_type = '" + clm_product_main_type + "', clm_product_sub_type = '" + clm_product_sub_type + "' ";
				query += "	, clm_product_safety_stock = '" + clm_product_safety_stock + "', clm_comment = '" + clm_comment + "', clm_update_user = '" + user_id + "', clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ";
				query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_product_id = '" + product_id + "'";
				 
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
