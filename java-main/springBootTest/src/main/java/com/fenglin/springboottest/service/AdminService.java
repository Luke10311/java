package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.BizException;
import com.fenglin.springboottest.entity.AdminUser;
import com.fenglin.springboottest.entity.CaseFile;
import com.fenglin.springboottest.entity.Drama;
import com.fenglin.springboottest.entity.SiteConfig;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.AdminUserMapper;
import com.fenglin.springboottest.mapper.CaseFileMapper;
import com.fenglin.springboottest.mapper.DramaMapper;
import com.fenglin.springboottest.mapper.SiteConfigMapper;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.util.JwtUtil;
import com.fenglin.springboottest.util.PasswordUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台管理业务：管理员登录 / 会话校验 / 捕快账号 / 站点配置 / 控制台统计。
 *
 * <p>管理端所有写操作都要先过 {@link #requireAdmin(String)}，
 * 令牌无效直接抛 {@link BizException}，由全局异常处理器转成 400。</p>
 */
@Service
public class AdminService {

    private static final String BEARER_PREFIX = "Bearer ";
    private static final int PASSWORD_MIN = 6;

    private final AdminUserMapper adminUserMapper;
    private final UserMapper userMapper;
    private final SiteConfigMapper siteConfigMapper;
    private final DramaMapper dramaMapper;
    private final CaseFileMapper caseFileMapper;
    private final JwtUtil jwtUtil;

    public AdminService(AdminUserMapper adminUserMapper,
                        UserMapper userMapper,
                        SiteConfigMapper siteConfigMapper,
                        DramaMapper dramaMapper,
                        CaseFileMapper caseFileMapper,
                        JwtUtil jwtUtil) {
        this.adminUserMapper = adminUserMapper;
        this.userMapper = userMapper;
        this.siteConfigMapper = siteConfigMapper;
        this.dramaMapper = dramaMapper;
        this.caseFileMapper = caseFileMapper;
        this.jwtUtil = jwtUtil;
    }

    /**
     * 管理员登录：校验账号与散列口令，成功后刷新最近登录时间。
     *
     * @throws BizException 账号或口令为空、账号不存在、口令不匹配
     */
    public AdminUser login(String username, String password) {
        String name = username == null ? "" : username.trim();
        if (name.isEmpty() || password == null || password.isEmpty()) {
            throw new BizException("管理员账号与通行密钥不可为空。");
        }
        AdminUser admin = adminUserMapper.selectOne(
                Wrappers.<AdminUser>lambdaQuery().eq(AdminUser::getUsername, name));
        if (admin == null || !PasswordUtil.matches(password, admin.getPassword())) {
            throw new BizException("管理员账号或通行密钥有误。");
        }

        LocalDateTime now = LocalDateTime.now();
        AdminUser patch = new AdminUser();
        patch.setId(admin.getId());
        patch.setLastLoginAt(now);
        adminUserMapper.updateById(patch);
        admin.setLastLoginAt(now);
        return admin;
    }

    /**
     * 解析 Authorization 头并确认管理员仍然存在。
     *
     * @throws BizException 未带令牌、令牌失效或账号已被删除
     */
    public AdminUser requireAdmin(String authorization) {
        String token = null;
        if (authorization != null && authorization.startsWith(BEARER_PREFIX)) {
            token = authorization.substring(BEARER_PREFIX.length());
        }
        String username = jwtUtil.parseUsername(token);
        if (username == null) {
            throw new BizException("管理员会话已失效，请重新登录中枢。");
        }
        AdminUser admin = adminUserMapper.selectOne(
                Wrappers.<AdminUser>lambdaQuery().eq(AdminUser::getUsername, username));
        if (admin == null) {
            throw new BizException("管理员会话已失效，请重新登录中枢。");
        }
        return admin;
    }

    /** 捕快账号分页（不返回口令散列） */
    public Map<String, Object> pageUsers(String keyword, long pageNo, long size) {
        long current = Math.max(1, pageNo);
        long pageSize = Math.min(Math.max(1, size), 100);
        long total = userMapper.selectCount(userQuery(keyword));
        long pages = total == 0 ? 0 : (total + pageSize - 1) / pageSize;
        long offset = (current - 1) * pageSize;

        List<User> rows = total == 0 ? List.of() : userMapper.selectList(
                userQuery(keyword).last("LIMIT " + pageSize + " OFFSET " + offset));

        List<Map<String, Object>> items = rows.stream().map(u -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", u.getId());
            m.put("username", u.getUsername());
            m.put("createdAt", u.getCreatedAt());
            return m;
        }).toList();

        Map<String, Object> data = new HashMap<>();
        data.put("page", current);
        data.put("totalPages", pages);
        data.put("total", total);
        data.put("items", items);
        return data;
    }

    /** 捕快列表条件（每次新建，count / select 各用一份） */
    private com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<User> userQuery(String keyword) {
        return Wrappers.<User>lambdaQuery()
                .like(keyword != null && !keyword.isBlank(), User::getUsername,
                        keyword == null ? "" : keyword.trim())
                .orderByDesc(User::getId);
    }

    /** 注销捕快账号 */
    @Transactional(rollbackFor = Exception.class)
    public void deleteUser(Long id) {
        if (id == null) {
            throw new BizException("缺少要注销的账号。");
        }
        User exists = userMapper.selectById(id);
        if (exists == null) {
            throw new BizException("该捕快已不在册。");
        }
        userMapper.deleteById(id);
    }

    /** 修改当前管理员通行密钥 */
    @Transactional(rollbackFor = Exception.class)
    public void changePassword(String authorization, String oldPassword, String newPassword) {
        AdminUser admin = requireAdmin(authorization);
        if (!PasswordUtil.matches(oldPassword, admin.getPassword())) {
            throw new BizException("原通行密钥不正确。");
        }
        if (newPassword == null || newPassword.length() < PASSWORD_MIN) {
            throw new BizException("新密钥至少需 " + PASSWORD_MIN + " 位。");
        }
        AdminUser patch = new AdminUser();
        patch.setId(admin.getId());
        patch.setPassword(PasswordUtil.hash(newPassword));
        adminUserMapper.updateById(patch);
    }

    /** 站点配置全量（按配置键排序，后台表单直接用） */
    public List<SiteConfig> listConfig() {
        return siteConfigMapper.selectList(
                Wrappers.<SiteConfig>lambdaQuery().orderByAsc(SiteConfig::getConfigKey));
    }

    /** 批量保存站点配置：只更新已存在的键，未知键忽略 */
    @Transactional(rollbackFor = Exception.class)
    public void saveConfig(Map<String, String> values) {
        if (values == null || values.isEmpty()) {
            throw new BizException("没有要保存的配置项。");
        }
        values.forEach((key, value) -> {
            if (key == null || key.isBlank()) {
                return;
            }
            SiteConfig exists = siteConfigMapper.selectById(key);
            if (exists == null) {
                return;
            }
            SiteConfig patch = new SiteConfig();
            patch.setConfigKey(key);
            patch.setConfigValue(value);
            siteConfigMapper.updateById(patch);
        });
    }

    /**
     * 控制台统计：剧集 / 案卷 / 捕快数量与总热度。
     * 卡片和「最近入库」列表都从这里出，不再写死。
     */
    public Map<String, Object> stats() {
        long dramaCount = dramaMapper.selectCount(null);
        long hotCount = dramaMapper.selectCount(Wrappers.<Drama>lambdaQuery().eq(Drama::getIsHot, 1));
        long onlineCount = dramaMapper.selectCount(Wrappers.<Drama>lambdaQuery().eq(Drama::getStatus, 1));
        long caseCount = caseFileMapper.selectCount(null);
        long caseOpen = caseFileMapper.selectCount(Wrappers.<CaseFile>lambdaQuery().eq(CaseFile::getStatus, "缉查中"));
        long userCount = userMapper.selectCount(null);
        long adminCount = adminUserMapper.selectCount(null);

        long totalViews = 0L;
        List<Object> sum = dramaMapper.selectObjs(
                Wrappers.<Drama>query().select("IFNULL(SUM(views), 0)"));
        if (!sum.isEmpty() && sum.get(0) != null) {
            totalViews = ((Number) sum.get(0)).longValue();
        }

        List<Map<String, Object>> recent = dramaMapper.selectList(
                        Wrappers.<Drama>lambdaQuery().orderByDesc(Drama::getId).last("LIMIT 5"))
                .stream().map(d -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", d.getId());
                    m.put("title", d.getTitle());
                    m.put("poster", d.getPoster());
                    m.put("score", d.getScore());
                    m.put("status", d.getStatus());
                    return m;
                }).toList();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("dramaCount", dramaCount);
        data.put("hotCount", hotCount);
        data.put("onlineCount", onlineCount);
        data.put("caseCount", caseCount);
        data.put("caseOpen", caseOpen);
        data.put("userCount", userCount);
        data.put("adminCount", adminCount);
        data.put("totalViews", totalViews);
        data.put("recent", recent);
        return data;
    }
}
