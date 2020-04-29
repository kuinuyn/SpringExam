package com.spring.exam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value="/sample")
public class SampleController {
	
	@RequestMapping(value="/getSample")
	public void getSampleRequest(HttpServletRequest request, HttpServletResponse response ) {
		
	}
}
