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
<!-- Select2 css-->
<link rel="stylesheet" type="text/css" href="components/select2/css/select2.min.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/select2-bootstrap.css" />
<link rel="stylesheet" type="text/css" href="components/select2/css/pmd-select2.css" />
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

h3 {
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
		String notice_id = (request.getParameter("_notice_id_")==null)?"":request.getParameter("_notice_id_");

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
			if(!_notice_id_.equals("")) {
				strCondition += "and x.clm_notice_id='" + _notice_id_ + "' ";
			}
			String query  = "";
			query  = "";
			query += " select x.clm_notice_id,x.clm_notice_contents,x.clm_notice_start_date,x.clm_notice_end_date,x.clm_notice_title";
			query += "  ,x.clm_notice_type,clm_del_yn,x.clm_comment,x.clm_reg_datetime,x.clm_reg_user_id,x.clm_company_key,coalesce(z1.clm_code_sub_name,'') as clm_notice_type_name  ";
			query += "  from tbl_notice_info x ";
			query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_notice_type = z1.clm_code_sub_id and z1.clm_code_id = '0010' ";
			query += " where x.clm_company_key = '" + SessionCompanyKey + "' and x.clm_del_yn='N' ";
			query += " order by x.clm_notice_id desc;";
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
				String clm_notice_id         	 = rs.getString("clm_notice_id");
				String clm_notice_contents  	 = rs.getString("clm_notice_contents");
				String clm_notice_start_date   	 = rs.getString("clm_notice_start_date");
				String clm_notice_end_date    	 = rs.getString("clm_notice_end_date");
				String clm_notice_type        	 = rs.getString("clm_notice_type");
				String clm_del_yn             	 = rs.getString("clm_del_yn");
				String clm_comment            	 = rs.getString("clm_comment");
				String clm_reg_datetime       	 = rs.getString("clm_reg_datetime");
				String clm_notice_title       	 = rs.getString("clm_notice_title");
				String clm_company_key        	 = rs.getString("clm_company_key");
				String clm_reg_user_id         	 = rs.getString("clm_reg_user_id");
				String clm_notice_type_name    	 = rs.getString("clm_notice_type_name");
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
				<span>공지사항 수정</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
			  <li><a href="index.jsp">Home</a></li>
			  <li class="active">공지사항 관리</li>
			  <li class="active">공지사항 수정</li>
			</ol><!--breadcrum end-->
		</div>

		<div class="table-responsive pmd-card pmd-z-depth">
			<!--section-title -- >
			<h2>Basic Form</h2>< !--section-title end -->
			<!-- section content start-->
			<form name="frm_order_data" id="frm_order_data">
			<div class="pmd-card pmd-z-depth">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<input type="hidden" id="txt_notice_id" name="txt_notice_id" value="<%=_notice_id_ %>" />
								<label for="regular1" class="control-label">
									공지제목<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_notice_title" name="txt_notice_title" class="form-control" value="<%=clm_notice_title %>">
								<input type="hidden" id="txt_process_type" name="txt_process_type" class="form-control" value="U">
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">
								<i class="material-icons md-dark pmd-sm" style="font-size:12px;">date_range</i>
								공지시작일자<span style="font-weight:bold; color:red;">*</span>
							</label>
							<input type="text" class="mat-input form-control" id="txt_notice_start_date" name="txt_notice_start_date" value="<%=clm_notice_start_date %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<label for="first-name">
								<i class="material-icons md-dark pmd-sm" style="font-size:12px;">date_range</i>
								공지종료일자<span style="font-weight:bold; color:red;">*</span>
							</label>
							<input type="text" class="mat-input form-control" id="txt_notice_end_date" name="txt_notice_end_date" value="<%=clm_notice_end_date %>">
						</div>
						<div class="form-group pmd-textfield pmd-textfield-floating-label col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
									공지유형<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" id="txt_notice_type_name" class="mat-input form-control" value="<%= clm_notice_type_name %>" value="" data-param_01="0" data-param_02="0003" data-toggle="modal" onClick="JavaScript:$.fnc_modal_notice_code(this);" readonly>
								<input type="hidden" id="txt_notice_type_id" name="txt_notice_type_id" class="form-control" value="<%= clm_notice_type %>">
							</div>
						</div>
						<%@ include file="include/modal/modal_notice_code.jsp" %>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">공지내용</label>
								<textarea style="height: 250px;" required class="form-control" id="ta_notice_contents" name="ta_notice_contents" ><%=clm_notice_contents %></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="pmd-card-actions">
					<a href="javascript:void(0);" class="btn btn-primary next" id="btn_notice_reg" name="btn_notice_reg">저장</a>
					<a href="notice_list.jsp?" class="btn btn-primary next" id="btn_list" name="btn_list">취소</a>
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


		// input자동완성 막기
		const inputs = document.querySelectorAll('input');
			for (let i = 0; i < inputs.length; i++) {
			inputs[i].setAttribute('autocomplete', 'off');
		}


		
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
	$(document).ready(function () {
	
		// input자동완성 막기
		const inputs = document.querySelectorAll('input');
			for (let i = 0; i < inputs.length; i++) {
			inputs[i].setAttribute('autocomplete', 'off');
		}
	});
</script>

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
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_notice_code_list.jsp?seq=' + param_01 + '&code_id=' + param_02);
			$('#form-dialog_cost_code').modal('show');
		};

		$.fnc_modal_customer_code = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_customer_code_list').attr('src', 'include/modal/modal_customer_code_list.jsp?seq=' + param_01);
			$('#form-dialog_customer_code').modal('show');
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

		$.fnc_select_to_parent_customer = function(customer_id, customer_name, customer_address, customer_employee_name, email, customer_tel, comment) {
			$('input[name=txt_client_name]').val(customer_name);
			$('input[name=txt_client_id]').val(customer_id);
			$('input[name=txt_client_addr]').val(customer_address);
			$('input[name=txt_order_email]').val(email);
			$('#form-dialog_customer_code').modal('hide');
			if(customer_name!=''){ $('input[name=txt_client_name]').focus(); };
			if(customer_id!=''){ $('input[name=txt_client_id]').focus() };
			if(customer_address!=''){ $('input[name=txt_client_addr]').focus(); };
			if(email!=''){ $('input[name=txt_order_email]').focus(); };
		
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

		$.fnc_file_data_delete = function(notice_id, notice_seq) {
			jQuery.ajax({
				url: 'notice_file_data_delete_proc.jsp',
				data: {
					'_notice_id_' : notice_id,
					'_notice_seq_' : notice_seq
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
					loader.off();
					location.reload();
				}
			});
		};

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

		$.fnc_modal_notice_code = function(obj) {
			var param_01 = $(obj).data('param_01');
			var param_02 = $(obj).data('param_02');
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_notice_code_list.jsp?seq=' + param_01 + '&code_id=' + param_02);
			$('#form-dialog_cost_code').modal('show');
		};


		$.fnc_select_to_parent_notice = function(seq,code_id,sub_name,sub_id) {
			console.log(code_id);
			$('input[id=txt_notice_type_name]').val(sub_name);
			$('input[id=txt_notice_type_id]').val(sub_id);
			
			$('#preNotice').attr('class','form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed');
			
			$('#form-dialog_cost_code').modal('hide');
			
		};
	
		function btn_notice_reg() {
			if ($("#txt_notice_title").val() == '') {
				alert('공지제목을 입력해주시기 바랍니다.');
				return;
			}
			if ($("#txt_notice_start_date").val() == '') {
				alert('공지시작일자를 입력해주시기 바랍니다.');
				return;
			}
			if ($("#txt_notice_end_date").val() == '') {
				alert('공지종료일자를 입력해주시기 바랍니다.');
				return;
			}
			if ($("#txt_notice_type_id").val() == '' || $("#txt_notice_type_name").val() == '') {
				alert('공지유형을 선택해주시기 바랍니다.');
				return;
			}

			if(confirm('공지정보를 수정 하시겠습니까?')){

				$.ajax({
					type : "POST",
					url : "notice_reg_save_proc.jsp",
					data : {

						'notice_id' : '<%= notice_id %>', 
						'notice_title' : $('#txt_notice_title').val(), 
						'notice_start_date' : $('#txt_notice_start_date').val(),
						'notice_end_date' : $('#txt_notice_end_date').val(),
						'notice_type_id' : $('#txt_notice_type_id').val(),
						'notice_contents' : $('#ta_notice_contents').val(),
						'process_type' : $('#txt_process_type').val()
							
					},
					error : function() {
						console.log('공지 수정 실패');
					},
					success: function(args){
						alert("공지 수정 완료");
						$(location).attr("href", 'notice_list.jsp');
					}
				});

			}

		}


		jQuery('#btn_notice_reg').click(function(e){
			btn_notice_reg();
		});

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
	});
</script>






<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>