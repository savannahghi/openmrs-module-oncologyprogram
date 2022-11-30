package org.openmrs.module.treatmentapp.page.controller;

import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.treatmentapp.EhrMchMetadata;
import org.openmrs.module.treatmentapp.api.ListItem;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.module.treatmentapp.api.TreatmentService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.page.PageModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;

public class MainPageController {
	
	private static final int MAX_CWC_DURATION = 5;
	
	private static final int MAX_ANC_PNC_DURATION = 9;
	
	protected Logger logger = LoggerFactory.getLogger(getClass());
	
	public String get(@RequestParam("patientId") Patient patient, @RequestParam(value = "queueId") Integer queueId,
	        PageModel model, FragmentConfiguration config, UiUtils uiUtils) {
		
		InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
		List<Regimen> regimens = inventoryCommonService.getRegimens(patient, null, false);
		
		List<SimpleObject> chemoProfile = new ArrayList<SimpleObject>();
		for (Regimen regimen : regimens) {
			SimpleObject profileInfo = new SimpleObject();
			profileInfo.put("name", regimen.getRegimenType().getName());
			profileInfo.put("icon", "icon-hospital");
			profileInfo.put("cycles", SimpleObject.fromCollection(regimen.getCycles(), uiUtils, "id", "name", "icon"));
			chemoProfile.add(profileInfo);
		}
		
		String details = SimpleObject.create("drugs", chemoProfile).toJson();
		
		model.addAttribute("regimens", regimens);
		model.addAttribute("patientCycles", details);
		TreatmentService mchService = Context.getService(TreatmentService.class);
		model.addAttribute("patient", patient);
		model.addAttribute("queueId", queueId);
		
		if (patient.getGender().equals("M")) {
			model.addAttribute("gender", "Male");
		} else {
			model.addAttribute("gender", "Female");
		}
		
		boolean enrolledInChemo = mchService.enrolledInChemo(patient);
		boolean enrolledInSurgery = mchService.enrolledInSurgery(patient);
		boolean enrolledInRadio = mchService.enrolledInRadio(patient);
		
		model.addAttribute("enrolledInChemo", enrolledInChemo);
		model.addAttribute("enrolledInSurgery", enrolledInSurgery);
		model.addAttribute("enrolledInRadio", enrolledInRadio);
		
		Program program = null;
		Calendar minEnrollmentDate = Calendar.getInstance();
		List<ListItem> possibleProgramOutcomes = new ArrayList<ListItem>();
		PatientQueueService queueService = Context.getService(PatientQueueService.class);
		OpdPatientQueue patientQueue = queueService.getOpdPatientQueueById(queueId);
		
		String opdConcept = null;
		if (patientQueue != null) {
			model.addAttribute("opdConcept", opdConcept);
		}
		
		if (enrolledInChemo) {
			model.addAttribute("title", "Chemotherapy");
			minEnrollmentDate.add(Calendar.MONTH, -MAX_ANC_PNC_DURATION);
			program = Context.getProgramWorkflowService().getProgramByUuid(EhrMchMetadata._MchProgram.ANC_PROGRAM);
			possibleProgramOutcomes = mchService.getPossibleOutcomes(program.getProgramId());
		} else if (enrolledInSurgery) {
			model.addAttribute("title", "Surgery");
			minEnrollmentDate.add(Calendar.MONTH, -MAX_ANC_PNC_DURATION);
			program = Context.getProgramWorkflowService().getProgramByUuid(EhrMchMetadata._MchProgram.PNC_PROGRAM);
			possibleProgramOutcomes = mchService.getPossibleOutcomes(program.getProgramId());
		} else if (enrolledInRadio) {
			model.addAttribute("title", "Radiotherapy");
			minEnrollmentDate.add(Calendar.MONTH, -MAX_ANC_PNC_DURATION);
			program = Context.getProgramWorkflowService().getProgramByUuid(EhrMchMetadata._MchProgram.PNC_PROGRAM);
			possibleProgramOutcomes = mchService.getPossibleOutcomes(program.getProgramId());
		} else {
			logger.error("No patient queue with stated ID");
		}
		
		//        TODO modify code to ensure that the last program enrolled is pulled
		List<PatientProgram> patientPrograms = Context.getProgramWorkflowService().getPatientPrograms(patient, program,
		    minEnrollmentDate.getTime(), null, null, null, false);
		
		//handles case when patient is yet to enroll in a patient program
		PatientProgram patientProgram = null;
		if (patientPrograms.size() > 0) {
			patientProgram = patientPrograms.get(0);
			//        TODO pull the correct enrollment Date
			model.addAttribute("enrollmentDate", patientProgram.getDateEnrolled());
		} else {
			patientProgram = new PatientProgram();
			model.addAttribute("enrollmentDate", new Date());
		}
		
		model.addAttribute("patientProgram", patientProgram);
		
		HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
		PatientSearch patientSearch = hospitalCoreService.getPatientByPatientId(patient.getPatientId());
		
		String patientType = hospitalCoreService.getPatientType(patient);
		
		model.addAttribute("patientType", patientType);
		model.addAttribute("patientSearch", patientSearch);
		model.addAttribute("previousVisit", hospitalCoreService.getLastVisitTime(patient));
		model.addAttribute("patientCategory", patient.getAttribute(14));
		//model.addAttribute("serviceOrderSize", serviceOrderList.size());
		model.addAttribute("patientId", patient.getPatientId());
		model.addAttribute("date", new Date());
		//  TODO add other patients attributes
		return null;
	}
	
	class ChemoWrapper {
		
		String name;
		
		String icon;
		
		List<PatientRegimen> cycles;
		
		public String getName() {
			return name;
		}
		
		public void setName(String name) {
			this.name = name;
		}
		
		public String getIcon() {
			return icon;
		}
		
		public void setIcon(String icon) {
			this.icon = icon;
		}
		
		public List<PatientRegimen> getCycles() {
			return cycles;
		}
		
		public void setCycles(List<PatientRegimen> cycles) {
			this.cycles = cycles;
		}
	}
}
