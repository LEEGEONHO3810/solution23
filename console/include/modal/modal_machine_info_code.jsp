<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<div tabindex="-1" class="modal fade" id="form-dialog_machine_code" style="display: none;" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header bordered">
				<button aria-hidden="true" data-dismiss="modal" class="close" type="button">×</button>
				<h2 class="pmd-card-title-text" id="modal_title">설비 목록</h2>
			</div>
			<div class="modal-body">
				<iframe id="ifrm_machine_modal_list" name="ifrm_machine_modal_list" style="width:100%;height:300px;background-color:#eee;" frameborder="0" src="#"></iframe>
			</div>
			<div class="pmd-modal-action">
				<!--
				<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-primary" type="button">조회</button>
				-->
				<button data-dismiss="modal"	class="btn pmd-ripple-effect btn-default" type="button">취소</button>
			</div>
		</div>
	</div>
</div>