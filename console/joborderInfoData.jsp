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
	request.setCharacterEncoding("UTF-8");
	String job_order = (request.getParameter("job_order")==null)?"":request.getParameter("job_order");
	System.out.println("> job_order : " + job_order);
	System.out.println("???");
	String SessionCompanyKey = (session.getAttribute("clm_company_key").equals(""))?"0001":(String)session.getAttribute("clm_company_key");
	
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
			if(!job_order.equals("")) {
				stmt = conn.createStatement();
				query = "";
				query += " select x.clm_material_id , sum(cast(x.clm_material_use_count as numeric)) as useSum ";
				query += " , y.clm_material_name , y.clm_material_code ";
				query += " , coalesce(z1.clm_code_sub_name, '') as clm_material_main_type_name , coalesce(z2.clm_code_sub_name, '') as clm_material_sub_type_name, coalesce(z3.clm_code_sub_name, '') as clm_material_unit_name ";
				query += " from tbl_material_use_log x ";
				query += " left outer join tbl_material_info y on y.clm_material_id = x.clm_material_id and y.clm_company_key = '0001' ";
				query += " left outer join tbl_code_sub_info z1 on y.clm_company_key = z1.clm_company_key and y.clm_material_main_type = z1.clm_code_sub_id and z1.clm_code_id = '0001' ";
				query += " left outer join tbl_code_sub_info z2 on y.clm_company_key = z2.clm_company_key and y.clm_material_sub_type = z2.clm_code_sub_id and z2.clm_code_id = '0002' ";
				query += " left outer join tbl_code_sub_info z3 on y.clm_company_key = z3.clm_company_key and y.clm_material_unit = z3.clm_code_sub_id and z3.clm_code_id = '0003' ";
				query += " where x.clm_company_key = '" + SessionCompanyKey + "' ";
				query += " and x.clm_joborder_id = '" + job_order + "' ";
				query += " group by x.clm_material_id , y.clm_material_name , y.clm_material_code, z1.clm_code_sub_name , z2.clm_code_sub_name , z3.clm_code_sub_name ";
				System.out.println("> MaterialInfoRegPop.q.0 " + query);
				rs = stmt.executeQuery(query);
				String json = "";

				
				rowCnt = 0;
				while (rs.next()) {
					String clm_material_id			 				 = rs.getString("clm_material_id");
					String useSum									 = rs.getString("useSum");
					String clm_material_name						 = rs.getString("clm_material_name");
					String clm_material_main_type_name				 = rs.getString("clm_material_main_type_name");
					String clm_material_sub_type_name				 = rs.getString("clm_material_sub_type_name");
					String clm_material_unit_name					 = rs.getString("clm_material_unit_name");
					
			
					

					if (!job_order.equals("")) {
						jObject = new JSONObject();
						jObject.put("clm_material_id", clm_material_id);
						jObject.put("useSum", useSum);
						jObject.put("clm_material_name", clm_material_name);
						jObject.put("clm_material_main_type_name", clm_material_main_type_name);
						jObject.put("clm_material_sub_type_name", clm_material_sub_type_name);
						jObject.put("clm_material_unit_name", clm_material_unit_name);
						
						
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

