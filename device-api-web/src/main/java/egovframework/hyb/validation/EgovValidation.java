package egovframework.hyb.validation;

import org.springframework.util.ObjectUtils;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class EgovValidation implements ConstraintValidator<EgovNotNull, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return !ObjectUtils.isEmpty(value);
    }

}
