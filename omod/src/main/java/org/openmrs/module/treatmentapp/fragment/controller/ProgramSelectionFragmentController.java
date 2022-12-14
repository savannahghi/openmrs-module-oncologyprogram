package org.openmrs.module.treatmentapp.fragment.controller;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.treatmentapp.EhrMchMetadata;
import org.openmrs.module.treatmentapp.api.MchService;
import org.openmrs.module.treatmentapp.api.TreatmentService;
import org.openmrs.module.treatmentapp.api.model.ClinicalForm;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestParam;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class ProgramSelectionFragmentController {
	
	protected Logger logger = LoggerFactory.getLogger(ProgramSelectionFragmentController.class);
	
	public void controller(FragmentConfiguration config, FragmentModel model) {
		config.require("queueId");
		
		Concept modeOfDelivery = Context.getConceptService().getConceptByUuid(EhrMchMetadata._MchProgram.PNC_DELIVERY_MODES);
		List<SimpleObject> modesOfDelivery = new ArrayList<SimpleObject>();
		for (ConceptAnswer answer : modeOfDelivery.getAnswers()) {
			modesOfDelivery.add(SimpleObject.create("uuid", answer.getAnswerConcept().getUuid(), "label", answer
			        .getAnswerConcept().getDisplayString()));
		}
		
		model.addAttribute("queueId", config.get("queueId"));
		model.addAttribute("source", config.get("source"));
		model.addAttribute("deliveryMode", modesOfDelivery);
	}
	
	public SimpleObject enrollInAnc(@RequestParam("patientId") Patient patient,
	        @RequestParam("dateEnrolled") String dateEnrolledAsString, UiSessionContext session, HttpServletRequest request) {
		TreatmentService mchService = Context.getService(TreatmentService.class);
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		Date dateEnrolled;
		try {
			ClinicalForm form = ClinicalForm.generateForm(request, patient, null);
			dateEnrolled = dateFormatter.parse(dateEnrolledAsString);
			mchService.enrollInChemo(patient, dateEnrolled);
			Encounter encounter = Context.getService(TreatmentService.class).saveTreatmentEncounter(
			    form,
			    EhrMchMetadata._MchEncounterType.ANC_TRIAGE_ENCOUNTER_TYPE,
			    Context.getService(KenyaEmrService.class).getDefaultLocation(),
			    Context.getVisitService().getVisitTypeByUuid(EhrMchMetadata._VistTypes.INITIAL_MCH_CLINIC_VISIT)
			            .getVisitTypeId());
			
			return SimpleObject.create("status", "success", "message", patient + " has been enrolled into Chemo");
		}
		catch (ParseException e) {
			logger.error(e.getMessage());
			return SimpleObject
			        .create("status", "error", "message", dateEnrolledAsString + " is not in the correct format.");
		}
	}
	
	public SimpleObject enrollInPnc(@RequestParam("patientId") Patient patient,
	        @RequestParam("dateEnrolled") String dateEnrolledAsString, UiSessionContext session, HttpServletRequest request) {
		TreatmentService mchService = Context.getService(TreatmentService.class);
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		Date dateEnrolled;
		try {
			ClinicalForm form = ClinicalForm.generateForm(request, patient, null);
			dateEnrolled = dateFormatter.parse(dateEnrolledAsString);
			mchService.enrollInRadio(patient, dateEnrolled);
			Encounter encounter = Context.getService(TreatmentService.class).saveTreatmentEncounter(form,
			    EhrMchMetadata._MchEncounterType.PNC_TRIAGE_ENCOUNTER_TYPE,
			    Context.getService(KenyaEmrService.class).getDefaultLocation(),
			    EhrMchMetadata.getInitialMCHClinicVisitTypeId());
			
			return SimpleObject.create("status", "success", "message", patient + " has been enrolled into Radio");
		}
		catch (ParseException e) {
			logger.error(e.getMessage());
			return SimpleObject
			        .create("status", "error", "message", dateEnrolledAsString + " is not in the correct format.");
		}
	}
	
	public SimpleObject enrollInCwc(@RequestParam("patientId") Patient patient,
	        @RequestParam("dateEnrolled") String dateEnrolledAsString) {
		TreatmentService mchService = Context.getService(TreatmentService.class);
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
		Date dateEnrolled;
		try {
			dateEnrolled = dateFormatter.parse(dateEnrolledAsString);
			//TODO add method to enroll in CWC and call from here
			return mchService.enrollInSurgery(patient, dateEnrolled);
		}
		catch (ParseException e) {
			logger.error(e.getMessage());
			return SimpleObject
			        .create("status", "error", "message", dateEnrolledAsString + " is not in the correct format.");
		}
	}
	
}
