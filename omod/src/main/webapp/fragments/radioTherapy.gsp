<%
    ui.includeCss("ehrconfigs", "jquery.dataTables.min.css")
    ui.includeCss("ehrconfigs", "onepcssgrid.css")
    ui.includeCss("ehrconfigs", "referenceapplication.css")

    ui.includeCss("ehrinventoryapp", "main.css")
    ui.includeCss("ehrconfigs", "custom.css")

    ui.includeJavascript("kenyaui", "pagebus/simple/pagebus.js")
    ui.includeJavascript("kenyaui", "kenyaui-tabs.js")
    ui.includeJavascript("kenyaui", "kenyaui-legacy.js")
    ui.includeJavascript("ehrconfigs", "moment.js")
    ui.includeJavascript("ehrconfigs", "jquery.dataTables.min.js")
    ui.includeJavascript("ehrconfigs", "jq.browser.select.js")

    ui.includeJavascript("ehrconfigs", "knockout-2.2.1.js")
    ui.includeJavascript("ehrconfigs", "emr.js")
    ui.includeJavascript("ehrconfigs", "jquery.simplemodal.1.4.4.min.js")
%>

<script>
    var getJSON = function (dataToParse) {
        if (typeof dataToParse === "string") {
            return JSON.parse(dataToParse);
        }
        return dataToParse;
    }

    jq(function(){

        jq("#treatmentSubmit").click(function(event){
            jq().toastmessage({
                sticky: true
            });
            var savingMessage = jq().toastmessage('showSuccessToast', 'Please wait as Information is being Saved...');
            var treatmentFormData = {
                'patientId': jq('#treatmentPatientID').val(),
                'surgeryNotes' : jq('#surgeryNotes').val()
            };

            function successFn(successly_){
                jq().toastmessage('removeToast', savingMessage);
                jq().toastmessage('showSuccessToast', "Patient Treatment has been updated Successfully");
            }
            jq("#treatmentForm").submit(
                jq.ajax({
                    type: 'POST',
                    url: '${ ui.actionLink("treatmentapp", "radioTherapy", "radioTreatment") }',
                    data: treatmentFormData,
                    success: successFn,
                    dataType: "json"
                })
            );
        });

    });
</script>

<style>
.toast-item {
    background-color: #222;
}
#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
    text-decoration: none;
}
.name {
    color: #f26522;
}
.new-patient-header .demographics .gender-age {
    font-size: 14px;
    margin-left: -55px;
    margin-top: 12px;
}
.new-patient-header .demographics .gender-age span {
    border-bottom: 1px none #ddd;
}
.new-patient-header .identifiers {
    margin-top: 5px;
}
.tag {
    padding: 2px 10px;
}
.tad {
    background: #666 none repeat scroll 0 0;
    border-radius: 1px;
    color: white;
    display: inline;
    font-size: 0.8em;
    padding: 2px 10px;
}
.status-container {
    padding: 5px 10px 5px 5px;
}
.catg {
    color: #363463;
    margin: 25px 10px 0 0;
}
form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus,
.simple-form-ui section fieldset select:focus, .simple-form-ui section fieldset input:focus, .simple-form-ui section #confirmationQuestion select:focus, .simple-form-ui section #confirmationQuestion input:focus,
.simple-form-ui #confirmation fieldset select:focus, .simple-form-ui #confirmation fieldset input:focus, .simple-form-ui #confirmation #confirmationQuestion select:focus,
.simple-form-ui #confirmation #confirmationQuestion input:focus, .simple-form-ui form section fieldset select:focus, .simple-form-ui form section fieldset input:focus,
.simple-form-ui form section #confirmationQuestion select:focus, .simple-form-ui form section #confirmationQuestion input:focus, .simple-form-ui form #confirmation fieldset select:focus,
.simple-form-ui form #confirmation fieldset input:focus, .simple-form-ui form #confirmation #confirmationQuestion select:focus, .simple-form-ui form #confirmation #confirmationQuestion input:focus {
    outline: 0px none #007fff;
    box-shadow: 0 0 0 0 #888;
}
#formBreadcrumb{
    background: #fff;
}
#treatmentForm{
    background: #f9f9f9 none repeat scroll 0 0;
    margin-top: 3px;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    align-items: center;
}
#charges-info{
    display: flex;
    flex-direction: column;
    max-width: 1024px;
    width: 100%;
}
#confirmation {
    min-height: 250px;
    width: 100%;
    max-width: 1024px;
}
.tasks {
    background: white none repeat scroll 0 0;
    border: 1px solid #cdd3d7;
    border-radius: 4px;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    color: #404040;
    font: 14px/20px "Lucida Grande",Verdana,sans-serif;
    margin: 10px 0 0 4px;
    width: 98.6%;
}
.tasks-header {
    background: #f0f1f2 linear-gradient(to bottom, #f5f7fd, #e6eaec) repeat scroll 0 0;
    border-bottom: 1px solid #d1d1d1;
    border-radius: 3px 3px 0 0;
    box-shadow: 0 1px rgba(255, 255, 255, 0.5) inset, 0 1px rgba(0, 0, 0, 0.03);
    color: #f26522;
    line-height: 24px;
    padding: 7px 15px;
    position: relative;
    text-shadow: 0 1px rgba(255, 255, 255, 0.7);
}
.tasks-title {
    color: inherit;
    font-size: 14px;
    font-weight: bold;
    line-height: inherit;
}
.tasks-lists {
    color: transparent;
    font: 0px/0 serif;
    height: 3px;
    margin-top: -11px;
    padding: 10px 4px;
    position: absolute;
    right: 10px;
    text-shadow: none;
    top: 50%;
    width: 19px;
}
.tasks-lists::before {
    background: #8c959d none repeat scroll 0 0;
    border-radius: 1px;
    box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
    content: "";
    display: block;
    height: 3px;
}
.tasks-list {
    font: 13px/20px "Lucida Grande",Verdana,sans-serif;
}
.tasks-list-item {
    -moz-user-select: none;
    border-bottom: 1px solid #aaa;
    cursor: pointer;
    display: inline-block;
    line-height: 24px;
    margin-right: 20px;
    padding: 5px;
    width: 150px;
}
.tasks-list-cb {
    display: none;
}
.tasks-list-mark {
    border: 2px solid #c4cbd2;
    border-radius: 12px;
    display: inline-block;
    height: 20px;
    margin-right: 0;
    position: relative;
    vertical-align: top;
    width: 20px;
}
.tasks-list-mark::before {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    border-color: #39ca74;
    border-image: none;
    border-style: solid;
    border-width: 0 0 4px 4px;
    content: "";
    display: none;
    height: 4px;
    left: 50%;
    margin: -5px 0 0 -6px;
    position: absolute;
    top: 50%;
    transform: rotate(-45deg);
    width: 8px;
}
.tasks-list-cb:checked ~ .tasks-list-mark {
    border-color: #39ca74;
}
.tasks-list-cb:checked ~ .tasks-list-mark::before {
    display: block;
}
.tasks-list-desc {
    color: #555;
    font-weight: bold;
}
.tasks-list-cb:checked ~ .tasks-list-desc {
    color: #34bf6e;
}
.tasks-list input[type="radio"] {
    left: -9999px !important;
    position: absolute !important;
    top: -9999px !important;
}
.selectp{
    border-bottom: 1px solid darkgrey;
    margin: 7px 10px;
    padding-bottom: 3px;
    padding-left: 5px;
}
#investigationRemoveIcon,
#procedureRemoveIcon {
    float: right;
    color: #f00;
    cursor: pointer;
    margin: 2px 5px 0 0;
}
fieldset input[type="text"],
fieldset select {
    height: 45px
}
.title-label {
    color: #f26522;
    cursor: pointer;
    font-family: "OpenSansBold",Arial,sans-serif;
    font-size: 1.3em;
    padding-left: 5px;
}
.dialog-content ul li span{
    display: inline-block;
    width: 130px;
}
.dialog-content ul li input{
    width: 255px;
    padding: 5px 10px;
}
.dialog textarea {
    width: 255px;
}
.dialog select {
    display: inline-block;
    width: 255px;
}
.dialog select option {
    font-size: 1em;
}
.dialog .dialog-content li {
    margin-bottom: 3px;
}
.dialog select {
    margin: 0;
    padding: 5px;
}
#modal-overlay {
    background: #000 none repeat scroll 0 0;
    opacity: 0.4 !important;
}
#summaryTable tr:nth-child(2n), #summaryTable tr:nth-child(2n+1) {
    background: rgba(0, 0, 0, 0) none repeat scroll 0 0;
}
#summaryTable {
    margin: -5px 0 -6px;
}
#summaryTable tr, #summaryTable th, #summaryTable td {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    border-color: #eee;
    border-image: none;
    border-style: none none solid;
    border-width: 1px;
}
#summaryTable td:first-child {
    vertical-align: top;
    width: 180px;
}
</style>

<form class="zsimple-form-ui" id="treatmentForm" method="post">
    <section id="charges-info">
        <fieldset>
            <label class="label title-label" style="width: auto; padding-left: 5px;">
                RADIOTHERAPY NOTES
                <span class="important"></span>
            </label>

            <p>
                <textarea id="surgeryNotes" name="surgeryNotes" placeholder="Notes" style="height: 129px; width: 100%; resize: none;"></textarea>
                <input name="treatmentPatientID" id="treatmentPatientID" value="${patient.patientId}" type="hidden">
            </p>

        </fieldset>

    </section>

    <div id="confirmation" style="min-height: 250px;">
        <div id="confirmationQuestion" class="focused" style="margin-top:0px">
            <p style="display: none">
                <button class="button submit confirm" style="display: none;"></button>
            </p>

            <span value="Submit" class="button submit confirm right" id="treatmentSubmit" style="margin: 5px 20px;">
                <i class="icon-save small"></i>
                Save
            </span>

            <span id="cancelButton" class="button cancel" style="margin: 5px">
                <i class="icon-remove small"></i>
                Cancel
            </span>
        </div>
    </div>
</form>
