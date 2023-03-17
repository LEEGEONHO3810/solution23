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
String MaterialIncomeSeq = (request.getParameter("MaterialIncomeSeq")==null)?"":request.getParameter("MaterialIncomeSeq");
String job_order = (request.getParameter("_order_id_")==null)?"":request.getParameter("_order_id_");
System.out.println(job_order);
String clm_joborder_id			= "";
String clm_product_id			= "";
String clm_product_name			= "";
String clm_company_key			= "";
String clm_planned_datetime		= "";
String clm_product_count		= "";
String clm_start_datetime		= "";
String clm_end_datetime			= "";
String clm_complete_yn			= "";

try {
			stmt = conn.createStatement();
			String strCondition = "";
			strCondition = "";
			String query =	"";
			query = " SELECT x.clm_joborder_id ,x.clm_planned_datetime ,y.clm_product_id ,y.clm_product_name , x.clm_company_key ";
			query += " ,x.clm_product_count ,x.clm_start_datetime ,x.clm_end_datetime ,x.clm_complete_yn ";
			query += " from tbl_joborder_info x ";
			query += " left outer join tbl_product_info y on x.clm_product_id = y.clm_product_id ";
			query += " where x.clm_company_key ='" + SessionCompanyKey + "' and x.clm_complete_yn = 'N' and x.clm_joborder_id = '" + job_order +  "' ";
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
				clm_joborder_id					 = rs.getString("clm_joborder_id");
				clm_product_id					 = rs.getString("clm_product_id");
				clm_product_name				 = rs.getString("clm_product_name");
				clm_company_key					 = rs.getString("clm_company_key");
				clm_planned_datetime				 = rs.getString("clm_planned_datetime");
				clm_product_count				 = rs.getString("clm_product_count");
				clm_start_datetime			 	 = rs.getString("clm_start_datetime");
				clm_end_datetime				 = rs.getString("clm_end_datetime");
				clm_complete_yn				 	 = rs.getString("clm_complete_yn");
				
			}


			

			
%>
<script type="text/javascript" language="javascript">
	var seq_number = 0;
	jQuery(document).ready(function(){

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

		var MaterialIncomeSeq = '<%=MaterialIncomeSeq %>';
		// $(window).load(function() {
		// 	$("#txt_material_order_id").attr('readonly',true);
		// 	// $('html').css("overflow","hidden");
		// 	$("#background").fullBg();

		// });

		var data_array = [];

		joborderData();

		function btn_joborder_reg() {

			var data = new Array();

			// if($("#txt_client_id").val() == '' || $("#txt_client_name").val() == ''){
			// 	alert('거래처를 선택 해주시기 바랍니다.');
			// 	return;
			// }
			// if($("#txt_income_delivery_date").val() == ''){
			// 	alert('입고일을 선택 해주시기 바랍니다.');
			// 	return;
			// }

			if(seq_number == 0){

				alert('입고정보를 추가해주시기 바랍니다.');
				return;
			}
			var idx = 0;
			
			for(var i=0; i<seq_number; i++){

				var tmpData = new Object();

					if(typeof $('#material_id_'+i).val() != 'undefined'){
						
						idx++;

						if($('#txt_product_name').val()== ''){
							alert('제품명을 입력해주세요');
							return;
						}


						if($('#use_count_'+i).val() == '' || $('#use_count_'+i).val() <= 0){
							alert('사용 할 재고를 입력해주세요.');
							return;
						}

						if(Number($('#material_stock_count_'+i).val()) < Number($('#use_count_'+i).val())){
						alert("재고의 개수를 넘어서 사용 할 수 없습니다.");
						return;
						}

						tmpData.material_id = $('#material_id_'+i).val();
						tmpData.use_count = $('#use_count_'+i).val(); // 사용재고 개수
						data.push(tmpData);
					

				}

			}

			console.log(data);
			if(confirm('입고정보를 등록 하시겠습니까?')){

				$.ajax({
					type : "POST",
					url : "joborder_reg_update_proc.jsp",
					data : {

						'dataArr' : JSON.stringify(data),
						'order_count' : $('#txt_order_count').val(), // 재작개수
						'job_order_id' : $('#txt_job_order_id').val(),
						'supply_count' : $('#txt_supply_count').val(),
						'product_id' : $('#txt_product_id').val(),
						'job_startTime' : $('#txt_job_startTime').val(),
						'job_endTime' : $('#txt_job_endTime').val(),
						'comment' : $('#ta_comment').val(),
						'order_date' : $('#txt_order_date').val()
							
						},
					error : function() {
						console.log('자재입고 등록 실패');
					},
					success: function(args){
						alert("작업지시서 등록완료");
						$(location).attr("href", 'joborder_info_list.jsp');
					}
				});

			}

		}

		jQuery.income_material_del = function(rowId, material_order_id) {
			if(material_order_id == ''){
				$('#tbl_material_income_slave > tbody > tr#income_tr_'+rowId).remove();
			}else{
				$.ajax({
					url : 'DeletePackageRecipeInfo.jsp',
					data : { 'MaterialIncomeSeq' : material_order_id, 'material_id' : material_id },
					type : "POST",
					dataType : "text",
					error : function() {
						alert('자재 삭제 실패');
					},
					success : function(data){
						// alert('자재 삭제 성공');
						$('#tbl_material_income_slave > tbody > tr#income_tr_'+rowId).remove();
					}
				});
			}
		}

		jQuery('#btn_joborder_reg').click(function(e){
			btn_joborder_reg();
		});



		jQuery('#btn_model_info_reg').click(function(e){
			var appendTr = '';
			appendTr += '<tr id="income_tr_' + seq_number + '">';
			appendTr += '<td style="text-align:center;"><input type="text" class="form-control" style=" background-color:white;" id="material_stock_name_' + seq_number + '" data-param_01="' +  seq_number + '" data-toggle="modal" value="" onClick="JavaScript:$.fnc_modal_material_stock(this)" readonly/></td>';
			appendTr += '<input type="hidden" id="material_id_' + seq_number + '" value=""></td>';
			appendTr += '<td style="text-align:center;"><input type="text" style="text-align: center;" class="form-control" id="material_stock_main_' + seq_number + '"  value="" readonly/></td>';
			appendTr += '<td style="text-align:center;"><input type="text" style="text-align: center;" class="form-control" id="material_stock_sub_' + seq_number + '"  value="" readonly/></td>';
			appendTr += '<td style="text-align:center;"><input type="number" style="text-align: right;" class="form-control" id="use_count_' + seq_number + '" value="0"/></td>';
			appendTr += '<td style="text-align:center;"><input type="text" style="text-align: right;" class="form-control" id="material_stock_count_' + seq_number + '" value="" readonly/></td>';
			appendTr += '<td style="text-align:center;"><input type="text" style="text-align: center;" class="form-control" id="material_stock_spec_' + seq_number + '" value="" readonly/></td>';
			appendTr += '<td style="text-align:center;"><input type="button" class="btn btn-danger next" onClick="JavaScript:jQuery.income_material_del(\'' + seq_number + '\',\'\');" value="삭제" /></td>';
			
			appendTr += '</tr>';

			seq_number = seq_number + 1;

			$("#tbl_material_income_slave > tbody").append(appendTr);
		});


		var data_array = [];

		function get_grid_data(){
			$.ajax({
				type : "POST",
				url : "MaterialIncomeRegPopData.jsp",
				data : { 'materialincomeseq' : MaterialIncomeSeq },
				dataType : "json",
				error : function() {
					console.log('통신 실패');
				},
				success : function(data) {
					
					data_array = [];
					console.log(data);

				}
			});
		}

		if(MaterialIncomeSeq=='') {
		}
		else {
			get_grid_data();
		}
		
		var dataArray = [];
	});


	jQuery.income_material_del = function(rowId, material_order_id) {
		if(material_order_id == ''){
			$('#tbl_material_income_slave > tbody > tr#income_tr_'+rowId).remove();
		}else{
			$.ajax({
				url : 'DeletePackageRecipeInfo.jsp',
				data : { 'MaterialIncomeSeq' : material_order_id, 'material_id' : material_id },
				type : "POST",
				dataType : "text",
				error : function() {
					alert('자재 삭제 실패');
				},
				success : function(data){
					// alert('자재 삭제 성공');
					$('#tbl_material_income_slave > tbody > tr#income_tr_'+rowId).remove();

				}
			});
		}
	}

	jQuery('#txt_product_name').click(function(e){
		console.log(material_id);
	});

	function joborderData() {
	}

</script>
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
				<span>작업지시서</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.jsp">Home</a></li>
				<li class="active">생산 관리</li>
				<li class="active">작업지시서 추가</li>
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
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div id="preMaterialName" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">
									작업지시번호<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="text" class="mat-input form-control"  id="txt_job_order_id" value="<%= clm_joborder_id %>" readonly>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									작업예정일자<font style="color:red">*</font>
								</label>
								<input type="text" id="txt_order_date" value="<%= clm_planned_datetime %>" class="form-control" readonly/>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div id="preCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									제품명<font style="color:red">*</font>
								</label>
								<input type="text" id="txt_product_name" class="form-control" value="<%= clm_product_name %>" readonly>
							</div>
						</div>
					</div>	
					<div class="group-fields clearfix row">
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									작업 시작시간<font style="color:red">*</font>
								</label>
								<input type="text" id="txt_job_startTime" value="<%= clm_start_datetime %>" class="form-control" readonly/>
							</div>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									작업 마감시간<font style="color:red">*</font>
								</label>
								<input type="text" id="txt_job_endTime" value="<%= clm_end_datetime %>" class="form-control" readonly/>
							</div>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
							<div id="machineCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									기계 설비<font style="color:red">*</font>
								</label>
								<input type="hidden" id="txt_machine_id" value=""/>
								<input type="text" id="txt_machine_name" class="mat-input form-control" value="" value="" data-param_01="0" data-param_02="0003" data-toggle="modal" onClick="JavaScript:$.fnc_modal_machine(this);" readonly>
							</div>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
							<div id="preCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									제작 개수<font style="color:red">*</font>
								</label>
								<input type="number" id="txt_order_count" value="<%= clm_product_count %>" class="form-control" readonly/>
							</div>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
							<div id="preCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									생산 개수<font style="color:red">*</font>
								</label>
								<input type="number" id="txt_supply_count" value="" class="form-control"/>
							</div>
						</div>
					</div>
						<div class="group-fields clearfix row">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
								<div class="form-group pmd-textfield pmd-textfield-floating-label" style="text-align: right;">
									<input type="button" id="btn_model_info_reg" class="btn btn-primary next" value="추가" />
								</div>
							</div>
						</div>
					<h2 style="font-size: 23px;">사용자재</h2>
					<div class="group-fields clearfix row" style="overflow: auto; height: 300px;">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="width: 100%; min-width: 1700px;">
							<table id="tbl_material_income_slave" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th style="width: 180px !important; text-align: center;">자재명</th>
										<!-- <th style="width: 180px !important; text-align: center;">입고번호</th> -->
										<th style="width: 130px !important; text-align: center;">대분류</th>
										<th style="width: 180px !important; text-align: center;">소분류</th>
										<th style="width: 130px !important; text-align: center;">사용재고 개수</th>
										<th style="width: 150px !important; text-align: center;">자재 재고</th>
										<th style="width: 150px !important; text-align: center;">자재 크기</th>
										<th style="text-align: center; width: 100px;">삭제</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
					</div>	

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
					<a href="javascript:void(0);" class="btn btn-primary next" id="btn_joborder_reg" name="btn_joborder_reg">저장</a>
					<a href="joborder_info_list.jsp?" class="btn btn-primary next" id="btn_list" name="btn_list">취소</a>
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

<!-- Scripts Ends -->

<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="components/datetimepicker/css/pmd-datetimepicker.css" />
<script type="text/javascript" src="components/select2/js/select2.full.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>

<!--detail page table data expand collapse javascript-->
<!-- Scripts Ends -->
<!-- Select2 js-->

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

		$.fnc_modal_product = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_product_code_list').attr('src', 'include/modal/modal_product_list.jsp');
			$('#form-dialog_product_code').modal('show');
		};

		
		$.fnc_select_to_parent_product = function(seq,product_id, product_name, product_code, product_main_type_name, product_sub_type_name, product_spec) {
			console.log(product_id);
			$('input[id=txt_product_name]').val(product_name);
			$('input[id=txt_product_id]').val(product_id);
			
			$('#preCode').attr('class','form-group pmd-textfield pmd-textfield-floating-label pmd-textfield-floating-label-completed');
			
			$('#form-dialog_product_code').modal('hide');
			
		};

		// 재고 모달창// 입고 번호 
		$.fnc_modal_material_stock = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_material_code_list').attr('src', 'include/modal/modal_material_stock_list.jsp?seq='+param_01);
			$('#form-dialog_material_code').modal('show');
		};
		
		$.fnc_select_to_parent_material_stock = function(seq,material_id, material_name, material_code, material_main_type, material_sub_type, material_unit,stock_count) {
			
			for(var i=0; i<seq; i++){
				if(typeof $('#material_id_'+i).val() != 'undefined'){
					if($('#material_id_'+i).val() == material_id){
						alert("이미 선택한 입고번호입니다.");
						return;
					}
				}
			}
			
			console.log(material_id);
			$('input[id=material_id_'+seq+']').val(material_id);
			$('input[id=material_stock_name_'+seq+']').val(material_name);
			$('input[id=material_stock_main_'+seq+']').val(material_main_type);
			$('input[id=material_stock_sub_'+seq+']').val(material_sub_type);
			$('input[id=material_stock_spec_'+seq+']').val(material_unit);
			$('input[id=material_stock_count_'+seq+']').val(stock_count);

			$('#form-dialog_material_code').modal('hide');
			
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