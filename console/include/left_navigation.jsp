<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>

<div class="pmd-sidebar-overlay"></div>

<script>
	function test() {
		event.stopImmediatePropagation();
		location.href = "system_info.jsp";
		return false;
	}
</script>
<!-- Left sidebar -->
<aside id="basicSidebar" class="pmd-sidebar  sidebar-default pmd-sidebar-slide-push pmd-sidebar-left pmd-sidebar-open bg-fill-darkblue sidebar-with-icons" role="navigation">
	<ul class="nav pmd-sidebar-nav">
		<!-- User info -->
		<li class="dropdown pmd-dropdown pmd-user-info visible-xs visible-md visible-sm visible-lg">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" aria-expandedhref="javascript:void(0);">
				<div class="media-left">
					<span class="avatar-list-img40x40">
						<%
							String main_img_path = "img/user/";
							String main_user_img = "";
							System.out.println("> main_user_img " + user_img);
							main_user_img = main_img_path + ((!user_img.equals(""))?user_img:"user_logo.png");
							System.out.println("> main_user_img " + main_user_img);
						%>
						<img alt="20x20" data-src="holder.js/20x20" class="img-responsive" src="<%=main_user_img %>" data-holder-rendered="true" onclick="test();">
					</span>
				</div>
				<div class="media-body media-middle">시스템 관리자</div>
				<div class="media-right media-middle"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<li><a href="../UserLogout.jsp">Logout</a></li>
			</ul>
		</li><!-- End user info -->
		<li>
			<a class="pmd-ripple-effect" href="index.jsp">
				<i class="material-icons media-left pmd-sm">dashboard</i>
				<span class="media-body">대시보드</span>
			</a>
		</li>
		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">자재관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					boolean authority_yn = authorityScreen.contains("material_order_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="material_order_list.jsp">자재 주문 목록</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("material_income_list.jsp");
					if(authority_yn) { 
				%>
				<li><a href="material_income_list.jsp">자재 입고 관리</a></li>
				<%
					}
				//	authority_yn = authorityScreen.contains("material_current_state_list.jsp");
				//	if(authority_yn) { 
				%>
					<!-- <li><a href="material_current_state_list.jsp">자재 현황 정보</a></li> -->
				<%
					//}
					authority_yn = authorityScreen.contains("material_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="material_info_list.jsp">자재 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("material_stock_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="material_stock_list.jsp">자재 재고 조회</a></li>
				<%
					}
				%>
			</ul>
		</li>

		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">생산관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("joborder_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="joborder_info_list.jsp">작업지시서 관리</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("joborder_progress_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="joborder_progress_list.jsp">작업지시서 진행현황</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("product_stock_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="product_stock_list.jsp">제품 재고 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("dashboard.jsp");
					if(authority_yn) { 
				%>
					<li><a href="dashboard.jsp">대시보드 관리</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("machine_work_history_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="machine_work_history_list.jsp">설비별 작업이력</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("product_qc_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="product_qc_info_list.jsp">제품 QC 정보</a></li>
				<%
					}
				%>
			</ul>
		</li>

		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">품질관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("income_material_quality_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="income_material_quality_list.jsp">입고 자재 품질 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("release_product_quality_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="release_product_quality_list.jsp">출고 제품 품질 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("product_complain_bycustomer_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="product_complain_bycustomer_list.jsp">고객별 제품 품질 불만 이력</a></li>
				<%
					}
				%>
			</ul>
		</li>

		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">출하관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("customer_order_release_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="customer_order_release_list.jsp">고객 주문 출하 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("product_stock_state_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="product_stock_state_list.jsp">제품 재고 현황 조회</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("release_product_bymachine_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="release_product_bymachine_list.jsp">라인별 출하 제품 관리</a></li>
				<%
					}
				%>
			</ul>
		</li>

		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">영업관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("customer_order_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="customer_order_list.jsp">고객 주문 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("material_order_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="material_order_info_list.jsp">자재 주문 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("order_progress_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="order_progress_info_list.jsp">주문 내역 진행 모니터링</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("material_order_income_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="material_order_income_info_list.jsp">자재 주문 입고 조회</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("mail_connection_info.jsp");
					if(authority_yn) { 
				%>
					<li><a href="mail_connection_info.jsp">주문 정보 메일 연동</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("mail_file_connection_info.jsp");
					if(authority_yn) { 
				%>
					<li><a href="mail_file_connection_info.jsp">주문 정보 파일 관리</a></li>
				<%
					}
				%>
			</ul>
		</li>


		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">기초정보관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("partner_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="partner_list.jsp">거래처 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("worker_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="worker_list.jsp">생산자 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("code_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="code_list.jsp">코드 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("product_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="product_list.jsp">제품 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("user_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="user_list.jsp">직원 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("faulty_code_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="faulty_code_list.jsp">불량 유형 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("AuthorityInfo.jsp");
					if(authority_yn) { 
				%>
					<li><a href="AuthorityInfo.jsp">권한 정보</a></li>
				<%
					}
				%>
			</ul>
		</li>


		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">시스템관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("company_info.jsp");
					if(authority_yn) { 
				%>
					<li><a href="company_info.jsp">자사 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("notice_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="notice_list.jsp">공지 관리</a></li>
				<%
					}
				%>
			</ul>
		</li>

		<li class="dropdown pmd-dropdown">
			<a aria-expanded="false" data-toggle="dropdown" class="btn-user dropdown-toggle media" data-sidebar="true" href="javascript:void(0);">
				<i class="material-icons media-left pmd-sm">assignment</i>
				<span class="media-body">설비관리</span>
				<div class="media-right media-bottom"><i class="dic-more-vert dic"></i></div>
			</a>
			<ul class="dropdown-menu">
				<%
					authority_yn = authorityScreen.contains("machine_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="machine_info_list.jsp">설비 정보</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("machine_qc_standard_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="machine_qc_standard_info_list.jsp">설비 점검 기준</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("machine_qc_history_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="machine_qc_history_list.jsp">설비 검교정 이력</a></li>
				<%
					}
					authority_yn = authorityScreen.contains("machine_repair_info_list.jsp");
					if(authority_yn) { 
				%>
					<li><a href="machine_repair_info_list.jsp">설비 정비 이력</a></li>
				<%
					}
				%>
			</ul>
		</li>

	</ul>
</aside>
<!-- End Left sidebar -->