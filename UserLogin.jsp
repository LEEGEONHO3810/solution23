<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*" import="java.util.Date"
	import="java.text.SimpleDateFormat" import="org.json.simple.JSONArray"
	import="org.json.simple.JSONObject"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login | 에코비즈텍 - Admin Dashboard</title>
<link rel="shortcut icon" type="image/x-icon" href="./console/themes/images/favicon.ico">
<script src="./console/resources/jquery-3.4.1.min.js"></script>
<script src="./console/resources/jquery-migrate-3.1.0.min.js"></script>
<script src="./console/resources/grid.locale-kr.js"></script>
<script src="./console/resources/jquery.jqGrid.min.js"></script>
<script src="./console/resources/css/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" href="./console/resources/css/jquery-ui-1.12.1.custom/jquery-ui.min.css">
<link rel="stylesheet" href="./console/resources/ui.jqgrid.css">
<!-- Propeller textfield js -->
<script type="text/javascript" src="./console/resources/textfield.js"></script>
<!-- Select2 js-->
<script type="text/javascript" src="./console/resources/select2.full.js"></script>
<link rel="stylesheet" href="./console/resources/jquery-ui-i18n.js">
<link rel="stylesheet" href="./console/resources/css/jquery-ui-1.12.1.custom/jquery-ui.min.css">
<link rel="stylesheet" href="./console/resources/ui.jqgrid.css">
<link href="./console/resources/summernote-lite.css" rel="stylesheet">
<script src="./console/resources/summernote-lite.js"></script>
<!-- Bootstrap css-->
<link rel="stylesheet" href="./console/resources/bootstrap.min.css">
<!--Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!--Google Icon Font-->
<link href="./console/resources/select2.min.css" rel="stylesheet">
<!--Google Icon Font-->
<link href="./console/resources/typography.css" rel="stylesheet">
<!--Google Icon Font-->
<link href="./console/resources/textfield.css" rel="stylesheet">
<!--Google Icon Font-->
<link href="./console/resources/pmd-select2.css" rel="stylesheet">
<!-- Propeller css -->
<link href="./console/resources/pmt/css/propeller.min.css" rel="stylesheet">
<style>
body {
	font-family: 'NanumSquare', sans-serif;
	-- font-weight: 700;
	-- background-image:url("./img/login_background.png");
	background-repeat:no-repeat;
	background-position:right bottom;
	background-attachment:fixed;
	background-color:white;
}
textarea {
	resize: none;
}

/* IE9 이하를 위한 css */
.placeholder {
	color: #eeeeee;
}

/* IE10 이상을 위한 css */
input::placeholder {
	color: #eeeeee;
	opacity: 1; /* 파이어폭스에서 뿌옇게 나오는 현상을 방지하기 위한 css */
}

input::-webkit-input-placeholder {
	color: #eeeeee;
}
/* IE */
input:-ms-input-placeholder {
	color: #eeeeee;
}
/* Firefox */
input:-mos-input-placeholder {
	color: #eeeeee;
}

.container {
	height: 200px;
	overflow: hidden;
}

.vertical-center {
	margin: 0;
	top: 50%;
	-ms-transform: translateY(-50%);
	transform: translateY(-50%);
}

.Aligner {
	display: flex;
	align-items: center;
	justify-content: center;
}

.Aligner-item {
	max-width: 50%;
}

.Aligner-item--top {
	align-self: flex-start;
}

.Aligner-item--bottom {
	align-self: flex-end;
}

.out {
 width: 100%;
 height: 
 text-align: center;
 border: 1px solid black;
 padding: 20px;
 margin: 15px;
 }
 
.in {
 display: inline-block;
 width: 50%;
 border: 1px solid red;
 height: 100px;
 }
 
 .div_box {
 position: absolute;
 width: 600px;
 height: 400px;
 background: #fff;
 top: 50%;
 left: 50%;
 margin: -200px 0 0 -300px;
 border: 1px solid #eeeeee;
 }
 
 .div_copyright {
 position: absolute;
 width: 600px;
 height: 50px;
 top: 50%;
 left: 50%;
 margin: 200px 0 0 -300px;
 }
 
 .div_info {
 position: absolute;
 width: 400px;
 height: 50px;
 top: 50%;
 left: 50%;
 margin: -30px 0 0 -300px;
 }

@font-face {
	font-family: 'NanumBarunGothicBold';
	src: url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot') format('embedded-opentype'), 
	     url('resources/fonts/NanumBarunGothic/NanumBarunGothicBold.woff') format('woff'), 
	     url('resources/fonts/NanumBarunGothic/NanumBarunGothic.eot') format('embedded-opentype'), 
	     url('resources/fonts/NanumBarunGothic/NanumBarunGothic.woff') format('woff');
}
@font-face {
	font-family: 'NanumSquareLight';
	font-weight: 300;
	src: url('resources/fonts/NanumFontSetup_TTF_SQUARE/NanumSquareL.ttf');
		url('resources/fonts/NanumFontSetup_TTF_SQUARE/NanumSquareL.ttf') format('truetype');
}
</style>
<style>
	@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
	@import url(http://fonts.googleapis.com/earlyaccess/nanumgothiccoding.css);
	@import url(http://fonts.googleapis.com/earlyaccess/nanummyeongjo.css);
	@import url(http://fonts.googleapis.com/earlyaccess/nanumbrushscript.css);
	@import url(http://fonts.googleapis.com/earlyaccess/nanumpenscript.css);
	@import url(http://cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
</style>
<!-- Google icon -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- Bootstrap css -->
<link rel="stylesheet" type="text/css" href="./console/resources/css/assets/css/bootstrap.min.css">

<!-- Propeller css -->
<link rel="stylesheet" type="text/css" href="./console/resources/css/assets/css/propeller.min.css">

<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="./console/resources/css/themes/css/propeller-theme.css" />

<!-- Propeller admin theme css-->
<link rel="stylesheet" type="text/css" href="./console/resources/css/themes/css/propeller-admin.css">
<%
	if(session.getAttribute("user_home") == null || session.getAttribute("mes_name") == null){
		session.invalidate();
	} else {
		String TmpHome = "index.jsp";
		String TmpMES_NAME = session.getAttribute("mes_name").toString();
		
		if(!TmpMES_NAME.equals("CHEONGJU_SOLUTION_2023")){

			session.invalidate();

		} else {

%>		
		<script type="text/javascript" language="javascript">
			window.location = './console/'+'<%=TmpHome%>';
		</script>
<%

		}

	}
%>
<script type="text/javascript" language="javascript">


	jQuery(document).ready(function(){
		$("#txt_id").focus();

		jQuery('#btn_submit').click(function(){
			jQuery.get_login_info();
		})
		
		jQuery.get_login_info = function() {
			var id = jQuery('input[id=txt_id]').val();
			var pw = jQuery('input[id=txt_pw]').val();
			var company_key = '0001'; // 에코비즈텍
			jQuery.ajax({
	            type : "GET",
	            url : "UserInfoProc.jsp?id=" + id + "&pw=" + pw + "&company_key=" + company_key,
	            dataType : "json",
	            error : function(){
	                alert('사용자 정보 조회에 실패했습니다!!');
	            },
	            success : function(data){
	            	report_item_info_data = data;

	       		   jQuery.each(report_item_info_data, function(key, value){
						console.log(key);
						console.log(value.length);
						
						if(key=='user_info') {
							if(value.length==1) {
								$(location).attr('href', 'console/index.jsp');
							}
							else {
				                alert('사용자 정보 조회에 실패했습니다!!');
							}
						}
	       		   });
	            }
	        });
		}
	});
	
	function enterkey() {
        if (window.event.keyCode == 13) {
			jQuery.get_login_info();
        }
	}

	var onlyNumber = function() {
		if ((event.keyCode < 48) || (event.keyCode > 57))
			event.returnValue = false;
	}
</script>
<script type="text/javascript"
	src="http://propeller.in/components/select2/js/pmd-select2.js"></script>
<!-- Scripts Starts -->
<script src="./console/resources/css/assets/js/bootstrap.min.js"></script>
<script src="./console/resources/css/assets/js/propeller.min.js"></script>
</head>
<body>
	
	<div class="logincard" style="max-width: 500px;">
		<div class="pmd-card card-default pmd-z-depth" style="width:100%;">
		  <div class="login-card">
			  <form>
				  <!--
				  <div class="pmd-card-title card-header-border text-center">
					  <div class="loginlogo">
						  <a href="javascript:void(0);">
							<img width="276px" height="342px" src="./console/resources/img/login_logo.png" alt="Logo">
						</a>
					  </div>
				  </div>
				  -->
				  <div class="pmd-card-title card-header-border text-center">
					<h1 style="font-weight:bold;line-height:1.5;">에코비즈텍<br/>MES 시스템</h1>
				  </div>
				  <div class="pmd-card-body">
					  <div class="alert alert-success" role="alert"> Oh snap! Change a few things up and try submitting again. </div>
					  <div class="form-group pmd-textfield pmd-textfield-floating-label">
						  <label for="inputError1" class="control-label pmd-input-group-label">ID</label>
						  <div class="input-group">
							  <div class="input-group-addon"><i class="material-icons md-dark pmd-sm">perm_identity</i></div>
							  <input type="text" class="form-control" id="txt_id" value="admin">
							  <input type="hidden" id="txt_company_key" value="">
						  </div>
					  </div>
					  
					  <div class="form-group pmd-textfield pmd-textfield-floating-label">
						  <label for="inputError1" class="control-label pmd-input-group-label">Password</label>
						  <div class="input-group">
							  <div class="input-group-addon"><i class="material-icons md-dark pmd-sm">lock_outline</i></div>
							  <input type="password" class="form-control" id="txt_pw" onkeyup="enterkey();">
						  </div>
					  </div>
				  </div>
				  <div class="pmd-card-footer card-footer-no-border card-footer-p16 text-center">
					  <div class="form-group clearfix"></div>
					  <a href="#" type="button" id="btn_submit" class="btn pmd-ripple-effect btn-primary btn-block">로그인</a>
					  <p class="redirection-link">COPYRIGHT ITFACTORY CO.,LTD. ALL RIGHTS RESERVED.</p>
					  
				  </div>
				  
			  </form>
		  </div>
	  </div>
  </div>

<script src="./console/assets/js/jquery-1.12.2.min.js"></script>
<script src="./console/assets/js/bootstrap.min.js"></script>
<script src="./console/assets/js/propeller.min.js"></script>
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
	});
</script>
<!-- login page sections show hide -->
<script type="text/javascript">
	$(document).ready(function(){
	 $('.app-list-icon li a').addClass("active");
		$(".login-for").click(function(){
			$('.login-card').hide()
			$('.forgot-password-card').show();
		});
		$(".signin").click(function(){
			$('.login-card').show()
			$('.forgot-password-card').hide();
		});
	});
</script>
<script type="text/javascript">
$(document).ready(function(){
		$(".login-register").click(function(){
			$('.login-card').hide()
			$('.forgot-password-card').hide();
			$('.register-card').show();
		});
		
		$(".register-login").click(function(){
			$('.register-card').hide()
			$('.forgot-password-card').hide();
			$('.login-card').show();
		});
		$(".forgot-password").click(function(){
			$('.login-card').hide()
			$('.register-card').hide()
			$('.forgot-password-card').show();
		});	
});
</script> 
</body>
</html>