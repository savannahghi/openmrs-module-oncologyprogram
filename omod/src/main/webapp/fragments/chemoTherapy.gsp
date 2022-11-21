<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css" integrity="sha512-5PV92qsds/16vyYIJo3T/As4m2d8b6oWYfoqV+vtizRB6KhF1F9kYzWzQmsO6T3z3QG2Xdhrx7FQ+5R1LiQdUA==" crossorigin="anonymous" referrerpolicy="no-referrer" />


<script>

    jq(function(){
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
          const cycleId = chemoDetail.context.dataset.cycleid;
          jq(".cycle").removeClass("selected");
          jq(chemoDetail).addClass("selected");


          jq.getJSON('${ ui.actionLink("treatmentapp", "chemoTherapy" ,"getChemotherapyCycleDetails") }',
              { 'id' : cycleId }
          ).success(function (data) {

            if (data.drugs.length > 0) {
              var chemoTemplate =  _.template(jq("#chemo-template").html());
              jq("#defaultContainer").html(chemoTemplate(data));
            }
            else {
              var chemoTemplate =  _.template(jq("#default-template").html());
              jq("#defaultContainer").html(chemoTemplate(data));
            }

            jq("#opdRecordsPrintButton").show(100);
          })
        });

    });


function toggleCssClass(e){
  e.parentNode.parentNode.classList.toggle("open");
}

</script>

<style>

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

</style>

<div class = "man">
  <div id="sideBar" class = "sidebar">
  No current cycles in progress
  </div>
  <div id = "defaultContainer" class = "cont">

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
    <div><button id = "bt_start_regimen" class = "bt"><i class="icon-plus"></i>Start patient's regimen</button></div>
</script>

<script id="landing-chemo-template" type="text/template">
    <button class = "bt"><i class="icon-hand-left"></i>Select a Protocol and cycle</button>
</script>

<script id="chemo-template" type="text/template">
    <div class="info-header">
      <i class="icon-medicine"></i>
      <h3>DRUGS PRESCRIPTION SUMMARY INFORMATION</h3>
    </div>

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
        {{ _.each(drugs, function(drug, index) { }}
        <tr style="border: 1px solid #eee;">
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{=index+1}}</td>
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.medication}}</td>
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dose}}</td>
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.route}}</td>
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dosingUnit}}</td>
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.comment}}</td>
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;"><a><i id="stockOutList" class="icon-edit link" title="Edit Drug"></i></a>&nbsp;&nbsp;&nbsp;<a><i class="icon-trash link" title="Delete Drug"></i></a></td>
        </tr>
        {{ }); }}
      </tbody>
  </table>


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
          <td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;"><a><i id="stockOutList" class="icon-edit link" title="Edit Drug"></i></a>&nbsp;&nbsp;&nbsp;<a><i class="icon-trash link" title="Delete Drug"></i></a></td>
        </tr>
        {{ }); }}
      </tbody>
  </table>

</script>

