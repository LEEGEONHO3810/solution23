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
<title>Table with Expand/Collapse | Propeller - Admin Dashboard</title>
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico">

<!-- Google icon -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- Bootstrap css -->
<link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">

<!-- Propeller css -->
<link rel="stylesheet" type="text/css" href="assets/css/propeller.min.css">

<!-- Select2 css-->
<link rel="stylesheet" type="text/css" href="components/select2/css/select2.min.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/select2-bootstrap.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/pmd-select2.css" />

<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-theme.css" />

<!-- Propeller admin theme css-->
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

.select2-results__option {
  font-size: 10px;
}

/*
@font-face {
	font-family: 'NanumBarunGothicBold';
	src: url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot');
	src: url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot')
		format('embedded-opentype'),
		url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.woff')
		format('woff');
}
*/
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
		<div class="pmd-navbar-right-icon pull-right navigation">


			<!-- Notifications -->
            <div class="dropdown notification icons pmd-dropdown">

				<a href="javascript:void(0)" title="Notification" class="dropdown-toggle pmd-ripple-effect"  data-toggle="dropdown" role="button" aria-expanded="true">
					<div data-badge="3" class="material-icons md-light pmd-sm pmd-badge  pmd-badge-overlap">notifications_none</div>
				</a>

				<div class="dropdown-menu dropdown-menu-right pmd-card pmd-card-default pmd-z-depth" role="menu">
					<!-- Card header -->
					<div class="pmd-card-title">
						<div class="media-body media-middle">
							<a href="notifications.html" class="pull-right">4개 견적 등록되었습니다.</a>
							<h3 class="pmd-card-title-text">알림</h3>
						</div>
					</div>

					<!-- Notifications list -->
					<ul class="list-group pmd-list-avatar pmd-card-list">
						<li class="list-group-item hidden">
							<p class="notification-blank">
								<span class="dic dic-notifications-none"></span>
								<span>You don´t have any notifications</span>
							</p>
						</li>
						<li class="list-group-item unread">
							<a href="javascript:void(0)">
								<div class="media-left">
									<span class="avatar-list-img40x40">
										<img alt="40x40" data-src="holder.js/40x40" class="img-responsive" src="themes/images/profile-1.png" data-holder-rendered="true">
									</span>
								</div>
								<div class="media-body">
									<span class="list-group-item-heading"><span>Prathit</span> posted a new challanegs</span>
									<span class="list-group-item-text">5 Minutes ago</span>
								</div>
							</a>
						</li>
						<li class="list-group-item">
							<a href="javascript:void(0)">
								<div class="media-left">
									<span class="avatar-list-img40x40">
										<img alt="40x40" data-src="holder.js/40x40" class="img-responsive" src="themes/images/profile-2.png" data-holder-rendered="true">
									</span>
								</div>
								<div class="media-body">
									<span class="list-group-item-heading"><span>Keel</span> Cloned 2 challenges.</span>
									<span class="list-group-item-text">15 Minutes ago</span>
								</div>
							</a>
						</li>
						<li class="list-group-item unread">
							<a href="javascript:void(0)">
								<div class="media-left">
									<span class="avatar-list-img40x40">
										<img alt="40x40" data-src="holder.js/40x40" class="img-responsive" src="themes/images/profile-3.png" data-holder-rendered="true">
									</span>
								</div>

								<div class="media-body">
									<span class="list-group-item-heading"><span>John</span> posted new collection.</span>
									<span class="list-group-item-text">25 Minutes ago</span>
								</div>
							</a>
						</li>
						<li class="list-group-item unread">
							<a href="javascript:void(0)">
								<div class="media-left">
									<span class="avatar-list-img40x40">
										<img alt="40x40" data-src="holder.js/40x40" class="img-responsive" src="themes/images/profile-4.png" data-holder-rendered="true">
									</span>
								</div>
								<div class="media-body">
									<span class="list-group-item-heading"><span>Valerii</span> Shared 5 collection.</span>
									<span class="list-group-item-text">30 Minutes ago</span>
								</div>
							</a>
						</li>
					</ul><!-- End notifications list -->

				</div>


            </div> <!-- End notifications -->
		</div>
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
<div class="pmd-sidebar-overlay"></div>

<!-- Left sidebar -->
<aside id="basicSidebar" class="pmd-sidebar  sidebar-default pmd-sidebar-slide-push pmd-sidebar-left pmd-sidebar-open bg-fill-darkblue sidebar-with-icons" role="navigation">
	<ul class="nav pmd-sidebar-nav">

		<!-- User info -->
		<li class="dropdown pmd-dropdown pmd-user-info visible-xs visible-md visible-sm visible-lg">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" aria-expandedhref="javascript:void(0);">
				<div class="media-left">
					<img src="themes/images/user-icon.png" alt="New User">
				</div>
				<div class="media-body media-middle">시스템 관리자</div>
				<div class="media-right media-middle"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<li><a href="login.jsp">Logout</a></li>
			</ul>
		</li><!-- End user info -->

		<li>
			<a class="pmd-ripple-effect" href="index.html">
				<i class="media-left media-middle"><svg version="1.1" x="0px" y="0px" width="19.83px" height="18px" viewBox="287.725 407.535 19.83 18" enable-background="new 287.725 407.535 19.83 18"
	 xml:space="preserve">
<g>
	<path fill="#C9C8C8" d="M307.555,407.535h-9.108v10.264h9.108V407.535z M287.725,407.535v6.232h9.109v-6.232H287.725z
		 M296.834,415.271h-9.109v10.264h9.109V415.271z M307.555,419.303h-9.108v6.232h9.108V419.303z"/>
</g>
</svg></i>
				<span class="media-body">대시보드</span>
			</a>
		</li>

		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="media-left media-middle"><svg version="1.1" x="0px" y="0px" width="18px" height="18.001px" viewBox="0 0 18 18.001" enable-background="new 0 0 18 18.001" xml:space="preserve">
<path fill="#C9C8C8" d="M6.188,0.001C5.232,0.001,4.5,0.732,4.5,1.688c0,0.394,0.166,0.739,0.334,1.02L5.45,3.71
	c0.113,0.113,0.176,0.341,0.176,0.51v0.281c0,0.619-0.506,1.125-1.125,1.125H0.282c-0.169,0-0.281,0.112-0.281,0.281V17.72
	c0,0.168,0.112,0.281,0.281,0.281h4.219c0.619,0,1.125-0.506,1.125-1.125v-0.281c0-0.168-0.063-0.397-0.176-0.509
	c0,0-0.615-0.946-0.615-1.002C4.666,14.802,4.5,14.457,4.5,14.063c0-0.956,0.731-1.688,1.688-1.688s1.688,0.731,1.688,1.688
	c0,0.394-0.166,0.739-0.334,1.02l-0.616,1.002c-0.056,0.112-0.176,0.341-0.176,0.509v0.281c0,0.619,0.506,1.125,1.125,1.125h4.219
	c0.168,0,0.281-0.113,0.281-0.281V13.5c0-0.619,0.506-1.125,1.125-1.125h0.281c0.169,0,0.396,0.063,0.51,0.176
	c0,0,0.945,0.616,1.002,0.616c0.337,0.168,0.626,0.334,1.02,0.334c0.956,0,1.687-0.731,1.687-1.687c0-0.957-0.731-1.688-1.687-1.688
	c-0.394,0-0.738,0.166-1.02,0.334l-1.002,0.616c-0.113,0.056-0.341,0.176-0.51,0.176H13.5c-0.619,0-1.125-0.506-1.125-1.125V5.908
	c0-0.168-0.113-0.281-0.281-0.281H7.875c-0.619,0-1.125-0.506-1.125-1.125V4.221c0-0.168,0.063-0.397,0.176-0.51
	c0,0,0.616-0.945,0.616-1.001c0.168-0.281,0.334-0.626,0.334-1.02C7.875,0.733,7.144,0.002,6.188,0.001L6.188,0.001z"/>
</svg></i>
				<span class="media-body">MES</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<li><a href="estimation_list.jsp">MES 정보 조회</a></li>
				<li><a href="estimation_calendar.jsp">MES 정보 일정</a></li>
				<li><a href="estimation_info_reg.jsp">MES 정보 등록</a></li>
				<li><a href="work_list.jsp">작업 정보 관리</a></li>
			</ul>
		</li>
		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">swap_calls</i>
				<span class="media-body">기초정보 관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<li><a href="partnet_list.jsp">업체 정보 관리</a></li>
				<li><a href="user_list.jsp">직원 정보 관리</a></li>
				<li><a href="system_info.jsp">시스템 정보 관리</a></li>
				<li><a href="code_list.jsp">코드 정보 관리</a></li>
			</ul>
		</li>
	</ul>
</aside><!-- End Left sidebar -->
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
			query += "x.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
			query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count, ";
			query += "(select clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id) clm_client_name ";
			query += "from ";
			query += "	tbl_order_info x ";
			query += "where 1=1 " + strCondition + " ";
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
				String clm_order_id								 = rs.getString("clm_order_id");
				String clm_client_id								= rs.getString("clm_client_id");
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
				String clm_client_name							 = rs.getString("clm_client_name");
				String clm_order_email							 = rs.getString("clm_order_email");
%>
<!--content area start-->
<div id="content" class="pmd-content inner-page">
<!--tab start-->
    <div class="container-fluid full-width-container value-added-detail-page">
		<div>
			<div class="pull-right table-title-top-action">
				<!--
				<div class="pmd-textfield pull-left">
				  <input type="text" id="exampleInputAmount" class="form-control" placeholder="Search for...">
				</div>
				<a href="javascript:void(0);" class="btn btn-primary pmd-btn-raised add-btn pmd-ripple-effect pull-left">조회</a>
				-->
			</div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>MES 정보 등록</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
			  <li><a href="index.html">Home</a></li>
			  <li class="active">MES</li>
			  <li class="active">MES 정보 등록</li>
			</ol><!--breadcrum end-->
		</div>

		<div class="table-responsive pmd-card pmd-z-depth">
			<!--section-title -- >
			<h2>Basic Form</h2>< !--section-title end -->
			<!-- section content start-->
			<form name="frm_order_data" id="frm_order_data">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									거래처<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_client_name" name="txt_client_name" class="form-control" value="<%=clm_client_name %>">
								<input type="hidden" id="txt_client_id" name="txt_client_id" class="form-control" value="<%=clm_client_id %>">
								<input type="hidden" id="txt_order_id" name="txt_order_id" class="form-control" value="<%=_order_id_ %>">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 작업명<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="txt_order_name" class="form-control" value="<%=clm_order_name %>">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <label for="regular1" class="control-label">
							 Email<span style="font-weight:bold; color:red;">*</span>
						   </label>
						   <input type="text" id="txt_order_email" name="txt_order_email" class="form-control" value="<%=clm_order_email %>">
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
										<button type="button" class="btn btn-primary btn-sm" onClick="JavaScript:$.fnc_cost_row_add();"> 등록 </button >
									</td>
								</tr>
							</table>
							<table id="tbl_cost_item_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border:1px solid #ccc;">
								<thead>
									<tr>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:5%;">No.</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:15%;" colspan="2">품 명</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:5%;">규 격</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:15%;">단 위</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:5%;">수 량</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:10%;">단 가</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:10%;">금 액</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; width:10%;">특이사항</th>
									</tr>
								</thead>
								<tbody>
<%
		try {
			Statement stmt_cost = conn.createStatement();
			strCondition = "";
			if(!strOrderId.equals("")) {
				strCondition += "and x.clm_order_id='" + strOrderId + "' ";
			}
			query  = "";
			query += "select ";
			query += "x.*, ";
			query += "(select y.clm_code_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_id) y) clm_code_name, ";
			query += "(select y.clm_code_sub_name from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_sub_name, ";
			query += "(select y.clm_code_unit_type from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit_type, ";
			query += "(select y.clm_code_unit from fn_code_sub_info(x.clm_cost_id, x.clm_cost_sub_id) y) clm_code_unit ";
			query += "from ";
			query += "	tbl_order_sub_cost x ";
			query += "where 1=1 " + strCondition + " ";
			query += "order by x.clm_order_id desc, x.clm_order_cost_seq;";
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
				String clm_cost_cost_count      = String.format("%,d", Integer.parseInt(rs_cost.getString("clm_cost_count")));
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
				String clm_cost_cost_price			= String.format("%,d", Integer.parseInt(rs_cost.getString("clm_cost_unit_price")));
				String clm_cost_cost_total_price			= String.format("%,d", Integer.parseInt(rs_cost.getString("clm_cost_unit_price")) * Integer.parseInt(rs_cost.getString("clm_cost_count")));

				System.out.println("> clm_cost_cost_price " + clm_cost_cost_price);
				System.out.println("> clm_cost_cost_count " + clm_cost_cost_count);
				System.out.println("> clm_cost_cost_total_price " + clm_cost_cost_total_price);
%>
									<tr id="tr_cost_<%=iSubRowCnt %>">
										<td style="padding:5px; border:1px solid #ccc; text-align:center;"><%=iSubRowCnt+1 %></td>
										<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">
											<input type="text" style="width:100%; padding:5px; background-color:#eee;" value="<%=clm_cost_code_name %>" id="txt_cost_code_name" name="txt_cost_code_name" readOnly>
											<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_id %>" id="txt_cost_code_id" name="txt_cost_code_id">
											<input type="hidden" style="width:100%; padding:5px;" value="<%=clm_cost_cost_sub_id %>" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">
										</td>
										<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;">
											<button class="btn btn-primary next" type="button" style="font-size:8px;" data-param_01="<%=iSubRowCnt %>" data-toggle="modal" id="btn_cost_code_list" name="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);">선 택</button>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:center;">
											<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="<%=clm_cost_code_unit %>" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:center;">
											<input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="<%=clm_cost_code_sub_name %>" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right;" value="<%=clm_cost_cost_count %>" onKeyUp="JavaScript:$.fnc_only_number(this, '<%=iSubRowCnt %>');">
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="<%=clm_cost_cost_price %>" id="txt_cost_cost_price" name="txt_cost_cost_price" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc; text-align:right;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="<%=clm_cost_cost_total_price %>" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly>
										</td>
										<td style="padding:5px; border:1px solid #ccc;">
											<input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="<%=clm_cost_comment %>" id="txt_cost_comment" name="txt_cost_comment" readOnly>
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
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 주소<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="txt_building_address" class="form-control" value="<%=clm_building_address %>">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 건축물구조<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="txt_building_type" name="txt_building_type" class="form-control" value="<%=clm_building_type %>">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">층고</label>
							<input type="text" class="mat-input form-control" id="txt_building_height" name="txt_building_height" value="<%=clm_building_height %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">연면적</label>
							<input type="text" class="mat-input form-control" id="txt_building_volume" name="txt_building_volume" value="<%=clm_building_volume %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">대지면적</label>
							<input type="text" class="mat-input form-control" id="txt_building_base_volume" name="txt_building_base_volume" value="<%=clm_building_base_volume %>">
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">해체신고여부</label>
							<input type="text" class="mat-input form-control" id="txt_building_deconstruction_report_yn" name="txt_building_deconstruction_report_yn" value="<%=clm_building_deconstruction_report_yn %>">
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-16">
							<div class="form-group pmd-textfield pmd-textfield-floating-label" style="padding-top:3px;">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" style="ta_comment;" name="ta_comment"><%=clm_comment %></textarea>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 30%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											첨부파일
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 70%;">
										<button type="button" class="btn btn-primary btn-sm" onClick="JavaScript:$.fnc_file_row_add();"> 등록 </button >
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
			if(!strOrderId.equals("")) {
				strCondition += "and x.clm_order_id='" + strOrderId + "' ";
			}
			query  = "";
			query += "select ";
			query += "x.* ";
			query += "from ";
			query += "	tbl_order_file x ";
			query += "where 1=1 " + strCondition + " ";
			query += "order by x.clm_order_id desc, x.clm_order_file_seq;";
			System.out.println("> " + strCurrentReportId + ".data_list " + query);
			ResultSet rs_file = stmt_file.executeQuery(query);

			reqDateStr = "";
			reqDateTime = 0;
			curDateTime = 0;
			minute = 0;
			duration_minute = "";

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
				String clm_file_file_full_name = clm_file_file_name + "." + clm_file_file_ext;
%>
									<tr id="tr_file_<%=iSubRowCnt %>">
										<td Style="border:1px solid #ccc; width:5%; text-align:center;"><%=iSubRowCnt+1 %></td>
										<td Style="border:1px solid #ccc; width:65%; text-align:left;"><%=clm_file_file_full_name %></td>
										<td Style="border:1px solid #ccc; width:10%; text-align:right;"><%=clm_file_file_size %>kb</td>
										<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;">
											<a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_download">다운로드</a>
										</td>
										<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;">
											<a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_delete">삭제</a>
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
				</div>
				<div class="pmd-card-actions">
					<a href="javascript:void(0);" class="btn btn-primary next" onClick="JavaScript:$.fnc_report_data_save();">저장</a>
					<a href="javascript:void(0);" class="btn btn-success next">복제</a>
					<a href="javascript:void(0);" class="btn btn-default">취소</a>
				</div>
			</div> <!-- section content end -->
			</form>
		</div>
		<!-- Card Footer -->
		<div class="pmd-card-footer">
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

		$.fnc_cost_row_add = function() {
			var seq = $("input[id='txt_cost_code_sub_name']").length;
			seq = Number(seq);

			var tags = '';
			tags += '<tr id="tr_cost_' + seq  + '">';
			tags += '	<td style="text-align:center;">' + seq + '</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">';
			tags += '		<input type="text" id="txt_cost_code_name" name="txt_cost_code_name" style="width:100%; padding:5px; background-color:#eee;" value="" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_id" name="txt_cost_code_id">';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">';
			tags += '	</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;"><button class="btn btn-primary next" type="button" style="font-size:8px;" data-param_01="' +  seq + '" data-toggle="modal" id="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);">선 택</button></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right;" value=""  onKeyUp="JavaScript:$.fnc_only_number(this, \'' + seq + '\');"></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_price" name="txt_cost_cost_price" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee; background-color:#eee;" value="" id="txt_cost_comment" name="txt_cost_comment" readOnly></td>';
			tags += '</tr>';

			$('#tbl_cost_item_list tbody').append(tags);
		}

		$.fnc_file_row_add = function() {
			var seq = $("a[id='btn_file_download']").length;
			seq = Number(seq)+1;

			var tags = '';
			tags += '<tr id="tr_file_' + seq  + '">';
			tags += '	<td Style="border:1px solid #ccc; width:5%; text-align:center;">' + seq + '</td>';
			tags += '	<td Style="border:1px solid #ccc; width:65%; text-align:left;"><input type="file" id="fl_attached_file" style="width:100%;"></td>';
			tags += '	<td Style="border:1px solid #ccc; width:10%; text-align:right;">0kb</td>';
			tags += '	<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;"><a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_download" disabled>다운로드</a></td>';
			tags += '	<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;"><a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_delete" disabled>삭제</a></td>';
			tags += '</tr>';

			$('#tbl_file_item_list tbody').append(tags);
		}

		$.fnc_modal_cost_code = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_cost_code_list.jsp?seq=' + param_01);
			$('#form-dialog_cost_code').modal('show');
		};

		$.fnc_select_to_parent = function(seq, code_id, code_sub_id, code_name, code_sub_name, code_unit, code_price, code_comment) {
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
			$('#form-dialog_cost_code').modal('hide');
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

		$.fnc_report_data_save = function() {
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
	});
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

</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>