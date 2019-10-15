package com.atguigu.atcrowdfunding.exception;


/**
 * 之所以继承RuntimeException，是因为，spring声明式事务，事务回滚策略：遇到运行期异常自动回滚。
 * @author Administrator
 *
 */
public class LoginException extends RuntimeException {

	public LoginException() {
		
	}
	
	public LoginException(String message) {
		super(message);
	}
}
