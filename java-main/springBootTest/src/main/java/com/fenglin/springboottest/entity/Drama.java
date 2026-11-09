package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 剧集实体，对应表 {@code meiying_shenbu.drama}。
 *
 * <p>首页「热播探案」、剧集页、后台「剧集管理」都读写这一张表。
 * 字段与 {@code home_admin_init.sql} 一一对应。</p>
 */
@TableName("drama")
public class Drama {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 剧名 */
    private String title;

    /** 年份 */
    private Integer year;

    /** 题材，英文逗号分隔（悬疑,古装） */
    private String genres;

    /** 评分 0.0-10.0 */
    private BigDecimal score;

    /** 播放热度 */
    private Integer views;

    /** 总集数 */
    private Integer episodes;

    /** 角标：独播/热播/新案，空串表示无 */
    private String badge;

    /** 是否首页热播（1是 0否） */
    private Integer isHot;

    /** 海报图片地址 */
    private String poster;

    /** 海报调色偏移（hue-rotate 度数） */
    private Integer hueShift;

    /** 兜底渐变封面色相 */
    private Integer hue;

    /** 剧情简介 */
    private String synopsis;

    /** 上架状态（1上架 0下架） */
    private Integer status;

    @TableField(value = "created_at", insertStrategy = FieldStrategy.NEVER, updateStrategy = FieldStrategy.NEVER)
    private LocalDateTime createdAt;

    @TableField(value = "updated_at", insertStrategy = FieldStrategy.NEVER, updateStrategy = FieldStrategy.NEVER)
    private LocalDateTime updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getGenres() {
        return genres;
    }

    public void setGenres(String genres) {
        this.genres = genres;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public Integer getViews() {
        return views;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public Integer getEpisodes() {
        return episodes;
    }

    public void setEpisodes(Integer episodes) {
        this.episodes = episodes;
    }

    public String getBadge() {
        return badge;
    }

    public void setBadge(String badge) {
        this.badge = badge;
    }

    public Integer getIsHot() {
        return isHot;
    }

    public void setIsHot(Integer isHot) {
        this.isHot = isHot;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public Integer getHueShift() {
        return hueShift;
    }

    public void setHueShift(Integer hueShift) {
        this.hueShift = hueShift;
    }

    public Integer getHue() {
        return hue;
    }

    public void setHue(Integer hue) {
        this.hue = hue;
    }

    public String getSynopsis() {
        return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Drama{id=" + id + ", title='" + title + "'}";
    }
}
