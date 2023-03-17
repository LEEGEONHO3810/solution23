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
		
		String _txt_user_name_           = request.getParameter("txt_user_name");
		String _txt_process_type_        = request.getParameter("txt_process_type");
		String _txt_user_id_             = request.getParameter("txt_user_id");
		String _txt_user_pw_             = request.getParameter("txt_user_pw");
		String _txt_department_id_       = request.getParameter("txt_department_id");
		String _txt_authority_id_ 		 = request.getParameter("txt_authority_id");
		String _ta_comment_              = request.getParameter("ta_comment");
		String _txt_authority_name_      = request.getParameter("txt_authority_name");
		String _txt_producer_yn_ = (request.getParameter("txt_producer_yn").equals(""))?"N":(String)request.getParameter("txt_producer_yn");
		String space = " ";
		

		System.out.println("> _txt_user_name_           " + _txt_user_name_);
		System.out.println("> _txt_process_type_        " + _txt_process_type_);
		System.out.println("> _txt_user_id_             " + _txt_user_id_);
		System.out.println("> _txt_user_pw_             " + _txt_user_pw_);
		System.out.println("> _txt_department_id_       " + _txt_department_id_);
		System.out.println("> _txt_authority_id_ " + _txt_authority_id_);
		System.out.println("> _ta_comment_              " + _ta_comment_);
		System.out.println("> _txt_producer_yn_              " + _txt_producer_yn_);
		System.out.println("> SessionCompanyKey              " + SessionCompanyKey);
		String query  = "";
		String strCondition = "";

		if(_txt_process_type_.equals("S")) {
			try {
				if(!_txt_user_id_.equals("")) {
					stmt = conn.createStatement();
					if(!_txt_user_id_.equals("")) {
						strCondition += "and x.clm_user_id='" + _txt_user_id_ + "' ";
					}
					query  = "";
					query += "select ";
					query += "x.* ";
					query += "from ";
					query += "	tbl_user_info x ";
					query += "where 1=1 " + strCondition + " ";
					query += "order by x.clm_user_id desc limit 1;";
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
						query += "update tbl_user_info set clm_user_name='" + _txt_user_name_ + "', clm_company_key='" + SessionCompanyKey + "' ,clm_user_pw='" + _txt_user_pw_ + "' , clm_comment='" + _ta_comment_ + "',clm_update_datetime = to_char(now(), 'YYYYMMDDHH24MISSMS'::text),clm_update_user ='"+ user_id+"' , clm_department_id='" + _txt_department_id_ + "' , clm_user_authority='" + _txt_authority_id_ + "',clm_producer_yn ='" + _txt_producer_yn_ + "' where clm_user_id='" + _txt_user_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".update_user_info " + query);
						stmt.execute(query);
					}
					else {
						stmt = conn.createStatement();
						query  = "";
						query += "insert into tbl_user_info(clm_user_id, clm_user_name, clm_user_pw ,clm_company_key, clm_comment, clm_department_id, clm_user_authority,clm_producer_yn,clm_reg_user,clm_reg_datetime,clm_update_user,clm_update_datetime) values('" + _txt_user_id_ + "', '" + _txt_user_name_ + "', '" + _txt_user_pw_ + "','" + SessionCompanyKey + "' , '" + _ta_comment_ + "', '" + _txt_department_id_ + "', '" + _txt_authority_id_ + "' ,'" + _txt_producer_yn_ + "','" + space + "', to_char(now(), 'YYYYMMDDHH24MISSMS'::text), '" + space + "' ,to_char(now(), 'YYYYMMDDHH24MISSMS'::text));";
						System.out.println("> " + strCurrentReportId + ".insert_user_info " + query);
						stmt.execute(query);
					}
				}
				else if(_txt_user_id_.equals("")) {
					stmt = conn.createStatement();
					query  = "";
					query += "insert into tbl_user_info(clm_user_id, clm_user_name, clm_comment, clm_department_id, clm_user_authority,clm_reg_user,clm_reg_datetime) values('" + _txt_user_id_ + "', '" + _txt_user_name_ + "', '" + _ta_comment_ + "', '" + _txt_department_id_ + "', '" + _txt_authority_id_ + "','"+user_id+"', to_char(now(), 'YYYYMMDDHH24MISSMS'::text));";
					System.out.println("> " + strCurrentReportId + ".insert_user_info " + query);
					stmt.execute(query);

					strCondition = "";
					if(!_txt_user_id_.equals("")) {
						strCondition += "and x.clm_user_id='" + _txt_user_id_ + "' ";
					}
					query  = "";
					query += "select ";
					query += "x.* ";
					query += "from ";
					query += "	tbl_user_info x ";
					query += "where 1=1 " + strCondition + " ";
					query += "order by x.clm_user_id desc limit 1;";
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
						_txt_user_id_ = rs.getString("clm_user_id");
						iRowCnt++;
					}
				}

				JSONObject jsonMain = new JSONObject();
				JSONArray jArray = new JSONArray();
				JSONObject jObject = null;

				jObject = new JSONObject();
				jObject.put("user_id", _txt_user_id_);
				jArray.add(0, jObject);
				jsonMain.put("user_data", jArray);

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