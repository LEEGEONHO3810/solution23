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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/session_info.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="description" content="Table with Expand/Collapse | Propeller - Admin Dashboard" />
<meta content="width=device-width, initial-scale=1, user-scalable=no" name="viewport" />
<title>에코비즈텍</title>
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico" />
<!-- Google icon -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
<!-- Bootstrap css -->
<link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css" />
<!-- Propeller css -->
<link rel="stylesheet" type="text/css" href="assets/css/propeller.min.css" />
<!-- Select2 css-->
<link rel="stylesheet" type="text/css" href="components/select2/css/select2.min.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/select2-bootstrap.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/pmd-select2.css" />
<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-theme.css" />
<!-- Propeller admin theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-admin.css" />
<style>
@import url('https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700,800');
@import url('https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css');

body {
	font-family: 'NanumSquare';
}

h1 {
	font-family: 'NanumSquare';
	font-weight: bold;
}

th {
	background-color: #eee;
	font-size:14px;
	font-weight:bold;
	color:#666;
	border-bottom:1px solid #ccc;
}

thead th {
	background-color: #eee;
	font-size:12px;
	font-weight:bold;
	color:#666;
}

tr {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	border-bottom:1px solid #ccc;
}

td {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	border-bottom:1px solid #ccc;
}

.approval_table {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	height:75px;
	border:1px solid #ccc;
	padding:0px;
}

.approval_td {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	height:75px;
	border:1px solid #ccc;
	padding:5px;
}

.approval_th {
	background-color: #eee;
	text-align:center;
	font-size:12px;
	font-weight:bold;
	color:#333;
	border:1px solid #ccc;
	padding:5px;
}

.select2-results__option {
  font-size: 10px;
}
@media print
{
    @page {
      size: A4;
      margin: 10mm;
    }

}
</style>
<%@ include file="include/_js_00.jsp" %>
</head>

<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<body>
<!-- Header Starts -->
<!--Start Nav bar -->
<nav class="navbar navbar-inverse navbar-fixed-top pmd-navbar pmd-z-depth" style="border-color: <%=header_color %>; background-color: <%=header_color %>;">

	<div class="container-fluid">
		<%@ include file="include/notice_info.jsp" %>
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<a href="javascript:void(0);" data-target="basicSidebar" data-placement="left" data-position="slidepush" is-open="true" is-open-width="1200" class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect pull-left margin-r8 pmd-sidebar-toggle"><i class="material-icons md-light">menu</i></a>
		  <a href="index.jsp" class="navbar-brand">
		  	에코비즈텍 MES 시스템
		  </a>
		</div>
	</div>

</nav><!--End Nav bar -->
<!-- Header Ends -->

<!-- Sidebar Starts -->
<%@ include file="include/left_navigation.jsp" %>
<!-- Sidebar Ends -->

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

		try {
			stmt = conn.createStatement();
			String strCondition = "";
			if(!_order_id_.equals("")) {
				strCondition += "and x.clm_order_id='" + _order_id_ + "' ";
			}
			String query  = "";
			query += "select ";
			query += "x.*, y.*, z.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
			query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count, ";
			query += "(CASE ";
			query += "	WHEN clm_order_state_type='A' THEN '견적' ";
			query += "	WHEN clm_order_state_type='B' THEN '주문' ";
			query += "	WHEN clm_order_state_type='C' THEN '주문취소' ";
			query += "END) clm_order_state_type_name, ";
			query += "y.clm_work_start_date clm_work_start_date_formatted, ";
			query += "y.clm_work_end_date clm_work_end_date_formatted, ";
			query += "(select y.clm_code_name from fn_code_sub_info(x.clm_building_deconstruction_report_yn) y) clm_building_deconstruction_report_yn_name, ";
			query += "(select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y) clm_reg_user_name, ";
			query += "(select clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_name ";
			query += "from ";
			query += "	tbl_order_info x, tbl_work_info y, tbl_work_progress_info z ";
			query += "where 1=1 and x.clm_order_id=y.clm_order_id and x.clm_order_id=z.clm_order_id " + strCondition + " ";
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

			int iRowCnt = 0;
			while (rs.next()) {
				String clm_order_id									 = rs.getString("clm_order_id");
				String clm_client_id								 = rs.getString("clm_client_id");
				String clm_order_name								 = rs.getString("clm_order_name");
				String clm_order_estimation_price					 = rs.getString("clm_order_estimation_price");
				String clm_building_address							 = rs.getString("clm_building_address");
				String clm_building_start_datetime					 = rs.getString("clm_building_start_datetime");
				String clm_building_fininsh_datetime				 = rs.getString("clm_building_fininsh_datetime");
				String clm_building_volume							 = rs.getString("clm_building_volume");
				String clm_building_base_volume						 = rs.getString("clm_building_base_volume");
				String clm_building_volume_py						 = rs.getString("clm_building_volume_py");
				String clm_building_base_volume_py					 = rs.getString("clm_building_base_volume_py");
				String clm_building_type							 = rs.getString("clm_building_type");
				String clm_building_height							 = rs.getString("clm_building_height");
				String clm_building_deconstruction_report_yn		 = rs.getString("clm_building_deconstruction_report_yn");
				String clm_order_state_type							 = rs.getString("clm_order_state_type");
				String clm_order_state_type_name					 = rs.getString("clm_order_state_type_name");
				String clm_order_datetime							 = rs.getString("clm_order_datetime");
				String clm_del_yn									 = rs.getString("clm_del_yn");
				String clm_mail_send_yn								 = rs.getString("clm_mail_send_yn");
				String clm_customer_id								 = rs.getString("clm_customer_id");
				String clm_inbound_user_id							 = rs.getString("clm_inbound_user_id");
				String clm_cancel_yn								 = rs.getString("clm_cancel_yn");
				String clm_comment									 = rs.getString("clm_comment");
				String clm_reg_datetime								 = rs.getString("clm_reg_datetime_formatted");
				String clm_reg_user_id								 = rs.getString("clm_reg_user_id");
				String clm_update_datetime							 = rs.getString("clm_update_datetime");
				String clm_update_user_id							 = rs.getString("clm_update_user_id");
				String clm_file_count								 = rs.getString("clm_file_count");
				String clm_client_name								 = rs.getString("clm_client_name");
				String clm_order_email								 = rs.getString("clm_order_email");
				String clm_reg_user_name							 = rs.getString("clm_reg_user_name");
				String clm_work_start_date							 = rs.getString("clm_work_start_date");
				String clm_work_end_date							 = rs.getString("clm_work_end_date");
				String clm_purchased_work_price						 = rs.getString("clm_purchased_work_price");
				// String clm_work_estimation_price					 = rs.getString("clm_work_estimation_price");
				String clm_work_start_date_formatted				 = rs.getString("clm_work_start_date_formatted");
				String clm_work_end_date_formatted					 = rs.getString("clm_work_end_date_formatted");
				// String clm_work_cost_total							 = rs.getString("clm_work_cost_total");
				// String clm_work_income_total						 = rs.getString("clm_work_income_total");
				// String clm_work_calc_total							 = rs.getString("clm_work_calc_total");
				String clm_estimation_price							 = rs.getString("clm_estimation_price");
				// int clm_work_purchased_rate_tmp						 = (int)((Double.parseDouble(clm_purchased_work_price)/Double.parseDouble(clm_estimation_price))*100);
				// int clm_work_purchased_rate_tmp						 = (int)((Double.parseDouble(clm_work_cost_total)/Double.parseDouble(clm_estimation_price))*100);
				String clm_estimation_work_diff						 = rs.getString("clm_estimation_work_diff");
				String clm_work_estimation_price				 = rs.getString("clm_estimation_price");
				String clm_work_progress_01							 = rs.getString("clm_work_progress_01");
				String clm_work_progress_02							 = rs.getString("clm_work_progress_02");
				String clm_work_process_01							 = rs.getString("clm_work_process_01");
				String clm_work_process_02							 = rs.getString("clm_work_process_02");
				String clm_work_process_03							 = rs.getString("clm_work_process_03");
				String clm_work_process_04							 = rs.getString("clm_work_process_04");
				String clm_work_process_05							 = rs.getString("clm_work_process_05");
				String clm_work_process_06							 = rs.getString("clm_work_process_06");
				String clm_work_process_07							 = rs.getString("clm_work_process_07");
				String clm_work_process_08							 = rs.getString("clm_work_process_08");
				String clm_work_process_09							 = rs.getString("clm_work_process_09");
				String clm_work_process_10							 = rs.getString("clm_work_process_10");
				String clm_work_process_11							 = rs.getString("clm_work_process_11");
				String clm_work_process_12							 = rs.getString("clm_work_process_12");
				String clm_work_process_13							 = rs.getString("clm_work_process_13");
				String clm_work_process_14							 = rs.getString("clm_work_process_14");
				String clm_work_process_15							 = rs.getString("clm_work_process_15");
				String clm_work_process_16							 = rs.getString("clm_work_process_16");
				String clm_work_process_17							 = rs.getString("clm_work_process_17");
				String clm_work_process_18							 = rs.getString("clm_work_process_18");
				String clm_work_process_19							 = rs.getString("clm_work_process_19");
				String clm_work_process_20							 = rs.getString("clm_work_process_20");
				String clm_work_process_21							 = rs.getString("clm_work_process_21");
				String clm_work_process_22							 = rs.getString("clm_work_process_22");
				String clm_work_process_01_date						 = (rs.getString("clm_work_process_01_date").equals(""))?"-":rs.getString("clm_work_process_01_date");
				String clm_work_process_02_date						 = (rs.getString("clm_work_process_02_date").equals(""))?"-":rs.getString("clm_work_process_02_date");
				String clm_work_process_03_date						 = (rs.getString("clm_work_process_03_date").equals(""))?"-":rs.getString("clm_work_process_03_date");
				String clm_work_process_04_date						 = (rs.getString("clm_work_process_04_date").equals(""))?"-":rs.getString("clm_work_process_04_date");
				String clm_work_process_05_date						 = (rs.getString("clm_work_process_05_date").equals(""))?"-":rs.getString("clm_work_process_05_date");
				String clm_work_process_06_date						 = (rs.getString("clm_work_process_06_date").equals(""))?"-":rs.getString("clm_work_process_06_date");
				String clm_work_process_07_date						 = (rs.getString("clm_work_process_07_date").equals(""))?"-":rs.getString("clm_work_process_07_date");
				String clm_work_process_08_date						 = (rs.getString("clm_work_process_08_date").equals(""))?"-":rs.getString("clm_work_process_08_date");
				String clm_work_process_09_date						 = (rs.getString("clm_work_process_09_date").equals(""))?"-":rs.getString("clm_work_process_09_date");
				String clm_work_process_10_date						 = (rs.getString("clm_work_process_10_date").equals(""))?"-":rs.getString("clm_work_process_10_date");
				String clm_work_process_11_date						 = (rs.getString("clm_work_process_11_date").equals(""))?"-":rs.getString("clm_work_process_11_date");
				String clm_work_process_12_date						 = (rs.getString("clm_work_process_12_date").equals(""))?"-":rs.getString("clm_work_process_12_date");
				String clm_work_process_13_date						 = (rs.getString("clm_work_process_13_date").equals(""))?"-":rs.getString("clm_work_process_13_date");
				String clm_work_process_14_date						 = (rs.getString("clm_work_process_14_date").equals(""))?"-":rs.getString("clm_work_process_14_date");
				String clm_work_process_15_date						 = (rs.getString("clm_work_process_15_date").equals(""))?"-":rs.getString("clm_work_process_15_date");
				String clm_work_process_16_date						 = (rs.getString("clm_work_process_16_date").equals(""))?"-":rs.getString("clm_work_process_16_date");
				String clm_work_process_17_date						 = (rs.getString("clm_work_process_17_date").equals(""))?"-":rs.getString("clm_work_process_17_date");
				String clm_work_process_18_date						 = (rs.getString("clm_work_process_18_date").equals(""))?"-":rs.getString("clm_work_process_18_date");
				String clm_work_process_19_date						 = (rs.getString("clm_work_process_19_date").equals(""))?"-":rs.getString("clm_work_process_19_date");
				String clm_work_process_20_date						 = (rs.getString("clm_work_process_20_date").equals(""))?"-":rs.getString("clm_work_process_20_date");
				String clm_work_process_21_date						 = (rs.getString("clm_work_process_21_date").equals(""))?"-":rs.getString("clm_work_process_21_date");
				String clm_work_process_22_date						 = (rs.getString("clm_work_process_22_date").equals(""))?"-":rs.getString("clm_work_process_22_date");
				String clm_work_process_01_schedule					 = (rs.getString("clm_work_process_01_schedule").equals(""))?"-":(rs.getString("clm_work_process_01_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_02_schedule					 = (rs.getString("clm_work_process_02_schedule").equals(""))?"-":(rs.getString("clm_work_process_02_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_03_schedule					 = (rs.getString("clm_work_process_03_schedule").equals(""))?"-":(rs.getString("clm_work_process_03_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_04_schedule					 = (rs.getString("clm_work_process_04_schedule").equals(""))?"-":(rs.getString("clm_work_process_04_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_05_schedule					 = (rs.getString("clm_work_process_05_schedule").equals(""))?"-":(rs.getString("clm_work_process_05_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_06_schedule					 = (rs.getString("clm_work_process_06_schedule").equals(""))?"-":(rs.getString("clm_work_process_06_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_07_schedule					 = (rs.getString("clm_work_process_07_schedule").equals(""))?"-":(rs.getString("clm_work_process_07_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_08_schedule					 = (rs.getString("clm_work_process_08_schedule").equals(""))?"-":(rs.getString("clm_work_process_08_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_09_schedule					 = (rs.getString("clm_work_process_09_schedule").equals(""))?"-":(rs.getString("clm_work_process_09_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_10_schedule					 = (rs.getString("clm_work_process_10_schedule").equals(""))?"-":(rs.getString("clm_work_process_10_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_11_schedule					 = (rs.getString("clm_work_process_11_schedule").equals(""))?"-":(rs.getString("clm_work_process_11_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_12_schedule					 = (rs.getString("clm_work_process_12_schedule").equals(""))?"-":(rs.getString("clm_work_process_12_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_13_schedule					 = (rs.getString("clm_work_process_13_schedule").equals(""))?"-":(rs.getString("clm_work_process_13_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_14_schedule					 = (rs.getString("clm_work_process_14_schedule").equals(""))?"-":(rs.getString("clm_work_process_14_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_15_schedule					 = (rs.getString("clm_work_process_15_schedule").equals(""))?"-":(rs.getString("clm_work_process_15_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_16_schedule					 = (rs.getString("clm_work_process_16_schedule").equals(""))?"-":(rs.getString("clm_work_process_16_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_17_schedule					 = (rs.getString("clm_work_process_17_schedule").equals(""))?"-":(rs.getString("clm_work_process_17_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_18_schedule					 = (rs.getString("clm_work_process_18_schedule").equals(""))?"-":(rs.getString("clm_work_process_18_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_19_schedule					 = (rs.getString("clm_work_process_19_schedule").equals(""))?"-":(rs.getString("clm_work_process_19_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_20_schedule					 = (rs.getString("clm_work_process_20_schedule").equals(""))?"-":(rs.getString("clm_work_process_20_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_21_schedule					 = (rs.getString("clm_work_process_21_schedule").equals(""))?"-":(rs.getString("clm_work_process_21_schedule")).replace("-","/").replace("-","/");
				String clm_work_process_22_schedule					 = (rs.getString("clm_work_process_22_schedule").equals(""))?"-":(rs.getString("clm_work_process_22_schedule")).replace("-","/").replace("-","/");

				String clm_work_date_diff_txt = "";

				java.util.Date today = new java.util.Date();
				SimpleDateFormat df = new SimpleDateFormat("YYYY/MM/dd");
				SimpleDateFormat df2 = new SimpleDateFormat("YYYY-MM-dd");
				String current_date = df.format(today);

				String date_start	 = clm_work_start_date.replaceAll("/", "");
				String date_end		 = clm_work_end_date.replaceAll("/", "");
				String date_today	 = current_date.replaceAll("/", "");

				// SimpleDateFormat format = new SimpleDateFormat("YYYY/MM/dd");
				DateFormat format = new SimpleDateFormat("yyyyMMdd");
				System.out.println("> " + date_start + " " + date_end + " " + date_today);

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
				// String day_date_rate_format = String.format("%,d", (int)day_date_rate);

				System.out.println(start_date + " " + end_date + " " + today_date + " " + day_date_rate);
				System.out.println(day_start_date + "일 차이");
				System.out.println(day_end_date + "일 차이");
				System.out.println(day_today_date + "일 차이");

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
				System.out.println("0." + day_today_date + "일 차이");
				String clm_work_purchased_rate						 = String.format("%,d", clm_work_purchased_rate_tmp);
				System.out.println("1." + day_today_date + "일 차이");
				String day_date_rate_info = (day_date_rate>100)?"100":String.valueOf(day_date_rate);
				System.out.println("2." + day_today_date + "일 차이");



				int diff_date = 0;

				if(day_date_rate>100) {
					diff_date = (int)(day_end_date - day_start_date);
				}

				String clm_work_purchased_rate_txt = "";

				if(day_date_rate==0) {
					clm_work_date_diff_txt = "작업전";
				}
				else if(day_date_rate>100) {
					clm_work_date_diff_txt = "기간 " + diff_date + "일 초과";
				}
				else if(day_date_rate==100) {
					clm_work_date_diff_txt = "기간만료";
				}
				else if(day_date_rate<100) {
					clm_work_date_diff_txt = "진행중";
				}

				if(clm_work_purchased_rate_tmp==0) {
					clm_work_purchased_rate_txt = "집행전";
				}
				else if(clm_work_purchased_rate_tmp>100) {
					clm_work_purchased_rate_txt = "예산초과";
				}
				else if(clm_work_purchased_rate_tmp==100) {
					clm_work_purchased_rate_txt = "예산소진";
				}
				else if(clm_work_purchased_rate_tmp<100) {
					clm_work_purchased_rate_txt = "예산 " + clm_work_cost_total + "원 집행중";
				}
%>
<!--content area start-->
<div id="content" class="pmd-content inner-page">
<!--tab start-->
    <div class="container-fluid full-width-container value-added-detail-page">
	<div style="margin-bottom:-20px; padding:0px;">
		<div class="pmd-card-title" style="padding-left:0px; padding-right:0px;">
			<div class="media-left">
			</div>
			<div class="media-body media-middle">
				<h1 class="pmd-card-title-text typo-fill-secondary" style="font-size:32px;">
					<span>작업 관리 정보 상세</span>
				</h1><!-- End Title -->
				<!--breadcrum start-->
				<ol class="breadcrumb text-left">
				  <li><a href="index.jsp">Home</a></li>
				  <li class="active">MES</li>
				  <li class="active">작업 관리 정보 상세</li>
				</ol><!--breadcrum end-->
			</div>
			<div class="media-right datetimepicker">
				<table class="table table-mc-red pmd-table" style="border-bottom:1px solid #eee; width:350px;">
					<tr>
						<th style="text-align:center; padding:5px; border:1px solid #ccc;" rowspan="2">결<br/>재</th>
						<th style="text-align:center; padding:5px; border:1px solid #ccc;">작성</th>
						<th style="text-align:center; padding:5px; border:1px solid #ccc;">검토</th>
						<th style="text-align:center; padding:5px; border:1px solid #ccc;">승인</th>
					</tr>
					<tr style="height: 55px;">
						<td style="border:1px solid #ccc; text-align:center; padding:0px;">
							<div id="div_approval_level_01">
								<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" id="btn_approve_01" type="button" data-target="#form-dialog_01_01" data-toggle="modal" data-param_01="01" data-param_02="" data-typeinfo="test_type">
									<i class="material-icons pmd-sm" style="color:#ccc; font-size:36px;">person</i>
								</button>
								<input type="hidden" id="txt_approval_01_datetime" placeholder="" style="border:1px solid #999;" value="" readOnly>
								<input type="hidden" id="txt_approval_01_stamp" placeholder="" style="border:1px solid #999;" value="" readOnly>
							</div>
						</td>
						<td style="border:1px solid #ccc; text-align:center; padding:0px;">
							<div id="div_approval_level_02">
								<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" id="btn_approve_02" type="button" data-target="#form-dialog_01_01" data-toggle="modal" data-param_01="02" data-param_02="" data-typeinfo="test_type">
									<i class="material-icons pmd-sm" style="color:#ccc; font-size:36px;">person</i>
								</button>
								<input type="hidden" id="txt_approval_02_datetime" placeholder="" style="border:1px solid #999;" value="" readOnly>
								<input type="hidden" id="txt_approval_02_stamp" placeholder="" style="border:1px solid #999;" value="" readOnly>
							</div>
						</td>
						<td style="border:1px solid #ccc; text-align:center; padding:0px;">
							<div id="div_approval_level_03">
								<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" id="btn_approve_03" type="button" data-target="#form-dialog_01_01" data-toggle="modal" data-param_01="03" data-param_02="" data-typeinfo="test_type">
									<i class="material-icons pmd-sm" style="color:#ccc; font-size:36px;">person</i>
								</button>
								<input type="hidden" id="txt_approval_03_datetime" placeholder="" style="border:1px solid #999;" value="" readOnly>
								<input type="hidden" id="txt_approval_03_stamp" placeholder="" style="border:1px solid #999;" value="" readOnly>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>

		<div id="print_position">
		<div class="table-responsive pmd-card pmd-z-depth no_print">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card pmd-z-depth pmd-card-custom-view">
					<div class="pmd-card-body">
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
							<tr>
								<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
									<!-- label for="regular1" class="control-label" style="font-size:16px; font-weight:bold;" -->
									<label for="regular1" class="control-label">
										일정계획 진척률
									</label>
								</td>
								<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
									<img src="img/<% if(day_date_rate>=100){ %>task_alt.png<% }else{ %>task_alt_gray.png<% } %>" style="width:18px; height:18px;">&nbsp;완료</span>
									<!--
									<input type="checkbox" id="OK" name="result" value="1" <% if(day_date_rate>=100){ %>checked<% }else{ %>disabled<% } %>>&nbsp;완료</span>
									-->
								</td>
							</tr>
						</table>
						<div class="progress-rounded progress">
							<div class="progress-bar progress-bar-danger" style="width:<%=day_date_rate_info %>%;"></div>
						</div>
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; border-bottom: 0px solid white; margin-top:-10px;">
							<tbody>
								<tr>
									<td style="border: 1px solid white; text-align:left; width:20%; padding:0px; font-weight:bold;"><%=clm_work_start_date_formatted %></td>
									<td style="border: 1px solid white; text-align:center; width:60%; padding:0px;">
										<%
											if(day_date_rate<100) {
										%>
											<%=clm_work_date_diff_txt %>
										<%
											}
											else {
										%>
											<b><font color="red"><%=clm_work_date_diff_txt %></font></b>
										<%
											}
										%>
										&nbsp;(<%=day_date_rate %>%)
									</td>
									<td style="border: 1px solid white; text-align:right; width:20%; padding:0px; font-weight:bold;"><%=clm_work_end_date_formatted %></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="pmd-card-body">
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
							<tr>
								<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
									<!-- label for="regular1" class="control-label" style="font-size:16px; font-weight:bold;" -->
									<label for="regular1" class="control-label">
										비용계획 진척률
									</label>
								</td>
								<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
									<img src="img/<% if(clm_work_purchased_rate_tmp>=100){ %>task_alt.png<% }else{ %>task_alt_gray.png<% } %>" style="width:18px; height:18px;">&nbsp;완료</span>
									<!--
									<input type="checkbox" id="OK" name="result" value="1" <% if(clm_work_purchased_rate.equals("100")){ %>checked<% }else{ %>disabled<% } %>>&nbsp;완료</span>
									-->
								</td>
							</tr>
						</table>
						<div class="progress-rounded progress">
							<div class="progress-bar progress-bar-success" style="width:<%=clm_work_purchased_rate %>%;"></div>
						</div>
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; border-bottom: 0px solid white; margin-top:-10px;">
							<tbody>
								<tr>
									<td style="border: 1px solid white; text-align:left; width:20%; padding:0px; font-weight:bold;">0</td>
									<td style="border: 1px solid white; text-align:center; width:60%; padding:0px;">
										<%
											if(clm_work_purchased_rate_tmp<=100) {
										%>
											<%=clm_work_purchased_rate_txt %>
										<%
											}
											else {
										%>
											<b><font color="red"><%=clm_work_purchased_rate_txt %></font></b>
										<%
											}
										%>
										&nbsp;(<%=clm_work_purchased_rate %>%)
									</td>
									<td style="border: 1px solid white; text-align:right; width:20%; padding:0px; font-weight:bold;"><%=String.format("%,d", Long.parseLong(clm_estimation_price_without_comma)) %></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive pmd-card pmd-z-depth no_print" style="padding:2px; background-color:transparent; border:  1px solid transparent; box-shadow: none;">
		</div>
		<div class="table-responsive pmd-card pmd-z-depth">
			<!--section-title -- >
			<h2>Basic Form</h2>< !--section-title end -->
			<!-- section content start-->
			<form name="frm_order_data" id="frm_order_data">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
									거래처<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="txt_client_name" name="txt_client_name" class="form-control" value="<%=clm_client_name %>" readOnly>
								<input type="hidden" id="txt_client_id" name="txt_client_id" class="form-control" value="<%=clm_client_id %>">
								<input type="hidden" id="txt_order_id" name="txt_order_id" class="form-control" value="<%=_order_id_ %>">
								<input type="hidden" id="txt_process_type" name="txt_process_type" class="form-control" value="S">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
									수행기간<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="<%=clm_work_start_date %> ~ <%=clm_work_end_date %>" readOnly>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<label for="regular1" class="control-label">
								Email<span style="font-weight:bold !important; color:red !important;">*</span>
							</label>
							<input type="text" id="txt_order_email" name="txt_order_email" class="form-control" value="<%=clm_order_email %>" readOnly>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<label for="regular1" class="control-label">
								작업소요일자<span style="font-weight:bold !important; color:red !important;">*</span>
							</label>
							<%
								// int gap_date_diff_tmp = gap_date_diff;
								String gap_date_diff_txt = "";
								// if(gap_date_diff<0) {
								// 	gap_date_diff_txt = "(완공 " + (gap_date_diff*(-1)) + "일 초과)";
								// }
								// else {
								// 	gap_date_diff_txt = "(완공 " + gap_date_diff + "일 남음)";
								// }
							%>
							<input type="text" id="regular1" class="form-control" value="<%=day_end_date %> 일 <%=gap_date_diff_txt %>" style="text-align:right;" readOnly>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
									사업소요비용(ⓐ)<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" id="txt_work_cost_total" name="txt_work_cost_total" style="text-align:right;" value="<%=clm_work_cost_total %>" readOnly>
							</div>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
									현장자재수입(ⓑ)<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" id="txt_work_income_total" name="txt_work_income_total" style="text-align:right;" value="<%=clm_work_income_total %>" readOnly>
							</div>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
									사업지출비용(ⓒ = ⓐ + ⓑ)<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" id="txt_work_calc_total" name="txt_work_calc_total" value="<%=clm_work_calc_total %>" style="text-align:right;" readOnly>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row no_print">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											공사 행정 진행 일정
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
										<!--
										<button type="button" class="btn btn-primary btn-sm" onClick="location.href='#'"> 등록 </button >
										-->
									</td>
								</tr>
							</table>
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<tbody>
									<tr>
										<td style="border-bottom: 1px solid white; text-align:center;"></td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('01');" id="a_work_process_01" name="a_work_process_01" <% if(clm_work_process_01.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												건축물해체허가신청기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('02');" id="a_work_process_02" name="a_work_process_02" <% if(clm_work_process_02.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												착공계제출
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('03');" id="a_work_process_03" name="a_work_process_03" <% if(clm_work_process_03.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												감리자계약
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('04');" id="a_work_process_04" name="a_work_process_04" <% if(clm_work_process_04.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												감리자지정
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('05');" id="a_work_process_05" name="a_work_process_05" <% if(clm_work_process_05.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												해체착공계제출
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('06');" id="a_work_process_06" name="a_work_process_06" <% if(clm_work_process_06.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												해체허가완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('07');" id="a_work_process_07" name="a_work_process_07" <% if(clm_work_process_07.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												비산먼지신고기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('08');" id="a_work_process_08" name="a_work_process_08" <% if(clm_work_process_08.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												비산먼지신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('09');" id="a_work_process_09" name="a_work_process_09" <% if(clm_work_process_09.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												특정공사신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('10');" id="a_work_process_10" name="a_work_process_10" <% if(clm_work_process_10.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												도로점용신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('11');" id="a_work_process_11" name="a_work_process_11" <% if(clm_work_process_11.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												건축물구조검토기간
											</a>
										</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;">계획</td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_01_schedule" name="spn_work_process_01_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_01_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_02_schedule" name="spn_work_process_02_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_02_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_03_schedule" name="spn_work_process_03_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_03_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_04_schedule" name="spn_work_process_04_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_04_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_05_schedule" name="spn_work_process_05_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_05_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_06_schedule" name="spn_work_process_06_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_06_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_07_schedule" name="spn_work_process_07_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_07_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_08_schedule" name="spn_work_process_08_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_08_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_09_schedule" name="spn_work_process_09_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_09_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_10_schedule" name="spn_work_process_10_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_10_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_11_schedule" name="spn_work_process_11_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_11_schedule %></span></td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">실행</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_01_date" name="spn_work_process_01_date" <% if(clm_work_process_01.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_01.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('01','<%=clm_work_process_01_date %>');" <% } %>><%=clm_work_process_01_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_02_date" name="spn_work_process_02_date" <% if(clm_work_process_02.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_02.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('02','<%=clm_work_process_02_date %>');" <% } %>><%=clm_work_process_02_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_03_date" name="spn_work_process_03_date" <% if(clm_work_process_03.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_03.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('03','<%=clm_work_process_03_date %>');" <% } %>><%=clm_work_process_03_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_04_date" name="spn_work_process_04_date" <% if(clm_work_process_04.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_04.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('04','<%=clm_work_process_04_date %>');" <% } %>><%=clm_work_process_04_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_05_date" name="spn_work_process_05_date" <% if(clm_work_process_05.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_05.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('05','<%=clm_work_process_05_date %>');" <% } %>><%=clm_work_process_05_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_06_date" name="spn_work_process_06_date" <% if(clm_work_process_06.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_06.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('06','<%=clm_work_process_06_date %>');" <% } %>><%=clm_work_process_06_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_07_date" name="spn_work_process_07_date" <% if(clm_work_process_07.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_07.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('07','<%=clm_work_process_07_date %>');" <% } %>><%=clm_work_process_07_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_08_date" name="spn_work_process_08_date" <% if(clm_work_process_08.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_08.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('08','<%=clm_work_process_08_date %>');" <% } %>><%=clm_work_process_08_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_09_date" name="spn_work_process_09_date" <% if(clm_work_process_09.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_09.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('09','<%=clm_work_process_09_date %>');" <% } %>><%=clm_work_process_09_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_10_date" name="spn_work_process_10_date" <% if(clm_work_process_10.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_10.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('10','<%=clm_work_process_10_date %>');" <% } %>><%=clm_work_process_10_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_11_date" name="spn_work_process_11_date" <% if(clm_work_process_11.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_11.equals("Y")){ %>onClick="JavaScript:$.fnc_work_progress_delete('11','<%=clm_work_process_11_date %>');" <% } %>><%=clm_work_process_11_date %></a></span></td>
									</tr>
									<tr>
										<td style="border-bottom: 1px solid white; text-align:center;"></td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('12');" id="a_work_process_12" name="a_work_process_12" <% if(clm_work_process_12.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												건축물구조검토완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('13');" id="a_work_process_13" name="a_work_process_13" <% if(clm_work_process_13.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												철거심의기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('14');" id="a_work_process_14" name="a_work_process_14" <% if(clm_work_process_14.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												철거심의완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('15');" id="a_work_process_15" name="a_work_process_15" <% if(clm_work_process_15.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												건설폐기물신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('16');" id="a_work_process_16" name="a_work_process_16" <% if(clm_work_process_16.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												석면신고기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('17');" id="a_work_process_17" name="a_work_process_17" <% if(clm_work_process_17.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												석면공사
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('18');" id="a_work_process_18" name="a_work_process_18" <% if(clm_work_process_18.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												해체완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('19');" id="a_work_process_19" name="a_work_process_19" <% if(clm_work_process_19.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												감리완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('20');" id="a_work_process_20" name="a_work_process_20" <% if(clm_work_process_20.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												멸실신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('21');" id="a_work_process_21" name="a_work_process_21" <% if(clm_work_process_21.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												등기정리
											</a>
										</td>
										<td style="padding:0px;" rowspan="3">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('22');" id="a_work_process_22" name="a_work_process_22" <% if(clm_work_process_22.equals("Y")){ %> style="background-color:#eee; font-weight:bold; padding:5px;"<% } %>>
												<img src="./img/task_alt_gray.png" style="width:10px; height:10px;">
												공사완료
											</a>
										</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;">계획</td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_12_schedule" name="spn_work_process_12_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_12_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_13_schedule" name="spn_work_process_13_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_13_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_14_schedule" name="spn_work_process_14_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_14_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_15_schedule" name="spn_work_process_15_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_15_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_16_schedule" name="spn_work_process_16_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_16_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_17_schedule" name="spn_work_process_17_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_17_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_18_schedule" name="spn_work_process_18_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_18_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_19_schedule" name="spn_work_process_19_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_19_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_20_schedule" name="spn_work_process_20_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_20_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_21_schedule" name="spn_work_process_21_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_21_schedule %></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:5px; border:1px solid white;"><span id="spn_work_process_22_schedule" name="spn_work_process_22_schedule" style="color:black; font-weight:bold;"><%=clm_work_process_22_schedule %></span></td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">실행</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_12_date" name="spn_work_process_12_date" <% if(clm_work_process_12.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_12.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('12','<%=clm_work_process_12_date %>');" <% } %>><%=clm_work_process_12_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_13_date" name="spn_work_process_13_date" <% if(clm_work_process_13.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_13.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('13','<%=clm_work_process_13_date %>');" <% } %>><%=clm_work_process_13_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_14_date" name="spn_work_process_14_date" <% if(clm_work_process_14.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_14.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('14','<%=clm_work_process_14_date %>');" <% } %>><%=clm_work_process_14_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_15_date" name="spn_work_process_15_date" <% if(clm_work_process_15.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_15.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('15','<%=clm_work_process_15_date %>');" <% } %>><%=clm_work_process_15_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_16_date" name="spn_work_process_16_date" <% if(clm_work_process_16.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_16.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('16','<%=clm_work_process_16_date %>');" <% } %>><%=clm_work_process_16_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_17_date" name="spn_work_process_17_date" <% if(clm_work_process_17.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_17.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('17','<%=clm_work_process_17_date %>');" <% } %>><%=clm_work_process_17_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_18_date" name="spn_work_process_18_date" <% if(clm_work_process_18.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_18.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('18','<%=clm_work_process_18_date %>');" <% } %>><%=clm_work_process_18_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_19_date" name="spn_work_process_19_date" <% if(clm_work_process_19.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_19.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('19','<%=clm_work_process_19_date %>');" <% } %>><%=clm_work_process_19_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_20_date" name="spn_work_process_20_date" <% if(clm_work_process_20.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_20.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('20','<%=clm_work_process_20_date %>');" <% } %>><%=clm_work_process_20_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_21_date" name="spn_work_process_21_date" <% if(clm_work_process_21.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_21.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('21','<%=clm_work_process_21_date %>');" <% } %>><%=clm_work_process_21_date %></a></span></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><span id="spn_work_process_22_date" name="spn_work_process_22_date" <% if(clm_work_process_22.equals("Y")){ %> style="background-color:red; color: white; font-weight:bold; padding:5px;"<% } %>><a href="#" <% if(clm_work_process_22.equals("Y")){ %> onClick="JavaScript:$.fnc_work_progress_delete('22','<%=clm_work_process_22_date %>');" <% } %>><%=clm_work_process_22_date %></a></span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											지 출
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
										<button type="button" class="btn btn-primary btn-sm no_print" onClick="JavaScript:$.fnc_cost_row_add();">등록</button>
									</td>
								</tr>
							</table>
							<table id="tbl_cost_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border:1px solid #ccc;">
								<thead>
									<tr>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:10%;">날 짜</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:15%;" colspan="2">품 명</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:5%;">규 격</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:5%;">수 량</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:10%;">단 가</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:10%;">금 액</th>
									</tr>
								</thead>
								<tbody>
<%
		try {
			Statement stmt_cost = conn.createStatement();
			strCondition = "";
			if(!_order_id_.equals("")) {
				strCondition += "and x.clm_order_id='" + _order_id_ + "' ";
			}
			query  = "";
			query += "select ";
			query += "x.*, ";
			query += "(select y.clm_code_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_id) y) clm_code_name, ";
			query += "(select y.clm_code_sub_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_sub_name, ";
			query += "(select y.clm_code_unit_type from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit_type, ";
			query += "(select y.clm_code_unit from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit ";
			query += "from ";
			query += "	tbl_work_sub_cost x ";
			query += "where 1=1 " + strCondition + " ";
			query += "order by x.clm_order_id desc, x.clm_order_cost_seq;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt_cost.executeQuery(query);

			reqDateStr = "";
			reqDateTime = 0;
			curDateTime = 0;
			minute = 0;
			duration_minute = "";

			int iSubRowCnt = 0;
			while (rs.next()) {
				String clm_cost_order_id        = rs.getString("clm_order_id");
				String clm_cost_order_cost_seq  = rs.getString("clm_order_cost_seq");
				String clm_cost_cost_id         = rs.getString("clm_cost_id");
				String clm_cost_cost_sub_id     = rs.getString("clm_cost_sub_id");
				String clm_cost_cost_count      = String.format("%,d", Integer.parseInt(rs.getString("clm_cost_count")));
				String clm_cost_del_yn          = rs.getString("clm_del_yn");
				String clm_cost_comment         = rs.getString("clm_comment");
				String clm_cost_reg_datetime    = rs.getString("clm_reg_datetime");
				String clm_cost_reg_user_id     = rs.getString("clm_reg_user_id");
				String clm_cost_update_datetime = rs.getString("clm_update_datetime");
				String clm_cost_update_user_id  = rs.getString("clm_update_user_id");
				String clm_cost_employee_seq     = rs.getString("clm_employee_seq");
				String clm_cost_cost_count_unit     = rs.getString("clm_cost_count_unit");
				String clm_cost_cost_count_type     = rs.getString("clm_cost_count_type");
				String clm_cost_code_name     = rs.getString("clm_code_name");
				String clm_cost_code_sub_name     = rs.getString("clm_code_sub_name");
				String clm_cost_code_unit     = rs.getString("clm_code_unit");
				String clm_cost_code_unit_type     = rs.getString("clm_code_unit_type");
				String clm_cost_cost_price			= rs.getString("clm_cost_unit_price").replace(",", "");
				String clm_cost_date				= rs.getString("clm_cost_date");
				String clm_cost_cost_price_format	= String.format("%,d", Integer.parseInt(clm_cost_cost_price));
				clm_cost_cost_price			= clm_cost_cost_price.replaceAll(",", "");
				String clm_cost_cost_total_price			= String.format("%,d", Integer.parseInt(clm_cost_cost_price) * Integer.parseInt(rs.getString("clm_cost_count")));
%>
									<tr id="tr_cost_<%=iSubRowCnt %>">
										<td style="padding:5px; border:1px solid #ccc; text-align:center;">
											<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_date %>" id="txt_cost_date" name="txt_cost_date" placeholder="YYYY-MM-DD" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">
											<input type="text" style="width:100%; padding:5px; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_code_name %>" id="txt_cost_code_name" name="txt_cost_code_name" readOnly>
											<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_id %>" id="txt_cost_code_id" name="txt_cost_code_id">
											<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_sub_id %>" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">
										</td>
										<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;">
											<button type="button" style="font-size:8px; width:45px; background-color:#fff; border:0px solid #fff;" data-param_01="<%=iSubRowCnt %>" data-param_02="0001" data-toggle="modal" id="btn_cost_code_list" name="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);" disabled></button>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:center;">
											<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_code_unit %>" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly>
											<input type="hidden" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_code_sub_name %>" id="txt_income_code_sub_name" name="txt_income_code_sub_name" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_cost_count %>" onKeyUp="JavaScript:$.fnc_only_number('C', this, '<%=iSubRowCnt %>');" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_cost_price_format %>" id="txt_cost_cost_price" name="txt_cost_cost_price" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_cost_total_price %>" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly>
										</td>
									</tr>
<%
				iSubRowCnt++;
			}

			if(iSubRowCnt==0) {
%>
									<tr id="tr_cost_empty">
										<td colspan="8" style="text-align:center;">등록된 지출 내역이 없습니다.</td>
									</tr>
<%
			}

			stmt_cost.close();
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}
%>
								</tbody>
							</table>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											수 입
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
										<!--
										<input type="text" id="datetimepicker-default" placeholder="" style="border:1px solid #999;" />
										<button type="button" class="btn btn-success btn-sm" onClick="location.href='#'"> 조회 </button >
										-->
										<button type="button" class="btn btn-primary btn-sm no_print" onClick="JavaScript:$.fnc_income_row_add();">등록</button>
									</td>
								</tr>
							</table>
							<table id="tbl_income_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border:1px solid #ccc;">
								<thead>
									<tr>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:10%;">날 짜</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:15%;" colspan="2">품 명</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:5%;">규 격</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:5%;">수 량</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:10%;">단 가</th>
										<th style="font-size:12px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:10%;">금 액</th>
									</tr>
								</thead>
								<tbody>
<%
		try {
			strCondition = "";
			if(!_order_id_.equals("")) {
				strCondition += "and x.clm_order_id='" + _order_id_ + "' ";
			}
			query  = "";
			query += "select ";
			query += "x.*, ";
			query += "(select y.clm_code_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_id) y) clm_code_name, ";
			query += "(select y.clm_code_sub_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_sub_name, ";
			query += "(select y.clm_code_unit_type from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit_type, ";
			query += "(select y.clm_code_unit from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit ";
			query += "from ";
			query += "	tbl_work_sub_income x ";
			query += "where 1=1 " + strCondition + " ";
			query += "order by x.clm_order_id desc, x.clm_order_cost_seq;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			rs = stmt.executeQuery(query);

			reqDateStr = "";
			reqDateTime = 0;
			curDateTime = 0;
			minute = 0;
			duration_minute = "";

			int iSubRowCnt = 0;
			while (rs.next()) {
				String clm_cost_order_id			= rs.getString("clm_order_id");
				String clm_cost_order_cost_seq		= rs.getString("clm_order_cost_seq");
				String clm_cost_cost_id				= rs.getString("clm_cost_id");
				String clm_cost_cost_sub_id			= rs.getString("clm_cost_sub_id");
				String clm_cost_cost_count			= String.format("%,d", Integer.parseInt(rs.getString("clm_cost_count")));
				String clm_cost_del_yn				= rs.getString("clm_del_yn");
				String clm_cost_comment				= rs.getString("clm_comment");
				String clm_cost_reg_datetime		= rs.getString("clm_reg_datetime");
				String clm_cost_reg_user_id			= rs.getString("clm_reg_user_id");
				String clm_cost_update_datetime		= rs.getString("clm_update_datetime");
				String clm_cost_update_user_id		= rs.getString("clm_update_user_id");
				String clm_cost_employee_seq		= rs.getString("clm_employee_seq");
				String clm_cost_cost_count_unit		= rs.getString("clm_cost_count_unit");
				String clm_cost_cost_count_type		= rs.getString("clm_cost_count_type");
				String clm_cost_code_name			= rs.getString("clm_code_name");
				String clm_cost_code_sub_name		= rs.getString("clm_code_sub_name");
				String clm_cost_code_unit			= rs.getString("clm_code_unit");
				String clm_cost_code_unit_type		= rs.getString("clm_code_unit_type");
				String clm_cost_cost_price			= rs.getString("clm_cost_unit_price").replace(",", "");
				String clm_cost_date				= rs.getString("clm_cost_date");
				String clm_cost_cost_price_format	= String.format("%,d", Integer.parseInt(clm_cost_cost_price));
				clm_cost_cost_price					= clm_cost_cost_price.replaceAll(",", "");
				String clm_cost_cost_total_price	= String.format("%,d", Integer.parseInt(clm_cost_cost_price) * Integer.parseInt(rs.getString("clm_cost_count")));
%>
									<tr id="tr_income_<%=iSubRowCnt %>">
										<td style="padding:5px; border:1px solid #ccc; text-align:center;">
											<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_date %>" id="txt_income_date" name="txt_income_date" onKeyup="JavaScript:fnc_input_date_format(this);" placeholder="YYYY-MM-DD" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">
											<input type="text" style="width:100%; padding:5px; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_code_name %>" id="txt_income_code_name" name="txt_income_code_name" readOnly>
											<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_id %>" id="txt_income_code_id" name="txt_income_code_id">
											<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_sub_id %>" id="txt_income_code_sub_id" name="txt_income_code_sub_id">
										</td>
										<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;">
											<button type="button" style="font-size:8px; width:45px; background-color:#fff; border:0px solid #fff;" data-param_01="<%=iSubRowCnt %>" data-param_02="0004" data-toggle="modal" id="btn_income_code_list" name="btn_income_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);" disabled></button>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:center;">
											<input type="hidden" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_code_sub_name %>" id="txt_income_code_sub_name" name="txt_income_code_sub_name" readOnly>
											<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_code_unit %>" id="txt_income_code_unit" name="txt_income_code_unit" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_cost_count %>" onKeyUp="JavaScript:$.fnc_only_number('I', this, '<%=iSubRowCnt %>');" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_cost_price_format %>" id="txt_income_cost_price" name="txt_income_cost_price" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid #fff;" value="<%=clm_cost_cost_total_price %>" id="txt_income_cost_total_price" name="txt_income_cost_total_price" readOnly>
										</td>
									</tr>
<%
				iSubRowCnt++;
			}

			if(iSubRowCnt==0) {
%>
									<tr id="tr_income_empty">
										<td colspan="8" style="text-align:center;">등록된 수입 내역이 없습니다.</td>
									</tr>
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}
%>
								</tbody>
							</table>
						</div>
						<%@ include file="include/modal/modal_cost_code.jsp" %>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
								 견적가액(ⓓ)<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="txt_estimation_price" name="txt_estimation_price" class="form-control" value="<%=clm_estimation_price %>" style="text-align:right;">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label for="regular1" class="control-label">
								 견적가액 대비 손익대차(ⓔ = ⓓ - ⓒ)<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="txt_estimation_work_diff" name="txt_estimation_work_diff" value="<%=clm_estimation_work_diff %>" class="form-control" style="text-align:right;">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
							   <label for="regular1" class="control-label">
								 주소<span style="font-weight:bold !important; color:red !important;">*</span>
							   </label>
							   <input type="text" id="txt_building_address" name="txt_building_address" class="form-control" value="<%=clm_building_address %>" readOnly>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
							   <label for="regular1" class="control-label">
								 건축물구조<span style="font-weight:bold !important; color:red !important;">*</span>
							   </label>
							   <input type="text" id="txt_building_type" name="txt_building_type" class="form-control" value="<%=clm_building_type %>" readOnly>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">층고</label>
							<input type="text" class="mat-input form-control" id="txt_building_height" name="txt_building_height" value="<%=clm_building_height %>" readOnly>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">연면적</label>
							<input type="text" class="mat-input form-control" id="txt_building_volume" name="txt_building_volume" value="<%=clm_building_volume %>" readOnly>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">대지면적</label>
							<input type="text" class="mat-input form-control" id="txt_building_base_volume" name="txt_building_base_volume" value="<%=clm_building_base_volume %>" readOnly>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">
								해체신고여부
							</label>
							<input type="text" id="txt_building_deconstruction_report_yn_name" name="txt_building_deconstruction_report_yn_name" class="form-control" value="<%=clm_building_deconstruction_report_yn %>" data-param_01="0" data-param_02="0003" data-toggle="modal" readOnly>
							<input type="hidden" id="txt_building_deconstruction_report_yn" name="txt_building_deconstruction_report_yn" class="form-control" value="<%=clm_building_deconstruction_report_yn %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">평연면적(py)</label>
							<input type="text" class="mat-input form-control" id="txt_building_volume_py" name="txt_building_volume_py" value="<%=clm_building_volume_py %>" readOnly>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">평대지면적(py)</label>
							<input type="text" class="mat-input form-control" id="txt_building_base_volume_py" name="txt_building_base_volume_py" value="<%=clm_building_base_volume_py %>" readOnly>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label print_margin_bottom">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" style="ta_comment;" name="ta_comment" readOnly><%=clm_comment %></textarea>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row no_print">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											첨부파일
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
										<!--
										<button type="button" class="btn btn-primary btn-sm" onClick="JavaScript:$.fnc_file_row_add();"> 등록 </button>
										-->
									</td>
								</tr>
							</table>
							<table id="tbl_file_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;">No.</th>
										<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;">파일명</th>
										<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;">파일크기</th>
										<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;">다운로드</th>
										<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;">삭제</th>
									</tr>
								</thead>
								<tbody>
<%
		try {
			Statement stmt_file = conn.createStatement();
			strCondition = "";
			if(!_order_id_.equals("")) {
				strCondition += "and x.clm_order_id='" + _order_id_ + "' ";
			}
			query  = "";
			query += "select x.* ";
			query += "  from tbl_work_file x ";
			query += " where 1=1 and x.clm_del_yn='N' " + strCondition + " ";
			query += " order by x.clm_order_id desc, x.clm_order_file_seq;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			ResultSet rs_file = stmt_file.executeQuery(query);

			reqDateStr = "";
			reqDateTime = 0;
			curDateTime = 0;
			minute = 0;
			duration_minute = "";

			String saveFolderRootLogical = "/ESTIMATION/GAGA/files";
			String iSubRowCntFormatted = "";

			int iSubRowCnt = 0;
			while (rs_file.next()) {
				String clm_file_order_id        = rs_file.getString("clm_order_id");
				String clm_file_order_file_seq  = rs_file.getString("clm_order_file_seq");
				String clm_file_file_id         = rs_file.getString("clm_file_id");
				String clm_file_file_name       = rs_file.getString("clm_file_name");
				String clm_file_file_ext        = rs_file.getString("clm_file_ext");
				String clm_file_file_size       = rs_file.getString("clm_file_size");
				String clm_file_process_type    = rs_file.getString("clm_process_type");
				String clm_file_del_yn          = rs_file.getString("clm_del_yn");
				String clm_file_comment         = rs_file.getString("clm_comment");
				String clm_file_reg_datetime    = rs_file.getString("clm_reg_datetime");
				String clm_file_reg_user_id     = rs_file.getString("clm_reg_user_id");
				String clm_file_update_datetime = rs_file.getString("clm_update_datetime");
				String clm_file_update_user_id  = rs_file.getString("clm_update_user_id");
				String clm_file_file_path       = rs_file.getString("clm_file_path");
				String clm_file_real_name       = rs_file.getString("clm_file_real_name");
				String clm_file_file_full_name = clm_file_file_name + "." + clm_file_file_ext;
				String clm_file_download_path   = saveFolderRootLogical + "/" + clm_file_order_id + "/" + clm_file_real_name;

				Long lng_file_file_size = Long.parseLong(clm_file_file_size);

				iSubRowCntFormatted = String.format("%02d", iSubRowCnt);
				clm_file_file_size = String.format("%,d", lng_file_file_size);
%>
									<tr id="tr_file_<%=iSubRowCnt %>">
										<td Style="border:1px solid #ccc; width:5%; text-align:center;"><%=iSubRowCnt+1 %></td>
										<td Style="border:1px solid #ccc; width:65%; text-align:left;"><%=clm_file_real_name %></td>
										<td Style="border:1px solid #ccc; width:10%; text-align:right;"><%=clm_file_file_size %> kb</td>
										<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;">
											<a href="<%=clm_file_download_path %>" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_download">다운로드</a>
										</td>
										<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;">
											<a <% if(clm_order_state_type.equals("A") || clm_order_state_type.equals("B")){ %> href="javascript:$.work_file_delete('<%=clm_file_order_id %>','<%=clm_file_order_file_seq %>');" <% } %> class="btn btn-danger next" style="font-size:8px; padding:10px;" id="btn_file_delete" <% if(clm_order_state_type.equals("C") || clm_order_state_type.equals("D")){ %> disabled <% } %>>삭제</a>
										</td>
									</tr>
<%
				iSubRowCnt++;
			}

			if(iSubRowCnt==0) {
%>
									<tr id="tr_file_empty">
										<td colspan="8" style="text-align:center;">등록된 파일이 없습니다.</td>
									</tr>
<%
			}

			stmt_file.close();
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}
%>
								</tbody>
							</table>
						</div>
					</div>
				<div>
					<a href="work_list.jsp" class="btn btn-primary next">목록</a>
					<% if(clm_order_state_type.equals("B")){ %>
						<a href="javascript:void(0);" class="btn btn-success next" onClick="JavaScript:$.fnc_report_data_save();">수정</a>
						<a href="#" onClick="JavaScript:$.fnc_report_state_change('<%=clm_order_id %>', 'C');" class="btn btn-danger next" id="btn_order_cancel" name="btn_order_cancel">주문취소</a>
						<a href="#" onClick="JavaScript:$.fnc_report_state_change('<%=clm_order_id %>', 'D');" class="btn btn-success next" id="btn_order_complete" name="btn_order_complete">완료</a>
					<% }else if(clm_order_state_type.equals("C")){ %>

					<% }else if(clm_order_state_type.equals("D")){ %>

					<% } %>
					<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_print();">인쇄</button>
					<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_pdf_download();">PDF 다운로드</button>
				</div>
			</div> <!-- section content end -->
			</form>
		</div>
		</div>
		<!-- Card Footer -->
		<div class="pmd-card-footer">
		</div>
	</div>
</div>
<div class="modal fade" id="div_alert_modal" role="dialog">
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">메시지</h4>
			</div>
			<div class="modal-body">
				<p id="p_alert_msg" style="font-size:14px;"></p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal" style="font-size:14px;" id="btn_confirm">확&nbsp;인</button>
			</div>
		</div>

	</div>
</div>
<%
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
%>
<!--tab start-->

<!--content area end-->

</div>

<!-- Footer Starts -->
<%@ include file="include/footer.jsp" %>
<!-- Footer Ends -->

<!-- Scripts Starts -->
<script src="assets/js/jquery-1.12.2.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/propeller.min.js"></script>
<!-- css 파일 -->
<link rel="stylesheet" href="https://nowonbun.github.io/Loader/loader.css">
<!-- javascript 파일 -->
<script type="text/javascript" src="https://nowonbun.github.io/Loader/loader.js"></script>

<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script>
	$(document).ready(function() {
		var sPath=window.location.pathname;
		var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
		$(".pmd-sidebar-nav").each(function(){
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").addClass("open");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('.dropdown-menu').css("display", "block");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('a.dropdown-toggle').addClass("active");
			$(this).find("a[href='"+sPage+"']").addClass("active");
		});
		$(".auto-update-year").html(new Date().getFullYear());
	});
</script>

<!-- Scripts Ends -->

<!--detail page table data expand collapse javascript-->
<script type="text/javascript">
$(document).ready(function () {
	$(".direct-expand").click(function(){
		$(".direct-child-table").slideToggle(300);
		$(this).toggleClass( "child-table-collapse" );
	});
});
</script>
<!-- Scripts Ends -->
<!-- Select2 js-->
<script type="text/javascript" src="components/select2/js/select2.full.js"></script>

<!-- Propeller Select2 -->
<script type="text/javascript">
	$(document).ready(function() {
		<!-- Simple Selectbox -->
		$(".select-simple").select2({
			theme: "bootstrap",
			minimumResultsForSearch: Infinity,
		});
		<!-- Selectbox with search -->
		$(".select-with-search").select2({
			theme: "bootstrap"
		});
		<!-- Select Multiple Tags -->
		$(".select-tags").select2({
			tags: false,
			theme: "bootstrap",
		});
		<!-- Select & Add Multiple Tags -->
		$(".select-add-tags").select2({
			tags: true,
			theme: "bootstrap",
		});
	});
</script>
<script type="text/javascript" src="components/select2/js/pmd-select2.js"></script>
<script>
	$(document).ready(function() {
		var sPath=window.location.pathname;
		var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
		$(".pmd-sidebar-nav").each(function(){
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").addClass("open");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('.dropdown-menu').css("display", "block");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('a.dropdown-toggle').addClass("active");
			$(this).find("a[href='"+sPage+"']").addClass("active");
		});

		$.fnc_work_progress_check = function(process_id) {
			jQuery.ajax({
				url: 'work_info_process_proc.jsp',
				data: { '_order_id_':'<%=_order_id_ %>', '_work_process_':process_id },
				error : function(){
					console.log('error');
					$("#p_alert_msg").html("변경 사항에 실패하였습니다.");
					$('#div_alert_modal').modal("show");
					loader.off();
				},
				beforeSend : function(){
					loader.on(function(){
					});
				},
				success: function(result){
					var order_data = result;
					var work_date = '';

					console.log('success');
					loader.off();

					jQuery.each(order_data, function(key, value){
						if(key=='order_data') {
							for(var i=0; i<value.length; i++) {
								work_date = value[i].work_date;
								// console.log('> work_date ' + work_date);
								$('span[name=spn_work_process_' + process_id + '_date]').text('');
								$('span[name=spn_work_process_' + process_id + '_date]').text(work_date);
								$('span[name=spn_work_process_' + process_id + '_date]').css('background-color', 'red');
								$('span[name=spn_work_process_' + process_id + '_date]').css('color', 'white');
								$('span[name=spn_work_process_' + process_id + '_date]').css('padding', '5px');
								$('a[name=a_work_process_' + process_id + ']').css('background-color', '#eee');
								// $('a[name=a_work_process_' + process_id + ']').css('color', 'white');
								$('a[name=a_work_process_' + process_id + ']').css('padding', '5px');
							}
						}
					});
				}
			});
		}

		$.fnc_work_progress_delete = function(process_id, process_date) {
			var process_name = '';
			if(process_id == '01'){
				process_name = '건축물해체허가신청기간';
			}else if(process_id == '02'){
				process_name = '착공계제출';
			}else if(process_id == '03'){
				process_name = '감리자계약';
			}else if(process_id == '04'){
				process_name = '감리자지정';
			}else if(process_id == '05'){
				process_name = '해체착공계제출';
			}else if(process_id == '06'){
				process_name = '해체허가완료';
			}else if(process_id == '07'){
				process_name = '비산먼지신고기간';
			}else if(process_id == '08'){
				process_name = '비산먼지신고';
			}else if(process_id == '09'){
				process_name = '특정공사신고';
			}else if(process_id == '10'){
				process_name = '도로점용신고';
			}else if(process_id == '11'){
				process_name = '건축물구조검토기간';
			}else if(process_id == '12'){
				process_name = '건축물구조검토완료';
			}else if(process_id == '13'){
				process_name = '철거심의기간';
			}else if(process_id == '14'){
				process_name = '철거심의완료';
			}else if(process_id == '15'){
				process_name = '건설폐기물신고';
			}else if(process_id == '16'){
				process_name = '석면신고기간';
			}else if(process_id == '17'){
				process_name = '석면공사';
			}else if(process_id == '18'){
				process_name = '해체완료';
			}else if(process_id == '19'){
				process_name = '감리완료';
			}else if(process_id == '20'){
				process_name = '멸실신고';
			}else if(process_id == '21'){
				process_name = '등기정리';
			}else if(process_id == '22'){
				process_name = '공사완료';
			}

			if(confirm(process_name + ' 실행일자 '+process_date + '를 삭제하시겠습니까?')){
				jQuery.ajax({
					url: './work_info_process_delete_proc.jsp',
					data: { 'order_id': '<%=_order_id_ %>', 'process_id':process_id, 'process_date':process_date },
					error : function(){
						console.log('error');
						$("#p_alert_msg").html("변경사항에 실패하였습니다.");
						$('#div_alert_modal').modal("show");
					},
					beforeSend : function(){
					},
					success: function(result){
						location.reload();
					}
				});
			}
		}

		// $('input[name=txt_cost_date]').datetimepicker({
		// 	format: 'YYYY-MM-DD',
		// 	useCurrent: false,
		// });

		$.fnc_datepicker = function(obj) {
			// console.log('> ' + $(obj).attr('id'));
			$('input[id=' + $(obj).attr('id') + ']').datetimepicker({
				format: 'YYYY/MM/DD',
				useCurrent: false,
			});
			/*
			$(obj).datepicker({
				format: 'YYYY/MM/DD',
				useCurrent: false,
			});
			*/
		};

		$.fnc_cost_row_add = function() {
			var empty_check = $("tr[id='tr_cost_empty']").length;
			var seq = 0;
			var today = $.fnc_today();
			if(Number(empty_check)>0) {
 				$('#tbl_cost_item_list > tbody:last').remove();
				$('#tbl_cost_item_list').append('<tbody></tbody>');
				// seq = 1;
			}
			else {
				seq = $("input[id='txt_cost_date']").length;
			}

			seq += 1;

			var tags = '';
			tags += '<tr id="tr_cost_' + seq + '">';
			// tags += '	<td style="text-align:center;">' + seq + '</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff;" value="' + today + '" id="txt_cost_date" name="txt_cost_date" onKeyup="JavaScript:fnc_input_date_format(this);" placeholder="YYYY-MM-DD" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">';
			tags += '		<input type="text" id="txt_cost_code_name" name="txt_cost_code_name" style="width:100%; padding:5px; background-color:#eee;" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_id" name="txt_cost_code_id">';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">';
			tags += '	</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;"><button type="button" style="font-size:8px; width:45px;" data-param_01="' +  seq + '" data-param_02="0001" data-toggle="modal" id="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);">선 택</button></td>';

			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;">';
			tags += '		<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly>';
			tags += '	</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right;" value=""  onKeyUp="JavaScript:$.fnc_only_number(\'C\', this, \'' + seq + '\');"></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_price" name="txt_cost_cost_price" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly></td>';
			// tags += '	<td style="padding:5px; border:1px solid #ccc;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee; background-color:#eee;" value="" id="txt_cost_comment" name="txt_cost_comment" readOnly></td>';
			tags += '</tr>';

			$('#tbl_cost_item_list tbody').append(tags);
		}

		$.fnc_income_row_add = function() {
			var empty_check = $("tr[id='tr_income_empty']").length;
			var seq = 0;
			var today = $.fnc_today();
			if(Number(empty_check)>0) {
 				$('#tbl_income_item_list > tbody:last').remove();
				$('#tbl_income_item_list').append('<tbody></tbody>');
				// seq = 1;
			} else {
				seq = $("input[id='txt_income_date']").length;
			}

			seq += 1;

			// var seq = $("input[id='txt_cost_code_sub_name']").length;
			// seq = Number(seq);

			var tags = '';
			tags += '<tr id="tr_income_' + seq  + '">';
			// tags += '	<td style="text-align:center;">' + seq + '</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff;" value="' + today + '" id="txt_income_date" name="txt_income_date" onKeyup="JavaScript:fnc_input_date_format(this);" placeholder="YYYY-MM-DD" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">';
			tags += '		<input type="text" id="txt_income_code_name" name="txt_income_code_name" style="width:100%; padding:5px; background-color:#eee" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_income_code_id" name="txt_income_code_id">';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_income_code_sub_id" name="txt_income_code_sub_id">';
			tags += '	</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;"><button type="button" style="font-size:8px; width:45px;" data-param_01="' +  seq + '" data-param_02="0004" data-toggle="modal" id="btn_income_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);">선 택</button></td>';

			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;">';
			tags += '		<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_income_code_unit" name="txt_income_code_unit" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_income_code_sub_name" name="txt_income_code_sub_name" readOnly>';
			tags += '	</td>';

			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" id="txt_income_cost_count" name="txt_income_cost_count" style="width:100%; padding:5px; text-align:right;" value=""  onKeyUp="JavaScript:$.fnc_only_number(\'I\', this, \'' + seq + '\');"></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_income_cost_price" name="txt_income_cost_price" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_income_cost_total_price" name="txt_income_cost_total_price" readOnly></td>';
			// tags += '	<td style="padding:5px; border:1px solid #ccc;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee; background-color:#eee;" value="" id="txt_cost_comment" name="txt_cost_comment" readOnly></td>';
			tags += '</tr>';

			$('#tbl_income_item_list tbody').append(tags);
		}

		$.fnc_file_row_add = function() {
			var empty_check = $("tr[id='tr_file_empty']").length;
			var seq = 0;
			if(Number(empty_check)>0) {
 				$('#tbl_file_item_list > tbody:last').remove();
				$('#tbl_file_item_list').append('<tbody></tbody>');
				// seq = 1;
			}
			else {
				seq = $("a[id='btn_file_download']").length-1;
			}

			var tags = '';
			tags += '<tr id="tr_file_' + seq  + '">';
			tags += '	<td Style="border:1px solid #ccc; width:5%; text-align:center;">' + seq + '</td>';
			tags += '	<td Style="border:1px solid #ccc; width:65%; text-align:left;"><input type="file" id="fl_attached_file" name="fl_attached_file" style="width:100%;"></td>';
			tags += '	<td Style="border:1px solid #ccc; width:10%; text-align:right;">0kb</td>';
			tags += '	<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;"><a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_download" disabled>다운로드</a></td>';
			tags += '	<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;"><a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_delete" disabled>삭제</a></td>';
			tags += '</tr>';

			$('#tbl_file_item_list tbody').append(tags);
		}

		$.fnc_modal_cost_code = function(obj) {
			var param_01 = $(obj).data('param_01');
			var param_02 = $(obj).data('param_02');
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_cost_code_list.jsp?seq=' + param_01 + '&code_id=' + param_02);
			$('#form-dialog_cost_code').modal('show');
			console.log(obj);
			if(obj.id == 'txt_building_type'){
				console.log('건축물구조 목록');
				$('#modal_title').text('건축물구조 목록');
			}else if(obj.id == 'btn_cost_code_list'){
				console.log('지출품목 목록');
				$('#modal_title').text('지출품목 목록');
			}else if(obj.id == 'btn_income_code_list'){
				console.log('수입품목 목록');
				$('#modal_title').text('수입품목 목록');
			}else if(obj.id == 'txt_building_deconstruction_report_yn_name'){
				console.log('해체신고여부 목록');
				$('#modal_title').text('해체신고여부 목록');
			}
		};

		$.fnc_select_to_parent = function(seq, code_id, code_sub_id, code_name, code_sub_name, code_unit, code_price, code_comment) {
			seq = seq - 1;
			if(code_id=='0001') {
				var cost_count = 0;
				var cost_total_price = Number(code_price)*cost_count;
				code_price = code_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
				$('input[name=txt_cost_code_name]').eq(Number(seq)).val(code_name);
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).val(code_sub_name);
				$('input[name=txt_cost_code_id]').eq(Number(seq)).val(code_id);
				$('input[name=txt_cost_code_sub_id]').eq(Number(seq)).val(code_sub_id);
				$('input[name=txt_cost_code_unit]').eq(Number(seq)).val(code_unit);
				$('input[name=txt_cost_cost_count]').eq(Number(seq)).val(cost_count);
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).val(code_price);
				$('input[name=txt_cost_cost_total_price]').eq(Number(seq)).val(cost_total_price);
				$('input[name=txt_cost_comment]').eq(Number(seq)).val(code_comment);
			}
			else if(code_id=='0004') {
				var cost_count = 0;
				var cost_total_price = Number(code_price)*cost_count;
				code_price = code_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
				$('input[name=txt_income_code_name]').eq(Number(seq)).val(code_name);
				$('input[name=txt_income_code_sub_name]').eq(Number(seq)).val(code_sub_name);
				$('input[name=txt_income_code_id]').eq(Number(seq)).val(code_id);
				$('input[name=txt_income_code_sub_id]').eq(Number(seq)).val(code_sub_id);
				$('input[name=txt_income_code_unit]').eq(Number(seq)).val(code_unit);
				$('input[name=txt_income_cost_count]').eq(Number(seq)).val(cost_count);
				$('input[name=txt_income_cost_price]').eq(Number(seq)).val(code_price);
				$('input[name=txt_income_cost_total_price]').eq(Number(seq)).val(cost_total_price);
				$('input[name=txt_income_comment]').eq(Number(seq)).val(code_comment);
			}

			$('#form-dialog_cost_code').modal('hide');
		};
		
		$.fnc_report_state_change = function(order_id, order_state_type) {
			jQuery.ajax({
				url: './estimation_info_change_proc.jsp',
				data: { 'txt_order_id':order_id, 'txt_process_type':order_state_type },
				error : function(){
					console.log('error');
					$("#p_alert_msg").html("변경사항에 실패하였습니다.");
					$('#div_alert_modal').modal("show");
				},
				beforeSend : function(){
				},
				success: function(result){
					location.reload();
				}
			});
		}

		$.fnc_only_number = function(obj, seq) {
		 	if ($(obj).val() != null && $(obj).val() != '') {
		 		var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				var code_price = $('input[name=txt_cost_cost_price]').eq(Number(seq)).val().replace(/,/gi, '');
				var cost_total_price = Number(code_price)*tmps;
		 		cost_total_price = cost_total_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
				$('input[name=txt_cost_cost_total_price]').eq(Number(seq)).val(cost_total_price);
		 		var tmps2 = tmps.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
		 		$(obj).val(tmps2);
		 	}
		}

		$.fnc_only_number = function(type, obj, seq) {
			// seq = seq - 1;
			var income_total = 0;
			var cost_total = 0;

			seq -= 1;
			if(type == 'C') {
				if ($(obj).val() != null && $(obj).val() != '') {
					var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
					var code_price = $('input[name=txt_cost_cost_price]').eq(Number(seq)).val().replace(/,/gi, '');
					//console.log('code_price : ' + code_price);
					var cost_total_price = Number(code_price)*tmps;
					cost_total_price = cost_total_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
					//console.log('cost_total_price : ' + cost_total_price);
					$('input[name=txt_cost_cost_total_price]').eq(Number(seq)).val(cost_total_price);
					var tmps2 = tmps.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
					$(obj).val(tmps2);

					var cost_array = [];
					cost_array = $('input[name=txt_cost_cost_total_price]');
					var total = 0;

					for(var i=0; i<cost_array.length; i++) {
						//console.log('> cost ' + i + ' ' + cost_array.eq(i).val());
						total += Number(cost_array.eq(i).val().replace(/,/gi, ''));
					}

					cost_total = total;

					//console.log('> cost_total ' + total);
					$('input[name=txt_work_cost_total]').val(total.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'));
				}
			}else if(type == 'I') {
				if ($(obj).val() != null && $(obj).val() != '') {
					var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
					var code_price = $('input[name=txt_income_cost_price]').eq(Number(seq)).val().replace(/,/gi, '');
					//console.log('code_price : ' + code_price);
					var cost_total_price = Number(code_price)*tmps;
					cost_total_price = cost_total_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
					//console.log('cost_total_price : ' + cost_total_price);
					$('input[name=txt_income_cost_total_price]').eq(Number(seq)).val(cost_total_price);
					var tmps2 = tmps.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
					$(obj).val(tmps2);

					var cost_array = [];
					cost_array = $('input[name=txt_income_cost_total_price]');
					var total = 0;

					for(var i=0; i<cost_array.length; i++) {
						//console.log('> income ' + cost_array.eq(i).val());
						total += Number(cost_array.eq(i).val().replace(/,/gi, ''));
					}

					total = total * -1;

					//console.log('> income_total ' + total);
					$('input[name=txt_work_income_total]').val(total.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'));
				}
			}

			var work_cost_total = Number($('input[name=txt_work_cost_total]').val().replace(/[^0-9]/g, ''));
			console.log('> work_cost_total ['+work_cost_total+']');
			var work_income_total = Number($('input[name=txt_work_income_total]').val().replace(/[^0-9]/g, ''));
			console.log('> work_income_total ['+work_income_total+']');
			var cost_total = work_cost_total + work_income_total;
			$('input[name=txt_work_calc_total]').val(cost_total.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'));
			var work_calc_total = Number($('input[name=txt_work_calc_total]').val().replace(/[^0-9]/g, ''));
			var estimation_price = Number($('input[name=txt_estimation_price]').val().replace(/[^0-9]/g, ''));
			// console.log('> work_calc_total ' + work_calc_total);
			var estimation_work_diff = estimation_price - work_calc_total;
			$('input[name=txt_estimation_work_diff]').val(estimation_work_diff.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'));
		}

		$.fnc_report_data_save = function() {
			$('#txt_process_type').val('S');
			jQuery.ajax({
				url: 'work_info_save_proc.jsp',
				data: $('#frm_order_data').serialize(),
				error : function(){
					console.log('error');
					$("#p_alert_msg").html("변경사항에 실패하였습니다.");
					$('#div_alert_modal').modal("show");
					loader.off();
				},
				beforeSend : function(){
					loader.on(function(){
					});
				},
				success: function(result){
					console.log('success');
					loader.off();
				}
			});
		}

		$.work_file_delete = function(order_file_id, order_file_seq) {
			$.ajax({
				url: './work_file_data_delete_proc.jsp',
				data: { '_order_id_':order_file_id, '_file_seq_':order_file_seq },
				error : function(request, status, error){
					$("#p_alert_msg").html('파일 삭제에 실패 하였습니다.');
					$('#div_alert_modal').modal("show");
					loader.off();
				},
				beforeSend : function(){
					loader.on();
				},
				success: function(result){
					loader.off();
					location.reload();
				}
			});
		}

		$.py_calculator = function(origin_type, obj){
			var volume_value = 0;

			if(origin_type==1){ volume_value = parseFloat($(obj).val()) * 3.3058; }
			else if(origin_type==2){ volume_value = parseFloat($(obj).val()) / 3.3058;}

			return volume_value;
		}

		$.fnc_today = function() {
			var today = new Date();
			var year = today.getFullYear();
			var month = today.getMonth() + 1;
			var date = today.getDate();

			var today_string = year + '-';
			if(Number(month) >= 10){
				today_string = today_string + month + '-';
			}else{
				today_string = today_string + '0' + month + '-';
			}

			if(Number(date) >= 10){
				today_string = today_string + date;
			}else{
				today_string = today_string + '0' + date;
			}


			return today_string;
		}

		$.fnc_pdf_download = function() {
			$('#ifrm_page').attr('src', 'work_info_detail_print.jsp?_str_order_id_=<%=_order_id_ %>');
			/*
			var originalContents = document.body.innerHTML;
			window.onbeforeprint = function(){
				$('.no_print').css('display','none');
				$('.print_margin_bottom').attr('style','margin-bottom:10px;');
				var printContents = document.getElementById("print_position").innerHTML;
				document.body.innerHTML = printContents;
			};
			window.onafterprint = function(){
				document.body.innerHTML = originalContents;
			};
			window.print();
			*/
		}

		$.fnc_print = function() {
			$('#ifrm_page').attr('src', 'work_info_detail_print.jsp?_str_order_id_=<%=_order_id_ %>');
			/*
			var originalContents = document.body.innerHTML;
			window.onbeforeprint = function(){
				$('.no_print').css('display','none');
				$('.print_margin_bottom').attr('style','margin-bottom:10px;');
				var printContents = document.getElementById("print_position").innerHTML;
				document.body.innerHTML = printContents;
			};
			window.onafterprint = function(){
				document.body.innerHTML = originalContents;
			};
			window.print();
			*/
		}
	});
</script>

<script type="text/javascript">

	function fnc_input_date_format(obj) {
		if(event.keyCode != 8) {
			if(obj.value.replace(/[0-9 \-]/g, "").length == 0) {
				let number = obj.value.replace(/[^0-9]/g,"");
				let ymd = "";

				if(number.length < 4) {
					return number;
				}
				else if(number.length < 6){
					ymd += number.substr(0, 4);
					ymd += "-";
					ymd += number.substr(4);
				}
				else {
					ymd += number.substr(0, 4);
					ymd += "-";
					ymd += number.substr(4, 2);
					ymd += "-";
					ymd += number.substr(6);
				}

				obj.value = ymd;
			}
			else {
				alert("숫자 이외의 값은 입력하실 수 없습니다.");
				obj.value = obj.value.replace(/[^0-9 ^\-]/g,"");
				return false;
			}
		}
		else {
			return false;
		}
	}

</script>

<!--detail page table data expand collapse javascript-->
<script type="text/javascript">
$(document).ready(function () {
	$(".direct-expand").click(function(){
		$(".direct-child-table").slideToggle(300);
		$(this).toggleClass( "child-table-collapse" );
	});
});
</script>
<!-- Scripts Ends -->
<iframe id="ifrm_page" name="ifrm_page" width="0" height="0">
</iframe>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>