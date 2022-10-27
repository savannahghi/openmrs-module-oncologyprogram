package org.openmrs.module.mchapp.api.parsers;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;

import java.util.Date;
import java.util.List;

public class SendForExaminationParser {
	
	private static final String TRIAGE_ROOM_CONCEPT_UUID = "3362c0d1-75c5-495c-939d-3163a1e77791";
	
	private static final String EXAM_ROOM_CONCEPT_UUID = "1acb3707-9e03-40e3-b157-ce28451c3fd0";
	
	private static final String IMMUNIZATION_ROOM_CONCEPT_UUID = "f00b4314-cec5-4ce7-b0cd-c43e8deea664";
	
	public static OpdPatientQueue parse(String referParamKey, String[] referParamValue, Patient patient, String visitStatus) {
		
		Concept mchTriageConcept = Context.getConceptService().getConceptByUuid(TRIAGE_ROOM_CONCEPT_UUID);
		Concept mchExamRoomConcept = Context.getConceptService().getConceptByUuid(EXAM_ROOM_CONCEPT_UUID);
		Concept mchImmunizationRoomConcept = Context.getConceptService().getConceptByUuid(IMMUNIZATION_ROOM_CONCEPT_UUID);
		OpdPatientQueue opdPatient = new OpdPatientQueue();
		if (StringUtils.equalsIgnoreCase(referParamKey, "send_for_examination") && referParamValue.length > 0) {
			List<PersonAttribute> pas = Context.getService(HospitalCoreService.class).getPersonAttributes(
			    patient.getPatientId());
			String selectedCategory = "";
			for (PersonAttribute pa : pas) {
				PersonAttributeType attributeType = pa.getAttributeType();
				if (attributeType.equals(Context.getPersonService().getPersonAttributeTypeByUuid(
				    "09cd268a-f0f5-11ea-99a8-b3467ddbf779"))) {
					selectedCategory = pa.getValue();
				}
			}
			OpdPatientQueue queue = new OpdPatientQueue();
			queue.setPatient(patient);
			queue.setCreatedOn(new Date());
			queue.setBirthDate(patient.getBirthdate());
			queue.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
			if (StringUtils.equalsIgnoreCase(referParamValue[0], EXAM_ROOM_CONCEPT_UUID)) {
				queue.setOpdConcept(mchExamRoomConcept);
				queue.setOpdConceptName(mchExamRoomConcept.getName().getName());
			} else if (StringUtils.equalsIgnoreCase(referParamValue[0], IMMUNIZATION_ROOM_CONCEPT_UUID)) {
				queue.setOpdConcept(mchImmunizationRoomConcept);
				queue.setOpdConceptName(mchImmunizationRoomConcept.getName().getName());
			}
			if (patient.getMiddleName() != null) {
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName() + " "
				        + patient.getMiddleName().replace(",", " "));
			} else {
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName());
			}
			queue.setReferralConcept(mchTriageConcept);
			queue.setReferralConceptName(mchTriageConcept.getName().getName());
			queue.setSex(patient.getGender());
			queue.setTriageDataId(null);
			queue.setCategory(selectedCategory);
			queue.setVisitStatus(visitStatus);
			opdPatient = Context.getService(PatientQueueService.class).saveOpdPatientQueue(queue);
		}
		return opdPatient;
	}
	
}
