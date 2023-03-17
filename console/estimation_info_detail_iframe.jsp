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
<body style="background-color:white;">
<!-- Header Starts -->
<!--Start Nav bar -->
<!-- Header Ends -->

<!-- Sidebar Starts -->
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
			query += "x.*, y.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
			query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count, ";
			query += "(CASE ";
			query += "	WHEN clm_order_state_type='A' THEN '견적' ";
			query += "	WHEN clm_order_state_type='B' THEN '주문' ";
			query += "	WHEN clm_order_state_type='C' THEN '주문취소' ";
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
<div id="content">
<!--tab start-->
<div>
	<div>
		<!--section-title -- >
		<h2>Basic Form</h2>< !--section-title end -->
		<!-- section content start-->
		<div style="background-color:white;">
			<div id="print_position" class="pmd-card-body">
				<div class="group-fields clearfix row">
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<div class="form-group pmd-textfield pmd-textfield-floating-label" style="background-color:#eee !important; padding:10px;">
							<span style="font-weight:bold !important; color:red !important;">*</span>&nbsp;해당 주문은 현재 <span style="color:red !important; font-weight:bold !important;">'<%=clm_order_state_type_name %>'</span>상태입니다.
						</div>
					</div>
				</div>
				<div class="group-fields clearfix row">
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<div class="form-group pmd-textfield pmd-textfield-floating-label">
							<label for="regular1" class="control-label">
								<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
								거래처<span style="font-weight:bold !important; color:red !important;">*</span>
							</label>
							<input type="text" id="txt_client_name" name="txt_client_name" class="form-control" value="<%=clm_client_name %>" onClick="JavaScript:$.fnc_modal_customer_code(this);" style="cursor:pointer;" readOnly />
							<input type="hidden" id="txt_client_id" name="txt_client_id" value="<%=clm_client_id %>" />
							<input type="hidden" id="txt_order_id" name="txt_order_id" value="<%=_order_id_ %>" />
							<input type="hidden" id="txt_process_type" name="txt_process_type" value="S" />
						</div>
					</div>
					<%@ include file="include/modal/modal_customer_code.jsp" %>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<div class="form-group pmd-textfield pmd-textfield-floating-label">
							<label for="regular1" class="control-label">
								작업명<span style="font-weight:bold !important; color:red !important;">*</span>
							</label>
							<input type="text" id="txt_order_name" name="txt_order_name" class="form-control" value="<%=clm_order_name %>" />
						</div>
					</div>
				</div>
				<div class="group-fields clearfix row">
					<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-6">
					   <label for="regular1" class="control-label">
						 Email
					   </label>
					   <input type="text" id="txt_order_email" name="txt_order_email" class="form-control" value="<%=clm_order_email %>" readOnly />
					</div>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<div class="form-group pmd-textfield pmd-textfield-floating-label">
						   <label for="regular1" class="control-label">
							 주소
						   </label>
						   <input type="text" id="txt_client_addr" name="txt_client_addr" class="form-control" value="<%=clm_client_addr %>" readOnly />
						</div>
					</div>
				</div>
				<div class="group-fields clearfix row">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
							<tr>
								<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
									<label for="regular1" class="control-label" style="font-size:16px;">
										지 출
									</label>
								</td>
								<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
								</td>
							</tr>
						</table>
						<table id="tbl_cost_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border:1px solid #ccc;">
							<thead>
								<tr>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">No.</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;" colspan="2">품 명</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">규 격</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">단 위</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">수 량</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">단 가</th>
									<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">금 액</th>
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
				<td style="padding:5px; border:1px solid #ccc; text-align:center;"><%=iSubRowCnt+1 %></td>
				<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid #ccc;" colspan="2">
					<input type="text" style="width:100%; padding:5px; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_code_name %>" id="txt_cost_code_name" name="txt_cost_code_name" readOnly>
					<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_id %>" id="txt_cost_code_id" name="txt_cost_code_id">
					<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_sub_id %>" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">
				</td>
				<td style="padding:5px; border:1px solid #ccc; text-align:center;">
					<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_code_unit %>" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly>
				</td>
				<td style="padding:5px; border:1px solid #ccc; text-align:center;">
					<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_code_sub_name %>" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly>
				</td>
				<td style="padding:5px; border:1px solid #ccc; text-align:right;">
					<input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right; border:0px solid transparent;" value="<%=clm_cost_cost_count %>" onKeyUp="JavaScript:$.fnc_only_number(this, '<%=iSubRowCnt %>');" readOnly>
				</td>
				<td style="padding:5px; border:1px solid #ccc; text-align:right;">
					<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#fff; border:0px solid transparent;" value="<%=clm_cost_cost_price_format %>" id="txt_cost_cost_price" name="txt_cost_cost_price" readOnly>
				</td>
				<td style="padding:5px; border:1px solid #ccc; text-align:right;">
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
						</div>
						<%@ include file="include/modal/modal_cost_code.jsp" %>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
									건축물구조<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="txt_building_type" name="txt_building_type" class="form-control" value="<%=clm_building_type %>" data-param_01="0" data-param_02="0002" data-toggle="modal" style="cursor:pointer;" onClick="JavaScript:$.fnc_modal_cost_code(this);" readOnly />
								<input type="hidden" id="txt_building_type_id" name="txt_building_type_id" class="form-control" />
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									지출견적 총계
								</label>
								<input type="text" id="txt_cost_total_price" name="txt_cost_total_price" class="form-control" value="<%=clm_estimation_price %>" placeHolder="0" style="text-align:right;" readOnly />
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									<!--
									<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
									-->
									작업지 주소<span style="font-weight:bold !important; color:red !important;">*</span>
								</label>
								<input type="text" id="txt_building_address" name="txt_building_address" class="form-control" value="<%=clm_building_address %>" readOnly onClick="JavaScript:sample2_execDaumPostcode();" style="cursor:pointer;" />
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									작업지 상세주소
								</label>
								<input type="text" id="txt_building_address_detail" name="txt_building_address_detail" class="form-control" value="<%=clm_building_address_detail %>" />
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">층고(M)</label>
							<input type="text" class="mat-input form-control" id="txt_building_height" name="txt_building_height" value="<%=clm_building_height %>" onKeyUp="JavaScript:$.fnc_only_number_with_comma(this);" maxlength="10" style="text-align:right;">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">연면적(㎡)</label>
							<input type="text" class="mat-input form-control" id="txt_building_volume" name="txt_building_volume" value="<%=clm_building_volume %>" onKeyUp="JavaScript:$.fnc_only_number_with_comma_volume(this, 'txt_building_volume_py');" maxlength="10" style="text-align:right;">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">대지면적(㎡)</label>
							<input type="text" class="mat-input form-control" id="txt_building_base_volume" name="txt_building_base_volume" value="<%=clm_building_base_volume %>" onKeyUp="JavaScript:$.fnc_only_number_with_comma_volume(this, 'txt_building_base_volume_py');" maxlength="10" style="text-align:right;">
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">
								<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
								해체신고여부
							</label>
							<input type="text" id="txt_building_deconstruction_report_yn_name" name="txt_building_deconstruction_report_yn_name" class="form-control" value="<%=clm_building_deconstruction_report_yn %>" data-param_01="0" data-param_02="0003" data-toggle="modal" onClick="JavaScript:$.fnc_modal_cost_code(this);" style="cursor:pointer;" readOnly />
							<input type="hidden" id="txt_building_deconstruction_report_yn" name="txt_building_deconstruction_report_yn" class="form-control" value="<%=clm_building_deconstruction_report_yn %>" />
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">평연면적(py)</label>
							<input type="text" class="mat-input form-control" id="txt_building_volume_py" name="txt_building_volume_py" value="<%=clm_building_volume_py %>" maxlength="10" readOnly style="text-align:right;" />
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">평대지면적(py)</label>
							<input type="text" class="mat-input form-control" id="txt_building_base_volume_py" name="txt_building_base_volume_py" value="<%=clm_building_base_volume_py %>" maxlength="10" readOnly style="text-align:right;" />
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">
								<i class="material-icons md-dark pmd-sm" style="font-size:12px;">date_range</i>
								작업시작일자<span style="font-weight:bold !important; color:red !important;">*</span>
							</label>
							<input type="text" class="mat-input form-control" id="txt_work_start_date" name="txt_work_start_date" style="cursor:pointer;" value="<%=clm_work_start_date %>" />
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<label for="first-name">
								<i class="material-icons md-dark pmd-sm" style="font-size:12px;">date_range</i>
								작업종료일자<span style="font-weight:bold !important; color:red !important;">*</span>
							</label>
							<input type="text" class="mat-input form-control" id="txt_work_end_date" name="txt_work_end_date" style="cursor:pointer;" value="<%=clm_work_end_date %>" />
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-4"></div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" style="ta_comment;" name="ta_comment"><%=clm_comment %></textarea>
							</div>
						</div>
					</div>


<%

%>
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
				</td>
			</tr>
		</table>
		<table id="tbl_file_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border:1px solid #ccc;">
			<thead>
				<tr>
					<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;  background-color: #eee !important;">No.</th>
					<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;  background-color: #eee !important;">파일명</th>
					<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;  background-color: #eee !important;">파일크기</th>
					<th style="border:1px solid #ccc; font-size:14px; font-weight:bold; text-align:center;  background-color: #eee !important;">다운로드</th>
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
			query += "  from  tbl_order_file x ";
			query += " where 1=1 ";
			query += "   and x.clm_del_yn='N' " + strCondition + " ";
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
			</tr>
<%
				iSubRowCnt++;
			}

			if(iSubRowCnt==0) {
%>
			<tr>
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
<%
	String displayCondition = (clm_order_state_type.equals("B") || clm_order_state_type.equals("D"))?"block":"none";
%>

		<div class="group-fields clearfix row no_print" id="div_work_progress_info" name="div_work_progress_info" style="display:<%=displayCondition %>">
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
					String clm_work_process_01_schedule					 = rs.getString("clm_work_process_01_schedule");
					String clm_work_process_02_schedule					 = rs.getString("clm_work_process_02_schedule");
					String clm_work_process_03_schedule					 = rs.getString("clm_work_process_03_schedule");
					String clm_work_process_04_schedule					 = rs.getString("clm_work_process_04_schedule");
					String clm_work_process_05_schedule					 = rs.getString("clm_work_process_05_schedule");
					String clm_work_process_06_schedule					 = rs.getString("clm_work_process_06_schedule");
					String clm_work_process_07_schedule					 = rs.getString("clm_work_process_07_schedule");
					String clm_work_process_08_schedule					 = rs.getString("clm_work_process_08_schedule");
					String clm_work_process_09_schedule					 = rs.getString("clm_work_process_09_schedule");
					String clm_work_process_10_schedule					 = rs.getString("clm_work_process_10_schedule");
					String clm_work_process_11_schedule					 = rs.getString("clm_work_process_11_schedule");
					String clm_work_process_12_schedule					 = rs.getString("clm_work_process_12_schedule");
					String clm_work_process_13_schedule					 = rs.getString("clm_work_process_13_schedule");
					String clm_work_process_14_schedule					 = rs.getString("clm_work_process_14_schedule");
					String clm_work_process_15_schedule					 = rs.getString("clm_work_process_15_schedule");
					String clm_work_process_16_schedule					 = rs.getString("clm_work_process_16_schedule");
					String clm_work_process_17_schedule					 = rs.getString("clm_work_process_17_schedule");
					String clm_work_process_18_schedule					 = rs.getString("clm_work_process_18_schedule");
					String clm_work_process_19_schedule					 = rs.getString("clm_work_process_19_schedule");
					String clm_work_process_20_schedule					 = rs.getString("clm_work_process_20_schedule");
					String clm_work_process_21_schedule					 = rs.getString("clm_work_process_21_schedule");
					String clm_work_process_22_schedule					 = rs.getString("clm_work_process_22_schedule");
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
%>
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-6">
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
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('01');" id="a_work_process_01" name="a_work_process_01">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											건축물해체허가신청기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('02');" id="a_work_process_02" name="a_work_process_02">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												착공계제출
											</a>
											<!--
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('02');">
												<span style="background-color:red; color: white; font-weight:bold; padding:5px;">
													<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
													착공계제출
												</span>
											</a>
											-->
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('03');" id="a_work_process_03" name="a_work_process_03">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												감리자계약
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('04');" id="a_work_process_04" name="a_work_process_04">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												감리자지정
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('05');" id="a_work_process_05" name="a_work_process_05">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												해체착공계제출
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('06');" id="a_work_process_06" name="a_work_process_06">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												해체허가완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('07');" id="a_work_process_07" name="a_work_process_07">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												비산먼지신고기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('08');" id="a_work_process_08" name="a_work_process_08">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												비산먼지신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('09');" id="a_work_process_09" name="a_work_process_09">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												특정공사신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('10');" id="a_work_process_10" name="a_work_process_10">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												도로점용신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('11');" id="a_work_process_11" name="a_work_process_11">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												건축물구조검토기간
											</a>
										</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_01_schedule" name="txt_work_process_01_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_01_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_02_schedule" name="txt_work_process_02_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_02_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_03_schedule" name="txt_work_process_03_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_03_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_04_schedule" name="txt_work_process_04_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_04_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_05_schedule" name="txt_work_process_05_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_05_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_06_schedule" name="txt_work_process_06_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_06_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_07_schedule" name="txt_work_process_07_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_07_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_08_schedule" name="txt_work_process_08_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_08_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_09_schedule" name="txt_work_process_09_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_09_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_10_schedule" name="txt_work_process_10_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_10_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_11_schedule" name="txt_work_process_11_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer; font-color: black;" value="<%=clm_work_process_11_schedule %>" /></td>
									</tr>
									<tr>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('12');" id="a_work_process_12" name="a_work_process_12">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												건축물구조검토완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('13');" id="a_work_process_13" name="a_work_process_13">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												철거심의기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('14');" id="a_work_process_14" name="a_work_process_14">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												철거심의완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('15');" id="a_work_process_15" name="a_work_process_15">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												건설폐기물신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('16');" id="a_work_process_16" name="a_work_process_16">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												석면신고기간
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('17');" id="a_work_process_17" name="a_work_process_17">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												석면공사
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('18');" id="a_work_process_18" name="a_work_process_18">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												해체완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('19');" id="a_work_process_19" name="a_work_process_19">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												감리완료
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('20');" id="a_work_process_20" name="a_work_process_20">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												멸실신고
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('21');" id="a_work_process_21" name="a_work_process_21">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												등기정리
											</a>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<a href="#" onClick="JavaScript:$.fnc_work_progress_check('22');" id="a_work_process_22" name="a_work_process_22">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												공사완료
											</a>
										</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_12_schedule" name="txt_work_process_12_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_12_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_13_schedule" name="txt_work_process_13_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_13_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_14_schedule" name="txt_work_process_14_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_14_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_15_schedule" name="txt_work_process_15_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_15_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_16_schedule" name="txt_work_process_16_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_16_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_17_schedule" name="txt_work_process_17_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_17_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_18_schedule" name="txt_work_process_18_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_18_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_19_schedule" name="txt_work_process_19_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_19_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_20_schedule" name="txt_work_process_20_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_20_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_21_schedule" name="txt_work_process_21_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_21_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"><input type="text" id="txt_work_process_22_schedule" name="txt_work_process_22_schedule" style="width:90%; text-align:center; padding:2px; background-color:#66CCFF44; cursor:pointer;" value="<%=clm_work_process_22_schedule %>" /></td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"></td>
									</tr>
								</tbody>
							</table>
						</div>
<%
				}
			}
			catch(Exception e) {
				System.out.println("> e " + e.toString());
			}
%>
		</div>
		</div>
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
		$.fnc_report_data_save = function() {
			var client_id = $('#txt_client_id').val();
			var client_name = $('#txt_client_name').val();
			var order_name = $('#txt_order_name').val();
			var building_type = $('#txt_building_type').val();
			var building_address = $('#txt_building_address').val();
			var work_start_date = $('#txt_work_start_date').val();
			var work_end_date = $('#txt_work_end_date').val();

			var work_process_01_schedule = $('#txt_work_process_01_schedule').val();
			var work_process_02_schedule = $('#txt_work_process_02_schedule').val();
			var work_process_03_schedule = $('#txt_work_process_03_schedule').val();
			var work_process_04_schedule = $('#txt_work_process_04_schedule').val();
			var work_process_05_schedule = $('#txt_work_process_05_schedule').val();
			var work_process_06_schedule = $('#txt_work_process_06_schedule').val();
			var work_process_07_schedule = $('#txt_work_process_07_schedule').val();
			var work_process_08_schedule = $('#txt_work_process_08_schedule').val();
			var work_process_09_schedule = $('#txt_work_process_09_schedule').val();
			var work_process_10_schedule = $('#txt_work_process_10_schedule').val();
			var work_process_11_schedule = $('#txt_work_process_11_schedule').val();
			var work_process_12_schedule = $('#txt_work_process_12_schedule').val();
			var work_process_13_schedule = $('#txt_work_process_13_schedule').val();
			var work_process_14_schedule = $('#txt_work_process_14_schedule').val();
			var work_process_15_schedule = $('#txt_work_process_15_schedule').val();
			var work_process_16_schedule = $('#txt_work_process_16_schedule').val();
			var work_process_17_schedule = $('#txt_work_process_17_schedule').val();
			var work_process_18_schedule = $('#txt_work_process_18_schedule').val();
			var work_process_19_schedule = $('#txt_work_process_19_schedule').val();
			var work_process_20_schedule = $('#txt_work_process_20_schedule').val();
			var work_process_21_schedule = $('#txt_work_process_21_schedule').val();
			var work_process_22_schedule = $('#txt_work_process_22_schedule').val();

			if(client_id == '' || client_name == ''){
				alert('거래처는 필수 입력입니다.');
			}else if(order_name == ''){
				alert('작업명은 필수 입력입니다.');
			}else if(building_type == ''){
				alert('건축물구조는 필수 입력입니다.');
			}else if(building_address == ''){
				alert('작업지 주소는 필수 입력입니다.');
			}else if(work_start_date == ''){
				alert('작업시작일자는 필수 입력입니다.');
			}else if(work_end_date == ''){
				alert('작업종료일자는 필수 입력입니다.');
			}else if(work_process_01_schedule != "" && work_process_01_schedule.length != 10){
				alert('건축물해체허가신청기간 일자가 잘못 되었습니다');
				$('#txt_work_process_01_schedule').focus();
			}else if(work_process_02_schedule != "" && work_process_02_schedule.length != 10){
				alert('착공계제출 일자가 잘못 되었습니다');
				$('#txt_work_process_02_schedule').focus();
			}else if(work_process_03_schedule != "" && work_process_03_schedule.length != 10){
				alert('감리자계약 일자가 잘못 되었습니다');
				$('#txt_work_process_03_schedule').focus();
			}else if(work_process_04_schedule != "" && work_process_04_schedule.length != 10){
				alert('감리자지정 일자가 잘못 되었습니다');
				$('#txt_work_process_04_schedule').focus();
			}else if(work_process_05_schedule != "" && work_process_05_schedule.length != 10){
				alert('해체착공계제출 일자가 잘못 되었습니다');
				$('#txt_work_process_05_schedule').focus();
			}else if(work_process_06_schedule != "" && work_process_06_schedule.length != 10){
				alert('해체허가완료 일자가 잘못 되었습니다');
				$('#txt_work_process_06_schedule').focus();
			}else if(work_process_07_schedule != "" && work_process_07_schedule.length != 10){
				alert('비산먼지신고기간 일자가 잘못 되었습니다');
				$('#txt_work_process_07_schedule').focus();
			}else if(work_process_08_schedule != "" && work_process_08_schedule.length != 10){
				alert('비산먼지신고 일자가 잘못 되었습니다');
				$('#txt_work_process_08_schedule').focus();
			}else if(work_process_09_schedule != "" && work_process_09_schedule.length != 10){
				alert('특정공사신고 일자가 잘못 되었습니다');
				$('#txt_work_process_09_schedule').focus();
			}else if(work_process_10_schedule != "" && work_process_10_schedule.length != 10){
				alert('도로점용신고 일자가 잘못 되었습니다');
				$('#txt_work_process_10_schedule').focus();
			}else if(work_process_11_schedule != "" && work_process_11_schedule.length != 10){
				alert('건축물구조검토기간 일자가 잘못 되었습니다');
				$('#txt_work_process_11_schedule').focus();
			}else if(work_process_12_schedule != "" && work_process_12_schedule.length != 10){
				alert('건축물구조검토완료 일자가 잘못 되었습니다');
				$('#txt_work_process_12_schedule').focus();
			}else if(work_process_13_schedule != "" && work_process_13_schedule.length != 10){
				alert('철거심의기간 일자가 잘못 되었습니다');
				$('#txt_work_process_13_schedule').focus();
			}else if(work_process_14_schedule != "" && work_process_14_schedule.length != 10){
				alert('철거심의완료 일자가 잘못 되었습니다');
				$('#txt_work_process_14_schedule').focus();
			}else if(work_process_15_schedule != "" && work_process_15_schedule.length != 10){
				alert('건설폐기물신고 일자가 잘못 되었습니다');
				$('#txt_work_process_15_schedule').focus();
			}else if(work_process_16_schedule != "" && work_process_16_schedule.length != 10){
				alert('석면신고기간 일자가 잘못 되었습니다');
				$('#txt_work_process_16_schedule').focus();
			}else if(work_process_17_schedule != "" && work_process_17_schedule.length != 10){
				alert('석면공사 일자가 잘못 되었습니다');
				$('#txt_work_process_17_schedule').focus();
			}else if(work_process_18_schedule != "" && work_process_18_schedule.length != 10){
				alert('해체완료 일자가 잘못 되었습니다');
				$('#txt_work_process_18_schedule').focus();
			}else if(work_process_19_schedule != "" && work_process_19_schedule.length != 10){
				alert('감리완료 일자가 잘못 되었습니다');
				$('#txt_work_process_19_schedule').focus();
			}else if(work_process_20_schedule != "" && work_process_20_schedule.length != 10){
				alert('멸실신고 일자가 잘못 되었습니다');
				$('#txt_work_process_20_schedule').focus();
			}else if(work_process_21_schedule != "" && work_process_21_schedule.length != 10){
				alert('등기정리 일자가 잘못 되었습니다');
				$('#txt_work_process_21_schedule').focus();
			}else if(work_process_22_schedule != "" && work_process_22_schedule.length != 10){
				alert('공사완료 일자가 잘못 되었습니다');
				$('#txt_work_process_22_schedule').focus();
			}else{
				$.ajax({
					url: './estimation_info_save_proc.jsp',
					data: $('#frm_order_data').serialize(),
					error : function(request, status, error){
						$("#p_alert_msg").html('변경사항에 실패하였습니다.');
						$('#div_alert_modal').modal("show");
						loader.off();
					},
					beforeSend : function(){
						loader.on();
					},
					success: function(result){
						var order_id = '<%=_order_id_ %>';
						var input_file = $('input[name="fl_attached_file"]');
						var form_data = new FormData();
						var seq_num = '00';
						for(var i=0; i<input_file.length; i++) {
							seq_num = (i<10)?('0'+i):i;
							form_data.append('upload_files_' + seq_num, input_file[i].files[0])
						};
						jQuery.ajax({
							url: './file_upload_proc.jsp?order_id='+order_id,
							data: form_data,
							contentType : false,
							processData : false,
							type:'POST',
							error : function(request, status, error){
								$("#p_alert_msg").html('파일 저장에 실패 하였습니다.');
								$('#div_alert_modal').modal("show");
								loader.off();
							},
							beforeSend : function(){

							},
							success: function(result){
								loader.off();
								$(location).attr("href", 'estimation_info_detail.jsp?_order_id_=' + order_id)
							}
						});
					}
				});
			}
		}

		$.order_file_delete = function(order_file_id, order_file_seq) {
			$.ajax({
				url: './estimation_file_data_delete_proc.jsp',
				data: { '_order_id_':order_file_id, '_file_seq_':order_file_seq },
				error : function(request, status, error){
					$("#p_alert_msg").html('파일 삭제에 실패 하였습니다.');
					$('#div_alert_modal').modal("show");
					loader.off();
					location.reload();
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

		$.order_cost_delete = function(cost_order_id, cost_order_cost_seq) {
			$.ajax({
				url: './estimation_info_cost_delete_proc.jsp',
				data: { '_cost_order_id_':cost_order_id, '_cost_order_cost_seq_':cost_order_cost_seq },
				error : function(request, status, error){
					$("#p_alert_msg").html('파일 삭제에 실패 하였습니다.');
					$('#div_alert_modal').modal("show");
					loader.off();
					location.reload();
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

		var sPath=window.location.pathname;
		var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
		$(".pmd-sidebar-nav").each(function(){
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").addClass("open");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('.dropdown-menu').css("display", "block");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('a.dropdown-toggle').addClass("active");
			$(this).find("a[href='"+sPage+"']").addClass("active");
		});

		$.fnc_cost_row_add = function() {
			var seq = $("input[id='txt_cost_code_sub_name']").length;
			seq = Number(seq);

			if(String(seq) == '0'){
				$('#tbl_cost_item_list tbody tr').remove();
			}

			var tags = '';
			tags += '<tr id="tr_cost_' + seq  + '">';
			tags += '	<td style="text-align:center;">' + (seq + 1) + '</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">';
			tags += '		<input type="text" id="txt_cost_code_name" name="txt_cost_code_name" style="width:100%; padding:5px; background-color:#eee;" value="" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_id" name="txt_cost_code_id">';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">';
			tags += '	</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;"><button class="btn btn-primary next" type="button" style="font-size:8px;" data-param_01="' +  seq + '" data-param_02="0001" data-toggle="modal" id="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);">선 택</button></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:left; background-color:#eee;" value="" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right;" value=""  onKeyUp="JavaScript:$.fnc_only_number(this, \'' + seq + '\');"></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_price" name="txt_cost_cost_price"onKeyUp="JavaScript:$.fnc_only_number_unit_price(\'C\', this, \'' + seq + '\');"  readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc;"></td>';
			tags += '</tr>';

			$('#tbl_cost_item_list tbody').append(tags);
		}

		$.fnc_file_row_add = function() {
			var seq = $("a[id='btn_file_download']").length;
			if(String(seq) == '0'){
				$('#tbl_file_item_list tbody tr').remove();
			}
			seq = Number(seq)+1;

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
			if(obj.id == 'txt_building_type'){
				console.log('건축물구조 목록');
				$('#modal_title').text('건축물구조 목록');
			}else if(obj.id == 'btn_cost_code_list'){
				console.log('지출품목 목록');
				$('#modal_title').text('지출품목 목록');
			}else if(obj.id == 'txt_building_deconstruction_report_yn_name'){
				console.log('해체신고여부 목록');
				$('#modal_title').text('해체신고여부 목록');
			}
		};

		$.fnc_select_to_parent = function(seq, code_id, code_sub_id, code_name, code_sub_name, code_unit, code_price, code_comment) {
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
			else if(code_id=='0002') {
				$('input[name=txt_building_type]').val(code_sub_name);
				$('input[name=txt_building_type_id]').val(code_id+code_sub_id);
				if(code_sub_name!=''){ $('input[name=txt_building_type]').focus(); };
			}
			else if(code_id=='0003') {
				$('input[name=txt_building_deconstruction_report_yn_name]').val(code_sub_name);
				$('input[name=txt_building_deconstruction_report_yn]').val(code_id+code_sub_id);
				if(code_sub_name!=''){ $('input[name=txt_building_deconstruction_report_yn_name]').focus(); };
			}
			$('#form-dialog_cost_code').modal('hide');

			if(code_sub_id=='0000') {
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).val('');
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).attr('placeholder', '기타');
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).css('background-color', '#fff');
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).attr('readOnly', false);
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).attr('placeholder', '0');
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).css('background-color', '#fff');
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).attr('readOnly', false);
			}
		};

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

		//입력한 문자열 전달
		$.inputNumberFormat = function(obj) {
			obj.value = $.comma($.uncomma(obj.value));
		}

		//콤마찍기
		$.comma = function(str) {
			str = String(str);
			return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		}

		//콤마풀기
		$.uncomma = function(str) {
			str = String(str);
			return str.replace(/[^\d]+/g, '');
		}

		//숫자만 리턴(저장할때)
		//alert(cf_getNumberOnly('1,2./3g')); -> 123 return
		$.cf_getNumberOnly = function(str) {
			var len      = str.length;
			var sReturn  = "";

			for (var i=0; i<len; i++){
				if ( (str.charAt(i) >= "0") && (str.charAt(i) <= "9") ){
					sReturn += str.charAt(i);
				}
			}
			return sReturn;
		}

		$.fnc_only_number = function(obj, seq) {
		 	if ($(obj).val() != null && $(obj).val() != '') {
				$('input[name=txt_cost_total_price]').focus();
				$('input[name=txt_cost_total_price]').blur();
				$(obj).focus();
		 		var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				var code_price = $('input[name=txt_cost_cost_price]').eq(Number(seq)).val().replace(/,/gi, '');
				var cost_total_price = Number(code_price)*tmps;
		 		cost_total_price = cost_total_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
				$('input[name=txt_cost_cost_total_price]').eq(Number(seq)).val(cost_total_price);
		 		var tmps2 = tmps.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
		 		$(obj).val(tmps2);

				var cost_array = [];
				cost_array = $('input[name=txt_cost_cost_total_price]');

				var total = 0;

				for(var i=0; i<cost_array.length; i++) {
					total += Number(cost_array.eq(i).val().replace(/,/gi, ''));
				}

				$('input[name=txt_cost_total_price]').val($.fnc_comma(total));
		 	}
		}

		//콤마찍기
		$.fnc_comma = function(str) {
			str = String(str);
			return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		}

		$.volume_calc_string= function(obj) {
			var origin_number_array = [];
			var origin_number = 0;
			var int_number = 0;
			var dbl_number = 0;
			var total_string = '';
			if ($(obj).val() != null && $(obj).val() != '') {
				origin_number_array = $(obj).val().split(" ");
				origin_number = origin_number_array[0];
				int_number = $.fnc_only_number_with_value($.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[0]);
				dbl_number = $.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[1];
				total_string = origin_number + ' ' + int_number + '.' + dbl_number;
				console.log('> ' + total_string);
				$(obj).attr('placeholder', total_string);
			}
		}

		$.volume_calc_py= function(obj, target) {
			// var origin_number_array = [];
			var origin_number = 0;
			var int_number = 0;
			var dbl_number = 0;
			var total_string = '';
			if ($(obj).val() != null && $(obj).val() != '') {
				origin_number = Number($(obj).val().replace(/[^0-9]/g, ''));
				int_number = $.fnc_only_number_with_value($.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[0]);
				dbl_number = $.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[1];
				total_string = int_number + '.' + dbl_number;
				$('input[name=' + target + ']').val(total_string);
			}
		}

		$('input[name=txt_building_volume]').focus(function(){
			$('input[name=txt_building_volume_py]').focus();
			if($('input[name=txt_building_volume]').val()=='') {
				$('input[name=txt_building_volume_py]').val('0');
			}
			this.focus();
		});

		$('input[name=txt_building_base_volume]').focus(function(){
			$('input[name=txt_building_base_volume_py]').focus();
			if($('input[name=txt_building_base_volume]').val()=='') {
			$('input[name=txt_building_base_volume_py]').val('0');
			}
			this.focus();
		});

		$.fnc_only_number_with_comma_volume = function(obj, target) {
			if ($(obj).val() != null && $(obj).val() != '') {
				var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				$(obj).val($.fnc_comma(tmps));

				$.volume_calc_py(obj, target);
			}

			if($(obj).val() == '') {
				$('input[name=' + target + ']').val('');
				$('input[name=' + target + ']').blur();
			}
		}

		$.fnc_only_number_with_comma = function(obj) {
			if ($(obj).val() != null && $(obj).val() != '') {
				var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				$(obj).val($.fnc_comma(tmps));
			}
		}

		$.fnc_only_number_with_value = function(number) {
				var tmps = parseInt(number.replace(/[^0-9]/g, '')) || '0';
				return $.fnc_comma(tmps);
			// }
		}

		$.py_calculator_with_value = function(origin_type, value){
			var volume_value = 0;

			if(origin_type==1){ volume_value = parseFloat(value) * 3.3058; }
			else if(origin_type==2){ volume_value = parseFloat(value) / 3.3058;}

			return volume_value;
		}

		$.py_calculator = function(origin_type, obj){
			var volume_value = 0;

			if(origin_type==1){ volume_value = parseFloat($(obj).val()) * 3.3058; }
			else if(origin_type==2){ volume_value = parseFloat($(obj).val()) / 3.3058;}

			return volume_value;
		}

		$.fnc_report_data_copy = function() {
			// console.log($('#frm_order_data').serialize());
			$('#txt_process_type').val('C');
			jQuery.ajax({
				url: 'estimation_info_save_proc.jsp',
				data: $('#frm_order_data').serialize(),
				error : function(){
					console.log('error');
					// $("#p_alert_msg").html("변경사항에 실패하였습니다.");
					// $('#div_alert_modal').modal("show");
					// loader.off();
				},
				beforeSend : function(){
					// loader.on(function(){
					// });
				},
				success: function(result){
					console.log('error');
					/*
					var list_info = JSON.parse(result);
					var hour = '';
					var min = '';

					jQuery.each(list_info, function(key, value){
						console.log(key);
						console.log(value.length);

						if(value.length>0) {
							for(var i=0; i<value.length; i++) {
								// console.log('> value[i].current_date ' + value[i].clm_current_date);
								hour = value[i].clm_current_date_hh;
								min = value[i].clm_current_date_mm;
								// document.getElementById('txt_revision_id_prod').value = value[i]._clm_report_revision_info_prod_;
							}
						}
					});

					if(step=='1') {
						$('#btn_data_save_01').attr('disabled', true);
						$('#txt_setting_hour_01').val(hour);
						$('#txt_setting_min_01').val(min);
						for(var i=0; i<$('input[id=txt_check_temp_01]').length; i++) {
							$('input[name=txt_check_temp_01]:eq(' + i + ')').css('background-color', '#eee');
							$('input[name=txt_check_temp_01]:eq(' + i + ')').attr('readOnly', true)
						}
					}
					else if(step=='2') {
						$("#btn_data_save_02").attr('disabled', true);
						$('#txt_setting_hour_02').val(hour);
						$('#txt_setting_min_02').val(min);
						for(var i=0; i<$('input[id=txt_check_temp_02]').length; i++) {
							$('input[name=txt_check_temp_02]:eq(' + i + ')').css('background-color', '#eee');
							$('input[name=txt_check_temp_02]:eq(' + i + ')').attr('readOnly', true)
						}
					}
					else if(step=='3') {
						$("#btn_data_save_03").attr('disabled', true);
						$('#txt_setting_hour_03').val(hour);
						$('#txt_setting_min_03').val(min);
						for(var i=0; i<$('input[id=txt_check_temp_03]').length; i++) {
							$('input[name=txt_check_temp_03]:eq(' + i + ')').css('background-color', '#eee');
							$('input[name=txt_check_temp_03]:eq(' + i + ')').attr('readOnly', true)
						}
					}

					$('#btn_data_save').blur();
					$("#p_alert_msg").html("변경사항이 저장되었습니다.");
					loader.off();
					$('#div_alert_modal').modal("show");
					$('#btn_confirm').focus();
					*/
				}
			});
		}

		$.fnc_pdf_download = function() {
			var originalContents = document.body.innerHTML;
			window.onbeforeprint = function(){
				$('.no_print').css('display','none');
				var printContents = document.getElementById("print_position").innerHTML;
				document.body.innerHTML = printContents;
			};
			window.onafterprint = function(){
				document.body.innerHTML = originalContents;
			};
			window.print();
		}

		$.fnc_excel_download = function() {

		}

		$.fnc_print = function() {
			// ifrm_page
			$('#ifrm_page').attr('src', 'estimation_info_detail_print.jsp?_str_order_id_=<%=_order_id_ %>');
			// iframe_print();
			/*
			var originalContents = document.body.innerHTML;
			window.onbeforeprint = function(){
				$('.no_print').css('display','none');
				var printContents = document.getElementById("print_position").innerHTML;
				document.body.innerHTML = printContents;
			};
			window.onafterprint = function(){
				document.body.innerHTML = originalContents;
			};
			window.print();
			*/
		}


		function divPrint() {
			var inbody = document.body.innerHTML; // 이전 body 영역 저장
			window.onbeforeprint = function () { // 프린트 화면 호출 전 발생하는 이벤트
				document.body.innerHTML = document.getElementById('targetDiv').innerHTML; // 원하는 영역 지정
			}
			window.onafterprint = function () { // 프린트 출력 후 발생하는 이벤트
				document.body.innerHTML = inbody; // 이전 body 영역으로 복구
			}
			window.print();
		}

		function iframe_print() {
			window.frames['ifrm_page'].focus();
			window.frames['ifrm_page'].print();
		}

		$('#txt_work_process_01_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_02_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_03_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_04_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_05_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_06_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_07_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_08_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_09_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_10_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "left",
				vertical: "auto"
			}
		});

		$('#txt_work_process_11_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "left",
				vertical: "auto"
			}
		});

		$('#txt_work_process_12_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_13_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_14_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_15_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_16_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_17_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_18_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_19_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_process_20_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: 'auto',
				vertical: 'auto'
			}
		});

		$('#txt_work_process_21_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: 'left',
				vertical: 'auto'
			}
		});

		$('#txt_work_process_22_schedule').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning:{
				horizontal: 'left',
				vertical: 'auto'
			}
		});

		$('#txt_work_start_date').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_work_end_date').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});
	});
</script>
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
	<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
		$('#txt_building_address_detail').focus();
    }

    function sample2_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    // document.getElementById("sample2_extraAddress").value = extraAddr;

                } else {
                    // document.getElementById("sample2_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                // document.getElementById('sample2_postcode').value = data.zonecode;
                document.getElementById("txt_building_address").value = data.zonecode + ' ' + addr + ' ' + extraAddr;
                document.getElementById("txt_building_address").focus();
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("txt_building_address_detail").focus();

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 800; //우편번호서비스가 들어갈 element의 width
        var height = 455; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>
<!--
<iframe id="ifrm_page" name="ifrm_page" width="0" height="0">
</iframe>
-->
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>