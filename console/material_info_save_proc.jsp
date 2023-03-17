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

	String material_code = request.getParameter("material_code") == null? "" : request.getParameter("material_code");
	String material_name = request.getParameter("material_name") == null? "" : request.getParameter("material_name");
	String material_main_id  = request.getParameter("material_main_id ") == null? "" : request.getParameter("material_main_id ");
	String material_sub_id = request.getParameter("material_sub_id") == null? "" : request.getParameter("material_sub_id");
	String material_unit = request.getParameter("material_unit") == null? "" : request.getParameter("material_unit");
	String material_comment = request.getParameter("material_comment") == null? "" : request.getParameter("material_comment");
	String material_safety_stock = request.getParameter("material_safety_stock") == null? "" : request.getParameter("material_safety_stock");
	String material_pack_count = request.getParameter("material_pack_count") == null? "0" : request.getParameter("material_pack_count");
	String material_code_name = request.getParameter("material_code_name") == null? "0" : request.getParameter("material_code_name");
	String user_id = session.getAttribute("user_id").toString();	

	System.out.println("> MaterialInfoRegUpdate.material_code : " + material_code);
	System.out.println("> MaterialInfoRegUpdate.material_name : " + material_name);
	System.out.println("> MaterialInfoRegUpdate.material_main_id : " + material_main_id);
	System.out.println("> MaterialInfoRegUpdate.material_sub_id : " + material_sub_id);
	System.out.println("> MaterialInfoRegUpdate.material_unit : " + material_unit);
	System.out.println("> MaterialInfoRegUpdate.material_comment : " + material_comment);
	System.out.println("> MaterialInfoRegUpdate.material_safety_stock : " + material_safety_stock);
	System.out.println("> MaterialInfoRegUpdate.user_id : " + user_id);

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
			if(material_id.equals("")) {
				stmt = conn.createStatement();
				query = " insert into tbl_material_info ";
				query += " (clm_company_key,clm_material_code, clm_material_name, clm_material_main_type, clm_material_sub_type, clm_material_unit, clm_material_safety_stock, clm_comment, clm_delete_yn, clm_reg_user, clm_reg_datetime, clm_update_user, clm_update_datetime) ";
				query += " values ";
				query += " ('" + SessionCompanyKey + "','" + material_code + "','" + material_name + "','" + material_main_id + "','" + material_sub_id + "','" + material_unit + "','" + material_safety_stock + "','" + material_comment + "', 'N' ,'" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '', '') ";
				
				System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();

				// 신규 데이터는 stock 데이터 생성
				stmt = conn.createStatement();
				query = " insert into tbl_material_stock ";
				query += " (clm_company_key, clm_material_id, clm_stock_count, clm_update_user, clm_update_datetime) ";
				query += " values ";
				query += " ('" + SessionCompanyKey + "', (select max(clm_material_id) from tbl_material_info where clm_company_key = '" + SessionCompanyKey + "'),'0', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
				
				System.out.println("> MaterialInfoRegUpdate.q.0.2 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();
			} else {
				
				stmt = conn.createStatement();
				query = " update tbl_material_info ";
				query += " set clm_material_code = '" + material_code + "', clm_material_name = '" + material_name + "', clm_material_main_type = '" + material_main_id + "', clm_material_sub_type = '" + material_sub_id + "', clm_material_unit = '" + material_unit + "' ";
				query += "	, clm_material_safety_stock = '" + material_safety_stock + "', clm_comment = '" + material_comment + "', clm_update_user = '" + user_id + "', clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ";
				query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_id = '" + material_id + "'";
				
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
