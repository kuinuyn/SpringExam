package com.spring.security;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import com.spring.security.service.CustomService;
import com.spring.security.vo.CustomVO;

public class CustomAuthenticationProvider implements AuthenticationProvider{
	@Resource(name = "CustomService")
	private CustomService customService;
	
	@SuppressWarnings("unused")
	@Autowired(required = false)
	private HttpServletRequest request;
	
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		
		String userId = (String) authentication.getPrincipal(); //아이디받기
		String userPw = (String) authentication.getCredentials(); //패스워드받기
		
		CustomVO vo = new CustomVO();
		vo.setUserId(userId);
		vo.setUserPw(userPw);
		vo.setName("네임");
		
		boolean loginChk = false;
		try {
			loginChk = customService.loginChk(vo);
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<GrantedAuthority> roles = new ArrayList<GrantedAuthority>();
		
		if(!loginChk) {
			return null;
		}
		else {
			roles.add(new SimpleGrantedAuthority("ROLE_USER"));
		}
		
		UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(userId, userPw, roles);
		result.setDetails(vo);
		
		return result;
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}
	
}
