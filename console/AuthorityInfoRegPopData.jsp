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
	String authority_id = (request.getParameter("authority_id")==null)?"":request.getParameter("authority_id");
	System.out.println("> authority_id : " + authority_id);
	
	JSONObject jsonMain = new JSONObject();
	JSONArray jArray = new JSONArray();
	JSONObject jObject = null;
	
	String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/CHEONGJU_SOLUTION_2023";
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
			if(!authority_id.equals("")) {
				stmt = conn.createStatement();
				query = "";
				query += " select x.clm_screen_id , y.clm_screen_name , y.clm_screen_type ";
				query += "	from tbl_authority_detail_info x ";
				query += "	    left outer join tbl_screen_info y ";
				query += "	        on y.clm_screen_id = x.clm_screen_id ";
				query += "  where 1=1 ";
				query += "	    and x.clm_authority_id = '"+ authority_id +"' ";
				query += "	order by y.clm_screen_type asc";
				System.out.println("> AuthorityInfoRegPopData.q.0 : " + query);
				rs = stmt.executeQuery(query);
				String json = "";
				rowCnt = 0;
				while (rs.next()) {
					String clm_screen_type = rs.getString("clm_screen_type");
					String clm_screen_name = rs.getString("clm_screen_name");

					if (!clm_screen_type.equals("")) {
						jObject = new JSONObject();
						jObject.put("clm_screen_type", clm_screen_type);
						jObject.put("clm_screen_name", clm_screen_name);
						jArray.add(rowCnt, jObject);
						rowCnt++;
					}
				}
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

