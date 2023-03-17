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
	String user_id = session.getAttribute("user_id").toString();

	String material_income_id = request.getParameter("material_income_id") == null? "" : request.getParameter("material_income_id");
	String material_id = request.getParameter("material_id") == null? "" : request.getParameter("material_id");
	String incomeYn  = request.getParameter("incomeYn") == null? "" : request.getParameter("incomeYn");
	String clm_material_order_seq  = request.getParameter("clm_material_order_seq") == null? "" : request.getParameter("clm_material_order_seq");
	String clm_income_yn   = request.getParameter("clm_income_yn") == null? "" : request.getParameter("clm_income_yn");
	String clm_order_count   = request.getParameter("clm_order_count") == null? "" : request.getParameter("clm_order_count");


	System.out.println("> material_income_id: " + material_income_id);
	System.out.println("> material_id: " + material_id);
	System.out.println("> incomeYn : " + incomeYn);
	System.out.println("> clm_material_order_seq : " + clm_material_order_seq);
	System.out.println("> clm_order_count : " + clm_order_count);


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
			
					//detail_update

					stmt = conn.createStatement();
					query = "";
					query += " update tbl_material_order_detail_info  ";
					query += "   set clm_income_yn = 'Y' ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_income_id + "' and clm_material_order_seq = '"+clm_material_order_seq+"'  ";
					System.out.println("> material_income_update_proc.MaterialIncomeInfoDetail : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();


					stmt = conn.createStatement();
					query = "";
					query += " update tbl_material_order_info ";
					query += " SET clm_all_income_yn = 'Y' ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_income_id + "' and not exists ( "; 
					query += " 	select 1 FROM tbl_material_order_detail_info ";
					query += " 	where clm_company_key = '" + SessionCompanyKey + "' AND clm_material_order_id = '" + material_income_id + "' AND clm_income_yn = 'N') ";
					System.out.println("> tbl_material_order_info.tbl_material_order_info : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();


					stmt = conn.createStatement();
					//move_log insert
					query = "";
					query += " insert into tbl_stock_move_log ";
					query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
					query += " values ";
					query += " ('" + SessionCompanyKey + "', '" + material_id + "', 'M', (select clm_stock_count from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
					query += " , (select cast(clm_stock_count as numeric) + "+clm_order_count+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '"+clm_order_count+"', '0', '0', '0', '0' ";
					query += " , '"+material_income_id+"-"+clm_material_order_seq+" 입고', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
					System.out.println("> material_income_update_proc.MaterialIncomeInfoLot : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();


					stmt = conn.createStatement();
					System.out.println("===============update tbl_material_stock========================");
					query = "";
					query += " update tbl_material_stock ";
					query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) + "+clm_order_count+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_id = '" + material_id + "' ";

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
