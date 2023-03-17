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
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/session_info.jsp" %>
<%
	try {
		request.setCharacterEncoding("UTF-8");

		File file ;
		int maxFileSize = 100 * 1024 * 1024;
		int maxMemSize = 100 * 1024 * 1024;

		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;

		String _txt_code_type_       				 = (request.getParameter("txt_code_type")==null)?"":request.getParameter("txt_code_type");
		String _txt_process_type_    				 = (request.getParameter("txt_process_type")==null)?"":request.getParameter("txt_process_type");
		String _txt_code_id_         				 = (request.getParameter("txt_code_id")==null)?"":request.getParameter("txt_code_id");
		String _txt_code_sub_id_     				 = (request.getParameter("txt_code_sub_id")==null)?"":request.getParameter("txt_code_sub_id");
		String _txt_code_name_       				 = (request.getParameter("txt_code_name")==null)?"":request.getParameter("txt_code_name");
		String _txt_code_sub_name_   				 = (request.getParameter("txt_code_sub_name")==null)?"":request.getParameter("txt_code_sub_name");
		String _txt_code_unit_       				 = (request.getParameter("txt_code_unit")==null)?"":request.getParameter("txt_code_unit");
		String _txt_code_unit_type_  				 = (request.getParameter("txt_code_unit_type")==null)?"":request.getParameter("txt_code_unit_type");
		String _txt_code_price_      				 = (request.getParameter("txt_code_price")==null)?"":request.getParameter("txt_code_price");
		String _ta_comment_          				 = (request.getParameter("ta_comment")==null)?"":request.getParameter("ta_comment");
		String _txt_code_sub_value_  				 = (request.getParameter("txt_code_value")==null)?"":request.getParameter("txt_code_value");
		String _txt_code_total_      				 = "";

		System.out.println("> _txt_code_type_		 " + _txt_code_type_);
		System.out.println("> _txt_code_id_			 " + _txt_code_id_);
		System.out.println("> _txt_code_sub_id_		 " + _txt_code_sub_id_);
		System.out.println("> _txt_code_name_		 " + _txt_code_name_);
		System.out.println("> _txt_code_sub_name_	 " + _txt_code_sub_name_);
		System.out.println("> _txt_code_sub_value_		 " + _txt_code_sub_value_);
		System.out.println("> _txt_code_unit_		 " + _txt_code_unit_);
		System.out.println("> _txt_code_unit_type_	 " + _txt_code_unit_type_);
		System.out.println("> _txt_code_price_		 " + _txt_code_price_);
		System.out.println("> _ta_comment_			 " + _ta_comment_);
		System.out.println("> _txt_process_type_			 " + _txt_process_type_);

		if(_txt_code_sub_id_.equals(" ")) {
			_txt_code_sub_id_ = "0000";
		}

		String query  = "";
		String strCondition  = "";

		if(_txt_process_type_.equals("S")) {
			
			try {

				if(_txt_code_type_.equals("U")) {
					stmt = conn.createStatement();

					if(!_txt_code_id_.equals("")) {
						strCondition += "and x.clm_code_id='" + _txt_code_id_ + "' ";
					}
					if(!_txt_code_sub_id_.equals("")) {
						strCondition += "and y.clm_code_sub_id='" + _txt_code_sub_id_ + "' ";
					}
					query  = "";
					query += "select ";
					query += "x.* , y.clm_code_sub_id ";
					query += "from ";
					query += "	tbl_code_info x ";
					query += " left outer join tbl_code_sub_info y on x.clm_use_yn = y.clm_use_yn ";
					query += "where 1=1 " + strCondition + " and x.clm_company_key = y.clm_company_key ";
					query += "order by x.clm_code_id desc, y.clm_code_sub_id limit 1;";
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
						query += "update tbl_code_sub_info set clm_code_name='" + _txt_code_name_ + "', clm_company_key='" + SessionCompanyKey + "', clm_comment='" + _ta_comment_ + "' where clm_code_id='" + _txt_code_id_ + "' and clm_code_sub_id='" + _txt_code_sub_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".update_user_info " + query);
						stmt.execute(query);
					}
					else {
						stmt = conn.createStatement();
						query  = "";
						query += "insert into tbl_code_info(clm_code_id,clm_company_key, clm_code_name, clm_comment) values('" + _txt_code_id_ + "', '" + SessionCompanyKey + "', '" + _txt_code_name_ + "', '" + _ta_comment_ + "');";
						System.out.println("> " + strCurrentReportId + ".insert_user_info.0 " + query);
						stmt.execute(query);
					}
				}else if(_txt_code_type_.equals("L")) {

					_txt_code_total_ = _txt_code_id_ + _txt_code_sub_id_;
					stmt = conn.createStatement();
					query  = "";
					query += "insert into tbl_code_sub_info(clm_code_id,clm_company_key, clm_code_sub_name,clm_code_sub_id,clm_code_sub_value,clm_comment,clm_code_name) values('" + _txt_code_id_ + "', '" + SessionCompanyKey + "', '" + _txt_code_sub_name_ + "', '" + _txt_code_sub_id_ + "', '" + _txt_code_sub_value_ + "', '" + _ta_comment_ + "','"+ _txt_code_name_ +"');";
					System.out.println("> " + strCurrentReportId + ".insert_user_info.1 " + query);
					stmt.execute(query);

					strCondition = "";
					if(!_txt_code_id_.equals("")) {
						strCondition += "and x.clm_code_id='" + _txt_code_id_ + "' ";
					}
					if(!_txt_code_sub_id_.equals("")) {
						strCondition += "and y.clm_code_sub_id='" + _txt_code_sub_id_ + "' ";
					}
					query  = "";
					query += "select ";
					query += "x.* , y.clm_code_sub_id ";
					query += "from ";
					query += "	tbl_code_info x ";
					query += " left outer join tbl_code_sub_info y on x.clm_use_yn = y.clm_use_yn ";
					query += "where 1=1 " + strCondition + " and x.clm_company_key = y.clm_company_key ";
					query += "order by x.clm_code_id desc, y.clm_code_sub_id limit 1;";
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
				}
				
			}
			catch(Exception e) {
				System.out.println("> e " + e.toString());
			}
		}
		else if(!_txt_process_type_.equals("S")) {
			stmt = conn.createStatement();
			query  = "";
			query += "update tbl_code_sub_info set clm_code_name='" + _txt_code_name_ + "', clm_code_sub_name='" + _txt_code_sub_name_ + "',clm_code_sub_value='" + _txt_code_sub_value_ + "', clm_comment='" + _ta_comment_ + "' where clm_code_id='" + _txt_code_id_ + "' and clm_code_sub_id='" + _txt_code_sub_id_ + "';";
			System.out.println("> " + strCurrentReportId + ".update_user_info " + query);
			stmt.execute(query);
		}


		out.clear();
		JSONObject jsonMain = new JSONObject();
		JSONArray jArray = new JSONArray();
		JSONObject jObject = null;

		jObject = new JSONObject();
		jObject.put("code_id", _txt_code_id_);
		jObject.put("code_sub_id", _txt_code_sub_id_);
		jArray.add(0, jObject);
		jsonMain.put("partner_data", jArray);

		response.setContentType("application/x-json; charset=UTF-8");
		response.getWriter().print(jsonMain);
		System.out.println(jsonMain.toJSONString());


	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>