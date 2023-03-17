<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.sql.*"
	import="java.util.*"
	import="java.text.SimpleDateFormat"
	import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"
	import="java.time.LocalDate"
	import="java.time.format.DateTimeFormatter"
	%>
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<%
		String clm_template_id            = "";
		// String clm_template_name          = "";
		String clm_product_id             = "";
		String clm_product_name           = "";
		String clm_model_name             = "";
		String clm_revision_id            = "";
		String clm_revision_id_prod       = "";
		String clm_update_datetime_format = "";
		String clm_doc_comment = "";
		
		System.out.println("> _order_name_ : " + _order_name_);
		System.out.println("> _customer_name_ : " + _customer_name_);
		System.out.println("> _building_address_ : " + _building_address_);
		System.out.println("> _work_from_date_ : " + _work_from_date_);
		System.out.println("> _work_end_date_ : " + _work_end_date_);
		System.out.println("> _building_type_ : " + _building_type_);
		System.out.println("> _building_type_ : " + _building_type_);

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
			query += "select x.*";
			query += "	   , (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted ";
			query += "     , (CASE ";
			query += "			WHEN clm_order_state_type='A' THEN '견적' ";
			query += "			WHEN clm_order_state_type='B' THEN '주문' ";
			query += "			WHEN clm_order_state_type='C' THEN '주문취소' ";
			query += "		  END) clm_order_state_type_name ";
			query += "	   , coalesce((select y.clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id), '-') clm_user_name ";
			query += "	   , coalesce((select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y), '-') clm_reg_user_name ";
			query += "	   , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
			query += "  from tbl_order_info x ";
			query += " where 1=1 and x.clm_del_yn='N' " + strCondition + " ";
			query += " order by x.clm_order_id desc;";
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
				String clm_order_state_type_name				 = rs.getString("clm_order_state_type_name");
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
				String clm_user_name							 = rs.getString("clm_user_name");
				String clm_estimation_price						 = rs.getString("clm_estimation_price");
				String clm_reg_user_name						 = rs.getString("clm_reg_user_name");
				String clm_order_state_color = "";
				String clm_mail_send_color = "";

				if(clm_order_state_type.equals("A")) {
					clm_order_state_color = "grey";
				}
				else if(clm_order_state_type.equals("B")) {
					clm_order_state_color = "red";
				}
				else if(clm_order_state_type.equals("C")) {
					clm_order_state_color = "blue";
				}
				else if(clm_order_state_type.equals("C")) {
					clm_order_state_color = "green";
				}

				if(clm_mail_send_yn.equals("Y")) {
					clm_mail_send_color = "grey";
				}
				else if(clm_mail_send_yn.equals("N")) {
					clm_mail_send_color = "red";
				}

				String clm_file_download_path   = saveFolderRootLogical + "/" + clm_order_id + ".zip";

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
				jObject.put("clm_order_state_type_name", clm_order_state_type_name);
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
				jObject.put("clm_estimation_price", clm_estimation_price);
				jObject.put("clm_user_name", clm_user_name);
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