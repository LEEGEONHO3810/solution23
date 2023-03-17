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

<!-- DataTables css-->
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.1.0/css/responsive.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">
<!-- Propeller dataTables css-->

<link rel="stylesheet" type="text/css" href="components/data-table/css/pmd-datatable.css">

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

h2 {
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
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-12 col-md-12 col-sm-12 col-xs-12">
									<label for="first-name">견적명</label>
									<input type="text" class="mat-input form-control" id="name" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">고객명</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">지역</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label class="control-label">영업사원</label>
									<input type="text" class="mat-input form-control" id="mobil" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">착공년도</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">건축물구조</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">층고</label>
									<input type="text" class="mat-input form-control" id="mobil" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">연면적</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">대지면적</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
									<label for="first-name">해체신고여부</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-12 col-md-12 col-sm-12 col-xs-12">
									<label for="first-name">특이사항</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
							</form>
						</div>
						<div class="pmd-modal-action">
							<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-primary" type="button">조회</button>
							<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-default" type="button">취소</button>
						</div>
					</div>
				</div>
			</div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>MES 정보 조회</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.html">Home</a></li>
				<li class="active">MES</li>
				<li class="active">MES 정보 조회</li>
			</ol><!--breadcrum end-->
		</div>
		<!-- Table -->
		<div class="table-responsive pmd-card pmd-z-depth">
			<table id="main_list" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%" style="border-top:5px solid #666;">
				<thead>
					<tr>
						<th style="font-size:14px; font-weight:bold;">관리번호</th>
						<th style="font-size:14px; font-weight:bold;">작업명</th>
						<th style="font-size:14px; font-weight:bold;">견적가액</th>
						<th style="font-size:14px; font-weight:bold;">층고</th>
						<th style="font-size:14px; font-weight:bold;">상태</th>
						<th style="font-size:14px; font-weight:bold;">등록일시</th>
						<th style="font-size:14px; font-weight:bold;">수정/삭제</th>
						<th style="font-size:14px; font-weight:bold;">첨부문서</th>
						<th style="font-size:14px; font-weight:bold;">메일발송완료</th>
						<th style="font-size:14px; font-weight:bold;">등록직원</th>
					</tr>
				</thead>
				<tbody>
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
			if(!strOrderId.equals("")) {
				strCondition += "and x.clm_order_id='" + strOrderId + "' ";
			}
			String query  = "";
			query += "select ";
			query += "x.*, (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted, ";
			query += "(select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y) clm_user_name, ";
			query += "(select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
			query += "from ";
			query += "	tbl_order_info x ";
			query += "where 1=1 and x.clm_del_yn='N' and x.clm_order_state_type='B' " + strCondition + " ";
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
				String clm_user_name							 = rs.getString("clm_user_name");
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
%>
					<tr id="tr_<%=clm_order_id %>">
						<td data-title="Ticket No">
							<a href="estimation_info_detail.jsp?_order_id_=<%=clm_order_id %>" style="font-weight:bold; color:#4285f4;">
							<%=clm_order_id %>
							</a>
						</td>
						<td data-title="building_address" style="padding:0px;">
							<a href="javascript:void(0);" class="btn pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-default btn-sm">
								<i class="material-icons md-dark pmd-sm" style="color:<%=clm_order_state_color %>;">check_circle_outline</i>
							</a>
							<%=clm_building_address %>
						</td>
						<td data-title="order_estimation_price">\<%=clm_order_estimation_price %></td>
						<td data-title="building_height"><%=clm_building_height %>m</td>
						<td data-title="building_type">
							<span class="status-btn blue-bg">
								<%=clm_building_type %>
							</span>
						</td>
						<td data-title="reg_datetime"><%=clm_reg_datetime %></td>
						<td class="pmd-table-row-action">
							<a href="JavaScript:$.order_modify_select('<%=clm_order_id %>', '<%=clm_order_state_type %>')" class="btn pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-default btn-sm">
								<i class="material-icons md-dark pmd-sm">edit</i>
							</a>
							<a href="javascript:$.fnc_report_data_delete('<%=clm_order_id %>');" class="btn pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-default btn-sm">
								<i class="material-icons md-dark pmd-sm">delete</i>
							</a>
						</td>
						<td class="pmd-table-row-action">
							<%
								if(Integer.parseInt(clm_file_count)>0) {
							%>
							<a href="javascript:void(0);" class="btn pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-default btn-sm">
								<i class="material-icons md-dark pmd-sm" style="color:red;">file_download</i>
							</a>
							<%
								}
								else {
							%>
							<i class="material-icons md-dark pmd-sm" style="color:grey;">file_download</i>
							<%
								}
							%>
						</td>
						<td class="pmd-table-row-action">
							<a href="javascript:$.fnc_report_data_mail('<%=clm_order_email %>');" class="btn pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-default btn-sm">
								<i class="material-icons md-dark pmd-sm" style="color:red;">domain_verification</i>
							</a>
							<a href="#" data-target="#form-dialog_02" data-toggle="modal" style="font-weight:bold;">
								재발송
							</a>
						</td>
						<td data-title="Browser Name"><%=clm_user_name %></td>
					</tr>
<%
				iRowCnt++;
			}

			int iRowCntTmp = 15;

			if(iRowCnt<iRowCntTmp) {
				for(int i=0; i<iRowCntTmp-iRowCnt; i++) {
%>
					<tr>
						<td data-title="Ticket No"></td>
						<td data-title="Browser Name" style="padding:10px; height:50px;"></td>
						<td data-title="Month"></td>
						<td data-title="Month"></td>
						<td data-title="Status"></td>
						<td data-title="date"></td>
						<td class="pmd-table-row-action"></td>
						<td class="pmd-table-row-action"></td>
						<td class="pmd-table-row-action"></td>
						<td data-title="Browser Name"></td>
					</tr>
<%
				}
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
%>
				</tbody>
			</table>
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
<script type="text/javascript">
$(document).ready(function () {
	$(".direct-expand").click(function(){
		$(".direct-child-table").slideToggle(300);
		$(this).toggleClass( "child-table-collapse" );
	});
});
</script>

<!-- Responsive Data table js-->
<script>
//Propeller  Customised Javascript code
$(document).ready(function() {
	$.order_modify_select = function(order_id, order_state) {
		if(order_state=='B') {
			$("#p_alert_msg").html("주문 상태인 견적입니다.");
			$('#div_alert_modal').modal("show");
		}
		else {
			$(location).attr("href", 'estimation_info_modify.jsp?_order_id_=' + order_id)
		}
	}

	var exampleDatatable = $('#example').DataTable({
		responsive: {
			details: {
				type: 'column',
				target: 'tr'
			}
		},
		/*
		columnDefs: [ {
			className: 'control',
			orderable: false,
			targets:   1
		} ],
		*/
		order: [ 1, 'asc' ],
		bFilter: true,
		bLengthChange: false,
		pagingType: "simple",
		"paging": false,
		"searching": false,
		"language": {
			"info": " _START_ - _END_ of _TOTAL_ ",
			"sLengthMenu": "<span class='custom-select-title'>Rows per page:</span> <span class='custom-select'> _MENU_ </span>",
			"sSearch": "",
			"sSearchPlaceholder": "Search",
			"paginate": {
				"sNext": " ",
				"sPrevious": " "
			},
		},
		dom:
			// "<'pmd-card-title'<'data-table-responsive pull-left'><'search-paper pmd-textfield'f>>" +
			"<'row'<'col-sm-12'tr>>" +
			"<'pmd-card-footer' <'pmd-datatable-pagination' l i p>>",
	});

	$.fnc_report_data_delete = function(order_id) {
		jQuery.ajax({
			url: 'estimation_info_delete_proc.jsp',
			data: {
				'_order_id_' : order_id,
			},
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
				$('#tr_' + order_id).children().remove();
				var tag = '';
				tag += '<tr>';
				tag += '	<td data-title="TicketNo"></td>';
				tag += '	<td data-title="building_address"style="padding:0px;"></td>';
				tag += '	<td data-title="order_estimation_price">&nbsp;</td>';
				tag += '	<td data-title="building_height"></td>';
				tag += '	<td data-title="building_type"></td>';
				tag += '	<td data-title="reg_datetime"></td>';
				tag += '	<td class="pmd-table-row-action"></td>';
				tag += '	<td class="pmd-table-row-action"></td>';
				tag += '	<td class="pmd-table-row-action"></td>';
				tag += '	<td data-title="BrowserName"></td>';
				tag += '</tr>';
				$('#main_list > tbody:last').append(tag);
				$("#p_alert_msg").html("견적 삭제되었습니다.");
				$('#div_alert_modal').modal("show");
			}
		});
	}

	$.fnc_report_data_mail = function(email) {
		jQuery.ajax({
			url: 'estimation_info_mail_proc.jsp',
			data: {
				'_order_id_' : email,
			},
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
			}
		});
	}

	/// Select value
	$('.custom-select-info').hide();

	// $(".data-table-responsive").html('<h2 class="pmd-card-title-text">Responsive Data table</h2>');
	$(".custom-select-action").html('<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">delete</i></button><button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">more_vert</i></button>');

} );
</script>
<!-- Scripts Ends -->

</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>