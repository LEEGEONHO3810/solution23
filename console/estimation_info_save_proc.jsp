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

		File file;
		int maxFileSize = 100 * 1024 * 1024;
		int maxMemSize = 100 * 1024 * 1024;
		
		String contentType = request.getContentType();
		String fieldName = "";
		String fileName = "";
		int numRowsUpdated = 0;
		
		String _txt_process_type_						 = (request.getParameter("txt_process_type")==null)?"":request.getParameter("txt_process_type");
		String _txt_order_id_							 = (request.getParameter("txt_order_id")==null)?"":request.getParameter("txt_order_id");
		String _txt_client_name_						 = (request.getParameter("txt_client_name")==null)?"":request.getParameter("txt_client_name");
		String _txt_client_id_							 = (request.getParameter("txt_client_id")==null)?"":request.getParameter("txt_client_id");
		String _txt_order_name_							 = (request.getParameter("txt_order_name")==null)?"":request.getParameter("txt_order_name");
		String _txt_order_email_						 = (request.getParameter("txt_order_email")==null)?"":request.getParameter("txt_order_email");
		String _txt_building_type_						 = (request.getParameter("txt_building_type")==null)?"":request.getParameter("txt_building_type");
		String _txt_building_height_					 = (request.getParameter("txt_building_height")==null)?"":request.getParameter("txt_building_height");
		String _txt_building_volume_					 = (request.getParameter("txt_building_volume")==null)?"":request.getParameter("txt_building_volume");
		String _txt_building_base_volume_				 = (request.getParameter("txt_building_base_volume")==null)?"":request.getParameter("txt_building_base_volume");
		String _txt_building_volume_py_					 = (request.getParameter("txt_building_volume_py")==null)?"":request.getParameter("txt_building_volume_py");
		String _txt_building_base_volume_py_			 = (request.getParameter("txt_building_base_volume_py")==null)?"":request.getParameter("txt_building_base_volume_py");
		String _txt_building_deconstruction_report_yn_	 = (request.getParameter("txt_building_deconstruction_report_yn_name")==null)?"":request.getParameter("txt_building_deconstruction_report_yn_name");
		String _txt_building_address_					 = (request.getParameter("txt_building_address")==null)?"":request.getParameter("txt_building_address");
		String _txt_building_address_detail_			 = (request.getParameter("txt_building_address_detail")==null)?"":request.getParameter("txt_building_address_detail");
		String _txt_cost_total_price_					 = (request.getParameter("txt_cost_total_price")==null)?"":request.getParameter("txt_cost_total_price");
		String _txt_work_start_date_					 = (request.getParameter("txt_work_start_date")==null)?"":request.getParameter("txt_work_start_date");
		String _txt_work_end_date_						 = (request.getParameter("txt_work_end_date")==null)?"":request.getParameter("txt_work_end_date");
		String _ta_comment_								 = (request.getParameter("ta_comment")==null)?"":request.getParameter("ta_comment");
		String[] _txt_cost_cost_count_					 = request.getParameterValues("txt_cost_cost_count");
		String[] _txt_cost_code_id_						 = request.getParameterValues("txt_cost_code_id");
		String[] _txt_cost_code_sub_id_					 = request.getParameterValues("txt_cost_code_sub_id");
		String[] _txt_cost_cost_price_					 = request.getParameterValues("txt_cost_cost_price");

		String _txt_work_process_01_schedule_			 = (request.getParameter("txt_work_process_01_schedule")==null)?"":request.getParameter("txt_work_process_01_schedule");
		String _txt_work_process_02_schedule_			 = (request.getParameter("txt_work_process_02_schedule")==null)?"":request.getParameter("txt_work_process_02_schedule");
		String _txt_work_process_03_schedule_			 = (request.getParameter("txt_work_process_03_schedule")==null)?"":request.getParameter("txt_work_process_03_schedule");
		String _txt_work_process_04_schedule_			 = (request.getParameter("txt_work_process_04_schedule")==null)?"":request.getParameter("txt_work_process_04_schedule");
		String _txt_work_process_05_schedule_			 = (request.getParameter("txt_work_process_05_schedule")==null)?"":request.getParameter("txt_work_process_05_schedule");
		String _txt_work_process_06_schedule_			 = (request.getParameter("txt_work_process_06_schedule")==null)?"":request.getParameter("txt_work_process_06_schedule");
		String _txt_work_process_07_schedule_			 = (request.getParameter("txt_work_process_07_schedule")==null)?"":request.getParameter("txt_work_process_07_schedule");
		String _txt_work_process_08_schedule_			 = (request.getParameter("txt_work_process_08_schedule")==null)?"":request.getParameter("txt_work_process_08_schedule");
		String _txt_work_process_09_schedule_			 = (request.getParameter("txt_work_process_09_schedule")==null)?"":request.getParameter("txt_work_process_09_schedule");
		String _txt_work_process_10_schedule_			 = (request.getParameter("txt_work_process_10_schedule")==null)?"":request.getParameter("txt_work_process_10_schedule");
		String _txt_work_process_11_schedule_			 = (request.getParameter("txt_work_process_11_schedule")==null)?"":request.getParameter("txt_work_process_11_schedule");
		String _txt_work_process_12_schedule_			 = (request.getParameter("txt_work_process_12_schedule")==null)?"":request.getParameter("txt_work_process_12_schedule");
		String _txt_work_process_13_schedule_			 = (request.getParameter("txt_work_process_13_schedule")==null)?"":request.getParameter("txt_work_process_13_schedule");
		String _txt_work_process_14_schedule_			 = (request.getParameter("txt_work_process_14_schedule")==null)?"":request.getParameter("txt_work_process_14_schedule");
		String _txt_work_process_15_schedule_			 = (request.getParameter("txt_work_process_15_schedule")==null)?"":request.getParameter("txt_work_process_15_schedule");
		String _txt_work_process_16_schedule_			 = (request.getParameter("txt_work_process_16_schedule")==null)?"":request.getParameter("txt_work_process_16_schedule");
		String _txt_work_process_17_schedule_			 = (request.getParameter("txt_work_process_17_schedule")==null)?"":request.getParameter("txt_work_process_17_schedule");
		String _txt_work_process_18_schedule_			 = (request.getParameter("txt_work_process_18_schedule")==null)?"":request.getParameter("txt_work_process_18_schedule");
		String _txt_work_process_19_schedule_			 = (request.getParameter("txt_work_process_19_schedule")==null)?"":request.getParameter("txt_work_process_19_schedule");
		String _txt_work_process_20_schedule_			 = (request.getParameter("txt_work_process_20_schedule")==null)?"":request.getParameter("txt_work_process_20_schedule");
		String _txt_work_process_21_schedule_			 = (request.getParameter("txt_work_process_21_schedule")==null)?"":request.getParameter("txt_work_process_21_schedule");
		String _txt_work_process_22_schedule_			 = (request.getParameter("txt_work_process_22_schedule")==null)?"":request.getParameter("txt_work_process_22_schedule");

		System.out.println("> ss_user_id								 " + ss_user_id); 
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
		System.out.println("> _txt_building_volume_py_					 " + _txt_building_volume_py_);
		System.out.println("> _txt_building_base_volume_py_				 " + _txt_building_base_volume_py_);
		System.out.println("> _txt_building_deconstruction_report_yn_	 " + _txt_building_deconstruction_report_yn_);
		System.out.println("> _txt_building_address_					 " + _txt_building_address_);
		System.out.println("> _txt_building_address_detail_				 " + _txt_building_address_detail_);
		System.out.println("> _txt_cost_total_price_					 " + _txt_cost_total_price_);
		System.out.println("> _txt_work_start_date_						 " + _txt_work_start_date_);
		System.out.println("> _txt_work_end_date_						 " + _txt_work_end_date_);
		System.out.println("> _ta_comment_								 " + _ta_comment_);
		System.out.println("> _txt_work_process_01_schedule_			 " + _txt_work_process_01_schedule_);
		System.out.println("> _txt_work_process_02_schedule_			 " + _txt_work_process_02_schedule_);
		System.out.println("> _txt_work_process_03_schedule_			 " + _txt_work_process_03_schedule_);
		System.out.println("> _txt_work_process_04_schedule_			 " + _txt_work_process_04_schedule_);
		System.out.println("> _txt_work_process_05_schedule_			 " + _txt_work_process_05_schedule_);
		System.out.println("> _txt_work_process_06_schedule_			 " + _txt_work_process_06_schedule_);
		System.out.println("> _txt_work_process_07_schedule_			 " + _txt_work_process_07_schedule_);
		System.out.println("> _txt_work_process_08_schedule_			 " + _txt_work_process_08_schedule_);
		System.out.println("> _txt_work_process_09_schedule_			 " + _txt_work_process_09_schedule_);
		System.out.println("> _txt_work_process_10_schedule_			 " + _txt_work_process_10_schedule_);
		System.out.println("> _txt_work_process_11_schedule_			 " + _txt_work_process_11_schedule_);
		System.out.println("> _txt_work_process_12_schedule_			 " + _txt_work_process_12_schedule_);
		System.out.println("> _txt_work_process_13_schedule_			 " + _txt_work_process_13_schedule_);
		System.out.println("> _txt_work_process_14_schedule_			 " + _txt_work_process_14_schedule_);
		System.out.println("> _txt_work_process_15_schedule_			 " + _txt_work_process_15_schedule_);
		System.out.println("> _txt_work_process_16_schedule_			 " + _txt_work_process_16_schedule_);
		System.out.println("> _txt_work_process_17_schedule_			 " + _txt_work_process_17_schedule_);
		System.out.println("> _txt_work_process_18_schedule_			 " + _txt_work_process_18_schedule_);
		System.out.println("> _txt_work_process_19_schedule_			 " + _txt_work_process_19_schedule_);
		System.out.println("> _txt_work_process_20_schedule_			 " + _txt_work_process_20_schedule_);
		System.out.println("> _txt_work_process_21_schedule_			 " + _txt_work_process_21_schedule_);
		System.out.println("> _txt_work_process_22_schedule_			 " + _txt_work_process_22_schedule_);

		if(_txt_cost_code_id_!=null) {
			for(int i=0; i<_txt_cost_code_id_.length; i++) {
				System.out.println("> _txt_cost_cost_count_[" + i + "]	 " + _txt_cost_cost_count_[i]);
				System.out.println("> _txt_cost_code_id_[" + i + "]		 " + _txt_cost_code_id_[i]);
				System.out.println("> _txt_cost_code_sub_id_[" + i + "]	 " + _txt_cost_code_sub_id_[i]);
				System.out.println("> _txt_cost_cost_price_[" + i + "]	 " + _txt_cost_cost_price_[i]);
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
					query += "	   , (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted ";
					query += "	   , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
					query += "	   , (select clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_name ";
					query += "  from tbl_order_info x ";
					query += " where 1=1 " + strCondition + " ";
					query += " order by x.clm_order_id desc;";
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
						query += "update tbl_order_info set clm_order_name='" + _txt_order_name_ + "', clm_order_email='" + _txt_order_email_ + "', clm_building_type='" + _txt_building_type_ + "', clm_building_height='" + _txt_building_height_ + "', clm_building_volume = '" + _txt_building_volume_ + "', clm_building_base_volume = '" + _txt_building_base_volume_ + "', clm_building_volume_py ='" + _txt_building_volume_py_ + "', clm_building_base_volume_py ='" + _txt_building_base_volume_py_ + "', clm_building_address='" + _txt_building_address_ + "', clm_building_address_detail='" + _txt_building_address_detail_ + "', clm_comment='" + _ta_comment_ + "', clm_client_id='" + _txt_client_id_ + "', clm_building_deconstruction_report_yn='" + _txt_building_deconstruction_report_yn_ + "' where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".update_order_info " + query);
						stmt.execute(query);

						query  = "";
						query += "update tbl_work_info set clm_work_start_date='" + _txt_work_start_date_ + "', clm_work_end_date='" + _txt_work_end_date_ + "' where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".update_work_info " + query);
						stmt.execute(query);

						query  = "";
						query += "update tbl_work_progress_info set clm_work_process_01_schedule='" + _txt_work_process_01_schedule_ + "', clm_work_process_02_schedule='" + _txt_work_process_02_schedule_ + "', clm_work_process_03_schedule='" + _txt_work_process_03_schedule_ + "', clm_work_process_04_schedule='" + _txt_work_process_04_schedule_ + "', clm_work_process_05_schedule='" + _txt_work_process_05_schedule_ + "', clm_work_process_06_schedule='" + _txt_work_process_06_schedule_ + "', clm_work_process_07_schedule='" + _txt_work_process_07_schedule_ + "', clm_work_process_08_schedule='" + _txt_work_process_08_schedule_ + "', clm_work_process_09_schedule='" + _txt_work_process_09_schedule_ + "', clm_work_process_10_schedule='" + _txt_work_process_10_schedule_ + "', clm_work_process_11_schedule='" + _txt_work_process_11_schedule_ + "', clm_work_process_12_schedule='" + _txt_work_process_12_schedule_ + "', clm_work_process_13_schedule='" + _txt_work_process_13_schedule_ + "', clm_work_process_14_schedule='" + _txt_work_process_14_schedule_ + "', clm_work_process_15_schedule='" + _txt_work_process_15_schedule_ + "', clm_work_process_16_schedule='" + _txt_work_process_16_schedule_ + "', clm_work_process_17_schedule='" + _txt_work_process_17_schedule_ + "', clm_work_process_18_schedule='" + _txt_work_process_18_schedule_ + "', clm_work_process_19_schedule='" + _txt_work_process_19_schedule_ + "', clm_work_process_20_schedule='" + _txt_work_process_20_schedule_ + "', clm_work_process_21_schedule='" + _txt_work_process_21_schedule_ + "', clm_work_process_22_schedule='" + _txt_work_process_22_schedule_ + "' where clm_order_id='" + _txt_order_id_ + "';";
						// System.out.println("> " + strCurrentReportId + ".insert_work_progress_info " + query);
						stmt.execute(query);
					} else {
						query += "insert into tbl_order_info ";
						query += " (clm_order_id, clm_order_name, clm_order_email, clm_building_type, clm_building_height, clm_building_volume, clm_building_base_volume, clm_building_volume_py, clm_building_base_volume_py, clm_building_address, clm_building_address_detail, clm_comment, clm_client_id, clm_building_deconstruction_report_yn, clm_reg_user_id, clm_reg_datetime) ";
						query += " values ";
						query += " ('" + _txt_order_id_ + "', '" + _txt_order_name_ + "', '" + _txt_order_email_ + "', '" + _txt_building_type_ + "', '" + _txt_building_height_ + "', '" + _txt_building_volume_ + "', '" + _txt_building_base_volume_ + "', '" + _txt_building_volume_py_ + "', '" + _txt_building_base_volume_py_ + "', '" + _txt_building_address_ + "', '" + _txt_building_address_detail_ + "', '" + _ta_comment_ + "', '" + _txt_client_id_ + "', '" + _txt_building_deconstruction_report_yn_ + "', '"+ss_user_id+"', to_char(now(), 'YYYYMMDDHH24MISSMS'::text));";
						System.out.println("> " + strCurrentReportId + ".insert_order_info " + query);
						stmt.execute(query);

						query  = "";
						query += "select ";
						query += "x.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
						query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count, ";
						query += "(select clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_name ";
						query += "from ";
						query += "	tbl_order_info x ";
						query += "where 1=1 ";
						query += "order by x.clm_order_id desc limit 1;";
						System.out.println("> " + strCurrentReportId + ".row_cnt " + query);
						rs = stmt.executeQuery(query);

						iRowCnt = 0;
						while (rs.next()) {
							_txt_order_id_ = rs.getString("clm_order_id");
						}


						query  = "";
						query += "insert into tbl_work_info(clm_order_id, clm_work_start_date, clm_work_end_date) values('" + _txt_order_id_ + "', '" + _txt_work_start_date_ + "', '" + _txt_work_end_date_ + "');";
						// System.out.println("> " + strCurrentReportId + ".insert_work_info.0 " + query);
						stmt.execute(query);

						query  = "";
						query += "insert into tbl_work_progress_info(clm_order_id) values('" + _txt_order_id_ + "');";
						// query += "insert into tbl_work_progress_info(clm_order_id, clm_work_process_01_schedule, clm_work_process_02_schedule, clm_work_process_03_schedule, clm_work_process_04_schedule, clm_work_process_05_schedule, clm_work_process_06_schedule, clm_work_process_07_schedule, clm_work_process_08_schedule, clm_work_process_09_schedule, clm_work_process_10_schedule, clm_work_process_11_schedule, clm_work_process_12_schedule, clm_work_process_13_schedule, clm_work_process_14_schedule, clm_work_process_15_schedule, clm_work_process_16_schedule, clm_work_process_17_schedule, clm_work_process_18_schedule, clm_work_process_19_schedule, clm_work_process_20_schedule, clm_work_process_21_schedule, clm_work_process_22_schedule) values('" + _txt_order_id_ + "', '" + _txt_work_process_01_schedule_ + "', '" + _txt_work_process_02_schedule_ + "', '" + _txt_work_process_03_schedule_ + "', '" + _txt_work_process_04_schedule_ + "', '" + _txt_work_process_05_schedule_ + "', '" + _txt_work_process_06_schedule_ + "', '" + _txt_work_process_07_schedule_ + "', '" + _txt_work_process_08_schedule_ + "', '" + _txt_work_process_09_schedule_ + "', '" + _txt_work_process_10_schedule_ + "', '" + _txt_work_process_11_schedule_ + "', '" + _txt_work_process_12_schedule_ + "', '" + _txt_work_process_13_schedule_ + "', '" + _txt_work_process_14_schedule_ + "', '" + _txt_work_process_15_schedule_ + "', '" + _txt_work_process_16_schedule_ + "', '" + _txt_work_process_17_schedule_ + "', '" + _txt_work_process_18_schedule_ + "', '" + _txt_work_process_19_schedule_ + "', '" + _txt_work_process_20_schedule_ + "', '" + _txt_work_process_21_schedule_ + "', '" + _txt_work_process_22_schedule_ + "');";
						// System.out.println("> " + strCurrentReportId + ".insert_work_progress_info " + query);
						stmt.execute(query);
					}
					
					query = "";
					query += "delete from tbl_order_sub_cost where clm_order_id='" + _txt_order_id_ + "';";
					System.out.println("> " + strCurrentReportId + ".delete_order_cost_info " + query);
					stmt.execute(query);
					if(_txt_cost_code_id_!=null) {
						for(int i=0; i<_txt_cost_code_id_.length; i++) {
							System.out.println("> 1._txt_cost_cost_count_[" + i + "]	 " + _txt_cost_cost_count_[i]);
							System.out.println("> 1._txt_cost_code_id_[" + i + "]		 " + _txt_cost_code_id_[i]);
							System.out.println("> 1._txt_cost_code_sub_id_[" + i + "]	 " + _txt_cost_code_sub_id_[i]);
							System.out.println("> 1._txt_cost_cost_price_[" + i + "]	 " + _txt_cost_cost_price_[i]);
							// biEstimationCost = new BigInteger(_txt_cost_cost_price_[i].replace(",", ""));
							// biEstimationCost = biEstimationCost.multiply(BigInteger.valueOf(Integer.parseInt(_txt_cost_cost_count_[i].replace(",", ""))));
							// biEstimationCostTotal = biEstimationCostTotal.add(biEstimationCost);

							int i_tmp = i+1;
							query = "";
							query += " insert into tbl_order_sub_cost ";
							query += " (clm_order_id, clm_order_cost_seq, clm_cost_id, clm_cost_sub_id, clm_cost_count, clm_cost_unit_price) ";
							query += " values ";
							query += " ('" + _txt_order_id_ + "', '" + String.format("%02d", i_tmp) + "', '" + _txt_cost_code_id_[i] + "', '" + _txt_cost_code_sub_id_[i] + "', '" + _txt_cost_cost_count_[i] + "', '" + _txt_cost_cost_price_[i] + "');";
							System.out.println("> " + strCurrentReportId + ".insert_order_cost_info " + query);
							stmt.execute(query);
						}

						query = "update tbl_order_info set clm_estimation_price = '" + _txt_cost_total_price_ + "' where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".insert_order_info " + query);
						stmt.execute(query);
					}
				}else if(_txt_order_id_.equals("")) {
					stmt = conn.createStatement();
					query  = "";
					query += "insert into tbl_order_info ";
					query += " (clm_order_name, clm_order_email, clm_building_type, clm_building_height, clm_building_volume, clm_building_base_volume, clm_building_volume_py, clm_building_base_volume_py, clm_building_address, clm_building_address_detail, clm_comment, clm_client_id, clm_building_deconstruction_report_yn, clm_reg_user_id, clm_reg_datetime) ";
					query += " values ";
					query += " ('" + _txt_order_name_ + "', '" + _txt_order_email_ + "', '" + _txt_building_type_ + "', '" + _txt_building_height_ + "', '" + _txt_building_volume_ + "', '" + _txt_building_base_volume_ + "', '" + _txt_building_volume_py_ + "', '" + _txt_building_base_volume_py_ + "', '" + _txt_building_address_ + "', '" + _txt_building_address_detail_ + "', '" + _ta_comment_ + "', '" + _txt_client_id_ + "', '" + _txt_building_deconstruction_report_yn_ + "', '"+ss_user_id+"', to_char(now(), 'YYYYMMDDHH24MISSMS'::text));";
					System.out.println("> " + strCurrentReportId + ".insert_order_info " + query);
					stmt.execute(query);

					query  = "";
					query += "select ";
					query += "x.* ";
					query += "from ";
					query += "	tbl_order_info x ";
					query += "where 1=1 ";
					query += "order by x.clm_order_id desc limit 1;";
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
						_txt_order_id_ = rs.getString("clm_order_id");
						iRowCnt++;
					}

					query  = "";
					query += "insert into tbl_work_info(clm_order_id, clm_work_start_date, clm_work_end_date) values('" + _txt_order_id_ + "', '" + _txt_work_start_date_ + "', '" + _txt_work_end_date_ + "');";
					// System.out.println("> " + strCurrentReportId + ".insert_work_info.1 " + query);
					stmt.execute(query);

					query  = "";
					query += "insert into tbl_work_progress_info(clm_order_id) values('" + _txt_order_id_ + "');";
					// query += "insert into tbl_work_progress_info(clm_order_id, clm_work_process_01_schedule, clm_work_process_02_schedule, clm_work_process_03_schedule, clm_work_process_04_schedule, clm_work_process_05_schedule, clm_work_process_06_schedule, clm_work_process_07_schedule, clm_work_process_08_schedule, clm_work_process_09_schedule, clm_work_process_10_schedule, clm_work_process_11_schedule, clm_work_process_12_schedule, clm_work_process_13_schedule, clm_work_process_14_schedule, clm_work_process_15_schedule, clm_work_process_16_schedule, clm_work_process_17_schedule, clm_work_process_18_schedule, clm_work_process_19_schedule, clm_work_process_20_schedule, clm_work_process_21_schedule, clm_work_process_22_schedule) values('" + _txt_order_id_ + "', '" + _txt_work_process_01_schedule_ + "', '" + _txt_work_process_02_schedule_ + "', '" + _txt_work_process_03_schedule_ + "', '" + _txt_work_process_04_schedule_ + "', '" + _txt_work_process_05_schedule_ + "', '" + _txt_work_process_06_schedule_ + "', '" + _txt_work_process_07_schedule_ + "', '" + _txt_work_process_08_schedule_ + "', '" + _txt_work_process_09_schedule_ + "', '" + _txt_work_process_10_schedule_ + "', '" + _txt_work_process_11_schedule_ + "', '" + _txt_work_process_12_schedule_ + "', '" + _txt_work_process_13_schedule_ + "', '" + _txt_work_process_14_schedule_ + "', '" + _txt_work_process_15_schedule_ + "', '" + _txt_work_process_16_schedule_ + "', '" + _txt_work_process_17_schedule_ + "', '" + _txt_work_process_18_schedule_ + "', '" + _txt_work_process_19_schedule_ + "', '" + _txt_work_process_20_schedule_ + "', '" + _txt_work_process_21_schedule_ + "', '" + _txt_work_process_22_schedule_ + "');";
					// System.out.println("> " + strCurrentReportId + ".insert_work_progress_info " + query);
					stmt.execute(query);

					BigInteger biEstimationCost = new BigInteger("0");
					BigInteger biEstimationCostTotal = new BigInteger("0");

					if(_txt_cost_code_id_!=null) {
						for(int i=0; i<_txt_cost_code_id_.length; i++) {
							System.out.println("> 1._txt_cost_cost_count_[" + i + "]	 " + _txt_cost_cost_count_[i]);
							System.out.println("> 1._txt_cost_code_id_[" + i + "]		 " + _txt_cost_code_id_[i]);
							System.out.println("> 1._txt_cost_code_sub_id_[" + i + "]	 " + _txt_cost_code_sub_id_[i]);
							System.out.println("> 1._txt_cost_cost_price_[" + i + "]	 " + _txt_cost_cost_price_[i]);
							// biEstimationCost = new BigInteger(_txt_cost_cost_price_[i].replace(",", ""));
							// biEstimationCost = biEstimationCost.multiply(BigInteger.valueOf(Integer.parseInt(_txt_cost_cost_count_[i].replace(",", ""))));
							// biEstimationCostTotal = biEstimationCostTotal.add(biEstimationCost);

							int i_tmp = i+1;
							query = "";
							query += "insert into tbl_order_sub_cost(clm_order_id, clm_order_cost_seq, clm_cost_id, clm_cost_sub_id, clm_cost_count, clm_cost_unit_price) values('" + _txt_order_id_ + "', '" + String.format("%02d", i_tmp) + "', '" + _txt_cost_code_id_[i] + "', '" + _txt_cost_code_sub_id_[i] + "', '" + _txt_cost_cost_count_[i] + "', '" + _txt_cost_cost_price_[i] + "');";
							System.out.println("> " + strCurrentReportId + ".insert_order_cost_info " + query);
							stmt.execute(query);
						}

						query = "update tbl_order_info set clm_estimation_price = '" + _txt_cost_total_price_ + "' where clm_order_id='" + _txt_order_id_ + "';";
						System.out.println("> " + strCurrentReportId + ".insert_order_info " + query);
						stmt.execute(query);
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
		} else if(_txt_process_type_.equals("C")) {
			stmt = conn.createStatement();
			String strCondition = "";
			if(!_txt_order_id_.equals("")) {
				strCondition += "and x.clm_order_id='" + _txt_order_id_ + "' ";
			}
			query  = "";
			query += "insert into tbl_order_info(clm_order_name, clm_order_estimation_price, clm_building_address, clm_building_address_detail, clm_building_volume, clm_building_base_volume, clm_building_type, clm_building_height, clm_building_deconstruction_report_yn, clm_order_state_type, clm_order_datetime, clm_order_email, clm_del_yn, clm_mail_send_yn, clm_customer_id, clm_inbound_user_id, clm_cancel_yn, clm_comment, clm_client_id) ";
			query += "select ";
			query += "x.clm_order_name, x.clm_order_estimation_price, x.clm_building_address, x.clm_building_address_detail, x.clm_building_volume, x.clm_building_base_volume, x.clm_building_type, x.clm_building_height, x.clm_building_deconstruction_report_yn, x.clm_order_state_type, x.clm_order_datetime, x.clm_order_email, x.clm_del_yn, x.clm_mail_send_yn, x.clm_customer_id, x.clm_inbound_user_id, x.clm_cancel_yn, x.clm_comment, x.clm_client_id ";
			query += "from ";
			query += "	tbl_order_info x ";
			query += "where 1=1 " + strCondition + " ";
			query += "order by x.clm_order_id desc;";
			System.out.println("> " + strCurrentReportId + ".copy_rows " + query);
			stmt.execute(query);

			query  = "";
			query += "select ";
			query += "x.* ";
			query += "from ";
			query += "	tbl_order_info x ";
			query += "where 1=1 ";
			query += "order by x.clm_order_id desc limit 1;";
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
			String _txt_order_id_tmp_ = "";

			int iRowCnt = 0;
			while (rs.next()) {
				_txt_order_id_tmp_ = rs.getString("clm_order_id");
				iRowCnt++;
			}

			query  = "";
			query += "insert into tbl_work_info(clm_order_id, clm_work_start_date, clm_work_end_date) values('" + _txt_order_id_ + "', '" + _txt_work_start_date_ + "', '" + _txt_work_end_date_ + "');";
			// System.out.println("> " + strCurrentReportId + ".insert_work_info " + query);
			stmt.execute(query);

			query  = "";
			query += "insert into tbl_work_progress_info(clm_order_id) values('" + _txt_order_id_ + "');";
			// query += "insert into tbl_work_progress_info(clm_order_id, clm_work_process_01_schedule, clm_work_process_02_schedule, clm_work_process_03_schedule, clm_work_process_04_schedule, clm_work_process_05_schedule, clm_work_process_06_schedule, clm_work_process_07_schedule, clm_work_process_08_schedule, clm_work_process_09_schedule, clm_work_process_10_schedule, clm_work_process_11_schedule, clm_work_process_12_schedule, clm_work_process_13_schedule, clm_work_process_14_schedule, clm_work_process_15_schedule, clm_work_process_16_schedule, clm_work_process_17_schedule, clm_work_process_18_schedule, clm_work_process_19_schedule, clm_work_process_20_schedule, clm_work_process_21_schedule, clm_work_process_22_schedule) values('" + _txt_order_id_ + "', '" + _txt_work_process_01_schedule_ + "', '" + _txt_work_process_02_schedule_ + "', '" + _txt_work_process_03_schedule_ + "', '" + _txt_work_process_04_schedule_ + "', '" + _txt_work_process_05_schedule_ + "', '" + _txt_work_process_06_schedule_ + "', '" + _txt_work_process_07_schedule_ + "', '" + _txt_work_process_08_schedule_ + "', '" + _txt_work_process_09_schedule_ + "', '" + _txt_work_process_10_schedule_ + "', '" + _txt_work_process_11_schedule_ + "', '" + _txt_work_process_12_schedule_ + "', '" + _txt_work_process_13_schedule_ + "', '" + _txt_work_process_14_schedule_ + "', '" + _txt_work_process_15_schedule_ + "', '" + _txt_work_process_16_schedule_ + "', '" + _txt_work_process_17_schedule_ + "', '" + _txt_work_process_18_schedule_ + "', '" + _txt_work_process_19_schedule_ + "', '" + _txt_work_process_20_schedule_ + "', '" + _txt_work_process_21_schedule_ + "', '" + _txt_work_process_22_schedule_ + "');";
			// System.out.println("> " + strCurrentReportId + ".insert_work_progress_info " + query);
			stmt.execute(query);

			strCondition = "";
			if(!_txt_order_id_.equals("")) {
				strCondition += "and x.clm_order_id='" + _txt_order_id_ + "' ";
			}
			query = "";
			query += "insert into tbl_order_sub_cost(clm_order_id, clm_order_cost_seq, clm_cost_id, clm_cost_sub_id, clm_cost_count, clm_cost_unit_price) ";
			query += "select ";
			query += "	'" + _txt_order_id_tmp_ + "', x.clm_order_cost_seq, x.clm_cost_id, x.clm_cost_sub_id, x.clm_cost_count, x.clm_cost_unit_price ";
			query += "from ";
			query += "	tbl_order_sub_cost x ";
			query += "where 1=1 " + strCondition + " ";
			System.out.println("> " + strCurrentReportId + ".insert_order_cost_info " + query);
			stmt.execute(query);

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
	}
	catch(Exception e2) {
		System.out.println("> " + strCurrentReportId + " e2 : " + e2.toString());
	}
%>

<%@ include file="include/conn_close_info.jsp" %>