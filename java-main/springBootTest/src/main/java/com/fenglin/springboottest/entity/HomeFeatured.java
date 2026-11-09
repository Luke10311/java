package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 首页「精选一案」实体，对应表 {@code meiying_shenbu.home_featured}。
 *
 * <p>前台首页第一屏的主视觉文案（副标题、推荐语、标签）与海报都取自这里。</p>
 */
@TableName("home_featured")
public class HomeFeatured {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 关联 drama.id */
    private Long dramaId;

    private String title;

    /** 副标题，如「第一案 · 灯市无头尸」 */
    private String sub;

    /** 推荐语 */
    private String description;

    /** 标签，逗号分隔 */
    private String tags;

    private BigDecimal score;

    private String badge;

    /** 海报地址 */
    private String poster;

    private Integer hue;

    private Integer sortOrder;

    /** 是否启用（1启用 0停用） */
    private Integer isActive;

    @TableField(value = "updated_at", insertStrategy = FieldStrategy.NEVER, updateStrategy = FieldStrategy.NEVER)
    private LocalDateTime updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getDramaId() {
        return dramaId;
    }

    public void setDramaId(Long dramaId) {
        this.dramaId = dramaId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSub() {
        return sub;
    }

    public void setSub(String sub) {
        this.sub = sub;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public String getBadge() {
        return badge;
    }

    public void setBadge(String badge) {
        this.badge = badge;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public Integer getHue() {
        return hue;
    }

    public void setHue(Integer hue) {
        this.hue = hue;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public Integer getIsActive() {
        return isActive;
    }

    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
