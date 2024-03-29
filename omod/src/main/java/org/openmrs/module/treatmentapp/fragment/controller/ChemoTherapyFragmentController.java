package org.openmrs.module.treatmentapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.treatmentapp.EhrMchMetadata;
import org.openmrs.module.treatmentapp.api.TreatmentService;
import org.openmrs.module.treatmentapp.model.VisitSummary;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.*;

/**
 * Chemotherapy Workflow
 */
public class ChemoTherapyFragmentController {
	
	protected Logger log = LoggerFactory.getLogger(ChemoTherapyFragmentController.class);
	
	public void controller(FragmentConfiguration config, FragmentModel model) {
		config.require("patientId");
		Integer patientId = Integer.parseInt(config.get("patientId").toString());
		
		PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		TreatmentService mchService = Context.getService(TreatmentService.class);
		EncounterType mchEncType = null;
		
		if (mchService.enrolledInChemo(patient)) {
			mchEncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata._MchEncounterType.ANC_ENCOUNTER_TYPE);
		} else if (mchService.enrolledInRadio(patient)) {
			mchEncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata._MchEncounterType.PNC_ENCOUNTER_TYPE);
		} else if (mchService.enrolledInSurgery(patient)) {
			mchEncType = Context.getEncounterService().getEncounterTypeByUuid(
			    EhrMchMetadata._MchEncounterType.CWC_ENCOUNTER_TYPE);
		}
		
		List<Encounter> encounters = dashboardService.getEncounter(patient, null, mchEncType, null);
		
		List<VisitSummary> visitSummaries = new ArrayList<VisitSummary>();
		
		int i = 0;
		
		for (Encounter enc : encounters) {
			VisitSummary visitSummary = new VisitSummary();
			visitSummary.setVisitDate(enc.getDateCreated());
			visitSummary.setEncounterId(enc.getEncounterId());
			Concept outcomeConcept = Context.getConceptService().getConcept("Visit outcome");
			for (Obs obs : enc.getAllObs()) {
				if (obs.getConcept().equals(outcomeConcept)) {
					visitSummary.setOutcome(obs.getValueText());
				}
			}
			visitSummaries.add(visitSummary);
			
			i++;
			
			if (i >= 20) {
				break;
			}
		}
		model.addAttribute("patient", patient);
		
		model.addAttribute("programSummaries", visitSummaries);
		// model.addAttribute("programSummaries", patientRegimens);
		// model.addAttribute("regimens", regimenTypes);
	}
	
	public SimpleObject getChemotherapyCycleDetails(@RequestParam("id") Integer cycleId, UiUtils ui) {
		List<PatientRegimen> chemoDetails;
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		
		//Fetch answers to the cancer disease status concept that mirror the HL7 coding for cancer disease status
		Concept cancerOutcomes = Context.getConceptService().getConceptByUuid(
		    EhrMchMetadata.ChemoTherapyConstants.CANCER_DISEASE_STATUS);
		Collection<ConceptAnswer> outcomesAnswers = cancerOutcomes.getAnswers();
		List<SimpleObject> outcomes = SimpleObject.fromCollection(outcomesAnswers, ui, "answerConcept.id",
		    "answerConcept.name");
		Cycle cycle = patientRegimenService.getCycleById(cycleId);
		
		if (cycle != null) {
			chemoDetails = patientRegimenService.getPatientRegimen(null, cycle, false);
			List<SimpleObject> drugs = SimpleObject.fromCollection(chemoDetails, ui, "id", "medication", "dose",
			    "dosingUnit", "route", "comment", "tag", "dispenseStatus");
			return SimpleObject.create("regimenName", cycle.getRegimenId().getRegimenType().getName(), "cycleName",
			    cycle.getName(), "cycleDrugs", drugs, "summaryNotes", cycle.getSummaryNotes(), "active", cycle.getActive(),
			    "dispenseStatus", cycle.getDispenseStatus() != null ? cycle.getDispenseStatus().getName().getName() : "",
			    "outcome", cycle.getOutcome() != null ? cycle.getOutcome().getName().getName() : "", "outcomes", outcomes);
		} else {
			return SimpleObject.create("success", false, "msg", "No cycle with requested ID");
		}
		
	}
	
	public SimpleObject fetchRegimenTypes(UiUtils ui) {
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		List<RegimenType> regimenTypes = patientRegimenService.getRegimenTypes(false);
		List<SimpleObject> types = SimpleObject.fromCollection(regimenTypes, ui, "id", "name", "cycles");
		return SimpleObject.create("regimenTypes", types);
	}
	
	public SimpleObject updatePatientRegimen(@RequestParam("regimenId") Integer regimenId, UiUtils ui) {
		
		List<PatientRegimen> chemoDetails = new ArrayList<PatientRegimen>();
		// TODO - Create these
		/*
		 * PatientRegimenService patientRegimenService =
		 * Context.getService(PatientRegimenService.class);
		 * //getRegimens takes a mandatory patient, and optional regimen type and tag
		 * List<PatientRegimen> patientRegimens =
		 * patientRegimenService.getRegimens(patient,regimen,tag,cycle);
		 *
		 */
		
		List<SimpleObject> drugs = SimpleObject.fromCollection(chemoDetails, ui, "id", "medication", "dose", "route",
		    "dosingUnit", "comment", "tag", "program");
		// return SimpleObject.create("chemoDetails", chemoDetails);
		return SimpleObject.create("drugs", drugs);
	}
	
	public SimpleObject createPatientRegimen(@RequestParam("patientId") Patient patient,
	        @RequestParam("regimenTypeId") Integer regimenTypeId, UiUtils ui) {
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		Regimen regimen = new Regimen();
		
		RegimenType regimenType = patientRegimenService.getRegimenTypeById(regimenTypeId);
		Set<DefaultRegimenMapping> regimenMappings = regimenType.getRegimenMappings();
		regimen.setPatient(patient);
		regimen.setRegimenType(regimenType);
		
		Cycle regimenCycle = new Cycle();
		regimenCycle.setName("Cycle 1 of " + regimenType.getCycles());
		regimenCycle.setActive(true);
		regimenCycle.setVoided(false);
		Set<PatientRegimen> patientRegimenSet = new HashSet<PatientRegimen>();
		
		//		Add default drugs to the cycle
		for (DefaultRegimenMapping drm : regimenMappings) {
			PatientRegimen patientRegimen = new PatientRegimen();
			patientRegimen.setMedication(drm.getMedication());
			patientRegimen.setDose(drm.getDose());
			patientRegimen.setDosingUnit(drm.getDosingUnit());
			patientRegimen.setRoute(drm.getRoute());
			patientRegimen.setTag(drm.getTag());
			patientRegimenSet.add(patientRegimen);
		}
		regimenCycle.setPatientRegimens(patientRegimenSet);
		Set<Cycle> cycles = new HashSet<Cycle>();
		cycles.add(regimenCycle);
		
		regimen.setCycles(cycles);
		
		Regimen createdRegimen = patientRegimenService.createRegimen(regimen);
		return SimpleObject.create("status", "success", "regimenId", createdRegimen.getId());
	}
	
	public SimpleObject createRegimenCycle(@RequestParam("regimenId") Integer regimenId, UiUtils ui) {
		
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		Regimen regimen = patientRegimenService.getRegimenById(regimenId);
		
		//		Check if there is an active cycle before adding a new one.
		for (Cycle c : regimen.getCycles()) {
			if (c.getActive()) {
				return SimpleObject.create("status", "fail", "message",
				    "Patient has an existing active cycle, administer drugs in the cycle and mark as closed!");
			}
		}
		
		//		For an initiation, automatically create a default cycle
		Cycle regimenCycle = new Cycle();
		regimenCycle.setName("Cycle " + (regimen.getCycles().size() + 1) + " of " + regimen.getRegimenType().getCycles());
		regimenCycle.setActive(true);
		regimenCycle.setVoided(false);
		
		//		Auto-populate previous cycle regimens if available
		if (regimen.getCycles().size() > 0) {
			//            Sort the set first
			List<Cycle> sortedCycles = new ArrayList<Cycle>(regimen.getCycles());
			Collections.sort(sortedCycles, new Comparator<Cycle>() {
				
				@Override
				public int compare(Cycle o1, Cycle o2) {
					return o2.getDateCreated().compareTo(o1.getDateCreated());
				}
			});
			//            Pull the topmost cycle
			Cycle latestCycle = sortedCycles.get(0);
			//            Copy previous drugs
			Set<PatientRegimen> patientRegimenSet = new HashSet<PatientRegimen>();
			for (PatientRegimen lcr : latestCycle.getPatientRegimens()) {
				PatientRegimen patientRegimen = new PatientRegimen();
				patientRegimen.setMedication(lcr.getMedication());
				patientRegimen.setDose(lcr.getDose());
				patientRegimen.setDosingUnit(lcr.getDosingUnit());
				patientRegimen.setRoute(lcr.getRoute());
				patientRegimen.setTag(lcr.getTag());
				patientRegimenSet.add(patientRegimen);
			}
			regimenCycle.setPatientRegimens(patientRegimenSet);
		}
		regimen.getCycles().add(regimenCycle);
		
		Regimen createdRegimen = patientRegimenService.updateRegimen(regimen);
		return SimpleObject.create("status", "success", "message", "Patient cycle created successfully");
	}
	
	public SimpleObject addCycleMedication(@RequestParam("cycleId") Integer cycleId,
	        @RequestParam(value = "drugId", required = false) Integer drugId, @RequestParam("drugName") String drugName,
	        @RequestParam("dosage") String dosage, @RequestParam("dosageUnit") String dosageUnit,
	        @RequestParam("route") Concept route, @RequestParam("tag") String tag, @RequestParam("comment") String comment,
	        UiUtils uiUtils) {
		
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		//		If drugId exists, then it is an update, otherwise, create a new entry
		PatientRegimen patientRegimen;
		if (drugId != null) {
			patientRegimen = patientRegimenService.getPatientRegimenById(drugId);
		} else {
			patientRegimen = new PatientRegimen();
		}
		
		Cycle cycle = patientRegimenService.getCycleById(cycleId);
		
		//TODO		Default dispense status of processed
		Concept dispenseConcept = Context.getConceptService().getConceptByUuid("167153AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		patientRegimen.setDispenseStatus(dispenseConcept);
		patientRegimen.setCycleId(cycle);
		patientRegimen.setComment(comment);
		patientRegimen.setTag(tag);
		patientRegimen.setRoute(route);
		patientRegimen.setDose(dosage);
		patientRegimen.setDosingUnit(dosageUnit);
		patientRegimen.setMedication(drugName);
		PatientRegimen createdPatientRegimen = patientRegimenService.createPatientRegimen(patientRegimen);
		cycle.getPatientRegimens().add(createdPatientRegimen);
		//Update display string for the patient regimen
		if (cycle.getActive()) {
			Set<PatientRegimen> patientRegimens = cycle.getPatientRegimens();
			StringBuilder csvBuilder = new StringBuilder();
			String SEPARATOR = "/";
			for (PatientRegimen pr : patientRegimens) {
				if (pr.getTag().equals("Chemotherapy") && !pr.getVoided()) {
					csvBuilder.append(pr.getMedication());
					csvBuilder.append(SEPARATOR);
				}
			}
			String csv = csvBuilder.toString();
			csv = csv.substring(0, csv.length() - SEPARATOR.length());
			Regimen cycleRegimen = cycle.getRegimenId();
			cycleRegimen.setDisplayString(csv);
			patientRegimenService.updateRegimen(cycleRegimen);
		}
		
		return SimpleObject.create("patientRegimen", SimpleObject.fromObject(createdPatientRegimen, uiUtils, "id",
		    "medication", "dosingUnit", "dose", "route", "comment", "tag"));
	}
	
	public SimpleObject deletePatientRegimen(@RequestParam("drugId") Integer drugId,
	        @RequestParam("comment") String comment, UiUtils ui) {
		
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		PatientRegimen patientRegimen = patientRegimenService.getPatientRegimenById(drugId);
		patientRegimen.setVoidReason(comment);
		patientRegimen.setDateVoided(new Date());
		
		patientRegimenService.voidPatientRegimen(patientRegimen);
		
		Cycle cycle = patientRegimen.getCycleId();
		
		//Update display string for the after deleting a line drug
		if (cycle.getActive()) {
			Set<PatientRegimen> patientRegimens = cycle.getPatientRegimens();
			StringBuilder csvBuilder = new StringBuilder();
			String SEPARATOR = "/";
			for (PatientRegimen pr : patientRegimens) {
				if (pr.getTag().equals("Chemotherapy") && !pr.getVoided()) {
					csvBuilder.append(pr.getMedication());
					csvBuilder.append(SEPARATOR);
				}
			}
			String csv = csvBuilder.toString();
			csv = csv.substring(0, csv.length() - SEPARATOR.length());
			Regimen cycleRegimen = cycle.getRegimenId();
			cycleRegimen.setDisplayString(csv);
			patientRegimenService.updateRegimen(cycleRegimen);
		}
		return SimpleObject.create("success", true, "id", drugId);
	}
	
	public SimpleObject updateRegimenCycle(@RequestParam("cycleId") Integer cycleId,
	        @RequestParam(value = "summaryNotes", required = false) String summaryNotes,
	        @RequestParam(value = "active", required = false) Boolean active,
	        @RequestParam(value = "outcome", required = false) Concept outcome,
	        @RequestParam(value = "dispenseStatus", required = false) Concept dispenseStatus, UiUtils ui) {
		
		InventoryCommonService patientRegimenService = Context.getService(InventoryCommonService.class);
		Cycle cycle = patientRegimenService.getCycleById(cycleId);
		
		if (!StringUtils.isEmpty(summaryNotes)) {
			cycle.setSummaryNotes(summaryNotes);
		}
		
		if (active != null) {
			cycle.setActive(active);
		}
		if (outcome != null) {
			cycle.setOutcome(outcome);
		}
		if (dispenseStatus != null) {
			cycle.setDispenseStatus(dispenseStatus);
		}
		
		patientRegimenService.updateCycle(cycle);
		return SimpleObject.create("success", true);
	}
	
}
