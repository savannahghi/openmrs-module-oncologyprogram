package org.openmrs.module.treatmentapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;

public class RadioTherapyFragmentController {
	
	public void get(@RequestParam("patientId") Patient patient, PageModel model) {
		model.addAttribute("patient", patient);
	}
	
	public void radioTreatment(@RequestParam(value = "patientId", required = false) Integer patientId,
	        @RequestParam(value = "physicalExamination", required = false) String physicalExamination) {
		
		HospitalCoreService hcs = (HospitalCoreService) Context.getService(HospitalCoreService.class);
		PatientQueueService surgeryService = Context.getService(PatientQueueService.class);
		OpdPatientQueueLog admitted = surgeryService.getOpdPatientQueueLogById(patientId);
		Patient patient = Context.getPatientService().getPatient(patientId);
		User user = Context.getAuthenticatedUser();
		Date date = new Date();
		PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
		Concept cPhysicalExamination = Context.getConceptService().getConceptByUuid("1391AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		
		Obs obsGroup = null;
		obsGroup = hcs.getObsGroupCurrentDate(patient.getPersonId());
		Encounter encounter = new Encounter();
		encounter = admitted.getEncounter();
		
		if (StringUtils.isNotBlank(physicalExamination)) {
			Obs obs = new Obs();
			obs.setObsGroup(obsGroup);
			obs.setConcept(cPhysicalExamination);
			obs.setValueText(physicalExamination);
			obs.setCreator(user);
			obs.setDateCreated(date);
			obs.setEncounter(encounter);
			obs.setPerson(patient);
			encounter.addObs(obs);
			Context.getEncounterService().saveEncounter(encounter);
		}
	}
}
