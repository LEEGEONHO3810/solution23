<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, java.math.BigInteger" %>
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
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%
	try {
		request.setCharacterEncoding("UTF-8");

		File file ;
		int maxFileSize = 100 * 1024 * 1024;
		int maxMemSize = 100 * 1024 * 1024;
		String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Sever1/webapps/ROOT/SOLUTION/files";

		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;
		

		String notice_id = (request.getParameter("notice_id")==null)?"":request.getParameter("notice_id");
		String notice_title  = request.getParameter("notice_title") == null? "" : request.getParameter("notice_title");
		String notice_start_date = request.getParameter("notice_start_date") == null? "" : request.getParameter("notice_start_date");
		String notice_end_date = request.getParameter("notice_end_date") == null? "" : request.getParameter("notice_end_date");
		String notice_type_id = request.getParameter("notice_type_id") == null? "" : request.getParameter("notice_type_id");
		String notice_contents = request.getParameter("notice_contents") == null? "" : request.getParameter("notice_contents");
		String process_type = request.getParameter("process_type") == null? "" : request.getParameter("process_type");
		
		String user_id = session.getAttribute("user_id").toString();


		System.out.println("> notice_title           " + notice_title);
		System.out.println("> notice_start_date        " + notice_start_date);
		System.out.println("> notice_end_date             " + notice_end_date);
		System.out.println("> notice_type_id             " + notice_type_id);
		System.out.println("> notice_contents       " + notice_contents);
		System.out.println("> process_type " + process_type);

		String query  = "";
		String strCondition = "";

		try {
				if(process_type.equals("S")) {
					stmt = conn.createStatement();
					query  = "";
					query += "insert into tbl_notice_info(clm_notice_contents, clm_notice_start_date ,clm_notice_end_date, clm_notice_type, clm_reg_datetime,clm_reg_user_id,clm_notice_title,clm_company_key) ";
					query += " values('" + notice_contents + "', '" + notice_start_date + "','" + notice_end_date + "' , '" + notice_type_id + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '" + user_id + "' ,'" + notice_title + "','" + SessionCompanyKey + "');";
					System.out.println("> " + strCurrentReportId + ".insert_user_info " + query);
					stmt.execute(query);
				
				}else if(process_type.equals("U")){
					stmt = conn.createStatement();
						query  = "";
						query += "update tbl_notice_info set clm_notice_title ='" + notice_title + "', clm_company_key='" + SessionCompanyKey + "' ,clm_notice_start_date='" + notice_start_date + "' ";
						query += " , clm_notice_end_date='" + notice_end_date + "',clm_notice_type = '"+notice_type_id+"',  clm_notice_contents='" + notice_contents + "'  where clm_notice_id='" + notice_id + "' ";
						System.out.println("> " + strCurrentReportId + ".update_user_info " + query);
						stmt.execute(query);
				}
			
			}
			catch(Exception e) {
				System.out.println("> e " + e.toString());
		}
	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>