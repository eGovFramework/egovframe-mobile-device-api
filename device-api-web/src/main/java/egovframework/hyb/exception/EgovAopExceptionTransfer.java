package egovframework.hyb.exception;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.egovframe.rte.fdl.cmmn.aspect.ExceptionTransfer;
import org.egovframe.rte.fdl.cmmn.exception.BaseRuntimeException;

@Aspect
public class EgovAopExceptionTransfer {

	private ExceptionTransfer exceptionTransfer;

	public void setExceptionTransfer(ExceptionTransfer exceptionTransfer) {
		this.exceptionTransfer = exceptionTransfer;
	}

	@Pointcut("execution(* egovframework.hyb..impl.*Impl.*(..))")
	private void exceptionTransferService() {}

	@AfterThrowing(pointcut="exceptionTransferService()", throwing="ex")
	public void doAfterThrowingExceptionTransferService(JoinPoint thisJoinPoint, Exception ex) throws BaseRuntimeException, Exception {
		exceptionTransfer.transfer(thisJoinPoint, ex);
	}

}
