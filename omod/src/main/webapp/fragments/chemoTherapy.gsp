<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css" integrity="sha512-5PV92qsds/16vyYIJo3T/As4m2d8b6oWYfoqV+vtizRB6KhF1F9kYzWzQmsO6T3z3QG2Xdhrx7FQ+5R1LiQdUA==" crossorigin="anonymous" referrerpolicy="no-referrer" />


<script>

let cycleId;
function toggleCssClass(e){
  e.parentNode.parentNode.classList.toggle("open");
}

    function processClick(e){
        const {medication, dose,dosingunit,route,tag, comment} = e.dataset;
        document.getElementById("prescription-dialog").style.display = "block";
        document.getElementById("drugName").value = medication;
        document.getElementById("comment").value = comment;
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



        jq(".cycle").on("click",  function(){
          jq("#defaultContainer").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
          var chemoDetail = jq(this);
          cycleId = chemoDetail.context.dataset.cycleid;
          jq(".cycle").removeClass("selected");
          jq(chemoDetail).addClass("selected");


          jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"getChemotherapyCycleDetails") }',
              { 'id' : cycleId }
          ).success(function (data) {
              console.log(data);
              var chemoTemplate =  _.template(jq("#chemo-template").html());
              jq("#defaultContainer").html(chemoTemplate(data));
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


        jq("#test").on("click", function (e) {
            console.log()
        });

        console.log("=======================");
        console.log(${patient.patientId});

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
             console.log(data);
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
             console.log(data);
             location.reload();
           })
             .fail(function() { console.log("error occurred while fetching cycle details"); })
             .always(function() { console.log("Completed fetching cycle details"); });
           }

        function addDrug(){
            var drugName = jq("#drugName").val();
            var drugDosage = {};
            drugDosage.id = jq("#drugDosageSelect option:selected").val();
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
            var drugId = jq("#drugName").data("drugId");

          jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"addCycleMedication") }',
              { cycleId,
              drugId,
              drugName,
              "dosage":drugDosage.text,
              "dosageUnit":dosageUnit.text,
              "route":routesSelect.text,
              "tag":tagSelect.text,
              comment
               }
          ).success(function (data) {
              console.log(data);
              var chemoTemplate =  _.template(jq("#chemo-template").html());
              jq("#defaultContainer").html(chemoTemplate(data));
          })
          .fail(function() { console.log("error occurred while fetching cycle details"); })
          .always(function() { console.log("Completed fetching cycle details"); });
        }

    function openForm() {
      document.getElementById("myForm").style.display = "block";
    }

    function closeForm() {
      document.getElementById("myForm").style.display = "none";
    }

    function submitForm(){
        const regimen = document.getElementById("regimen").value;
        const cycle = document.getElementById("cycle").value;
        const days = document.getElementById("days").value;
        document.getElementById("myForm").style.display = "none";
        jq("#defaultContainer").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
        jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"createPatientRegimen") }',
              { 'patientId':${patient.patientId},'regimenId' : regimen,'cycle':cycle,'days':days }
          ).success(function (data) {
              console.log(data);
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









</script>

<style>
	.error{
		border: 1px solid #f00 !important;
	}
.man{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    height: 70vh;
    display: flex;
    color: #agf;
}

.sidebar{
    width: 260px;
    flex-shrink: 0;
    background-color: rgba(22,22,22,0.4);
    height: 100%;
    overflow: auto;
}

.cont{
  flex-grow: 1;
  padding: 2em;
  background-image: radial-gradient(rgba(0, 0, 0, .4), rgba(0, 0, 0, .8)), url('../public/banner.png');
  background-size: cover;
  background-position: center;
  display: flex;
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

.row-actions:hover{
  background-color: rgba(255, 255, 255, .1);
  cursor: pointer;
}


.sidebar-item.selected{
  background-color: rgba(255, 255, 255, .1);
}


.sidebar-title{
  display: flex;
  font-size: 1.2em;
  justify-content: space-between;
}
.sidebar-title span i{
  display: inline-block;
  width: 1.5em;
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


</style>

<div class = "man">
  <div id="sideBar" class = "sidebar">
  No current cycles in progress
  </div>
  <div id = "defaultContainer" class = "cont">

  </div>
</div>

<div class="form-popup" id="myForm" style = "display:none">

  <form class="form-container">
    <h3 align = "center">Regimen</h3>
    <label for="regimen"><b>Regimen</b></label>
    <select name="regimen" id="regimen" required>
        <option value=""></option>
        <option value="1">ACT Protocol</option>
        <option value="2">CHOP Protocol</option>
    </select>

    <label for="cycle"><b>Cycle</b></label>
    <select name="cycle" id="cycle" required>
        <option value=""></option>
        <option value="1">Cycle 1 of 6</option>
        <option value="2">Cycle 2 of 6</option>
    </select>

    <label for="days"><b>Days</b></label>
    <select name="days" id="days" required>
        <option value=""></option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
        <option value="6">6</option>
    </select>

    <button type="submit" class="button confirm" style="float: right; width: auto!important;" onclick="submitForm()">Confirm</button>
    <button type="button" class="button cancel" onclick="closeForm()" style="width: auto!important;">Cancel</button>
  </form>
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

        <h3>Prescription</h3>
    </div>

    <div class="dialog-content">
        <form id="drugForm">
            <ul>
                <li>
                    <label>Drug<span class="important">*<span></label>
                    <input class="drug-name" id="drugName" type="text">
                </li>
                <li>
                    <label>Dosage<span class="important">*<span></label>
                    <select id="drugDosageSelect" style="width: 125px !important;">
                        <option value="0">Select Dosage</option>
                        <option value="1">My Dosage</option>
                    </select>
                    <select id="drugUnitsSelect" style="width: 125px !important;">
                        <option value="0">Select Unit</option>
                        <option value="0">My Unit</option>
                    </select>
                </li>

                <li>
                    <label>Route<span class="important">*<span></label>
                    <select id="routesSelect">
                        <option value="0">Select Route</option>
                        <option value="0">My Route</option>
                    </select>
                </li>
                <li>
                    <label>Category<span class="important">*<span></label>
                    <select id="tagSelect">
                        <option value="0">Select Category</option>
                        <option value="1">Pre-Medication</option>
                        <option value="2">Chemotherapy</option>
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
      </span>
      {{ _.each(drugs, function(drug, index) { }}
          <div id = {{-drug.name}} class = "sidebar-item">
              <div class = "sidebar-title"> 
                  <span> 
                    <i class= {{-drug.icon}} ></i>  {{-drug.name}}
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
                            </span>
                        </div>
                      </div>
                  {{ }); }}
                  <div class = "sidebar-item"><button><i class="icon-plus"></i>Add a Cycle</button></div>

                 {{ } else{  }}
                      <p>No Cycles in this patient regimen</p>
                      <button><i class="icon-plus"></i>Add a Cycle</button>
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
                  <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;"><a><i id="stockOutList" class="icon-edit link row-actions" title="Edit Drug" onclick = "processClick(this)"></i></a>&nbsp;&nbsp;&nbsp;<a><i class="icon-trash link row-actions" title="Delete Drug"></i></a></td>
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
          <textarea id="w3review" name="w3review" rows="4" style="width: 100%;" placeholder = "Enter cycle summary notes here ..." />

    </div>

    <div class="chemoItem">
            <label  class="button confirm" style="float: right; width: auto!important;">Save</label>
            <label id= "btn-administer-cycle" class="button confirm" style="float: right; width: auto!important; display: none!important;">Administer</label>
            <label id= "btn-save-cycle" class="button cancel" style="width: auto!important;">Cancel Cycle</label>
    </div>
</script>


<script id="outcome-template" type="text/template">
    <div class="chemoItem">
      <span class = "sidebar-title">
          <span id="test"><i class="icon-medicine"></i>  Visit Outcome </span>
      </span>

      <form id = "outcome-form">
        <input type="radio" id="stable" name="chemo-outcome" value="Stable Disease">
        <label for="stable">Stable Disease</label><br>
        <input type="radio" id="progressed" name="chemo-outcome" value="Progressed">
        <label for="progressed">Progressed:</label><br>
        <input type="radio" id="partial-remission" name="chemo-outcome" value="Partial Remission">
        <label for="partial-remission">Partial Remission</label><br><br>
        <input type="radio" id="complete-remission" name="chemo-outcome" value="Complete Remission">
        <label for="complete-remission">Complete Remission</label><br><br>
      </form>

    </div>
    <div class="chemoItem">
            <label  class="button confirm" style="float: right; width: auto!important;">Save</label>
            <label id= "btn-administer-cycle" class="button confirm" style="float: right; width: auto!important; display: none!important;">Administer</label>
            <label id= "btn-save-cycle" class="button cancel" style="width: auto!important;">Cancel Cycle</label>
    </div>
</script>


<script id="summary-template" type="text/template">
    <div class="chemoItem">
      <span class = "sidebar-title">
          <span id="test"><i class="icon-medicine"></i>  Visit Summary </span>
      </span>

      <div class = "contItem">
        <div class = "inf">
            <div>Regimen:</div>
            <div>Cycle: </div>
            <div>Premedication: </div>
            <div>Chemo Medication:</div>
            <div>Visit Outcome:</div>
            <div>Cycle Notes: </div>
        </div>
        <div class = "inf">
            <div>Breast Cancer</div>
            <div>Stage 2</div>
            <div>Grade 3</div>
            <div>The patient presents with stage 2 breast cancer and should begin a round of chemotherapy on the CHOP regimen </div>
            <div>Stable disease </div>
            <div>Vitals: Previously recorded vitals link</div>
        </div>
      </div>

    </div>
    <div class="chemoItem">
            <label  class="button confirm" style="float: right; width: auto!important;">Save</label>
            <label id= "btn-administer-cycle" class="button confirm" style="float: right; width: auto!important; display: none!important;">Administer</label>
            <label id= "btn-save-cycle" class="button cancel" style="width: auto!important;">Cancel Cycle</label>
    </div>
</script>
