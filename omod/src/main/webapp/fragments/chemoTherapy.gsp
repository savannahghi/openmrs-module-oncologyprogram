<script>
	jq(function(){
		jq("#ul-left-menu").on("click", ".program-summary", function(){
			jq("#chemo-detail").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
			jq("#opdRecordsPrintButton").hide();

			var programDetail = jq(this);
			jq(".program-summary").removeClass("selected");
			jq(programDetail).addClass("selected");

			jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"getProgramSummaryDetails") }',
					{ 'encounterId' : jq(programDetail).find(".encounter-id").val() }
			).success(function (data) {

				if (data.drugs.length > 0) {
					var chemoTemplate =  _.template(jq("#chemo-template").html());
					jq("#chemo-detail").html(chemoTemplate(data));
				}
				else {
					var chemoTemplate =  _.template(jq("#empty-template").html());
					jq("#chemo-detail").html(chemoTemplate(data));
				}

				jq("#opdRecordsPrintButton").show(100);
			})
		});

		jq('#opdRecordsPrintButton').click(function(){
			jq("#printSection").print({
				globalStyles: 	false,
				mediaPrint: 	false,
				stylesheet: 	'${ui.resourceLink("treatmentapp", "styles/printout.css")}',
				iframe: 		false,
				width: 			600,
				height:			700
			});
		});

		var programSummaries = jq(".program-summary");

		if (programSummaries.length > 0) {
			programSummaries[0].click();
			jq('#cs').show();
		}else{
			jq('#cs').hide();
		}

		/*jq('#ul-left-menu').slimScroll({
			allowPageScroll: false,
			height		   : '426px',
			distance	   : '11px',
			color		   : '#363463'
		});*/

		jq('#ul-left-menu').scrollTop(0);
		jq('#slimScrollDiv').scrollTop(0);
	});
</script>

<style>
#ul-left-menu {
	border-top: medium none #fff;
	border-right: 	medium none #fff;
}
#ul-left-menu li:nth-child(1) {
	border-top: 	1px solid #ccc;
}
#ul-left-menu li:last-child {
	border-bottom:	1px solid #ccc;
	border-right:	1px solid #ccc;
}
.program-summary{

}
#person-detail {
	display: none;
}
.dashboard .info-body label {
	display: inline-block;
	font-size: 90%;
	font-weight: bold;
	margin-bottom: 5px;
	width: 190px;
}
.clinical-history label{
	float: left;
}
.clinical-history span{
	float: 	left;
	display: inline-block;
}
.status.active {
	margin-right: 10px;
	margin-top: 7px;
}
</style>

<div class="onerow">
	<div id="div-left-menu" style="padding-top: 15px;" class="col15 clear">
		<ul id="ul-left-menu" class="left-menu">
			<% programSummaries.each { summary -> %>
			<li class="menu-item program-summary" visitid="54" style="border-right:1px solid #ccc; margin-right: 15px; width: 168px; height: 18px;">
				<input type="hidden" class="encounter-id" value="${summary.encounterId}" >
				<span class="menu-date">
					<i class="icon-time"></i>
					<span id="vistdate">
						${ui.formatDatetimePretty(summary.visitDate)}
					</span>
				</span>
				<span class="menu-title">
					<i class="icon-stethoscope"></i>
					<% if (summary.outcome) { %>
					${ summary.outcome }
					<% }  else { %>
					No Outcome Yet
					<% } %>
				</span>
				<span class="arrow-border"></span>
				<span class="arrow"></span>
			</li>

			<% } %>

			<li style="height: 30px; margin-right: 15px; width: 168px;" class="menu-item">
			</li>
		</ul>
	</div>

	<div class="col16 dashboard opdRecordsPrintDiv" style="min-width: 78%">
		<div id="printSection">
			<div id="person-detail">
				<h3>PATIENT SUMMARY INFORMATION</h3>

				<label>
					<span class='status active'></span>
					Identifier:
				</label>
				<span>${patient.getPatientIdentifier()}</span>
				<br/>

				<label>
					<span class='status active'></span>
					Full Names:
				</label>
				<span>${patient.givenName} ${patient.familyName} ${patient.middleName?patient.middleName:''}</span>
				<br/>

				<label>
					<span class='status active'></span>
					Age:
				</label>
				<span>${patient.age} (${ui.formatDatePretty(patient.birthdate)})</span>
				<br/>

				<label>
					<span class='status active'></span>
					Gender:
				</label>
				<span>${gender}</span>
				<br/>
			</div>

			<div class="info-section" id="program-detail">

			</div>

			<div class="info-sections" id="chemo-detail" style="margin: 0px 10px 0px 5px;">

			</div>
		</div>

		<button id="opdRecordsPrintButton" class="task" style="float: right; margin: 10px;">
			<i class="icon-print small"></i>
			Print
		</button>
	</div>
</div>

<div class="main-content" style="border-top: 1px none #ccc;">
	<div id=""></div>
</div>


<script id="chemo-template" type="text/template">
<div class="info-header">
	<i class="icon-medicine"></i>
	<h3>DRUGS PRESCRIPTION SUMMARY INFORMATION</h3>
</div>

<table id="chemoList">
	<thead>
	<tr style="border-bottom: 1px solid #eee;">
		<th>#</th>
		<th>Medication</th>
		<th>Dosage</th>
		<th>Route</th>
		<th>Dosing Unit</th>
		<th>Comment</th>
		<th>Action</th>
	</tr>
	</thead>
	<tbody>
	{{ _.each(drugs, function(drug, index) { }}
	<tr style="border: 1px solid #eee;">
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{=index+1}}</td>
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.medication}}</td>
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dose}}</td>
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.route}}</td>
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dosingUnit}}</td>
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.comment}}</td>
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;"></td>
	</tr>
	{{ }); }}
	</tbody>
</table>
</script>

<script id="empty-template" type="text/template">
<div class="info-header">
	<i class="icon-medicine"></i>
	<h3>DRUGS PRESCRIPTION SUMMARY INFORMATION</h3>
</div>

<table id="chemoList">
	<thead>
	<tr>
		<th>#</th>
		<th>Medication</th>
		<th>Dosage</th>
		<th>Route</th>
		<th>Dosing Unit</th>
		<th>Comment</th>
		<th>Action</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td></td>
		<td style="text-align: center;" colspan="4">No Drugs Prescribed</td>
	</tr>
	</tbody>
</table>
</script>

<div></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>