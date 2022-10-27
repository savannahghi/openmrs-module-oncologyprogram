package org.openmrs.module.mchapp.api.parsers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Concept;
import org.openmrs.Obs;
import org.openmrs.Patient;

public class DateTimeObsProcessor implements ObsProcessor {
	
	@Override
	public List<Obs> createObs(Concept question, String[] answers, Patient patient) throws ParseException {
		List<Obs> observations = new ArrayList<Obs>();
		for (int i = 0; i < answers.length; i++) {
			if (StringUtils.isNotBlank(answers[i])) {
				Obs obs = new Obs();
				obs.setConcept(question);
				SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
				dateFormatter.setLenient(false);
				Date valueDate = dateFormatter.parse(answers[i]);
				obs.setValueDatetime(valueDate);
				obs.setPerson(patient);
				obs.setObsDatetime(new Date());
				observations.add(obs);
			}
		}
		return observations;
	}
	
}
