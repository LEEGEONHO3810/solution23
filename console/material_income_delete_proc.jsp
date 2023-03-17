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
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.multipart.FileRenamePolicy"%>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.StandardCopyOption" %>
<%

	String material_order_id = request.getParameter("material_order_id") == null? "" : request.getParameter("material_order_id");
	String material_comment = request.getParameter("comment") == null? "" : request.getParameter("comment");
	String client_id = request.getParameter("client_id") == null? "" : request.getParameter("client_id");
	String due_date = request.getParameter("due_date") == null? "" : request.getParameter("due_date");
	String order_date = request.getParameter("order_date") == null? "" : request.getParameter("order_date");
	String txt_process_type = request.getParameter("txt_process_type") == null? "" : request.getParameter("txt_process_type");

	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");
	String user_id = session.getAttribute("user_id").toString();	
	String dataArr = request.getParameter("dataArr") == null? "" : request.getParameter("dataArr");
	
	SimpleDateFormat format1 = new SimpleDateFormat ("yyyyMMdd");
	Date time = new Date();
	String CurrentDate = format1.format(time);
	System.out.println("현재일자 : " + CurrentDate);

	SimpleDateFormat format2 = new SimpleDateFormat ("yyyy-MM-dd");
	String nowDate = format2.format(time);
	System.out.println("현재일자 형식 : " + nowDate);

	System.out.println("=============== 등록 시작 ========================");
	
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
	
			stmt = conn.createStatement();
			query = " delete from tbl_material_order_detail_info ";
			query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_order_id + "' ";
			System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
			ps = conn.prepareStatement(query);
			numRowsUpdated = ps.executeUpdate();

			query = " delete from tbl_material_order_info ";
			query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_order_id + "' ";
			System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
			ps = conn.prepareStatement(query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();
				
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
