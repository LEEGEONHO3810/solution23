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

<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-theme.css" />

<!-- Propeller admin theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-admin.css">

<!-- Propeller date time picker css-->
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/pmd-datetimepicker.css" />

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

h2 {
	font-family: 'NanumSquare';
	font-size: 18px;
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
<div class="pmd-sidebar-overlay"></div>

<!-- Left sidebar -->
<%@ include file="include/left_navigation.jsp" %>
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
				<span>작업 정보 관리</span>
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
									<input type="checkbox" id="OK" name="result" value="1" checked>&nbsp;완료</span>
								</td>
							</tr>
						</table>
						<div class="progress-rounded progress">
							<div class="progress-bar progress-bar-danger" style="width: 77%;"></div>
						</div>
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; border-bottom: 0px solid white; margin-top:-10px;">
							<tbody>
								<tr>
									<td style="border: 1px solid white; text-align:left; width:20%; padding:0px; font-weight:bold;">2022.07.05</td>
									<td style="border: 1px solid white; text-align:center; width:60%; padding:0px;">진행중(77%)</td>
									<td style="border: 1px solid white; text-align:right; width:20%; padding:0px; font-weight:bold;">2022.07.25</td>
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
									<input type="checkbox" id="OK" name="result" value="1" checked>&nbsp;완료</span>
								</td>
							</tr>
						</table>
						<div class="progress-rounded progress">
							<div class="progress-bar progress-bar-success" style="width: 54%;"></div>
						</div>
						<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; border-bottom: 0px solid white; margin-top:-10px;">
							<tbody>
								<tr>
									<td style="border: 1px solid white; text-align:left; width:20%; padding:0px; font-weight:bold;">0 원</td>
									<td style="border: 1px solid white; text-align:center; width:60%; padding:0px;">진행중(54%)</td>
									<td style="border: 1px solid white; text-align:right; width:20%; padding:0px; font-weight:bold;">20,000,000 원</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive pmd-card pmd-z-depth" style="padding:2px; background-color:transparent; border:  1px solid transparent; box-shadow: none;">
		</div>
		<div class="table-responsive pmd-card pmd-z-depth">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
								 작업명<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="만민중앙교회(구로구 구로동)">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									수행기간<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="2016-09-20 ~ 2016-10-20">
							</div>
						</div>
					</div>
					<!--
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
								 Email<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="admin@itfactory.io">
							</div>
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
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt.png" style="width:10px; height:10px;">
											건축물해체허가신청기간
											<!--
											<a href="javascript:void(0);" class="btn pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-default btn-sm">
												<i class="material-icons md-dark pmd-sm" style="font-size:12px;" onClick="JavaScript:$.fnc_obj_del(this);" id="1">cancel</i>
											</a>
											-->
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<span style="background-color:red; color: white; font-weight:bold; padding:5px;">
												<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
												착공계제출
											</span>
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											감리자계약
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											감리자지정</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											해체착공계제출</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											해체허가완료</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											비산먼지신고기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											비산먼지신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											특정공사신고기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											특정공사신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											도로점용신고</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											건축물구조검토기간</td>
										<td style="padding:0px;" rowspan="2">▶</td>
									</tr>
									<tr>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">2022.07.05</td>
										<td style="text-align:center; padding:0px; padding-bottom:10px;">
											<span style="background-color:red; color: white; font-weight:bold; padding:5px;">2022.07.05</span>
										</td>
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
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											건축물구조검토완료
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											철거심의기간
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											철거심의완료
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											건설폐기물신고
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											석면신고기간
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											석면공사
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											해체완료
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											감리완료
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											멸실신고
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											등기정리
										</td>
										<td style="padding:0px;" rowspan="2">▶</td>
										<td style="border-bottom: 1px solid white; text-align:center;">
											<img src="img/task_alt_gray.png" style="width:10px; height:10px;">
											공사완료
										</td>
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
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 20%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											지 출
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 80%;">
										등록일자
										<input type="text" id="datetimepicker-default" placeholder="" style="border:1px solid #999;" />
										<button type="button" class="btn btn-success btn-sm" onClick="location.href='#'"> 조회 </button >
										<button type="button" class="btn btn-primary btn-sm" onClick="location.href='#'"> 등록 </button >
									</td>
								</tr>
							</table>
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>날짜</th>
										<th>공정</th>
										<th>인원</th>
										<th>기사</th>
										<th>장비</th>
										<th>일당</th>
										<th>금액</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>2016-09-20</td>
										<td>철거 장비비</td>
										<td></td>
										<td>일</td>
										<td>13</td>
										<td style="text-align:right;">1,000,000</td>
										<td style="text-align:right;">13,000,000</td>
									</tr>
									<tr>
										<td>2016-09-20</td>
										<td>철거 인건비</td>
										<td>기공</td>
										<td>품</td>
										<td>16</td>
										<td style="text-align:right;">150,000</td>
										<td style="text-align:right;">2,400,000</td>
									</tr>
									<tr>
										<td>2016-09-20</td>
										<td></td>
										<td>조공</td>
										<td>품</td>
										<td>20</td>
										<td style="text-align:right;">130,000</td>
										<td style="text-align:right;">2,600,000</td>
									</tr>
									<tr>
										<td>2016-09-20</td>
										<td>건설폐기물 처리비</td>
										<td>운반</td>
										<td>대</td>
										<td>53</td>
										<td style="text-align:right;">100,000</td>
										<td style="text-align:right;">5,300,000</td>
									</tr>
									<tr>
										<td>2016-09-20</td>
										<td></td>
										<td>처리</td>
										<td>대</td>
										<td>53</td>
										<td style="text-align:right;">220,000</td>
										<td style="text-align:right;">11,660,000</td>
									</tr>
									<tr>
										<td>2016-09-20</td>
										<td>고철,비철,스크랩</td>
										<td></td>
										<td>톤</td>
										<td>-31</td>
										<td style="text-align:right;">450,000</td>
										<td style="text-align:right;">-13,950,000</td>
									</tr>
									<tr>
										<td>2016-09-20</td>
										<td>단위절삭</td>
										<td></td>
										<td>식</td>
										<td>-1</td>
										<td style="text-align:right;">10,000</td>
										<td style="text-align:right;">-10,000</td>
									</tr>
									<tr>
										<td colspan="2">합 계</td>
										<td></td>
										<td></td>
										<td></td>
										<td style="text-align:right;"></td>
										<td style="text-align:right;">21,000,000</td>
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
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="padding:0px; margin:0px;">
								<tr>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: left; width: 20%;">
										<label for="regular1" class="control-label" style="font-size:16px;">
											수 입
										</label>
									</td>
									<td style="padding:5px; margin:0px; border:0px solid transparent; text-align: right; width: 80%;">
										등록일자
										<input type="text" id="datetimepicker-default" placeholder="" style="border:1px solid #999;" />
										<button type="button" class="btn btn-success btn-sm" onClick="location.href='#'"> 조회 </button >
										<button type="button" class="btn btn-primary btn-sm" onClick="location.href='#'"> 등록 </button >
									</td>
								</tr>
							</table>
							<table id="example" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th>날짜</th>
										<th>유형</th>
										<th>품목</th>
										<th>업체명</th>
										<th>중량</th>
										<th>단가</th>
										<th>금액</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>2016-09-20</td>
										<td>고철</td>
										<td>철사</td>
										<td>가가종합</td>
										<td style="text-align:right;">13.0Kg</td>
										<td style="text-align:right;">1,000,000</td>
										<td style="text-align:right;">13,000,000</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td colspan="2">합 계</td>
										<td></td>
										<td></td>
										<td style="text-align:right;"></td>
										<td style="text-align:right;"></td>
										<td style="text-align:right;">0</td>
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
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
								 손익대차<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" style="text-align:right; font-weight:bold;" value="-21,000,000">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
								 Email<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="admin@itfactory.io">
							</div>
						</div>
						<!--
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
								 첨부파일
								</label>
								<input type="file" id="regular1" class="form-control" style="font-size:10px;">
							</div>
						</div>
						-->
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									주소<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_addr_01" class="form-control" value="" readOnly onClick="JavaScript:sample2_execDaumPostcode();">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									상세주소<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" class="form-control" value="" id="txt_addr_02">
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
<!-- Javascript for Datepicker -->
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>

<script>
	// Default date and time picker
	$('#datetimepicker-default').datetimepicker();

	// View mode datepicker [shows only years and month]
	$('#datepicker-view-mode').datetimepicker({
		viewMode: 'years',
		format: 'MM/YYYY'
	});

	// Inline datepicker
	$('#datepicker-inline').datetimepicker({
		inline: true
	});

	// Time picker only
	$('#timepicker').datetimepicker({
		format: 'LT'
	});

	// Linked date and time picker
	// start date date and time picker
	$('#datepicker-start').datetimepicker();

	// End date date and time picker
	$('#datepicker-end').datetimepicker({
		useCurrent: false
	});

	// start date picke on chagne event [select minimun date for end date datepicker]
	$("#datepicker-start").on("dp.change", function (e) {
		$('#datepicker-end').data("DateTimePicker").minDate(e.date);
	});
	// Start date picke on chagne event [select maxmimum date for start date datepicker]
	$("#datepicker-end").on("dp.change", function (e) {
		$('#datepicker-start').data("DateTimePicker").maxDate(e.date);
	});

	// Disabled Days of the Week (Disable sunday and saturday) [ 0-Sunday, 1-Monday, 2-Tuesday   3-wednesday 4-Thusday 5-Friday 6-Saturday]
	$('#datepicker-disabled-days').datetimepicker({
		 daysOfWeekDisabled: [0, 6]
	});

	// Datepicker in popup
	$('#datepicker-popup-inline').datetimepicker({
		inline: true
	});

	$("[data-header-left='true']").parent().addClass("pmd-navbar-left");

	// Datepicker left header
	$('#datepicker-left-header').datetimepicker({
		'format' : "YYYY-MM-DD HH:mm:ss", // HH:mm:ss
	});
</script>

</body>
</html>