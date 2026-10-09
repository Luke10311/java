package com.meiying.shenbu.controller;

import com.meiying.shenbu.common.Result;
import com.meiying.shenbu.service.UserService;
import com.meiying.shenbu.util.JwtUtil;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    /** 注册接口 */
    @PostMapping("/register")
    public Result<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        Map<String, Object> r = userService.register(username, password);

        if (Boolean.TRUE.equals(r.get("ok"))) {
            return Result.ok((String) r.get("msg"), r);
        }
        return Result.fail((String) r.get("msg"));
    }

    /** 登录接口 */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        Map<String, Object> r = userService.login(username, password);

        if (Boolean.TRUE.equals(r.get("ok"))) {
            return Result.ok((String) r.get("msg"), r);
        }
        return Result.fail((String) r.get("msg"));
    }

    /** 会话校验接口：携带 Bearer token，返回当前用户名 */
    @GetMapping("/me")
    public Result<Map<String, Object>> me(@RequestHeader(value = "Authorization", required = false) String auth) {
        String token = null;
        if (auth != null && auth.startsWith("Bearer ")) {
            token = auth.substring(7);
        }
        String username = token == null ? null : JwtUtil.parse(token);
        if (username == null) {
            return Result.fail("令牌失效或已过期，请重新登城。");
        }
        Map<String, Object> data = new HashMap<>();
        data.put("username", username);
        return Result.ok("验讫。", data);
    }
}
