package com.spring.common.util;


import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.tags.EscapeBodyTag;

import com.spring.common.service.CommonTagService;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;


public class CommonCodeTag extends EscapeBodyTag {

	private static final long serialVersionUID = -4443092462400353496L;
	
	@Autowired
	private CommonTagService commonTagService;
	
	protected Object value; // tag attribute
	protected String var; // tag attribute
	
	@Override
	protected int doStartTagInternal() {
		// Dao 직접 연결
		WebApplicationContext webAppContext = getRequestContext().getWebApplicationContext();
		AutowireCapableBeanFactory autowireBeanFactory = webAppContext.getAutowireCapableBeanFactory();
		autowireBeanFactory.autowireBean(this);
		
		try {
			this.value = commonTagService.getCodeList();
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		return SKIP_BODY;
	}
	
	@Override
	public int doEndTag() throws JspException {
		Object result;
		
		if (value != null) {
			// ... reading our attribute
			result = JSONSerializer.toJSON(value);
		}
		else {
			try {
				// ... retrieving and trimming our body
				if (this.readBodyContent() == null)
					result = "";
				else
					result = this.readBodyContent().trim();
			} catch (Exception e) {
				result = "";
			}
		}
		
		if (var != null) {
			if (result != null) {
				pageContext.setAttribute(var, result, PageContext.REQUEST_SCOPE);
			}
		}
		
		return EVAL_PAGE;
	}
	
	// for tag attribute
	public void setVar(String var) {
		this.var = var;
	}
	
	// for tag attribute
	public void setValue(String var) {
		this.var = var;
	}

}
