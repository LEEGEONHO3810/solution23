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
<%


	String material_comment = request.getParameter("comment") == null? "" : request.getParameter("comment");
	String client_id = request.getParameter("client_id") == null? "" : request.getParameter("client_id");
	String due_date = request.getParameter("due_date") == null? "" : request.getParameter("due_date");
	String order_date = request.getParameter("order_date") == null? "" : request.getParameter("order_date");

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
			
			for(int i=0; i<obj.size(); i++) {
				JSONObject listKey = (JSONObject) obj.get(i);
				String material_order_id  = String.valueOf(listKey.get("material_order_id"));
				
				if(dataArr != null){
					System.out.println("===============select tbl_material_income_lot 입력========================");
					stmt = conn.createStatement();
					String now_income_id = "";
					String now_seq = "";
		
					query = "";
					query += " select LPAD((coalesce(max(cast(clm_seq as numeric)), 0)+1)::text, 3, '0') as clm_seq ";
					query += "  from tbl_material_income_lot ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_date = '" + CurrentDate + "' ";
					System.out.println("+ MaterialOrderRegPopUpdate.MaterialOrderLot : " + query);
		
					rs = stmt.executeQuery(query);
		
					while (rs.next()) {
						
						now_seq = rs.getString("clm_seq");
						now_income_id = "MI" + CurrentDate + now_seq;
						System.out.println("+ now_seq : " + now_seq); // 001
						System.out.println("+ now_income_id : " + now_income_id); // MI20210809001
					}
					stmt.close();
					

					stmt = conn.createStatement();
					System.out.println("===============update tbl_material_order_info 입력========================");
					query = " update tbl_material_order_info ";
					query += "  set clm_update_user = '"+ user_id +"', clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text), clm_all_income_yn = 'Y' ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_order_id + "' ";
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();
					
					stmt = conn.createStatement();
					query = "";
					query += " select clm_material_order_seq, clm_material_id, clm_order_count ";
					query += "   from tbl_material_order_detail_info";
					query += "  where clm_material_order_id = '"+material_order_id+"' and clm_company_key = '"+SessionCompanyKey+"' ";
					query += "  order by cast(clm_material_order_seq as integer) ";
					
					rs = stmt.executeQuery(query);

					while (rs.next()) {
						String material_order_seq = rs.getString("clm_material_order_seq");
						String material_id = rs.getString("clm_material_id");
						String order_count = rs.getString("clm_order_count");
						// 입고 상세정보 insert 
						System.out.println("=============== 입고 상세정보 시작 ========================");
						
						stmt = conn.createStatement();
						//detail_update
						query = "";
						query = " update tbl_material_order_detail_info  ";
						query += "   set clm_income_yn = 'Y' ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_order_id + "' and clm_material_order_seq = '"+material_order_seq+"'  ";
						System.out.println("> material_income_update_proc.MaterialIncomeInfoDetail : " + query + "");
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();


						//move_log insert
						query = "";
						query += " insert into tbl_stock_move_log ";
						query += " (clm_company_key, clm_material_id, clm_material_type, clm_before_count, clm_after_count, clm_income_move, clm_release_move, clm_use_move, clm_product_move, clm_etc_move, clm_comment, clm_reg_user, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + material_id + "', 'M', (select clm_stock_count from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " , (select cast(clm_stock_count as numeric) + "+order_count+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "'), '"+order_count+"', '0', '0', '0', '0' ";
						query += " , '"+material_order_id+"-"+material_order_seq+" 입고', '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text))";
						System.out.println("> material_income_update_proc.MaterialIncomeInfoLot : " + query + "");
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();

						
						System.out.println("===============update tbl_material_stock========================");
						query = " update tbl_material_stock ";
						query += "   set clm_stock_count = (select cast(clm_stock_count as numeric) + "+order_count+" from tbl_material_stock where clm_material_id = '" + material_id + "' and clm_company_key = '" + SessionCompanyKey + "') ";
						query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_id = '" + material_id + "'";
						
						System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();
						stmt.close();
					}
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
