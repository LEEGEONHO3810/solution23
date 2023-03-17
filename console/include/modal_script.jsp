<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<script>
	$(document).ready(function() {
		$.fnc_issue_confirm = function(doc_id, report_id, write_date, write_time, product_id, manager_id, session_user_id, issue_id) {
			var params = {
					___proc_id___ : 'issue_001',
					___report_id___ : report_id,
					___write_date___ : write_date,
					___write_time___ : write_time,
					___product_id___ : product_id,
					___manager_id___ : manager_id,
					___session_user_id___ : session_user_id,
					___issue_id___ : issue_id, 
					___doc_id___ : doc_id
			}

			jQuery.ajax({
				url: 'include/modal_proc.jsp',
				data: params,
				type: 'POST',
				error : function(){
					alert('저장 실패!!');
				},
				success: function(result){
					window.location.reload();
					/*
					$('#div_approval_level_01').empty();
					var stamp_img = $('<img>', {
						'src':'resources/img/_stamp_user001.png',
						'width':'40px',
						'height':'40px',
					})
					$('#div_approval_level_01').append(stamp_img);
					*/
				}
			});
		}
	});
</script>
