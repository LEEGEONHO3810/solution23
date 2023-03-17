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

<%
	String materialId = (request.getParameter("material_id")==null)?"":request.getParameter("material_id");
	String materialType = (request.getParameter("material_type")==null)?"":request.getParameter("material_type");


	System.out.println("+ ");
	System.out.println("+ materialId : " + materialId);
	System.out.println("+ materialType : " + materialType);
	System.out.println("+ ");
%>
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
				<button class="btn btn-primary btn-sm" button type="button" onclick="location.href='material_info_reg.jsp'">등록</button>
				<button class="btn btn-primary btn-sm" type="button" onClick="JavaScript:$.fnc_excel_download();">엑셀 다운로드</button>
			</div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>자재 정보</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
			  <li><a href="index.html">Home</a></li>
			  <li class="active">자재관리</li>
			  <li class="active">자재 정보</li>
			</ol><!--breadcrum end-->
		</div>
		<!-- Table -->
		<div>
			<div id="allPage">
				<form id="frm_order_data">
				<table id="main_list" class="table table-striped table-bordered" style="width:100%">
					<thead>
						<tr>
							<th style="font-size:14px; border-top:5px solid #666; text-align:center; font-weight:bold; width:5%;"><input type="checkbox" class="dt_all_chk" id="chk_all_user_id" name="chk_all_user_id" onClick="JavaScript:$.check_all();"></th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width: 320px;">자재명</th>
								<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width: 160px; ">자재 대분류</th>
								<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width: 160px; ">자재 소분류</th>
								<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width: 120px; ">자재 단위</th>
								<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; width: 120px; ">자재 안전재고</th>
								<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center; ">특이사항</th>
							<th style="border-top:5px solid #666; font-size:14px; font-weight:bold; text-align:center;width: 100px;" >상세</th>
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
		String saveFolderRootLogical = "/SOLUTION/files";
		try {
			stmt = conn.createStatement();
			strCondition = "";
			//if(!_material_id_.equals("")) {
			//	strCondition += "and x.clm_material_id = '" + _material_id_ + "' ";
			//}
			query = "";	
			query += " select x.clm_material_id,z2.clm_code_sub_id,z1.clm_code_sub_name, x.clm_company_key, x.clm_material_code, x.clm_material_name ";
			query += " ,x.clm_material_main_type ,coalesce(z1.clm_code_sub_name,'') as clm_material_main_type_name, x.clm_comment ";
			query += " , x.clm_material_safety_stock,x.clm_delete_yn,x.clm_reg_user,x.clm_reg_datetime,x.clm_update_user,x.clm_update_datetime ";
			query += " , coalesce(x.clm_material_sub_type, '') clm_material_sub_type, coalesce(z2.clm_code_sub_name,'') as clm_material_sub_type_name , coalesce(x.clm_material_unit, '') clm_material_unit ";
			query += " , coalesce(z3.clm_code_sub_name,'') as clm_material_unit_name ";
			query += " from tbl_material_info x ";
			query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_material_main_type = z1.clm_code_sub_id and z1.clm_code_id = '0001' ";
			query += " left outer join tbl_code_sub_info z2 on x.clm_company_key = z2.clm_company_key and x.clm_material_sub_type = z2.clm_code_sub_id and z2.clm_code_id = '0002' ";
			query += " left outer join tbl_code_sub_info z3 on x.clm_company_key = z3.clm_company_key and x.clm_material_unit = z3.clm_code_sub_id and z3.clm_code_id = '0003' ";
			query += " where x.clm_company_key = '" + SessionCompanyKey + "'";
			query += " order by x.clm_material_id ";
			System.out.println("> MaterialInfoRegPop.q.0 " + query);
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
				String clm_material_id					 = rs.getString("clm_material_id");
				String clm_company_key					 = rs.getString("clm_company_key");
				String clm_material_code				 = rs.getString("clm_material_code");
				String clm_material_name				 = rs.getString("clm_material_name");
				String clm_material_main_type			 = rs.getString("clm_material_main_type");
				String clm_material_main_type_name		 = rs.getString("clm_material_main_type_name");
				String clm_material_sub_type			 = rs.getString("clm_material_sub_type");
				String clm_material_sub_type_name		 = rs.getString("clm_material_sub_type_name");
				String clm_material_unit				 = rs.getString("clm_material_unit");
				String clm_material_unit_name			 = rs.getString("clm_material_unit_name");
				String clm_material_safety_stock		 = rs.getString("clm_material_safety_stock");
				String clm_delete_yn					 = rs.getString("clm_delete_yn");
				String clm_comment			 			 = rs.getString("clm_comment");
				String clm_reg_user					  	 = rs.getString("clm_reg_user");
				String clm_reg_datetime					 = rs.getString("clm_reg_datetime");
				String clm_update_user 					 = rs.getString("clm_update_user");
				String clm_update_datetime				 = rs.getString("clm_update_datetime");
				
%>
							<tr id="tr_<%=clm_material_id %>">
								<td class="td_first_child" style="text-align:center;">
									<input type="checkbox" class="dt_chk" id="chk_order_id" name="chk_order_id" value="<%=clm_material_id %>">
								</td>
								<td style="text-align: left;"><%=clm_material_name %></td>
								<td style="text-align: center;"><%=clm_material_main_type_name %></td>
								<td style="text-align: center;"><%=clm_material_sub_type_name %></td>
								<td style="text-align: center;"><%=clm_material_unit_name %></td>
								<td style="text-align: right;"><%=clm_material_safety_stock %></td>
								<td style="text-align: left;"><%=clm_comment %></td>
								<td style="font-size:14px; text-align:center;">
									<button type="button" class="btn btn-primary btn-sm" onClick="JavaScript:$.fnc_material_detail('<%=clm_material_id %>');"> 상세 </button ></td>
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
						$('input[name=\'chk_all_user_id\']').checked = false;
					}
					else{
						box[i].checked = true;
						$('input[name=\'chk_all_user_id\']').checked = true;
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
			$("#p_alert_msg").html("다운로드 할 자재 정보를 선택해 주십시요.");
			$('#div_alert_modal').modal("show");
			return 0;
		}
		
		var param_data = {
			'_chk_order_id_' : arr_order_id
		};
		
		jQuery.ajax({
			url: 'material_info_excel_download_proc.jsp',
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
	
	} );

	</script>
	
<iframe id="ifrm_page" name="ifrm_page" width="0" height="0">
</iframe>
</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>