package com.fenglin.springboottest.common;

/**
 * 业务异常：用于把「名号已存在」「密码错误」这类可预期的失败，
 * 从 Service 层干净地抛到全局异常处理器，统一转成 {@link Result#fail}。
 */
public class BizException extends RuntimeException {

    public BizException(String message) {
        super(message);
    }
}
