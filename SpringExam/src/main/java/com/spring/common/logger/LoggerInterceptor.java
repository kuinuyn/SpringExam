package com.spring.common.logger;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class LoggerInterceptor extends HandlerInterceptorAdapter{
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		super.afterConcurrentHandlingStarted(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		logger.debug("========================== LoggerInterceptor END ==========================");
		
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	@SuppressWarnings("unchecked")
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		logger.debug("========================== LoggerInterceptor START ==========================");
		logger.debug(" URI [{}], "+request.getRequestURI());
		
		Enumeration<String> paramNames = request.getParameterNames();
		String key = null;
		String value = null;
		while(paramNames.hasMoreElements()) {
			key = (String) paramNames.nextElement();
			value = request.getParameter(key);
			
			logger.debug(" RequestParameter Data ==> "+key+" : "+value);
		}
		
		return super.preHandle(request, response, handler);
	}
	
}
