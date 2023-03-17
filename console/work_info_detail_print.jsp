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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="include/session_info.jsp" %>
<%@ include file="include/conn_info.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description" content="Table with Expand/Collapse | Propeller - Admin Dashboard">
<meta content="width=device-width, initial-scale=1, user-scalable=no" name="viewport">
<title>에코비즈텍</title>
<meta name="description" content="Admin is a material design and bootstrap based responsive dashboard template created mainly for admin and backend applications."/>
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="assets/css/propeller.min.css">
<link rel="stylesheet" type="text/css" href="themes/css/propeller-theme.css" />
<link rel="stylesheet" type="text/css" href="themes/css/propeller-admin.css">
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
<%
		_order_id_ = _str_order_id_;

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
			query += "x.*, y.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
			query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count, ";
			query += "(CASE ";
			query += "	WHEN clm_order_state_type='A' THEN '견적' ";
			query += "	WHEN clm_order_state_type='B' THEN '주문' ";
			query += "	WHEN clm_order_state_type='C' THEN '주문취소' ";
			query += "	WHEN clm_order_state_type='C' THEN '완료' ";
			query += "END) clm_order_state_type_name, ";
			query += "coalesce(clm_building_deconstruction_report_yn,'') clm_building_deconstruction_report_yn, ";
			query += "(select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y) clm_reg_user_name, ";
			query += "(select clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_name, ";
			query += "(select y.clm_client_addr from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_addr ";
			query += "from ";
			query += "	tbl_order_info x, tbl_work_info y ";
			query += "where 1=1 and x.clm_order_id=y.clm_order_id " + strCondition + " ";
			query += "order by x.clm_order_id desc limit 1;";
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
				String clm_building_address_detail					 = rs.getString("clm_building_address_detail");
				String clm_client_addr							 = rs.getString("clm_client_addr");
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
				String clm_work_start_date							 = rs.getString("clm_work_start_date");
				String clm_work_end_date							 = rs.getString("clm_work_end_date");
				String clm_reg_user_name							 = rs.getString("clm_reg_user_name");
				String clm_estimation_price							 = rs.getString("clm_estimation_price");
%>
<!--content area start-->
<!--tab start-->
		<!--section-title -- >
		<h2>Basic Form</h2>< !--section-title end -->
		<!-- section content start-->
		<form name="frm_order_data" id="frm_order_data">
		<table style="width:100%; height:100%;">
			<tr>
				<td style="border:1px solid black; padding:10px; width:100%; font-weight:normal; font-size:36px; text-align:center;" colspan="4">
					견적 정보 상세
				</td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">거래처</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_client_name %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">작업명</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_order_name %></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">이메일</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_order_email %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">주소</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_client_addr %></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">지출내역</th>
				<td style="border:1px solid black; padding:10px; padding-bottom:0px; width:85%; font-weight:normal; text-align:left;" colspan="3">
						<table id="tbl_cost_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border:1px solid black;">
							<thead>
								<tr>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid black; background-color: #eee !important; padding: 5px !important;" colspan="2">품 명</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid black; background-color: #eee !important; padding: 5px !important;">규 격</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid black; background-color: #eee !important; padding: 5px !important;">단 위</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid black; background-color: #eee !important; padding: 5px !important;">수 량</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid black; background-color: #eee !important; padding: 5px !important;">단 가</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid black; background-color: #eee !important; padding: 5px !important;">금 액</th>
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
			query += "select x.* ";
			query += "	   , (select y.clm_code_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_id) y) clm_code_name ";
			query += "	   , (select y.clm_code_sub_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_sub_name ";
			query += "	   , (select y.clm_code_unit_type from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit_type ";
			query += "	   , (select y.clm_code_unit from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit ";
			query += "  from tbl_order_sub_cost x  ";
			query += " where 1=1 " + strCondition + " ";
			query += " order by x.clm_order_id desc, x.clm_order_cost_seq;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			ResultSet rs_cost = stmt_cost.executeQuery(query);

			reqDateStr = "";
			reqDateTime = 0;
			curDateTime = 0;
			minute = 0;
			duration_minute = "";

			int iSubRowCnt = 0;
			while (rs_cost.next()) {
				String clm_cost_order_id        = rs_cost.getString("clm_order_id");
				String clm_cost_order_cost_seq  = rs_cost.getString("clm_order_cost_seq");
				String clm_cost_cost_id         = rs_cost.getString("clm_cost_id");
				String clm_cost_cost_sub_id     = rs_cost.getString("clm_cost_sub_id");
				String clm_cost_count           = rs_cost.getString("clm_cost_count");
				String clm_cost_count_without_comma           = clm_cost_count.replaceAll(",", "");
				// String clm_cost_cost_count      = clm_cost_count_without_comma;
				String clm_cost_cost_count      = String.format("%,d", Integer.parseInt(clm_cost_count_without_comma));
				String clm_cost_del_yn          = rs_cost.getString("clm_del_yn");
				String clm_cost_comment         = rs_cost.getString("clm_comment");
				String clm_cost_reg_datetime    = rs_cost.getString("clm_reg_datetime");
				String clm_cost_reg_user_id     = rs_cost.getString("clm_reg_user_id");
				String clm_cost_update_datetime = rs_cost.getString("clm_update_datetime");
				String clm_cost_update_user_id  = rs_cost.getString("clm_update_user_id");
				String clm_cost_employee_seq     = rs_cost.getString("clm_employee_seq");
				String clm_cost_cost_count_unit     = rs_cost.getString("clm_cost_count_unit");
				String clm_cost_cost_count_type     = rs_cost.getString("clm_cost_count_type");
				String clm_cost_code_name     = rs_cost.getString("clm_code_name");
				String clm_cost_code_sub_name     = rs_cost.getString("clm_code_sub_name");
				String clm_cost_code_unit     = rs_cost.getString("clm_code_unit");
				String clm_cost_code_unit_type     = rs_cost.getString("clm_code_unit_type");
				String clm_cost_cost_price			= rs_cost.getString("clm_cost_unit_price").replaceAll(",", "");
				// String clm_cost_cost_price_format	= clm_cost_cost_price;
				String clm_cost_cost_price_format	= String.format("%,f", Double.parseDouble(clm_cost_cost_price));
				clm_cost_cost_price			= clm_cost_cost_price.replaceAll(",", "");
				// System.out.println("> clm_cost_cost_price >>>>>>>>>>>>>>>>>>>> " + clm_cost_cost_price + " / " + clm_cost_count_without_comma);
				String clm_cost_cost_total_price			= String.format("%,f", Double.parseDouble(clm_cost_cost_price) * Double.parseDouble(clm_cost_count_without_comma));

				clm_cost_cost_price_format = clm_cost_cost_price_format.substring(0, clm_cost_cost_price_format.indexOf("."));
				clm_cost_cost_total_price = clm_cost_cost_total_price.substring(0, clm_cost_cost_total_price.indexOf("."));
%>
			<tr id="tr_cost_<%=iSubRowCnt %>">
				<td style="padding:5px; border:1px solid black; width:20%; border-right:1px solid black;" colspan="2">
					<input type="text" style="width:100%; padding:5px; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_code_name %>" id="txt_cost_code_name" name="txt_cost_code_name" readOnly>
					<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_id %>" id="txt_cost_code_id" name="txt_cost_code_id">
					<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_sub_id %>" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">
				</td>
				<td style="padding:5px; border:1px solid black; text-align:center;">
					<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_code_unit %>" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly>
				</td>
				<td style="padding:5px; border:1px solid black; text-align:center;">
					<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_code_sub_name %>" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly>
				</td>
				<td style="padding:5px; border:1px solid black; text-align:right;">
					<input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right; border:0px solid transparent;" value="<%=clm_cost_cost_count %>" onKeyUp="JavaScript:$.fnc_only_number(this, '<%=iSubRowCnt %>');" readOnly>
				</td>
				<td style="padding:5px; border:1px solid black; text-align:right;">
					<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_cost_price_format %>" id="txt_cost_cost_price" name="txt_cost_cost_price" readOnly>
				</td>
				<td style="padding:5px; border:1px solid black; text-align:right;">
					<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_cost_total_price %>" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly>
				</td>
			</tr>
<%
				iSubRowCnt++;
			}

			if(iSubRowCnt==0) {
%>
			<tr>
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
				</td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">건축물구조</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_type %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">지출견적 총계</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_estimation_price %></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">작업지주소</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_address %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">작업지상세주소</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_address_detail %></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">층고</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_height %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">해체신고여부</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_deconstruction_report_yn %></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">연명적(㎡)</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_volume %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">연명적(평)</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">대지면적(㎡)</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_building_base_volume %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">대지면적(평)</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"></td>
			</tr>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">작업시작일</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_work_start_date %></td>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">작업종료일</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;"><%=clm_work_end_date %></td>
			</tr>

<%
	String displayCondition = (clm_order_state_type.equals("B") || clm_order_state_type.equals("D"))?"block":"none";

	if(clm_order_state_type.equals("B") || clm_order_state_type.equals("D")) {
%>
			<tr>
				<th style="border:1px solid black; padding:10px; width:100%; font-weight:bold; text-align:center;" colspan="4">공사 행정 진행 일정</th>
			</tr>
			<tr>
				<td style="border:1px solid black; padding:10px; width:100%; font-weight:normal; text-align:center;" colspan="4">
<%

			try {
				stmt = conn.createStatement();
				strCondition = "";
				if(!_order_id_.equals("")) {
					strCondition += "and z.clm_order_id='" + _order_id_ + "' ";
				}
				query  = "";
				query += "select z.* ";
				query += "  from tbl_work_progress_info z ";
				query += "where 1=1 ";
				query += strCondition + " ";
				query += "order by z.clm_order_id desc;";
				System.out.println("> " + strCurrentReportId + ".data_list " + query);
				rs = stmt.executeQuery(query);

				iRowCnt = 0;
				while (rs.next()) {
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
					String clm_work_process_01_schedule					 = (rs.getString("clm_work_process_01_schedule").equals(""))?"-":(rs.getString("clm_work_process_01_schedule")).substring(2);
					String clm_work_process_02_schedule					 = (rs.getString("clm_work_process_02_schedule").equals(""))?"-":(rs.getString("clm_work_process_02_schedule")).substring(2);
					String clm_work_process_03_schedule					 = (rs.getString("clm_work_process_03_schedule").equals(""))?"-":(rs.getString("clm_work_process_03_schedule")).substring(2);
					String clm_work_process_04_schedule					 = (rs.getString("clm_work_process_04_schedule").equals(""))?"-":(rs.getString("clm_work_process_04_schedule")).substring(2);
					String clm_work_process_05_schedule					 = (rs.getString("clm_work_process_05_schedule").equals(""))?"-":(rs.getString("clm_work_process_05_schedule")).substring(2);
					String clm_work_process_06_schedule					 = (rs.getString("clm_work_process_06_schedule").equals(""))?"-":(rs.getString("clm_work_process_06_schedule")).substring(2);
					String clm_work_process_07_schedule					 = (rs.getString("clm_work_process_07_schedule").equals(""))?"-":(rs.getString("clm_work_process_07_schedule")).substring(2);
					String clm_work_process_08_schedule					 = (rs.getString("clm_work_process_08_schedule").equals(""))?"-":(rs.getString("clm_work_process_08_schedule")).substring(2);
					String clm_work_process_09_schedule					 = (rs.getString("clm_work_process_09_schedule").equals(""))?"-":(rs.getString("clm_work_process_09_schedule")).substring(2);
					String clm_work_process_10_schedule					 = (rs.getString("clm_work_process_10_schedule").equals(""))?"-":(rs.getString("clm_work_process_10_schedule")).substring(2);
					String clm_work_process_11_schedule					 = (rs.getString("clm_work_process_11_schedule").equals(""))?"-":(rs.getString("clm_work_process_11_schedule")).substring(2);
					String clm_work_process_12_schedule					 = (rs.getString("clm_work_process_12_schedule").equals(""))?"-":(rs.getString("clm_work_process_12_schedule")).substring(2);
					String clm_work_process_13_schedule					 = (rs.getString("clm_work_process_13_schedule").equals(""))?"-":(rs.getString("clm_work_process_13_schedule")).substring(2);
					String clm_work_process_14_schedule					 = (rs.getString("clm_work_process_14_schedule").equals(""))?"-":(rs.getString("clm_work_process_14_schedule")).substring(2);
					String clm_work_process_15_schedule					 = (rs.getString("clm_work_process_15_schedule").equals(""))?"-":(rs.getString("clm_work_process_15_schedule")).substring(2);
					String clm_work_process_16_schedule					 = (rs.getString("clm_work_process_16_schedule").equals(""))?"-":(rs.getString("clm_work_process_16_schedule")).substring(2);
					String clm_work_process_17_schedule					 = (rs.getString("clm_work_process_17_schedule").equals(""))?"-":(rs.getString("clm_work_process_17_schedule")).substring(2);
					String clm_work_process_18_schedule					 = (rs.getString("clm_work_process_18_schedule").equals(""))?"-":(rs.getString("clm_work_process_18_schedule")).substring(2);
					String clm_work_process_19_schedule					 = (rs.getString("clm_work_process_19_schedule").equals(""))?"-":(rs.getString("clm_work_process_19_schedule")).substring(2);
					String clm_work_process_20_schedule					 = (rs.getString("clm_work_process_20_schedule").equals(""))?"-":(rs.getString("clm_work_process_20_schedule")).substring(2);
					String clm_work_process_21_schedule					 = (rs.getString("clm_work_process_21_schedule").equals(""))?"-":(rs.getString("clm_work_process_21_schedule")).substring(2);
					String clm_work_process_22_schedule					 = (rs.getString("clm_work_process_22_schedule").equals(""))?"-":(rs.getString("clm_work_process_22_schedule")).substring(2);
					String clm_work_process_01_date						 = (rs.getString("clm_work_process_01_date").equals(""))?"-":(rs.getString("clm_work_process_01_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_02_date						 = (rs.getString("clm_work_process_02_date").equals(""))?"-":(rs.getString("clm_work_process_02_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_03_date						 = (rs.getString("clm_work_process_03_date").equals(""))?"-":(rs.getString("clm_work_process_03_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_04_date						 = (rs.getString("clm_work_process_04_date").equals(""))?"-":(rs.getString("clm_work_process_04_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_05_date						 = (rs.getString("clm_work_process_05_date").equals(""))?"-":(rs.getString("clm_work_process_05_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_06_date						 = (rs.getString("clm_work_process_06_date").equals(""))?"-":(rs.getString("clm_work_process_06_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_07_date						 = (rs.getString("clm_work_process_07_date").equals(""))?"-":(rs.getString("clm_work_process_07_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_08_date						 = (rs.getString("clm_work_process_08_date").equals(""))?"-":(rs.getString("clm_work_process_08_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_09_date						 = (rs.getString("clm_work_process_09_date").equals(""))?"-":(rs.getString("clm_work_process_09_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_10_date						 = (rs.getString("clm_work_process_10_date").equals(""))?"-":(rs.getString("clm_work_process_10_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_11_date						 = (rs.getString("clm_work_process_11_date").equals(""))?"-":(rs.getString("clm_work_process_11_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_12_date						 = (rs.getString("clm_work_process_12_date").equals(""))?"-":(rs.getString("clm_work_process_12_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_13_date						 = (rs.getString("clm_work_process_13_date").equals(""))?"-":(rs.getString("clm_work_process_13_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_14_date						 = (rs.getString("clm_work_process_14_date").equals(""))?"-":(rs.getString("clm_work_process_14_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_15_date						 = (rs.getString("clm_work_process_15_date").equals(""))?"-":(rs.getString("clm_work_process_15_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_16_date						 = (rs.getString("clm_work_process_16_date").equals(""))?"-":(rs.getString("clm_work_process_16_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_17_date						 = (rs.getString("clm_work_process_17_date").equals(""))?"-":(rs.getString("clm_work_process_17_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_18_date						 = (rs.getString("clm_work_process_18_date").equals(""))?"-":(rs.getString("clm_work_process_18_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_19_date						 = (rs.getString("clm_work_process_19_date").equals(""))?"-":(rs.getString("clm_work_process_19_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_20_date						 = (rs.getString("clm_work_process_20_date").equals(""))?"-":(rs.getString("clm_work_process_20_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_21_date						 = (rs.getString("clm_work_process_21_date").equals(""))?"-":(rs.getString("clm_work_process_21_date")).substring(2).replace("/","-").replace("/","-");
					String clm_work_process_22_date						 = (rs.getString("clm_work_process_22_date").equals(""))?"-":(rs.getString("clm_work_process_22_date")).substring(2).replace("/","-").replace("/","-");
%>
							<table id="example" cellspacing="0" width="100%">
								<tbody>
									<tr>
										<td style="padding:5px; border:1px solid black;" width="4.3%"></td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">건축물해체허가신청기간</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">착공계제출</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">감리자계약</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">감리자지정</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">해체착공계제출</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">해체허가완료</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">비산먼지신고기간</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">비산먼지신고</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">특정공사신고</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">도로점용신고</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">건축물구조검토기간</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;">계획</td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_01_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_02_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_03_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_04_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_05_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_06_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_07_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_08_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_09_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_10_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_11_schedule %></td>
									</tr>
									<tr>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;">실행</td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_01_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_02_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_03_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_04_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_05_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_06_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_07_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_08_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_09_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_10_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_11_date %></td>
									</tr>
									<tr>
										<td style="padding:5px; border:1px solid black;" width="4.3%"></td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">건축물구조검토완료</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">철거심의기간</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">철거심의완료</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">건설폐기물신고</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">석면신고기간</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">석면공사</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">해체완료</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">감리완료</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">멸실신고</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">등기정리</td>
										<td style="padding:5px; border:1px solid black;" width="8.7%">공사완료</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;">계획</td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_12_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_13_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_14_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_15_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_16_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_17_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_18_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_19_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_20_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_21_schedule %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_22_schedule %></td>
									</tr>
									<tr>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;">실행</td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_12_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_13_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_14_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_15_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_16_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_17_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_18_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_19_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_20_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_21_date %></td>
										<td style="text-align:center; padding:5px; border:1px solid black; padding-left:0px; padding-right: 0px;"><%=clm_work_process_22_date %></td>
									</tr>
								</tbody>
							</table>
<%
				}
			}
			catch(Exception e) {
				System.out.println("> e " + e.toString());
			}
%>
				</td>
			</tr>
<%
	}
%>
			<tr>
				<th style="border:1px solid black; padding:10px; width:18%; font-weight:bold; text-align:center;">특이사항</th>
				<td style="border:1px solid black; padding:10px; width:32%; font-weight:normal; text-align:left;" colspan="3"><%=clm_comment %></td>
			</tr>
		</table>
		</form>
		</div>
		<!-- Card Footer -->
	</div>
</div>
<%
				iRowCnt++;
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

<!-- Scripts Starts -->
<script src="assets/js/jquery-1.12.2.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/propeller.min.js"></script>
<!-- css 파일 -->
<link rel="stylesheet" href="https://nowonbun.github.io/Loader/loader.css">
<!-- javascript 파일 -->
<script type="text/javascript" src="https://nowonbun.github.io/Loader/loader.js"></script>
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/pmd-datetimepicker.css" />
<script type="text/javascript" src="components/select2/js/select2.full.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script>
window.onload=function(){
	window.print();
}
</script>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>