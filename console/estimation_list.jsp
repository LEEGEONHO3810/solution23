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
<style>
@media print 
{
	@page {
	  size: A4 landscape;
	  margin: 10mm;
	}
}
</style>
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico">
<%@ include file="include/css_00.jsp" %>
<%@ include file="include/_js_00.jsp" %>
</head>
<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<body>
<!-- Header Starts -->
<!--Start Nav bar -->
<nav class="navbar navbar-inverse navbar-fixed-top pmd-navbar pmd-z-depth" style="border-color: <%=header_color %>; background-color: <%=header_color %>;">
	<div class="container-fluid">
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
		<div class="pmd-card-title" style="padding-left:16px; padding-top:29px; padding-right:0px;">
			<div class="pull-right table-title-top-action">
				<!--
				<div class="pmd-textfield pull-left">
					<input type="text" id="exampleInputAmount" class="form-control" placeholder="Search for...">
				</div>
				-->
				<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_reg();">등록</button>
				<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_print();">인쇄</button>
				<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_pdf_download();">PDF 다운로드</button>
				<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_excel_download();">엑셀 다운로드</button>
				<!--<button data-target="#form-dialog" data-toggle="modal" class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button">검색조건</button>-->
			</div>
			<div tabindex="-1" class="modal fade" id="form-dialog" style="display: none;" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header bordered">
							<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
							<h2 class="pmd-card-title-text">검색조건</h2>
						</div>
						<div class="modal-body" style="height:450px;">
							<form class="form-horizontal">
								<!--
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-12 col-md-12 col-sm-12 col-xs-12">
									<label for="first-name">작업명</label>
									<input type="text" class="mat-input form-control" id="txt_order_name" value="">
								</div>
								-->
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">작업명</label>
									<input type="text" class="mat-input form-control" id="txt_order_name" name="txt_order_name" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">건축물구조</label>
									<input type="text" class="mat-input form-control" id="txt_building_type" name="txt_building_type" value="" data-param_01="0" data-param_02="0002" data-toggle="modal" onClick="JavaScript:$.fnc_modal_cost_code(this);" readOnly>
									<input type="hidden" id="txt_building_type_id" name="txt_building_type_id" class="form-control">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">고객명</label>
									<input type="text" class="mat-input form-control" id="txt_customer_name" name="txt_customer_name" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">영업사원</label>
									<input type="text" class="mat-input form-control" id="txt_user_name" name="txt_user_name" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-12 col-md-12 col-sm-12 col-xs-12">
									<label for="first-name">주소</label>
									<input type="text" class="mat-input form-control" id="txt_building_address" name="txt_building_address" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">착공년도 시작</label>
									<input type="text" class="mat-input form-control" id="txt_work_from_date" name="txt_work_from_date" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">착공년도 종료</label>
									<input type="text" class="mat-input form-control" id="txt_work_end_date" name="txt_work_end_date" value="">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">층고 시작</label>
									<input type="text" class="mat-input form-control" id="txt_building_from_height" name="txt_building_from_height" value="" onKeyUp="JavaScript:$.fnc_only_number_with_comma(this);">
								</div>
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-6 col-md-6 col-sm-6 col-xs-12">
									<label for="first-name">층고 종료</label>
									<input type="text" class="mat-input form-control" id="txt_building_end_height" name="txt_building_end_height" value="" onKeyUp="JavaScript:$.fnc_only_number_with_comma(this);">
								</div>
								<!--
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
								-->
								<div class="pmd-modal-action form-group pmd-textfield pmd-textfield-floating-label col-lg-12 col-md-12 col-sm-12 col-xs-12">
									<label for="first-name">특이사항</label>
									<input type="text" class="mat-input form-control" id="email" value="">
								</div>
							</form>
						</div>
						<div class="pmd-modal-action">
							<button data-dismiss="modal" class="btn pmd-ripple-effect btn-primary" type="button" onClick="JavaScript:$.fnc_search();">조회</button>
							<button data-dismiss="modal" class="btn pmd-ripple-effect btn-default" type="button">취소</button>
						</div>
					</div>
				</div>
			</div>
			<h1 class="pmd-card-title-text typo-fill-secondary" style="font-size:32px;">
				<span>MES 정보 상세</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
			  <li><a href="index.jsp">Home</a></li>
			  <li class="active">MES</li>
			  <li class="active">MES 정보 상세</li>
			</ol><!--breadcrum end-->
		</div>
		<%@ include file="include/modal/modal_cost_code.jsp" %>
		<!-- Table -->
		<div>
			<form name="frm_order_data" id="frm_order_data">
			<table id="main_list" class="table table-striped table-bordered" style="width:100%; border-top:5px solid #666;">
				<thead>
					<tr>
						<th style="font-size:14px; text-align:center; font-weight:bold; width:10px;">
							<input type="checkbox" class="dt_all_chk" id="chk_all_order_id" name="chk_all_order_id" onClick="JavaScript:$.check_all();">
						</th>
						<th style="font-size:14px; text-align:center; font-weight:bold;" width="50px;">관리번호</th>
						<th style="font-size:14px; text-align:center; font-weight:bold;" width="200px;">의뢰업체</th>
						<th style="font-size:14px; text-align:center; font-weight:bold;">작업명</th>
						<th style="font-size:14px; text-align:center; font-weight:bold;" width="120px;">견적가액</th>
						<th style="font-size:14px; text-align:center; font-weight:bold;" width="35px;">상태</th>
						<th style="font-size:14px; text-align:center; font-weight:bold;" width="110px;">등록일시</th>
						<!--
						<th style="font-size:14px; text-align:center; font-weight:bold;" width="80px;">등록직원</th>
						-->
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

		String clm_file_download_path   = "";
		String saveFolderRootLogical = "/ESTIMATION/GAGA/files";

		try {
			stmt = conn.createStatement();
			String strCondition = "";
			if(!strOrderId.equals("")) {
				strCondition += "and x.clm_order_id='" + strOrderId + "' ";
			}
			String query  = "";
			query += "select x.* ";
			query += "	   , (TO_CHAR(to_timestamp(substring(x.clm_reg_datetime, 1, 10),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')) clm_reg_datetime_formatted ";
			query += "     , (CASE ";
			query += "			 WHEN clm_order_state_type='A' THEN '견적' ";
			query += "			 WHEN clm_order_state_type='B' THEN '주문' ";
			query += "			 WHEN clm_order_state_type='C' THEN '주문취소' ";
			query += "			 WHEN clm_order_state_type='D' THEN '완료' ";
			query += "		  END) clm_order_state_type_name ";
			query += "	   , coalesce((select y.clm_client_name from tbl_client_info y where y.clm_client_id=x.clm_client_id), '-') clm_user_name ";
			query += "     , coalesce((select y.clm_user_name from fn_user_info(x.clm_reg_user_id) y), '-') clm_reg_user_name ";
			query += "     , (select count(*) from tbl_order_file y where y.clm_order_id=x.clm_order_id) clm_file_count ";
			query += "from tbl_order_info x ";
			query += "where 1=1 and x.clm_del_yn='N' " + strCondition + " ";
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

			String iSubRowCntFormatted = "";

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

				clm_file_download_path   = saveFolderRootLogical + "/" + clm_order_id + ".zip";
%>
					<tr id="tr_<%=clm_order_id %>">
						<td class="td_first_child" style="text-align:center;">
							<input type="checkbox" class="dt_chk" id="chk_order_id" name="chk_order_id" value="<%=clm_order_id %>">
						</td>
						<td data-title="Ticket No" style="font-size:14px; text-align:center;">
							<a href="estimation_info_detail.jsp?_order_id_=<%=clm_order_id %>" style="font-weight:bold; color:#4285f4;">
							<%=clm_order_id %>
							</a>
						</td>
						<td data-title="Ticket No" style="font-size:14px; text-align:left;">
							<%=clm_user_name %>
						</td>
						<td data-title="building_address" style="font-size:14px;">
							<%=clm_order_name %>
						</td>
						<td data-title="order_estimation_price" style="font-size:14px; text-align:right;">\<%=clm_estimation_price %></td>
						<td data-title="building_type" style="font-size:14px; text-align:center;">
							<span class="status-btn blue-bg">
								<%=clm_order_state_type_name %>
							</span>
						</td>
						<td data-title="reg_datetime" style="font-size:14px; text-align:center;"><%=clm_reg_datetime %></td>
						<!--<td data-title="Browser Name" style="font-size:14px; text-align:center;"><%=clm_reg_user_name %></td>-->
					</tr>
<%
				iRowCnt++;
			}
		}
		catch(Exception e) {
			System.out.println("> e.toString().0 " + e.toString());
		}

		stmt.close();
%>
				</tbody>
			</table>
			</form>
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
<!-- css 파일 -->
<link rel="stylesheet" href="https://nowonbun.github.io/Loader/loader.css">
<!-- javascript 파일 -->
<script type="text/javascript" src="https://nowonbun.github.io/Loader/loader.js"></script>

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
		/*
		if(order_state=='B') {
			$("#p_alert_msg").html("주문 상태인 견적입니다.");
			$('#div_alert_modal').modal("show");
		}
		else {
			$(location).attr("href", 'estimation_info_modify.jsp?_order_id_=' + order_id);
		}
		*/

		$(location).attr("href", 'estimation_info_modify.jsp?_order_id_=' + order_id);
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
		$.ajax({
			type: 'POST',
			url: 'MailSenderSMTP.jsp',
			data: {
				mail_receiver: 'support@itfactory.io',
				mail_title:'kenji777@itfactory.io',
				mail_text:'test'
			},
			error : function(){
				$("#p_alert_msg").html("메일 전송에 실패하였습니다.");
				$('#div_alert_modal').modal("show");
				loader.off();
			},
			beforeSend : function(){
				loader.on(function(){
				});
			},
			success: function(result){
				$("#p_alert_msg").html('메일을 정상적으로 발송 하였습니다.');
				$('#div_alert_modal').modal("show");
				loader.off();
			}
		});
	}

	<%
		clm_file_download_path = saveFolderRootLogical + "/";
	%>

	$.fnc_search = function() {
		var order_name				 = $('input[name=txt_order_name]').val();
		var customer_name			 = $('input[name=txt_customer_name]').val();
		var building_address		 = $('input[name=txt_building_address]').val();
		var user_name				 = $('input[name=txt_user_name]').val();
		var work_from_date			 = $('input[name=txt_work_from_date]').val();
		var work_end_date			 = $('input[name=txt_work_end_date]').val();
		var building_type			 = $('input[name=txt_building_type]').val();
		var building_from_height	 = $('input[name=txt_building_from_height]').val();
		var building_end_height		 = $('input[name=txt_building_end_height]').val();

		var param_data = {
				'_order_name_' : order_name,
				'_customer_name_' : customer_name,
				'_building_address_' : building_address,
				'_user_name_' : user_name,
				'_work_from_date_' : work_from_date,
				'_work_end_date_' : work_end_date,
				'_building_type_' : building_type,
				'_building_from_height_' : building_from_height,
				'_building_end_height_' : building_end_height,
			};

		jQuery.ajax({
			url: 'estimation_info_search_proc.jsp',
			type:'POST',
			dataType: 'json',
			data: param_data,
			error : function(request, status, error){
				console.log('error');
				console.log('code:' + request.status + '\n' + 'message:' + request.responseText + '\n' + 'error:' + error);
			},
			beforeSend : function(){
			},
			success: function(result){
				var report_item_info_data = result;
				var order_id = '';
				var tag = '';

				$('#main_list > tbody').children().remove();

				jQuery.each(report_item_info_data, function(key, value){
					if(key=='order_data') {
						for(var i=0; i<value.length; i++) {
							tag += '<tr id="tr_'+value[i].clm_order_id+'">';
							tag += '<td class="td_first_child" style="text-align:center;">';
							tag += '<input type="checkbox" class="dt_chk" id="chk_order_id" name="chk_order_id" value="'+value[i].clm_order_id+'">';
							tag += '</td>';
							tag += '<td data-title="Ticket No" style="font-size:14px; text-align:center;">';
							tag += '<a href="estimation_info_detail.jsp?_order_id_='+value[i].clm_order_id+'" style="font-weight:bold; color:#4285f4;">';
							tag += value[i].clm_order_id;
							tag += '</a>';
							tag += '</td>';
							tag += '<td data-title="Ticket No" style="font-size:14px; text-align:center;">';
							tag += value[i].clm_user_name;
							tag += '</td>';
							tag += '<td data-title="building_address" style="font-size:14px;">';
							tag += value[i].clm_order_name;
							tag += '</td>';
							tag += '<td data-title="order_estimation_price" style="font-size:14px; text-align:right;">\\'+value[i].clm_estimation_price+'</td>';
							tag += '<td data-title="building_type" style="font-size:14px; text-align:center;">';
							tag += '<span class="status-btn blue-bg">';
							tag += value[i].clm_order_state_type_name;
							tag += '</span>';
							tag += '</td>';
							tag += '<td data-title="reg_datetime" style="font-size:14px; text-align:center;">'+value[i].clm_reg_datetime+'</td>';
							tag += '<td data-title="Browser Name" style="font-size:14px; text-align:center;">'+value[i].clm_reg_user_name+'</td>';
							tag += '</tr>';
						}

						$('#main_list > tbody').append(tag);
					}
				});
			}
		});
	}

	$.check_all = function(){
		var box = $('input[name=\'chk_order_id\']');
		var flag = true;

		if(typeof box=='object'){
			if(box.length > 1) {
				for(var i=0; i < box.length; i++){
					if(box[i].checked == false){  //하나라도 체크안되어 있으면
					 flag = false;
					}
				}

				for(var i=0; i < box.length; i++){
					if(flag == true){
						box[i].checked = false;
						$('input[name=\'chk_all_order_id\']').checked = false;
					}
					else{
						box[i].checked = true;
						$('input[name=\'chk_all_order_id\']').checked = true;
					}
				}
			}
			else{
				box.checked = ((box.checked)? false : true);
			}
		}
		else {
			alert("항목이없습니다.");
		}
	}

	$.fnc_excel_download = function() {
		var arr_order_id = [];
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_order_id.push($(this).val());
		});

		if(arr_order_id==0) {
			$("#p_alert_msg").html("다운로드 할 견적을 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}
		
		var param_data = {
			'_chk_order_id_' : arr_order_id
		};
		
		jQuery.ajax({
			url: 'estimation_info_excel_download_proc.jsp',
			type:'POST',
			data: $('#frm_order_data').serialize(),
			error : function(request, status, error){
			},
			beforeSend : function(){
			},
			success: function(result){
				var report_item_info_data = result;
				var order_id = '';
				var tag = '';
				
				jQuery.each(report_item_info_data, function(key, value){
					if(key=='excel_files') {
						for(var i=0; i < value.length; i++) {
							location.href = '../excel/' + value[i].excel_file_name;
						}
					}
				});

				loader.off();
			}
		});
	}
		
	$.fnc_print = function() {
		var arr_order_id = [];
		var str_order_id = '';
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_order_id.push($(this).val());
			str_order_id += $(this).val() + ',';
		});

		if(arr_order_id==0) {
			$("#p_alert_msg").html("인쇄 할 견적을 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		str_order_id = str_order_id.substring(0, str_order_id.length-1);
		
		console.log(str_order_id);
		$('#ifrm_page').attr('src', 'estimation_info_print_proc.jsp?_str_order_id_=' + str_order_id);
	}

	$.fnc_pdf_download = function() {
		var arr_order_id = [];
		var str_order_id = '';
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_order_id.push($(this).val());
			str_order_id += $(this).val() + ',';
			// console.log($(this).val());
		});

		if(arr_order_id==0) {
			$("#p_alert_msg").html("다운로드 할 견적을 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		str_order_id = str_order_id.substring(0, str_order_id.length-1);
		
		console.log(str_order_id);
		$('#ifrm_page').attr('src', 'estimation_info_print_proc.jsp?_str_order_id_=' + str_order_id);
		
	}
	
	$.fnc_reg = function(){
		location.href = "./estimation_info_reg.jsp";
	}

	//콤마찍기
	$.fnc_comma = function(str) {
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}

	$.fnc_only_number_with_comma = function(obj) {
		if ($(obj).val() != null && $(obj).val() != '') {
			var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
			$(obj).val($.fnc_comma(tmps));
		}
	}

	/// Select value
	$('.custom-select-info').hide();

	// $(".data-table-responsive").html('<h2 class="pmd-card-title-text">Responsive Data table</h2>');
	$(".custom-select-action").html('<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">delete</i></button><button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">more_vert</i></button>');

});
</script>
<!-- Scripts Ends -->

<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/pmd-datetimepicker.css" />
<script type="text/javascript" src="components/select2/js/select2.full.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$('#txt_work_from_date').datetimepicker({
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

		$('.custom-select-info').hide();

		$(".custom-select-action").html('<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">delete</i></button><button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">more_vert</i></button>');

		$.fnc_modal_cost_code = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_cost_code_list.jsp?seq=' + param_01);
			$('#form-dialog_cost_code').modal('show');
		};

		$.fnc_select_to_parent = function(seq, code_id, code_sub_id, code_name, code_sub_name, code_unit, code_price, code_comment) {
			/*
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

			if(code_sub_id=='0000') {
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).val('');
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).attr('placeholder', '기타');
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).css('background-color', '#fff');
				$('input[name=txt_cost_code_sub_name]').eq(Number(seq)).attr('readOnly', false);
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).attr('placeholder', '0');
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).css('background-color', '#fff');
				$('input[name=txt_cost_cost_price]').eq(Number(seq)).attr('readOnly', false);
			}
			*/
		};
	} );
</script>

<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
<script type="text/javascript" src="resources/pdfmake/pdfmake.min.js"></script>
<script type="text/javascript" src="resources/pdfmake/vfs_fonts.js"></script>
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

<!-- Responsive Data table js-->
<script>
//Propeller  Customised Javascript code
$(document).ready(function() {
	// Korean
	var lang_kor = {
		"decimal" : "",
		"emptyTable" : "데이터가 없습니다.",
		"info" : "_START_ - _END_ (총 _TOTAL_ 건)",
		"infoEmpty" : "0건",
		"infoFiltered" : "(전체 _MAX_ 건 중 검색결과)",
		"infoPostFix" : "",
		"thousands" : ",",
		"lengthMenu" : "_MENU_ 개씩 보기",
		"loadingRecords" : "로딩중...",
		"processing" : "처리중...",
		"search" : "검색 : ",
		"zeroRecords" : "검색된 데이터가 없습니다.",
		"paginate" : {
			"first" : "첫 페이지",
			"last" : "마지막 페이지",
			"next" : "다음",
			"previous" : "이전"
		},
		"aria" : {
			"sortAscending" : " :  오름차순 정렬",
			"sortDescending" : " :  내림차순 정렬"
		}
	};

	$('#main_list').DataTable({
		dom : 'Blfrtip',
		language : lang_kor,
		buttons: [
			// 'copy', 'excel', 'pdf', 'print'
			// 'copy', 'print'
		],
		select: {
			style: 'multi',
			selector: 'td > .td_first_child'
		}
	});
	$('#main_list_info').attr('class', 'col-sm-6');
	$('#main_list_info').css('font-size', '14px');
	$('#main_list_info').css('margin-top', '18px');
	$('#main_list_length').attr('class', 'col-sm-6');
	$('#main_list_length').css('padding-left', '0px');
	$('#main_list_length label').css('font-size', '14px');
	$('#main_list_filter').css('text-align', 'right');
	$('#main_list_filter').css('margin-bottom', '5px');
	$('#main_list_filter').css('font-size', '14px');
	$('#main_list_paginate').attr('class', 'col-sm-6');
	$('#main_list_paginate').css('text-align', 'right');
	$('#main_list_paginate').css('margin-top', '-5px');
	$('#main_list_paginate ul ').css('font-size', '14px');
	$('.dt-buttons button').attr('class', 'btn btn-primary btn-sm');
	$('.dt-buttons').css('font-size', '14px');
	$('.dt-buttons').css('padding-bottom', '10px');
	// $('.dt-buttons').css('text-align', 'right');

	$.fn_file_download = function(file_download_path) {
		location.href=file_download_path;
	}
} );
</script>
<iframe id="ifrm_page" name="ifrm_page" width="0" height="0">
</iframe>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>