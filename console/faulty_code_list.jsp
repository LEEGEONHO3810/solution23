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
    <div class="container-fluid full-width-container value-added-detail-page">
		<div>
			<div class="pull-right table-title-top-action">
				<button class="btn pmd-ripple-effect btn-primary pmd-z-depth" type="button" onClick="JavaScript:$.fnc_excel_download();">엑셀 다운로드</button>
			
			</div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>불량 유형 정보</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
			  <li><a href="index.html">Home</a></li>
			  <li class="active">기초정보 관리</li>
			  <li class="active">불량 유형 정보</li>
			</ol><!--breadcrum end-->
		</div>
		<!-- Table -->
		<div>
			<form id="frm_order_data" name="frm_order_data">
				<table id="main_list" class="table table-striped table-bordered" style="width:100%">
					<thead>
						<tr>
							<th style="font-size:14px; border-top:5px solid #666; text-align:center; font-weight:bold; width:5%;"><input type="checkbox" class="dt_all_chk" id="chk_all_code_id" name="chk_all_code_id" onClick="JavaScript:$.check_all();"></th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;" width="100px">상위코드</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;" width="100px">하위코드</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;">상위코드명</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;">하위코드명</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;">코드값</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;">특이사항</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;" width="60px">상세</th>
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
			strCondition = "";
			String name = "불량";

			if(!_code_id_.equals("")) {
				strCondition += "and y.clm_code_id='" + _code_id_ + "' ";
			}
			if(!_code_sub_id_.equals("")) {
				strCondition += "and y.clm_code_sub_id='" + _code_sub_id_ + "' ";
			}
			query  = "";
			query += "select y.*";
			query += "  from tbl_code_sub_info y  ";
			query += " where 1=1 and y.clm_delete_yn='N' and y.clm_company_key = '" + SessionCompanyKey + "' and y.clm_code_name = '" + name + "' ";
			query += " order by cast(y.clm_code_sub_id as numeric) desc ;";
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
				String clm_code_id			 = rs.getString("clm_code_id");
				String clm_code_sub_id		 = rs.getString("clm_code_sub_id");
				String clm_company_key		 = rs.getString("clm_company_key");
				String clm_code_sub_value	 = rs.getString("clm_code_sub_value");
				String clm_code_name		 = rs.getString("clm_code_name");
				String clm_code_sub_name	 = rs.getString("clm_code_sub_name");
				String clm_comment			 = rs.getString("clm_comment");
				String clm_reg_datetime		 = rs.getString("clm_reg_datetime");
				String clm_reg_user			 = rs.getString("clm_reg_user");
				String clm_update_datetime	 = rs.getString("clm_update_datetime");
				String clm_update_user		 = rs.getString("clm_update_user");
				String clm_delete_yn			 = rs.getString("clm_delete_yn");

%>
							<tr id="tr_<%=clm_code_id %>">
								<td class="td_first_child" style="text-align:center;">
									<input type="checkbox" class="dt_chk" id="chk_order_id" name="chk_order_id" value="<%=clm_code_id %>-<%=clm_code_sub_id %>">
								</td>
								<td style="font-size:14px; text-align:center;"><%=clm_code_id %></td>
								<td style="font-size:14px; text-align:center;"><%=clm_code_sub_id %></td>
								<td style="font-size:14px; text-align:center;"><%=clm_code_name %></td>
								<td style="font-size:14px; text-align:center;"><%=clm_code_sub_name %></td>
								<td style="font-size:14px; text-align:center;"><%=clm_code_sub_value %></td>
								<td style="font-size:14px; text-align:center;"><%=clm_comment %></td>
								<td style="font-size:14px; text-align:center;"><button type="button" class="btn btn-primary btn-sm" onClick="JavaScript:$.fnc_code_detail('<%=clm_code_id %>', '<%=clm_code_sub_id %>');" style="padding:2px;"> 상세 </button ></td>
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
		<!-- Card Footer -->
		<!--
		<div class="pmd-card-footer">
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
		</div>
		-->
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

<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
<script type="text/javascript" src="resources/pdfmake/pdfmake.min.js"></script>
<script type="text/javascript" src="resources/pdfmake/vfs_fonts.js"></script>
<!-- Scripts Ends -->

<!--
<link rel="stylesheet" href="https://cdn.datatables.net/1.11.3/css/dataTables.bootstrap.min.css"/>
-->

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
					appendTr += '	<td data-title="bigo"></td>';
					appendTr += '	<td data-title="detail"></td>';
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
	$('.dt-buttons').css('font-size', '14px');
	$('.dt-buttons').css('padding-bottom', '10px');
	// $('.dt-buttons').css('text-align', 'right');

	$.fnc_code_detail = function(code_id, code_sub_id) {
		location.href='code_info_detail.jsp?_code_id_=' + code_id + '&_code_sub_id_=' + code_sub_id + '&_code_type_=L';
	}
} );
</script>

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
						$('input[name=\'chk_all_code_id\']').checked = false;
					}
					else{
						box[i].checked = true;
						$('input[name=\'chk_all_code_id\']').checked = true;
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
			$("#p_alert_msg").html("다운로드 할 공지사항 목록을 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}
		
		var param_data = {
			'_chk_order_id_' : arr_order_id
		};
		
		jQuery.ajax({
			url: 'code_info_excel_download_proc.jsp',
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
		var arr_code_id = [];
		var str_code_id = '';
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_code_id.push($(this).val());
			str_code_id += $(this).val() + ',';
			// console.log($(this).val());
		});

		if(arr_code_id==0) {
			$("#p_alert_msg").html("인쇄 할 코드 정보를 선택해 주십시오.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		str_code_id = str_code_id.substring(0, str_code_id.length-1);
		
		console.log(str_code_id);
		$('#ifrm_page').attr('src', 'code_list_info_print_proc.jsp?_str_order_id_=' + str_code_id);
	}

	$.fnc_pdf_download = function() {
		var arr_code_id = [];
		var str_code_id = '';
		var chk_count = 0;
		$("input[name='chk_order_id']:checked").each(function(i) {
			arr_code_id.push($(this).val());
			str_code_id += $(this).val() + ',';
			// console.log($(this).val());
		});

		if(arr_code_id==0) {
			$("#p_alert_msg").html("다운로드 할 코드 정보를 선택해 주십시오.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		str_code_id = str_code_id.substring(0, str_code_id.length-1);
		
		console.log(arr_code_id);
		$('#ifrm_page').attr('src', 'code_list_info_print_proc.jsp?_str_order_id_=' + str_code_id);
		/*
		var arr_order_id = [];
		var chk_count = 0;
		$("input[name='clm_user_id']:checked").each(function(i) {
			arr_order_id.push($(this).val());
			// console.log($(this).val());
		});

		if(arr_order_id==0) {
			$("#p_alert_msg").html("다운로드 할 견적을 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}

		// var order_id				 = $('input[name=clm_user_id]').val();
		// var customer_name			 = $('input[name=txt_customer_name]').val();
		// var building_address		 = $('input[name=txt_building_address]').val();
		// var user_name				 = $('input[name=txt_user_name]').val();
		// var work_from_date			 = $('input[name=txt_work_from_date]').val();
		// var work_end_date			 = $('input[name=txt_work_end_date]').val();
		// var building_type			 = $('input[name=txt_building_type]').val();
		// var building_from_height	 = $('input[name=txt_building_from_height]').val();
		// var building_end_height		 = $('input[name=txt_building_end_height]').val();

		var param_data = {
				'_clm_user_id_' : arr_order_id,
				// '_customer_name_' : customer_name,
				// '_building_address_' : building_address,
				// '_user_name_' : user_name,
				// '_work_from_date_' : work_from_date,
				// '_work_end_date_' : work_end_date,
				// '_building_type_' : building_type,
				// '_building_from_height_' : building_from_height,
				// '_building_end_height_' : building_end_height,
			};

		for(var i=0; i<arr_order_id.length; i++) {
			console.log('> ' + i + ' ' + arr_order_id[i]);
		}

		var pop = window.open("about:blank","content","width=1600,height=800");

		jQuery.ajax({
			url: 'estimation_info_pdf_download_proc.jsp',
			type:'POST',
			// dataType: 'json',
			// data: $('#frm_order_data').serialize(),
			data: $('#frm_order_data').serialize(),
			error : function(request, status, error){
				console.log('error');
				console.log('code:' + request.status + '\n' + 'message:' + request.responseText + '\n' + 'error:' + error);
				// $("#p_alert_msg").html("변경사항에 실패하였습니다.");
				// $('#div_alert_modal').modal("show");
				// loader.off();
			},
			beforeSend : function(){
				// loader.on(function(){
				// });
			},
			success: function(result){
				var report_item_info_data = result;
				var order_id = '';
				var tag = '';

				jQuery.each(report_item_info_data, function(key, value){
					if(key=='pdf_files') {
						for(var i=0; i<value.length; i++) {
							console.log('> ' + i + ' : ' + 'excel/' + value[i].pdf_file_name);
							pop.location.href = 'excel/' + value[i].pdf_file_name;
						}
					}
				});

				$("#p_alert_msg").html("PDF 다운로드 성공.");
				$('#div_alert_modal').modal("show");
				loader.off();
			}
		});
		*/
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
	
	} );
	</script>
<iframe id="ifrm_page" name="ifrm_page" width="0" height="0">
</iframe>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>