package com.spring.common.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtils {
	private Properties properties;

	public PropertiesUtils() {
		properties = new Properties();
	}

	public Properties getProperties() {
		return properties;
	}
	
	public void loadProp(String path) throws IOException {
		InputStream inputStream = getClass().getResourceAsStream(path);
		properties.load(inputStream);
		inputStream.close();
	}
	
	public static Properties loadPropForStatic(String path) throws IOException {
		Properties properties = new Properties();
		InputStream inputStream = PropertiesUtils.class.getClassLoader().getResourceAsStream(path);
		properties.load(inputStream);
		inputStream.close();
		return properties;
	}
	
	public static void main(String[] args) throws IOException{
		PropertiesUtils propertiesUtils = new PropertiesUtils();
		
		propertiesUtils.loadProp("/properties/app_config.properties");
		Properties properties = propertiesUtils.getProperties();
		properties.list(System.out);
		
		System.out.println(properties.get("file.upload.path"));
		
		// 아래 코드는 새로운 프로퍼티 파일에 같은 키를 준 경우 오버라이드 하는 것을 확인합니다.
        Properties staticProp = PropertiesUtils.loadPropForStatic("properties/application-prod.properties");
        properties.putAll(staticProp);
        properties = propertiesUtils.getProperties();
        properties.list(System.out);
	}
}
