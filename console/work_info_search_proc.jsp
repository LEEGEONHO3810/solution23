<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
	import="java.text.DateFormat"
	%>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<%
		String clm_template_id            = "";
		// String clm_template_name          = "";
		String clm_product_id             = "";
		String clm_product_name           = "";
		String clm_model_name           = "";
		String clm_revision_id            = "";
		String clm_revision_id_prod       = "";
		String clm_update_datetime_format = "";
		String clm_doc_comment = "";

		// System.out.println("> _order_id_			 " + _order_id_);
		// System.out.println("> _order_name_			 " + _order_name_);
		// System.out.println("> _customer_name_		 " + _customer_name_);
		// System.out.println("> _building_address_	 " + _building_address_);
		// System.out.println("> _user_name_			 " + _user_name_);
		// System.out.println("> _work_date_			 " + _work_date_);
		// System.out.println("> _building_type_		 " + _building_type_);
		// System.out.println("> _building_height_		 " + _building_height_);

		try {
			stmt = conn.createStatement();
			String strCondition = "";
			if(!_order_name_.equals("")) {
				strCondition += "and x.clm_order_name like '%" + _order_name_ + "%' ";
			}
			if(!_customer_name_.equals("")) {
				strCondition += "and x.clm_client_name like '%" + _customer_name_ + "%' ";
			}
			if(!_building_address_.equals("")) {
				strCondition += "and x.clm_building_address_full like '%" + _building_address_ + "%' ";
			}
			if(!_work_from_date_.equals("")) {
				strCondition += "and x.clm_work_date between '" + _work_from_date_ + "' and '" + _work_end_date_ + "' ";
			}
			if(!_building_type_.equals("")) {
				strCondition += "and x.clm_building_type='" + _building_type_ + "' ";
			}
			if(!_building_from_height_.equals("")) {
				strCondition += "and x.clm_building_height between '" + _building_from_height_ + "' and '" + _building_end_height_ + "' ";
			}
			String query  = "";
			query += "select ";
			query += "x.*, y.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
			query += "(CASE ";
			query += "	WHEN clm_work_state='00' THEN '작업전' ";
			query += "	WHEN clm_work_state='01' THEN '건축물해체허가신청기간' ";
			query += "	WHEN clm_work_state='02' THEN '착공계제출' ";
			query += "	WHEN clm_work_state='03' THEN '감리자계약' ";
			query += "	WHEN clm_work_state='04' THEN '감리자지정' ";
			query += "	WHEN clm_work_state='05' THEN '해체착공계제출' ";
			query += "	WHEN clm_work_state='06' THEN '해체허가완료' ";
			query += "	WHEN clm_work_state='07' THEN '비산먼지신고기간' ";
			query += "	WHEN clm_work_state='08' THEN '비산먼지신고' ";
			query += "	WHEN clm_work_state='09' THEN '특정공사신고' ";
			query += "	WHEN clm_work_state='10' THEN '도로점용신고' ";
			query += "	WHEN clm_work_state='11' THEN '건축물구조검토기간' ";
			query += "	WHEN clm_work_state='12' THEN '건축물구조검토완료' ";
			query += "	WHEN clm_work_state='13' THEN '철거심의기간' ";
			query += "	WHEN clm_work_state='14' THEN '철거심의완료' ";
			query += "	WHEN clm_work_state='15' THEN '건설폐기물신고' ";
			query += "	WHEN clm_work_state='16' THEN '석면신고기간' ";
			query += "	WHEN clm_work_state='17' THEN '석면공사' ";
			query += "	WHEN clm_work_state='18' THEN '해체완료' ";
			query += "	WHEN clm_work_state='19' THEN '감리완료' ";
			query += "	WHEN clm_work_state='20' THEN '멸실신고' ";
			query += "	WHEN clm_work_state='21' THEN '등기정리' ";
			query += "END) clm_work_state_type_name, ";
			query += "y.clm_work_start_date clm_work_start_date_formatted, ";
			query += "y.clm_work_end_date clm_work_end_date_formatted, ";
			query += "coalesce((select y.clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id), '-') clm_user_name, ";
			query += "(select y.clm_code_name from fn_code_sub_info('0003', x.clm_building_deconstruction_report_yn) y) clm_building_deconstruction_report_yn_name, ";
			query += "coalesce((select y.clm_user_name from fn_user_info(y.clm_work_manager_id) y), '-') clm_work_manager_name, ";
			query += "coalesce((select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y), '-') clm_reg_user_name, ";
			query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
			query += "from ";
			query += "	tbl_order_info x, tbl_work_info y ";
			query += "where 1=1 and x.clm_order_id=y.clm_order_id and x.clm_del_yn='N' and x.clm_order_state_type='B' " + strCondition + " ";
			query += "order by x.clm_order_id desc;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);

			String reqDateStr = "";
			java.util.Date curDate = null;
			SimpleDateFormat dateFormat = null;
			java.util.Date reqDate = null;
			long reqDateTime = 0;
			long curDateTime = 0;
			long minute = 0;
			String duration_minute = "";

			String saveFolderRootLogical = "/ESTIMATION/GAGA/files";
			String iSubRowCntFormatted = "";

			JSONObject jsonMain = new JSONObject();
			JSONArray jArray = new JSONArray();
			JSONObject jObject = null;

			jObject = new JSONObject();

			int iRowCnt = 0;
			while (rs.next()) {
				String clm_order_id								 = rs.getString("clm_order_id");
				String clm_order_name							 = rs.getString("clm_order_name");
				String clm_order_estimation_price				 = rs.getString("clm_order_estimation_price");
				String clm_building_address						 = rs.getString("clm_building_address");
				String clm_building_start_datetime				 = rs.getString("clm_building_start_datetime");
				String clm_building_fininsh_datetime			 = rs.getString("clm_building_fininsh_datetime");
				String clm_building_volume						 = rs.getString("clm_building_volume");
				String clm_building_base_volume					 = rs.getString("clm_building_base_volume");
				String clm_building_type						 = rs.getString("clm_building_type");
				String clm_building_height						 = rs.getString("clm_building_height");
				String clm_building_deconstruction_report_yn	 = rs.getString("clm_building_deconstruction_report_yn");
				String clm_order_state_type						 = rs.getString("clm_order_state_type");
				String clm_order_datetime						 = rs.getString("clm_order_datetime");
				String clm_del_yn								 = rs.getString("clm_del_yn");
				String clm_mail_send_yn							 = rs.getString("clm_mail_send_yn");
				String clm_customer_id							 = rs.getString("clm_customer_id");
				String clm_inbound_user_id						 = rs.getString("clm_inbound_user_id");
				String clm_cancel_yn							 = rs.getString("clm_cancel_yn");
				String clm_comment								 = rs.getString("clm_comment");
				String clm_reg_datetime							 = rs.getString("clm_reg_datetime_formatted");
				String clm_reg_user_id							 = rs.getString("clm_reg_user_id");
				String clm_update_datetime						 = rs.getString("clm_update_datetime");
				String clm_update_user_id						 = rs.getString("clm_update_user_id");
				String clm_file_count							 = rs.getString("clm_file_count");
				String clm_order_email							 = rs.getString("clm_order_email");
				String clm_reg_user_name						 = rs.getString("clm_reg_user_name");
				String clm_work_progress_01						 = rs.getString("clm_work_progress_01");
				String clm_work_progress_02						 = rs.getString("clm_work_progress_02");
				String clm_hold_state							 = rs.getString("clm_hold_state");
				String clm_work_start_date						 = rs.getString("clm_work_start_date");
				String clm_work_end_date						 = rs.getString("clm_work_end_date");
				String clm_work_manager_id						 = rs.getString("clm_work_manager_id");
				String clm_purchased_work_price					 = rs.getString("clm_purchased_work_price");
				String clm_work_estimation_price				 = rs.getString("clm_estimation_price");
				String clm_work_state_type_name				 = rs.getString("clm_work_state_type_name");
				String clm_work_manager_name					 = rs.getString("clm_work_manager_name");
				String clm_work_start_date_formatted			 = rs.getString("clm_work_start_date_formatted");
				String clm_work_end_date_formatted					 = rs.getString("clm_work_end_date_formatted");
				String clm_user_name							 = rs.getString("clm_user_name");

				String clm_work_cost_total							 = rs.getString("clm_work_cost_total");
				String clm_work_income_total						 = rs.getString("clm_work_income_total");
				String clm_work_calc_total							 = rs.getString("clm_work_calc_total");
				String clm_work_cost_total_without_comma			 = clm_work_cost_total.replace(",", "");
				String clm_work_income_total_without_comma			 = clm_work_income_total.replace(",", "");
				String clm_work_calc_total_without_comma			 = clm_work_calc_total.replace(",", "");
				String clm_estimation_price_without_comma			 = clm_work_estimation_price.replace(",", "");
				if(clm_estimation_price_without_comma.equals("0")) {
					clm_estimation_price_without_comma = clm_work_cost_total_without_comma;
				}
				int clm_work_purchased_rate_tmp						 = (int)((Double.parseDouble(clm_work_cost_total_without_comma)/Double.parseDouble(clm_estimation_price_without_comma))*100);
				String clm_work_purchased_rate						 = String.format("%,d", clm_work_purchased_rate_tmp);
				// System.out.println("> clm_work_cost_total_without_comma " + clm_work_cost_total_without_comma + " / clm_estimation_price_without_comma " + clm_estimation_price_without_comma + " / clm_work_purchased_rate " + clm_work_purchased_rate);

				// String clm_work_purchased_rate					 = String.format("%,d", (int)((Double.parseDouble(clm_purchased_work_price)/Double.parseDouble(clm_work_estimation_price))*100));
				String clm_order_state_color = "";
				String clm_mail_send_color = "";

				java.util.Date today = new java.util.Date();
				SimpleDateFormat df = new SimpleDateFormat("YYYY/MM/dd");
				String current_date = df.format(today);

				String date_start	 = clm_work_start_date.replaceAll("/", "");
				String date_end		 = clm_work_end_date.replaceAll("/", "");
				String date_today	 = current_date.replaceAll("/", "");

				// SimpleDateFormat format = new SimpleDateFormat("YYYY/MM/dd");
				DateFormat format = new SimpleDateFormat("yyyyMMdd");
				// System.out.println("> " + date_start + " " + date_end + " " + date_today);

				java.util.Date date_gap_start	 = format.parse( date_start );
				java.util.Date date_gap_end	 = format.parse( date_end );
				java.util.Date date_gap_today	 = format.parse( date_today );





				String start_date = date_start.replaceAll("-", "");
				String end_date = date_end.replaceAll("-", "");
				String today_date = date_today.replaceAll("-", "");

				DateFormat format_dt = new SimpleDateFormat("yyyyMMdd");

				/* Date타입으로 변경 */

				java.util.Date dt_start_date = format_dt.parse( start_date );
				java.util.Date dt_end_date = format_dt.parse( end_date );
				java.util.Date dt_today_date = format_dt.parse( today_date );
				long sec_start_date = (dt_end_date.getTime() - dt_start_date.getTime()) / 1000; // 초
				long sec_end_date = (dt_today_date.getTime() - dt_start_date.getTime()) / 1000; // 초
				long sec_today_date = (dt_today_date.getTime() - dt_end_date.getTime()) / 1000; // 초
				long Min = (dt_end_date.getTime() - dt_start_date.getTime()) / 60000; // 분
				long Hour = (dt_end_date.getTime() - dt_start_date.getTime()) / 3600000; // 시
				long day_start_date = sec_start_date / (24*60*60); // 일자수
				long day_end_date = sec_end_date / (24*60*60); // 일자수
				long day_today_date = sec_today_date / (24*60*60); // 일자수
				int day_date_rate = (int)(((double)day_end_date/(double)day_start_date)*100);
				String day_date_rate_info = (day_date_rate>100)?"100":String.valueOf(day_date_rate);

				if(clm_order_state_type.equals("A")) {
					clm_order_state_color = "grey";
				}
				else if(clm_order_state_type.equals("B")) {
					clm_order_state_color = "red";
				}
				else if(clm_order_state_type.equals("C")) {
					clm_order_state_color = "blue";
				}
				else if(clm_order_state_type.equals("D")) {
					clm_order_state_color = "green";
				}

				if(clm_mail_send_yn.equals("Y")) {
					clm_mail_send_color = "grey";
				}
				else if(clm_mail_send_yn.equals("N")) {
					clm_mail_send_color = "red";
				}

				String clm_file_download_path   = saveFolderRootLogical + "/" + clm_order_id + ".zip";

				// String clm_file_download_path   = saveFolderRootLogical + "/" + clm_order_id + ".zip";

				// Long lng_file_file_size = Long.parseLong(clm_file_file_size);

				// iSubRowCntFormatted = String.format("%02d", iSubRowCnt);
				// clm_file_file_size = String.format("%,d", lng_file_file_size);

				jObject.put("clm_order_id", clm_order_id);
				jObject.put("clm_order_name", clm_order_name);
				jObject.put("clm_order_estimation_price", clm_order_estimation_price);
				jObject.put("clm_building_address", clm_building_address);
				jObject.put("clm_building_start_datetime", clm_building_start_datetime);
				jObject.put("clm_building_fininsh_datetime", clm_building_fininsh_datetime);
				jObject.put("clm_building_volume", clm_building_volume);
				jObject.put("clm_building_base_volume", clm_building_base_volume);
				jObject.put("clm_building_type", clm_building_type);
				jObject.put("clm_building_height", clm_building_height);
				jObject.put("clm_building_deconstruction_report_yn", clm_building_deconstruction_report_yn);
				jObject.put("clm_order_state_type", clm_order_state_type);
				jObject.put("clm_order_datetime", clm_order_datetime);
				jObject.put("clm_del_yn", clm_del_yn);
				jObject.put("clm_mail_send_yn", clm_mail_send_yn);
				jObject.put("clm_customer_id", clm_customer_id);
				jObject.put("clm_inbound_user_id", clm_inbound_user_id);
				jObject.put("clm_cancel_yn", clm_cancel_yn);
				jObject.put("clm_comment", clm_comment);
				jObject.put("clm_reg_datetime", clm_reg_datetime);
				jObject.put("clm_reg_user_id", clm_reg_user_id);
				jObject.put("clm_update_datetime", clm_update_datetime);
				jObject.put("clm_update_user_id", clm_update_user_id);
				jObject.put("clm_file_count", clm_file_count);
				jObject.put("clm_order_email", clm_order_email);
				jObject.put("clm_reg_user_name", clm_reg_user_name);
				jObject.put("clm_work_progress_01", clm_work_progress_01);
				jObject.put("clm_work_progress_02", clm_work_progress_02);
				jObject.put("clm_hold_state", clm_hold_state);
				jObject.put("clm_work_start_date", clm_work_start_date);
				jObject.put("clm_work_end_date", clm_work_end_date);
				jObject.put("clm_work_manager_id", clm_work_manager_id);
				jObject.put("clm_purchased_work_price", clm_purchased_work_price);
				jObject.put("clm_work_estimation_price", clm_work_estimation_price);
				jObject.put("clm_work_state_type_name", clm_work_state_type_name);
				jObject.put("clm_work_manager_name", clm_work_manager_name);
				jObject.put("clm_work_start_date_formatted", clm_work_start_date_formatted);
				jObject.put("clm_work_end_date_formatted", clm_work_end_date_formatted);
				jObject.put("clm_user_name", clm_user_name);
				jObject.put("clm_work_cost_total", clm_work_cost_total);
				jObject.put("clm_work_income_total", clm_work_income_total);
				jObject.put("clm_work_calc_total", clm_work_calc_total);
				jObject.put("clm_work_cost_total_without_comma", clm_work_cost_total_without_comma);
				jObject.put("clm_work_income_total_without_comma", clm_work_income_total_without_comma);
				jObject.put("clm_work_calc_total_without_comma", clm_work_calc_total_without_comma);
				jObject.put("clm_estimation_price_without_comma", clm_estimation_price_without_comma);
				jObject.put("clm_file_download_path", clm_file_download_path);
				jObject.put("clm_mail_send_color", clm_mail_send_color);
				jObject.put("clm_order_state_color", clm_order_state_color);

				jObject.put("day_date_rate_info", day_date_rate_info);
				jObject.put("day_date_rate", day_date_rate);
				jObject.put("day_today_date", day_today_date);
				jObject.put("day_end_date", day_end_date);
				jObject.put("day_start_date", day_start_date);
				jObject.put("clm_work_purchased_rate", clm_work_purchased_rate);

				jArray.add(iRowCnt, jObject);

				iRowCnt++;
			}

			jsonMain.put("order_data", jArray);

			response.setContentType("application/x-json; charset=UTF-8");
			response.getWriter().print(jsonMain);
			System.out.println(jsonMain.toJSONString());
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
%>
<%@ include file="include/conn_close_info.jsp" %>