package org.openmrs.module.treatmentapp.api;

import org.openmrs.Encounter;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.APIException;
import org.openmrs.module.treatmentapp.api.model.ClinicalForm;
import org.openmrs.ui.framework.SimpleObject;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

public interface TreatmentService {
	
	boolean enrolledInChemo(Patient patient);
	
	SimpleObject enrollInChemo(Patient patient, Date dateEnrolled);
	
	boolean enrolledInRadio(Patient patient);
	
	SimpleObject enrollInRadio(Patient patient, Date dateEnrolled);
	
	boolean enrolledInSurgery(Patient patient);
	
	SimpleObject enrollInSurgery(Patient patient, Date dateEnrolled);
	
	Encounter saveTreatmentEncounter(ClinicalForm form, String encounterType, Location location, Integer visitTypeId);
	
	Encounter saveTreatmentEncounter(ClinicalForm form, String encounterType, Location location);
	
	List<Obs> getPatientProfile(Patient patient, String program);
	
	List<Obs> getHistoricalPatientProfile(Patient patient, String programUuid);
	
	List<ListItem> getPossibleOutcomes(Integer programId);
	
	public void updatePatientProgram(Integer patientProgramId, String enrollmentDateYmd, String completionDateYmd,
	        Integer locationId, Integer outcomeId) throws ParseException;
	
	public List<Object> findVisitsByPatient(Patient patient, boolean includeInactive, boolean includeVoided,
	        Date dateEnrolled) throws APIException;
}
