<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
import="java.sql.*"
import="java.util.Date"
import="java.util.Calendar"
import="java.util.Locale"
import="java.util.GregorianCalendar"
import="java.text.SimpleDateFormat"
import="org.json.simple.JSONArray"
import="org.json.simple.JSONObject"%>
<%@include file="./PopupJava.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MES시스템</title>

<!-- DataTables css-->
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.1.0/css/responsive.bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/select/1.2.0/css/select.dataTables.min.css">
<!-- Propeller dataTables css-->

<link rel="stylesheet" type="text/css" href="../resources/css/components/data-table/css/pmd-datatable.css">
<link rel="stylesheet" type="text/css" href="../resources/css/components/datetimepicker/css/bootstrap-datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="../resources/css/components/datetimepicker/css/pmd-datetimepicker.css" />

<!-- Propeller theme css-->
<link rel="stylesheet" type="text/css" href="../resources/css/themes/css/propeller-theme.css" />

<!-- Propeller admin theme css-->
<link rel="stylesheet" type="text/css" href="../resources/css/themes/css/propeller-admin.css">

<script src="../resources/jquery-3.4.1.min.js"></script>
<script src="../resources/jquery-migrate-3.1.0.min.js"></script>
<script src="../resources/grid.locale-kr.js"></script>
<script src="../resources/jquery.jqGrid.min.js"></script>
<script src="../resources/css/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>

<link rel="stylesheet"
href="../resources/css/jquery-ui-1.12.1.custom/jquery-ui.min.css">
<link rel="stylesheet" href="../resources/ui.jqgrid.css">

<!-- Propeller textfield js -->
<script type="text/javascript" src="../resources/textfield.js"></script>

<!-- Select2 js-->
<script type="text/javascript" src="../resources/select2.full.js"></script>
<link rel="stylesheet" href="../resources/jquery-ui-i18n.js">

<link rel="stylesheet"
href="../resources/css/jquery-ui-1.12.1.custom/jquery-ui.min.css">
<link rel="stylesheet" href="../resources/ui.jqgrid.css">

<link href="../resources/summernote-lite.css" rel="stylesheet">
<script src="../resources/summernote-lite.js"></script>

<!-- Bootstrap css-->
<link rel="stylesheet" href="../resources/bootstrap.min.css">

<!--Google Icon Font-->
<link href="http://fonts.googleapis.com/icon?family=Material+Icons"
rel="stylesheet">

<!--Google Icon Font-->
<link href="../resources/select2.min.css" rel="stylesheet">

<!--Google Icon Font-->
<link href="../resources/typography.css" rel="stylesheet">

<!--Google Icon Font-->
<link href="../resources/textfield.css" rel="stylesheet">

<!--Google Icon Font-->
<link href="../resources/pmd-select2.css" rel="stylesheet">

<!-- Propeller css -->
<link href="../resources/pmt/css/propeller.min.css" rel="stylesheet">

<style>
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

@font-face {
font-family: 'NanumBarunGothicBold';
src: url('../resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot');
src: url('../resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot')
    format('embedded-opentype'),
    url('../resources/fonts/NanumBarunGothic/NanumBarunGothicBold.woff')
    format('woff');
}

.ui-jqgrid .ui-jqgrid-htable th div {
height:auto;
overflow:hidden;
padding-top:12px;
padding-bottom:12px;
position:relative;
vertical-align:text-top;
white-space:normal !important;
font-weight:bold;
font-size:130%;
}

tr.jqgrow {
height: 30px;
}

/* .ui-jqgrid .ui-jqgrid-htable td div { padding: 10px; } */
.ui-jqgrid tr.jqgrow td{
 height: auto;
 white-space: normal;
 padding: 5px;
}
</style>

<%
request.setCharacterEncoding("UTF-8");
String authority_id = (request.getParameter("authority_id")==null)?"":request.getParameter("authority_id");
String user_id = session.getAttribute("user_id").toString();
String SessionCompanyKey = (String)session.getAttribute("company_key");
String SessionMesName = (String)session.getAttribute("mes_name");
String SessionUserID = (String)session.getAttribute("user_id");
String header_color = (session.getAttribute("header_color").equals(""))?"#4285f4":(String)session.getAttribute("header_color");

System.out.println("> AuthorityInfoRegPop.authority_id : " + authority_id);
System.out.println("> AuthorityInfoRegPop.user_id : " + user_id);
System.out.println("> AuthorityInfoRegPop.SessionCompanyKey : " + SessionCompanyKey);
System.out.println("> AuthorityInfoRegPop.SessionMesName : " + SessionMesName);
System.out.println("> AuthorityInfoRegPop.SessionUserID : " + SessionUserID);

SimpleDateFormat format1 = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
Calendar time = Calendar.getInstance();

String strWhereConditions = "";

Connection conn = null;
Statement stmt = null;

String url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/"+(String)session.getAttribute("mes_name");
String usr = "postgres";
String pwd = "postgres";
Class.forName("org.postgresql.Driver");

String query = "";
ResultSet rs = null;
String temp2 = "0";

conn = DriverManager.getConnection(url, usr, pwd);

String clm_authority_name = "";
String clm_comment = "";

if(!authority_id.equals("")){

    stmt = conn.createStatement();

    query = "";
    query += " select x.clm_authority_id , x.clm_authority_name , x.clm_comment , x.clm_delete_yn , y.clm_screen_id ";
    query += "	from tbl_authority_info x ";
    query += "	    left outer join tbl_authority_detail_info y ";
    query += "	        on y.clm_authority_id = x.clm_authority_id and y.clm_company_key = '"+ SessionCompanyKey +"' ";
    query += "  where x.clm_company_key = '"+ SessionCompanyKey +"' ";
    query += "	    and x.clm_authority_id = '"+ authority_id +"' ";
    query += "	    and x.clm_delete_yn != 'Y' ";
    System.out.println("> AuthorityInfoRegPop.q.0 " + query);
    rs = stmt.executeQuery(query);

    if(rs!=null) {
        while (rs.next()) {
            clm_authority_name = rs.getString("clm_authority_name");
            clm_comment = rs.getString("clm_comment");
        }
    }
    stmt.close();

}


if(conn!=null) {
    conn.close();
}

%>

    <style>
        body {
            font-family: 'NanumSquareLight', sans-serif;
            font-weight: 700;
        }
        #div_use_yn {
            background-color:transparent;
            color:#333333;
            position:absolute;
            top:40px;
            left:1180px;
            width:100px;
        }
        #main_background {
            --border:solid 8px #1A2E75;
            --border-top:solid 35px #1A2E75;
            border:solid 8px #881C22;
            border-top:solid 35px #881C22;
            background-color:white;
            color:#333333;
            position:absolute;
            top:0px;
            left:0px
        }
        #main_logo {
            text-align: left;
            position:relative;
            top:0px;
            left:0px
        }
        #main_body {
            background-color:transparent;
            position:absolute;
            top:0px;
            left:0px;
        }
        #main_title {
            position:absolute;
            top:20px;
            left:20px;
            font-size:16;
            font-weight:bold;
        }
        #main_datetime {
            position:absolute;
            font-family: 'NanumBarunGothicBold', sans-serif;
            top:70px;
            left:20px;
            font-size:6;
            font-weight:bold;
        }
        #main_contents {
            position:absolute;
            font-family: 'NanumBarunGothicBold', sans-serif;
            top:80px;
            left:0px;
            font-size:6;
            font-weight:bold;
        }
        @font-face {
            font-family: 'NanumBarunGothicBold';
            src: url('../resources/fonts/NanumBarunGothic/NanumBarunGothicBold.eot') format('embedded-opentype'),
                 url('../resources/fonts/NanumBarunGothic/NanumBarunGothicBold.woff') format('woff'),
                 url('../resources/fonts/NanumBarunGothic/NanumBarunGothic.eot') format('embedded-opentype'),
                 url('../resources/fonts/NanumBarunGothic/NanumBarunGothic.woff') format('woff');
        }
        @font-face {
            font-family: 'NanumSquareLight';
            font-weight: 300;
            src: url('../resources/fonts/NanumFontSetup_TTF_SQUARE/NanumSquareL.ttf');
                url('../resources/fonts/NanumFontSetup_TTF_SQUARE/NanumSquareL.ttf') format('truetype');
        }
    </style>
    <style type="text/css">
        body {
            background-color: #f7f7f7;
            /* background-color: #39414A;
            color: white; */
            font-family: Helvetica, Arial, sans-serif;
            font-size: smaller;
            /* background-image: url("nav_bg.png"); */
            /* background-repeat: repeat-x; */
        }
        div#tree {
            position: absolute;
            height: 95%;
            width: 95%;
            padding: 5px;
            margin-right: 16px;
        }
        ul.fancytree-container {
            height: 100%;
            width: 100%;
            overflow: auto;
            background-color: transparent;
        }
        span.fancytree-node span.fancytree-title {
            /* color: white; */
            text-decoration: none;
        }
        /* span.fancytree-focused span.fancytree-title {
            outline-color: white;
        } */
        span.fancytree-node:hover span.fancytree-title,
        span.fancytree-active span.fancytree-title,
        span.fancytree-active.fancytree-focused span.fancytree-title,
        .fancytree-treefocus span.fancytree-title:hover,
        .fancytree-treefocus span.fancytree-active span.fancytree-title {
            color: #39414A;
        }
        span.external span.fancytree-title:after {
            content: "";
            background: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAFVBMVEVmmcwzmcyZzP8AZswAZv////////9E6giVAAAAB3RSTlP///////8AGksDRgAAADhJREFUGFcly0ESAEAEA0Ei6/9P3sEcVB8kmrwFyni0bOeyyDpy9JTLEaOhQq7Ongf5FeMhHS/4AVnsAZubxDVmAAAAAElFTkSuQmCC") 100% 50% no-repeat;
            padding-right: 13px;
        }
        /* Remove system outline for focused container */
        .ui-fancytree.fancytree-container:focus {
            outline: none;
        }
        .ui-fancytree.fancytree-container {
            border: none;
        }
        </style>
        
        
        <style>
        .nav > li.pmd-user-info > a:hover, .pmd-sidebar-left .nav > li.pmd-user-info > a:focus, .pmd-sidebar-left .nav > li.pmd-user-info > a:active, .pmd-sidebar-left .nav > li.pmd-user-info > a.active{
            background-color: #1d3b68 !important;
        }
        .pmd-sidebar .pmd-sidebar-nav .dropdown-menu{
            background-color: #1d3b68;
        }
        .pmd-sidebar-left .nav > li > a:hover, .pmd-sidebar-left .nav > li > a:focus, .pmd-sidebar-left .nav > li > a:active, .pmd-sidebar-left .nav > li > a.active{
            background-color: #1d3b68;
        }
        </style>
    <script type="text/javascript" language="javascript">
    var seq_number = 0;
    var screen_arr = [];
    var type_arr = [];
    var name_arr = [];
    var authority_id = '<%=authority_id %>';
    // $(window).resize(function() {
    //       location.reload();
    // });
    $(function(){
	// --- Initialize sample trees
	$("#tree").fancytree({
		treeId: "nav",
		quicksearch:true,
		autoActivate: false, // we use scheduleAction()
		autoCollapse: true,
		autoScroll: true,
//			autoFocus: true,
        checkbox:true,
        selectMode:3,
		clickFolderMode: 3, // expand with single click
		minExpandLevel: 2,
		tabindex: "-1", // we don't want the focus frame
		// toggleEffect: { effect: "blind", options: {direction: "vertical", scale: "box"}, duration: 2000 },
		// scrollParent: null, // use $container
        select: function(event, data){
            screen_arr = [];
            type_arr = [];
            name_arr = [];
            var selKeys = $.map(data.tree.getSelectedNodes(), function(node){

                var screen_id_val = $('#'+node.key).val();
                if(screen_id_val != undefined){
                    screen_arr.push($('#'+node.key).val())
                    type_arr.push($('#T'+node.key).val())
                    name_arr.push($('#N'+node.key).val())
                }
                return node.key;
            });
            showSelectScreen();
        },
		tooltip: function(event, data) {
			return data.node.title;
		},
		focus: function(event, data) {
			var node = data.node;
			// Auto-activate focused node after 1 second
			if(node.data.href){
				node.scheduleAction("activate", 1000);
			}
		},
		blur: function(event, data) {
			data.node.scheduleAction("cancel");
		},
		beforeActivate: function(event, data){
			var node = data.node;

			if( node.data.href && node.data.target === "_blank") {
				window.open(node.data.href, "_blank");
				return false; // don't activate
			}
		},
		activate: function(event, data){
			var node = data.node,
				orgEvent = data.originalEvent || {};

			if(node.data.href){
				window.open(node.data.href, (orgEvent.ctrlKey || orgEvent.metaKey) ? "_blank" : node.data.target);
			}
			if( node.data.target === "_blank") {
				return false;
			}
			if( window.parent &&  parent.history && parent.history.pushState ) {
				parent.history.pushState({title: node.title}, "", "#" + (node.data.href || ""));
			}
		},
		dblclick: function(event, data){
		},
		click: function(event, data){
			var node = data.node,
				orgEvent = data.originalEvent;

			if(node.isActive() && node.data.href){
				window.open(node.data.href, (orgEvent.ctrlKey || orgEvent.metaKey) ? "_blank" : node.data.target);
			}
		}
	});
	var tree = $.ui.fancytree.getTree(),
		frameHash = window.parent && window.parent.location.hash;

	if( frameHash ) {
		frameHash = frameHash.replace("#", "");
		tree.visit(function(n) {
			if( n.data.href && n.data.href === frameHash ) {
				n.setActive();
				return false;
			}
		});
	}
});

    jQuery(document).ready(function(){
        // $('html').css("overflow","hidden");  // 레이어 뜬상태에서 html 스크롤바 삭제
        // $("#background").fullBg();
        $('#main_background').css('width', $(window).width());
        $('#main_background').css('height', $(window).height());
        $('#main_body').css('width', $(window).width()-18);
        $('#main_body').css('height', $(window).height()-45);
        // $('#main_contents').css('width', $(window).width()-145);
        $('#main_contents').css('width', $(window).width()-30);
        $('#main_contents').css('height', $(window).height()-200);
        $('#main_contents').css('background-color', 'transparent');
        $('#main_contents').css('border', 'solid 0px black');
        $('.unit_no').css('width', '100%');
        // $('.unit_no').css('background-color', '#003366');
        $('.unit_no').css('padding', '10px');
        $('.unit_no').css('color', 'white');
        $('.unit_no').css('margin', '0px');
        $('.unit_no').css('font-size', '24px');
        $('.unit_no').css('font-weight', 'bold');
        $('.unit_temperature').css('width', '100%');
        // $('.unit_temperature').css('background-color', '#3399CC');
        $('.unit_temperature').css('padding', '10px');
        $('.unit_temperature').css('color', 'white');
        $('.unit_temperature').css('margin', '0px');
        $('.unit_result').css('width', '100%');
        // $('.unit_result').css('background-color', '#003366');
        $('.unit_result').css('padding', '10px');
        $('.unit_result').css('color', 'white');
        $('.unit_result').css('margin', '0px');
        $('.unit_popup_link').css('color', 'white');

        $(window).load(function() {
            // $('html').css("overflow","hidden");
            // $("#background").fullBg();
        });

        jQuery('#btn_code_reg').click(function(e){

            if($('#txt_authority_name').val() == ''){
                alert('권한명을 입력해주시기 바랍니다.');
                return;
            }
            if(screen_arr.length == 0){
                alert('화면을 선택해주시기 바랍니다.');
                return;
            }

            var data = new Array();
            for(var i=0; i<screen_arr.length; i++){

                var tmpData = new Object();

                tmpData.screen_id = screen_arr[i];
				data.push(tmpData);
            }
            
            if(confirm("권한정보를 등록하시겠습니까?")){

                $.ajax({
                    url : 'AuthorityInfoRegPopUpdate.jsp',
                    data : { 
                                'authority_id' : authority_id,
                                'authority_name' : $('#txt_authority_name').val(),
                                'comment' : $('#txt_comment').val(),
                                'screen_data' : JSON.stringify(data),
                        },
                    type : "POST",
                    dataType : "text",
                    error : function() {
                        console.log('권한정보 저장 실패');
                    },
                    success : function(data){
                        alert('재 로그인 이후 권한이 적용됩니다.');
                        opener.parent.location.reload();
                        self.close();
                    }
                });

            }
            
        });

        function get_grid_data(){
            $.ajax({
                type : "POST",
                url : "AuthorityInfoRegPopData.jsp",
                data : { 'authority_id' : authority_id},
                dataType : "json",
                error : function() {
                    console.log('통신 실패');
                },
                success : function(data) {
                    data_array = [];
                    console.log(data);

                    var beforeId = "";
                    var nowId = "";
                    for(var i=0; i<data.grid_data.length; i++) {
                        var drawType = "A";

                        var clm_screen_type = data.grid_data[i].clm_screen_type;
                        var clm_screen_name = data.grid_data[i].clm_screen_name;

                        var appendTr = "";
                        appendTr += '<tr id="baseMaterial_tr" style="font-size:12px; background-color:#FFFFFF;">';
                        appendTr += '<td style="text-align:center; width:20%;">'+ clm_screen_type +'</td>';
                        appendTr += '<td style="text-align:center;">' + clm_screen_name + '</td>';
                        appendTr += '</tr>';

                        $("#tbl_screen_table > tbody").append(appendTr);
                        
                    }
                }
            });
        }

        if(authority_id=='') {
        }
        else {
            get_grid_data();
        }

    });

    function fncUserInfo(user_id, user_name){
        $("#txt_machine_manager_id").val(user_id);
        $("#txt_machine_manager_name").val(user_name);
    }
    function showSelectScreen(){
        $('#tbl_screen_table > tbody > tr').remove();
        console.log(screen_arr)
        console.log(type_arr)
        console.log(name_arr)
        for(var i=0; i<screen_arr.length; i++){
            var appendTr = "";
            appendTr += '<tr id="baseMaterial_tr" style="font-size:12px; background-color:#FFFFFF;">';
            appendTr += '<td style="text-align:center; width:20%;">'+ type_arr[i] +'</td>';
            appendTr += '<td style="text-align:center;">' + name_arr[i] + '</td>';
            appendTr += '</tr>';
            $("#tbl_screen_table > tbody").append(appendTr);
        }

    }
    </script>
<%
%>
</head>
<body>
	<!--content area start-->
	<div id="content" class="pmd-content inner-page" style="padding:15px;">
	
		<!--tab start-->
		<div class="container-fluid full-width-container" style="background-color:transparent;" >
	
			<div>
				<!--section-title -->
				<div style="background-color: <%=header_color %>; border-radius: 8px;">
					<h2 style="color: #eeeeee; padding: 10px; font-size: 27px;">권한 정보</h2><!--section-title end -->
				</div>
				<!-- section content start-->
				<form id="validationForm" action="" method="post" onsubmit="return false;">
				<div class="pmd-card pmd-z-depth">
					<div class="pmd-card-body">
						<div class="group-fields clearfix row">
							<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
								<div id="upperId" class="form-group pmd-textfield pmd-textfield-floating-label">
									<label>권한명<font style="color:red">*</font></label>
									<input type="text" id="txt_authority_name" value="<%=clm_authority_name %>" class="form-control">
								</div>
							</div>
						</div>
                        <div class="group-fields clearfix row">
                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="form-group pmd-textfield pmd-textfield-floating-label">
                                    <label>특이사항</label>
                                    <input type="text" id="txt_comment" value="<%=clm_comment %>" class="form-control">
                                </div>
                            </div>
						</div>
                        <div class="group-fields clearfix row">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
								<div class="form-group pmd-textfield pmd-textfield-floating-label" style="text-align: left; font-size: 30px; margin-top: 30px;">
									권한 화면 정보
								</div>
							</div>
						</div>
                        <div class="group-fields clearfix row" style="overflow: auto; height: 450px;">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">

                                <div class="Aligner" style="width: 100%; height:400px; padding-top: 0px; padding-left: 0px; padding-right: 0px;">
                                    <div class="Aligner" style="width: 395px; height:100%; padding-left: 0px; padding-right: 10px; padding-top: 50px; background-color: white;">
                                        <div style="width:100%; height:100%;">
                                            <div class="form-group pmd-textfield pmd-textfield-floating-label" style="width: 100%; height: 100%; float: left; padding-right: 10px;">
                                                <div id="tree">
                                                    <ul>
                                                        <li class="folder expanded"> 화면정보
                                                        <ul>
                                                    <%
            
                                                    String plan_url = "jdbc:postgresql://itfactoryddns.iptime.org:5432/"+SessionMesName;
                                                    String plan_usr = "postgres";
                                                    String plan_pwd = "postgres";
                                                    Class.forName("org.postgresql.Driver");
            
                                                    Connection plan_conn = DriverManager.getConnection(plan_url, plan_usr, plan_pwd);
                                                    Connection plan_conn2 = DriverManager.getConnection(plan_url, plan_usr, plan_pwd);
                                                    ResultSet plan_rs = null;
                                                    ResultSet plan_rs2 = null;
                                                    Statement plan_stmt = null;
                                                    Statement plan_stmt2 = null;
                                                    PreparedStatement plan_ps = null;
                                                    PreparedStatement plan_ps2 = null;
            
                                                    plan_stmt = plan_conn.createStatement();
                            
                                                    query = "";
                                                    query += " select clm_screen_type ";
                                                    query += " from tbl_screen_info ";
                                                    query += " where clm_company_key = '"+ SessionCompanyKey +"' ";
                                                    query += " group by clm_screen_type, clm_reg_datetime ";
                                                    query += " order by clm_reg_datetime asc ";
                                                    System.out.println("+ query : " + query);
                                                    plan_rs = plan_stmt.executeQuery(query);
                                                    
                                                    String clm_screen_type = "";
                                                    int treeCnt = 1;
                                                    %>
            
                                                    <%
                            
                                                    while (plan_rs.next()) {
                                                        clm_screen_type = plan_rs.getString("clm_screen_type");
                                                    %>
                                                    <li class="folder">
                                                        <%=clm_screen_type %>
                                                    <ul>
            
                                                    <%
                                                        treeCnt++;
                                                        plan_stmt2 = plan_conn2.createStatement();
                                
                                                        String query2 = "";
                                                        query2 += " select x.clm_screen_id , x.clm_screen_name , x.clm_screen_type ";
                                                        query2 += " from tbl_screen_info x ";
                                                        query2 += " where x.clm_company_key = '"+ SessionCompanyKey +"' ";
                                                        query2 += " 	and x.clm_screen_type = '"+ clm_screen_type +"' ";
                                                        query2 += "     and x.clm_use_yn = 'Y' ";
                                                        query2 += " order by x.clm_reg_datetime desc ";
            
                                                        System.out.println("+ query2 joborder: " + query2);
                                                        plan_rs2 = plan_stmt2.executeQuery(query2);
            
                                                        String screen_id = "";
                                                        String screen_name = "";
                                                        String screen_type = "";
                                                        String asc_rownum = "";
                                                        String desc_rownum = "";
            
                                                        while (plan_rs2.next()) {
                                                            treeCnt++;
                                                            screen_id = plan_rs2.getString("clm_screen_id");
                                                            screen_name = plan_rs2.getString("clm_screen_name");
                                                            screen_type = plan_rs2.getString("clm_screen_type");
                                                            String[] idArr = screen_id.split(".jsp");
                                                            String s_id = idArr[0];
                                                            %>
                                                                <li>
                                                                    <%=screen_name %>
                                                                    <input type="hidden" id="_<%=treeCnt %>" value="<%=screen_id %>" >
                                                                    <input type="hidden" id="T_<%=treeCnt %>" value="<%=screen_type %>" >
                                                                    <input type="hidden" id="N_<%=treeCnt %>" value="<%=screen_name %>" >
                                                                </li>
                                                            <%
                                                        }
                                                        plan_stmt2.close();
                                                    %>

                                                    </ul></li>
                                                    <%
                                                    }
                            
                                                    plan_stmt.close();
                                                    plan_conn.close();
                                                    plan_conn2.close();
                                                    %>
                                                        </ul>
                                                    </li></ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Aligner" style="width:calc(100% - 295px); height: 300px; padding-left: 0px; padding-right: 0px; background-color: white;">
                                        <div style="width: 100%; height:100%; text-align:center; margin-bottom: 30px; overflow: auto; height: 350px;">
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                                <table id="tbl_screen_table" class="table pmd-table table-hover table-striped display responsive nowrap" cellspacing="0" width="100%">
                                                    <thead>
                                                        <tr>
                                                            <th>화면구분</th>
                                                            <th style="width:80%;">화면명</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>

							</div>
						</div>
					</div>
					<div class="pmd-card-actions" style="text-align:right;">
                        <a href="javascript:void(0);" id="btn_code_reg" class="btn btn-primary next">등록</a>
					</div>
				</div> <!-- section content end -->
				</form>
			</div>
				<!-- section content end -->
			</div>
	
		</div><!-- tab end -->
	
	</div><!-- content area end -->
	<!-- Scripts Starts -->
	<script src="../resources/css/assets/js/jquery-1.12.2.min.js"></script>
	<script src="../resources/css/assets/js/bootstrap.min.js"></script>
	<script src="../resources/css/assets/js/propeller.min.js"></script>

    <script src="../left_menu_db_sample/src/jquery-ui-dependencies/jquery.fancytree.ui-deps.js"></script>
    <link href="../left_menu_db_sample/src/skin-win8/ui.fancytree.css" rel="stylesheet">
    <script src="../left_menu_db_sample/src/jquery.fancytree.js"></script>
    <script src="sample.js"></script>
	
	<script type="text/javascript" language="javascript" src="../resources/css/components/custom-scrollbar/js/jquery.mCustomScrollbar.js"></script>
	<!-- Javascript for Datepicker -->
	<script type="text/javascript" language="javascript" src="../resources/css/components/datetimepicker/js/moment-with-locales.js"></script>
	<script type="text/javascript" language="javascript" src="../resources/css/components/datetimepicker/js/bootstrap-datetimepicker.js"></script>
	
	<!-- Datatable js -->
	<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
	
	<!-- Datatable Bootstrap -->
	<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>
	
	<!-- Datatable responsive js-->
	<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/responsive/2.1.0/js/dataTables.responsive.min.js"></script>
	
	<!-- Datatable select js-->
	<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js"></script>
	
	<script>
		//Propeller  Customised Javascript code
		$(document).ready(function() {
			$("div.data-table-inverse").html('<h2 class="pmd-card-title-text">Inverse Table</h2>');
			$(".custom-select-action").html('<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">delete</i></button><button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">more_vert</i></button>');
		
			// Linked date and time picker
			// start date date and time picker
			$('#txt_income_delivery_date').datetimepicker({
				format: 'YYYY-MM-DD'
			});
		
		} );
		</script>
	
	</body>
	</html>
