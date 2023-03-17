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
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico" />
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="assets/css/propeller.min.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/select2.min.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/select2-bootstrap.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/pmd-select2.css" />
<link rel="stylesheet" type="text/css" href="themes/css/propeller-theme.css" />
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

<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<body>
<!-- Header Starts -->
<!--Start Nav bar -->
<nav class="navbar navbar-inverse navbar-fixed-top pmd-navbar pmd-z-depth" style="border-color: <%=header_color %>; background-color: <%=header_color %>;">

	<div class="container-fluid">
		<%@ include file="include/notice_info.jsp" %>
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
			if(!__order_id__.equals("")) {
				strCondition += "and x.clm_order_id='" + __order_id__ + "' ";
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
			<form id="validationForm" action="" method="post">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									거래처<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="regular1" class="form-control" value="<%=clm_client_name %>">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 작업명<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="regular1" class="form-control" value="<%=clm_order_name %>">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <label for="regular1" class="control-label">
							 Email<span style="font-weight:bold; color:red;">*</span>
						   </label>
						   <input type="text" id="regular1" class="form-control" value="<%=clm_order_email %>">
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
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 주소<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="regular1" class="form-control" value="<%=clm_building_address %>">
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						   <div class="form-group pmd-textfield pmd-textfield-floating-label">
							   <label for="regular1" class="control-label">
								 건축물구조<span style="font-weight:bold; color:red;">*</span>
							   </label>
							   <input type="text" id="regular1" class="form-control" value="<%=clm_building_type %>">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">층고</label>
							<input type="text" class="mat-input form-control" id="mobil" value="<%=clm_building_height %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">연면적</label>
							<input type="text" class="mat-input form-control" id="email" value="<%=clm_building_volume %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">대지면적</label>
							<input type="text" class="mat-input form-control" id="email" value="<%=clm_building_base_volume %>">
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">해체신고여부</label>
							<input type="text" class="mat-input form-control" id="email" value="<%=clm_building_deconstruction_report_yn %>">
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
								<textarea required class="form-control" style="text-align:left;"><%=clm_comment %></textarea>
							</div>
						</div>
					</div>
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