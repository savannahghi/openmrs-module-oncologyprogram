package org.openmrs.module.treatmentapp.web.controller;

import org.json.JSONArray;
import org.json.JSONObject;
import org.openmrs.api.context.Context;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.v1_0.controller.BaseRestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

@Controller
@RequestMapping(value = "/rest/" + RestConstants.VERSION_1 + "/pharmacyresponse")
public class PharmacyRequestsController extends BaseRestController {

    @RequestMapping(method = RequestMethod.GET)
    @ResponseBody
    public Object get(WebRequest request) {
        return new SimpleObject().add("sessionId", request.getSessionId()).add("authenticated", Context.isAuthenticated());
    }

    @RequestMapping(method = RequestMethod.POST)
    @ResponseBody
    public Object post(@RequestBody String body, WebRequest request) {
        JSONObject jsonObject = new JSONObject(body);
        JSONArray medications = jsonObject.getJSONArray("medications");
        SimpleObject returnObject = new SimpleObject();
        returnObject.add("success", true);
        //		TODO process individual medications
        for (int i = 0; i < medications.length(); i++) {
            JSONObject medicationObject = medications.getJSONObject(i);
            int medicationId = medicationObject.getInt("id");
            String dispenseStatus = medicationObject.getString("dispenseStatus");
            String comment = medicationObject.getString("comment");
            String dose = medicationObject.getString("dose");
            String dosingUnit = medicationObject.getString("dosingUnit");

            returnObject.add("message", updateMedicationStatus(medicationId, dispenseStatus, comment, dose, dosingUnit));
        }

        return returnObject;
    }


    private String updateMedicationStatus(int medicationId, String dispenseStatus, String comment, String dose, String dosingUnit) {
//		TODO - Perform the actual updates
        return "Update successful for drug  ==> " + medicationId;
    }


}
