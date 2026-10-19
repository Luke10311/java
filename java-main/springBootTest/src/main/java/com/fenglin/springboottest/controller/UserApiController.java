package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.BizException;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.UserService;
import com.fenglin.springboottest.util.JwtUtil;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 给 Vue 前端调用的用户接口。
 *
 * <p>对接 {@code meiying-shenbu-vue/src/store/users.js}，约定如下：</p>
 * <ul>
 *   <li>{@code POST /api/user/register}  body: {username, password}</li>
 *   <li>{@code POST /api/user/login}     body: {username, password} → data: {username, token}</li>
 *   <li>{@code GET  /api/user/me}        header: Authorization: Bearer &lt;token&gt; → data: {username}</li>
 * </ul>
 * 三者统一返回 {@code {code, msg, data}}。
 */
@RestController
@RequestMapping("/api/user")
public class UserApiController {

    private static final String BEARER_PREFIX = "Bearer ";

    private final UserService userService;
    private final JwtUtil jwtUtil;

    public UserApiController(UserService userService, JwtUtil jwtUtil) {
        this.userService = userService;
        this.jwtUtil = jwtUtil;
    }

    /** 注册 */
    @PostMapping("/register")
    public Result<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        User user = userService.register(body.get("username"), body.get("password"));

        Map<String, Object> data = new HashMap<>();
        data.put("username", user.getUsername());
        return Result.ok("入籍成功！", data);
    }

    /** 登录：校验通过后签发 JWT */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        User user = userService.login(body.get("username"), body.get("password"));

        Map<String, Object> data = new HashMap<>();
        data.put("username", user.getUsername());
        data.put("token", jwtUtil.generate(user.getUsername()));
        return Result.ok("令牌验讫！", data);
    }

    /** 会话校验：携带 Bearer token，返回当前用户名 */
    @GetMapping("/me")
    public Result<Map<String, Object>> me(
            @RequestHeader(value = "Authorization", required = false) String authorization) {

        String token = null;
        if (authorization != null && authorization.startsWith(BEARER_PREFIX)) {
            token = authorization.substring(BEARER_PREFIX.length());
        }
        String username = jwtUtil.parseUsername(token);
        if (username == null) {
            throw new BizException("令牌失效或已过期，请重新登城。");
        }

        Map<String, Object> data = new HashMap<>();
        data.put("username", username);
        return Result.ok("验讫。", data);
    }
}
