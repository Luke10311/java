package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.common.BizException;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.util.PasswordUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户业务：注册与登录。
 *
 * <p>校验不通过或凭据错误时抛 {@link BizException}，由全局异常处理器
 * 统一包装成 {@code {code:400, msg:...}} 返回给前端。</p>
 */
@Service
public class UserService {

    /** 名号长度限制，与前端 RegisterForm.vue 的校验保持一致 */
    private static final int USERNAME_MIN = 2;
    private static final int USERNAME_MAX = 16;
    /** 密码长度限制，与前端保持一致 */
    private static final int PASSWORD_MIN = 6;

    private final UserMapper userMapper;

    public UserService(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    /**
     * 注册新用户。
     *
     * @return 落库后的用户对象
     * @throws BizException 名号格式不合法、密码过短或名号已被占用
     */
    @Transactional(rollbackFor = Exception.class)
    public User register(String username, String password) {
        String name = username == null ? "" : username.trim();

        if (name.length() < USERNAME_MIN || name.length() > USERNAME_MAX) {
            throw new BizException("名号须为 " + USERNAME_MIN + "-" + USERNAME_MAX + " 位字符。");
        }
        if (password == null || password.length() < PASSWORD_MIN) {
            throw new BizException("令牌至少需 " + PASSWORD_MIN + " 位。");
        }

        Long exists = userMapper.selectCount(
                Wrappers.<User>lambdaQuery().eq(User::getUsername, name));
        if (exists != null && exists > 0) {
            throw new BizException("此名号已入籍，请另择他名。");
        }

        User user = new User();
        user.setUsername(name);
        user.setPassword(PasswordUtil.hash(password));
        userMapper.insert(user);
        return user;
    }

    /**
     * 登录校验。
     *
     * @return 校验通过的用户对象
     * @throws BizException 名号或令牌为空、用户不存在、密码不匹配
     */
    public User login(String username, String password) {
        String name = username == null ? "" : username.trim();

        if (name.isEmpty() || password == null || password.isEmpty()) {
            throw new BizException("名号与令牌不可为空。");
        }

        User user = userMapper.selectOne(
                Wrappers.<User>lambdaQuery().eq(User::getUsername, name));

        if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
            throw new BizException("名号或令牌有误，魅影惑人，请再核对。");
        }
        return user;
    }
}
