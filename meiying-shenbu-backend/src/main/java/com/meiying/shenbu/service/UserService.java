package com.meiying.shenbu.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.meiying.shenbu.entity.User;
import com.meiying.shenbu.mapper.UserMapper;
import com.meiying.shenbu.util.JwtUtil;
import com.meiying.shenbu.util.PasswordUtil;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {

    private final UserMapper userMapper;

    public UserService(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    /**
     * 注册：用户名 2-16 位、密码至少 6 位、不可重名
     */
    public Map<String, Object> register(String username, String password) {
        Map<String, Object> result = new HashMap<>();
        if (username == null || username.trim().length() < 2 || username.trim().length() > 16) {
            result.put("ok", false);
            result.put("msg", "名号须为 2-16 位字符。");
            return result;
        }
        if (password == null || password.length() < 6) {
            result.put("ok", false);
            result.put("msg", "令牌至少需 6 位。");
            return result;
        }
        username = username.trim();

        Long count = userMapper.selectCount(
                new QueryWrapper<User>().eq("username", username));
        if (count != null && count > 0) {
            result.put("ok", false);
            result.put("msg", "此名号已入籍，请另择他名。");
            return result;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtil.hash(password));
        userMapper.insert(user);

        result.put("ok", true);
        result.put("msg", "入籍成功！");
        return result;
    }

    /**
     * 登录：校验用户名与密码
     */
    public Map<String, Object> login(String username, String password) {
        Map<String, Object> result = new HashMap<>();
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            result.put("ok", false);
            result.put("msg", "名号与令牌不可为空。");
            return result;
        }

        User user = userMapper.selectOne(
                new QueryWrapper<User>().eq("username", username.trim()));

        if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
            result.put("ok", false);
            result.put("msg", "名号或令牌有误，魅影惑人，请再核对。");
            return result;
        }

        result.put("ok", true);
        result.put("msg", "令牌验讫！");
        result.put("username", user.getUsername());
        result.put("token", JwtUtil.generate(user.getUsername()));
        return result;
    }
}
