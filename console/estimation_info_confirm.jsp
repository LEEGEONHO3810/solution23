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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description" content="Table with Expand/Collapse | Propeller - Admin Dashboard">
<meta content="width=device-width, initial-scale=1, user-scalable=no" name="viewport">
<title>Table with Expand/Collapse | Propeller - Admin Dashboard</title>
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico">
<%@ include file="include/session_info.jsp" %>

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
</head>

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
			<form id="validationForm" action="" method="post">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									거래처<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="대륭건설">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									작업명<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="만민중앙교회(구로구 구로동)">
							</div>
						</div>
					</div>
					<!--
					<table cellspacing="0" width="100%" style="width:100%; border-bottom: 0px solid #ccc;">
						<tr>
							<td style="width:50%; border: 0px solid #ccc;"></td>
							<td style="width:50%; border: 0px solid #ccc;"></td>
						</tr>
					</table>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
					   <div class="form-group pmd-textfield pmd-textfield-floating-label">
						   <label for="regular1" class="control-label">
							 첨부파일
						   </label>
						   <input type="file" id="regular1" class="form-control" style="font-size:10px;">
						</div>
					</div>
					-->
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<label for="regular1" class="control-label">
								Email<span style="font-weight:bold; color:red;">*</span>
							</label>
							<input type="text" id="regular1" class="form-control" value="admin@itfactory.io">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									작업소요일자<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="20 일" style="text-align:right;">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									사업소요비용(ⓐ)<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="25,000,000 원" style="text-align:right;">
							</div>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									현장자재수입(ⓑ)<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="-5,000,000 원" style="text-align:right;">
							</div>
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									사업지출비용(ⓐ - ⓑ)<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="20,000,000 원" style="text-align:right;">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
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
										<td style="border-bottom: 1px solid white; text-align:center;">건축물해체허가신청기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">착공계제출</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">감리자계약</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">감리자지정</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">해체착공계제출</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">해체허가완료</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">비산먼지신고기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">비산먼지신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">특정공사신고기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">특정공사신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">도로점용신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">건축물구조검토기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
									</tr>
									<tr>
										<td style="border-bottom: 1px solid white; text-align:center;">건축물구조검토완료</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">철거심의기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">철거심의완료</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">건설폐기물신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">석면신고기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">석면공사</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">해체완료</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">감리완료</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">멸실신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">등기정리</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">공사완료</td>
										<td style="padding:0px;" rowspan="2"></td>
										<td style="border-bottom: 1px solid white; text-align:center;"></td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;"></td>
									</tr>
								</tbody>
							</table>
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
										<!--
										<button type="button" class="btn btn-primary btn-sm" onClick="location.href='#'"> 등록 </button >
										-->
									</td>
								</tr>
							</table>
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>No.</th>
										<th>품 명</th>
										<th>규 격</th>
										<th>단 위</th>
										<th>수 량</th>
										<th>단 가</th>
										<th>금 액</th>
										<th>특이사항</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>1</td>
										<td>철거 장비비</td>
										<td></td>
										<td>일</td>
										<td>13</td>
										<td>1,000,000</td>
										<td>13,000,000</td>
										<td></td>
									</tr>
									<tr>
										<td>2</td>
										<td>철거 인건비</td>
										<td>기공</td>
										<td>품</td>
										<td>16</td>
										<td>150,000</td>
										<td>2,400,000</td>
										<td></td>
									</tr>
									<tr>
										<td></td>
										<td></td>
										<td>조공</td>
										<td>품</td>
										<td>20</td>
										<td>130,000</td>
										<td>2,600,000</td>
										<td></td>
									</tr>
									<tr>
										<td>3</td>
										<td>건설폐기물 처리비</td>
										<td>운반</td>
										<td>대</td>
										<td>53</td>
										<td>100,000</td>
										<td>5,300,000</td>
										<td></td>
									</tr>
									<tr>
										<td></td>
										<td></td>
										<td>처리</td>
										<td>대</td>
										<td>53</td>
										<td>220,000</td>
										<td>11,660,000</td>
										<td></td>
									</tr>
									<tr>
										<td>4</td>
										<td>고철,비철,스크랩</td>
										<td></td>
										<td>톤</td>
										<td>-31</td>
										<td>450,000</td>
										<td>-13,950,000</td>
										<td></td>
									</tr>
									<tr>
										<td>5</td>
										<td>단위절삭</td>
										<td></td>
										<td>식</td>
										<td>-1</td>
										<td>10,000</td>
										<td>-10,000</td>
										<td></td>
									</tr>
									<tr>
										<td colspan="2">합 계</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>21,000,000</td>
										<td></td>
									</tr>
									<!--
									<tr>
										<td colspan="2">특이사항</td>
										<td colspan="6">1. 철거면허 등록업체 2. 산재보험, 근재보험, 영업배상보험가입업체 3. 석면해체.제거등록업체 4. 고재비 및 폐기물처리비는 평균시세로 적용함.</td>
									</tr>
									-->
								</tbody>
							</table>
						</div>
					</div>
					<!--
					<div class="group-fields clearfix row">
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label>작업유형 상위*</label>
								<select class="select-simple form-control pmd-select2">\
								</select>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label>작업유형 하위*</label>
								<select class="select-simple form-control pmd-select2">
								</select>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									견적가액*
								</label>
								<input type="text" id="regular1" class="form-control">
							</div>
						</div>
					</div>
					-->
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 주소<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="regular1" class="form-control" value="경기도 안산시 단원구 시흥대로 84-6 (선부동)">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 건축물구조<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="regular1" class="form-control" value="">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">층고</label>
							<input type="text" class="mat-input form-control" id="mobil" value="">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">연면적</label>
							<input type="text" class="mat-input form-control" id="email" value="">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">대지면적</label>
							<input type="text" class="mat-input form-control" id="email" value="">
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">해체신고여부</label>
							<input type="text" class="mat-input form-control" id="email" value="">
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label" style="padding-top:3px;">
							   <label for="regular1" class="control-label">
								 첨부파일
							   </label>
							   <input type="file" id="regular1" class="form-control" style="font-size:10px; ">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" style="text-align:left;">1. 철거면허 등록업체 2. 산재보험, 근재보험, 영업배상보험가입업체 3. 석면해체.제거등록업체 4. 고재비 및 폐기물처리비는 평균시세로 적용함.</textarea>
							</div>
						</div>
					</div>
					<!--
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="checkbox pmd-default-theme">
								<label class="pmd-checkbox checkbox-pmd-ripple-effect">
									<input type="checkbox" value="">
									<span>Save Details</span>
								</label>
							</div>
						</div>
					</div>
					-->
				</div>
				<div class="pmd-card-actions">
					<a href="javascript:void(0);" class="btn btn-primary next">저장</a>
					<a href="javascript:void(0);" class="btn btn-success next">복제</a>
					<a href="javascript:void(0);" class="btn btn-default">취소</a>
				</div>
			</div> <!-- section content end -->
			</form>
		</div>
		<!-- Card Footer -->
		<div class="pmd-card-footer">
			<!--
		  <ul class="pmd-pagination pull-right list-inline">
			  <span>Rows per page:</span> <span class="dropdown pmd-dropdown">
			  <button class="btn pmd-ripple-effect pmd-btn-flat btn-link dropdown-toggle" type="button" id="dropdownMenuDivider" data-toggle="dropdown" aria-expanded="false">10 <span class="caret"></span></button>
			  <ul aria-labelledby="dropdownMenuDivider" role="menu" class="dropdown-menu">
				  <li role="presentation"><a href="javascript:void(0);" tabindex="-1" role="menuitem">10</a></li>
				  <li role="presentation"><a href="javascript:void(0);" tabindex="-1" role="menuitem">20</a></li>
				  <li role="presentation"><a href="javascript:void(0);" tabindex="-1" role="menuitem">30</a></li>
				  <li role="presentation"><a href="javascript:void(0);" tabindex="-1" role="menuitem">40</a></li>
				  <li role="presentation"><a href="javascript:void(0);" tabindex="-1" role="menuitem">50</a></li>
			  </ul>
			  </span> <span>1-10 of 100</span> <a href="javascript:void(0);" aria-label="Previous"><i class="material-icons md-dark pmd-sm">keyboard_arrow_left</i></a> <a href="javascript:void(0);" aria-label="Next"><i class="material-icons md-dark pmd-sm">keyboard_arrow_right</i></a>
		  </ul>
		  	-->
		</div>
	</div>
</div>
<!--tab start-->

<!--content area end-->

</div>

<!-- Footer Starts -->
<footer class="admin-footer">
 <div class="container-fluid">
 	<ul class="list-unstyled list-inline">
	 	<li>
			<!--
			<span class="pmd-card-subtitle-text">ITFACTORY &copy; <span class="auto-update-year"></span>. All Rights Reserved.</span>
			-->
			<h3 class="pmd-card-subtitle-text">
				(28116) 충청북도 청주시 흥덕구 송절동 718  TEL. 043-270-2000   FAX. 043-270-2099<br/>
				COPYRIGHT(c) 2020 ITFACTORY All rights reserved.
			</h3>
        </li>

        <li class="pull-right for-support">
			<a href="mailto:support@propeller.in">
          		<div>
					<svg x="0px" y="0px" width="38px" height="38px" viewBox="0 0 38 38" enable-background="new 0 0 38 38">
<g><path fill="#A5A4A4" d="M25.621,21.085c-0.642-0.682-1.483-0.682-2.165,0c-0.521,0.521-1.003,1.002-1.524,1.523
		c-0.16,0.16-0.24,0.16-0.44,0.08c-0.321-0.2-0.683-0.32-1.003-0.521c-1.483-0.922-2.726-2.125-3.809-3.488
		c-0.521-0.681-1.002-1.402-1.363-2.205c-0.04-0.16-0.04-0.24,0.08-0.4c0.521-0.481,1.002-1.003,1.524-1.483
		c0.721-0.722,0.721-1.524,0-2.246c-0.441-0.44-0.842-0.842-1.203-1.202c-0.441-0.441-0.842-0.842-1.243-1.243
		c-0.642-0.642-1.483-0.642-2.165,0c-0.521,0.521-1.002,1.002-1.524,1.523c-0.481,0.481-0.722,1.043-0.802,1.685
		c-0.08,1.042,0.16,2.085,0.521,3.047c0.762,2.085,1.925,3.849,3.328,5.532c1.884,2.286,4.17,4.05,6.815,5.333
		c1.203,0.562,2.406,1.002,3.729,1.123c0.922,0.04,1.724-0.201,2.365-0.923c0.441-0.521,0.923-0.922,1.403-1.403
		c0.682-0.722,0.682-1.563,0-2.245C27.265,22.729,26.423,21.927,25.621,21.085z"/>
	<path fill="#A5A4A4" d="M32.437,5.568C28.869,2,24.098-0.005,19.005-0.005S9.182,2,5.573,5.568C2.005,9.177,0,13.908,0,19
		s1.965,9.823,5.573,13.432c3.568,3.568,8.34,5.573,13.432,5.573s9.823-1.965,13.431-5.573
		C39.854,25.014,39.854,12.985,32.437,5.568z M30.299,30.294c-3.003,3.045-7.021,4.695-11.293,4.695
		c-4.272,0-8.291-1.65-11.294-4.695C4.666,27.29,3.016,23.271,3.016,19c0-4.272,1.649-8.291,4.695-11.294
		c3.003-3.003,7.022-4.695,11.294-4.695c4.272,0,8.291,1.649,11.293,4.695C36.56,13.924,36.56,24.075,30.299,30.294z"/>
</g></svg>
            	</div>
            	<div>
				  <span class="pmd-card-subtitle-text">For Support</span>
				  <h3 class="pmd-card-title-text">support@itfactory.io</h3>
				</div>
            </a>
        </li>
    </ul>
 </div>
</footer>
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