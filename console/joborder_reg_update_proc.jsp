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

	String job_order_id  = request.getParameter("job_order_id ") == null? "" : request.getParameter("job_order_id ");
	String product_id = request.getParameter("product_id") == null? "" : request.getParameter("product_id");
	String planned_datetime = request.getParameter("order_date") == null? "" : request.getParameter("order_date");
	String comment = request.getParameter("comment") == null? "" : request.getParameter("comment");
	String start_datetime = request.getParameter("job_startTime") == null? "" : request.getParameter("job_startTime");
	String end_datetime = request.getParameter("job_endTime") == null? "" : request.getParameter("job_endTime");
	String product_count = request.getParameter("order_count") == null? "" : request.getParameter("order_count");
	String supply_count = request.getParameter("supply_count") == null? "" : request.getParameter("supply_count");

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

		Connection conn2 = DriverManager.getConnection(url, usr, pwd);
		Statement stmt2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;

		Connection conn3 = DriverManager.getConnection(url, usr, pwd);
		Statement stmt3 = null;
		PreparedStatement ps3 = null;
		ResultSet rs3 = null;
		
		JSONParser parser = new JSONParser();
		JSONArray obj = (JSONArray) parser.parse(dataArr);
		
		if(job_order_id.equals("")){
			stmt = conn.createStatement();
						
			String now_income_id = "";
			String now_seq = "";
			String jobOrder_id = "";

			query = "";
			query += " select LPAD((coalesce(max(cast(clm_seq as numeric)), 0)+1)::text, 3, '0') as clm_seq ";
			query += "  from tbl_joborder_lot ";
			query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_date = '" + CurrentDate + "' ";
			System.out.println("+ MaterialOrderRegPopUpdate.MaterialOrderLot : " + query);
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				now_seq = rs.getString("clm_seq");
				jobOrder_id = "JOB" + CurrentDate + now_seq;
				System.out.println("+ now_seq : " + now_seq); // 001
				System.out.println("+ jobOrder_id : " + jobOrder_id); // order20210809001
			}
			stmt.close();

			stmt = conn.createStatement();
			System.out.println("===============product_stock_lot 업데이트========================");
			query = "";
			query += " update tbl_product_stock ";
			query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) + "+supply_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
			query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_product_id = '" + product_id + "'";
			ps = conn.prepareStatement(query);
			System.out.println("+ tbl_product_stock : " + query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();

			stmt = conn.createStatement();
			System.out.println("===============jobOrder_lot 업데이트========================");
			// income_lot 업데이트
			query = "";
			query += " insert into tbl_joborder_lot ";
			query += " (clm_company_key, clm_date, clm_seq) ";
			query += " values ";
			query += " ('" + SessionCompanyKey + "', '" + CurrentDate + "', '" + now_seq + "')";
			ps = conn.prepareStatement(query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();
			
			stmt = conn.createStatement();
			System.out.println("===============jobOder_info 입력========================");
			query = "";
			query += " insert into tbl_joborder_info ";
			query += " (clm_company_key, clm_joborder_id, clm_product_id, clm_planned_datetime, clm_start_datetime, clm_end_datetime ";
			query += "	, clm_product_count, clm_machine_id , clm_comment, clm_reg_user, clm_reg_datetime, clm_update_user, clm_update_datetime )";
			query += " values ";
			query += " ('" + SessionCompanyKey + "', '" + jobOrder_id + "', '"+ product_id +"','"+ planned_datetime +"','"+ start_datetime +"','"+ end_datetime +"', '" + product_count + "','0' ";
			query += " , '" + comment + "','" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '', '')";
			ps = conn.prepareStatement(query);
			numRowsUpdated = ps.executeUpdate();
			stmt.close();


			// 작업지시 상세정보 insert 
			System.out.println("=============== 작업지시 상세정보 시작 ========================");
			int lot_seq = 1;

			for(int i=0; i<obj.size(); i++) {

				JSONObject listKey = (JSONObject) obj.get(i);

				String material_id       = String.valueOf(listKey.get("material_id"));
				String use_count       = String.valueOf(listKey.get("use_count"));
				// 자재사용내역 insert
			

					
				String totalUseCnt = use_count;
				int intUseCnt = Integer.parseInt(totalUseCnt);

				while (rs2.next()) {

					String material_order_id = rs2.getString("clm_material_order_id");	// 입고번호
					String material_order_seq = rs2.getString("clm_material_order_seq"); // 입고 seq
					String remainCnt = rs2.getString("remainCnt"); 						// 남은재고
					int intRemainCnt = Integer.parseInt(remainCnt);

					if(intUseCnt > intRemainCnt){ // 이번 입고번호로는 부족할떄

						// tbl_material_use_log 
						stmt3 = conn3.createStatement();

						query = "";
						query += " insert into tbl_material_use_log ";
						query += " (clm_company_key, clm_joborder_id, clm_material_id, clm_material_order_id, clm_material_order_seq, clm_material_use_count, clm_reg_user,clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + jobOrder_id + "' , '" + material_id + "', '" + material_order_id + "', '" + material_order_seq + "', '" + intRemainCnt + "', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
						System.out.println("> material_income_update_proc.tbl_material_use_log : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						// tbl_stock_move_log

						stmt3 = conn3.createStatement();

						query = "";
						query += " insert into tbl_stock_move_log ";
						query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + material_id + "', 'M', (select clm_stock_count from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " , (select cast(clm_stock_count as numeric) - "+intRemainCnt+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '0', '0', '"+intRemainCnt+"', '0', '0' ";
						query += " , '"+jobOrder_id+" 자재 사용', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
						System.out.println("> material_income_update_proc.tbl_stock_move_log : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						// tbl_material_stock

						stmt3 = conn3.createStatement();
						
						query = "";
						query = " update tbl_material_stock ";
						query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) - "+intRemainCnt+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_id = '" + material_id + "'";
						System.out.println("> material_income_update_proc.tbl_material_stock : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						intUseCnt = intUseCnt-intRemainCnt;				

					} else { // 이번 입고번호로 충분할때

						// tbl_material_use_log 
						stmt3 = conn3.createStatement();

						query = "";
						query += " insert into tbl_material_use_log ";
						query += " (clm_company_key, clm_joborder_id, clm_material_id, clm_material_order_id, clm_material_order_seq, clm_material_use_count, clm_reg_user,clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + jobOrder_id + "' , '" + material_id + "', '" + material_order_id + "', '" + material_order_seq + "', '" + intUseCnt + "', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text)) ";
						System.out.println("> material_income_update_proc.tbl_material_use_log : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						// tbl_stock_move_log

						stmt3 = conn3.createStatement();

						query = "";
						query += " insert into tbl_stock_move_log ";
						query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + material_id + "', 'M', (select clm_stock_count from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " , (select cast(clm_stock_count as numeric) - "+intUseCnt+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '0', '0', '"+intUseCnt+"', '0', '0' ";
						query += " , '"+jobOrder_id+" 자재 사용', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
						System.out.println("> material_income_update_proc.tbl_stock_move_log : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						// tbl_material_stock

						stmt3 = conn3.createStatement();
						
						query = "";
						query = " update tbl_material_stock ";
						query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) - "+intUseCnt+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_id = '" + material_id + "'";
						System.out.println("> material_income_update_proc.tbl_material_stock : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						intUseCnt = 0;

					}

					if(intUseCnt==0){
						System.out.println("=============== 자재재고 정보 insert 끝 ========================");
						break;
					}

				}

				stmt2.close();

			}

			stmt.close();
			
			System.out.println("===============끝========================");

			conn.close();

			if(conn2 != null){
				conn2.close();
			}
	
			if(conn3 != null){
				conn3.close();
			}
		}
	} catch (Exception e2) {
		System.out.println("> e2 : " + e2);
		e2.printStackTrace();
	}
			
	
%>
