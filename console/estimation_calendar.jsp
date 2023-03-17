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
<%@ include file="include/conn_info.jsp" %>
<%@ include file="include/session_info.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta charset="utf-8" />
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
<!-- DataTables css-->
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.1.0/css/responsive.bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css" />
<!-- Propeller dataTables css-->
<link rel="stylesheet" type="text/css" href="components/data-table/css/pmd-datatable.css" />
<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-theme.css" />
<!-- Propeller admin theme css-->
<link rel="stylesheet" type="text/css" href="themes/css/propeller-admin.css" />
<link href='calendar/packages/core/main.css' rel='stylesheet' />
<link href='calendar/packages/daygrid/main.css' rel='stylesheet' />
<link href='calendar/packages/timegrid/main.css' rel='stylesheet' />
<script src='calendar/packages/core/main.js'></script>
<script src='calendar/packages/interaction/main.js'></script>
<script src='calendar/packages/daygrid/main.js'></script>
<script src='calendar/packages/timegrid/main.js'></script>
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
	font-weight: bold;
}

.th {
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

.tr {
	background-color: #fff;
	font-size:12px;
	font-weight:normal;
	color:#333;
	border-bottom:1px solid #ccc;
}

.td {
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
#calendar {
	margin: 0 auto;
}
#calendar-container {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
}

.fc-header-toolbar {
	padding-top: 1em;
	padding-left: 0px;
	padding-right: 0px;
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
	String customer_name = (request.getParameter("customer_name") == null)?"":request.getParameter("customer_name");
	String order_name = (request.getParameter("order_name") == null)?"":request.getParameter("order_name");
%>
<!--content area start-->
<div id="content" class="pmd-content inner-page">
<!--tab start-->
		<div class="container-fluid full-width-container value-added-detail-page">
		<div class="pmd-card-title" style="padding-left:16px; padding-top:29px; padding-right:0px;">
			<div class="pull-right table-title-top-action">
				<!--
				<div class="pmd-textfield pull-left">
					<input type="text" id="exampleInputAmount" class="form-control" placeholder="Search for...">
				</div>
				-->
				<button data-target="#form-dialog" data-toggle="modal" class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button">검색조건</button>
			</div>
			<div tabindex="-1" class="modal fade" id="form-dialog" style="display: none;" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header bordered">
							<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
							<h2 class="pmd-card-title-text">검색조건</h2>
						</div>
						<div class="modal-body">
							<form class="form-horizontal">
								<div class="form-group pmd-textfield pmd-textfield-floating-label">
									<label for="first-name">거래처</label>
									<input type="text" class="mat-input form-control" id="customer_name" value="<%=customer_name %>">
								</div>
								<div class="form-group pmd-textfield pmd-textfield-floating-label">
									<label for="first-name">수행기간</label>
									<input type="text" class="mat-input form-control" id="order_name" value="<%=order_name %>">
								</div>
							</form>
						</div>
						<div class="pmd-modal-action">
							<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" onClick="JavaScript:$.fnc_search();" type="button">조회</button>
							<button data-dismiss="modal" class="btn pmd-ripple-effect btn-default" type="button">닫기</button>
						</div>
					</div>
				</div>
			</div>

			<div tabindex="-1" class="modal fade" id="form-dialog-order" style="display: none;" aria-hidden="true">
				<div class="modal-dialog" style="width:1000px;">
					<div class="modal-content">
						<div class="modal-header bordered">
							<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
							<h2 id="dialog_title" class="pmd-card-title-text">견적정보</h2>
						</div>
						<div class="modal-body" style="background-color:white;">
							<iframe id="ifrm_estimation" name="ifrm_estimation" style="border:0px; width:100%; height:1020px; background-color:white; padding:0px;">
							</iframe>

							<div style="margin-top:15px;">
								<!--
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" onClick="JavaScript:$.fnc_location('E');" type="button">견적확인</button>
								-->
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" type="button">닫기</button>
							</div>
							<!--
							<form class="form-horizontal">
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <input type="hidden" id="dis_order_id" value="" />
									   <label for="regular1" class="control-label" style="text-align:left;">거래처</label>
									   <input type="text" id="dis_client_name" name="dis_client_name" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업명</label>
									   <input type="text" id="dis_order_name" name="dis_order_name" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">건축물구조</label>
									   <input type="text" id="dis_building_deconstruction_report_yn" name="dis_building_deconstruction_report_yn" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">지출견적 총계</label>
									   <input type="text" id="dis_estimation_price" name="dis_estimation_price" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업지 주소</label>
									   <input type="text" id="dis_building_address" name="dis_building_address" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업지 상세주소</label>
									   <input type="text" id="dis_building_address_detail" name="dis_building_address_detail" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업시작일자</label>
									   <input type="text" id="dis_work_start_date" name="dis_work_start_date" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업종료일자</label>
									   <input type="text" id="dis_work_end_date" name="dis_work_end_date" class="form-control" value="" readonly />
									</div>
								</div>
							</form>
							-->
						</div>
					</div>
				</div>
			</div>

			<div tabindex="-1" class="modal fade" id="form-dialog-order2" style="display: none;" aria-hidden="true">
				<div class="modal-dialog" style="width:1000px;">
					<div class="modal-content">
						<div class="modal-header bordered">
							<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
							<h2 id="dialog_title" class="pmd-card-title-text">작업정보</h2>
						</div>
						<div class="modal-body">
							<iframe id="ifrm_work" name="ifrm_work" style="border:0px; width:100%; height:1020px; background-color:white; padding:0px;">
							</iframe>

							<div style="margin-top:15px;">
								<!--
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" onClick="JavaScript:$.fnc_location('E');" type="button">견적확인</button>
								-->
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" type="button">닫기</button>
							</div>
							<!--
							<form class="form-horizontal">
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <input type="hidden" id="dis2_order_id" value="" />
									   <label for="regular1" class="control-label" style="text-align:left;">거래처</label>
									   <input type="text" id="dis2_client_name" name="dis2_client_name" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업명</label>
									   <input type="text" id="dis2_order_name" name="dis2_order_name" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">건축물구조</label>
									   <input type="text" id="dis2_building_deconstruction_report_yn" name="dis2_building_deconstruction_report_yn" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">지출견적 총계</label>
									   <input type="text" id="dis2_estimation_price" name="dis2_estimation_price" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업지 주소</label>
									   <input type="text" id="dis2_building_address" name="dis2_building_address" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업지 상세주소</label>
									   <input type="text" id="dis2_building_address_detail" name="dis2_building_address_detail" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업시작일자</label>
									   <input type="text" id="dis2_work_start_date" name="dis2_work_start_date" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">작업종료일자</label>
									   <input type="text" id="dis2_work_end_date" name="dis2_work_end_date" class="form-control" value="" readonly />
									</div>
								</div>
								<div class="group-fields clearfix row">
									<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">사업소요비용(ⓐ)</label>
									   <input type="text" id="dis2_work_cost_total" name="dis2_work_cost_total" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">현장자재수입(ⓑ)</label>
									   <input type="text" id="dis2_work_income_total" name="dis2_work_income_total" class="form-control" value="" readonly />
									</div>
									<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
									   <label for="regular1" class="control-label" style="text-align:left;">사업지출비용(ⓒ = ⓐ + ⓑ)</label>
									   <input type="text" id="dis2_work_calc_total" name="dis2_work_calc_total" class="form-control" value="" readonly />
									</div>
								</div>
							</form>

							<div style="margin-top:15px;">
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" onClick="JavaScript:$.fnc_location('E');" type="button">견적확인</button>
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" onClick="JavaScript:$.fnc_location('W');" type="button">작업확인</button>
								<button data-dismiss="modal" class="btn pmd-ripple-effect btn-default" type="button">닫기</button>
							</div>
							-->
						</div>
					</div>
				</div>
			</div>
			<!-- Title -->
			<h1 class="pmd-card-title-text typo-fill-secondary" style="font-size:32px;">
				<span>MES 정보 일정</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.html">Home</a></li>
				<li class="active">MES</li>
				<li class="active">MES 정보 일정</li>
			</ol><!--breadcrum end-->
		</div>
		<!-- Table -->
		<div style="width:100%;">
			<div id='calendar'></div>
		</div>
		<!-- Card Footer -->
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
<!-- Datatable js -->
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
<!-- Datatable Bootstrap -->
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>
<!-- Datatable responsive js-->
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/responsive/2.1.0/js/dataTables.responsive.min.js"></script>
<!-- Datatable select js-->
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js"></script>
<!--detail page table data expand collapse javascript-->
<link href="./fullcalendar/main.css" rel="stylesheet" />
<script src="./fullcalendar/main.js"></script>
<script src="./fullcalendar/locales-all.js"></script>
<script type="text/javascript">
$(document).ready(function () {
	$(".direct-expand").click(function(){
		$(".direct-child-table").slideToggle(300);
		$(this).toggleClass( "child-table-collapse" );
	});

	$.fnc_search = function() {
		var customer_name = $('#customer_name').val();
		var order_name = $('#order_name').val();
		var url = './estimation_calendar.jsp';

		if(customer_name != ''){
			url += '?customer_name='+customer_name;
		}
		if(customer_name != '' && order_name != ''){
			url += '&order_name='+order_name;
		}else if(order_name != ''){
			url += '?order_name='+order_name;
		}

		location.href = url;
	}

	$.fnc_location = function(type) {
		$('#ifrm_estimation').attr('src', 'blank_iframe.jsp');
		$('#ifrm_work').attr('src', 'blank_iframe.jsp');
		// $('#ifrm_estimation').modal('hide');
		// var order_id = $('#dis_order_id').val();
		// if(order_id == ''){
		// 	order_id = $('#dis2_order_id').val();
		// }
		// if(type == 'E'){
		// 	location.href = './estimation_info_detail.jsp?_order_id_='+order_id;
		// }else if(type == 'W'){
		// 	location.href = './work_info_detail.jsp?_order_id_='+order_id;
		// }
	}
});
</script>
<script>
	var calendar = null;
	document.addEventListener('DOMContentLoaded', function () {
		$(function () {
			var params = {
							'order_name':'<%=order_name %>',
							'customer_name':'<%=customer_name %>'
						 };
			var request = jQuery.ajax({
				url: './include/estimation_calendar_select_query.jsp',
				data: params,
				type: 'POST',
				dataType : 'json',
				beforeSend : function(){
				}
			});

			request.done(function (data) {
				var calendarEl = document.getElementById('calendar');
				calendar = new FullCalendar.Calendar(calendarEl, {
					locale: "ko",
					initialView: 'dayGridMonth',
					fixedWeekCount: false, //마지막주 안나오게
					aspectRatio: 1.6,
					dateClick: function(info) {
					},
					eventClick: function(info){
						var title = info.event._def.title;
						var order_id = info.event._def.extendedProps.order_id;
						var client_name = info.event._def.extendedProps.client_name;
						var estimation_price = info.event._def.extendedProps.estimation_price;
						var building_deconstruction_report_yn = info.event._def.extendedProps.building_deconstruction_report_yn;
						var building_address = info.event._def.extendedProps.building_address;
						var building_address_detail = info.event._def.extendedProps.building_address_detail;
						var order_state_type = info.event._def.extendedProps.order_state_type;
						var start_date = info.event._def.extendedProps.start_date;
						var end_date = info.event._def.extendedProps.end_date;
						var work_cost_total = info.event._def.extendedProps.work_cost_total;
						var work_income_total = info.event._def.extendedProps.work_income_total;
						var work_calc_total = info.event._def.extendedProps.work_calc_total;

						$('#dis_order_id').val('');
						$('#dis2_order_id').val('');
						console.log('> order_state_type ' + order_state_type);
						if(order_state_type == 'A'){
							$('#ifrm_estimation').attr('src', 'estimation_info_detail_iframe.jsp?_str_order_id_=' + order_id);
							$('#form-dialog-order').modal("show");
							// $('#dis_order_id').val(order_id);
							// $('#dis_order_name').val(title);
							// $('#dis_client_name').val(client_name);
							// $('#dis_work_start_date').val(start_date);
							// $('#dis_work_end_date').val(end_date);
							// $('#dis_estimation_price').val(estimation_price);
							// $('#dis_building_deconstruction_report_yn').val(building_deconstruction_report_yn);
							// $('#dis_building_address').val(building_address);
							// $('#dis_building_address_detail').val(building_address_detail);
							// $('#form-dialog-order').modal("show");
						}else if(order_state_type == 'B'){
							$('#ifrm_work').attr('src', 'work_info_detail_iframe.jsp?_str_order_id_=' + order_id);
							$('#form-dialog-order2').modal("show");
							// $('#dis2_order_id').val(order_id);
							// $('#dis2_order_name').val(title);
							// $('#dis2_client_name').val(client_name);
							// $('#dis2_work_start_date').val(start_date);
							// $('#dis2_work_end_date').val(end_date);
							// $('#dis2_estimation_price').val(estimation_price);
							// $('#dis2_building_deconstruction_report_yn').val(building_deconstruction_report_yn);
							// $('#dis2_building_address').val(building_address);
							// $('#dis2_building_address_detail').val(building_address_detail);
							// $('#dis2_work_cost_total').val(work_cost_total);
							// $('#dis2_work_income_total').val(work_income_total);
							// $('#dis2_work_calc_total').val(work_calc_total);
							// $('#form-dialog-order2').modal("show");
						}
					},
					events: data
				});
				calendar.render();

				$('.fc-header-toolbar').attr('style', "margin-bottom:10px;");
				$('th.fc-license-message').attr('style', "display:none;");
				$('th.fc-day-sun > div > a').attr('style', "color:red;");
				$('th.fc-day-sat > div > a').attr('style', "color:blue;");
				$('.fc-daygrid-day-frame').attr('style', "cursor:pointer;");

			});

			request.fail(function(jqXHR, textStatus) {
				alert( "Request failed: " + textStatus );
			});
		});
	});
</script>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>