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
	String machine_id = request.getParameter("machine_id") == null? "" : request.getParameter("machine_id");
	String client_id = request.getParameter("client_id") == null? "" : request.getParameter("client_id");

	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");
	String user_id = session.getAttribute("user_id").toString();	
	String dataArr = request.getParameter("dataArr") == null? "" : request.getParameter("dataArr");

	System.out.println("job_order_id : " + job_order_id);
	System.out.println("product_id : " + product_id);
	System.out.println("planned_datetime : " + planned_datetime);
	System.out.println("comment : " + comment);
	System.out.println("start_datetime : " + start_datetime);
	System.out.println("end_datetime : " + end_datetime);
	System.out.println("product_count : " + product_count);
	System.out.println("machine_id : " + machine_id);
	System.out.println("client_id : " + client_id);
	


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
			System.out.println("===============income_lot 업데이트========================");
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

			// 작업지시 상세정보 insert 
			System.out.println("=============== 작업지시 상세정보 시작 ========================");
			int lot_seq = 1;

			for(int i=0; i<obj.size(); i++) {

				JSONObject listKey = (JSONObject) obj.get(i);

						String product_id       = String.valueOf(listKey.get("product_id"));
						String order_count       = String.valueOf(listKey.get("order_count"));
				// 자재사용내역 insert
				
				stmt2 = conn2.createStatement();
				query = "";
				query += " select *, (t.sum - t.useCnt) as remainCnt from ( ";
				query += "   select sum(cast(x.clm_product_count as numeric)), x.clm_joborder_id ,coalesce (y.useCnt, 0) as useCnt " ;
				query += " 		from tbl_product_produce_info x  ";
				query += "   		left outer join (  ";
				query += " 				select clm_release_id, clm_release_seq , sum(cast(clm_release_count as numeric)) as useCnt, clm_joborder_id  ";
				query += "   			from tbl_product_release_detail_info   ";
				query += " 				where clm_product_id = '0000035'  ";
				query += "   			and clm_company_key = '0001'  ";
				query += " 				group by clm_release_seq, clm_joborder_id,clm_release_id ";
				query += "  		) y on x.clm_joborder_id = y.clm_joborder_id ";
				query += " 		where x.clm_product_id = '0000035' ";
				query += " 		and x.clm_company_key = '0001' ";
				query += "  	group by x.clm_joborder_id, y.useCnt  ";
				query += "  	order by x.clm_joborder_id asc ) t  ";
				query += "  	where (t.sum - t.useCnt) != 0; ";
				rs2 = stmt2.executeQuery(query);
				System.out.println("+ tbl_product_order_detail_info : " + query);

					
				String totalUseCnt = use_count;
				int intUseCnt = Integer.parseInt(totalUseCnt);

				while (rs2.next()) {

					String clm_joborder_id = rs2.getString("clm_joborder_id");	// 입고번호
					String material_order_seq = rs2.getString("clm_material_order_seq"); // 입고 seq
					String remainCnt = rs2.getString("remainCnt"); 						// 남은재고
					int intRemainCnt = Integer.parseInt(remainCnt);

					if(intUseCnt > intRemainCnt){ // 이번 입고번호로는 부족할떄

						// tbl_stock_move_log

						stmt3 = conn3.createStatement();

						query += " insert into tbl_stock_move_log ";
						query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + product_id + "', 'P', (select clm_stock_count from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " , (select cast(clm_stock_count as numeric) - "+order_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '"+order_count+"', '0', '0', '0', '0' ";
						query += " , '"+now_income_id+"-"+now_seq+" 출고', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
						System.out.println("> material_income_update_proc.tbl_stock_move_log : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						// tbl_material_stock

						stmt3 = conn3.createStatement();
						
						query = " update tbl_product_stock ";
						query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) - "+order_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_product_id = '" + product_id + "'";
						System.out.println("> material_income_update_proc.tbl_material_stock : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						intUseCnt = intUseCnt-intRemainCnt;				

					} else { // 이번 입고번호로 충분할때

						// tbl_stock_move_log

						stmt3 = conn3.createStatement();

						query += " insert into tbl_stock_move_log ";
						query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + product_id + "', 'P', (select clm_stock_count from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " , (select cast(clm_stock_count as numeric) - "+order_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '"+order_count+"', '0', '0', '0', '0' ";
						query += " , '"+now_income_id+"-"+now_seq+" 출고', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
						System.out.println("> material_income_update_proc.tbl_stock_move_log : " + query + "");
						ps3 = conn3.prepareStatement(query);
						numRowsUpdated = ps3.executeUpdate();

						stmt3.close();

						// tbl_material_stock

						stmt3 = conn3.createStatement();
						
						query = " update tbl_product_stock ";
						query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) - "+order_count+" from tbl_product_stock where clm_product_id = '" + product_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_product_id = '" + product_id + "'";
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
