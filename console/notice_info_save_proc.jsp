<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
		String notice_id = (request.getParameter("_notice_id_")==null)?"":request.getParameter("_notice_id_");

		request.setCharacterEncoding("UTF-8");

		File file ;
		int maxFileSize = 100 * 1024 * 1024;
		int maxMemSize = 100 * 1024 * 1024;
		String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Sever1/webapps/ROOT/ESTIMATION/GAGA/files";
		
		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;
		
		String _txt_process_type_						 = request.getParameter("txt_process_type");
		String _txt_notice_id_							 = (request.getParameter("txt_notice_id")==null)?"":request.getParameter("txt_notice_id");
		String _txt_notice_title_						 = request.getParameter("txt_notice_title");
		String _txt_notice_type_						 = request.getParameter("txt_notice_type");
		String _txt_notice_start_date_					 = request.getParameter("txt_notice_start_date");
		String _txt_notice_end_date_					 = request.getParameter("txt_notice_end_date");
		String _txt_notice_type_id_						 = request.getParameter("txt_notice_type_id");
		String _ta_notice_contents_						 = request.getParameter("ta_notice_contents");

		System.out.println("> _txt_process_type_						 " + _txt_process_type_);
		System.out.println("> _txt_notice_id_							 " + _txt_notice_id_);
		System.out.println("> _txt_notice_type_							 " + _txt_notice_type_);
		System.out.println("> _txt_notice_type_id_						 " + _txt_notice_type_id_);
		System.out.println("> _txt_notice_title_						 " + _txt_notice_title_);
		System.out.println("> _txt_notice_start_date_					 " + _txt_notice_start_date_);
		System.out.println("> _txt_notice_end_date_						 " + _txt_notice_end_date_);
		System.out.println("> _ta_notice_contents_						 " + _ta_notice_contents_);

		String query  = "";

		if(_txt_process_type_.equals("S")) {
			try {
				if(!_txt_notice_id_.equals("")) {
					stmt = conn.createStatement();
					String strCondition = "";
					if(!_txt_notice_id_.equals("")) {
						strCondition += "and x.clm_notice_id='" + _txt_notice_id_ + "' ";
					}
					query  = "";
					query += "select ";
					query += "x.* ";
					query += "from ";
					query += "	tbl_notice_info x ";
					query += "where 1=1 " + strCondition + " ";
					query += "order by x.clm_notice_id desc;";
					System.out.println("> " + strCurrentReportId + ".row_cnt " + query);
					rs = stmt.executeQuery(query);

					String reqDateStr = "";
					java.util.Date curDate = null;
					SimpleDateFormat dateFormat = null;
					java.util.Date reqDate = null;
					long reqDateTime = 0;
					long curDateTime = 0;
					long minute = 0;
					String duration_minute = "";

					int iRowCnt = 0;
					while (rs.next()) {
						iRowCnt++;
					}

					query = "";
					if(iRowCnt>0) {
						stmt = conn.createStatement();
						query  = "";
						query += "update tbl_notice_info set clm_notice_title='" + _txt_notice_title_ + "', clm_notice_start_date='" + _txt_notice_start_date_ + "', clm_notice_end_date='" + _txt_notice_end_date_ + "', clm_notice_contents='" + _ta_notice_contents_ + "', clm_notice_type='" + _txt_notice_type_id_ + "' where clm_notice_id='" + _txt_notice_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".update_notice_info " + query);
						stmt.execute(query);
					}else {
						stmt = conn.createStatement();
						query  = "";
						query += "insert into tbl_notice_info(clm_notice_title, clm_notice_start_date, clm_notice_end_date, clm_notice_contents, clm_notice_type) values ('" + _txt_notice_title_ + "', '" + _txt_notice_start_date_ + "', '" + _txt_notice_end_date_ + "', '" + _ta_notice_contents_ + "', '" + _txt_notice_type_id_ + "');";
						System.out.println("> " + strCurrentReportId + ".insert_notice_info " + query);
						stmt.execute(query);
					}
				}else if(_txt_notice_id_.equals("")) {
					stmt = conn.createStatement();
					query  = "";
					query += "insert into tbl_notice_info(clm_notice_title, clm_notice_start_date, clm_notice_end_date, clm_notice_contents, clm_notice_type) values ('" + _txt_notice_title_ + "', '" + _txt_notice_start_date_ + "', '" + _txt_notice_end_date_ + "', '" + _ta_notice_contents_ + "', '" + _txt_notice_type_id_ + "');";
					System.out.println("> " + strCurrentReportId + ".insert_notice_info " + query);
					stmt.execute(query);

					query  = "";
					query += "select x.* ";
					query += "from tbl_notice_info x ";
					query += "where 1=1 ";
					query += "order by x.clm_notice_id desc limit 1;";
					System.out.println("> " + strCurrentReportId + ".row_cnt " + query);
					rs = stmt.executeQuery(query);

					String reqDateStr = "";
					java.util.Date curDate = null;
					SimpleDateFormat dateFormat = null;
					java.util.Date reqDate = null;
					long reqDateTime = 0;
					long curDateTime = 0;
					long minute = 0;
					String duration_minute = "";

					int iRowCnt = 0;
					while (rs.next()) {
						_txt_notice_id_ = rs.getString("clm_notice_id");
						iRowCnt++;
					}
				}

				JSONObject jsonMain = new JSONObject();
				JSONArray jArray = new JSONArray();
				JSONObject jObject = null;

				jObject = new JSONObject();
				jObject.put("notice_id", _txt_notice_id_);
				jArray.add(0, jObject);
				jsonMain.put("notice_data", jArray);

				response.setContentType("application/x-json; charset=UTF-8");
				response.getWriter().print(jsonMain);
				System.out.println(jsonMain.toJSONString());
			}
			catch(Exception e) {
				System.out.println("> e " + e.toString());
			}
		}
	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>