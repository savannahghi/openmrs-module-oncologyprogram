package org.openmrs.module.treatmentapp.api;

import java.util.List;

import org.openmrs.Patient;

public interface MchEncounterService {
	
	List<String> getConditions(Patient patient);
}
