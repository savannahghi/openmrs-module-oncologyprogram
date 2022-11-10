package org.openmrs.module.treatmentapp.fragment.controller;

import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.treatmentapp.EhrMchMetadata;
import org.openmrs.module.treatmentapp.api.MchService;
import org.openmrs.module.treatmentapp.model.VisitSummary;
import org.openmrs.module.treatmentapp.model.PatientRegimen;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

/**
 * Chemotherapy Workflow
 */
public class ChemoTherapyFragmentController {
	
	protected Logger log = LoggerFactory.getLogger(ChemoTherapyFragmentController.class);
	
	public void controller(FragmentConfiguration config, FragmentModel model) {
		config.require("patientId");
		Integer patientId = Integer.parseInt(config.get("patientId").toString());
		
		PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		//		TODO - Create these
		/*
		PatientRegimenService patientRegimenService = Context.getService(PatientRegimenService.class);
		//getRegimens takes a mandatory patient, and optional regimen type and tag
		List<PatientRegimen> patientRegimens = patientRegimenService.getRegimens(patient,regimen,tag,cycleId);

		List<RegimenType> regimenTypes = patientRegimenService.getRegimenTypes(voided:false); //voided = true/false


		 */
		
		MchService mchService = Context.getService(MchService.class);
		EncounterType mchEncType = null;
		
		if (mchService.enrolledInANC(patient)) {
			mchEncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata._MchEncounterType.ANC_ENCOUNTER_TYPE);
		} else if (mchService.enrolledInPNC(patient)) {
			mchEncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata._MchEncounterType.PNC_ENCOUNTER_TYPE);
		} else {
			mchEncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata._MchEncounterType.CWC_ENCOUNTER_TYPE);
		}
		
		List<Encounter> encounters = dashboardService.getEncounter(patient, null, mchEncType, null);
		
		List<VisitSummary> visitSummaries = new ArrayList<VisitSummary>();
		
		int i = 0;
		
		for (Encounter enc : encounters) {
			VisitSummary visitSummary = new VisitSummary();
			visitSummary.setVisitDate(enc.getDateCreated());
			visitSummary.setEncounterId(enc.getEncounterId());
			Concept outcomeConcept = Context.getConceptService().getConcept("Visit outcome");
			for (Obs obs : enc.getAllObs()) {
				if (obs.getConcept().equals(outcomeConcept)) {
					visitSummary.setOutcome(obs.getValueText());
				}
			}
			visitSummaries.add(visitSummary);
			
			i++;
			
			if (i >= 20) {
				break;
			}
		}
		model.addAttribute("patient", patient);
		model.addAttribute("programSummaries", visitSummaries);
		//		model.addAttribute("programSummaries", patientRegimens);
		//		model.addAttribute("regimens", regimenTypes);
	}
	
	//	public SimpleObject getProgramSummaryDetails(@RequestParam("cycleId") Integer cycle, UiUtils ui) {
	public SimpleObject getProgramSummaryDetails(@RequestParam("encounterId") Integer encounterId, UiUtils ui) {
		
		List<PatientRegimen> chemoDetails = new ArrayList<PatientRegimen>();
		// TODO - Create these
		/*
		PatientRegimenService patientRegimenService = Context.getService(PatientRegimenService.class);
		//getRegimens takes a mandatory patient, and optional regimen type and tag
		List<PatientRegimen> patientRegimens = patientRegimenService.getRegimens(patient,regimen,tag,cycle);

		 */
		chemoDetails.add(new PatientRegimen(1, "Sodium Chloride", "750 ml", "Oral", "Vial", "Before Meals",
		        "Pre Medication", "CHOP Protocol Cycles"));
		List<SimpleObject> drugs = SimpleObject.fromCollection(chemoDetails, ui, "id", "medication", "dose", "route",
		    "dosingUnit", "comment", "tag", "program");
		//		return SimpleObject.create("chemoDetails", chemoDetails);
		return SimpleObject.create("drugs", drugs);
	}
	
	public SimpleObject updatePatientRegimen(@RequestParam("regimenId") Integer regimenId, UiUtils ui) {
		
		List<PatientRegimen> chemoDetails = new ArrayList<PatientRegimen>();
		// TODO - Create these
		/*
		PatientRegimenService patientRegimenService = Context.getService(PatientRegimenService.class);
		//getRegimens takes a mandatory patient, and optional regimen type and tag
		List<PatientRegimen> patientRegimens = patientRegimenService.getRegimens(patient,regimen,tag,cycle);

		 */
		chemoDetails.add(new PatientRegimen(1, "Sodium Chloride", "750 ml", "Oral", "Vial", "Before Meals",
		        "Pre Medication", "CHOP Protocol Cycles"));
		List<SimpleObject> drugs = SimpleObject.fromCollection(chemoDetails, ui, "id", "medication", "dose", "route",
		    "dosingUnit", "comment", "tag", "program");
		//		return SimpleObject.create("chemoDetails", chemoDetails);
		return SimpleObject.create("drugs", drugs);
	}
	
	public SimpleObject deletePatientRegimen(@RequestParam("regimenId") Integer regimenId, UiUtils ui) {
		
		List<PatientRegimen> chemoDetails = new ArrayList<PatientRegimen>();
		// TODO - Create these
		/*
		PatientRegimenService patientRegimenService = Context.getService(PatientRegimenService.class);
		//getRegimens takes a mandatory patient, and optional regimen type and tag
		List<PatientRegimen> patientRegimens = patientRegimenService.getRegimens(patient,regimen,tag,cycle);

		 */
		chemoDetails.add(new PatientRegimen(1, "Sodium Chloride", "750 ml", "Oral", "Vial", "Before Meals",
		        "Pre Medication", "CHOP Protocol Cycles"));
		List<SimpleObject> drugs = SimpleObject.fromCollection(chemoDetails, ui, "id", "medication", "dose", "route",
		    "dosingUnit", "comment", "tag", "program");
		//		return SimpleObject.create("chemoDetails", chemoDetails);
		return SimpleObject.create("drugs", drugs);
	}
	
}
