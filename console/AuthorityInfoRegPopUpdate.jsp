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
	String authority_name = request.getParameter("authority_name") == null? "" : request.getParameter("authority_name");
	String comment = request.getParameter("comment") == null? "" : request.getParameter("comment");
	String screen_data = request.getParameter("screen_data") == null? "" : request.getParameter("screen_data");
    
	String user_id = session.getAttribute("user_id").toString();	

	System.out.println("> AuthorityInfoRegPopUpdate.authority_id : " + authority_id);
	System.out.println("> AuthorityInfoRegPopUpdate.authority_name : " + authority_name);
	System.out.println("> AuthorityInfoRegPopUpdate.comment : " + comment);
	System.out.println("> AuthorityInfoRegPopUpdate.screen_data : " + screen_data);

	try {
		String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/CHEONGJU_SOLUTION_2023";
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

            if(authority_id.equals("")){ //신규

				// 권한테이블 insert 
                stmt = conn.createStatement();
                query = " insert into tbl_authority_info ";
                query += " ( clm_authority_name, clm_comment, clm_delete_yn, clm_reg_user, clm_reg_datetime, clm_update_user, clm_update_datetime) ";
                query += " values ";
                query += " ( '" + authority_name + "','" + comment + "','N','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ,'','') ";
                
                System.out.println("> AuthorityInfoRegPopUpdate.q.0.1 : " + query + "");
                ps = conn.prepareStatement(query);
                numRowsUpdated = ps.executeUpdate();
                stmt.close();

				JSONParser parser = new JSONParser();
				JSONArray obj = (JSONArray) parser.parse(screen_data);
	
				// 화면 권한 정보 insert
				for(int i=0; i<obj.size(); i++) {
					JSONObject listKey = (JSONObject) obj.get(i);

					String screen_id = String.valueOf(listKey.get("screen_id"));

					// 권한테이블 detail insert
					stmt = conn.createStatement();
					query = " insert into tbl_authority_detail_info ";
					query += " ( clm_authority_id, clm_screen_id, clm_reg_yn, clm_reg_user, clm_reg_datetime) ";
					query += " values ";
					query += " ( (select max(clm_authority_id) from tbl_authority_info ),'" + screen_id + "','','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
					
					System.out.println("> AuthorityInfoRegPopUpdate.q.0.2 : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();

				}

				// Main.jsp alwaysd
				/*
				stmt = conn.createStatement();
				query = " insert into tbl_authority_detail_info ";
				query += " ( clm_authority_id, clm_screen_id, clm_reg_yn, clm_reg_user, clm_reg_datetime) ";
				query += " values ";
				query += " ( (select max(clm_authority_id) from tbl_authority_info ),'Main.jsp','','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
				
				System.out.println("> AuthorityInfoRegPopUpdate.q.0.3 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();
				*/

            } else if(!authority_id.equals("")) { // 업데이트

				// 권한 테이블 업데이트 
                stmt = conn.createStatement();
                query = " update tbl_authority_info ";
                query += " set clm_authority_name = '"+ authority_name +"' , clm_comment = '"+ comment +"', clm_update_user = '" + user_id + "', clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ";
                query += " where clm_authority_id = '"+ authority_id +"' ";
                
                System.out.println("> AuthorityInfoRegPopUpdate.q.0.1 : " + query + "");
                ps = conn.prepareStatement(query);
                numRowsUpdated = ps.executeUpdate();
                stmt.close();

				// 기존 화면권한 삭제
				stmt = conn.createStatement();
                query = " delete from tbl_authority_detail_info ";
                query += " where clm_authority_id = '"+ authority_id +"' ";
                
                System.out.println("> AuthorityInfoRegPopUpdate.q.0.2 : " + query + "");
                ps = conn.prepareStatement(query);
                numRowsUpdated = ps.executeUpdate();
                stmt.close();


				JSONParser parser = new JSONParser();
				JSONArray obj = (JSONArray) parser.parse(screen_data);
	
				// 화면 권한 정보 insert
				for(int i=0; i<obj.size(); i++) {
					JSONObject listKey = (JSONObject) obj.get(i);

					String screen_id = String.valueOf(listKey.get("screen_id"));

					// 권한테이블 detail insert
					stmt = conn.createStatement();
					query = " insert into tbl_authority_detail_info ";
					query += " ( clm_authority_id, clm_screen_id, clm_reg_yn, clm_reg_user, clm_reg_datetime) ";
					query += " values ";
					query += " ( '"+ authority_id +"' ,'" + screen_id + "','','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
					
					System.out.println("> AuthorityInfoRegPopUpdate.q.0.3 : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();

				}

				/*
				stmt = conn.createStatement();
				query = " insert into tbl_authority_detail_info ";
				query += " ( clm_authority_id, clm_screen_id, clm_reg_yn, clm_reg_user, clm_reg_datetime) ";
				query += " values ";
				query += " ( '"+ authority_id +"' ,'Main.jsp','','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
				
				System.out.println("> AuthorityInfoRegPopUpdate.q.0.4 : " + query + "");
				ps = conn.prepareStatement(query);
				numRowsUpdated = ps.executeUpdate();
				stmt.close();
				*/

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
