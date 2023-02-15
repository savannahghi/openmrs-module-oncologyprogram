package org.openmrs.module.treatmentapp.page.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
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

import java.util.*;

public class MainPageController {
	
	private static final int MAX_ANC_PNC_DURATION = 9;
	
	protected Logger logger = LoggerFactory.getLogger(getClass());
	
	/**
	 * @param patient
	 * @param queueId
	 * @param focusProgram
	 * @param model
	 * @param config
	 * @param uiUtils
	 * @return
	 */
	public String get(@RequestParam("patientId") Patient patient, @RequestParam(value = "queueId") Integer queueId,
	        @RequestParam(value = "focusProgram", required = false) String focusProgram, PageModel model,
	        FragmentConfiguration config, UiUtils uiUtils) {
		
		InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
		List<Regimen> regimens = inventoryCommonService.getRegimens(patient, null, false);
		
		List<SimpleObject> chemoProfile = new ArrayList<SimpleObject>();
		for (Regimen regimen : regimens) {
			SimpleObject profileInfo = new SimpleObject();
			profileInfo.put("regimenId", regimen.getId());
			profileInfo.put("name", regimen.getRegimenType().getName());
			profileInfo.put("displayString", regimen.getDisplayString());
			profileInfo.put("icon", "icon-hospital");
			profileInfo.put("cycles",
			    SimpleObject.fromCollection(regimen.getCycles(), uiUtils, "id", "name", "icon", "active", "summaryNotes"));
			chemoProfile.add(profileInfo);
		}
		
		String details = SimpleObject.create("drugs", chemoProfile).toJson();
		
		model.addAttribute("mflCode",
		    Context.getAdministrationService().getGlobalProperty(EhrMchMetadata.ChemoTherapyConstants.MFL_CODE));
		model.addAttribute("openhimUrl",
		    Context.getAdministrationService().getGlobalProperty(EhrMchMetadata.ChemoTherapyConstants.OPENHIM_URL));
		
		//model.addAttribute("NUPI","Get patient NUPI); // Could this be the same as the patient OpenMRS id? - No
		
		//Process National ID and NUPI
		PatientIdentifier nationalId = patient.getPatientIdentifier(EhrMchMetadata.ChemoTherapyConstants.NATIONAL_ID_STRING);
		PatientIdentifier nupi = patient.getPatientIdentifier(EhrMchMetadata.ChemoTherapyConstants.NUPI_STRING);
		model.addAttribute("idNumber", nationalId);
		model.addAttribute("nupi", nupi);
		
		//Process patient additional attributes
		model.addAttribute("maritalStatus", patient.getAttribute(5)); // 68 ??
		model.addAttribute("phoneNumber", patient.getAttribute(8));
		model.addAttribute("nokContact", patient.getAttribute(9)); //71 or 9 or 86 ???
		model.addAttribute("nokRelationship", patient.getAttribute(10));
		model.addAttribute("nokName", patient.getAttribute(12));
		model.addAttribute("idNumber", patient.getAttribute(13));
		model.addAttribute("alternatePhone", patient.getAttribute(16));
		model.addAttribute("nhifNumber", patient.getAttribute(74));
		//TODO fetch correct investigations
		model.addAttribute("investigations","investigations");
		
		//		TODO Process latest observations
		
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
		if (!StringUtils.isEmpty(focusProgram)) {
			model.addAttribute("focusProgram", focusProgram);
		} else {
			if (enrolledInChemo) {
				model.addAttribute("focusProgram", "Chemotherapy");
			} else if (enrolledInSurgery) {
				model.addAttribute("focusProgram", "Procedure/Surgery");
			} else if (enrolledInRadio) {
				model.addAttribute("focusProgram", "Radiotherapy");
			}
		}
		
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
			return "redirect:" + uiUtils.pageLink("treatmentapp", "enroll") + "?patientId=" + patient.getPatientId()
			        + "&queueId=" + queueId;
		}
		
		List<PatientProgram> patientPrograms = Context.getProgramWorkflowService().getPatientPrograms(patient, program,
		    minEnrollmentDate.getTime(), null, null, null, false);
		
		//handles case when patient is yet to enroll in a patient program
		PatientProgram patientProgram = null;
		if (patientPrograms.size() > 0) {
			patientProgram = patientPrograms.get(0);
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
		model.addAttribute("patientCategory", patient.getAttribute(56));
		//model.addAttribute("serviceOrderSize", serviceOrderList.size());
		model.addAttribute("patientId", patient.getPatientId());
		model.addAttribute("date", new Date());
		//  TODO add other patients attributes
		return null;
	}

    public List<SimpleObject> getInvestigationResults(
            @RequestParam("patientId") Integer patientId,
            @RequestParam("orderId") Integer orderId,
            UiUtils ui
    ){
        Patient patient = Context.getPatientService().getPatient(patientId);
        Order labOrder = Context.getOrderService().getOrder(orderId);

        Map<String, String> sortedResults = new TreeMap<String, String>();
        List<SimpleObject> results = new ArrayList<SimpleObject>();
        if (labOrder.getEncounter() != null) {
            for (Obs obs : labOrder.getEncounter().getAllObs()) {
                if (obs.hasGroupMembers()) {
                    continue;
                }
                String resultDescription = obs.getConcept().getDisplayString();
                if (obs.getObsGroup() != null) {
                    resultDescription = obs.getObsGroup().getConcept().getDisplayString() + " (" + resultDescription + ")";
                }
                String resultValue = obs.getValueAsString(Context.getLocale()) +" :-->"+obs.getComment();
                sortedResults.put(resultDescription, resultValue);
            }
        }
        if (sortedResults.size() == 0) {
            String nameOfLabEncounterType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_LAB_ENCOUTNER_TYPE);
            EncounterType labEncounterType = Context.getEncounterService().getEncounterTypeByUuid("11d3f37a-f282-11ea-a825-1b5b1ff1b854");
            List<Encounter> labOrdersEncounters = Context.getEncounterService().getEncounters(patient, null, null, null, null, Arrays.asList(labEncounterType), null, null, null, false);
            Date datePerfomed = null;
            for (Encounter encounter: labOrdersEncounters) {
                for (Obs obs : encounter.getAllObs()) {
                    if (!obs.getOrder().getOrderId().equals(orderId)) {
                        continue;
                    } else if (obs.getOrder() == null) {
                        continue;
                    }
                    String resultDescription = obs.getConcept().getDisplayString();
                    if (obs.getObsGroup() != null) {
                        resultDescription = obs.getObsGroup().getConcept().getDisplayString() + " (" + resultDescription + ")";
                    }
                    String resultValue = obs.getValueAsString(Context.getLocale()) +":-->"+obs.getComment();
                    sortedResults.put(resultDescription, resultValue);
                    if (datePerfomed == null) {
                        datePerfomed = obs.getObsDatetime();
                    }
                }
            }
            for (Map.Entry<String, String> result : sortedResults.entrySet()) {
                results.add(SimpleObject.create("label", result.getKey(), "value", result.getValue(), "datePerfomed", ui.formatDatePretty(datePerfomed)));
            }
        }
        return results;
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
