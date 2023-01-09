package org.openmrs.module.treatmentapp.web.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.webservices.rest.SimpleObject;
import org.openmrs.module.webservices.rest.web.v1_0.controller.BaseRestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.openmrs.module.webservices.rest.web.RestConstants;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

@Controller
@RequestMapping(value = "/rest/" + RestConstants.VERSION_1 + "/pharmacyrequest")
public class PharmacyRequestsController extends BaseRestController {
	
	@RequestMapping(method = RequestMethod.GET)
	@ResponseBody
	public Object get(WebRequest request) {
		return new SimpleObject().add("sessionId", request.getSessionId()).add("authenticated", Context.isAuthenticated());
	}
	
	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	public Object post(WebRequest request) {
		return new SimpleObject().add("sessionId", request.getSessionId()).add("authenticated", Context.isAuthenticated());
	}
	
}
