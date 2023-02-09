package org.openmrs.module.treatmentapp;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.ProgramWorkflowService;
import org.openmrs.api.context.Context;
import org.openmrs.module.treatmentapp.api.TreatmentService;
import org.openmrs.test.BaseModuleContextSensitiveTest;

import java.util.Date;
import java.util.List;

import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

@Ignore
public class TreatmentServiceTest extends BaseModuleContextSensitiveTest {
	
	TreatmentService treatmentService;
	
	ProgramWorkflowService workflowService;
	
	@Before
	public void setUp() throws Exception {
		treatmentService = Context.getService(TreatmentService.class);
		workflowService = Context.getProgramWorkflowService();
	}
	
	@Test
	public void shouldEnrollPatientChemo() {
		Patient patient = new Patient();
		patient.setGender("M");
		patient.setBirthdate(new Date());
		
		/*patient = patientService.savePatient(patient);
		assertNotNull(patient.getId());*/
	}
	
	@Test
	public void testPatientEnrollment() {
		// Arrange
		Patient patient = createPatient();
		Program program = createProgram();
		
		// Act
		PatientProgram patientProgram = createPatientProgram(patient, program);
		
		// Assert
		assertEquals(patient, patientProgram.getPatient());
		assertEquals(program, patientProgram.getProgram());
	}
    @Test
    public void getAllUsers_shouldNotReturnNull() throws Exception {
        assertThat(Context.getUserService().getAllUsers(), notNullValue());
    }
	
	private PatientProgram createPatientProgram(Patient patient, Program program) {
		PatientProgram patientProgram = new PatientProgram();
		patientProgram.setPatient(patient);
		patientProgram.setProgram(program);
		patientProgram.setDateEnrolled(new Date());
		return Context.getProgramWorkflowService().savePatientProgram(patientProgram);
	}
	
	private Program createProgram() {
		Program program = new Program();
		program.setName("Chemo");
		program.setDescription("A program for managing chemo treatment");
		
		// Save the program to the database
		program = Context.getProgramWorkflowService().saveProgram(program);
		return program;
	}
	
	private Patient createPatient() {
		Patient patient = new Patient();
		patient.setGender("M");
		patient.setBirthdate(new Date());
		return patient;
	}
	
}
