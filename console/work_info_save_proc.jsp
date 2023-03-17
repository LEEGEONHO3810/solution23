<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.awt.image.BufferedImage" %>
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
		
		String _txt_building_deconstruction_report_yn_	 = request.getParameter("txt_building_deconstruction_report_yn");
		String _txt_process_type_						 = request.getParameter("txt_process_type");
		String _txt_order_id_							 = request.getParameter("txt_order_id");
		String _txt_client_name_						 = request.getParameter("txt_client_name");
		String _txt_client_id_							 = request.getParameter("txt_client_id");
		String _txt_order_name_							 = request.getParameter("txt_order_name");
		String _txt_order_email_						 = request.getParameter("txt_order_email");
		String _txt_building_type_						 = request.getParameter("txt_building_type");
		String _txt_building_height_					 = request.getParameter("txt_building_height");
		String _txt_building_volume_					 = request.getParameter("txt_building_volume");
		String _txt_building_base_volume_				 = request.getParameter("txt_building_base_volume");
		String _txt_building_address_					 = request.getParameter("txt_building_address");
		String _txt_work_cost_total_					 = request.getParameter("txt_work_cost_total");
		String _txt_work_income_total_					 = request.getParameter("txt_work_income_total");
		String _txt_work_calc_total_					 = request.getParameter("txt_work_calc_total");
		String _txt_estimation_work_diff_				 = request.getParameter("txt_estimation_work_diff");
		String _rdo_del_yn_								 = request.getParameter("rdo_del_yn");
		String _ta_comment_								 = request.getParameter("ta_comment");
		String[] _txt_cost_date_						 = request.getParameterValues("txt_cost_date");
		String[] _txt_cost_cost_count_					 = request.getParameterValues("txt_cost_cost_count");
		String[] _txt_cost_code_id_						 = request.getParameterValues("txt_cost_code_id");
		String[] _txt_cost_code_sub_id_					 = request.getParameterValues("txt_cost_code_sub_id");
		String[] _txt_cost_cost_price_					 = request.getParameterValues("txt_cost_cost_price");
		String[] _txt_income_date_						 = request.getParameterValues("txt_income_date");
		String[] _txt_income_cost_count_				 = request.getParameterValues("txt_income_cost_count");
		String[] _txt_income_code_id_					 = request.getParameterValues("txt_income_code_id");
		String[] _txt_income_code_sub_id_				 = request.getParameterValues("txt_income_code_sub_id");
		String[] _txt_income_cost_price_				 = request.getParameterValues("txt_income_cost_price");
		String[] _txt_cost_code_sub_name_				 = request.getParameterValues("txt_cost_code_sub_name");
		String[] _txt_income_code_sub_name_				 = request.getParameterValues("txt_income_code_sub_name");

		String etcDescrition = "";

		System.out.println("> _txt_work_cost_total_						 " + _txt_work_cost_total_);
		System.out.println("> _txt_work_income_total_					 " + _txt_work_income_total_);
		System.out.println("> _txt_work_calc_total_						 " + _txt_work_calc_total_);
		System.out.println("> _txt_estimation_work_diff_				 " + _txt_estimation_work_diff_);
		System.out.println("> _rdo_del_yn_								 " + _rdo_del_yn_);
		System.out.println("> _txt_building_deconstruction_report_yn_	 " + _txt_building_deconstruction_report_yn_);
		System.out.println("> _txt_process_type_						 " + _txt_process_type_);
		System.out.println("> _txt_order_id_							 " + _txt_order_id_);
		System.out.println("> _txt_client_name_							 " + _txt_client_name_);
		System.out.println("> _txt_client_id_							 " + _txt_client_id_);
		System.out.println("> _txt_order_name_							 " + _txt_order_name_);
		System.out.println("> _txt_order_email_							 " + _txt_order_email_);
		System.out.println("> _txt_building_type_						 " + _txt_building_type_);
		System.out.println("> _txt_building_height_						 " + _txt_building_height_);
		System.out.println("> _txt_building_volume_						 " + _txt_building_volume_);
		System.out.println("> _txt_building_base_volume_				 " + _txt_building_base_volume_);
		System.out.println("> _txt_building_address_					 " + _txt_building_address_);
		System.out.println("> _ta_comment_								 " + _ta_comment_);

		if(_txt_cost_date_!=null) {
			for(int i=0; i<_txt_cost_code_id_.length; i++) {
				System.out.println("> _txt_cost_cost_count_[" + i + "]	 " + _txt_cost_cost_count_[i]);
				System.out.println("> _txt_cost_code_id_[" + i + "]		 " + _txt_cost_code_id_[i]);
				System.out.println("> _txt_cost_code_sub_id_[" + i + "]	 " + _txt_cost_code_sub_id_[i]);
				System.out.println("> _txt_cost_cost_price_[" + i + "]	 " + _txt_cost_cost_price_[i]);
				System.out.println("> _txt_cost_code_sub_name_[" + i + "]	 " + _txt_cost_code_sub_name_[i]);
			}
		}
		String query  = "";

		if(_txt_process_type_.equals("S")) {
			try {
				if(!_txt_order_id_.equals("")) {
					stmt = conn.createStatement();
					String strCondition = "";
					if(!_txt_order_id_.equals("")) {
						strCondition += "and x.clm_order_id='" + _txt_order_id_ + "' ";
					}
					query  = "";
					query += "select x.* ";
					query += "  from tbl_work_info x ";
					query += " where 1=1 " + strCondition + " ";
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
						
						query = "update tbl_work_info set clm_work_cost_total = '" + _txt_work_cost_total_ +  "', clm_work_income_total= '" + _txt_work_income_total_ +  "', clm_work_calc_total= '" + _txt_work_calc_total_ +  "', clm_estimation_work_diff= '" + _txt_estimation_work_diff_ +  "', clm_del_yn = '" + _rdo_del_yn_ + "', clm_comment = '" + _ta_comment_ + "' where clm_order_id = '" + _txt_order_id_ + "';";
						// query += "update tbl_work_info set clm_order_name='" + _txt_order_name_ + "', clm_order_email='" + _txt_order_email_ + "', clm_building_type='" + _txt_building_type_ + "', clm_building_height='" + _txt_building_height_ + "', clm_building_volume='" + _txt_building_volume_ + "', clm_building_base_volume='" + _txt_building_base_volume_ + "', clm_building_address='" + _txt_building_address_ + "', clm_comment='" + _ta_comment_ + "', clm_client_id='" + _txt_client_id_ + "', clm_building_deconstruction_report_yn='" + _txt_building_deconstruction_report_yn_ + "' where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".update_order_info " + query);
						stmt.execute(query);
					}
					else {
						query += "insert into tbl_order_info(clm_order_id, clm_order_name, clm_order_email, clm_building_type, clm_building_height, clm_building_volume, clm_building_base_volume, clm_building_address, clm_comment, clm_client_id, clm_building_deconstruction_report_yn) values('" + _txt_order_id_ + "', '" + _txt_order_name_ + "', '" + _txt_order_email_ + "', '" + _txt_building_type_ + "', '" + _txt_building_height_ + "', '" + _txt_building_volume_ + "', '" + _txt_building_base_volume_ + "', '" + _txt_building_address_ + "', '" + _ta_comment_ + "', '" + _txt_client_id_ + "', '" + _txt_building_deconstruction_report_yn_ + "');";
						System.out.println("> " + strCurrentReportId + ".insert_order_info " + query);
						stmt.execute(query);

						query  = "";
						query += "select x.*  ";
						query += "     , (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted ";
						query += "     , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
						query += "     , (select clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_name ";
						query += "  from tbl_order_info x ";
						query += " where 1=1 ";
						query += " order by x.clm_order_id desc limit 1;";
						System.out.println("> " + strCurrentReportId + ".row_cnt " + query);
						rs = stmt.executeQuery(query);

						iRowCnt = 0;
						while (rs.next()) {
							_txt_order_id_ = rs.getString("clm_order_id");
						}
					}

					if(_txt_cost_code_id_!=null) {
						query = "";
						query += "delete from tbl_work_sub_cost where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".delete_work_cost_info " + query);
						stmt.execute(query);

						for(int i=0; i<_txt_cost_code_id_.length; i++) {
							System.out.println("> _txt_cost_cost_count_[" + i + "]	 " + _txt_cost_cost_count_[i]);
							System.out.println("> _txt_cost_code_id_[" + i + "]		 " + _txt_cost_code_id_[i]);
							System.out.println("> _txt_cost_code_sub_id_[" + i + "]	 " + _txt_cost_code_sub_id_[i]);
							System.out.println("> _txt_cost_cost_price_[" + i + "]	 " + _txt_cost_cost_price_[i]);
							etcDescrition = _txt_cost_code_sub_name_[i];
							int i_tmp = i+1;
							query = "";
							query += "insert into tbl_work_sub_cost (clm_order_id, clm_order_cost_seq, clm_cost_id, clm_cost_sub_id, clm_cost_count, clm_cost_unit_price, clm_etc_descrition) values('" + _txt_order_id_ + "', '" + String.format("%02d", i_tmp) + "', '" + _txt_cost_code_id_[i] + "', '" + _txt_cost_code_sub_id_[i] + "', '" + _txt_cost_cost_count_[i] + "', '" + _txt_cost_cost_price_[i] + "', '" + etcDescrition + "');";
							System.out.println("> " + strCurrentReportId + ".insert_work_cost_info " + query);
							stmt.execute(query);
						}
					}

					if(_txt_income_code_id_!=null) {
						query = "";
						query += "delete from tbl_work_sub_income where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".delete_work_income_info " + query);
						stmt.execute(query);

						for(int i=0; i<_txt_income_code_id_.length; i++) {
							System.out.println("> _txt_income_cost_count_[" + i + "]	 " + _txt_income_cost_count_[i]);
							System.out.println("> _txt_income_code_id_[" + i + "]		 " + _txt_income_code_id_[i]);
							System.out.println("> _txt_income_code_sub_id_[" + i + "]	 " + _txt_income_code_sub_id_[i]);
							System.out.println("> _txt_income_cost_price_[" + i + "]	 " + _txt_income_cost_price_[i]);
							etcDescrition = _txt_income_code_sub_name_[i];
							int i_tmp = i+1;
							query = "";
							query += "insert into tbl_work_sub_income (clm_order_id, clm_order_cost_seq, clm_cost_id, clm_cost_sub_id, clm_cost_count, clm_cost_unit_price, clm_etc_descrition) values('" + _txt_order_id_ + "', '" + String.format("%02d", i_tmp) + "', '" + _txt_income_code_id_[i] + "', '" + _txt_income_code_sub_id_[i] + "', '" + _txt_income_cost_count_[i] + "', '" + _txt_income_cost_price_[i] + "', '" + etcDescrition + "');";
							System.out.println("> " + strCurrentReportId + ".insert_order_cost_info " + query);
							stmt.execute(query);
						}
					}
				}

				JSONObject jsonMain = new JSONObject();
				JSONArray jArray = new JSONArray();
				JSONObject jObject = null;

				jObject = new JSONObject();
				jObject.put("order_id", _txt_order_id_);
				jArray.add(0, jObject);
				jsonMain.put("order_data", jArray);

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