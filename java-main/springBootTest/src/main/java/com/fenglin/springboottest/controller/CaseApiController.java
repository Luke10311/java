package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.CaseFile;
import com.fenglin.springboottest.service.CaseService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 前台案卷接口（无需登录），对接 {@code meiying-shenbu-vue/src/data/cases.js} 的调用方。
 *
 * <ul>
 *   <li>GET /api/case/latest?limit=6  首页案件区块</li>
 *   <li>GET /api/case/{id}            案卷详情</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/case")
public class CaseApiController {

    private final CaseService caseService;

    public CaseApiController(CaseService caseService) {
        this.caseService = caseService;
    }

    @GetMapping("/latest")
    public Result<List<CaseFile>> latest(@RequestParam(defaultValue = "6") int limit) {
        return Result.ok("", caseService.latest(limit));
    }

    @GetMapping("/{id}")
    public Result<CaseFile> detail(@PathVariable Long id) {
        CaseFile c = caseService.detail(id);
        if (c == null) {
            return Result.fail("此案卷未公开或已撤下。");
        }
        return Result.ok("", c);
    }
}
