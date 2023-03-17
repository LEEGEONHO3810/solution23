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
		request.setCharacterEncoding("UTF-8");

		File file ;
		int maxFileSize = 100 * 1024 * 1024;
		int maxMemSize = 100 * 1024 * 1024;
		String saveFolderRoot = "C:/Program Files/Apache Software Foundation/Tomcat9Sever1/webapps/ROOT/ESTIMATION/GAGA/files";

		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;
		// System.out.println("+ UpdateMaterialLInfo.contentType " + contentType);

		String _txt_client_id_				 = request.getParameter("txt_client_id");
		String clm_company_key			 = request.getParameter("clm_company_key");
		String _txt_client_name_			 = request.getParameter("txt_client_name");
		String _txt_client_serial_no_		 = request.getParameter("txt_client_serial_no");
		String _txt_ceo_name_				 = request.getParameter("txt_ceo_name");
		String _txt_client_phone_				 = request.getParameter("txt_client_phone");
		String _txt_client_fax_				 = request.getParameter("txt_client_fax");
		String _txt_client_tel_				 = request.getParameter("txt_client_tel");
		String _txt_client_addr_			 = request.getParameter("txt_client_addr");
		String _txt_client_address_detail_	 = request.getParameter("txt_client_address_detail");
		String _ta_comment_					 = request.getParameter("ta_comment");
		String _txt_process_type_        = request.getParameter("txt_process_type");

		System.out.println("> _txt_client_id_				 " + _txt_client_id_);
		System.out.println("> _txt_client_name_				 " + _txt_client_name_);
		System.out.println("> _txt_client_serial_no_		 " + _txt_client_serial_no_);
		System.out.println("> _txt_ceo_name_				 " + _txt_ceo_name_);
		System.out.println("> _txt_client_phone_				 " + _txt_client_phone_);
		System.out.println("> _txt_client_tel_				 " + _txt_client_tel_);
		System.out.println("> _txt_client_fax_				 " + _txt_client_fax_);
		System.out.println("> _txt_client_addr_			 " + _txt_client_addr_);
		System.out.println("> _txt_client_address_detail_	 " + _txt_client_address_detail_);
		System.out.println("> _ta_comment_					 " + _ta_comment_);

		String query  = "";

		if(_txt_process_type_.equals("S")) {
			try {
				if(!_txt_client_id_.equals("")) {
					stmt = conn.createStatement();
					String strCondition = "";
					if(!_txt_client_id_.equals("")) {
						strCondition += "and x.clm_client_id='" + _txt_client_id_ + "' ";
					}
					query  = "";
					query += "select ";
					query += "x.* ";
					query += "from ";
					query += "	tbl_client_info x ";
					query += "where 1=1 " + strCondition + " ";
					query += "order by x.clm_client_id desc limit 1;";
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
						query += "update tbl_client_info set clm_client_serial_no='" + _txt_client_serial_no_ + "', clm_client_ceo = '" + _txt_ceo_name_ + "',clm_client_phone='" + _txt_client_phone_ + "', clm_client_fax='" + _txt_client_fax_ + "', clm_client_name='" + _txt_client_name_ + "', clm_client_addr='" + _txt_client_addr_ + "', clm_client_address_detail='" + _txt_client_address_detail_ + "', clm_comment='" + _ta_comment_ + "', clm_client_tel = '" + _txt_client_tel_ +"' where clm_client_id='" + _txt_client_id_ + "' and clm_company_key =   '"+ SessionCompanyKey +"'; ";
						System.out.println("> " + strCurrentReportId + ".update_notice_info " + query);
						stmt.execute(query);
					}
					else {
						stmt = conn.createStatement();
						query  = "";
						query += "insert into tbl_client_info(clm_company_key,clm_client_serial_no, clm_client_ceo, clm_client_phone, clm_client_fax,clm_client_tel,clm_client_name, clm_client_addr, clm_client_address_detail, clm_comment) values('"+ SessionCompanyKey +"','" + _txt_client_serial_no_ + "', '" + _txt_ceo_name_ + "', '" + _txt_client_phone_ + "', '" + _txt_client_fax_ + "', '" + _txt_client_tel_ + "','" + _txt_client_name_ + "', '" + _txt_client_addr_ + "', '" + _txt_client_address_detail_ + "', '" + _ta_comment_ + "');";
						System.out.println("> " + strCurrentReportId + ".insert_notice_info " + query);
						stmt.execute(query);
					}
				}
				else if(_txt_client_id_.equals("")) {
					stmt = conn.createStatement();
					query  = "";
					query += "insert into tbl_client_info(clm_company_key,clm_client_serial_no, clm_client_ceo, clm_client_tel, clm_client_fax, clm_client_name, clm_client_phone, clm_client_addr, clm_client_address_detail, clm_comment) values('"+ SessionCompanyKey +"','" + _txt_client_serial_no_ + "', '" + _txt_ceo_name_ + "', '" + _txt_client_tel_ + "', '" + _txt_client_fax_ + "', '" + _txt_client_name_ + "', '" + _txt_client_phone_ + "', '" + _txt_client_addr_ + "', '" + _txt_client_address_detail_ + "', '" + _ta_comment_ + "');";
					System.out.println("> " + strCurrentReportId + ".insert_notice_info " + query);
					stmt.execute(query);

					query  = "";
					query += "select ";
					query += "x.* ";
					query += "from ";
					query += "	tbl_client_info x ";
					query += "where 1=1 ";
					query += "order by x.clm_client_id desc limit 1;";
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
						_txt_client_id_ = rs.getString("clm_client_id");
						iRowCnt++;
					}
				}

				JSONObject jsonMain = new JSONObject();
				JSONArray jArray = new JSONArray();
				JSONObject jObject = null;

				jObject = new JSONObject();
				jObject.put("partner_id", _txt_client_id_);
				jArray.add(0, jObject);
				jsonMain.put("partner_data", jArray);

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