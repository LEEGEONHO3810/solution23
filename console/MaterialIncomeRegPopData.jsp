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
<%@ page import="java.text.DecimalFormat" %>
<%
	request.setCharacterEncoding("UTF-8");
	String material_income_id = (request.getParameter("material_income_id")==null)?"":request.getParameter("material_income_id");
	System.out.println("???");
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");

	DecimalFormat decFormat = new DecimalFormat("###,###");

	JSONObject jsonMain = new JSONObject();
	JSONArray jArray = new JSONArray();
	JSONObject jObject = null;
	
	String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/"+(String)session.getAttribute("mes_name");
	String usr = "postgres";
	String pwd = "postgres";
	String query = "";
	Class.forName("org.postgresql.Driver");


	

	int iRowCount = 0;
	int numRowsUpdated = 0;
	ResultSet rs = null;


	Connection conn = DriverManager.getConnection(url, usr, pwd);
	Statement stmt = null;
	PreparedStatement ps = null;

	try {
		int rowCnt = 0;

		

		try {
			if(!material_income_id.equals("")) {
				stmt = conn.createStatement();
				query = "";
				query += " select x.clm_material_order_id , y.clm_income_date , y.clm_order_count ,y.clm_material_order_seq ,y.clm_income_yn ";
				query += " , y.clm_material_id,c.clm_material_name,c.clm_material_code ";
				query += " ,coalesce(z1.clm_code_sub_name,'') as clm_material_main_type_name , coalesce(z2.clm_code_sub_name,'') as clm_material_sub_type_name, coalesce(z3.clm_code_sub_name, '') clm_material_unit_name ";
				query += " from tbl_material_order_info x ";
				query += " left outer join tbl_material_order_detail_info y on x.clm_material_order_id = y.clm_material_order_id ";
				query += " left outer join tbl_material_info c on y.clm_material_id = c.clm_material_id ";
				query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and c.clm_material_main_type = z1.clm_code_sub_id and z1.clm_code_id = '0001' ";
				query += " left outer join tbl_code_sub_info z2 on x.clm_company_key = z2.clm_company_key and c.clm_material_sub_type = z2.clm_code_sub_id and z2.clm_code_id = '0002' ";
				query += " left outer join tbl_code_sub_info z3 on x.clm_company_key = z3.clm_company_key and c.clm_material_unit = z3.clm_code_sub_id and z3.clm_code_id = '0003' ";
				query += " where x.clm_company_key = '" + SessionCompanyKey + "' and y.clm_material_order_id = '" + material_income_id + "' and c.clm_material_id  = y.clm_material_id and y.clm_del_yn = 'N' ";
				query += " order by y.clm_material_order_id ";
				System.out.println("> MaterialInfoRegPop.q.0 " + query);
				rs = stmt.executeQuery(query);
				String json = "";

				String int_clm_order_count = "";
				String float_clm_order_count = "";
				rowCnt = 0;
				
				while (rs.next()) {
					
								
					String clm_material_name			 = rs.getString("clm_material_name");
					String clm_income_date				 = rs.getString("clm_income_date");
					String clm_order_count				 = rs.getString("clm_order_count");
					String clm_material_order_seq		 = rs.getString("clm_material_order_seq");
					String clm_income_yn				 = rs.getString("clm_income_yn");
					String clm_material_id				 = rs.getString("clm_material_id");
					String clm_material_main_type_name	 = rs.getString("clm_material_main_type_name");
					String clm_material_code			 = rs.getString("clm_material_code");
					String clm_material_unit_name		 = rs.getString("clm_material_unit_name");
					String clm_material_sub_type_name	 = rs.getString("clm_material_sub_type_name");

					if(clm_order_count.contains(".")){
						String[] split_clm_order_count = clm_order_count.split("\\.");
						int_clm_order_count = split_clm_order_count[0];
						float_clm_order_count = split_clm_order_count[1];
					 }else{
						int_clm_order_count = clm_order_count;
					 }
					 System.out.println(int_clm_order_count);
					 clm_order_count = decFormat.format(Integer.parseInt(int_clm_order_count));


					 if(!float_clm_order_count.equals("")){

						clm_order_count = clm_order_count + "." + float_clm_order_count;

					 }


					if (!material_income_id.equals("")) {
						jObject = new JSONObject();
						jObject.put("clm_income_date", clm_income_date);
						jObject.put("clm_order_count", clm_order_count);
						jObject.put("clm_material_order_seq", clm_material_order_seq);
						jObject.put("clm_income_yn", clm_income_yn);
						jObject.put("clm_material_id", clm_material_id);
						jObject.put("clm_material_name", clm_material_name);
						jObject.put("clm_material_code", clm_material_code);
						jObject.put("clm_material_unit_name", clm_material_unit_name);
						jObject.put("clm_material_main_type_name", clm_material_main_type_name);
						jObject.put("clm_material_sub_type_name", clm_material_sub_type_name);
						jObject.put("material_income_id", material_income_id);
						
						
						jArray.add(rowCnt, jObject);
						rowCnt++;
					}
				}
			}
			else {
			}
			jsonMain.put("grid_data", jArray);
			out.print(jsonMain.toJSONString());
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();

		if(conn!=null) {
			conn.close();
		}
	}catch (Exception e) {
		System.out.println(e.toString());
	}finally {
		if(stmt != null) {
			stmt.close();
		}
		if(conn != null) {
			conn.close();
		}
	}
%>

