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


	String modal_jodOrder_id  = request.getParameter("txt_modal_jodOrder_id") == null? "" : request.getParameter("txt_modal_jodOrder_id");
	String modal_start_time = request.getParameter("txt_modal_start_time") == null? "" : request.getParameter("txt_modal_start_time");
	String modal_end_time = request.getParameter("txt_modal_end_time") == null? "" : request.getParameter("txt_modal_end_time");
	String modal_plus_count = request.getParameter("txt_modal_plus_count") == null? "" : request.getParameter("txt_modal_plus_count");
	String modal_product_id = request.getParameter("txt_modal_product_id") == null? "" : request.getParameter("txt_modal_product_id");
	String modal_comment = request.getParameter("txt_modal_comment") == null? "" : request.getParameter("txt_modal_comment");

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
		
			String now_income_id = "";
			String now_seq = "";
			String jobOrder_id = "";

			// 작업지시 상세정보 insert 
			stmt = conn.createStatement();
			System.out.println("===============modal에서 produce_info 입력========================");
			query = "";
			query += " insert into tbl_product_produce_info ";
			query += " (clm_company_key, clm_joborder_id, clm_user_id, clm_product_id  ";
			query += "	, clm_reg_user, clm_reg_datetime, clm_product_count ,clm_comment,clm_update_user,clm_update_datetime)";
			query += " values ";
			query += " ('" + SessionCompanyKey + "', '" + modal_jodOrder_id + "','"+ user_id +"','"+ modal_product_id +"' ";
			query += "  ,'"+ user_id +"', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '"+ modal_plus_count +"','"+ modal_comment +"', '"+ user_id +"' , to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
			ps = conn.prepareStatement(query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();

			stmt = conn.createStatement();
			System.out.println("===============modal에서 joborder 업데이트========================");
			query = "";
			query += " update tbl_joborder_info ";
			query += "   set clm_start_datetime = '" + modal_start_time + "' , clm_end_datetime = '" + modal_end_time + "' ";
			query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_joborder_id = '" + modal_jodOrder_id + "'";
			ps = conn.prepareStatement(query);
			System.out.println("+ tbl_product_stock : " + query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();

			stmt = conn.createStatement();

			query = "";
			query += " insert into tbl_stock_move_log ";
			query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
			query += " values ";
			query += " ('" + SessionCompanyKey + "', '" + modal_product_id + "', 'P', (select clm_stock_count from tbl_product_stock where clm_product_id = '" + modal_product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
			query += " , (select cast(clm_stock_count as numeric) + "+modal_plus_count+" from tbl_product_stock where clm_product_id = '" + modal_product_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '0', '0', '"+ modal_plus_count+ "', '0', '0' ";
			query += " , '"+modal_jodOrder_id+" 생산', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
			System.out.println("> material_income_update_proc.tbl_stock_move_log : " + query + "");
			ps = conn.prepareStatement(query);
			numRowsUpdated = ps.executeUpdate();

			stmt.close();

			System.out.println("=============== 작업지시 상세정보 시작 ========================");
			System.out.println("===============끝========================");





			stmt = conn.createStatement();
			System.out.println("===============product_stock 업데이트========================");
			query = "";
			query += " update tbl_product_stock ";
			query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) + "+modal_plus_count+" from tbl_product_stock where clm_product_id = '" + modal_product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
			query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_product_id = '" + modal_product_id + "' ";
			ps = conn.prepareStatement(query);
			System.out.println("+ tbl_product_stock : " + query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();
			conn.close();

		} catch (Exception e2) {
			System.out.println("> e2 : " + e2);
			e2.printStackTrace();
		}
				
	
%>
