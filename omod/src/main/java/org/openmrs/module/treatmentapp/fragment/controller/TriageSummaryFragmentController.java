package org.openmrs.module.treatmentapp.fragment.controller;

import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.treatmentapp.EhrMchMetadata;
import org.openmrs.module.treatmentapp.api.MchService;
import org.openmrs.module.treatmentapp.api.TreatmentService;
import org.openmrs.module.treatmentapp.model.TriageDetail;
import org.openmrs.module.treatmentapp.model.TriageSummary;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

public class TriageSummaryFragmentController {
	
	public void controller(FragmentConfiguration config, FragmentModel model) {
		config.require("patientId");
		Integer patientId = Integer.parseInt(config.get("patientId").toString());
		PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
		
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		TreatmentService treatmentService = Context.getService(TreatmentService.class);
		EncounterType treatmentncType = null;
		
		if (treatmentService.enrolledInChemo(patient)) {
			treatmentncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata.TreatmentEncounterType.CHEMO_TRIAGE_ENCOUNTER_TYPE);
		} else if (treatmentService.enrolledInRadio(patient)) {
			treatmentncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata.TreatmentEncounterType.RADIO_TRIAGE_ENCOUNTER_TYPE);
		} else if (treatmentService.enrolledInSurgery(patient)) {
			treatmentncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata.TreatmentEncounterType.SURGERY_TRIAGE_ENCOUNTER_TYPE);
		}
		
		List<Encounter> encounters = dashboardService.getEncounter(patient, null, treatmentncType, null);
		
		List<TriageSummary> triageSummaries = new ArrayList<TriageSummary>();
		
		int i = 0;
		
		for (Encounter enc : encounters) {
			TriageSummary triageSummary = new TriageSummary();
			triageSummary.setVisitDate(enc.getDateCreated());
			triageSummary.setEncounterId(enc.getEncounterId());
			triageSummaries.add(triageSummary);
			i++;
			if (i >= 20) {
				break;
			}
		}
		model.addAttribute("patient", patient);
		model.addAttribute("triageSummaries", triageSummaries);
	}
	
	public SimpleObject getTriageSummaryDetails(@RequestParam("encounterId") Integer encounterId, UiUtils ui) {
		Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
		TriageDetail triageDetail = TriageDetail.create(encounter);
		
		SimpleObject triage = SimpleObject.fromObject(triageDetail, ui, "weight", "height", "temperature", "pulseRate",
		    "systolic", "daistolic", "muac", "growthStatus", "weightcategory");
		return SimpleObject.create("notes", triage);
	}
}
