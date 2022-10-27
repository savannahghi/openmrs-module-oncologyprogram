<script>
	jq(document).ready(function () {

	var age 	= ${patient.age};
	var gender 	= '${patient.gender}';
	var select  = 'enrollInAnc';

	jQuery(function(){
		if (age <= 5){
			jq("input[name='enrollIn'][value='enrollInCwc']").attr('checked', 'checked');
			select = 'enrollInCwc';
		}

		jQuery("input[name='enrollIn']").change(function(){
			var programme = jq(this).val();

			select = programme;
		});

			jQuery('.confirm').click(function () {
				if (!jq("input[name='enrollIn']:checked").val()) {
					jq().toastmessage('showErrorToast', 'No Programme has been selected');
				}

				var programme = jq("input[name='enrollIn']:checked").val();

				if ('${source?source:""}' == 'clinic' && programme != 'enrollInCwc') {
					if (programme == 'enrollInAnc') {
						jq('#ancDateEnrolled').val(jq('#date-enrolled-field').val());
						//This will show the Dialog
						jq("#enrollAncDialog").show();
						//enrollAncDialog.show();

					} else {
						jq('#pncDateEnrolled').val(jq('#date-enrolled-field').val());
						// This will show the Dialog
						jq("#enrollPncDialog").show();
						//enrollPncDialog.show();
					}
				} else {
					handleEnrollInProgram("${ui.actionLink('mchapp', 'programSelection', '" + programme + "')}",
							successUrl
					);
				}
			});


		var handleEnrollInProgram = function (postUrl, successUrl) {
			jq.post(
				postUrl,
				{
					patientId: ${patient.id},
					dateEnrolled: jq("#date-enrolled-field").val(),
				},
				null,
				'json'
			).done(function(data){
				if (data.status === "success") {
					jq().toastmessage('showSuccessToast', data.message);
					//redirect to triage page
					window.location = successUrl;
				} else if (data.status === "error") {
					//display error message
					jq().toastmessage({sticky : true});
					jq().toastmessage('showErrorToast', data.message);
				}
			}).fail(function(){
				//display error message
			});
		};

		var enrollAncDialog = emr.setupConfirmationDialog({
            dialogOpts: {
                overlayClose: false,
                close: true
            },
            selector: '#enrollAncDialog',
            actions: {
                confirm: function () {
					var requestData = {
						parity		: jq('#parity').val(),
						gravida		: jq('#gravida').val(),
						lmp			: jq('#1427AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-field').val(),
						edd			: jq('#5596AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-field').val(),
						gestation	: jq('#gestation').val(),
						visitCount	: jq('#visitNumber').val()
					};

					if (requestData.parity == '' || requestData.gravida == '' || requestData.lmp == '' || requestData.edd == '' || requestData.gestation == '' || requestData.visitCount == ''){
						jq().toastmessage('showErrorToast', 'Ensure all fields have been properly filled');
						return false;
					}

					var data = jq("form#enrollAncDialog").serialize();

					jq.post('${ui.actionLink("mchapp", "programSelection", "enrollInAnc")}',
						data,
						null,
						'json'
					).done(function(data){
						if (data.status === "success") {
							jq().toastmessage('showSuccessToast', data.message);
							window.location = successUrl;
						} else if (data.status === "error") {
							jq().toastmessage('showErrorToast', data.message);
						}
					}).fail(function(){
						//display error message
					});





                    enrollAncDialog.close();
                },
                cancel: function () {
                    enrollAncDialog.close();
                }
            }
        });

		var enrollPncDialog = emr.setupConfirmationDialog({
            dialogOpts: {
                overlayClose: false,
                close: true
            },
            selector: '#enrollPncDialog',
            actions: {
                confirm: function () {
					var requestData = {
						deliveryMode: jq('#deliveryMode').val(),
						deliveryDate: jq('#5599AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-field').val(),
					};


					var data = jq("form#enrollPncDialog").serialize();

					jq.post('${ui.actionLink("mchapp", "programSelection", "enrollInPnc")}',
						data,
						null,
						'json'
					).done(function(data){
						if (data.status === "success") {
							jq().toastmessage('showSuccessToast', data.message);
							window.location = successUrl;
						} else if (data.status === "error") {
							jq().toastmessage('showErrorToast', data.message);
						}
					}).fail(function(){
						//display error message
					});





                    enrollAncDialog.close();
                },
                cancel: function () {
                    enrollAncDialog.close();
                }
            }
        });
	 });
	});

</script>

<style>
	input[type="text"], 
	input[type="number"], 
	input[type="password"], 
	select {
		border: 1px solid #aaa !important;
		border-radius: 2px !important;
		box-shadow: none !important;
		box-sizing: border-box !important;
		height: 38px !important;
		line-height: 18px !important;
		padding: 0 10px !important;
	}
	span.date input {
		display: inline-block;
		padding: 5px 10px;
		width: 252px!important;
	}
	.tasks {
        background: white none repeat scroll 0 0;
		border: 1px solid #cdd3d7;
		border-radius: 4px;
		box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
		color: #404040;
		display: inline-block;
		font: 13px/20px "Lucida Grande",Verdana,sans-serif;
		margin-bottom: 5px;
		width: 250px;
    }

    .tasks-header {
        position: relative;
        line-height: 24px;
        padding: 7px 15px;
        color: #5d6b6c;
        text-shadow: 0 1px rgba(255, 255, 255, 0.7);
        background: #f0f1f2;
        border-bottom: 1px solid #d1d1d1;
        border-radius: 3px 3px 0 0;
        background-image: -webkit-linear-gradient(top, #f5f7fd, #e6eaec);
        background-image: -moz-linear-gradient(top, #f5f7fd, #e6eaec);
        background-image: -o-linear-gradient(top, #f5f7fd, #e6eaec);
        background-image: linear-gradient(to bottom, #f5f7fd, #e6eaec);
        -webkit-box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
        box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
    }

    .tasks-title {
        line-height: inherit;
        font-size: 14px;
        font-weight: bold;
        color: inherit;
    }

    .tasks-lists {
        background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/registration/images/view_list.png") no-repeat scroll 3px 0 / 85% auto;
        position: absolute;
        top: 50%;
        right: 10px;
        margin-top: -11px;
        padding: 10px 4px;
        width: 19px;
        height: 3px;
        font: 0/0 serif;
        text-shadow: none;
        color: transparent;
    }

    .tasks-lists:before {
        display: block;
        height: 3px;
        background: #8c959d;
        border-radius: 1px;
        -webkit-box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
        box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
    }

    .tasks-list-item {
        display: block;
        line-height: 24px;
        padding: 5px 10px;
        cursor: pointer;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
    }

    .tasks-list-item + .tasks-list-item {
        border-top: 1px solid #f0f2f3;
    }

    .tasks-list-cb {
        display: none;
    }
	
	.tasks-list-mark {
		border: 2px solid #c4cbd2;
		border-radius: 5px;
		display: inline-block;
		height: 20px;
		margin-right: 0;
		position: relative;
		vertical-align: top;
		width: 20px;
	}

    .tasks-list-mark:before {
        content: '';
        display: none;
        position: absolute;
        top: 50%;
        left: 50%;
        margin: -5px 0 0 -6px;
        height: 4px;
        width: 8px;
        border: solid #39ca74;
        border-width: 0 0 4px 4px;
        -webkit-transform: rotate(-45deg);
        -moz-transform: rotate(-45deg);
        -ms-transform: rotate(-45deg);
        -o-transform: rotate(-45deg);
        transform: rotate(-45deg);
    }

    .tasks-list-cb:checked ~ .tasks-list-mark {
        border-color: #39ca74;
    }

    .tasks-list-cb:checked ~ .tasks-list-mark:before {
        display: block;
    }

    .tasks-list-desc {
        font-weight: bold;
        color: #555;
    }

    .tasks-list-cb:checked ~ .tasks-list-desc {
        color: #34bf6e;
    }
	#enrollAncDialog{
	position: absolute;
    top: 50%;
    margin-left: -225px;
    left: 50%;
	}
	#enrollPncDialog{
	position: absolute;
    top: 50%;
    margin-left: -225px;
    left: 50%;
	}
	
</style>

<div>
	<div id="div-left-menu" style="padding-top: 15px; color: #363463;" class="col15 clear">
		<ul id="ul-left-menu" class="left-menu">
			<li class="menu-item visit-summary selected" visitid="54">
				<span class="menu-date">
					<i class="icon-user"></i>
					<span id="vistdate">
						PATIENT ENROLMENT
					</span>
				</span>
				<span class="menu-title">
					<i class="icon-info-sign"></i>
					TREATMENT PROGRAMME
				</span>
				<span class="arrow-border"></span>
				<span class="arrow"></span>
			</li>
			
			<li style="height: 30px;" class="menu-item">
			</li>
		</ul>
	</div>
	
	<div style="min-width: 70%" class="col16 dashboard">			
		<div id="visit-detail" class="info-section">
			<div class="info-header">
				<i class="icon-user-md"></i>
				<h3>ENROLMENT DETAILS</h3>
			</div>

			<div class="info-body">
				<div>
					<label for="date-enrolled-display" style="display: inline-block; width: 190px; padding-left: 10px;">Date of Enrollment</label>
					<span>${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'date-enrolled', id: 'date-enrolled', label: 'Date of Enrollment', useTime: false, defaultToday: true])}</span>							
				</div>
				
				<div style="margin-top: 5px;">
					<label for="date-enrolled-display" style="display: inline-block; width: 190px; float: left; padding: 5px 4px 0px 10px;">Select Programme</label>
					
					<div class="tasks">
						<header class="tasks-header">
							<span class="tasks-title">TREATMENT PROGRAMMES</span>
							<a class="tasks-lists"></a>
						</header>

						<div class="tasks-list">
							<label class="tasks-list-item">
								<input type="radio" class="tasks-list-cb" value="enrollInAnc" name="enrollIn" style="display:none!important" checked="checked">
								<span class="tasks-list-mark"></span>
								<span class="tasks-list-desc"> CHEMOTHERAPY</span>
							</label>

							<label class="tasks-list-item">
								<input type="radio" class="tasks-list-cb" value="enrollInPnc" name="enrollIn" style="display:none!important">
								<span class="tasks-list-mark"></span>
								<span class="tasks-list-desc"> RADIOTHERAPY</span>
							</label>

							<label class="tasks-list-item">
								<input type="radio" class="tasks-list-cb" value="enrollInCwc" name="enrollIn" style="display:none!important">
								<span class="tasks-list-mark"></span>
								<span class="tasks-list-desc"> SURGERY</span>
							</label>
						</div>
					</div>					
				</div>
			</div>
		</div>		
		
		<button style="float: right; margin: 10px; display: block;" class="confirm">
			<i class="icon-save small"></i>
			Enroll
		</button>
	</div>
</div>

<div class="container">	
	<br style="clear: both">
</div>

<form method="post" id="enrollAncDialog" class="dialog" style="display: none;">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>
        <h3>CHEMO DETAILS</h3>
    </div>

    <div class="dialog-content">
        <ul>
            <li>
                <label for="deliveryModez">Surgery Status</label>
                <select id="deliveryModez" name="concept.a875ae0b-893c-47f8-9ebe-f721c8d0b130">
                    <option value="">Select Option</option>
                    <% deliveryMode.each { modes -> %>
                    <option value="${modes.uuid}">${modes.label}</option>
                    <% } %>
                </select>
            </li>
			
            <span class="button confirm" id="processProgramExitz" style="float: right; margin-right: 35px;">
				<i class="icon-save small"></i>
				Save
			</span>
			
            <span class="button cancel">Cancel</span>
        </ul>
    </div>
</form>

<form method="post" id="enrollPncDialog" class="dialog" style="display: none;">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>
        <h3>RADIOTHERAPY DETAILS</h3>
    </div>

    <div class="dialog-content">
        <ul>

			<li>
				<label for="deliveryMode">Surgery Status</label>
				<select id="deliveryMode" name="concept.a875ae0b-893c-47f8-9ebe-f721c8d0b130">
					<option value="">Select Option</option>					
					<% deliveryMode.each { modes -> %>
 						<option value="${modes.uuid}">${modes.label}</option>
 					<% } %>
				</select>
			</li>
			
            <span class="button confirm" id="processProgramExit" style="float: right; margin-right: 35px;">
				<i class="icon-save small"></i>
				Save
			</span>
			
            <span class="button cancel">Cancel</span>
        </ul>
    </div>
</form>
