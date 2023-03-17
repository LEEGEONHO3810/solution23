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

	String release_order_id = request.getParameter("release_order_id") == null? "" : request.getParameter("release_order_id");
	String client_id = request.getParameter("client_id") == null? "" : request.getParameter("client_id");
	String order_date = request.getParameter("order_date") == null? "" : request.getParameter("order_date");
	String comment = request.getParameter("comment") == null? "" : request.getParameter("comment");
	String due_date = request.getParameter("due_date") == null? "" : request.getParameter("due_date");

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
		
		String client_order_seq = "";
		String client_order_id = "";
		JSONParser parser = new JSONParser();
		JSONArray obj = (JSONArray) parser.parse(dataArr);
		
		try {
	
				
				if(release_order_id.equals("")){
					stmt = conn.createStatement();
								
					String now_income_id = "";
					String now_seq = "";
		
					query = "";
					query += " select LPAD((coalesce(max(cast(clm_seq as numeric)), 0)+1)::text, 3, '0') as clm_seq ";
					query += "  from tbl_product_release_lot ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_date = '" + CurrentDate + "' ";
					System.out.println("+ tbl_product_release_lot.tbl_product_release_lot : " + query);
		
					rs = stmt.executeQuery(query);
		
					while (rs.next()) {
						now_seq = rs.getString("clm_seq");
						now_income_id = "R" + CurrentDate + now_seq;
						System.out.println("+ now_seq : " + now_seq); // 001
						System.out.println("+ now_income_id : " + now_income_id); // R20210809001
					}

					stmt.close();

					stmt = conn.createStatement();
					System.out.println("===============release_lot 업데이트========================");
					// income_lot 업데이트
					query = "";
					query += " insert into tbl_product_release_lot ";
					query += " (clm_company_key, clm_date, clm_seq) ";
					query += " values ";
					query += " ('" + SessionCompanyKey + "', '" + CurrentDate + "', '" + now_seq + "')";
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();
					
					stmt = conn.createStatement();
					System.out.println("===============product_release_info 입력========================");
					query = "";
					query += " insert into tbl_product_release_info ";
					query += " (clm_company_key, clm_release_id, clm_client_id, clm_release_datetime, clm_comment, clm_reg_user ";
					query += "	, clm_reg_datetime, clm_update_user, clm_update_datetime,clm_all_release_yn)";
					query += " values ";
					query += " ('" + SessionCompanyKey + "', '" + now_income_id + "', '"+ client_id +"','"+ order_date +"','"+ comment +"','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ";
					query += " ,'', '', 'N')";
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();
					
					// 입고 상세정보 insert 
					System.out.println("=============== 출고 상세정보 시작 ========================");
					int lot_seq = 1;
					for(int i=0; i<obj.size(); i++) {

						JSONObject listKey = (JSONObject) obj.get(i);
		
						String product_id       = String.valueOf(listKey.get("product_id"));
						String order_count       = String.valueOf(listKey.get("order_count"));
	
						// detail_insert
						query = "";
						query += " insert into tbl_product_release_detail_info ";
						query += " (clm_company_key, clm_release_id, clm_release_seq, clm_product_id,clm_release_count, clm_joborder_id,clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + now_income_id + "' , '" + Integer.toString(lot_seq) + "', '" + product_id + "', '" + order_count + "', '', to_char(now(), 'YYYYMMDDHH24MISSMS'::text) ) ";
						
						stmt = conn.createStatement();
						System.out.println("> material_income_update_proc.MaterialIncomeInfoDetail : " + query + "");
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();


						// move_log insert
						query = "";
						query += " insert into tbl_stock_move_log ";
						query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + product_id + "', 'P', (select clm_stock_count from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " , (select cast(clm_stock_count as numeric) - "+order_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '"+order_count+"', '0', '0', '0', '0' ";
						query += " , '"+now_income_id+"-"+now_seq+" 출고', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();
						System.out.println("===============update tbl_material_stock========================");

						
						query = " update tbl_product_stock ";
						query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) - "+order_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_product_id = '" + product_id + "'";
						
						System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();
						stmt.close();
						
						lot_seq = lot_seq+1;


						System.out.println("===============끝========================");
					}
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
