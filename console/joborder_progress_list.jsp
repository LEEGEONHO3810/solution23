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
<title></title>
<link rel="shortcut icon" type="image/x-icon" href="themes/images/favicon.ico" />
<!-- Google icon -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
<!-- Bootstrap css -->
<link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css" />
<!-- Propeller css -->
<link rel="stylesheet" type="text/css" href="assets/css/propeller.min.css" />
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
	String strCondition = "";
	String query  = "";
	int rowCnt = 0;
%>

<!--content area start-->
<div id="content" class="pmd-content inner-page">
<!--tab start-->
    <div class="container-fluid full-width-container value-added-detail-page" >
		<div>
			<div class="pull-right table-title-top-action">
				<!--
				<div class="pmd-textfield pull-left">
				  <input type="text" id="exampleInputAmount" class="form-control" placeholder="Search for...">
				</div>
				-->
				<button class="btn btn-primary btn-sm" id="completeYn" button type="button">작업 완료</button>
				<button class="btn btn-primary btn-sm" type="button" onClick="JavaScript:$.fnc_excel_download();">엑셀 다운로드</button>
			</div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>작업지시서 진행현황</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
			  <li><a href="index.html">Home</a></li>
			  <li class="active">생산 관리</li>
			  <li class="active">작업지시서 진행현황</li>
			</ol><!--breadcrum end-->
		</div>
		<!-- Table -->
		<div>
			<div id="allPage">
				<form id="frm_order_data">
				<table id="main_list" class="table table-striped table-bordered" style="width:100%">
					<thead>
						<tr>
							<th style="font-size:14px; border-top:5px solid #666; text-align:center; font-weight:bold; width:5%;"><input type="checkbox" class="dt_all_chk" id="chk_all_order_id" name="chk_all_order_id" onClick="JavaScript:$.check_all();"></th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:80px;">작업지시서 번호</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;">제품명</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:120px;">작업예정 일자</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:120px;">작업 시작시간</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:120px;">작업 마감시간</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:100px;">제작 개수</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:120px;">제작 된 개수</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:180px;">특이사항</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:120px;">작업 상태</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width:80px;">작업 진행</th>
						</tr>
					</thead>
					<tbody>
<%

		try {
			stmt = conn.createStatement();
			strCondition = "";
			//if(!_material_id_.equals("")) {
			//	strCondition += "and x.clm_material_id = '" + _material_id_ + "' ";
			//}
			
			query = "";
			query += " select x.clm_joborder_id, x.clm_company_key, x.clm_product_id, x.clm_planned_datetime, x.clm_complete_yn ";
			query += "  ,x.clm_start_datetime,x.clm_end_datetime,x.clm_product_count,x.clm_comment, y.clm_product_name, coalesce (sum(cast(z.clm_product_count  as numeric)),0) as allSum ";
			query += "  , y.clm_product_name, coalesce (sum(cast(z.clm_product_count  as numeric)),0) as allSum, case x.clm_complete_yn when 'Y' then '작업완료' else '작업중' end clm_status  ";
			query += " from tbl_joborder_info x  ";
			query += " left outer join tbl_product_info y on x.clm_product_id = y.clm_product_id and x.clm_company_key = y.clm_company_key ";
			query += " left outer join tbl_product_produce_info z on y.clm_product_id  = x.clm_product_id and y.clm_company_key  = z.clm_company_key and x.clm_joborder_id = z.clm_joborder_id  ";
			query += " where x.clm_company_key = '"+ SessionCompanyKey +"'   ";
			query += " group by x.clm_joborder_id, x.clm_company_key, x.clm_product_id, x.clm_planned_datetime  ,x.clm_start_datetime ,x.clm_complete_yn ";
			query += " ,x.clm_end_datetime,x.clm_product_count,x.clm_comment, y.clm_product_name ";
			query += " order by x.clm_joborder_id; ";
			System.out.println("> productInfoRegPop.q.0 " + query);
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
				String clm_joborder_id						 = rs.getString("clm_joborder_id");
				String clm_product_id						 = rs.getString("clm_product_id");
				String clm_company_key						 = rs.getString("clm_company_key");
				String clm_planned_datetime					 = rs.getString("clm_planned_datetime");
				String clm_start_datetime					 = rs.getString("clm_start_datetime");
				String clm_end_datetime						 = rs.getString("clm_end_datetime");
				String clm_product_count					 = rs.getString("clm_product_count");
				String clm_product_name						 = rs.getString("clm_product_name");
				String clm_comment							 = rs.getString("clm_comment");
				String allSum							 	 = rs.getString("allSum");
				String clm_complete_yn						 = rs.getString("clm_complete_yn");
				String clm_status						 	 = rs.getString("clm_status");
				
				
%>



				<tr id="tr_<%=clm_joborder_id %>">
					<td class="td_first_child" style="text-align:center;">
						<input type="checkbox" class="dt_chk" id="chk_order_id_<%=clm_joborder_id %>" name="chk_order_id" value="<%=clm_joborder_id %>">
						<input type="hidden" id="all_complete_yn_<%=clm_joborder_id %>" value="<%=clm_complete_yn %>"  />
					</td>
					<td style="text-align: center;"><%=clm_joborder_id %></td>
					<td style="text-align: left;"><%=clm_product_name %></td>
					<td style="text-align: center;"><%=clm_planned_datetime %></td>
					<td style="text-align: center;"><%=clm_start_datetime %></td>
					<td style="text-align: center;"><%=clm_end_datetime %></td>
					<td style="text-align: right;"><%=clm_product_count %></td>
					<td style="text-align: right;"><%=allSum %></td>
					<td style="text-align: center;"> <%=clm_comment %></td>
					<td style="text-align: center;"> <%=clm_status %></td>
					<td  style="text-align: center;">
						<button type="button" class="btn btn-primary btn-sm" onClick="fnc_joborder_complete('<%=clm_joborder_id %>','<%=clm_product_name%>','<%=clm_planned_datetime%>','<%=clm_product_count%>','<%=clm_product_id%>','<%=allSum%>');"> 작업 완료 </button >
					</td>
						
				</tr>
<%
				iRowCnt++;
			}

			int iRowCntTmp = 15;
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
<!-- 작업 완료 모달창  -->
<!--content area end-->
<div tabindex="-1" class="modal fade" id="form-dialog_joborder_confirm" style="display: none;" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header bordered">
				<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
				<h2 class="pmd-card-title-text" id="modal_title">작업완료</h2>
			</div>
			<div class="modal-body">
				<div class="group-fields clearfix row">
					<input type="hidden" id="txt_modal_product_id" class="mat-input form-control" value="">
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="first-name">
								작업지시서 번호
							</label>
							<input type="text" id="txt_modal_jodOrder_id" class="mat-input form-control" value="" readonly>
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="regular1" class="control-label">
								제품명
							</label>
							<input type="text" id="txt_modal_product_name" value="" class="form-control" />
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="regular1" class="control-label">
								작업 예정일자
							</label>
							<input type="text" id="txt_modal_jodOrder_planned_datetime" value="" class="form-control" />
						</div>
					</div>
				</div>
				<div class="group-fields clearfix row">
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="first-name">
								작업 시작 시간
							</label>
							<input type="time" id="txt_modal_start_time" class="mat-input form-control" value="">
						</div>
					</div>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="regular1" class="control-label">
								작업 종료 시간
							</label>
							<input type="time" id="txt_modal_end_time" value="" class="form-control" />
						</div>
					</div>
					<div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="regular1" class="control-label">
								목표 개수
							</label>
							<input  type="text" id="txt_modal_order_count"  class="form-control" readonly style="background-color: #ccc; text-align: left; font-weight: bold" />
						</div>
					</div>
					<div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="regular1" class="control-label">
								작업 현황
							</label>
							<input  type="number" id="txt_modal_allSum_count" class="form-control" readonly />
						</div>
					</div>
					<div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
						<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
							<label for="regular1" class="control-label">
								작업 개수<font style="color:red">*</font>
							</label>
							<input  type="number" id="txt_modal_plus_count" class="form-control" />
						</div>
					</div>
				</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" id="modal_comment" name="modal_comment"></textarea>
							</div>
						</div>
					</div>
			
			<div class="pmd-modal-action">
				<button id="btn_joborder_complete" name="btn_joborder_complete" class="btn pmd-ripple-effect btn-default" >저장</button>
				<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-default" type="button">취소</button>
			</div>
		</div>
	</div>
</div>

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
		"infoEmpty" : "0명",
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

		 ],
		 select: {
			style: 'multi',
			selector: 'td > .td_first_child'
		},
		"drawCallback": function( settings ) {
			console.log(settings._iDisplayLength);
			console.log(settings.aiDisplay.length);
			if(Number(settings._iDisplayLength) >  Number(settings.aiDisplay.length)){
				var diff = Number(settings._iDisplayLength) - Number(settings.aiDisplay.length);

				for(x=0; x<diff; x++){
					var appendTr = '';
					appendTr += '<tr>';
					appendTr += '	<td data-title="TicketNo"></td>';
					appendTr += '	<td data-title="building_address"style="padding:0px;"></td>';
					appendTr += '	<td data-title="order_estimation_price">&nbsp;</td>';
					appendTr += '	<td data-title="building_height"></td>';
					appendTr += '	<td data-title="building_type"></td>';
					appendTr += '	<td data-title="reg_datetime"></td>';
					appendTr += '	<td data-title="reg_type"></td>';
					appendTr += '	<td data-title="button"></td>';
					appendTr += '	<td data-title="detail"></td>';
					appendTr += '	<td data-title="order"></td>';
					appendTr += '	<td data-title="ord1er"></td>';
					appendTr += '</tr>';
					$("#main_list > tbody").append(appendTr);
				}
			}
		}
	});
	$('#main_list_info').attr('class', 'col-sm-6');
	$('#main_list_info').css('font-size', '14px');
	$('#main_list_length').attr('class', 'col-sm-6');
	$('#main_list_length').css('padding-left', '0px');
	$('#main_list_length label').css('font-size', '14px');
	$('#main_list_filter').css('text-align', 'right');
	$('#main_list_filter').css('margin-bottom', '5px');
	$('#main_list_filter').css('font-size', '14px');
	$('#main_list_paginate').attr('class', 'col-sm-6');
	$('#main_list_paginate').css('text-align', 'right');
	$('#main_list_paginate').css('margin-top', '-25px');
	$('#main_list_paginate ul ').css('font-size', '14px');
	$('.dt-buttons button').attr('class', 'btn btn-primary btn-sm');
	//$('.dt-buttons').css('font-size', '14px');
	//$('.dt-buttons').css('padding-bottom', '10px');
	//$('.dt-buttons').css('text-align', 'right');

	$.fnc_material_detail = function(material_id) {
		location.href='material_info_detail.jsp?_material_id_=' + material_id;
	}
	$.fn_file_download = function(file_download_path) {
		location.href=file_download_path;
	}
} );


</script>

<script>
	//Propeller  Customised Javascript code
	$(document).ready(function() {
		

			// input자동완성 막기
		const inputs = document.querySelectorAll('input');
			for (let i = 0; i < inputs.length; i++) {
			inputs[i].setAttribute('autocomplete', 'off');
		}

		$.order_modify_select = function(order_id, order_state) {
		
			$(location).attr("href", 'estimation_info_modify.jsp?_order_id_=' + order_id);
		}
	
		var exampleDatatable = $('#example').DataTable({
			responsive: {
				details: {
					type: 'column',
					target: 'tr'
				}
			},
			
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
					
				},
				beforeSend : function(){
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
		var data_array = [];


	$.fnc_print = function() {
		var arr_user_id = [];
		var str_user_id = '';
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_user_id.push($(this).val());
			str_user_id += $(this).val() + ',';
		});

		if(arr_user_id==0) {
			$("#p_alert_msg").html("인쇄 할 직원 정보를 선택해 주십시오.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		str_user_id = str_user_id.substring(0, str_user_id.length-1);
		
		console.log(str_user_id);
		$('#ifrm_page').attr('src', 'user_info_print_proc.jsp?_str_order_id_=' + str_user_id);
	}

	$.fnc_pdf_download = function() {
		var arr_user_id = [];
		var str_user_id = '';
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_user_id.push($(this).val());
			str_user_id += $(this).val() + ',';
			// console.log($(this).val());
		});

		if(arr_user_id==0) {
			$("#p_alert_msg").html("다운로드 할 직원 정보를 선택해 주십시오.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		str_user_id = str_user_id.substring(0, str_user_id.length-1);
		
		console.log(arr_user_id);
		$('#ifrm_page').attr('src', 'user_info_print_proc.jsp?_str_order_id_=' + str_user_id);
	
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
	

		jQuery('#btn_joborder_complete').click(function(e){
			fnc_joborder_complete_save();
		});



		$.check_all = function(){
			var box = $('input[name=\'chk_order_id\']');
			var flag = true;


			if(typeof box=='object'){
				if(box.length > 0) {
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
				}else{
					box.checked = ((box.checked)? false : true);
				}
			}
			else {
				alert("항목이없습니다.");
			}
		}
	 
		
		jQuery('#completeYn').click(function(e){
			var arr_order_id = [];
			var str_order_id = '';
			var chk_count = 0;
			var Error_MSG = '';

			$("input[name='chk_order_id']:checked").each(function(i) {
					arr_order_id.push($(this).val());
					str_order_id += $(this).val() + ',';
			});

			console.log(arr_order_id.length);

			var data = new Array();


			for(var i = 0; i <arr_order_id.length; i++ ){
				var tmpData = new Object();
				tmpData.job_order_id = $('#chk_order_id_'+arr_order_id[i]).val();
				tmpData.complete_yn = $('#all_complete_yn_'+arr_order_id[i]).val();
				if($('#all_complete_yn_'+arr_order_id[i]).val() == 'Y'){
					Error_MSG = '이미 작업 완료 된 작업지시서가 포함되어 있습니다.';
				}
				data.push(tmpData);
			}

			if(arr_order_id.length == 0) {
				$("#p_alert_msg").html("작업 완료 할 작업지시서를 선택해주세요");
				$('#div_alert_modal').modal("show");
				return 0;
			}else if(Error_MSG != ''){
				alert(Error_MSG);
				return;
			}

			$.ajax({
				type : "POST",
				url : 'joborder_complete_stock_proc.jsp',
				data : {
					'dataArr' : JSON.stringify(data)
				},
				dataType : "text",
				error : function() {
					console.log('작업지시서 등록 실패');
					location.reload();
				},
				success: function(data){
					alert("작업지시서 등록완료");
					location.reload();
				}
			});
		});


		$.fnc_excel_download = function() {
		var arr_order_id = [];
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_order_id.push($(this).val());
		});

		if(arr_order_id==0) {
			$("#p_alert_msg").html("다운로드 할 자재 정보를 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}
		
		var param_data = {
			'_chk_order_id_' : arr_order_id
		};
		
		jQuery.ajax({
			url: 'joborder_progress_excel_download_proc.jsp',
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
			}
		});
	}



	
	} );




	function fnc_joborder_complete(job_order_id,clm_product_name,planned_datetime,clm_product_count,clm_product_id,allSum){
		// 모달 초기화
		$('#txt_modal_jodOrder_id').val("");
		$('#txt_modal_product_name').val("");
		$('#txt_modal_product_id').val("");
		$('#txt_modal_order_count').val(""); //  작업 지시서 오더 개수
		$('#txt_modal_allSum_count').val(""); // 현재까지 만든 작업 개수 현황
		$('#txt_modal_jodOrder_planned_datetime').val("");
		$('#txt_modal_start_time').val("");
		$('#txt_modal_end_time').val("");
		$('#modal_comment').val("");
		$('#txt_modal_plus_count').val("");
		

		console.log(job_order_id);
		console.log(clm_product_name);
		console.log(clm_product_id);
		console.log(clm_product_count);
		console.log(allSum);
		console.log(planned_datetime);


		$('#txt_modal_jodOrder_id').val(job_order_id);
		$('#txt_modal_product_name').val(clm_product_name);
		$('#txt_modal_product_id').val(clm_product_id);
		$('#txt_modal_order_count').val(clm_product_count); //  작업 지시서 오더 개수
		$('#txt_modal_allSum_count').val(allSum); // 현재까지 만든 작업 개수 현황
		$('#txt_modal_jodOrder_planned_datetime').val(planned_datetime);
		$('#modal_comment').val();

		
		$('#form-dialog_joborder_confirm').modal('show');
		
	}

	function fnc_joborder_complete_save(){
		
		if(Number($('#txt_modal_order_count').val()) < Number($('#txt_modal_allSum_count').val())+Number($('#txt_modal_plus_count').val())){
			alert("생산 목표를 넘어 생산 할 수 없습니다.");
			return;
		}

		console.log($('#txt_modal_plus_count').val());
		$.ajax({
			type : "POST",
			url : 'joboder_modal_proc.jsp',
			data : {
				
				'txt_modal_jodOrder_id' : $('#txt_modal_jodOrder_id').val(),
				'txt_modal_product_id' :  $('#txt_modal_product_id').val(),
				'txt_modal_start_time' : $('#txt_modal_start_time').val(),
				'txt_modal_end_time' : $('#txt_modal_end_time').val(),
				'txt_modal_plus_count' : $('#txt_modal_plus_count').val(),
				'txt_modal_comment' : $('#modal_comment').val()
			},
			dataType : "text",
			error : function() {
				console.log('작업지시서 현황 등록 실패');
				location.reload();
			},
			success: function(data){
				alert("작업지시서 현황 등록 완료");
				location.reload();
			}
		});
	}
	
	</script>
	
<iframe id="ifrm_page" name="ifrm_page" width="0" height="0">
</iframe>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>