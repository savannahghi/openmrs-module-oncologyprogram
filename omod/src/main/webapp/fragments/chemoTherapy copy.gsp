  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css" integrity="sha512-5PV92qsds/16vyYIJo3T/As4m2d8b6oWYfoqV+vtizRB6KhF1F9kYzWzQmsO6T3z3QG2Xdhrx7FQ+5R1LiQdUA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Load React. -->
    <!-- Note: when deploying, replace "development.js" with "production.min.js". -->
    <script src="https://unpkg.com/react@18/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js" crossorigin></script>


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
			var enrollTemplate =  _.template(jq("#enroll-template").html());
            jq("#chemo-detail").html(enrollTemplate());
		}

		/*jq('#ul-left-menu').slimScroll({
			allowPageScroll: false,
			height		   : '426px',
			distance	   : '11px',
			color		   : '#363463'
		});*/


        jq('#stockOutList').on("click", function(){
            var idnt = jq(this).data('idnt');

            jq.getJSON('${ ui.actionLink("treatmentapp", "storesOuts", "getImmunizationStockoutTransaction") }', {transactionId: idnt})
                .success(function (data) {
                    var depletedDate = data.depletedOn;

                    jq('#outsEditId').val(idnt);
                    jq('#outsEditName').val(data.name);
                    jq('#outsEditRemarks').val(data.remarks);

                    jq('#outsEditExpiry-field').val(moment(depletedDate).format('YYYY-MM-DD'));
                    jq('#outsEditExpiry-display').val(moment(depletedDate).format('DD MMM YYYY'));

                    stockoutsEditDialog.show();
                }
            );
        });

		jq('#ul-left-menu').scrollTop(0);
		jq('#slimScrollDiv').scrollTop(0);

const data = '[{"title":"General","icon":"bi-gear-fill","childrens":[{"title":"Home","icon":"bi-house-fill","path":"/"},{"title":"About","icon":"bi-info-circle-fill","path":"/about"},{"title":"Contact","icon":"bi-phone-fill","childrens":[{"title":"Facebook","icon":"bi-facebook"},{"title":"Twitter","icon":"bi-twitter"},{"title":"Instagram","icon":"bi-instagram"}]},{"title":"FAQ","icon":"bi-question-circle-fill"}]},{"title":"Account","icon":"bi-info-circle-fill","childrens":[{"title":"Login","path":"/login"},{"title":"Register","path":"/register"},{"title":"Forgot Password","path":"/forgot-password"},{"title":"Reset Password","path":"/reset-password"}]},{"title":"Profile","icon":"bi-person-fill","childrens":[{"title":"Profile","path":"/profile"},{"title":"Settings","childrens":[{"title":"Account","path":"/settings/account"},{"title":"Billing","childrens":[{"title":"Payment","path":"/settings/billing/payment"},{"title":"Subscription","path":"/settings/billing/subscription"}]},{"title":"Notifications","path":"/settings/notifications"}]},{"title":"Logout","path":"/logout"}]},{"title":"Advance","icon":"bi-view-list","childrens":[{"title":"Search","path":"/search"},{"title":"History","path":"/history"}]},{"title":"Support","icon":"bi-question-circle-fill","path":"/support"},{"title":"Report Bug","icon":"bi-bug","path":"/report-bug"}]';

const parsedData = JSON.parse(data);
let cycleFormed = false;

'use strict';

const e = React.createElement;

class SideBar extends React.Component{
    constructor(props) {
        super(props);
    }
    render(){
      const {addCycle,toggleAddCycle} = this.props;
      if(parsedData.length > 0){
        return e('div', { className: 'sidebar' },e('span', {className: "sidebar-header" }, e('i', {className: "icon-stethoscope" }),"  Chemotherapy"),parsedData.map((item,index) => { return e(SideBarItem,{item,key: index})}),e('button', { className: 'bt-side', onClick: () => toggleAddCycle() }, e('i', {className: "icon-plus" }), " Add a Cycle") )
      }else{
        return e('div', { className: 'sidebar' },"No current cycles in progress")
      }
        
    }
}

class SideBarItem extends React.Component{
    constructor(props) {
        super(props);
        this.state = { open: false };
      }

    render(){

    const {item} = this.props;
    if(item.childrens){
        const subs = item.childrens.map((item,index) => { return e(SideBarItem,{item,key: index})})
        return e('div', { className: this.state.open ? 'sidebar-item open' : 'sidebar-item'  },
            e('div', { className: 'sidebar-title' },
            e('span', { },
               item.icon && e('i', {className: item.icon }),item.title),
               e('i', { className: 'bi-chevron-down toggle-btn',  onClick: () => this.setState({open:!this.state.open}) })),
            e('div', { className: 'sidebar-content' },subs))
    }else{
      return  e('div', { className: 'sidebar-item plain'  },
            e('div', { className: 'sidebar-title' },
            e('span', { },
             item.icon &&  e('i', {className: item.icon }),item.title)),
            e('div', { className: 'sidebar-content' })
        )
      }

    }
}

class ChemoCycle extends React.Component{
  constructor(props){
    super(props);
    this.state = {
      premedications:[],
      chemotherapy:[],
      summaryNotes:"",
      outcome:""
    }

  }

  render(){

    let {cycleItem} = this.props.cycleItem;
    console.log(cycleItem)

    if(cycleItem){
      this.state.premedications = cycleItem.premedications;
      this.state.chemotherapy = cycleItem.premedications;
      this.state.summaryNotes = cycleItem.summaryNotes;
      this.state.outcome = cycleItem.outcome;
    }


    return e('div', { className: 'cont' },
    e('div', { className: 'contItem' },
      e('div', { className: 'inf' },
          e('div', { }, "Diagnosis:"),
          e('div', { }, "Staging: "),
          e('div', { }, "Grading: "),
          e('div', { }, "Doctor's notes:"),
          e('div', { }, "Vitals: ")),
      e('div', { className: 'inf' },
          e('div', { }, "Breast Cancer"),
          e('div', { }, "Stage 2"),
          e('div', { }, "Grade 3"),
          e('div', { }, "The patient presents with stage 2 breast cancer and should begin a round of chemotherapy on the CHOP regimen "),
          e('div', { }, "Vitals: Previously recorded vitals link"))),
      e('button', { className: 'bt' }, e('i', {className: "icon-plus" }), " Start patient's regimen"));
    
    
  }

}

class MainContainer extends React.Component{
  constructor(props){
    super(props);
  }

  render(){

    console.log(this.props.addCycle)

    if(parsedData.length > 0){
      return e('div', { className: 'cont' }, e('p', { className: 'inf' }, this.props.addCycle));
    }else{
      return e('div', { className: 'cont' },
      e('div', { className: 'contItem' },
        e('div', { className: 'inf' },
            e('div', { }, "Diagnosis:"),
            e('div', { }, "Staging: "),
            e('div', { }, "Grading: "),
            e('div', { }, "Doctor's notes:"),
            e('div', { }, "Vitals: ")),
        e('div', { className: 'inf' },
            e('div', { }, "Breast Cancer"),
            e('div', { }, "Stage 2"),
            e('div', { }, "Grade 3"),
            e('div', { }, "The patient presents with stage 2 breast cancer and should begin a round of chemotherapy on the CHOP regimen "),
            e('div', { }, "Vitals: Previously recorded vitals link"))),
        e('button', { className: 'bt' }, e('i', {className: "icon-plus" }), " Start patient's regimen"));
    }
    
  }
}


class ChemoContainer extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          addCycle:true
        }
    }

    toggleAddCycle =  () => {
      this.state = {
        addCycle: !this.state.addCycle
      };
    }

    render() {
        console.log(this.state.addCycle)
        return e('div',{ className: 'man' },e(SideBar,{addCycle: this.state.addCycle, toggleAddCycle: this.toggleAddCycle}), e(MainContainer,{addCycle: this.state.addCycle}));
    }
}

const domContainer = document.querySelector('#like_button_container');
const root = ReactDOM.createRoot(domContainer);
root.render(e(ChemoContainer));

	});

        var stockoutsEditDialog = emr.setupConfirmationDialog({
            dialogOpts: {
                overlayClose: false,
                close: true
            },
            selector: '#stockouts-dialog-edit',
            actions: {
                confirm: function () {
                    //Code Here
                    var stockoutsData = {
                        outsIdnt: jq("#outsEditId").val(),
                        depletionDate: jq("#outsEditExpiry-field").val(),
                        dateRestocked: jq("#outsEditRestocked-field").val(),
                        outsRemarks: jq("#outsEditRemarks").val()
                    }

                    if (jq.trim(stockoutsData.depletionDate) === "") {
                        jq().toastmessage('showErrorToast', "Check to ensure that Date Depleted been filled");
                        return false;
                    }

                    jq.getJSON('${ ui.actionLink("treatmentapp", "storesOuts", "updateImmunizationStockout") }', stockoutsData)
                        .success(function (data) {
                            if (data.status === "success") {
                                jq().toastmessage('showSuccessToast', data.message);
                                stockoutsEditDialog.close();
                                getStoreStockouts();
                            } else {
                                jq().toastmessage('showErrorToast', data.message);
                            }
                        }).error(function (xhr, status, err) {
                            jq().toastmessage('showErrorToast', "AJAX error!" + err);
                        }
                    );
                },
                cancel: function () {
                    stockoutsEditDialog.close();
                }
            }
        });
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

<style>

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
		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;"><a><i id="stockOutList" class="icon-edit link" title="Edit Drug"></i></a>&nbsp;&nbsp;&nbsp;<a><i class="icon-trash link" title="Delete Drug"></i></a></td>
	</tr>
	{{ }); }}
	</tbody>
</table>

</script>

<script id="enroll-template" type="text/template">
<div class="info-header">
	<div><span>Diagnosis</span><span>Breast Cancer</span></div>
	<div><span>Staging</span><span>Stage 2</span></div>
	<div><span>Grading</span><span>Grade 3</span></div>
	<div><span>Doctor's Notes</span><span>The patient presents with the stage 2 breast cancer and should begin a round of chemotherapy on CHOP program</span></div>
	<div><span>Vitals</span><span>Previously recorded vitals link</span></div>
</div>
<div><button>Start patient's regimen</button></div>
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
<div id="like_button_container"></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>