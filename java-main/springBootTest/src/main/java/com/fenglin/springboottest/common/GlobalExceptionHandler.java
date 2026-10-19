package com.fenglin.springboottest.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理：把异常统一翻译成前端认识的 {@code {code, msg, data}} 结构。
 *
 * <p>这样 Controller 里只写正常流程，不用满屏 try/catch。</p>
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /** 可预期的业务失败：直接把它的话术透给前端 */
    @ExceptionHandler(BizException.class)
    public Result<Void> handleBiz(BizException e) {
        log.warn("业务校验未通过：{}", e.getMessage());
        return Result.fail(e.getMessage());
    }

    /** 并发下撞到 username 唯一索引：语义等同「名号已存在」 */
    @ExceptionHandler(DuplicateKeyException.class)
    public Result<Void> handleDuplicateKey(DuplicateKeyException e) {
        log.warn("唯一索引冲突：{}", e.getMostSpecificCause().getMessage());
        return Result.fail("此名号已入籍，请另择他名。");
    }

    /** 兜底：避免把堆栈直接抛给浏览器 */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleOthers(Exception e) {
        log.error("服务端未预期的异常", e);
        return Result.fail("服务端开小差了，请稍后再试。");
    }
}
