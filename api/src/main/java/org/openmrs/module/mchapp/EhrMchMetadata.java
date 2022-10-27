package org.openmrs.module.mchapp;

import org.openmrs.api.context.Context;

public class EhrMchMetadata {
	
	public static final class _AncConstantConceptQuestions {
		
		public static final String PARITY = "1053AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String GRAVIDA = "5624AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String LAST_MENSTRUAL_PERIOD = "1427AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	}
	
	//reached here for concept uuid confirmation
	public static final class _VistTypes {
		
		public static final String FACILITY_VISIT = "66a4ef36-fac4-11ea-bcbf-375d20d55603"; //aligned
		
		public static final String INITIAL_MCH_CLINIC_VISIT = "76583758-fac4-11ea-b5f3-d340ddbbb0d2"; //aligned
		
		public static final String RETURN_ANC_CLINIC_VISIT = "8462eab4-fac4-11ea-a965-338aef2ca794"; //aligned
		
		public static final String RETURN_PNC_CLINIC_VISIT = "94e337ea-fac4-11ea-be33-0736112d65ec"; //aligned
		
		public static final String RETURN_CWC_CLINIC_VISIT = "a6329004-fac4-11ea-babb-7b8345fde680"; //aligned
	}
	
	public static final class MchAppConstants {
		
		public static final String ANC_DEWORMING = "159922AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String ANC_LLITN = "160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String PNC_CERVICAL_SCREENING_METHOD = "163589AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String PNC_CERVICAL_SCREENING_RESULT = "23bee3ab-f241-4e56-8d92-1116dc6b516a"; //not found
		
		public static final String PNC_FAMILY_PLANNING = "374AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_LLITN = "160428AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_DEWORMED = "159922AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String FAMILY_PLANNING_CLINIC_CONCEPT_UUID = "374AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_CHILD_COMPLETED_IMMUNIZATION = "164134AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_FOLLOW_UP = "162207AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_BREASTFEEDING_COUNCELLING = "1910AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_BREASTFEEDING_EXCLUSSIVE = "5526AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_BREASTFEEDING_FOR_INFECTED = "1151AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String CWC_VITAMIN_A_SUPPLEMENTATION = "c1346a48-9777-428f-a908-e8bff24e4e37";// to be created(100126235)
		
		public static final String CWC_SUPPLEMENTED_WITH_MNP = "534705aa-8857-4e70-9b08-b363fb3ce677";// to be created(100126237)
		
		public static final String CWC_EXAMINATION_CLASS = "8d491a9a-c2cc-11de-8d13-0010c6dffd0f";
		
		public static final String CWC_EXAMINATION_DATATYPE = "8d4a48b6-c2cc-11de-8d13-0010c6dffd0f";
		
		public static final String MCH_HIV_PRIOR_STATUS = "1169AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";//1169 to be checked
		
		public static final String MCH_HIV_PARTNER_TESTED = "161557AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String MCH_HIV_PARTNER_STATUS = "1436AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; //1436
		
		public static final String PNC_EXCERCISE = "151321AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; //place holder
		
		public static final String PNC_MULTIVITAMIN = "5712097d-a478-4ff4-a2aa-bd827a6833ed"; //place holder
		
		public static final String PNC_VITAMIN_A = "86339AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String PNC_HAEMATINICS = "461AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; // holder for PNC_HAEMATINICS
		
		public static final String ANC_FEEDING_COUNCELLING = "161651AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String ANC_FEEDING_EXCLUSSIVE = "161096AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String ANC_FEEDING_INFECTED = "162522AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String ANC_FEEDING_DECISION = "a0bf86bb-b50e-4be4-a54c-32518bfb843f";
		
		public static final String ANC_EXCERCISE = "0a92efcc-51b3-448d-b4e3-a743ea5aa18c";
		
	}
	
	public static final class MchAppTriageConstants {
		
		public static final String PULSE_RATE = "5087AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String HEIGHT = "5090AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String WEIGHT = "5089AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String SYSTOLIC = "5085AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String DAISTOLIC = "5086AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String TEMPERATURE = "5088AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String MUAC = "160908AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; //160908
		
		public static final String GROWTH_STATUS = "112937AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; //holder for 100126186
		
		public static final String WEIGHT_CATEGORY = "1854AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
	}
	
	public static final class _MchEncounterType {
		
		public static final String ANC_ENCOUNTER_TYPE = "ae378f6e-f292-11ea-8ef8-0bb1ae4b7f42";
		
		public static final String ANC_TRIAGE_ENCOUNTER_TYPE = "25dbb7d0-fac6-11ea-94e8-0bd56324f4b5";
		
		public static final String PNC_ENCOUNTER_TYPE = "cbe0212a-f292-11ea-affa-2b398f67bbb4";
		
		public static final String PNC_TRIAGE_ENCOUNTER_TYPE = "fcaec384-fac5-11ea-8aeb-fffc453fcc77";
		
		public static final String CWC_ENCOUNTER_TYPE = "09073c56-fac6-11ea-87aa-bfe01fd142fd";
		
		public static final String CWC_TRIAGE_ENCOUNTER_TYPE = "150932f2-fac6-11ea-b158-4b1b80bfe51c";
	}
	
	public static final class _MchProgram {
		
		public static final String ANC_PROGRAM = "e8751e5c-fbda-11ea-9bba-ff7e8cea17d3";
		
		public static final String PNC_PROGRAM = "23edfbca-fbdb-11ea-a675-17377ca3079e"; //1623
		
		public static final String ANTENATAL_VISIT_NUMBER = "1425AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		//public static final Integer INITIAL_MCH_CLINIC_VISIT = 2;
		
		//		public static final Integer RETURN_ANC_CLINIC_VISIT = 3;
		//
		//		public static final Integer RETURN_PNC_CLINIC_VISIT = 4;
		//
		//		public static final Integer RETURN_CWC_CLINIC_VISIT = 5;
		
		/*CWC PROGRAM, WORKFLOW AND STATE CONCEPTS*/
		public static final String CWC_PROGRAM = "645d7e4c-fbdb-11ea-911a-5fe00fc87a47"; //MCWC
		
		public static final String PNC_DELIVERY_MODES = "5630AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		public static final String MCH_WEIGHT_CATEGORIES = "1854AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
		
		//temporary
		public static final String MCH_GROWTH_MONITOR = "fb577873-ea93-49f9-a3e7-82ae5035bbd2";
	}
	
	public static int getFaclityVisitTypeId() {
		return Context.getVisitService().getVisitTypeByUuid(_VistTypes.FACILITY_VISIT).getVisitTypeId();
	}
	
	public static int getInitialMCHClinicVisitTypeId() {
		return Context.getVisitService().getVisitTypeByUuid(_VistTypes.INITIAL_MCH_CLINIC_VISIT).getVisitTypeId();
	}
	
	public static int getReturnAncClinicVisitTypeId() {
		return Context.getVisitService().getVisitTypeByUuid(_VistTypes.RETURN_ANC_CLINIC_VISIT).getVisitTypeId();
	}
	
	public static int getReturnPncClinicVisitTypeId() {
		return Context.getVisitService().getVisitTypeByUuid(_VistTypes.RETURN_PNC_CLINIC_VISIT).getVisitTypeId();
	}
	
	public static int getReturnCwcClinicVisitTypeId() {
		return Context.getVisitService().getVisitTypeByUuid(_VistTypes.RETURN_CWC_CLINIC_VISIT).getVisitTypeId();
	}
	
}
