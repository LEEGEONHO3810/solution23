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
	String authority_id = request.getParameter("authority_id") == null? "" : request.getParameter("authority_id");
	String user_id = session.getAttribute("user_id").toString();	

	System.out.println("> AuthorityInfoDelete.authority_id : " + authority_id);
	System.out.println("> AuthorityInfoDelete.user_id : " + user_id);

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
			if(!authority_id.equals("")) {
				String[] array_authority_id = authority_id.split(",");
				stmt = conn.createStatement();
				
				for(int i=0; i<array_authority_id.length; i++){
					query = " update tbl_authority_info set clm_delete_yn = 'Y' , clm_update_user= '"+ user_id +"', clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ";
					query += " where clm_company_key = '" + (String)session.getAttribute("company_key") + "' and clm_authority_id = '" + array_authority_id[i] + "'"; 
					System.out.println("> AuthorityInfoDelete.q.0.1 : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
				}
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
