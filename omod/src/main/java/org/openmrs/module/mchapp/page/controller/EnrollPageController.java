package org.openmrs.module.mchapp.page.controller;

import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;

public class EnrollPageController {
	
	public void get(@RequestParam("patientId") Patient patient, @RequestParam(value = "queueId") Integer queueId,
	        PageModel model) {
		
		model.addAttribute("patient", patient);
		model.addAttribute("queueId", queueId);
		
		if (patient.getGender().equals("M")) {
			model.addAttribute("gender", "Male");
		} else {
			model.addAttribute("gender", "Female");
		}
		
		HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
		PatientSearch patientSearch = hospitalCoreService.getPatientByPatientId(patient.getPatientId());
		
		String patientType = hospitalCoreService.getPatientType(patient);
		
		model.addAttribute("patientType", patientType);
		model.addAttribute("patientSearch", patientSearch);
		model.addAttribute("previousVisit", hospitalCoreService.getLastVisitTime(patient));
		model.addAttribute(
		    "patientCategory",
		    patient.getAttribute(Context.getPersonService().getPersonAttributeTypeByUuid(
		        "09cd268a-f0f5-11ea-99a8-b3467ddbf779")));
		
		model.addAttribute("patientId", patient.getPatientId());
		model.addAttribute("date", new Date());
	}
	
}
