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
<script src="assets/js/jquery-1.12.2.min.js"></script>
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

String clm_machine_id				=	"";
String clm_machine_name				=	"";
String clm_company_key					=	"";
String clm_machine_type					=	"";
String clm_machine_type_name			=	"";

try {
			stmt = conn.createStatement();
			String strCondition = "";
			strCondition = "";
			String query =	"";
			query = " select x.clm_machine_id,x.clm_machine_name,x.clm_machine_type, coalesce(z1.clm_code_sub_name, '') as clm_machine_type_name,x.clm_company_key ";
			query += " from tbl_machine_info x ";
			query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_machine_type = z1.clm_code_sub_id and z1.clm_code_id = '0009' ";
			query += " where x.clm_company_key = '" + SessionCompanyKey + "' ";
			query += " order by x.clm_machine_id ";

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

				iRowCnt++;
				clm_machine_id					 = rs.getString("clm_machine_id");
				clm_machine_name				 = rs.getString("clm_machine_name");
				clm_company_key					 	 = rs.getString("clm_company_key");
				clm_machine_type				 	 = rs.getString("clm_machine_type");
				clm_machine_type_name			 	 = rs.getString("clm_machine_type_name");
				
			}


			

			
%>
<script type="text/javascript" language="javascript">
	var seq_number = 0;
	jQuery(document).ready(function(){


	var data_array = [];

	function btn_machine_reg() {


	if(typeof $('#txt_machine_id').val() != 'undefined'){
			

		if($('#machine_name').val()== ''){
			alert('설비명을 입력해주세요');
			return;
		}

		if($('#machine_type_name').val()== ''){
		alert("설비 타입을 선택해주세요.");
		return;
		}


	}
		console.log($('#txt_machine_name').val());
		console.log($('#txt_machine_name').val());
		console.log($('#txt_machine_type_name').val());
		console.log($('#txt_machine_id').val());
		console.log($('#ta_comment').val());

		if(confirm('입고정보를 등록 하시겠습니까?')){

			$.ajax({
				type : "POST",
				url : "machine_save_proc.jsp",
				data : {
					'machine_name' : $('#txt_machine_name').val(),
					'machine_type_name' : $('#txt_machine_type_name').val(),
					'machine_sub_id' : $('#txt_machine_id').val(),  // code_sub_id
					'ta_comment' : $('#ta_comment').val(),  // code_sub_id
					},
					
				error : function() {
					console.log('설비 등록 실패');
				},
				success: function(args){
					alert("설비 등록 완료");
					$(location).attr("href", 'machine_info_list.jsp');
				}
			});

		}

	}

	jQuery('#btn_machine_reg').click(function(e){
		btn_machine_reg();
	});

	var data_array = [];

	// function get_grid_data(){
	// 	$.ajax({
	// 		type : "POST",
	// 		url : "MaterialIncomeRegPopData.jsp",
	// 		data : { },
	// 		dataType : "json",
	// 		error : function() {
	// 			console.log('통신 실패');
	// 		},
	// 		success : function(data) {
				
	// 			data_array = [];
	// 			console.log(data);

			
	// 		}
	// 	});
	// }

		// get_grid_data();
	
});

	</script>
<!--content area start-->
<div id="content" class="pmd-content inner-page">
<!--tab start-->
    <div class="container-fluid full-width-container value-added-detail-page">
		<div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>설비관리</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.jsp">Home</a></li>
				<li class="active">설비 정보</li>
				<li class="active">설비 추가</li>
			</ol><!--breadcrum end-->
		</div>

		<div class="table-responsive pmd-card pmd-z-depth">
			<!--section-title -- >
			<h2>Basic Form</h2>< !--section-title end -->
			<!-- section content start-->
			<form name="frm_order_data" id="frm_order_data">
			<div class="pmd-card pmd-z-depth">
				<input type="hidden" id="txt_process_type" name="txt_process_type" class="form-control" value="S">
				<div class="pmd-card-body">
						
					<div class="group-fields clearfix row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									설비명
								</label>
								<input type="text" id="txt_machine_name" value="" class="form-control" />
							</div>
						</div>
						
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div id="preCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									설비타입<font style="color:red">*</font>
								</label>
								<input type="hidden" id="txt_machine_id" value="" />
								<input type="text" id="txt_machine_type_name" class="mat-input form-control" value="" value="" data-param_01="0" data-param_02="0003" data-toggle="modal" onClick="JavaScript:$.fnc_modal_machine(this);" readonly>
							</div>
						</div>
					</div>
					
					
					<%@ include file="include/modal/modal_machine_modal_code.jsp" %>

					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" id="ta_comment" name="ta_comment"></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="pmd-card-actions">
					<a href="javascript:void(0);" class="btn btn-primary next" id="btn_machine_reg" name="btn_machine_reg">저장</a>
					<a href="machine_info_list.jsp?" class="btn btn-primary next" id="btn_list" name="btn_list">취소</a>
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

<script type="text/javascript" src="components/select2/js/pmd-select2.js"></script>
<script>
	$(document).ready(function() {

		// input 자동완성 막는 기능
			const inputs = document.querySelectorAll('input');
				for (let i = 0; i < inputs.length; i++) {
				inputs[i].setAttribute('autocomplete', 'off');
			}

		var sPath=window.location.pathname;
		var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
		$(".pmd-sidebar-nav").each(function(){
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").addClass("open");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('.dropdown-menu').css("display", "block");
			$(this).find("a[href='"+sPage+"']").parents(".dropdown").find('a.dropdown-toggle').addClass("active");
			$(this).find("a[href='"+sPage+"']").addClass("active");
		});

		$.fnc_modal_machine = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_machine_modal_list').attr('src', 'include/modal/modal_machine_modal_list.jsp');
			$('#form-dialog_machine_modal_code').modal('show');
		};

		
		$.fnc_select_to_parent_machine = function(seq,code_id,sub_name,sub_id) {
			console.log(code_id);
			$('input[id=txt_machine_type_name]').val(sub_name);
			$('input[id=txt_machine_id]').val(sub_id);
			
			$('#preCode').attr('class','form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed');
			
			$('#form-dialog_machine_modal_code').modal('hide');
			
		};


		$('#txt_order_date').datetimepicker({
			useCurrent: false,
			'format' : "YYYY-MM-DD", // HH:mm:ss,
			sideBySide: true,
			widgetPositioning: {
				horizontal: "auto",
				vertical: "auto"
			}
		});

		$('#txt_due_date').datetimepicker({
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

</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>