package com.meiying.shenbu.common;

/**
 * 统一响应结构
 */
public class Result<T> {

    private int code;       // 200 成功；400 业务失败
    private String msg;
    private T data;

    public static <T> Result<T> ok(String msg, T data) {
        Result<T> r = new Result<>();
        r.code = 200;
        r.msg = msg;
        r.data = data;
        return r;
    }

    public static <T> Result<T> ok(String msg) {
        return ok(msg, null);
    }

    public static <T> Result<T> fail(String msg) {
        Result<T> r = new Result<>();
        r.code = 400;
        r.msg = msg;
        return r;
    }

    public int getCode() { return code; }
    public void setCode(int code) { this.code = code; }

    public String getMsg() { return msg; }
    public void setMsg(String msg) { this.msg = msg; }

    public T getData() { return data; }
    public void setData(T data) { this.data = data; }
}
