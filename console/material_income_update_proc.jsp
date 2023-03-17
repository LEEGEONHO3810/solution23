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
		
		String client_order_seq = "";
		String client_order_id = "";
		JSONParser parser = new JSONParser();
		JSONArray obj = (JSONArray) parser.parse(dataArr);
		
			try {
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
				if(txt_process_type.equals("R")){

					if(material_order_id.equals("")){

						stmt = conn.createStatement();
						System.out.println("===============income_lot 업데이트========================");
						// income_lot 업데이트
						query = "";
						query += " insert into tbl_material_income_lot ";
						query += " (clm_company_key, clm_date, clm_seq) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + CurrentDate + "', '" + now_seq + "')";
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();
						stmt.close();
						
						stmt = conn.createStatement();
						
						System.out.println("===============income_info 입력========================");
						query = "";
						query += " insert into tbl_material_order_info ";
						query += " (clm_company_key, clm_material_order_id, clm_client_id, clm_order_date, clm_due_date, clm_delete_yn ";
						query += "	, clm_comment, clm_reg_user, clm_reg_datetime, clm_update_user, clm_update_datetime, clm_all_income_yn )";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + now_income_id + "', '"+ client_id +"','"+ order_date +"','"+ due_date +"','N', '" + material_comment + "' ";
						query += " , '" + user_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '', '', 'N')";
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();
						stmt.close();
						
						// 입고 상세정보 insert 
						System.out.println("=============== 입고 상세정보 시작 ========================");


						int lot_seq = 1;
						for(int i=0; i<obj.size(); i++) {

							JSONObject listKey = (JSONObject) obj.get(i);
			
							String material_id      = String.valueOf(listKey.get("material_id"));
							String order_count      = String.valueOf(listKey.get("order_count"));			
							String material_income_date	   = String.valueOf(listKey.get("material_income_date"));
		
							// detail_insert
							query = "";
							query += " insert into tbl_material_order_detail_info ";
							query += " (clm_company_key, clm_material_order_id, clm_material_order_seq, clm_material_id, clm_order_count, clm_income_date, clm_income_yn) ";
							query += " values ";
							query += " ('" + SessionCompanyKey + "', '" + now_income_id + "' , '" + Integer.toString(lot_seq) + "', '" + material_id + "', '" + order_count + "', '" + material_income_date + "', 'N' ) ";
							System.out.println("> material_income_update_proc.MaterialIncomeInfoDetail : " + query + "");
							ps = conn.prepareStatement(query);
							numRowsUpdated = ps.executeUpdate();
							stmt.close();
							lot_seq = lot_seq+1;


							System.out.println("===============끝========================");
						}
					}
				}else if (txt_process_type.equals("M")){
					stmt = conn.createStatement();
					query = " delete from tbl_material_order_detail_info ";
					query += " where clm_company_key = '" + SessionCompanyKey + "' and clm_material_order_id = '" + material_order_id + "' ";
					System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();

					System.out.println("===============update========================");
					stmt = conn.createStatement();
					query  = "";
					query += "update tbl_material_order_info set clm_client_id ='" + client_id + "', clm_order_date='" + order_date + "' ,clm_due_date='" + due_date + "' ";
					query += " , clm_comment='" + material_comment + "',clm_update_user = '"+user_id+"',  clm_update_datetime= to_char(now(), 'YYYYMMDDHH24MISSMS'::text)  where clm_material_order_id='" + material_order_id + "' ";
					System.out.println("> MaterialInfoRegUpdate.q.0.1 : " + query + "");
					ps = conn.prepareStatement(query);
					numRowsUpdated = ps.executeUpdate();
					stmt.close();

					int lot_seq = 1;

					for(int i=0; i<obj.size(); i++) {
						stmt = conn.createStatement();
						JSONObject listKey = (JSONObject) obj.get(i);
						String material_id      = String.valueOf(listKey.get("material_id"));
						String order_count      = String.valueOf(listKey.get("order_count"));			
						String material_income_date	   = String.valueOf(listKey.get("material_income_date"));

						order_count = order_count.replaceAll(",", "");
					

						// detail_insert
						query = "";
						query += " insert into tbl_material_order_detail_info ";
						query += " (clm_company_key, clm_material_order_id, clm_material_order_seq, clm_material_id, clm_order_count, clm_income_date, clm_income_yn) ";
						query += " values ";
						query += " ('" + SessionCompanyKey + "', '" + material_order_id + "' , '" + Integer.toString(lot_seq) + "', '" + material_id + "', '" + order_count + "', '" + material_income_date + "', 'N' ) ";
						
					
						System.out.println("> material_income_update_proc.MaterialIncomeInfoDetail : " + query + "");
						ps = conn.prepareStatement(query);
						numRowsUpdated = ps.executeUpdate();
						
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
