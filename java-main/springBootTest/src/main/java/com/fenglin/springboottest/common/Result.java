package com.fenglin.springboottest.common;

import java.io.Serializable;

/**
 * 统一响应结构，与前端约定一致：
 * <pre>
 * { "code": 200 | 400, "msg": "提示文案", "data": {...} | null }
 * </pre>
 * 前端只认 code === 200 为成功（见 meiying-shenbu-vue/src/store/users.js）。
 *
 * @param <T> 业务数据类型
 */
public class Result<T> implements Serializable {

    /** 200 成功；400 业务失败 */
    private int code;
    private String msg;
    private T data;

    public Result() {
    }

    public Result(int code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public static <T> Result<T> ok(String msg, T data) {
        return new Result<>(200, msg, data);
    }

    public static <T> Result<T> ok(String msg) {
        return ok(msg, null);
    }

    public static <T> Result<T> fail(String msg) {
        return new Result<>(400, msg, null);
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
