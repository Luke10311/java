package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.AdminUser;
import com.fenglin.springboottest.entity.CaseFile;
import com.fenglin.springboottest.entity.Drama;
import com.fenglin.springboottest.entity.SiteConfig;
import com.fenglin.springboottest.service.AdminService;
import com.fenglin.springboottest.service.CaseService;
import com.fenglin.springboottest.service.DramaService;
import com.fenglin.springboottest.util.JwtUtil;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台管理接口，对接 {@code meiying-shenbu-vue/src/api/admin.js}。
 *
 * <p>除登录外，所有接口都要求请求头 {@code Authorization: Bearer <token>}，
 * 令牌由 {@code POST /api/admin/login} 签发。</p>
 *
 * <ul>
 *   <li>POST   /api/admin/login               登录 → {username, realName, token}</li>
 *   <li>GET    /api/admin/me                  当前管理员</li>
 *   <li>GET    /api/admin/stats               控制台统计</li>
 *   <li>GET    /api/admin/drama               剧集分页</li>
 *   <li>POST   /api/admin/drama               新增/更新剧集</li>
 *   <li>DELETE /api/admin/drama/{id}          删除剧集</li>
 *   <li>GET    /api/admin/case                案卷分页</li>
 *   <li>POST   /api/admin/case                新增/更新案卷</li>
 *   <li>DELETE /api/admin/case/{id}           删除案卷</li>
 *   <li>GET    /api/admin/user                捕快分页</li>
 *   <li>DELETE /api/admin/user/{id}           注销捕快</li>
 *   <li>GET    /api/admin/config              站点配置</li>
 *   <li>POST   /api/admin/config              保存站点配置</li>
 *   <li>POST   /api/admin/password            修改自己的通行密钥</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/admin")
public class AdminApiController {

    private final AdminService adminService;
    private final DramaService dramaService;
    private final CaseService caseService;
    private final JwtUtil jwtUtil;

    public AdminApiController(AdminService adminService,
                              DramaService dramaService,
                              CaseService caseService,
                              JwtUtil jwtUtil) {
        this.adminService = adminService;
        this.dramaService = dramaService;
        this.caseService = caseService;
        this.jwtUtil = jwtUtil;
    }

    /** 管理员登录 */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        AdminUser admin = adminService.login(body.get("username"), body.get("password"));

        Map<String, Object> data = new HashMap<>();
        data.put("username", admin.getUsername());
        data.put("realName", admin.getRealName());
        data.put("token", jwtUtil.generate(admin.getUsername()));
        return Result.ok("中枢已解锁。", data);
    }

    /** 当前管理员信息 */
    @GetMapping("/me")
    public Result<Map<String, Object>> me(
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        AdminUser admin = adminService.requireAdmin(authorization);

        Map<String, Object> data = new HashMap<>();
        data.put("username", admin.getUsername());
        data.put("realName", admin.getRealName());
        data.put("lastLoginAt", admin.getLastLoginAt());
        return Result.ok("验讫。", data);
    }

    /** 控制台统计 */
    @GetMapping("/stats")
    public Result<Map<String, Object>> stats(
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        adminService.requireAdmin(authorization);
        return Result.ok("", adminService.stats());
    }

    /* ==================== 剧集管理 ==================== */

    @GetMapping("/drama")
    public Result<Map<String, Object>> pageDrama(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "10") long size) {
        adminService.requireAdmin(authorization);
        return Result.ok("", dramaService.page(keyword, genre, status, page, size));
    }

    @PostMapping("/drama")
    public Result<Drama> saveDrama(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody Drama drama) {
        adminService.requireAdmin(authorization);
        boolean isNew = drama.getId() == null;
        Drama saved = dramaService.save(drama);
        return Result.ok(isNew ? "新卷已入库。" : "卷宗已更新。", saved);
    }

    @DeleteMapping("/drama/{id}")
    public Result<Void> deleteDrama(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable Long id) {
        adminService.requireAdmin(authorization);
        dramaService.delete(id);
        return Result.ok("卷宗已销毁。");
    }

    /* ==================== 案卷管理 ==================== */

    @GetMapping("/case")
    public Result<Map<String, Object>> pageCase(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "10") long size) {
        adminService.requireAdmin(authorization);
        return Result.ok("", caseService.page(keyword, status, page, size));
    }

    @PostMapping("/case")
    public Result<CaseFile> saveCase(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody CaseFile caseFile) {
        adminService.requireAdmin(authorization);
        boolean isNew = caseFile.getId() == null;
        CaseFile saved = caseService.save(caseFile);
        return Result.ok(isNew ? "新案已立卷。" : "案卷已更新。", saved);
    }

    @DeleteMapping("/case/{id}")
    public Result<Void> deleteCase(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable Long id) {
        adminService.requireAdmin(authorization);
        caseService.delete(id);
        return Result.ok("案卷已撤下。");
    }

    /* ==================== 捕快管理 ==================== */

    @GetMapping("/user")
    public Result<Map<String, Object>> pageUser(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "10") long size) {
        adminService.requireAdmin(authorization);
        return Result.ok("", adminService.pageUsers(keyword, page, size));
    }

    @DeleteMapping("/user/{id}")
    public Result<Void> deleteUser(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable Long id) {
        adminService.requireAdmin(authorization);
        adminService.deleteUser(id);
        return Result.ok("该捕快已注销。");
    }

    /* ==================== 系统设置 ==================== */

    @GetMapping("/config")
    public Result<List<SiteConfig>> config(
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        adminService.requireAdmin(authorization);
        return Result.ok("", adminService.listConfig());
    }

    @PostMapping("/config")
    public Result<Void> saveConfig(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody Map<String, String> values) {
        adminService.requireAdmin(authorization);
        adminService.saveConfig(values);
        return Result.ok("配置已存档。");
    }

    @PostMapping("/password")
    public Result<Void> changePassword(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody Map<String, String> body) {
        adminService.changePassword(authorization, body.get("oldPassword"), body.get("newPassword"));
        return Result.ok("通行密钥已更换，请重新登录。");
    }
}
