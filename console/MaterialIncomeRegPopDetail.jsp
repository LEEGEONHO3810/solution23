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
input{
	-webkit-box-shadow: none !important;
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
String material_income_id = (request.getParameter("_material_income_id_")==null)?"":request.getParameter("_material_income_id_");

String query  = "";
String clm_material_order_id         = "";
String clm_client_id         		 = "";
String clm_client_name               = "";
String clm_material_id            	 = "";
String clm_material_name             = "";
String clm_order_date                = "";
String clm_comment       			 = "";
String clm_due_date       			 = "";
String clm_income_yn       			 = "";
String clm_material_order_seq       			 = "";
try {
			stmt = conn.createStatement();
			String strCondition = "";
			strCondition = "";
			query = "";
			query += " select x.clm_material_order_id, x.clm_client_id , t.clm_material_id,z.clm_client_name,x.clm_due_date, y.clm_material_name, x.clm_order_date ";
			query += "	, coalesce(x.clm_comment,'') clm_comment, t.clm_income_yn , t.clm_material_order_seq ";
			query += "  from tbl_material_order_info x ";
			query += "  left outer join tbl_material_order_detail_info t ";
			query += " 		on t.clm_material_order_id = x.clm_material_order_id and t.clm_company_key = '" + SessionCompanyKey + "' ";
			query += "  left outer join tbl_material_info y on t.clm_material_id = y.clm_material_id and y.clm_company_key = '" + SessionCompanyKey + "' ";
			query += "  left outer join tbl_client_info z on x.clm_client_id = z.clm_client_id and z.clm_company_key = '" + SessionCompanyKey + "' ";
			query += "  where x.clm_company_key = '" + SessionCompanyKey + "' and x.clm_material_order_id = '" + material_income_id + "' ";
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
			
			while (rs.next()) {

			clm_material_order_id = rs.getString("clm_material_order_id");
			clm_client_id = rs.getString("clm_client_id");
			clm_client_name = rs.getString("clm_client_name");
			clm_material_id = rs.getString("clm_material_id");
			clm_due_date  = rs.getString("clm_due_date");
			clm_material_name = rs.getString("clm_material_name");
			clm_order_date = rs.getString("clm_order_date");
			clm_comment = rs.getString("clm_comment");
			clm_income_yn = rs.getString("clm_income_yn");
			clm_material_order_seq = rs.getString("clm_material_order_seq");

	}

			

			
%>
<script type="text/javascript" language="javascript">
	var seq_number = 0;

	jQuery(document).ready(function(){

		var material_income_id = '<%=material_income_id %>';
		// $(window).load(function() {
		// 	$("#txt_material_order_id").attr('readonly',true);
		// 	// $('html').css("overflow","hidden");
		// 	$("#background").fullBg();

		// });
		var data_array = [];

		jQuery.income_material_del = function(rowId,material_id,income_yn,material_order_id,material_order_seq) {
			let rowCount = $('#tbl_material_income_slave > tbody > tr').length;

			if(rowCount <= 1) {
				$("#confirmModal").modal("show");
				$("#modalBody").html("<p>삭제 할 수 없습니다.</p>");
				return;
			}

			$("#confirmModal").modal("show");

			$("#deleteConfirm").on("click", function() {
				$.ajax({
					url : 'DeletePackageRecipeInfo.jsp',
					data : { 
						'material_income_id' : material_order_id,
						'material_id' : material_id,
						'incomeYn' : income_yn,
						'clm_material_order_seq' : material_order_seq
					},
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

				$('#confirmModal').modal('hide');
			});
		}

	jQuery('#btn_material_income_reg').click(function(e){
		material_income_reg();
	});




	var data_array = [];

	if(material_income_id=='') {
	}
	else {
		get_grid_data();
	}
	
	var dataArray = [];
});


function material_income_reg() {	

	var data = new Array();

	if($("#txt_client_id").val() == '' || $("#txt_client_name").val() == ''){
		alert('거래처를 선택 해주시기 바랍니다.');
		return;
	}
	if($("#txt_income_delivery_date").val() == ''){
		alert('입고일을 선택 해주시기 바랍니다.');
		return;
	}

	if(seq_number == 0){

		alert('입고정보를 추가해주시기 바랍니다.');
		return;
	}

	var idx = 0;

	for(var i=0; i<seq_number; i++){

		var tmpData = new Object();

			if(typeof $('#material_id_'+i).val() != 'undefined'){
				
				idx++;

				if($('#order_count_'+i).val() == '' || $('#order_count_'+i).val() <= 0){
					alert('입고량을 입력해 주시기 바랍니다.');
					return;
				}
				if($('#material_unit_'+i).val() == 'EA'){ // 자재단위가 EA 라면
					if(!Number.isInteger($('#order_count_'+i).val()*1)){
						alert('자재단위가 EA인 자재의 입고량은 소수점을 사용할 수 없습니다.');
						return;
					}
				}
				if($('#material_due_date'+i).val() == ''){
					alert('입고 예정일을 입력해 주시기 바랍니다.');
					return;
				}
				if($('#material_order_date'+i).val() == ''){
					alert('입고 예정일을 입력해 주시기 바랍니다.');
					return;
				}

				tmpData.material_id = $('#material_id_'+i).val();
				tmpData.order_count = $('#order_count_'+i).val();
				tmpData.material_income_date = $('#material_income_date_'+i).val();

				data.push(tmpData);

		}

	}
	console.log("material_order_id : " + $('#txt_material_order_id').val());
	console.log("txt_client_id : " + $('#txt_client_id').val());
	console.log("txt_order_date : " + $('#txt_order_date').val());
	console.log("txt_due_date : " + $('#txt_due_date').val());
	console.log("ta_comment : " + $('#ta_comment').val());
	console.log("dataArr : ");
	console.log(data)

	if(confirm('입고정보를 등록 하시겠습니까?')){

		$.ajax({
			type : "POST",
			url : "material_income_update_proc.jsp",
			data : {
					'dataArr' : JSON.stringify(data),
					'material_order_id' : $('#txt_material_order_id').val(),
					'client_id' : $('#txt_client_id').val(),
					'order_date' : $('#txt_due_date').val(),
					'due_date' : $('#txt_due_date').val(),
					'comment' : $('#ta_comment').val(),

				},
			error : function() {
				console.log('자재입고 등록 실패');
			},
			success: function(args){
				alert("입고 등록완료");
				$(location).attr("href", 'material_income_list.jsp?');
			}
		});

	}

}

function get_grid_data(){

	$.ajax({
		type : "POST",
		url : "MaterialIncomeRegPopData.jsp",
		data : { 'material_income_id' : '<%=material_income_id %>',
		},
		dataType : "json",
		error : function() {
			console.log('통신 실패');
		},
		success : function(data) {
			
			data_array = [];
			console.log(data);
			
			
			for(var i=0; i<data.grid_data.length; i++) {
				var clm_material_name = data.grid_data[i].clm_material_name;
				var clm_material_id = data.grid_data[i].clm_material_id;
				var clm_material_main_type_name = data.grid_data[i].clm_material_main_type_name;
				var clm_material_sub_type_name = data.grid_data[i].clm_material_sub_type_name;
				var clm_income_date = data.grid_data[i].clm_income_date;
				var clm_order_count = data.grid_data[i].clm_order_count;
				var clm_material_code = data.grid_data[i].clm_material_code;
				var clm_material_unit_name = data.grid_data[i].clm_material_unit_name;
				var clm_income_yn = data.grid_data[i].clm_income_yn;
				var material_income_id = data.grid_data[i].material_income_id;
				var clm_material_order_seq = data.grid_data[i].clm_material_order_seq;


				var appendTr = '';
				appendTr += '<tr id="income_tr_' + seq_number + '">';
				appendTr += '<td style="border:1px solid #ccc;" text-align:center;">' + (seq_number + 1) + '</td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:right;"><input type="text" class="form-control" style="border:none; background-color:white; background-color:#FFFFFF;" id="material_name_' + seq_number + '"value="'+clm_material_name+'" readonly/></td>';
				appendTr += '<input type="hidden" id="material_id_' + seq_number + '" value=""></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:right;"><input type="text" style="text-align:center; border:none; background-color:#FFFFFF; " class="form-control" id="material_main_' + seq_number + '"  value="'+ clm_material_main_type_name +'" readonly/></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:right;"><input type="text" style="text-align:center; border:none; background-color:#FFFFFF; " class="form-control " id="material_sub_' + seq_number + '"  value="'+ clm_material_sub_type_name +'" readonly/></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:right;"><input type="text" class="form-control" style=" border:none; text-align:right; background-color:#FFFFFF;" id="use_count_' + seq_number + '" value="'+ clm_order_count +'" readonly/></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:right;"><input type="text" class="form-control" style=" border:none; text-align:center; background-color:#FFFFFF;" id="material_spec_' + seq_number + '" value="'+ clm_material_unit_name +'" readonly/></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:right;"><input type="text" class="form-control" style=" border:none; text-align:center; background-color:#FFFFFF; " id="material_income_date_' + seq_number + '" value="'+ clm_income_date +'" readonly/></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:center;"><input type="button" class="btn btn-danger btn-sm" id="buttonDelete' + seq_number + '" ' + (clm_income_yn !== "N" ? 'disabled' : '') + ' onClick="JavaScript:jQuery.income_material_del(\'' + seq_number + '\',\'' + clm_material_id + '\',\'' + clm_income_yn + '\',\'' + material_income_id + '\',\'' + clm_material_order_seq + '\');" value="삭제"  /></td>';
				appendTr += '<td style="padding:2px; border:1px solid #ccc; text-align:center;"><input type="button" ' + (clm_income_yn !== "N" ? 'disabled' : '') + '  class="btn btn-danger btn-sm"  onClick="JavaScript:jQuery.fnc_income_yn(\'' + clm_material_id + '\',\'' + clm_income_yn  + '\',\'' + material_income_id + '\',\'' + clm_material_order_seq + '\',\'' + seq_number + '\');" value="입고"  /></td>';
				appendTr += '</tr>';
				seq_number = seq_number + 1;
				$("#tbl_material_income_slave > tbody").append(appendTr);
			}
		}
	});
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
				<span>자재 주문 상세</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.jsp">Home</a></li>
				<li class="active">자재 관리</li>
				<li class="active">자재 입고 관리</li>
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
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div id="preMaterialName" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">
									입고번호
								</label>
								<input type="text" class="mat-input form-control"  id="txt_material_order_id" value="<%= clm_material_order_id %>" readonly>
							</div>
						</div>
					</div>	
					<div class="group-fields clearfix row">
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">
									거래처
								</label>
								<input type="hidden" id="txt_client_id" value="<%=clm_client_id %>" />
								<input type="text" id="txt_client_name" class="mat-input form-control" value="<%=clm_client_name%>" readonly>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									등록일
								</label>
								<input type="text" id="txt_order_date" value="<%= clm_order_date %>" class="form-control" readonly/>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									입고 예정일
								</label>
								<input type="text" id="txt_due_date" value="<%= clm_due_date %>" class="form-control" readonly/>
							</div>
						</div>
					</div>
					<div class="group-fields clearfix row" >
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="width: 100%;">
							<table id="tbl_material_income_slave" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
								<thead>
									<tr>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:30px;">No</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important;">자재명</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:120px;">대분류</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:150px;">소분류</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:100px;">입고량</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:120px;">자재 단위</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:120px;">입고 예정일</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:80px;">삭제</th>
										<th style="font-size:14px; text-align:center; font-weight:bold; border:1px solid #ccc; background-color: #eee !important; padding: 5px !important; width:80px;">입고 확인</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
					</div>	

					<%@ include file="include/modal/modal_client_code.jsp" %>
					<%@ include file="include/modal/modal_material_code.jsp" %>

					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" id="ta_comment" name="ta_comment" readonly><%= clm_comment %></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="pmd-card" style="padding-left: 5px;">
					<!-- <a href="javascript:void(0);" class="btn btn-primary next" id="btn_material_income_reg" name="btn_material_income_reg">수정</a> -->
					<button type="button" class="btn btn-primary btn-sm" id="btn_modify" name="btn_modify" <%if(!clm_income_yn.equals("N")){ %> disabled <% }%>  onclick="location.href='material_income_modify.jsp?_material_order_id_=<%= clm_material_order_id %>';">수정</button>					
					<button type="button" class="btn btn-primary btn-sm" id="delete_mate" name="delete_mate" <%if(!clm_income_yn.equals("N")){ %> disabled <% }%>>삭제</button>
					<button type="button" class="btn btn-primary btn-sm" id="btn_list" name="btn_list"  onclick="location.href='material_income_list.jsp'">뒤로</button>
				</div>
			</div> <!-- section content end -->
			</form>
		</div>
		<!-- Card Footer -->
		<div class="pmd-card-footer">
		</div>
	</div>
</div>
<div id="confirmModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
	  <div class="modal-content">
		<div class="modal-header">
		  <h5 class="modal-title" id="confirmModalLabel">삭제 확인</h5>
		  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		  </button>
		</div>
		<div class="modal-body" id="modalBody">
		  <p>삭제하시겠습니까?</p>
		</div>
		<div class="modal-footer">
			<button type="button" id="deleteConfirm" class="btn btn-primary">예</button>
		  <button type="button" class="btn btn-secondary" data-dismiss="modal">아니오</button>
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

	// 생산자 여부
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
});
</script>
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

		$.fnc_modal_client = function(obj) {
			console.log('> $.fnc_modal_client_list');
			var param_01 = $(obj).data('param_01');
			$('#ifrm_cost_code_list').attr('src', 'include/modal/modal_client_list.jsp');
			$('#form-dialog_cost_code').modal('show');
		};

		$.fnc_select_to_parent = function(seq, client_id, client_name, client_addr) {
			$('input[id=txt_client_name]').val(client_name);
			$('input[id=txt_client_id]').val(client_id);

			$('#form-dialog_cost_code').modal('hide');
			if(client_name!=''){ $('input[name=txt_client_name]').focus(); };
			if(client_id!=''){ $('input[name=txt_client_id]').focus() };
			
		};

		$.fnc_material_modal = function(obj) {
			var param_01 = $(obj).data('param_01');
			$('#ifrm_material_code_list').attr('src', 'include/modal/modal_material_list.jsp?seq='+param_01);
			$('#form-dialog_material_code').modal('show');
		};

		$.fnc_select_to_parent_material = function(seq,material_id, material_name, material_code, material_main_type, material_sub_type, material_unit) {
			$('input[id=material_name_'+seq+']').val(material_name);
			$('input[id=material_main_'+seq+']').val(material_main_type);
			$('input[id=material_sub_'+seq+']').val(material_sub_type);
			$('input[id=material_unit_'+seq+']').val(material_unit);
			$('input[id=material_code_'+seq+']').val(material_code);

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

		$.fnc_material_detail = function(clm_material_id) {
			location.href='material_info_detail.jsp?_material_id_='+ '<%= clm_material_id %>' ;
			
		}



		
		$.fnc_income_yn = function(material_id,clm_income_yn,material_order_id,clm_material_order_seq,seq_number) {

			$.ajax({
				url : 'updateMaterialIncomeYn.jsp',
				data : { 'material_income_id' : material_order_id
						, 'material_id' : material_id
						, 'clm_income_yn' : clm_income_yn
						, 'clm_order_count' : $('#use_count_'+seq_number).val()
						, 'clm_material_order_seq' : clm_material_order_seq },
				type : "POST",
				dataType : "text",
				error : function() {
				},
				success : function(data){
					alert("입고 확인");
					location.reload();
				}
			});
		}

		jQuery('#delete_mate').click(function(e) {
			e.preventDefault();

			$('#confirmModal').modal('show');

			$('#deleteConfirm').click(function() {
				$.ajax({
				type: "POST",
				url: 'material_income_delete_proc.jsp',
				data: {
					'txt_process_type': 'D',
					'material_order_id': '<%=clm_material_order_id %>'
				},
				error: function() {
					console.log('삭제 실패');
					location.reload();
				},
				success: function(data) {
					alert("자재 주문 삭제 등록완료");
					$(location).attr("href", 'material_order_list.jsp?');
				}
				});

				// 모달창 닫기
				$('#confirmModal').modal('hide');
			});
		});
	});
</script>

</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>
