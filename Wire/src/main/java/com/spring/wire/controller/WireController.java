package com.spring.wire.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@Component
public class WireController {
	
	@RequestMapping(value="/wire.do", method= {RequestMethod.GET})
	public String wire(HttpServletRequest req) {
		
		return "wire";
		 
	}
}
	
