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
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<a href="javascript:void(0);" data-target="basicSidebar" data-placement="left" data-position="slidepush" is-open="true" is-open-width="1200" class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect pull-left margin-r8 pmd-sidebar-toggle"><i class="material-icons md-light">menu</i></a>
		  <a href="index.jsp" class="navbar-brand">
		  	청주솔루션 견적 관리 시스템
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
			if(!_user_id_.equals("")) {
				strCondition += "and x.clm_user_id='" + _user_id_ + "' ";
			}
			String query  = "";
			query  = "";
			query += " select x.clm_user_id, x.clm_user_pw, x.clm_user_name,x.clm_company_key,x.clm_user_authority,y.clm_department_id,x.clm_comment,x.clm_reg_user,y.clm_department_name,x.clm_producer_yn, ";
			query += " x.clm_reg_datetime, x.clm_update_user, x.clm_update_datetime, x.clm_user_seq, x.clm_del_yn, z.clm_authority_id, z.clm_authority_name,x.clm_producer_yn ";
			query += " from tbl_user_info x ";
			query += " left outer join tbl_department_info y on x.clm_company_key = y.clm_company_key ";
			query += " left outer join tbl_authority_info z on x.clm_user_authority = z.clm_authority_id  ";
			query += " where 1=1 and x.clm_del_yn='N' " + strCondition + " and x.clm_company_key = y.clm_company_key ";
			query += " order by x.clm_user_id desc;";
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
				String clm_user_id					 = (rs.getString("clm_user_id")==null)?"":rs.getString("clm_user_id");
				String clm_user_pw					 = (rs.getString("clm_user_pw")==null)?"":rs.getString("clm_user_pw");
				String clm_user_name				 = (rs.getString("clm_user_name")==null)?"":rs.getString("clm_user_name");
				String clm_department_id			 = (rs.getString("clm_department_id")==null)?"":rs.getString("clm_department_id");
				String clm_comment					 = (rs.getString("clm_comment")==null)?"":rs.getString("clm_comment");
				String clm_reg_user					 = (rs.getString("clm_reg_user")==null)?"":rs.getString("clm_reg_user");
				String clm_reg_datetime				 = (rs.getString("clm_reg_datetime")==null)?"":rs.getString("clm_reg_datetime");
				String clm_update_user				 = (rs.getString("clm_update_user")==null)?"":rs.getString("clm_update_user");
				String clm_update_datetime			 = (rs.getString("clm_update_datetime")==null)?"":rs.getString("clm_update_datetime");
				String clm_del_yn					 = (rs.getString("clm_del_yn")==null)?"":rs.getString("clm_del_yn");
				String clm_user_seq					 = rs.getString("clm_user_seq");
				String clm_producer_yn 					 = rs.getString("clm_producer_yn");
				String clm_user_authority			 = (rs.getString("clm_user_authority")==null)?"":rs.getString("clm_user_authority");
				String clm_department_name			 = (rs.getString("clm_department_name")==null)?"":rs.getString("clm_department_name");
				String clm_authority_id		 = (rs.getString("clm_authority_id")==null)?"":rs.getString("clm_authority_id");
				String clm_authority_name		 = (rs.getString("clm_authority_name")==null)?"":rs.getString("clm_authority_name");
				System.out.println(clm_producer_yn);
%>
<!--content area start-->
<div id="content" class="pmd-content inner-page">
<!--tab start-->
    <div class="container-fluid full-width-container value-added-detail-page">
		<div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>직원 정보 수정</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.jsp">Home</a></li>
				<li class="active">기초 정보 관리</li>
				<li class="active">직원 정보 수정</li>
			</ol><!--breadcrum end-->
		</div>

		<div class="table-responsive pmd-card pmd-z-depth">
			<!--section-title -- >
			<h2>Basic Form</h2>< !--section-title end -->
			<!-- section content start-->
			<form name="frm_order_data" id="frm_order_data">
			<input type="hidden" id="txt_user_seq" name="txt_user_seq" class="form-control" value="<%=clm_user_seq %>" readOnly>
			<div class="pmd-card pmd-z-depth">
				<input type="hidden" id="txt_process_type" name="txt_process_type" class="form-control" value="S">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									성명<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_user_name" name="txt_user_name" class="form-control" value="<%=clm_user_name %>">
								<!--
								<input type="hidden" id="txt_process_type" name="txt_process_type" class="form-control" value="S">
								-->
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									직원ID<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_user_id" name="txt_user_id" class="form-control" value="<%=clm_user_id %>" readOnly>
							</div>
						</div>
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									직원PW<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_user_pw" name="txt_user_pw" class="form-control" value="<%=clm_user_pw %>" readOnly>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								권한<span style="font-weight:bold; color:red;">*</span>
								<input type="text" class="mat-input form-control" id="txt_authority_name" name="txt_authority_name" value="<%=clm_authority_name %>" data-param_01="0" data-param_02="0003" data-toggle="modal" onClick="JavaScript:$.fnc_modal_authority_code(this);" readOnly>
								<input type="hidden" id="txt_authority_id" name="txt_authority_id" value="<%=clm_authority_id %>" readOnly>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">
									<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
									소속부서<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" class="mat-input form-control" id="txt_department_name" name="txt_department_name" value="<%=clm_department_name %>" data-param_01="0" data-param_02="0003" data-toggle="modal" onClick="JavaScript:$.fnc_modal_department_code(this);" readOnly>
								<input type="hidden" id="txt_department_id" name="txt_department_id" value="<%=clm_department_id %>" readOnly>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12" style="margin-top:25px;">
							<label class="pmd-checkbox checkbox-pmd-ripple-effect">
								<input type="checkbox" id="txt_producer_yn" name="txt_producer_yn" <%if(clm_producer_yn.equals("Y")) { %>checked="" <% }%> value="">
								<span class="pmd-checkbox"> 생산자여부</span>
							</label>
						</div>
						<%@ include file="include/modal/modal_department_code.jsp" %>
						<%@ include file="include/modal/modal_authority_code.jsp" %>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" style="ta_comment" name="ta_comment"><%=clm_comment %></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="pmd-card-actions">
					<a href="javascript:void(0);" class="btn btn-primary next" onClick="JavaScript:$.fnc_report_data_save();" id="btn_save" name="btn_save">저장</a>
					<a href="user_info_detail.jsp?_user_id_=<%=_user_id_ %>" class="btn btn-primary next" id="btn_list" name="btn_list">취소</a>
					<!--
					<a href="user_list.jsp" class="btn btn-primary next" id="btn_list" name="btn_list">목록</a>
					<a href="user_info_save_proc.jsp?_user_id_=<%=_user_id_ %>" class="btn btn-primary next">저장</a>
					-->
				</div>
			</div> <!-- section content end -->
			</form>
		</div>
		<!-- Card Footer -->
		<div class="pmd-card-footer">
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
<!-- css 파일 -->
<link rel="stylesheet" href="https://nowonbun.github.io/Loader/loader.css">
<!-- javascript 파일 -->
<script type="text/javascript" src="https://nowonbun.github.io/Loader/loader.js"></script>
<script>
	$(document).ready(function() {
		$('#txt_client_name').blur();
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

<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/pmd-datetimepicker.css" />
<script type="text/javascript" src="components/select2/js/select2.full.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>

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
	// 생산자 여부txt_producer_yn
    $("input:checkbox").change(function(){
      if(this.checked){
        $(this).attr('value', 'Y');
		console.log($(this).val())
      }else{
        $(this).attr('value', 'N');
		console.log($(this).val())
      }
    });

	$(".direct-expand").click(function(){
		$(".direct-child-table").slideToggle(300);
		$(this).toggleClass( "child-table-collapse" );
	});

		
		var sPath=window.location.pathname;
		var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
		$(".pmd-sidebar-nav").each(function(){
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").addClass("open");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('.dropdown-menu').css("display", "block");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('a.dropdown-toggle').addClass("active");
			$(this).find("a[href='"+sPage+"']").addClass("active");
		});

		$.fnc_cost_row_add = function() {
			var empty_check = $("tr[id='tr_cost_empty']").length;
			var seq = 0;
			if(Number(empty_check)>0) {
 				$('#tbl_cost_item_list > tbody:last').remove();
				$('#tbl_cost_item_list').append('<tbody></tbody>');
				// seq = 1;
			}
			else {
				seq = $("input[id='txt_cost_code_sub_name']").length;
			}

			// var seq = $("input[id='txt_cost_code_sub_name']").length;
			// seq = Number(seq);

			var tags = '';
			tags += '<tr id="tr_cost_' + seq  + '">';
			tags += '	<td style="text-align:center;">' + (seq + 1) + '</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:20%; border-right:1px solid transparent;">';
			tags += '		<input type="text" id="txt_cost_code_name" name="txt_cost_code_name" style="width:100%; padding:5px; background-color:#eee;" value="" readOnly>';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_id" name="txt_cost_code_id">';
			tags += '		<input type="hidden" style="width:100%; padding:5px;" value="" id="txt_cost_code_sub_id" name="txt_cost_code_sub_id">';
			tags += '	</td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;"><button class="btn btn-primary next" type="button" style="font-size:8px;" data-param_01="' +  seq + '" data-param_02="0001" data-toggle="modal" id="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_cost_code(this);">선 택</button></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:center; background-color:#eee;" value="" id="txt_cost_code_unit" name="txt_cost_code_unit" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:left; background-color:#eee;" value="" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" id="txt_cost_cost_count" name="txt_cost_cost_count" style="width:100%; padding:5px; text-align:right;" value=""  onKeyUp="JavaScript:$.fnc_only_number(this, \'' + seq + '\');"></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_price" name="txt_cost_cost_price"onKeyUp="JavaScript:$.fnc_only_number_unit_price(\'C\', this, \'' + seq + '\');"  readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:right;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee;" value="" id="txt_cost_cost_total_price" name="txt_cost_cost_total_price" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee; background-color:#eee;" value="" id="txt_cost_comment" name="txt_cost_comment" readOnly></td>';
			tags += '</tr>';

			$('#tbl_cost_item_list tbody').append(tags);
		}

		$.fnc_file_row_add = function() {
			var empty_check = $("tr[id='tr_file_empty']").length;
			var seq = 0;
			if(Number(empty_check)>0) {
 				$('#tbl_file_item_list > tbody:last').remove();
				$('#tbl_file_item_list').append('<tbody></tbody>');
				seq = 0;
			}
			else {
				seq = $("a[id='btn_file_download']").length;
			}

			var tags = '';
			tags += '<tr id="tr_file_' + seq  + '">';
			tags += '	<td Style="border:1px solid #ccc; width:5%; text-align:center;">' + (seq + 1) + '</td>';
			tags += '	<td Style="border:1px solid #ccc; width:65%; text-align:left;"><input type="file" id="fl_attached_file" name="fl_attached_file" style="width:100%;"></td>';
			tags += '	<td Style="border:1px solid #ccc; width:10%; text-align:right;">0kb</td>';
			tags += '	<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;"><a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_download" disabled>다운로드</a></td>';
			tags += '	<td style="border:1px solid #ccc; width:10%; padding:3px; text-align:center;"><a href="javascript:void(0);" class="btn btn-primary next" style="font-size:8px; padding:10px;" id="btn_file_delete" disabled>삭제</a></td>';
			tags += '</tr>';

			$('#tbl_file_item_list tbody').append(tags);
		}

		$.fnc_add_comma = function(obj){
			var value = $(obj).val();
			value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			console.log('> value ' + value);
			$(obj).val(value);
			// return value;
		}

		$.fnc_modal_cost_code = function(obj) {
			var param_01 = $(obj).data('param_01');
			var param_02 = $(obj).data('param_02');
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_cost_code_list.jsp?seq=' + param_01 + '&code_id=' + param_02);
			$('#form-dialog_cost_code').modal('show');
		};

		$.fnc_modal_department_code = function(obj) {
			console.log('> $.fnc_modal_department_code');
			var param_01 = $(obj).data('param_01');
			// $('#ifrm_customer_code_list').attr('src', 'include/modal/modal_department_code_list.jsp?seq=' + param_01);
			$('#ifrm_department_code_list').attr('src', 'include/modal/modal_department_code_list.jsp');
			$('#form-dialog_department_code').modal('show');
		};

		$.fnc_modal_authority_code = function(obj) {
			console.log('> $.fnc_modal_authority_code');
			var param_01 = $(obj).data('param_01');
			// $('#ifrm_customer_code_list').attr('src', 'include/modal/modal_department_code_list.jsp?seq=' + param_01);
			$('#ifrm_authority_code_list').attr('src', 'include/modal/modal_authority_code_list.jsp');
			$('#form-dialog_authority_code').modal('show');
		};

		$.fnc_select_to_parent = function(seq, code_id, code_sub_id, code_name, code_sub_name, code_unit, code_price, code_comment) {
			console.log('> ' + seq + ' ' + code_id + ' ' + code_sub_id);
			if(code_id=='0001') {
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
			}
			else if(code_id=='0002') {
				$('input[name=txt_building_type]').val(code_sub_name);
				$('input[name=txt_building_type_id]').val(code_id+code_sub_id);
				if(code_sub_name!=''){ $('input[name=txt_building_type]').focus(); };
			}
			else if(code_id=='0003') {
				$('input[name=txt_building_deconstruction_report_yn_name]').val(code_sub_name);
				$('input[name=txt_building_deconstruction_report_yn]').val(code_id+code_sub_id);
				if(code_sub_name!=''){ $('input[name=txt_building_deconstruction_report_name]').focus(); };
			}
			else if(code_id=='0005') {
				$('input[name=txt_notice_type]').val(code_sub_name);
				$('input[name=txt_notice_type_id]').val(code_id+code_sub_id);
				if(code_sub_name!=''){ $('input[name=txt_notice_type]').focus(); };
			}
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
		};

		$.fnc_only_number_unit_price = function(type, obj, seq) {
			// seq = seq - 1;
			// console.log('> seq ' + seq);
			var income_total = 0;
			var cost_total = 0;

			// seq -= 1;
			// if(type=='C') {
				if ($(obj).val() != null && $(obj).val() != '') {
					$('input[name=txt_cost_total_price]').focus();
					$('input[name=txt_cost_total_price]').blur();
					$(obj).focus();
					var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
					var code_price = $('input[name=txt_cost_cost_count]').eq(Number(seq)).val().replace(/,/gi, '');
					var cost_total_price = Number(code_price)*tmps;
					// console.log('> seq ' + cost_total_price + ' = ' + code_price + ' * ' + tmps);
					cost_total_price = cost_total_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
					$('input[name=txt_cost_cost_total_price]').eq(Number(seq)).val(cost_total_price);
					var tmps2 = tmps.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
					$(obj).val(tmps2);

					var cost_array = [];
					cost_array = $('input[name=txt_cost_cost_total_price]');
					var total = 0;

					for(var i=0; i<cost_array.length; i++) {
						// console.log('> cost ' + i + ' ' + cost_array.eq(i).val());
						total += Number(cost_array.eq(i).val().replace(/,/gi, ''));
					}

					cost_total = total;

					// console.log('> cost_total ' + total);
					$('input[name=txt_cost_total_price]').val(total.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'));
				}
			
		}

		$.fnc_select_to_parent_user = function(customer_id, customer_name, customer_address, customer_employee_name, email, customer_tel, comment) {
			$('input[name=txt_department_name]').val(customer_name);
			$('input[name=txt_department_id]').val(customer_id);
			$('input[name=txt_department_name]').focus();
			$('#form-dialog_department_code').modal('hide');
		};

		$.fnc_select_to_authority = function(authority_id, authority_name) {
			$('input[name=txt_authority_name]').val(authority_name);
			$('input[name=txt_authority_id]').val(authority_id);
			$('input[name=txt_authority_name]').focus();
			$('#form-dialog_authority_code').modal('hide');
		};


		//입력한 문자열 전달
		$.inputNumberFormat = function(obj) {
			obj.value = $.comma($.uncomma(obj.value));
		}

		//콤마찍기
		$.comma = function(str) {
			str = String(str);
			return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		}

		//콤마풀기
		$.uncomma = function(str) {
			str = String(str);
			return str.replace(/[^\d]+/g, '');
		}

		//숫자만 리턴(저장할때)
		//alert(cf_getNumberOnly('1,2./3g')); -> 123 return
		$.cf_getNumberOnly = function(str) {
			var len      = str.length;
			var sReturn  = "";

			for (var i=0; i<len; i++){
				if ( (str.charAt(i) >= "0") && (str.charAt(i) <= "9") ){
					sReturn += str.charAt(i);
				}
			}
			return sReturn;
		}

		$.fnc_only_number = function(obj, seq) {
		 	if ($(obj).val() != null && $(obj).val() != '') {
				$('input[name=txt_cost_total_price]').focus();
				$('input[name=txt_cost_total_price]').blur();
				$(obj).focus();
		 		var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				var code_price = $('input[name=txt_cost_cost_price]').eq(Number(seq)).val().replace(/,/gi, '');
				var cost_total_price = Number(code_price)*tmps;
		 		cost_total_price = cost_total_price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
				$('input[name=txt_cost_cost_total_price]').eq(Number(seq)).val(cost_total_price);
		 		var tmps2 = tmps.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
		 		$(obj).val(tmps2);

				var cost_array = [];
				cost_array = $('input[name=txt_cost_cost_total_price]');

				var total = 0;

				for(var i=0; i<cost_array.length; i++) {
					// console.log('> cost ' + i + ' ' + cost_array.eq(i).val());
					total += Number(cost_array.eq(i).val().replace(/,/gi, ''));
				}

				$('input[name=txt_cost_total_price]').val($.fnc_comma(total));
		 	}
		}

		//콤마찍기
		$.fnc_comma = function(str) {
			str = String(str);
			return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		}

		$.volume_calc_string= function(obj) {
			var origin_number_array = [];
			var origin_number = 0;
			var int_number = 0;
			var dbl_number = 0;
			var total_string = '';
			if ($(obj).val() != null && $(obj).val() != '') {
				origin_number_array = $(obj).val().split(" ");
				origin_number = origin_number_array[0];
				// var tmps = parseInt(origin_number.replace(/[^0-9]/g, '')) || '0';
				// $(obj).val($.fnc_comma(tmps));
				// console.log('> ' + $.py_calculator(2, $(obj)).toFixed(2));
				// console.log('> ' + $.py_calculator(2, $(obj)).toFixed(2).split('.')[0]);
				int_number = $.fnc_only_number_with_value($.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[0]);
				dbl_number = $.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[1];
				total_string = origin_number + ' ' + int_number + '.' + dbl_number;
				console.log('> ' + total_string);
				// $(obj).val(total_string);
				$(obj).attr('placeholder', total_string);
			}
		}

		$.volume_calc_py= function(obj, target) {
			// var origin_number_array = [];
			var origin_number = 0;
			var int_number = 0;
			var dbl_number = 0;
			var total_string = '';
			if ($(obj).val() != null && $(obj).val() != '') {
				origin_number = Number($(obj).val().replace(/[^0-9]/g, ''));
				// console.log('> ' + origin_number);
				int_number = $.fnc_only_number_with_value($.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[0]);
				dbl_number = $.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[1];
				total_string = int_number + '.' + dbl_number;
				// console.log('> ' + total_string);
				$('input[name=' + target + ']').val(total_string);
			}
		}

		$('input[name=txt_building_volume]').focus(function(){
			$('input[name=txt_building_volume_py]').focus();
			if($('input[name=txt_building_volume]').val()=='') {
				$('input[name=txt_building_volume_py]').val('0');
			}
			this.focus();
		});

		$('input[name=txt_building_base_volume]').focus(function(){
			$('input[name=txt_building_base_volume_py]').focus();
			if($('input[name=txt_building_base_volume]').val()=='') {
			$('input[name=txt_building_base_volume_py]').val('0');
			}
			this.focus();
		});

		$.fnc_only_number_with_comma_volume = function(obj, target) {
			if ($(obj).val() != null && $(obj).val() != '') {
				var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				$(obj).val($.fnc_comma(tmps));

				$.volume_calc_py(obj, target);
			}

			if($(obj).val() == '') {
				$('input[name=' + target + ']').val('');
				$('input[name=' + target + ']').blur();
			}
		}

		$.fnc_only_number_with_comma = function(obj) {
			if ($(obj).val() != null && $(obj).val() != '') {
				var tmps = parseInt($(obj).val().replace(/[^0-9]/g, '')) || '0';
				$(obj).val($.fnc_comma(tmps));
			}
		}

		$.fnc_only_number_with_value = function(number) {
			// if ($(obj).val() != null && $(obj).val() != '') {
				var tmps = parseInt(number.replace(/[^0-9]/g, '')) || '0';
				return $.fnc_comma(tmps);
			// }
		}

		$.py_calculator_with_value = function(origin_type, value){
			var volume_value = 0;

			if(origin_type==1){ volume_value = parseFloat(value) * 3.3058; }
			else if(origin_type==2){ volume_value = parseFloat(value) / 3.3058;}

			return volume_value;
		}

		$.py_calculator = function(origin_type, obj){
			var volume_value = 0;

			if(origin_type==1){ volume_value = parseFloat($(obj).val()) * 3.3058; }
			else if(origin_type==2){ volume_value = parseFloat($(obj).val()) / 3.3058;}

			return volume_value;
		}

		$.fnc_report_data_save = function() {
			$.ajax({
				url: 'user_info_save_proc.jsp',
				data: $('#frm_order_data').serialize(),
				error : function(request, status, error){
					// console.log('error code:' + request.status + ', message : ' + request.responseText + ', error : ' + error);
					$("#p_alert_msg").html('변경사항에 실패하였습니다.');
					$('#div_alert_modal').modal("show");
					loader.off();
				},
				beforeSend : function(){
					loader.on(function(){
					});
				},
				success: function(result){
					var report_item_info_data = result;
					var user_id = '';

					jQuery.each(report_item_info_data, function(key, value){
						if(key=='user_data') {
							for(var i=0; i<value.length; i++) {
								user_id = value[i].user_id;
							}
						}
					});
					var input_file = $('input[name="fl_attached_file"]');
					if(input_file.length>0) {
						var form_data = new FormData();
						var seq_num = '00';
						for(var i=0; i<input_file.length; i++) {
							// console.log('> ' + i + ' ' + input_file[i].files.length);
							seq_num = (i<10)?('0'+i):i;
							form_data.append('upload_files_' + seq_num, input_file[i].files[0])
						};
						jQuery.ajax({
							url: 'file_upload_proc.jsp?order_id=' + user_id + '&process_type=USER_INFO',
							data: form_data,
							contentType : false,
							processData : false,
							type:'POST',
							error : function(request, status, error){
								console.log('error code:' + request.status + ', message : ' + request.responseText + ', error : ' + error);
								$("#p_alert_msg").html('파일 저장에 실패하였습니다.');
								$('#div_alert_modal').modal("show");
								loader.off();
							},
							beforeSend : function(){
								// loader.on(function(){
								// });
							},
							success: function(result){
								/*
								// // console.log('file success');
								// $("#txt_order_id").val(order_id);
								// $("#txt_process_type").val('S');
								// $('#btn_save').text('수정');
								// $("#p_alert_msg").html('저장 성공하였습니다.');
								// $('#div_alert_modal').modal("show");
								loader.off();
								// $("#p_alert_msg").html("저장 성공하였습니다.");
								// $('#div_alert_modal').modal("show");
								$(location).attr("href", 'user_info_detail.jsp?_user_id_=' + user_id)
								*/
							}
						});
					}
					else {
						// $(location).attr("href", 'user_info_detail.jsp?_user_id_=<%=_user_id_ %>');
					}

					input_file = $('input[name="fl_user_img"]');
					console.log('> input_file.length ' + input_file.length);
					if(input_file.length>0) {
						var form_data = new FormData();
						var seq_num = '00';
						for(var i=0; i<input_file.length; i++) {
							// console.log('> ' + i + ' ' + input_file[i].files.length);
							seq_num = (i<10)?('0'+i):i;
							form_data.append('upload_files_' + seq_num, input_file[i].files[0])
						};
						jQuery.ajax({
							url: 'file_upload_photo_proc.jsp?order_id=' + user_id,
							data: form_data,
							contentType : false,
							processData : false,
							type:'POST',
							error : function(request, status, error){
								console.log('error code:' + request.status + ', message : ' + request.responseText + ', error : ' + error);
								$("#p_alert_msg").html('파일 저장에 실패하였습니다.');
								$('#div_alert_modal').modal("show");
								loader.off();
							},
							beforeSend : function(){
								// loader.on(function(){
								// });
							},
							success: function(result){
								// // console.log('file success');
								// $("#txt_order_id").val(order_id);
								// $("#txt_process_type").val('S');
								// $('#btn_save').text('수정');
								// $("#p_alert_msg").html('저장 성공하였습니다.');
								// $('#div_alert_modal').modal("show");
								// loader.off();
								// $("#p_alert_msg").html("저장 성공하였습니다.");
								// $('#div_alert_modal').modal("show");
								// $(location).attr("href", 'user_info_detail.jsp?_user_id_=' + user_id)
							}
						});
					}

					loader.off();

					$(location).attr("href", 'user_info_detail.jsp?_user_id_=<%=_user_id_ %>');
				}
			});
		}

		$('#txt_notice_start_date').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_notice_end_date').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$.fnc_file_data_delete = function(order_id, file_seq, file_id) {
			jQuery.ajax({
				url: 'user_file_data_delete_proc.jsp',
				data: {
					'_order_id_' : order_id,
					'_file_seq_' : file_seq
				},
				error : function(){
					console.log('error');
					$("#p_alert_msg").html("변경사항에 실패하였습니다.");
					$('#div_alert_modal').modal("show");
					loader.off();
				},
				beforeSend : function(){
					loader.on(function(){
					});
				},
				success: function(result){
					console.log('#tr_' + file_id);
					$('#tr_' + file_id).children().remove();
					// var tag = '';
					// tag += '<tr>';
					// tag += '	<td data-title="TicketNo"></td>';
					// tag += '	<td data-title="building_address"style="padding:0px;"></td>';
					// tag += '	<td data-title="order_estimation_price">&nbsp;</td>';
					// tag += '	<td data-title="building_height"></td>';
					// tag += '	<td data-title="building_type"></td>';
					// tag += '	<td data-title="reg_datetime"></td>';
					// tag += '	<td class="pmd-table-row-action"></td>';
					// tag += '	<td class="pmd-table-row-action"></td>';
					// tag += '	<td class="pmd-table-row-action"></td>';
					// tag += '	<td data-title="BrowserName"></td>';
					// tag += '</tr>';
					// $('#main_list > tbody:last').append(tag);
					$("#p_alert_msg").html("파일 삭제되었습니다.");
					$('#div_alert_modal').modal("show");
					loader.off();
				}
			});
		};
	});
</script>






<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	// 우편번호 찾기 화면을 넣을 element
	var element_layer = document.getElementById('layer');

	function closeDaumPostcode() {
		// iframe을 넣은 element를 안보이게 한다.
		element_layer.style.display = 'none';
	}

	function sample2_execDaumPostcode() {
		new daum.Postcode({
			oncomplete: function(data) {
				// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if(data.userSelectedType === 'R'){
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if(data.buildingName !== '' && data.apartment === 'Y'){
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if(extraAddr !== ''){
						extraAddr = ' (' + extraAddr + ')';
					}
					// 조합된 참고항목을 해당 필드에 넣는다.
					// document.getElementById("sample2_extraAddress").value = extraAddr;

				} else {
					// document.getElementById("sample2_extraAddress").value = '';
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				// document.getElementById('sample2_postcode').value = data.zonecode;
				document.getElementById("txt_user_address").value = data.zonecode + ' ' + extraAddr + ' ' + addr;
				document.getElementById("txt_user_address").focus();
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("txt_user_address_detail").focus();

				// iframe을 넣은 element를 안보이게 한다.
				// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
				element_layer.style.display = 'none';
			},
			width : '100%',
			height : '100%',
			maxSuggestItems : 5
		}).embed(element_layer);

		// iframe을 넣은 element를 보이게 한다.
		element_layer.style.display = 'block';

		// iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
		initLayerPosition();
	}

	function closeDaumPostcode() {
		// iframe을 넣은 element를 안보이게 한다.
		element_layer.style.display = 'none';
	}

	// 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
	// resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
	// 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
	function initLayerPosition(){
		var width = 300; //우편번호서비스가 들어갈 element의 width
		var height = 400; //우편번호서비스가 들어갈 element의 height
		var borderWidth = 5; //샘플에서 사용하는 border의 두께

		// 위에서 선언한 값들을 실제 element에 넣는다.
		element_layer.style.width = width + 'px';
		element_layer.style.height = height + 'px';
		element_layer.style.border = borderWidth + 'px solid';
		// 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
		element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
		element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
	}
</script>

</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>