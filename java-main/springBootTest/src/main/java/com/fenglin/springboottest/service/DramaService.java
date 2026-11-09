package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.common.BizException;
import com.fenglin.springboottest.entity.Drama;
import com.fenglin.springboottest.entity.HomeFeatured;
import com.fenglin.springboottest.mapper.DramaMapper;
import com.fenglin.springboottest.mapper.HomeFeaturedMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 剧集业务：后台增删改查 + 前台首页 / 剧集页 / 详情页读取。
 *
 * <p>前台返回的结构与 {@code meiying-shenbu-vue/src/data/dramas.js} 保持一致，
 * 这样视图层换成接口时一行都不用改（genres 仍然是数组，hot 仍然是布尔）。</p>
 */
@Service
public class DramaService {

    private final DramaMapper dramaMapper;
    private final HomeFeaturedMapper featuredMapper;

    public DramaService(DramaMapper dramaMapper, HomeFeaturedMapper featuredMapper) {
        this.dramaMapper = dramaMapper;
        this.featuredMapper = featuredMapper;
    }

    /* ==================== 后台：增删改查 ==================== */

    /** 后台列表分页：支持按剧名搜索、按题材/上下架筛选 */
    public Map<String, Object> page(String keyword, String genre, Integer status, long pageNo, long size) {
        long current = Math.max(1, pageNo);
        long pageSize = Math.min(Math.max(1, size), 100);
        long total = dramaMapper.selectCount(adminQuery(keyword, genre, status));
        long pages = total == 0 ? 0 : (total + pageSize - 1) / pageSize;
        long offset = (current - 1) * pageSize;

        List<Drama> rows = total == 0 ? List.of() : dramaMapper.selectList(
                adminQuery(keyword, genre, status).last("LIMIT " + pageSize + " OFFSET " + offset));

        Map<String, Object> data = new HashMap<>();
        data.put("page", current);
        data.put("totalPages", pages);
        data.put("total", total);
        data.put("items", rows);
        return data;
    }

    /** 新增或更新；id 为空走新增 */
    @Transactional(rollbackFor = Exception.class)
    public Drama save(Drama drama) {
        if (drama == null) {
            throw new BizException("没有收到剧集内容。");
        }
        String title = drama.getTitle() == null ? "" : drama.getTitle().trim();
        if (title.isEmpty()) {
            throw new BizException("剧名不可为空。");
        }
        if (title.length() > 64) {
            throw new BizException("剧名最多 64 个字。");
        }
        drama.setTitle(title);

        if (drama.getScore() != null
                && (drama.getScore().compareTo(BigDecimal.ZERO) < 0
                || drama.getScore().compareTo(BigDecimal.TEN) > 0)) {
            throw new BizException("评分需在 0 到 10 之间。");
        }

        if (drama.getId() == null) {
            applyDefaults(drama);
            dramaMapper.insert(drama);
        } else {
            if (dramaMapper.selectById(drama.getId()) == null) {
                throw new BizException("此卷已不存在，可能已被他人删除。");
            }
            dramaMapper.updateById(drama);
        }
        return dramaMapper.selectById(drama.getId());
    }

    /** 删除剧集 */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        if (id == null) {
            throw new BizException("缺少要删除的剧集编号。");
        }
        if (dramaMapper.selectById(id) == null) {
            throw new BizException("此卷已不存在。");
        }
        dramaMapper.deleteById(id);
    }

    /* ==================== 前台：首页 / 列表 / 详情 ==================== */

    /** 首页「精选一案」 */
    public Map<String, Object> featured() {
        HomeFeatured f = featuredMapper.selectOne(
                Wrappers.<HomeFeatured>lambdaQuery()
                        .eq(HomeFeatured::getIsActive, 1)
                        .orderByAsc(HomeFeatured::getSortOrder)
                        .last("LIMIT 1"));
        if (f == null) {
            // 没配精选就退回评分最高的一部，首页不至于空着
            List<Drama> top = dramaMapper.selectList(Wrappers.<Drama>lambdaQuery()
                    .eq(Drama::getStatus, 1)
                    .orderByDesc(Drama::getScore)
                    .last("LIMIT 1"));
            return top.isEmpty() ? null : toView(top.get(0));
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", f.getDramaId() == null ? f.getId() : f.getDramaId());
        data.put("title", f.getTitle());
        data.put("sub", f.getSub());
        data.put("desc", f.getDescription());
        data.put("tags", splitGenres(f.getTags()));
        data.put("score", f.getScore());
        data.put("badge", f.getBadge());
        data.put("poster", f.getPoster());
        data.put("hue", f.getHue() == null ? 212 : f.getHue());
        return data;
    }

    /** 首页热播：只取已上架的热播剧，可按题材筛 */
    public List<Map<String, Object>> hot(String category, int limit) {
        LambdaQueryWrapper<Drama> qw = Wrappers.<Drama>lambdaQuery()
                .eq(Drama::getStatus, 1)
                .eq(Drama::getIsHot, 1)
                .like(category != null && !category.isBlank() && !"全部".equals(category),
                        Drama::getGenres, category == null ? "" : category.trim())
                .orderByDesc(Drama::getScore)
                .last("LIMIT " + Math.min(Math.max(1, limit), 50));
        return dramaMapper.selectList(qw).stream().map(this::toView).toList();
    }

    /** 悬案榜：按播放热度倒序 */
    public List<Map<String, Object>> rank(int limit) {
        List<Drama> list = dramaMapper.selectList(Wrappers.<Drama>lambdaQuery()
                .eq(Drama::getStatus, 1)
                .orderByDesc(Drama::getViews)
                .last("LIMIT " + Math.min(Math.max(1, limit), 50)));

        return list.stream().map(d -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", d.getId());
            m.put("title", d.getTitle());
            m.put("heat", String.format("%.1f 万", (d.getViews() == null ? 0 : d.getViews()) / 10000.0));
            m.put("trend", "flat");
            m.put("score", d.getScore());
            m.put("year", d.getYear());
            m.put("episodes", d.getEpisodes());
            m.put("genres", splitGenres(d.getGenres()));
            m.put("poster", d.getPoster());
            m.put("hue", d.getHue());
            return m;
        }).toList();
    }

    /** 剧集页列表：筛选 + 排序 + 分页 */
    public Map<String, Object> list(String genre, String year, String sort, String keyword,
                                    long pageNo, long size) {
        long current = Math.max(1, pageNo);
        long pageSize = Math.min(Math.max(1, size), 60);
        long total = dramaMapper.selectCount(publicQuery(genre, year, sort, keyword));
        long pages = total == 0 ? 0 : (total + pageSize - 1) / pageSize;
        long offset = (current - 1) * pageSize;

        List<Drama> rows = total == 0 ? List.of() : dramaMapper.selectList(
                publicQuery(genre, year, sort, keyword)
                        .last("LIMIT " + pageSize + " OFFSET " + offset));

        Map<String, Object> data = new HashMap<>();
        data.put("page", current);
        data.put("totalPages", Math.max(1, pages));
        data.put("total", total);
        data.put("items", rows.stream().map(this::toView).toList());
        return data;
    }

    /** 详情：剧集本体 + 简介（演职人员 / 分集仍由前端按题材生成） */
    public Map<String, Object> detail(Long id) {
        Drama d = id == null ? null : dramaMapper.selectById(id);
        if (d == null || (d.getStatus() != null && d.getStatus() == 0)) {
            return null;
        }
        return toView(d);
    }

    /* ==================== 内部工具 ==================== */

    /** 后台列表查询条件（每次新建，避免 count 与 select 复用同一个 wrapper） */
    private LambdaQueryWrapper<Drama> adminQuery(String keyword, String genre, Integer status) {
        return Wrappers.<Drama>lambdaQuery()
                .like(keyword != null && !keyword.isBlank(), Drama::getTitle,
                        keyword == null ? "" : keyword.trim())
                .like(genre != null && !genre.isBlank(), Drama::getGenres,
                        genre == null ? "" : genre.trim())
                .eq(status != null, Drama::getStatus, status)
                .orderByDesc(Drama::getIsHot)
                .orderByDesc(Drama::getScore)
                .orderByAsc(Drama::getId);
    }

    /** 前台列表查询条件 */
    private LambdaQueryWrapper<Drama> publicQuery(String genre, String year, String sort, String keyword) {
        Integer yearValue = (year == null || year.isBlank() || "all".equals(year)) ? null : parseYear(year);

        LambdaQueryWrapper<Drama> qw = Wrappers.<Drama>lambdaQuery()
                .eq(Drama::getStatus, 1)
                .like(genre != null && !genre.isBlank() && !"全部".equals(genre),
                        Drama::getGenres, genre == null ? "" : genre.trim())
                .eq(yearValue != null, Drama::getYear, yearValue)
                .like(keyword != null && !keyword.isBlank(), Drama::getTitle,
                        keyword == null ? "" : keyword.trim());

        switch (sort == null ? "default" : sort) {
            case "score" -> qw.orderByDesc(Drama::getScore);
            case "views" -> qw.orderByDesc(Drama::getViews);
            case "year" -> qw.orderByDesc(Drama::getYear).orderByDesc(Drama::getScore);
            default -> qw.orderByDesc(Drama::getIsHot).orderByDesc(Drama::getScore);
        }
        return qw;
    }

    private void applyDefaults(Drama d) {
        if (d.getYear() == null) {
            d.setYear(2026);
        }
        if (d.getGenres() == null || d.getGenres().isBlank()) {
            d.setGenres("悬疑");
        }
        if (d.getScore() == null) {
            d.setScore(BigDecimal.ZERO);
        }
        if (d.getViews() == null) {
            d.setViews(0);
        }
        if (d.getEpisodes() == null || d.getEpisodes() < 1) {
            d.setEpisodes(1);
        }
        if (d.getBadge() == null) {
            d.setBadge("");
        }
        if (d.getIsHot() == null) {
            d.setIsHot(0);
        }
        if (d.getPoster() == null) {
            d.setPoster("");
        }
        if (d.getHueShift() == null) {
            d.setHueShift(0);
        }
        if (d.getHue() == null) {
            d.setHue(212);
        }
        if (d.getStatus() == null) {
            d.setStatus(1);
        }
    }

    private Integer parseYear(String year) {
        try {
            return Integer.parseInt(year.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<String> splitGenres(String genres) {
        if (genres == null || genres.isBlank()) {
            return List.of();
        }
        return Arrays.stream(genres.split("[,，]"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }

    /** 实体 → 前端认识的字段名（genres 数组、hot 布尔） */
    private Map<String, Object> toView(Drama d) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", d.getId());
        m.put("title", d.getTitle());
        m.put("year", d.getYear());
        m.put("genres", splitGenres(d.getGenres()));
        m.put("score", d.getScore());
        m.put("views", d.getViews());
        m.put("episodes", d.getEpisodes());
        m.put("badge", d.getBadge());
        m.put("hot", d.getIsHot() != null && d.getIsHot() == 1);
        m.put("poster", d.getPoster());
        m.put("hueShift", d.getHueShift());
        m.put("hue", d.getHue());
        m.put("synopsis", d.getSynopsis());
        m.put("status", d.getStatus());
        return m;
    }
}
