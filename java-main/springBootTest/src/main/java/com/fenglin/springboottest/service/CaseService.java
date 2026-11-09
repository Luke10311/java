package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.common.BizException;
import com.fenglin.springboottest.entity.CaseFile;
import com.fenglin.springboottest.mapper.CaseFileMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 案卷业务：后台增删改查 + 前台案件区块。
 *
 * <p>字段名与 {@code meiying-shenbu-vue/src/data/cases.js} 对齐，
 * 前端换成接口时视图层不用改。</p>
 */
@Service
public class CaseService {

    private final CaseFileMapper caseFileMapper;

    public CaseService(CaseFileMapper caseFileMapper) {
        this.caseFileMapper = caseFileMapper;
    }

    /** 后台分页：按案名搜索、按状态筛选 */
    public Map<String, Object> page(String keyword, String status, long pageNo, long size) {
        long current = Math.max(1, pageNo);
        long pageSize = Math.min(Math.max(1, size), 100);
        long total = caseFileMapper.selectCount(query(keyword, status));
        long pages = total == 0 ? 0 : (total + pageSize - 1) / pageSize;
        long offset = (current - 1) * pageSize;

        List<CaseFile> rows = total == 0 ? List.of() : caseFileMapper.selectList(
                query(keyword, status).last("LIMIT " + pageSize + " OFFSET " + offset));

        Map<String, Object> data = new HashMap<>();
        data.put("page", current);
        data.put("totalPages", pages);
        data.put("total", total);
        data.put("items", rows);
        return data;
    }

    /** 列表条件（每次新建，count / select 各用一份） */
    private LambdaQueryWrapper<CaseFile> query(String keyword, String status) {
        return Wrappers.<CaseFile>lambdaQuery()
                .like(keyword != null && !keyword.isBlank(), CaseFile::getTitle,
                        keyword == null ? "" : keyword.trim())
                .eq(status != null && !status.isBlank() && !"全部".equals(status),
                        CaseFile::getStatus, status)
                .orderByDesc(CaseFile::getId);
    }

    /** 新增或更新 */
    @Transactional(rollbackFor = Exception.class)
    public CaseFile save(CaseFile c) {
        if (c == null) {
            throw new BizException("没有收到案卷内容。");
        }
        String title = c.getTitle() == null ? "" : c.getTitle().trim();
        if (title.isEmpty()) {
            throw new BizException("案名不可为空。");
        }
        c.setTitle(title);

        if (c.getStatus() == null || c.getStatus().isBlank()) {
            c.setStatus("缉查中");
        }
        if (c.getIsActive() == null) {
            c.setIsActive(1);
        }

        if (c.getId() == null) {
            caseFileMapper.insert(c);
        } else {
            if (caseFileMapper.selectById(c.getId()) == null) {
                throw new BizException("此卷已不存在，可能已被他人删除。");
            }
            caseFileMapper.updateById(c);
        }
        return caseFileMapper.selectById(c.getId());
    }

    /** 删除案卷 */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        if (id == null) {
            throw new BizException("缺少要删除的案卷编号。");
        }
        if (caseFileMapper.selectById(id) == null) {
            throw new BizException("此卷已不存在。");
        }
        caseFileMapper.deleteById(id);
    }

    /** 前台首页案件区块：取最新若干卷 */
    public List<CaseFile> latest(int limit) {
        return caseFileMapper.selectList(Wrappers.<CaseFile>lambdaQuery()
                .eq(CaseFile::getIsActive, 1)
                .orderByDesc(CaseFile::getId)
                .last("LIMIT " + Math.min(Math.max(1, limit), 20)));
    }

    /** 前台案卷详情 */
    public CaseFile detail(Long id) {
        CaseFile c = id == null ? null : caseFileMapper.selectById(id);
        if (c == null || (c.getIsActive() != null && c.getIsActive() == 0)) {
            return null;
        }
        return c;
    }
}
