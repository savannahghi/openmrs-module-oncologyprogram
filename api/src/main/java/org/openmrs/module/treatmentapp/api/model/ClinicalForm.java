/**
 * 
 */
package org.openmrs.module.treatmentapp.api.model;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.treatmentapp.api.parsers.DrugOrdersParser;
import org.openmrs.module.treatmentapp.api.parsers.InvestigationParser;
import org.openmrs.module.treatmentapp.api.parsers.ObsDatetimeUpdater;
import org.openmrs.module.treatmentapp.api.parsers.ObsParser;

/**
 * Contains observations made by user
 */
public class ClinicalForm {
	
	private Patient patient;
	
	private List<Obs> observations = new ArrayList<Obs>();
	
	private ClinicalForm() {
	}
	
	public Patient getPatient() {
		return patient;
	}
	
	public List<Obs> getObservations() {
		return observations;
	}
	
	@SuppressWarnings("unchecked")
	public static ClinicalForm generateForm(HttpServletRequest request, Patient patient, String location)
	        throws ParseException {
		ClinicalForm form = new ClinicalForm();
		form.patient = patient;
		ObsParser obsParser = new ObsParser();
		for (Map.Entry<String, String[]> postedParams : ((Map<String, String[]>) request.getParameterMap()).entrySet()) {
			form.observations = obsParser.parse(form.observations, patient, postedParams.getKey(), postedParams.getValue());
		}
		if (request.getParameter("obsDatetime") != null) {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
			dateFormatter.setLenient(false);
			Date obsDatetime = dateFormatter.parse(request.getParameter("obsDatetime"));
			form.observations = ObsDatetimeUpdater.updateDatetime(form.observations, obsDatetime);
		}
		return form;
	}
	
}
