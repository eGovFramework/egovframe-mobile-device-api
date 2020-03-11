package egovframework.com.cmm.service;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EgovProperties {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovProperties.class);
	public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource("").getPath().substring(0, EgovProperties.class.getResource("").getPath().lastIndexOf("com"));
	public static final String GLOBALS_PROPERTIES_FILE = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + "globals.properties";

	public static String getPathProperty(String keyName) {
		LOGGER.debug("##### EgovProperties getPathProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);
		String value = "";
		FileInputStream fis = null;
		try {
			Properties props = new Properties();
			fis = new FileInputStream(filePathBlackList(GLOBALS_PROPERTIES_FILE));
			props.load(new BufferedInputStream(fis));
			value = props.getProperty(keyName);
			value = (value == null) ? "" : value.trim();
			value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + value;
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("##### EgovProperties getPathProperty file not found.", fnfe);
			throw new RuntimeException("EgovProperties file not found", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("##### EgovProperties getPathProperty file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException e) {
					LOGGER.debug("##### EgovProperties getPathProperty finally file IO exception", e);
				}
			}
		}

		return value;
	}

	public static String getProperty(String keyName) {
		LOGGER.debug("##### EgovProperties getProperty : {} = {}", GLOBALS_PROPERTIES_FILE, keyName);
		String value = "";
		FileInputStream fis = null;
		try {
			Properties props = new Properties();
			fis = new FileInputStream(filePathBlackList(GLOBALS_PROPERTIES_FILE));
			props.load(new BufferedInputStream(fis));
			if (props.getProperty(keyName) == null) {
				return "";
			}
			value = props.getProperty(keyName).trim();
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("##### EgovProperties getProperty file not found.", fnfe);
			throw new RuntimeException("EgovProperties file not found", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("##### EgovProperties getProperty file IO exception", ioe);
			throw new RuntimeException("Property file IO exception", ioe);
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException e) {
					LOGGER.debug("##### EgovProperties getProperty finally file IO exception", e);
				}
			}
		}
		return value;
	}

	public static String filePathBlackList(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}
		returnValue = returnValue.replaceAll("\\.\\.", "");
		return returnValue;
	}

}
