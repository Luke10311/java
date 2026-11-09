package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.service.DramaService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 前台剧集接口（无需登录），对接 {@code meiying-shenbu-vue/src/api/home.js}。
 *
 * <ul>
 *   <li>GET /api/drama/featured                  精选一案</li>
 *   <li>GET /api/drama/hot?category=悬疑          首页热播</li>
 *   <li>GET /api/drama/rank?limit=5               悬案榜</li>
 *   <li>GET /api/drama/list?genre=&year=&sort=&page=  剧集页列表</li>
 *   <li>GET /api/drama/{id}                       剧集详情</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/drama")
public class DramaApiController {

    private final DramaService dramaService;

    public DramaApiController(DramaService dramaService) {
        this.dramaService = dramaService;
    }

    @GetMapping("/featured")
    public Result<Map<String, Object>> featured() {
        return Result.ok("", dramaService.featured());
    }

    @GetMapping("/hot")
    public Result<List<Map<String, Object>>> hot(
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "8") int limit) {
        return Result.ok("", dramaService.hot(category, limit));
    }

    @GetMapping("/rank")
    public Result<List<Map<String, Object>>> rank(@RequestParam(defaultValue = "5") int limit) {
        return Result.ok("", dramaService.rank(limit));
    }

    @GetMapping("/list")
    public Result<Map<String, Object>> list(
            @RequestParam(required = false) String genre,
            @RequestParam(required = false) String year,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") long page,
            @RequestParam(defaultValue = "12") long size) {
        return Result.ok("", dramaService.list(genre, year, sort, keyword, page, size));
    }

    @GetMapping("/{id}")
    public Result<Map<String, Object>> detail(@PathVariable Long id) {
        Map<String, Object> data = dramaService.detail(id);
        if (data == null) {
            return Result.fail("未寻得此卷，许是被谁抽走了。");
        }
        return Result.ok("", data);
    }
}
