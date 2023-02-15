<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css" integrity="sha512-5PV92qsds/16vyYIJo3T/As4m2d8b6oWYfoqV+vtizRB6KhF1F9kYzWzQmsO6T3z3QG2Xdhrx7FQ+5R1LiQdUA==" crossorigin="anonymous" referrerpolicy="no-referrer" />


<script>

let cycleId;
let cycleDetails;
function toggleCssClass(e){
  e.parentNode.parentNode.classList.toggle("open");
}
function Formulation(formulationObj) {
	this.id = formulationObj.id;
	this.label = formulationObj.label;
}

function DrugUnit(unitObj) {
	this.id = unitObj.id;
	this.label = unitObj.label;
}

function DrugRoute(routeObj) {
	this.id = routeObj.id;
	this.label = routeObj.label;
}

function DrugCategory(catObj){
	this.id = catObj.id;
	this.label = catObj.label;
}
function DrugUnit(unitObj){
	this.id = unitObj.id;
	this.label = unitObj.label;
}

function CycleDrug() {
	var self = this;

	self.id = ko.observable();
	self.medication = ko.observable();

    self.dosage = ko.observable();
    self.dosageOpts = ko.observableArray([]);

	self.drugUnit = ko.observable();
	self.drugUnitsOptions = ko.observableArray([]);

	self.drugRoute = ko.observable();
	self.drugRouteOpts = ko.observableArray([]);

	self.category = ko.observable();
	self.categoryOpts = ko.observableArray([]);

	self.unit = ko.observable();
	self.unitOpts = ko.observableArray([]);

	self.comment = ko.observable();
}

    function processClick(e){
        console.log(e.dataset);
        const {drugid, medication, dose, dosingunit, route, tag, comment} = e.dataset;
        document.getElementById("prescription-dialog").style.display = "block";

        if(drugid){
            document.getElementById("drugId").value = drugid;
        }
        if(medication){
            document.getElementById("drugName").value = medication;
            var event = new Event('change');
            document.getElementById("drugName").dispatchEvent(event);
        }
        if(comment){
            document.getElementById("comment").value = comment;
        }
    }

    function deleteCycleDrug(e){
        const {drugid,drugname} = e.dataset;
        document.getElementById("drug-void-dialog").style.display = "block";
        document.getElementById("medication").value = drugname;
        document.getElementById("void-drug-id").value = drugid;
    }

     jq(function () {
      //const data = {"drugs": [{"name":"CHOP Protocol", "icon":"icon-hospital", "cycles":[{"id": 1,"name":"cycle 1 of 6", "icon":"icon-stethoscope"},{"id": 2,"name":"cycle 2 of 6", "icon":"icon-stethoscope"}] },{"name":"ACT Protocol", "icon":"icon-medkit"}]}
      const data = ${patientCycles};
	  console.log('${patientCycles}');

      if(data.drugs.length > 0){
        // Populate side bar
        var sideBarTemplate =  _.template(jq("#side-bar").html());
        jq("#sideBar").html(sideBarTemplate(data));

        // Populate content area
        var chemoTemplate =  _.template(jq("#landing-chemo-template").html());
        jq("#defaultContainer").html(chemoTemplate(data));

      }else{
        var sideBarTemplate =  _.template(jq("#empty-side-bar").html());
        jq("#sideBar").html(sideBarTemplate(data));

        var chemoTemplate =  _.template(jq("#default-template").html());
        jq("#defaultContainer").html(chemoTemplate(data));
      }

      jq(".drug-name").on("focus.autocomplete", function() {
            var selectedInput = this;
            jq(this).autocomplete({
                source: function(request, response) {
                    jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDrugs") }', {
                        q: request.term
                    }).success(function(data) {
                    console.log("Drugs ===>");
                    console.log(data);
                        var results = [];
                        for (var i in data) {
                            var result = {
                                label: data[i].name,
                                name: data[i].name,
                                value: data[i].id.toString(),
                                id: data[i].id.toString()
                            };
                            results.push(result);
                        }
                        response(results);
                    });
                },
                minLength: 3,
                select: function(event, ui) {
                    event.preventDefault();
                    var lval = ui.item.label || ""
                    jq(selectedInput).val(lval);
                    drugIdnt = ui.item.value;
                },
                change: function(event, ui) {
                    event.preventDefault();
                    var lval = ui.item.label || ""
                    jq(selectedInput).val(lval);
                    jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getFormulationByDrugName") }', {
                        "drugName": lval
                    }).success(function(data) {
                    console.log("Formulations By Drug Name");
                    console.log(data);
                        var formulations = jq.map(data, function(formulation) {
                            return new Formulation({
                                id: formulation.id,
                                label: formulation.name + ":" + formulation.dozage
                            });
                        });
                        cycleDrug.drug().dosageOpts(formulations);
                    });

                    jq.getJSON('${ui.actionLink("patientdashboardapp","clinicalNotes","getDrugUnit")}')
                        .success(function(data) {
                        var drugUnit = jq.map(data, function(drugUnit) {
                            return new DrugUnit({
                                id: drugUnit.id,
                                label: drugUnit.label
                            });
                        });
                        cycleDrug.drug().drugUnitsOptions(drugUnit);
                    });

                    const categories = [
                        {"id":"1", "label": "Pre-Medication"},
                        {"id":"2", "label": "Chemotherapy"},
                        {"id":"3", "label": "Post-Medication"},
                    ]

                    var drugCategories = jq.map(categories, function(drugCat) {
                        return new DrugCategory({
                            id: drugCat.id,
                            label: drugCat.label
                        });
                    });
                    cycleDrug.drug().categoryOpts(drugCategories);

                    const units = [
                        {"id":"1", "label": "mg"},
                        {"id":"2", "label": "ml"},
                    ]

                    var drugUnits = jq.map(units, function(drugUnit) {
                        return new DrugUnit({
                            id: drugUnit.id,
                            label: drugUnit.label
                        });
                    });
                    cycleDrug.drug().unitOpts(drugUnits);

                    jq.getJSON('${ui.actionLink("patientdashboardapp","clinicalNotes","getDrugRoutes")}')
                    .success(function(data) {
                        var drugRoutes = jq.map(data, function(drugRoute) {
                            return new DrugRoute({
                                id: drugRoute.id,
                                label: drugRoute.name
                            });
                        });
                        cycleDrug.drug().drugRouteOpts(drugRoutes);
                    });
                },
                open: function() {
                    jq(this).removeClass("ui-corner-all").addClass("ui-corner-top");
                },
                close: function() {
                    jq(this).removeClass("ui-corner-top").addClass("ui-corner-all");
                }
            });
      });

        jq(".cycle").on("click",  function(){
          jq("#defaultContainer").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
          var chemoDetail = jq(this);
          cycleId = chemoDetail.context.dataset.cycleid;
          jq(".cycle").removeClass("selected");
          jq(chemoDetail).addClass("selected");


          jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"getChemotherapyCycleDetails") }',
              { 'id' : cycleId }
          ).success(function (data) {

          //let display = (data.cycleDrugs.map(x => x.medication)).join("/");
          //console.log(display);
              cycleDetails = data;
              var chemoTemplate =  _.template(jq("#chemo-template").html());
              jq("#defaultContainer").html(chemoTemplate(data));
              document.getElementById("currentRegimen").textContent = cycleDetails.regimenName;
              document.getElementById("currentCycle").textContent = cycleDetails.cycleName;
              document.getElementById("currentStatus").textContent = cycleDetails.active ? "Active" : "Inactive";
          })
          .fail(function() { console.log("error occurred while fetching cycle details"); })
          .always(function() { console.log("Completed fetching cycle details"); });
        });



        jq(".addCycle").on("click",  function(){
            let addCycleBtn = jq(this);
            let regimenId = addCycleBtn.context.dataset.regimenid;
            jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"createRegimenCycle") }',
              { 'patientId':${patient.patientId},regimenId }
            ).success(function (data) {
              const {status, message} = data;
              if(status === 'fail'){
                jq().toastmessage('showErrorToast', message)
              }else{
                jq().toastmessage({sticky : true});
                jq().toastmessage('showSuccessToast', "Success....reloading the page....!");
                location.reload();
              }
            })
            .fail(function() { console.log("error occurred while fetching cycle details"); })
            .always(function() { console.log("Completed fetching cycle details"); });

        });


        var adddrugdialog = emr.setupConfirmationDialog({
            dialogOpts: {
                overlayClose: false,
                close: true
            },
            selector: '#prescription-dialog',
            actions: {
                confirm: function () {
                    if (!drugDialogVerified()) {
                        jq().toastmessage('showErrorToast', 'Ensure fields marked in red have been properly filled before you continue')
                        return false;
                    }

                    addDrug();
                    jq("#drugForm")[0].reset();
                    jq('select option[value!="0"]', '#drugForm').remove();
                    closePrescriptionDialog();
                    location.reload();
                },
                cancel: function () {
                    jq("#drugForm")[0].reset();
                    jq('select option[value!="0"]', '#drugForm').remove();
                    //jq("#prescription-dialog").style.display = "none";
                   // adddrugdialog.close();
                }
            }
        });

    });

        function voidCycleDrug(){
           let drugId = jq("#void-drug-id").val().trim();
           let comment = jq("#void-comment").val().trim();

           if(!drugId || !comment){
                jq().toastmessage('showErrorToast', 'Please provide reason for deleting!');
                if(!comment){
                    jq("#void-comment").addClass('error');
                }else{
                    jq("#void-comment").removeClass('error');
                }
                return false;
           }
           jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"deletePatientRegimen") }',
                 { drugId, comment}
           ).success(function (data) {
             location.reload();
           })
             .fail(function() { console.log("error occurred while fetching cycle details"); })
             .always(function() { console.log("Completed fetching cycle details"); });
           }
        function updateCycleDrug(){
           let drugId = jq("#drug-id").val();
           let comment = jq("#void-comment").val();

           if(!drugId || !comment){
                jq().toastmessage('showErrorToast', 'Please provide reason for deleting!');
                return false;
           }
           jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"updatePatientRegimen") }',
                 { drugId, comment}
           ).success(function (data) {
             location.reload();
           })
             .fail(function() { console.log("error occurred while fetching cycle details"); })
             .always(function() { console.log("Completed fetching cycle details"); });
           }

        function addDrug(){
            var drugName = jq("#drugName").val();
            var drugDosage = {};
            drugDosage.value = jq("#drugDosage").val();
            drugDosage.text = jq("#drugDosageSelect option:selected").text();

            var dosageUnit = {};
            dosageUnit.id = jq("#drugUnitsSelect option:selected").val();
            dosageUnit.text = jq("#drugUnitsSelect option:selected").text();

            var routesSelect = {};
            routesSelect.id = jq("#routesSelect option:selected").val();
            routesSelect.text = jq("#routesSelect option:selected").text();

            var tagSelect = {};
            tagSelect.id = jq("#tagSelect option:selected").val();
            tagSelect.text = jq("#tagSelect option:selected").text();

            var comment = jq("#comment").val();
            var drugId = jq("#drugId").val();

          jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"addCycleMedication") }',
              {
                  cycleId,
                  drugId,
                  drugName,
                  "dosage":drugDosage.value + ":" + drugDosage.text,
                  "dosageUnit":dosageUnit.text,
                  "route":routesSelect.id,
                  "tag":tagSelect.text,
                  comment
               }
          ).success(function (data) {
              var chemoTemplate =  _.template(jq("#chemo-template").html());
              jq("#defaultContainer").html(chemoTemplate(data));
          })
          .fail(function() { console.log("error occurred while fetching cycle details"); })
          .always(function() { console.log("Completed fetching cycle details"); });
        }

    function openForm() {
      document.getElementById("myForm").style.display = "block";
      jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"fetchRegimenTypes") }')
            .success(function (data) {
                const {regimenTypes} = data;
                for (i = 0; i < regimenTypes.length; i++)
                {
                     jq('#regimenType').append( '<option value="'+ regimenTypes[i].id +'">'+ regimenTypes[i].name +'</option>' );
                }
            })
            .fail(function() { console.log("error occurred while fetching regimen types"); })
            .always(function() { console.log("Completed fetching request"); });
    }

    function closeForm() {
      document.getElementById("myForm").style.display = "none";
    }

    function submitForm(){
        const regimenTypeId = document.getElementById("regimenType").value;
        document.getElementById("myForm").style.display = "none";
        jq("#defaultContainer").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
        jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"createPatientRegimen") }',
              { 'patientId':${patient.patientId},regimenTypeId}
          ).success(function (data) {
              location.reload();
              //var chemoTemplate =  _.template(jq("#chemo-template").html());
              //jq("#defaultContainer").html(chemoTemplate(data));
          })
          .fail(function() { console.log("error occurred registering patient regimen"); })
          .always(function() { console.log("Completed fetching request"); });
    }

    function closePrescriptionDialog(){
        jq("#drugForm")[0].reset();
        jq('select option[value!="0"]', '#drugForm').remove();
        document.getElementById("prescription-dialog").style.display = "none";
    }

    function closeDeleteDialog(){
        jq("#drugDeleteForm")[0].reset();
        document.getElementById("drug-void-dialog").style.display = "none";
    }

    function loadTemplate(template,data){
      var chemoTemplate =  _.template(template.html());
      jq("#defaultContainer").html(chemoTemplate(data));
    }

    function loadNext(templateName){
        let temp;
        if(templateName === 'outcome'){
            //Fetch outcomes
            temp = jq("#outcome-template");
        }else if(templateName === 'summary'){
            temp = jq("#summary-template");
        }
        loadTemplate(temp,cycleDetails);

        if(templateName === 'outcome'){
            document.querySelectorAll("input[name='cycle_outcome']").forEach((input) => {
                    input.addEventListener('change', myfunction);
                });
        }
    }

    function myfunction(event) {
        cycleDetails.outcome = {
            "id":event.target.id,
            "name": event.target.value
        };
    }

    const postDrugAction = async (requestBody) => {
    //TODO - update the request
    //'Authorization', 'Basic ' + base64.encode(username + ":" + password)

    //const response = await fetch('http://localhost:8080/${openhimUrl}', {
    const response = await fetch('${openhimUrl}', {
        method: 'POST',
        body: JSON.stringify(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      });
      const serverResponse = await response.json(); //extract JSON from the http response
      console.log(serverResponse);
      // Process the returned response - normally would be an acknowledgement at this point
      // Updates to be asynchronously sent once the pharmacy is done processing the drugs
      jq().toastmessage('showSuccessToast', serverResponse.msg);

    }


    function processPrescription(){
        jq().toastmessage('showSuccessToast', 'Sending request to pharmacy');
        // TODO - Raise the external request to post the dispense order to the pharmacy and wait for updates on dispense in collaboration with CHAI folks
        // Add dispense status - Draft, Sent, Pending, Partially Fulfilled, Fulfilled, Failed



        let cycleDrugs = cycleDetails.cycleDrugs;
        let payload = {};
        payload.mflCode = ${mflCode};
        payload.nupi = '${nupi?.identifier}';
        payload.idNumber = '${idNumber?.identifier}';
        payload.nhifNumber = '${nhifNumber}';
        payload.patientName = {
                        "familyName" : "${patient.familyName}",
                        "givenName" : "${patient.givenName}",
                        "middleName" : "${patient.middleName ? patient.middleName : ''}"
         }

        payload.patientAddress = {
                    "county" : "${patient.personAddress.countyDistrict}",
                    "subCounty" : "${patient.personAddress.stateProvince}",
                    "ward" : "${patient.personAddress.address4}",
                    "village" : "${patient.personAddress.cityVillage}"
                    }
        payload.observation = {
                    "weight" : "",
                    "height" : "",
                    "bloodPressure" : "",
                    "bloodOxygen" : "",
                    "temperature" : ""
                    }

        payload.dateOfBirth = '${patient.birthdate}';
        payload.phoneNumber = "${phoneNumber ? phoneNumber : ''}";
        payload.alternatePhone = "${alternatePhone ? alternatePhone : ''}";
        payload.enrollmentDate = '${enrollmentDate}';
        payload.birthdateEstimated = '${patient.birthdateEstimated}';
        payload.nextOfKin = {
                "name": "${nokName ? nokName : ''}",
                "contact": "${nokContact ? nokContact : ''}",
                "relationship": "${nokRelationship ? nokRelationship : ''}"
            };
        payload.gender = "${gender ? gender : ''}";
        payload.maritalStatus = "${maritalStatus ? maritalStatus : ''}";
        payload.medications = cycleDrugs;
        postDrugAction(payload);


        cycleDetails.summaryNotes = document.getElementById("summary_notes").value;
        jq("#btn-request-dispense").hide();
        jq("#btn-administer-cycle").show();
    }

    function addPatientCycle(){
        jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"addPatientCycle") }',
              { 'patientId':${patient.patientId},'regimenId' : regimen,'cycle':cycle,'days':days }
          ).success(function (data) {
              location.reload();
              //var chemoTemplate =  _.template(jq("#chemo-template").html());
              //jq("#defaultContainer").html(chemoTemplate(data));
          })
          .fail(function() { console.log("error occurred registering patient regimen"); })
          .always(function() { console.log("Completed fetching request"); });
    }

    function completeCycle(){
        jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"updateRegimenCycle") }',
              { cycleId,
               'active':false,
               'outcome':cycleDetails.outcome.id,
               'summaryNotes':cycleDetails.summaryNotes
               }
          ).success(function (data) {
              location.reload();
          })
          .fail(function() { console.log("error occurred during completing cycle"); })
          .always(function() { console.log("Completed updating the cycle"); });
    }










</script>

<style>
	.error{
		border: 1px solid #f00 !important;
	}
.man{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    height: 65vh;
    display: flex;
    color: #agf;
}

.sidebar{
    width: 283px;
    flex-shrink: 0;
    height: 100%;
    overflow: auto;
}

.cont{
  flex-grow: 1;
  padding: 2em;
  flex-direction: column;
  justify-content: center;
  text-align: center;
}

.contItem{
  flex-grow: 1;
  padding: 2em;
  display: flex;
  flex-direction: row;
  justify-content: center;
  text-align: left;
}

.chemoItem{
  flex-grow: 1;
  /* padding: 2em; */
  display: flex;
  flex-direction: row;
  justify-content: start;
  text-align: left;
      padding: .75em 1em;
    display: block;
    font-weight: bold;
    text-transform: capitalize;
    font-size: 1.4em;
    justify-content: space-between;
}

.tit{
font-size: 3em;
}

.inf{
  font-size: 1.1em;
  letter-spacing: 1px;
  line-height: 1.5;
  margin: 1.5em;
  color: rgb(224, 224, 224);
}
.bt{
  margin: 0 auto;
  border: none;
  outline: none;
  padding: .75em 1em;
  font-size: 1em;
  letter-spacing: 1px;
  box-shadow: 0 3px 5px rgba(0, 0, 0, .4);
  font-weight: bold;
  text-transform: capitalize;
  border-radius: 3px;
  background-color: rgb(134, 49, 0);
}

.bt-side{
    margin: 0 auto;
    border: none;
    outline: none;
    font-size: 1em;
    box-shadow: 0 3px 5px rgba(0, 0, 0, .4);
    font-weight: bold;
    text-transform: capitalize;
    border-radius: 3px;
    background-color: rgb(134, 49, 0);
    position: absolute;
    left: 4px;
    bottom: 5px;
}


.sidebar-item{
  padding: .75em 1em;
  display: block;
  transition: background-color .15s;
  border-radius: 5px;
}

.sidebar-header{
    padding: .75em 1em;
    display: block;
    border-radius: 5px;
    font-weight: bold;
    text-transform: capitalize;
    font-size: 1.4em;
    justify-content: space-between;
}
.sidebar-item:hover{
  background-color: rgba(255, 255, 255, .1);
}

.add-drug:hover{
  background-color: rgba(255, 255, 255, .1);
  cursor: pointer;
}
.add-regimen{
  background-color: rgba(255, 255, 255, .1);
  cursor: pointer;
  float: right !important;
}

.row-actions:hover{
  background-color: rgba(255, 255, 255, .1);
  cursor: pointer;
}


.sidebar-item.selected{
  background-color: rgba(69, 30, 30, .1);
}


.sidebar-title{
  display: flex;
  font-size: 1.2em;
  justify-content: space-between;
}
.sidebar-title span i{
  display: inline-block;
  width: 1.2em;
}
.sidebar-title .toggle-btn{
  cursor: pointer;
  transition: transform .3s;
}
.sidebar-item.open > .sidebar-title .toggle-btn{
  transform: rotate(180deg);
}
.sidebar-content{
  padding-top: .25em;
  height: 0;
  overflow: hidden;
}
.sidebar-item.open > .sidebar-content{
  height: auto;
}

.sidebar-item.plain{
  color: #fff;
  text-decoration: none;
}
.sidebar-item.plain:hover{
  text-decoration: underline;
}
.sidebar-item.plain i{
  display: inline-block;
  width: 1.7em;
}

.form-popup {
  background: gray;
  position: absolute;
  float: left;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

.form-container {
  max-width: 300px;
  padding: 10px;
  background-color: white;
}

.cycle-active {
    background: #161;
    color: white;
    letter-spacing: 1px;
    margin: 5px;
    display: inline;
    padding: 3px 8px;
    font-size: 0.8em;
    -webkit-border-radius: 50px;
    -moz-border-radius: 50px;
    border-radius: 50px;
}

.cycle-complete {
    background: #116;
    color: white;
    display: inline;
    padding: 3px 8px;
    font-size: 0.8em;
    -webkit-border-radius: 50px;
    -moz-border-radius: 50px;
    border-radius: 50px;
}



</style>

<div class = "man">
  <div id="sideBar" class = "sidebar">
  No current cycles in progress
  </div>
  <div id = "defaultContainer" class = "cont">

  </div>
</div>

<div class="dialog form-popup" id="myForm" style = "display:none">

<div class="dialog-header">
        <i class="icon-hospital"></i>
        <h3>Regimen</h3>
    </div>

    <div class="dialog-content">
        <form id="regimenForm">
            <ul>
                <li>
                    <label>Regimen<span class="important">*</span></label>
                    <select name="regimen" id="regimenType" style="width: 100% !important;" required>
                        <option value="0"></option>
                    </select>
                </li>
            </ul>
            <label  class="button cancel" style="width: auto!important;" onclick="closeForm()">Cancel</label>
            <label class="button confirm" style="float: right; margin-left: 10px; width: auto!important;" onclick="submitForm()">Confirm</label>
        </form>
    </div>
</div>

<div id="drug-void-dialog" class="dialog form-popup" style="display:none;">
    <div class="dialog-header">
        <i class="icon-trash"></i>
        <h3>Delete Medication</h3>
    </div>

    <div class="dialog-content">
        <form id="drugDeleteForm">
            <ul>
                <li>
                    <label>Medication<span class="important">*</span></label>
                    <input class="drug-name" id="medication" type="text" disabled />
                    <input id="void-drug-id" type="hidden"  />
                </li>
                <li>
                    <label>Reason<span class="important">*</span></label>
                    <textarea id="void-comment" style="width: 100% !important;" required></textarea>
                </li>
            </ul>
            <label id = "confirm-button" class="button cancel" style="float: right; width: auto!important;" onclick="voidCycleDrug()">Delete</label>
            <label id = "cancel-button" class="button confirm" style="margin-left: 10px; width: auto!important;" onclick="closeDeleteDialog()">Cancel</label>
        </form>
    </div>
</div>
<div id="prescription-dialog" class="dialog form-popup" style="display:none;">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>

        <h3>Add/Edit Prescription</h3>
    </div>

    <div class="dialog-content">
        <form id="drugForm">
        <input class="drug-id" id="drugId" type="hidden" data-bind="value: cycleDrug.drug().drugId, valueUpdate: 'blur'">
            <ul>
                <li>
                    <label>Drug<span class="important">*<span></label>
                    <input class="drug-name" id="drugName" type="text" data-bind="value: cycleDrug.drug().medication, valueUpdate: 'blur'">
                </li>
                <li>
                    <label>Dosage<span class="important">*<span></label>
                    <input class="drug-dosage" id="drugDosage" type="text" style="width: 60px !important;" >
                    <select id="drugDosageSelect"
                        style="width: 65px !important;"
                        data-bind="options: cycleDrug.drug().unitOpts, value: cycleDrug.drug().unit, optionsValue: 'id', optionsText: 'label',  optionsCaption: 'Select Dosage'">
                    </select>
                    <select id="drugUnitsSelect"
                        data-bind="options: cycleDrug.drug().drugUnitsOptions, value: cycleDrug.drug().drugUnit, optionsValue: 'id', optionsText: 'label',  optionsCaption: 'Select Unit'"
                        style="width: 120px !important;">
                    </select>

                </li>

                <li>
                    <label>Route<span class="important">*<span></label>
                    <select id="routesSelect"
                        data-bind="options: cycleDrug.drug().drugRouteOpts, value: cycleDrug.drug().drugRoute, optionsValue: 'id', optionsText: 'label',  optionsCaption: 'Select Route'">
                    </select>
                </li>
                <li>
                    <label>Category<span class="important">*<span></label>
                    <select id="tagSelect"
                        data-bind="options: cycleDrug.drug().categoryOpts, value: cycleDrug.drug().category, optionsValue: 'id', optionsText: 'label',  optionsCaption: 'Select Category'">
                    </select>
                </li>
                <li>
                    <label>Comment</label>
                    <textarea id="comment" style="width: 100% !important;"></textarea>
                </li>
            </ul>
            <label id = "confirm-button" class="button confirm" style="float: right; width: auto!important;">Confirm</label>
            <label id = "cancel-button" class="button cancel" style="width: auto!important;" onclick="closePrescriptionDialog()">Cancel</label>
        </form>
    </div>
</div>



<script id="empty-side-bar" type="text/template">
      <span class = "sidebar-header">
          <i class="icon-stethoscope"></i>  Chemotherapy
      </span>
      <p>No current Regimen</p>
</script>


<script id="side-bar" type="text/template">
      <span class = "sidebar-header">
          <i class="icon-stethoscope"></i>  Chemotherapy
          <i class="icon-plus add-regimen" title="Add a regimen" onclick = "openForm()"></i>
      </span>
      {{ _.each(drugs, function(drug, index) { }}
          <div id = {{-drug.name}} class = "sidebar-item">
              <div class = "sidebar-title"> 
                  <span style="word-break: break-all;">
                    <i class= {{-drug.icon}} ></i>
                        {{ if (drug.displayString) { }}
                          {{-drug.displayString}}
                        {{ } else { }}
                          {{-drug.name}}
                        {{ } }}


                  </span>
                  <i class="icon-chevron-down toggle-btn" onclick = "toggleCssClass(this)"></i>
              </div>
              <div class= "sidebar-content">
                 {{ if(drug.cycles?.length > 0){ }}
                    {{ _.each(drug.cycles, function(cycle, idx) { }}
                      <div id = {{-cycle.id}} class = "sidebar-item cycle" data-cycleId = {{-cycle.id}} >
                        <div class = "sidebar-title"> 
                            <span> 
                              <i class= {{-cycle.icon}} ></i>  {{-cycle.name}}
                              {{ if (cycle.active) { }}
                                <span class = "cycle-active">active</span>
                              {{ } else { }}
                                <span class = "cycle-complete">complete</span>
                              {{ } }}
                            </span>
                        </div>
                      </div>
                  {{ }); }}
                  <div class = "sidebar-item"><button class = "addCycle" data-regimenId= {{-drug.regimenId}}><i class="icon-plus"></i>Add a Cycle</button></div>
                 {{ } else{  }}
                      <p>No Cycles in this patient regimen</p>
                      <button class = "addCycle" data-regimenId= {{-drug.regimenId}}><i class="icon-plus"></i>Add a Cycle</button>
                 {{ } }}
              </div>
          </div>
          
      {{ }); }}
</script>


<script id="default-template" type="text/template">
      <div class = "contItem">
        <div class = "inf">
            <div>Diagnosis:</div>
            <div>Staging: </div>
            <div>Grading: </div>
            <div>Doctor's notes:</div>
            <div>Vitals: </div>
        </div>
        <div class = "inf">
          <div>Breast Cancer</div>
            <div>Stage 2</div>
            <div>Grade 3</div>
            <div>The patient presents with stage 2 breast cancer and should begin a round of chemotherapy on the CHOP regimen </div>
            <div>Vitals: Previously recorded vitals link</div>
        </div>
    </div>
    <div><button id = "bt_start_regimen" class = "bt" onclick = "openForm()"><i class="icon-plus"></i>Start patient's regimen</button></div>
</script>

<script id="landing-chemo-template" type="text/template">
    <button class = "bt"><i class="icon-hand-left"></i>Select a Protocol and cycle</button>
</script>

<script id="chemo-template" type="text/template">
    <div class="chemoItem">
      <span class = "sidebar-title">
          <span id="test"><i class="icon-medicine"></i>  Pre-Medication </span>
          <i class="icon-plus add-drug" title="Add a pre-medication" onclick = "processClick(this)" data-tag = "pre-medication"></i>
      </span>
        <table id="preMedList">
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
            {{ _.each(cycleDrugs, function(drug, index) { }}
              {{ if(drug?.tag === "Pre-Medication"){ }}
                <tr style="border: 1px solid #eee;">
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">
                    {{=index+1}}
                    {{if(dispenseStatus === 'Pending Dispense') { }}
                           <input type="checkbox" id={{-drug.id}} name={{-drug.id}} value={{-drug.id}}>
                    {{ } }}
                  </td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.medication}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dose}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.route}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dosingUnit}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.comment}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">
                    <a><i id="stockOutList" class="icon-edit link row-actions"
                            title="Edit Drug"
                            onclick = "processClick(this)"
                            data-medication = '{{-drug.medication}}'
                            data-drugId = '{{-drug.id}}'
                            data-dose = '{{-drug.dose}}'
                            data-dosingUnit = '{{-drug.dosingUnit}}'
                            data-route = '{{-drug.route}}'
                            data-tag = '{{-drug.tag}}'
                            data-comment = '{{-drug.comment}}'></i></a>&nbsp;&nbsp;&nbsp;
                    <a><i class="icon-trash link row-actions" title="Delete Drug" onclick = "deleteCycleDrug(this)" data-drugId = {{-drug.id}} data-drugName = {{-drug.medication}}></i></a>
                  </td>
                </tr>
              {{ } }}
            {{ }); }}
          </tbody>
      </table>
    </div>

    <div class="chemoItem">
      <span class = "sidebar-title">
          <span><i class="icon-stethoscope"></i>  Chemotherapy</span>
          <i class="icon-plus add-drug" title="Add a chemotherapy drug" onclick = "processClick(this)" data-tag = "chemotherapy"></i>
      </span>
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
            {{ _.each(cycleDrugs, function(drug, index) { }}
              {{ if(drug?.tag === "Chemotherapy"){ }}
                <tr style="border: 1px solid #eee;">
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{=index+1}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.medication}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dose}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.route}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dosingUnit}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.comment}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">
                  <a><i id="stockOutList" class="icon-edit link row-actions"
                                              title="Edit Drug"
                                              onclick = "processClick(this)"
                                              data-medication = '{{-drug.medication}}'
                                              data-drugId = '{{-drug.id}}'
                                              data-dose = '{{-drug.dose}}'
                                              data-dosingUnit = '{{-drug.dosingUnit}}'
                                              data-route = '{{-drug.route}}'
                                              data-tag = '{{-drug.tag}}'
                                              data-comment = '{{-drug.comment}}'></i></a>&nbsp;&nbsp;&nbsp;
                                      <a><i class="icon-trash link row-actions" title="Delete Drug" onclick = "deleteCycleDrug(this)" data-drugId = {{-drug.id}} data-drugName = {{-drug.medication}}></i></a>
                  </td>
                </tr>
              {{ } }}
            {{ }); }}
          </tbody>
      </table>
    </div>


    <div class="chemoItem">
      <span class = "sidebar-title">
          <span id="test"><i class="icon-medicine"></i>  Post-Medication </span>
          <i class="icon-plus add-drug" title="Add a pre-medication" onclick = "processClick(this)" data-tag = "post-medication"></i>
      </span>
        <table id="postMedList">
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
            {{ _.each(cycleDrugs, function(drug, index) { }}
              {{ if(drug?.tag === "Post-Medication"){ }}
                <tr style="border: 1px solid #eee;">
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">
                    {{=index+1}}
                    {{if(dispenseStatus === 'Pending Dispense') { }}
                           <input type="checkbox" id={{-drug.id}} name={{-drug.id}} value={{-drug.id}}>
                    {{ } }}
                  </td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.medication}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dose}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.route}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dosingUnit}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.comment}}</td>
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">
                    <a><i id="stockOutList" class="icon-edit link row-actions"
                            title="Edit Drug"
                            onclick = "processClick(this)"
                            data-medication = '{{-drug.medication}}'
                            data-drugId = '{{-drug.id}}'
                            data-dose = '{{-drug.dose}}'
                            data-dosingUnit = '{{-drug.dosingUnit}}'
                            data-route = '{{-drug.route}}'
                            data-tag = '{{-drug.tag}}'
                            data-comment = '{{-drug.comment}}'></i></a>&nbsp;&nbsp;&nbsp;
                    <a><i class="icon-trash link row-actions" title="Delete Drug" onclick = "deleteCycleDrug(this)" data-drugId = {{-drug.id}} data-drugName = {{-drug.medication}}></i></a>
                  </td>
                </tr>
              {{ } }}
            {{ }); }}
          </tbody>
      </table>
    </div>

    <div class="chemoItem">
          <span class = "sidebar-title">
              <span><i class="icon-edit "></i>  Cycle Summary Notes</span>
          </span>
          <textarea id="summary_notes" name="summary_notes" rows="4" style="width: 100%;" placeholder = "Enter cycle summary notes here ...">{{-summaryNotes}}</textarea>

    </div>

    <div class="chemoItem">
            <label id= "btn-request-dispense"class="button confirm next" style="float: right; width: auto!important;" onclick = "processPrescription()">Save</label>
            <label id= "btn-administer-cycle" class="button confirm"
            style="float: right; width: auto!important; display: none!important;" onclick = "loadNext('outcome')">Administer</label>
            <label id= "btn-save-cycle" class="button cancel" style="width: auto!important;">Cancel Cycle</label>
    </div>
</script>


<script id="outcome-template" type="text/template">
    <div class="chemoItem">
      <span class = "sidebar-title">
          <span id="test"><i class="icon-medicine"></i>  Visit Outcome </span>
      </span>

        {{ _.each(cycleDetails.outcomes, function(oc, idx) { }}
            <input type="radio" id={{-oc.answerConcept.id }} name="cycle_outcome" value='{{-oc.answerConcept.name }}'>
            <label for={{-oc.answerConcept.id }}>{{-oc.answerConcept.name }}</label><br>
        {{ }); }}

    </div>
    <div class="chemoItem">
            <label  class="button confirm" style="float: right; width: auto!important;" onclick = "loadNext('summary')">Next</label>
            <label id= "btn-save-cycle" class="button cancel" style="width: auto!important;">Back</label>
    </div>
</script>


<script id="summary-template" type="text/template">
    <div class="chemoItem">
      <span class = "sidebar-title">
          <span id="test"><i class="icon-medicine"></i>  Visit Summary </span>
      </span>

      <div class = "contItem">
          <table>
            <tr>
              <td>Regimen</td>
              <td>{{-regimenName }}</td>
            </tr>
            <tr>
              <td>Cycle</td>
              <td>{{-cycleName }}</td>
            </tr>
            <tr>
              <td>Pre-Medication</td>
              <td>
                    {{ _.each(cycleDetails.cycleDrugs, function(cd, idx) { }}
                        {{ if (cd.tag === "Pre-Medication") { }}
                            <label>{{-cd.medication}}</label> <label>({{-cd.dose}}),</label>
                        {{ } }}
                    {{ }); }}
              </td>
            </tr>
            <tr>
              <td>Chemo Medication</td>
              <td>
                  {{ _.each(cycleDetails.cycleDrugs, function(cd, idx) { }}
                      {{ if (cd.tag === "Chemotherapy") { }}
                          <label>{{-cd.medication}}</label> <label>({{-cd.dose}}),</label>
                      {{ } }}
                  {{ }); }}
              </td>
            </tr>
            <tr>
              <td>Post-Medication</td>
              <td>
                {{ _.each(cycleDetails.cycleDrugs, function(cd, idx) { }}
                    {{ if (cd.tag === "Post-Medication") { }}
                        <label>{{-cd.medication}}</label> <label>({{-cd.dose}}),</label>
                    {{ } }}
                {{ }); }}
              </td>
            </tr>
            <tr>
              <td>Visit Outcome</td>
              <td>{{-outcome.name }}</td>
            </tr>
            <tr>
              <td>Cycle Notes</td>
              <td>{{-summaryNotes }}</td>
            </tr>
          </table>
      </div>

    </div>
    <div class="chemoItem">
            <label id= "btn-complete-cycle"  class="button confirm" style="float: right; width: auto!important;" onclick = "completeCycle()">Complete Cycle</label>
            <label id= "btn-save-cycle" class="button cancel" style="width: auto!important;">Cancel Cycle</label>
    </div>
</script>


<script>
	var cycleDrug = {drug: ko.observable(new CycleDrug())};
	ko.applyBindings(cycleDrug, jq("#prescription-dialog")[0]);
</script>
