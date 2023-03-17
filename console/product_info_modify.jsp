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
<%
String product_id = (request.getParameter("_product_id_")==null)?"":request.getParameter("_product_id_");

		String clm_template_id            = "";
		// String clm_template_name          = "";
		String clm_product_id             = "";

		String clm_model_name           = "";
		String clm_revision_id            = "";
		String clm_revision_id_prod       = "";
		String clm_update_datetime_format = "";
		String query  = "";
		String clm_max_count = "";


		String clm_product_name           	= "";
		String clm_company_key				= "";
		String clm_product_code				= "";
		String clm_product_code_name		= "";
		String clm_product_main_type		= "";
		String clm_product_main_type_name	= "";
		String clm_product_sub_type			= "";
		String clm_product_sub_type_name	= "";
		String clm_product_spec				= "";
		String clm_product_spec_name		= "";
		String clm_product_safety_stock		= "";
		String clm_delete_yn				= "";
		String clm_comment			 		= "";
		String clm_reg_user					= "";
		String clm_reg_datetime				= "";
		String clm_update_user 				= "";
		String clm_update_datetime			= "";
try {
			stmt = conn.createStatement();
			String strCondition = "";
			strCondition = "";
			
			query = " select x.clm_product_id,z2.clm_code_sub_id,z1.clm_code_sub_name, x.clm_company_key, x.clm_product_code, x.clm_product_name, coalesce(x.clm_product_main_type, '') clm_product_main_type ,coalesce(z1.clm_code_sub_name,'') as clm_product_main_type_name, x.clm_comment, x.clm_product_safety_stock,x.clm_delete_yn,x.clm_reg_user,x.clm_reg_datetime,x.clm_update_user,x.clm_update_datetime ";
			query += " , coalesce(x.clm_product_sub_type, '') clm_product_sub_type, coalesce(z2.clm_code_sub_name,'') as clm_product_sub_type_name , coalesce(x.clm_product_spec, '') clm_product_spec, coalesce(z3.clm_code_sub_name,'') as clm_product_spec_name ,coalesce(z4.clm_code_sub_name,'') as clm_product_code_name ";
			query += " from tbl_product_info x ";
			query += " left outer join tbl_code_sub_info z1 on x.clm_company_key = z1.clm_company_key and x.clm_product_main_type = z1.clm_code_sub_id and z1.clm_code_id = '0005' ";
			query += " left outer join tbl_code_sub_info z2 on x.clm_company_key = z2.clm_company_key and x.clm_product_sub_type = z2.clm_code_sub_id and z2.clm_code_id = '0006' ";
			query += " left outer join tbl_code_sub_info z3 on x.clm_company_key = z3.clm_company_key and x.clm_product_spec = z3.clm_code_sub_id and z3.clm_code_id = '0007' ";
			query += " left outer join tbl_code_sub_info z4 on x.clm_company_key = z4.clm_company_key and x.clm_product_code = z4.clm_code_sub_id and z4.clm_code_id = '0008' ";
			query += " where x.clm_company_key = '" + SessionCompanyKey + "' and x.clm_product_id = '" + product_id +"' ";
			query += " order by x.clm_product_id ";
			System.out.println("> productInfoRegPop.q.0 " + query);
			rs = stmt.executeQuery(query);




				String reqDateStr = "";
				java.util.Date curDate = null;
				SimpleDateFormat dateFormat = null;
				java.util.Date reqDate = null;
				long reqDateTime = 0;
				long curDateTime = 0;
				long minute = 0;

			int iRowCnt = 0;
			while (rs.next()) {
				iRowCnt++;
				String duration_minute		 = "";
			clm_product_id					 = rs.getString("clm_product_id");
			clm_product_name				 = rs.getString("clm_product_name");
			clm_company_key					 = rs.getString("clm_company_key");
			clm_product_code				 = rs.getString("clm_product_code");
			clm_product_code_name			 = rs.getString("clm_product_code_name");
			clm_product_main_type			 = rs.getString("clm_product_main_type");
			clm_product_main_type_name		 = rs.getString("clm_product_main_type_name");
			clm_product_sub_type			 = rs.getString("clm_product_sub_type");
			clm_product_sub_type_name		 = rs.getString("clm_product_sub_type_name");
			clm_product_spec				 = rs.getString("clm_product_spec");
			clm_product_spec_name			 = rs.getString("clm_product_spec_name");
			clm_product_safety_stock		 = rs.getString("clm_product_safety_stock");
			clm_delete_yn					 = rs.getString("clm_delete_yn");
			clm_comment			 			 = rs.getString("clm_comment");
			clm_reg_user					  	 = rs.getString("clm_reg_user");
			clm_reg_datetime					 = rs.getString("clm_reg_datetime");
			clm_update_user 					 = rs.getString("clm_update_user");
			clm_update_datetime				 = rs.getString("clm_update_datetime");
			}

			

			
%>
<%@ include file="include/_js_00.jsp" %>
</head>

<%@ include file="include/menu_info.jsp" %>
<%@ include file="include/request_info.jsp" %>
<<script type="text/javascript" language="javascript">
	var seq_number = 0;
	
$(window).load(function() {

var product_id = '<%=product_id %>';
jQuery('#btn_product_reg').click(function(e){
		var qc_value = '';
		
		$.ajax({
			url : 'product_stock_save_proc.jsp',
			data : { 
						'product_id' : product_id,
						'product_name' : $('#txt_product_name').val(),
						'product_main_id' : $('#txt_product_main_id option:selected').val(),
						'product_sub_id' : $('#txt_product_sub_id option:selected').val(),
						'product_spec' : $('#txt_product_spec option:selected').val(),
						'product_safety_stock' : $('#txt_clm_product_safety_stock').val(),
						'product_comment' : $('#ta_comment').val(),
						'product_code' : $('#txt_product_code_name').val(),
				   },
			type : "POST",
			dataType : "text",
			error : function() {
				console.log('자재정보 저장 실패');
			},
			success : function(data){
				alert("성공 / 나중에 페이지 이동");
				// location.href
				// self.close();
			}
		});
	});

});
	// $(window).resize(function() {
	// 	  location.reload();
	// });
	

	// function changeGubun(){
	// 	if($('#sb_product_gubun option:selected').val() == "0002"){ //자재구분이 원액이라면
	// 		// 비중 입력란 display
	// 		$('#gravityDiv').css('display','block');
	// 	} else {
	// 		$('#gravityDiv').css('display','none');
	// 		$('#txt_product_specific_gravity').val(0);
	// 	}

	// 	if($('#sb_product_gubun option:selected').val() == "0001"){ //자재구분이 원료 라면
	// 		$('#iseq_1').css('display','block');
	// 		$('#iseq_2').css('display','block');
	// 		$('#iseq_3').css('display','block');
	// 		$('#iseq_4').css('display','none');
	// 		$('#iseq_5').css('display','none');
	// 		$('#iseq_6').css('display','none');
	// 		$('#iseq_7').css('display','none');
	// 	} else if($('#sb_product_gubun option:selected').val() == "0002"){ //자재구분이 원액이라면
	// 		$('#iseq_1').css('display','none');
	// 		$('#iseq_2').css('display','none');
	// 		$('#iseq_3').css('display','none');
	// 		$('#iseq_4').css('display','block');
	// 		$('#iseq_5').css('display','block');
	// 		$('#iseq_6').css('display','none');
	// 		$('#iseq_7').css('display','none');

	// 	} else if($('#sb_product_gubun option:selected').val() == "0003"){ //자재구분이 부자재 라면
	// 		$('#iseq_1').css('display','none');
	// 		$('#iseq_2').css('display','none');
	// 		$('#iseq_3').css('display','none');
	// 		$('#iseq_4').css('display','none');
	// 		$('#iseq_5').css('display','none');
	// 		$('#iseq_6').css('display','block');
	// 		$('#iseq_7').css('display','block');

	// 	}

	// 	$("#sb_product_type option:eq(0)").prop("selected", true);
	// }


</script>
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
				
			</div>
			<!-- Title -->
			<h1 class="section-title" id="services">
				<span>자재 정보 등록</span>
			</h1><!-- End Title -->
			<!--breadcrum start-->
			<ol class="breadcrumb text-left">
				<li><a href="index.jsp">Home</a></li>
				<li class="active">기초 정보 관리</li>
				<li class="active">코드 정보 등록</li>
			</ol><!--breadcrum end-->
		</div>

		<div class="table-responsive pmd-card pmd-z-depth">
			<!--section-title -- >
			<h2>Basic Form</h2>< !--section-title end -->
			<!-- section content start-->
			<form id="validationForm" action="" method="post" onsubmit="return false;">
				<div class="pmd-card pmd-z-depth">
				<input type="hidden" id="txt_process_type" name="txt_process_type" class="form-control" value="S">
				<input type="hidden" id="txt_code_type" name="txt_code_type" class="form-control" value="<%=_code_type_ %>">
				<div class="pmd-card-body">
					<div class="group-fields clearfix row">
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div id="preproductName" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">
									제품명<span style="font-weight:bold; color:red;">*</span>
								</label>
							
							<input type="text" class="mat-input form-control" id="txt_product_name" name="txt_product_name" value="<%= clm_product_name %>">
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div id="preCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
									제품 대분류<span style="font-weight:bold; color:red;">*</span>
								</label>
								<select id="txt_product_main_id" name="txt_product_main_id" class="select-simple form-control pmd-select2" style="background-color: #ffffff; width:100%; padding:5px;">
									<option <% if(clm_product_main_type.equals("")){ %> selected <% } %>>대분류 선택</option>
									<%
									try{
										stmt = conn.createStatement();
										query = " select clm_code_sub_id, clm_code_sub_name from tbl_code_sub_info where clm_company_key = '" + SessionCompanyKey+"' and clm_code_id = '0005' ";
										rs = stmt.executeQuery(query);
										while (rs.next()) {
										String  clm_code_sub_id = rs.getString("clm_code_sub_id");
										String	clm_code_sub_name = rs.getString("clm_code_sub_name");
									%>
										<option value="<%=clm_code_sub_id%>" <% if(clm_product_main_type.equals(clm_code_sub_id)){ %> selected <% } %>><%=clm_code_sub_name%></option>
									<%
										}
										stmt.close();
									} catch (Exception e) {
										stmt.close();
									}
									%>
								</select>
								
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div id="preCode" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="regular1" class="control-label">
									<i class="material-icons md-dark pmd-sm" style="font-size:12px;">library_books</i>
									제품 소분류<span style="font-weight:bold; color:red;">*</span>
								</label>
								<select id="txt_product_sub_id" name="txt_product_sub_id"  class="select-simple form-control pmd-select2" style="background-color: #ffffff; width:100%; padding:5px;">
									<option  <% if(clm_product_sub_type.equals("")){ %> selected <% } %>>소분류 선택</option>
									<%
									try{
										stmt = conn.createStatement();
										query = " select clm_code_sub_id, clm_code_sub_name from tbl_code_sub_info where clm_company_key = '" + SessionCompanyKey+"' and clm_code_id = '0006' ";
										rs = stmt.executeQuery(query);
										while (rs.next()) {
										String  clm_code_sub_id = rs.getString("clm_code_sub_id");
										String	clm_code_sub_name = rs.getString("clm_code_sub_name");
									%>
										<option value="<%=clm_code_sub_id%>" <% if(clm_product_sub_type.equals(clm_code_sub_id)){ %> selected <% } %>><%=clm_code_sub_name%></option>
									<%
										}
										stmt.close();
									} catch (Exception e) {
										stmt.close();
									}
									%>
								</select>
							</div>
						</div>
						
					</div>	
					<div class="group-fields clearfix row">
						
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div id="preproductName" class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">
									자재 코드<span style="font-weight:bold; color:red;">*</span>
								</label>
								<select id="txt_product_code_name" name="txt_product_code_name" class="select-simple form-control pmd-select2" style="background-color: #ffffff; width:100%; padding:5px;">
									<option <% if(clm_product_code.equals("")){ %> selected <% } %>>제품 코드 선택</option>
									<%
									try{
										stmt = conn.createStatement();
										query = " select clm_code_sub_id, clm_code_sub_name from tbl_code_sub_info where clm_company_key = '" + SessionCompanyKey+"' and clm_code_id = '0008' ";
										rs = stmt.executeQuery(query);
										while (rs.next()) {
										String	clm_code_sub_id = rs.getString("clm_code_sub_id");
										String	clm_code_sub_name = rs.getString("clm_code_sub_name");
									%>
										<option value="<%=clm_code_sub_id%>" <% if(clm_product_code.equals(clm_code_sub_id)){ %> selected <% } %>><%=clm_code_sub_name%></option>
									<%
										}
										stmt.close();
									} catch (Exception e) {
										stmt.close();
									}
									%>
								</select>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label for="first-name">안전재고
									<span style="font-weight:bold; color:red;">*</span>
								</label>
								<input type="number" class="mat-input form-control" id="txt_clm_product_safety_stock" name="txt_clm_product_safety_stock" value="<%= clm_product_safety_stock %>">
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
								<div class="form-group pmd-textfield pmd-textfield-floating-label">
									<label for="regular1" class="control-label">
										제품 규격<font style="color:red">*</font>
									</label>
									<select id="txt_product_spec" name="txt_product_spec" class="select-simple form-control pmd-select2" style="background-color: #ffffff; width:100%; padding:5px;">
										<option value="" <% if(clm_product_spec.equals("")){ %> selected <% } %>>제품 규격 선택</option>
										<%
										try{
											stmt = conn.createStatement();
											query = " select clm_code_sub_id, clm_code_sub_name from tbl_code_sub_info where clm_company_key = '" + SessionCompanyKey + "' and clm_code_id = '0007' ";
											rs = stmt.executeQuery(query);
											while (rs.next()) {
											String clm_code_sub_id = rs.getString("clm_code_sub_id");
											String clm_code_sub_name = rs.getString("clm_code_sub_name");
										%>
											<option value="<%=clm_code_sub_id%>" <% if(clm_product_spec.equals(clm_code_sub_id)){ %> selected <% } %>><%=clm_code_sub_name%></option>
										<%
											}
											stmt.close();
											conn.close();
										} catch (Exception e) {
											stmt.close();
											conn.close();
										}
										%>
									</select>
								</div>
							</div>
					</div>
					<div class="group-fields clearfix row">
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
							<div class="form-group pmd-textfield pmd-textfield-floating-label">
								<label class="control-label">특이사항</label>
								<textarea required class="form-control" id="ta_comment" name="ta_comment" <% if(_code_type_.equals("U")){ %>readOnly style="background-color:#eee;"<% } %>><%= clm_comment %></textarea>
							</div>
						</div>
					</div>
					
				</div>
				<div class="pmd-card-actions">
					
					<a href="javascript:void(0);" id="btn_product_reg" class="btn btn-primary next">저장</a>
					
					<a href="product_stock_list.jsp" class="btn btn-primary next" id="btn_list" name="btn_list">목록</a>
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
			// }
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
			tags += '	<td style="padding:5px; border:1px solid #ccc; width:5%; text-align:center; border-left:1px solid transparent;"><button class="btn btn-primary next" type="button" style="font-size:8px;" data-param_01="' +  seq + '" data-param_02="0001" data-toggle="modal" id="btn_cost_code_list" onClick="JavaScript:$.fnc_modal_sub_cost_code(this);">선 택</button></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc; text-align:center;"><input type="text" style="width:100%; padding:5px; text-align:left; background-color:#eee;" value="" id="txt_cost_code_sub_name" name="txt_cost_code_sub_name" readOnly></td>';
			tags += '	<td style="padding:5px; border:1px solid #ccc;"><input type="text" style="width:100%; padding:5px; text-align:right; background-color:#eee; background-color:#eee;" value="" id="txt_cost_comment" name="txt_cost_comment" readOnly></td>';
			tags += '</tr>';

			console.log(code_id);
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
		}


		

		$.fnc_only_number_unit_price = function(type, obj, seq) {
			var income_total = 0;
			var cost_total = 0;

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
						total += Number(cost_array.eq(i).val().replace(/,/gi, ''));
					}

					cost_total = total;

					$('input[name=txt_cost_total_price]').val(total.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'));
				}
		
		}

		


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
				int_number = $.fnc_only_number_with_value($.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[0]);
				dbl_number = $.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[1];
				total_string = origin_number + ' ' + int_number + '.' + dbl_number;
				console.log('> ' + total_string);
				$(obj).attr('placeholder', total_string);
			}
		}

		$.volume_calc_py= function(obj, target) {
			var origin_number = 0;
			var int_number = 0;
			var dbl_number = 0;
			var total_string = '';
			if ($(obj).val() != null && $(obj).val() != '') {
				origin_number = Number($(obj).val().replace(/[^0-9]/g, ''));
				int_number = $.fnc_only_number_with_value($.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[0]);
				dbl_number = $.py_calculator_with_value(2, origin_number).toFixed(2).split('.')[1];
				total_string = int_number + '.' + dbl_number;
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

		// $.fnc_only_number_with_comma($('input[name=txt_code_price]'));

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

</body>
</html>
<%@ include file="include/conn_close_info.jsp" %>