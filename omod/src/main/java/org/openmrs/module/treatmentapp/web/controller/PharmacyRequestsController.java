package org.openmrs.module.treatmentapp.web.controller;

import org.json.JSONArray;
import org.json.JSONObject;
import org.openmrs.Concept;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.model.Cycle;
import org.openmrs.module.hospitalcore.model.PatientRegimen;
import org.openmrs.module.hospitalcore.model.Regimen;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.v1_0.controller.BaseRestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

import java.util.Set;

@Controller
@RequestMapping(value = "/rest/" + RestConstants.VERSION_1 + "/pharmacyresponse")
public class PharmacyRequestsController extends BaseRestController {
	
	@RequestMapping(method = RequestMethod.GET)
	@ResponseBody
	public Object get(WebRequest request) {
		return new SimpleObject().add("sessionId", request.getSessionId()).add("authenticated", Context.isAuthenticated());
	}
	
	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	public Object post(@RequestBody String body, WebRequest request) {
		JSONObject jsonObject = new JSONObject(body);
		JSONArray medications = jsonObject.getJSONArray("medications");
		SimpleObject returnObject = new SimpleObject();
		returnObject.add("success", true);
		//		TODO process individual medications
		for (int i = 0; i < medications.length(); i++) {
			JSONObject medicationObject = medications.getJSONObject(i);
			int medicationId = medicationObject.getInt("id");
			String medication = medicationObject.getString("medication");
			String dose = medicationObject.getString("dose");
			String dosingUnit = medicationObject.getString("dosingUnit");
			String route = medicationObject.getString("route");
			String comment = medicationObject.getString("comment");
			String tag = medicationObject.getString("tag");
			String dispenseStatus = medicationObject.getString("dispenseStatus");
			
			returnObject.add("message",
			    updateMedicationStatus(medicationId, medication, dose, dosingUnit, route, comment, tag, dispenseStatus));
		}
		
		return returnObject;
	}
	
	private String updateMedicationStatus(int medicationId, String medication, String dose, String dosingUnit, String route,
	        String comment, String tag, String dispenseStatus) {
		
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		PatientRegimen patientRegimen = patientRegimenService.getPatientRegimenById(medicationId);
		
		//		TODO - Update for when a new drug is added by the pharmacist
		//		if (patientRegimen == null) {
		//			patientRegimen = new PatientRegimen();
		//		}
		
		//		Cycle cycle = patientRegimenService.getCycleById(patientRegimen.getCycleId().getId());
		
		//TODO		Default dispense status of processed
		Concept dispenseConcept = Context.getConceptService().getConceptByName(dispenseStatus);
		patientRegimen.setDispenseStatus(dispenseConcept);
		//		patientRegimen.setCycleId(cycle);
		patientRegimen.setComment(patientRegimen.getComment() + ": update => " + comment);
		patientRegimen.setTag(tag);
		//		TODO - Reconcile with CHAI on route concepts
		//		patientRegimen.setRoute(route);
		patientRegimen.setDose(dose);
		patientRegimen.setDosingUnit(dosingUnit);
		patientRegimen.setMedication(medication);
		PatientRegimen createdPatientRegimen = patientRegimenService.createPatientRegimen(patientRegimen);
		
		//		TODO - Do we want to replicate this?
		//		cycle.getPatientRegimens().add(createdPatientRegimen);
		//Update display string for the patient regimen
		//		if (cycle.getActive()) {
		//			Set<PatientRegimen> patientRegimens = cycle.getPatientRegimens();
		//			StringBuilder csvBuilder = new StringBuilder();
		//			String SEPARATOR = "/";
		//			for (PatientRegimen pr : patientRegimens) {
		//				if (pr.getTag().equals("Chemotherapy") && !pr.getVoided()) {
		//					csvBuilder.append(pr.getMedication());
		//					csvBuilder.append(SEPARATOR);
		//				}
		//			}
		//			String csv = csvBuilder.toString();
		//			csv = csv.substring(0, csv.length() - SEPARATOR.length());
		//			Regimen cycleRegimen = cycle.getRegimenId();
		//			cycleRegimen.setDisplayString(csv);
		//			patientRegimenService.updateRegimen(cycleRegimen);
		//		}
		
		return "Update successful for drug  ==> " + medicationId;
	}
	
}
