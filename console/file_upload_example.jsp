<%@ page language="java" contentType="text/html; charset=EUC-KR"%>
<%@ include file="include/session_info.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
    <form name="frmName" id="frmName" method="post" enctype="multipart/form-data"
        action="file_upload_proc.jsp">
        <!-- 파일을 전송해서 업로드하기 위해 필요한 form 태그와 input 태그를 지정 -->
        user<br/>
		<input name="user"><br/>
		title<br/>
		<input name="title"><br/>
		file<br/>
		<input type="file" name="upload_file"><br/>
		<input type="file" name="upload_file"><br/>
		<input type="file" name="upload_file"><br/>
		<input type="file" name="upload_file"><br/>
		<input type="file" name="upload_file"><br/>
		<!-- 파일을 업로드하기 위해 input type을 file로 지정 -->
		<input type="button" value="UPLOAD" onClick="JavaScript:$.fnc_report_data_save();"><br/>
    </form>
</body>

<script src="assets/js/jquery-1.12.2.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script src="assets/js/propeller.min.js"></script>
<script>
	$(document).ready(function() {
		$.fnc_report_data_save = function() {
			// console.log($('#frm_order_data').serialize());
			// var form = $('#frmName')[0];
			var input_file = $('input[name="upload_file"]');
			var form_data = new FormData();
			for(var i=0; i<input_file.length; i++) {
				console.log('> ' + i + ' ' + input_file[i].files.length);
				form_data.append('upload_files_' + i, input_file[i].files[0])
			};
			jQuery.ajax({
				url: 'file_upload_proc.jsp',
				data: form_data,
				contentType : false,
				processData : false,
				type:'POST',
				error : function(){
					console.log('error');
					// $("#p_alert_msg").html("변경사항에 실패하였습니다.");
					// $('#div_alert_modal').modal("show");
					// loader.off();
				},
				beforeSend : function(){
					// loader.on(function(){
					// });
				},
				success: function(result){
					console.log('error');
				}
			});
			/*
			var files = input_file[0].files;
			var files1 = input_file[1].files;
			var formData = new FormData();
			for(var i=0; i<files.length; i++) {
				console.log('> ' + i + ' ' + files[i]);
				formData.append('upload_files', files[i])
			}
			jQuery.ajax({
				url: 'file_upload_proc.jsp',
				data: formData,
				contentType : false,
				processData : false,
				type:'POST',
				error : function(){
					console.log('error');
					// $("#p_alert_msg").html("변경사항에 실패하였습니다.");
					// $('#div_alert_modal').modal("show");
					// loader.off();
				},
				beforeSend : function(){
					// loader.on(function(){
					// });
				},
				success: function(result){
					console.log('error');
				}
			});
			*/
		}
	});
</script>
</html>
