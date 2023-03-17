<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>

<!-- Scripts Starts -->
<script src="assets/js/jquery-1.12.2.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>

<script src="assets/js/propeller.min.js"></script>

<!-- Scripts Ends -->
<!-- Javascript for Datepicker -->
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>

<!-- Scripts Ends -->
<!-- Javascript for Datepicker -- >
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>

<!-- Scripts Starts -- >
<script src="assets/js/jquery-1.12.2.min.js"></script>
<script src="assets/js/bootstrap.min.js"></script>


<!-- Datatable js -- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>

<!-- Datatable Bootstrap -- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>

<!-- Datatable responsive js-- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/responsive/2.1.0/js/dataTables.responsive.min.js"></script>

<!-- Datatable select js-- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js"></script>

<script src="assets/js/propeller.min.js"></script>

<!-- Javascript for Datepicker -- >
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/moment-with-locales.js"></script>
<script type="text/javascript" language="javascript" src="components/datetimepicker/js/bootstrap-datetimepicker.js"></script>
-->

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

		$.fnc_user_info = function(user_id, user_name) {
			// alert('> ' + user_id + ' ' + user_name);
			document.getElementById('txt_user_id').value = user_id;
			document.getElementById('txt_user_name').value = user_name;
		}

		$.fnc_product_info = function(product_id, model_id, model_name) {
			// alert('> ' + user_id + ' ' + user_name);
			document.getElementById('txt_product_id').value = product_id;
			document.getElementById('txt_model_id').value = model_id;
			document.getElementById('txt_model_name').value = model_name;
		}

		$.fnc_metal_confirm = function(doc_id, report_id, write_time, manager_id, session_user_id, seq, step, val, location_id) {
			/*
			// console.log();
			var obj_id = 'td_pass_result_' + seq + '_' + step;
			$('#' + obj_id).empty();
			var stamp_img = $('<img>', {
				'src':'resources/img/_stamp_user001.png',
				'width':'40px',
				'height':'40px',
			})
			$('#' + obj_id).append(stamp_img);
			*/
			if(step!='0') {
				var params = {
						___proc_id___ : '001',
						___report_id___ : report_id,
						___write_time___ : write_time,
						___manager_id___ : manager_id,
						___session_user_id___ : session_user_id,
						___doc_id___ : doc_id,
						___seq___ : seq,
						___val___ : val,
						___step___ : step,
						___location_id___ : location_id
				}

				jQuery.ajax({
					url: 'include/metal_proc.jsp',
					// processData: false,
					// contentType: false,
					data: params,
					type: 'POST',
					error : function(){
						alert('저장 실패!!');
					},
					success: function(result){
						var obj_id = '#td_pass_result_' + seq + '_' + step;
						// alert(obj_id);
						$(obj_id).empty();
						// <i class="material-icons pmd-sm" style="color:#ccc; font-size:32px;">check_circle</i>
						var stamp_img = $('<i>', {
							'class':'material-icons pmd-sm',
							'color':'red',
							'font-size':'32px',
							'value':'check_circle',
						})
						$(obj_id).append('<i class="material-icons pmd-sm" style="color:#259b24; font-size:32px;">check_circle</i>');
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
			else if(step=='0') {
				var params = {
						___proc_id___ : '002',
						___report_id___ : report_id,
						___write_time___ : write_time,
						___manager_id___ : manager_id,
						___session_user_id___ : session_user_id,
						___doc_id___ : doc_id,
						___seq___ : seq,
						___val___ : val,
						___step___ : step,
						___location_id___ : location_id
				}

				jQuery.ajax({
					url: 'include/metal_proc.jsp',
					// processData: false,
					// contentType: false,
					data: params,
					type: 'POST',
					error : function(){
						alert('저장 실패!!');
					},
					success: function(result){
						var obj_id = '';
						obj_id = (val=='ok')?'#td_pass_result_' + seq + '_ok':'#td_pass_result_' + seq + '_ng';
						// alert(obj_id);
						$(obj_id).empty();
						// <i class="material-icons pmd-sm" style="color:#ccc; font-size:32px;">check_circle</i>
						// var stamp_img = $('<i>', {
						// 	'class':'material-icons pmd-sm',
						// 	'color':'red',
						// 	'font-size':'32px',
						// 	'value':'check_circle',
						// })
						if(val=='ok') {
							$(obj_id).append('	<i class="material-icons pmd-sm" style="color:#0099ff; font-size:24px; padding-left:8px;">thumb_up</i>');
							// $(obj_id).append('적합');
						}
						else if(val=='ng') {
							$(obj_id).append('	<i class="material-icons pmd-sm" style="color:#cc0000; font-size:24px; padding-left:8px;">thumb_down</i>');
							// $(obj_id).append('부적합');
						}
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
		}

		$.fnc_slave_confirm = function(doc_id, report_id, write_time, manager_id, session_user_id, seq) {
			var params = {
					___proc_id___ : '002',
					___report_id___ : report_id,
					___write_time___ : write_time,
					___manager_id___ : manager_id,
					___session_user_id___ : session_user_id,
					___doc_id___ : doc_id
			}

			jQuery.ajax({
				url: 'include/approval_proc.jsp',
				// processData: false,
				// contentType: false,
				data: params,
				type: 'POST',
				error : function(){
					alert('저장 실패!!');
				},
				success: function(result){
					$('#td_slave_approval_' + seq).empty();
					var stamp_img = $('<img>', {
						'src':'resources/img/<%=ss_user_stamp %>',
						'width':'40px',
						'height':'40px',
					})
					$('#td_slave_approval_' + seq).append(stamp_img);
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

		$.fnc_approve_confirm = function(doc_id, report_id, approval_level_id, approval_user_id) {
			var params = {
					___proc_id___ : '001',
					___approval_level_id___ : approval_level_id,
					___approval_user_id___ : approval_user_id,
					___report_id___ : report_id,
					___doc_id___ : doc_id
			}

			jQuery.ajax({
				url: 'include/approval_proc.jsp',
				// processData: false,
				// contentType: false,
				data: params,
				type: 'POST',
				datatype : 'json',
				error : function(){
					alert('저장 실패!!');
				},
				success: function(result){
					var approval_level = JSON.parse(result).level;
					var approval_target = '#div_approval_level_' + approval_level;
					console.log(approval_target);
					$(approval_target).empty();
					var stamp_img = $('<img>', {
						'src':'resources/img/<%=ss_user_stamp %>',
						'width':'40px',
						'height':'40px',
					})
					$(approval_target).append(stamp_img);
				}
			});
		}
	});
</script>

<script type="text/javascript">
(function() {
  "use strict";
  var toggles = document.querySelectorAll(".c-hamburger");
  for (var i = toggles.length - 1; i >= 0; i--) {
    var toggle = toggles[i];
    toggleHandler(toggle);
  };
  function toggleHandler(toggle) {
    toggle.addEventListener( "click", function(e) {
      e.preventDefault();
      (this.classList.contains("is-active") === true) ? this.classList.remove("is-active") : this.classList.add("is-active");
    });
  }

})();
</script>
<script>
	// // Linked date and time picker
	// // start date date and time picker
	// $('#datepicker-default').datetimepicker();
	// $(".auto-update-year").html(new Date().getFullYear());

	// Linked date and time picker
	// start date date and time picker
	$('#datepicker-start').datetimepicker({
		// useCurrent: true,
		'format' : "YYYY-MM-DD", // HH:mm:ss
	});

	// End date date and time picker
	$('#datepicker-end').datetimepicker({
		useCurrent: false,
		'format' : "YYYY-MM-DD", // HH:mm:ss,
		sideBySide: true,
		widgetPositioning: {
            horizontal: "auto",
            vertical: "auto"
		}
	});

	// start date picke on chagne event [select minimun date for end date datepicker]
	$("#datepicker-start").on("dp.change", function (e) {
		$('#datepicker-end').data("DateTimePicker").minDate(e.date);
	});
	// Start date picke on chagne event [select maxmimum date for start date datepicker]
	$("#datepicker-end").on("dp.change", function (e) {
		$('#datepicker-start').data("DateTimePicker").maxDate(e.date);
	});
</script>

<!-- Datatable js -- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>

<!-- Datatable Bootstrap -- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>

<!-- Datatable responsive js-- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/responsive/2.1.0/js/dataTables.responsive.min.js"></script>

<!-- Datatable select js-- >
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/select/1.2.0/js/dataTables.select.min.js"></script>

<!-- Propeller Data table js-- >
<script>
//Propeller Customised Javascript code
$(document).ready(function() {
	$('#example-checkbox').DataTable({
		responsive: false,
		columnDefs: [ {
			orderable: false,
			// className: 'select-checkbox',
			targets:0,
		} ],
		select: {
			style: 'multi',
			selector: 'td:first-child'
		},
		order: [ 1, 'asc' ],
		bFilter: true,
		bLengthChange: true,
		pagingType: "simple",
		"paging": true,
		"searching": true,
		"language": {
			"info": " _START_ - _END_ of _TOTAL_ ",
			"sLengthMenu": "<span class='custom-select-title'>Rows per page:</span> <span class='custom-select'> _MENU_ </span>",
			"sSearch": "",
			"sSearchPlaceholder": "Search",
			"paginate": {
				"sNext": " ",
				"sPrevious": " "
			},
		},
		dom:
			// "<'pmd-card-title'<'data-table-title'><'search-paper pmd-textfield'f>>" +
			"<'custom-select-info'<'custom-select-item'><'custom-select-action'>>" +
			"<'row'<'col-sm-12'tr>>" +
			"<'pmd-card-footer' <'pmd-datatable-pagination' l i p>>",
	});

	/// Select value
	$('.custom-select-info').hide();

	$('#example-checkbox tbody').on( 'click', 'tr', function () {
		if ( $(this).hasClass('selected') ) {
			var rowinfo = $(this).closest('.dataTables_wrapper').find('.select-info').text();
			$(this).closest('.dataTables_wrapper').find('.custom-select-info .custom-select-item').text(rowinfo);
			if ($(this).closest('.dataTables_wrapper').find('.custom-select-info .custom-select-item').text() != null){
				$(this).closest('.dataTables_wrapper').find('.custom-select-info').show();
				//show delet button
			} else{
				$(this).closest('.dataTables_wrapper').find('.custom-select-info').hide();
			}
		}
		else {
			var rowinfo = $(this).closest('.dataTables_wrapper').find('.select-info').text();
			$(this).closest('.dataTables_wrapper').find('.custom-select-info .custom-select-item').text(rowinfo);
		}
		if($('#example-checkbox').find('.selected').length == 0){
			$(this).closest('.dataTables_wrapper').find('.custom-select-info').hide();
		}
	} );
	$("div.data-table-title").html('<h2 class="pmd-card-title-text">Propeller Data table</h2>');
	$(".custom-select-action").html('<button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">delete</i></button><button class="btn btn-sm pmd-btn-fab pmd-btn-flat pmd-ripple-effect btn-primary" type="button"><i class="material-icons pmd-sm">more_vert</button>');

} );
</script>
-->

<script>
$(document).ready(function() {
	/*
	if($('#txt_approval_01_datetime').val()!='') {
		$('#div_approval_level_01').empty();
		var stamp_img = $('<img>', {
			'src':'resources/img/_stamp_user001.png',
			'width':'40px',
			'height':'40px',
		})
		$('#div_approval_level_01').append(stamp_img);
	}
	*/
	if($('#txt_approval_01_datetime').val()!='') {
		$('#div_approval_level_01').empty();
		var stamp_img = $('<img>', {
			'src':'resources/img/<%=_clm_approval_01_stamp %>',
			'width':'40px',
			'height':'40px',
		})
		$('#div_approval_level_01').append(stamp_img);
	}
	if($('#txt_approval_02_datetime').val()!='') {
		$('#div_approval_level_02').empty();
		var stamp_img = $('<img>', {
			'src':'resources/img/<%=_clm_approval_02_stamp %>',
			'width':'40px',
			'height':'40px',
		})
		$('#div_approval_level_02').append(stamp_img);
	}
	if($('#txt_approval_03_datetime').val()!='') {
		$('#div_approval_level_03').empty();
		var stamp_img = $('<img>', {
			'src':'resources/img/<%=_clm_approval_03_stamp %>',
			'width':'40px',
			'height':'40px',
		})
		$('#div_approval_level_03').append(stamp_img);
	}

	$('#btn_list').on('click', function(e) {
		location.href = '<%=strCurrentReportId %>_list.jsp';
		// // alert('test');
		// window.open('data:application/vnd.ms-excel,' + $('#tbl_slave_data').html());
		// e.preventDefault();
	});
});
</script>